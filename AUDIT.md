---
id: deployments.audit
---
# Audit
> Load when: checking which Szmelc web deployments exist, which are broken, or which need a migration to the core.

Snapshot: 2026-11-26. The live table is rebuilt weekly by `tools/audit.sh` and shown on the site (view "Deployments"). Classification and migration notes live in `audit/registry.tsv`.

## Method

- Owners: every organization and user in `audit/owners.conf`.
- Candidates: public repositories with Pages enabled, a `<owner>.github.io` name, or a homepage URL. Forks count only when their homepage is ours. Extra URLs come from `audit/extra-urls.tsv`.
- Per site: the HTTP status, the last deployment, and a lint of the live HTML plus its same-origin CSS for the flags `webfont`, `framework`, `tracker`, `round`, `no-theme` and `purple`.
- Private repositories are counted here but never named, and the public report never lists them.
- Kombinat, both generations, every branch: each branch was diffed against `main` for CSS, HTML, JS, PHP and UI directories. Only the Henderson UI branch changes the interface (a new design system, frame, status marks, sessions, terminal and reader views). The config branch is backend only. The Kombinat v2 branches add a module scaffold with an empty `ui/` directory, so v2 has no web UI yet: `RULES/UX.md` (panel) is the brief for it.
- szmelc.com: the full source, its design notes and route catalog, its idea list of period motifs, and the extracted design pack (tokens, 22 specimen cards, OS, kit and neon components, three UI kits). Rendered live pages were checked against them.

## State on 2026-11-26

| | Count |
|---|---|
| Repositories scanned | 437 (9 organizations, 1 user) |
| Repositories with Pages enabled | 8 |
| Public sites in the audit | 17 (12 from repositories, 5 szmelc.com routes) |
| Not live (404 or no answer) | 5 |
| Live project UIs with drift flags | 4 |
| Private legacy Pages sites (not in the report) | 4, the largest with 324 deployments, last 2025-12 |

### Not live
- **Assertion-Driven-Architecture** and **Kombinat**: Pages is on with `build_type=workflow`, but no workflow deploys, so the URL is 404. Fix: add `templates/pages.yml` with a real build, or turn Pages off. Kombinat is a local panel, so turning Pages off is the better fix there.
- **szmelc.com/svg** (SVG-Alert-Studio homepage) and **szmelc.com/hyperland** (Hyperland homepage): 404. Point each homepage at a live URL.
- **dev.szmelc.com**: the host does not answer. The Realistic-Update-Simulator homepage points there, but the same game is live at `szmelc.com/realistic-update-simulator/`.

### Drift on project UIs
| Site | Flags | Migration |
|---|---|---|
| SAUR | `round` | Pill buttons and pill nav go to a radius of 4px or less. The "signed" badge becomes the one aquamarine highlight. |
| Password123 | `round` | Cards go from 6px to 3px, tags become outline badges, headings move from accent to `--head`. |
| hyperland-wiki | `round` | Hextra defaults: a purple `[!IMPORTANT]` callout and a light default. Apply `templates/hextra-custom.css` and default to dark. |
| Entropy-Linux.github.io | `no-theme` | Relic look. Keep blackletter as the wordmark face, use the terminal theme, and put the links into cards. |

The CONVENTIONS site passes every check. It is the reference implementation.

## What the analysis found

### Three lineages
1. **CONVENTIONS mono**: a flat, square, JetBrains Mono site in teal and greys, built by a script into one self-contained page with hash routing, a dialog, a menu and a keyboard map. This is the most complete and most accessible line, so it is the base of the core.
2. **szmelc.com period skins**: a Win95 desktop shell that opens every route in a window. Each route is a deliberate one-off skin (vaporwave, teletext, a 2003 messenger, cassette futurism, GeoCities). The routes share a technical layer (sound engine with global mute, popups, global modes, a window manager, a JSON template engine) and no layout. Two Win95 systems coexist: the hand-built OS chrome and a Bootstrap-era pixel kit. Mixing them on one surface is drift. The design pack documents bevel-as-state, hard offset shadows, radius 0 and 2px spacing steps.
3. **Kombinat panel, Henderson UI**: one dark theme, square shapes, 1px lines instead of shadows, no gradients, a sans display face for text and mono for data, and one red brand accent. Its UX decisions carry over to any app: places that each answer one question, an Inbox of what needs the human, list + details, `Ctrl+K` palette, a composer from anywhere, a status bar, one poll, status by shape and word, one accent action per view, no emoji, and aliases for old token names.

### Older layers
- Relic sites (2023–2024): black, `#00ff00`, a blackletter display face, no theme handling. The mood survives as an allowed wordmark face plus the terminal theme.
- The org home page: a Tailwind CDN template with blue-tinted greys and corporate copy. This is the anti-pattern that `RULES/COPY.md` and the core exist to prevent.
- A GitHub-dark clone palette (SVG-Alert-Studio): readable, but borrowed. Map it to the core tokens.

### Smaller defects seen
- Henderson UI at 1280px: the last header tab runs into the search box.
- szmelc.com OS chrome has no focus style. The skins' accessibility floor requires one.

## Follow-ups
Each fix lands in its own repository through a PR. This repo only records them.
- [ ] ADA: deploy workflow or Pages off.
- [ ] Kombinat: Pages off, or a landing page.
- [ ] SVG-Alert-Studio, Hyperland, Realistic-Update-Simulator: fix the homepage URLs.
- [ ] SAUR, Password123: radius and badge migration.
- [ ] hyperland-wiki: `templates/hextra-custom.css` and a dark default.
- [ ] Org home page: rebuild from `templates/starter.html` with the `landing` archetype.
