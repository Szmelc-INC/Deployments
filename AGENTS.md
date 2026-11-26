# Deployments
> Agent rules for this repo. Global conventions apply; do not restate them. Consult the installed conventions repository's `INDEX.md`.

## Read first
- `DOCTRINE.md` (binding), then only the `RULES/` file whose "Load when" matches the task.

## Commands
- Build: `tools/build.sh`
- Test: `tools/check.sh`
- Lint: `shellcheck tools/*.sh`
- Refresh data: `tools/audit.sh` (network, gh auth)

## Layout
- `RULES/`: rules, CONVENTIONS format (`id:` front-matter, `> Load when:`, one-line bullets).
- `templates/`: what other repos copy. `szmelc.css` is the single source of the core.
- `site/`: this repo's page; `tools/build.sh` injects the data block.
- `audit/`: inputs (`owners.conf`, `extra-urls.tsv`, `registry.tsv`) and the committed snapshot `deployments.json`.

## Rules
- Edit the core only in `templates/szmelc.css`, then run `tools/sync-core.sh`. Never edit an inlined copy.
- A new rule goes to the matching `RULES/` file, or a new one in the same format, and its path goes into the reading list in `tools/build.sh`.
- A new flavor knob needs a row in `RULES/FLAVORS.md`, a token or attribute in the core, and a control in the site's Flavors view.
- Public material only: never name private repositories or copy private code, fonts or icons; token values and described patterns are fine.
- Fixes to other repositories go to those repositories as PRs; here, update `audit/registry.tsv` and `AUDIT.md`.

## Gotchas
- `public/` is build output and gitignored; CI deploys it.
- `tools/audit.sh` sees public repositories only (also in CI); the committed snapshot is what offline builds show.
- Headless Chromium clamps `--window-size` to at least 500px wide: test 360px inside a 360px iframe served over HTTP, not with a narrow window.
- A headless `--screenshot` of a page scrolled by a deep link can come out blank; check scroll position from a script instead.
- The site's Markdown renderer is small: headings, lists, tables, code, links, bold and quotes. Keep docs to that subset.
