---
id: deployments.doctrine
---
# Szmelc WebUI doctrine
> Load when: starting, restyling or reviewing any Szmelc web UI, Pages site, docs site or app panel.

Every Szmelc web UI tastes the same and still has its own flavor. To get that, the core is shared and locked, and each project changes a few small, named knobs. This file binds the rest of the repo together. The rules sit in `RULES/`, the code in `templates/`, and the state of every live site in `AUDIT.md`.

Base library: [Szmelc-INC/CONVENTIONS.md](https://github.com/Szmelc-INC/CONVENTIONS.md). Its `CONVENTIONS/INTERFACES/WEBUI/*`, `CONVENTIONS/DESIGN/COLORS.md` and `CONVENTIONS/GITHUB/DEPLOYMENTS/GITHUB-PAGES.md` apply unchanged. This repo adds the parts they do not cover: scopes, flavors, archetypes, UX patterns, status marks, period skins and the audit.

## 1. Three surfaces, three contracts

| Surface | Examples | Visual core | Technical contract |
|---|---|---|---|
| **Project UI**: Pages sites, docs, registries, tool UIs | CONVENTIONS site, SAUR, Password123, hyperland-wiki | `templates/szmelc.css`, locked | CONVENTIONS WEBUI rules + `RULES/UX.md` |
| **App panel**: long-lived control UIs | Kombinat | Core + `panel` flavor | Same, plus `RULES/UX.md` "panel" section |
| **Period skin**: szmelc.com routes | pulpit, AlgoRytmy, Telegazeta, SSN | Exempt: each route has its own identity | `RULES/SKINS.md` (shared FX, modes, mute, a11y floor) |

- On a project UI, the core is fixed and only the knobs change.
- A period skin is the opposite. On szmelc.com, a layout that repeats across routes counts as a bug, not as consistency. What the routes share is the technical layer.
- When you are not sure which surface you are on: a project repo with a README is a project UI, and a szmelc.com route is a skin.

## 2. The core (locked on project UIs and panels)

- **Palette**: teal accent `#105c5c` (text `#34a3a3`/`#1f8a8a`), danger `#750f0f`/`#b83a3a`, silver `#c0c0c0`, aquamarine `#7fffd4` for 1–2 highlights per screen with black text, and neutral greys `#0b0b0b`/`#131313`/`#1b1b1b` with lines at `#262626`. Never purple, and never a framework's default accent.
- **Ramps**: the token names from CONVENTIONS `site.sh` (`--bg --surface --raise --line --fg --mute --link --fill --tint --ex --hl`).
- **Themes**: `dark` is the default and `light` is required. `mono` and `terminal` are optional.
- **Shape**: lines are 1px, radius is 0–4px (the core uses 3px, the `panel` archetype 0), and shadows never blur. There are no gradients, except the modal vignette and edge fades. No glass, no pills, no rounded cards.
- **Type**: JetBrains Mono through the system stack, never fetched. Body text is 14px, reading width is 92ch, and the smallest text is 11.5px.
- **Behavior**: one self-contained `index.html`, hash routing, one `<dialog>`, a keyboard map, and no trackers. All of it comes from CONVENTIONS WEBUI.
- **Status**: shown by shape plus a word, never by hue alone (`RULES/STATUS.md`).

## 3. Flavor: what a project may change

These are the only knobs. Everything else stays as it is. The full table is in `RULES/FLAVORS.md`.

1. **Archetype**: `catalog`, `registry`, `reader`, `docs`, `panel` or `landing` (`RULES/ARCHETYPES.md`).
2. **Wordmark**: the prompt glyph, the highlighted suffix (`.md`, `.SYS`, `AUR`) and an optional self-hosted display face or pixel or ASCII logo. It applies to the wordmark only.
3. **Signature effect**: at most one of `cursor`, `scanlines`, `glitch` or `dither`. It is off under reduced motion and under more contrast.
4. **Rule color**: the 3–4px top rule takes one accent-ramp step, or `--danger` for experimental projects.
5. **Body face**: mono by default. `reader`, `docs` and `panel` may use the system sans for body text, and `panel` may self-host one OFL sans instead. Labels, data and code stay mono.
6. **Themes**: `mono` or `terminal`, on top of dark and light. Only a `panel` may ship dark alone.

The flavor test: blur a screenshot until you cannot read the text. It should still read as Szmelc, because of the teal rule, the square grey panels and the mono labels. Then read the wordmark. It should name exactly one project.

## 4. Settled conflicts

The audited sources disagree. These are the rulings:

| Source says | Ruling |
|---|---|
| Henderson UI (Kombinat): red `#ff3340` as the brand accent | Keep the principle and drop the hue. "Needs the human" is a solid `--link` teal dot with a bold word. The one main action per view is a teal fill. Danger red is only for failures and risk. |
| Henderson UI: a self-hosted grotesque as the text face | Allowed only in the `panel` archetype: one OFL sans, self-hosted next to the page, set as `--font-sans` for body text. Labels, data and code stay mono. |
| Henderson UI: one dark theme only | Project UIs ship dark and light. A panel may ship dark only if it says so in its README. |
| szmelc.com: `.pal-1…11`, purple, neon, Bootstrap 4 | Skin scope only (`RULES/SKINS.md`). Never on a project UI. |
| hyperland-wiki: the Hextra default (purple callouts, blue links) | Map it to the core with `templates/hextra-custom.css`. |
| SAUR: pill buttons; Password123: rounded cards | Radius 0–4px. Migration rows are in `AUDIT.md`. |
| szmelc.com design pack: no focus ring on OS chrome | Skins keep a visible focus ring anyway (the a11y floor in `RULES/SKINS.md`). |
| The old org home page: Tailwind CDN, blue-tinted greys, corporate copy | Anti-pattern. Rebuild it from `templates/starter.html` with the `landing` archetype. |

## 5. Where things live

| Need | File |
|---|---|
| Rules, one topic each | `RULES/` |
| Core CSS, starter page, Pages workflow, Hextra override | `templates/` |
| Every deployment, its state and its migration | `AUDIT.md`, `audit/` |
| Audit, build, check and core-sync automation | `tools/` |
