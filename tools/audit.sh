#!/usr/bin/env bash
# audit.sh - list every public web deployment of the configured owners, check that
# it is live and lint its HTML against the doctrine (DOCTRINE.md).
# Usage: tools/audit.sh [--out FILE] [--no-lint] [--quiet]
# Needs: gh (authenticated; GH_TOKEN in CI), jq, curl. Public repositories only.
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
out="$root/audit/deployments.json"
lint=1 quiet=0
while (($#)); do
  case $1 in
    --out) out=$2; shift 2 ;;
    --no-lint) lint=0; shift ;;
    --quiet) quiet=1; shift ;;
    -h|--help) sed -n '2,5p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "audit: unknown option: $1" >&2; exit 2 ;;
  esac
done
for c in gh jq curl; do command -v "$c" >/dev/null || { echo "audit: missing $c" >&2; exit 1; }; done
say(){ ((quiet)) || printf '%s\n' "$*" >&2; }

tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
owners=$(grep -v '^\s*#' "$root/audit/owners.conf" | awk 'NF{print $1}')

# 1. candidate repos: Pages enabled, a <owner>.github.io repo, or a homepage URL
for o in $owners; do
  kind=$(gh api "users/$o" --jq .type 2>/dev/null || echo none)
  case $kind in
    Organization) path="orgs/$o/repos?type=public&per_page=100" ;;
    User) path="users/$o/repos?type=owner&per_page=100" ;;
    *) say "audit: skip $o (not found)"; continue ;;
  esac
  # forks count only when their homepage is ours (szmelc domain or the owner's github.io)
  # shellcheck disable=SC2016  # $o is a jq variable
  gh api --paginate "$path" --jq '.[]|select(.private|not)
    |select((.fork|not) or (.owner.login as $o|(.homepage//"")|test("szmelc|//"+$o+"\\.github\\.io";"i")))
    |select(.has_pages or (.name|test("\\.github\\.io$";"i")) or ((.homepage//"")|test("^https?://")))
    |{repo:.full_name,owner:.owner.login,name:.name,has_pages:.has_pages,archived:.archived,
      homepage:(.homepage//""),pushed:(.pushed_at[:10]),description:(.description//"")}' \
    >> "$tmp/repos.jsonl" 2>/dev/null || say "audit: cannot list $o"
done
[[ -s $tmp/repos.jsonl ]] || { echo "audit: no repositories found" >&2; exit 1; }

# 2. extra URLs that no repo setting points at (szmelc.com routes and similar)
grep -v '^\s*#' "$root/audit/extra-urls.tsv" 2>/dev/null | awk -F'\t' 'NF>=2' |
  jq -R -c 'split("\t")|{repo:"",owner:"",name:.[0],has_pages:false,archived:false,homepage:.[1],pushed:"",description:(.[2]//"")}' \
  >> "$tmp/repos.jsonl"

# hue (0-360) and saturation (0-1) of a #rrggbb color, printed as "h s"
hue(){ awk -v h="$1" 'function x(c){return index("0123456789abcdef",tolower(c))-1}
  BEGIN{r=(x(substr(h,2,1))*16+x(substr(h,3,1)))/255;g=(x(substr(h,4,1))*16+x(substr(h,5,1)))/255;b=(x(substr(h,6,1))*16+x(substr(h,7,1)))/255
  mx=r;if(g>mx)mx=g;if(b>mx)mx=b;mn=r;if(g<mn)mn=g;if(b<mn)mn=b;d=mx-mn;if(d==0){print 0,0;exit}
  if(mx==r)H=60*(((g-b)/d)%6);else if(mx==g)H=60*((b-r)/d+2);else H=60*((r-g)/d+4);if(H<0)H+=360
  l=(mx+mn)/2;s=d/(1-(2*l-1<0?-(2*l-1):2*l-1));printf "%d %.2f\n",H,s}'; }

# lint flags for one page: $1 = the HTML plus linked CSS (structure checks),
# $2 = CSS only (<style> blocks, style="" attributes, linked sheets) for colors and radius,
# so hex values quoted in page text or data blocks never count
lint_html(){
  local f=$1 css=$2; local -a hits=()
  grep -qiE 'fonts\.googleapis|fonts\.gstatic|use\.typekit|fonts\.bunny' "$f" && hits+=(webfont)
  grep -qiE 'cdn\.tailwindcss|tailwind(\.min)?\.css|bootstrap(\.min)?\.css|bulma(\.min)?\.css' "$f" && hits+=(framework)
  grep -qiE 'googletagmanager|google-analytics|plausible\.io|umami|hotjar|clarity\.ms' "$f" && hits+=(tracker)
  { grep -qiE 'border-radius:\s*([5-9]|[1-9][0-9]+)px|border-radius:\s*[0-9.]+(r?em)' "$css" ||
    grep -qiE 'class="[^"]*rounded-(full|xl|2xl|lg)' "$f"; } && hits+=(round)
  grep -qiE 'prefers-color-scheme|data-theme|color-scheme' "$f" || hits+=(no-theme)
  local c h s purple=0
  for c in $(grep -oiE '#[0-9a-f]{6}\b' "$css" | tr '[:upper:]' '[:lower:]' | sort -u | head -200); do
    read -r h s < <(hue "$c")
    if (( h >= 255 && h <= 320 )) && awk -v s="$s" 'BEGIN{exit !(s>=0.35)}'; then purple=1; break; fi
  done
  ((purple)) && hits+=(purple)
  printf '%s\n' "${hits[@]}" | jq -R . | jq -s -c 'map(select(length>0))'
}

# 3. resolve the URL, check it, lint it, read the last deployment
: > "$tmp/out.jsonl"
while IFS= read -r row; do
  repo=$(jq -r .repo <<<"$row"); owner=$(jq -r .owner <<<"$row"); name=$(jq -r .name <<<"$row")
  home=$(jq -r .homepage <<<"$row"); pages=$(jq -r .has_pages <<<"$row")
  lo=$(tr '[:upper:]' '[:lower:]' <<<"$owner")
  url=""
  if [[ $pages == true ]]; then
    if [[ ${name,,} == "$lo.github.io" ]]; then url="https://$lo.github.io/"; else url="https://$lo.github.io/$name/"; fi
  fi
  site="$home"; [[ $site =~ ^https://github\.com/ ]] && site=""
  [[ -z $url ]] && url=$site
  [[ -z $url ]] && continue
  grep -qxF "$url" "$tmp/seen" 2>/dev/null && continue
  echo "$url" >> "$tmp/seen"
  code=$(curl -s -L -o "$tmp/page.html" -w '%{http_code}' --max-time 20 "$url") || true
  [[ $code =~ ^[0-9]{3}$ ]] || code=000
  flags='[]'
  if ((lint)) && [[ $code == 200 ]]; then
    # CSS only: inline <style> blocks and style="" attributes, then same-origin stylesheets
    awk 'BEGIN{IGNORECASE=1} /<style/{s=1} s{print} /<\/style>/{s=0}' "$tmp/page.html" > "$tmp/style.css"
    grep -oiE 'style="[^"]*"' "$tmp/page.html" >> "$tmp/style.css" || true
    base=$(sed -E 's#^(https?://[^/]+).*#\1#' <<<"$url")
    for css in $(grep -oiE '<link[^>]+rel="?stylesheet"?[^>]*>' "$tmp/page.html" | grep -oiE 'href="[^"]+"' | cut -d'"' -f2 | head -6); do
      case $css in
        http*) [[ $css == "$base"* ]] || continue; u=$css ;;
        /*) u="$base$css" ;;
        *) u="${url%/*}/$css" ;;
      esac
      curl -s -L --max-time 15 "$u" >> "$tmp/style.css" || true
    done
    cat "$tmp/style.css" >> "$tmp/page.html"
    flags=$(lint_html "$tmp/page.html" "$tmp/style.css")
  fi
  dep='{}'
  if [[ -n $repo ]]; then
    dep=$(gh api "repos/$repo/deployments?per_page=1" --jq '.[0]//{}|{env:(.environment//""),at:((.created_at//"")[:10])}' 2>/dev/null || echo '{}')
  fi
  jq -c --arg url "$url" --arg code "$code" --argjson flags "$flags" --argjson dep "$dep" \
    '. + {url:$url,http:($code|tonumber),flags:$flags,deploy:$dep}' <<<"$row" >> "$tmp/out.jsonl"
  say "$code  $url  $(jq -r 'join(",")' <<<"$flags")"
done < <(jq -c -s 'sort_by(.has_pages|not)[]' "$tmp/repos.jsonl")   # the hosting repo wins a shared URL

# 4. merge the hand-kept registry (surface, archetype, migration notes)
reg="$root/audit/registry.tsv"
jq -R -s -c 'split("\n")|map(select(length>0 and (startswith("#")|not))|split("\t")
  |{key:.[0],value:{surface:.[1],archetype:.[2],flavor:.[3],notes:(.[4]//"")}})|from_entries' "$reg" > "$tmp/reg.json"
mkdir -p "$(dirname "$out")"
jq -s --slurpfile reg "$tmp/reg.json" --arg at "$(date -u +%F)" '
  {generated:$at, sites:(map(. + ($reg[0][(if .repo=="" then .name else .repo end)] // {surface:"",archetype:"",flavor:"",notes:""}))
  |sort_by((if .http!=200 then 0 elif (.surface|test("project|panel|legacy")) and (.flags|length)>0 then 1
            elif (.surface|test("skin|external")) then 3 else 2 end), .url))}' "$tmp/out.jsonl" > "$out"
say "audit: $(jq '.sites|length' "$out") sites -> ${out#"$root"/}"
