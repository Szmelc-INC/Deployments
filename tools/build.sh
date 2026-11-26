#!/usr/bin/env bash
# build.sh - build the Deployments site into public/ (gitignored).
# Usage: tools/build.sh [--offline]
#   Reads DOCTRINE.md, RULES/*.md, AUDIT.md, audit/deployments.json and templates/.
#   --offline is accepted for clarity: the build never fetches anything; run tools/audit.sh first for fresh data.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
out="$root/public"
[[ ${1:-} == --offline || -z ${1:-} ]] || { echo "build: unknown option: $1" >&2; exit 2; }
command -v jq >/dev/null || { echo "build: missing jq" >&2; exit 1; }
"$root/tools/sync-core.sh" --check

rm -rf "$out"; mkdir -p "$out/templates"
repo="https://github.com/Szmelc-INC/Deployments"

# documents in reading order
docs=$(for f in DOCTRINE.md RULES/UX.md RULES/FLAVORS.md RULES/ARCHETYPES.md RULES/STATUS.md RULES/SKINS.md RULES/COPY.md AUDIT.md; do
  [[ -f $root/$f ]] || { echo "build: missing $f" >&2; exit 1; }
  jq -n --arg path "$f" --rawfile md "$root/$f" \
    '{path:$path, id:("doc-" + ($path|ascii_downcase|gsub("[^a-z0-9]+";"-"))), md:$md}'
done | jq -s .)

# downloadable templates with a one-line description each
declare -A desc=(
  [szmelc.css]="The locked core: tokens, themes, components, status marks, effects. Copy between the core markers."
  [starter.html]="Self-contained single-page starter: core inlined, routing, dialog, menu, keys. Set the flavor knobs and fill #data."
  [pages.yml]="GitHub Pages workflow: build script, upload artifact, deploy. Pinned actions."
  [hextra-custom.css]="Maps a Hugo Hextra docs site onto the core palette: no purple, teal links, square callouts."
)
tpl=$(for f in szmelc.css starter.html pages.yml hextra-custom.css; do
  cp "$root/templates/$f" "$out/templates/$f"
  jq -n --arg p "templates/$f" --arg d "${desc[$f]}" --arg s "$(du -h "$root/templates/$f" | cut -f1)" '{path:$p,desc:$d,size:$s}'
done | jq -s .)

audit="$root/audit/deployments.json"
[[ -s $audit ]] || echo '{"generated":"","sites":[]}' > "$audit"
built=$(date -u +%F)
data=$(jq -n -c --argjson docs "$docs" --argjson tpl "$tpl" --slurpfile audit "$audit" --arg repo "$repo" --arg built "$built" \
  '{docs:$docs, audit:$audit[0], templates:$tpl, repo:$repo, built:$built}')
printf '%s\n' "$data" | jq . > "$out/data.json"

# inject the data block; "<" is escaped so no string can close the script element
# (ENVIRON, not awk -v: -v would expand the JSON's backslash escapes; print, not sub(): "&" is special there)
DATA=$(printf '%s' "$data" | sed 's/</\\u003c/g') awk '
  /<script type="application\/json" id="data">/ { print "<script type=\"application/json\" id=\"data\">" ENVIRON["DATA"] "</script>"; next } { print }' \
  "$root/site/index.html" > "$out/index.html"
grep -q '"docs":\[{' "$out/index.html" || { echo "build: data block not injected" >&2; exit 1; }

# llms.txt: an index for agents (CONVENTIONS/SPECS/THIRD-PARTY/LLMS-TXT.md)
{
  echo "# Deployments"
  echo "> Szmelc WebUI doctrine: one locked core, small per-project flavors, and a weekly audit of every public deployment."
  echo
  echo "## Docs"
  jq -r --arg r "$repo" '.[]|"- [\(.path)](\($r)/blob/main/\(.path))"' <<<"$docs"
  echo
  echo "## Templates"
  jq -r '.[]|"- [\(.path)](\(.path)): \(.desc)"' <<<"$tpl"
} > "$out/llms.txt"
echo "build: public/ ($(du -sh "$out" | cut -f1), $(jq '.audit.sites|length' "$out/data.json") sites, $(jq '.docs|length' "$out/data.json") docs)"
