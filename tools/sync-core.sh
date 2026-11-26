#!/usr/bin/env bash
# sync-core.sh - copy templates/szmelc.css into every file that carries the core block,
# between "/* == szmelc core v1" and "/* == end szmelc core v1 == */".
# Usage: tools/sync-core.sh [--check] [FILE...]   (default: templates/*.html site/*.html)
# --check: change nothing, exit 1 when a copy differs from the source.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
src="$root/templates/szmelc.css"
check=0
[[ ${1:-} == --check ]] && { check=1; shift; }
(($#)) || set -- "$root"/templates/*.html "$root"/site/*.html
rc=0
for f in "$@"; do
  [[ -f $f ]] || continue
  grep -q '/\* == szmelc core v1' "$f" || continue
  new=$(awk -v src="$src" '
    /\/\* == szmelc core v1/ && !done {while((getline l < src)>0) print l; skip=1; next}
    skip && /\/\* == end szmelc core v1 == \*\// {skip=0; done=1; next}
    !skip {print}' "$f")
  if [[ $new != "$(cat "$f")" ]]; then
    if ((check)); then echo "sync-core: out of date: ${f#"$root"/}" >&2; rc=1
    else printf '%s\n' "$new" > "$f"; echo "sync-core: updated ${f#"$root"/}"; fi
  fi
done
exit $rc
