#!/usr/bin/env bash
# check.sh - doctrine checks for this repo. No network. Exit 1 on the first class of failure, after listing all hits.
set -uo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root" || exit 1
fail=0
bad(){ echo "check: $*" >&2; fail=1; }

# 1. every inlined core copy matches templates/szmelc.css
tools/sync-core.sh --check || bad "core copies out of date: run tools/sync-core.sh"

# 2. rule files: front-matter id and a "Load when" trigger (CONVENTIONS rule format)
for f in DOCTRINE.md RULES/*.md; do
  head -3 "$f" | grep -q '^id: ' || bad "$f: missing front-matter id"
  grep -q '^> Load when: ' "$f" || bad "$f: missing '> Load when:' line"
  n=$(grep -c '^- ' "$f"); (( n <= 40 )) || bad "$f: $n bullets, split the file"
done

# 3. templates and site obey the core: no fetched fonts, no CDN frameworks, no trackers, no purple
web=(templates/*.css templates/*.html site/*.html)
grep -nE 'fonts\.googleapis|fonts\.gstatic|use\.typekit' "${web[@]}" && bad "fetched webfont"
grep -nE 'cdn\.tailwindcss|bootstrap(\.min)?\.css|<script[^>]+src=' "${web[@]}" && bad "external script or framework"
grep -nE 'googletagmanager|google-analytics|plausible|hotjar' "${web[@]}" && bad "tracker"
grep -noiE '#(8a2be2|9400d3|800080|9370db|7b68ee|6a5acd|8965e0|b48cff|d2a8ff|c965ff|8f93f3)\b' "${web[@]}" && bad "purple in a template"
grep -nE 'border-radius:\s*([5-9]|[1-9][0-9]+)px' templates/szmelc.css && bad "core radius above 4px"

# 4. JSON and TSV data parse
jq -e '.sites|type=="array"' audit/deployments.json >/dev/null || bad "audit/deployments.json invalid"
awk -F'\t' '!/^#/ && NF && NF!=5 {print FILENAME":"NR": "NF" columns"; e=1} END{exit e}' audit/registry.tsv || bad "registry.tsv needs 5 columns"

# 5. local links in Markdown point at files that exist
while IFS=: read -r file link; do
  t=${link%%#*}; [[ -z $t ]] && continue
  [[ -e $(dirname "$file")/$t || -e $t ]] || bad "$file: broken link $link"
done < <(grep -oE '\]\([^)#][^)]*\)' ./*.md RULES/*.md 2>/dev/null | sed -E 's/\]\((.*)\)$/\1/' | grep -vE ':[a-z]+://|:mailto:' | sed 's#^\./##')

# 6. backticked repo paths in docs exist (templates/, tools/, RULES/, audit/)
# shellcheck disable=SC2016  # literal backticks
while IFS=: read -r file p; do
  [[ -e $p ]] || bad "$file: missing path \`$p\`"
done < <(grep -oE '`(templates|tools|RULES|audit)/[A-Za-z0-9_.-]+`' ./*.md RULES/*.md | tr -d '`' | sed 's#^\./##')

((fail)) && exit 1
echo "check: ok"
