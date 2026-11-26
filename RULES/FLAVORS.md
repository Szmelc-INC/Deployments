---
id: deployments.rules.flavors
---
# Flavors
> Load when: giving a project UI its own look, choosing a wordmark, effect or archetype, or reviewing a page for drift.

| Knob | How | Allowed values | Default |
|---|---|---|---|
| Archetype | `data-flavor` on `<html>` | `catalog` `registry` `reader` `docs` `panel` `landing` | `catalog` |
| Wordmark prompt | `--wm-prompt` | One glyph: `❯ $ # § ■ λ >` | Archetype preset |
| Wordmark suffix | `<b>` inside `.wm` | The part that names the kind: `.md`, `AUR`, `.SYS`, `123` | None |
| Wordmark face | `@font-face` on `.wm` only | Self-hosted woff2 under OFL, or a pixel or ASCII logo as inline SVG or text | Core mono |
| Signature effect | `data-fx` on `<html>` | `cursor` `scanlines` `glitch` `dither`, one of them | None |
| Top rule | `--rule` | `--accent-d…--accent-l`, `--danger` for experimental | `--accent` |
| Body face | `--font-body` | `var(--font)`; `var(--font-sans)` only for `reader`, `docs`, `panel`; a `panel` may point `--font-sans` at one self-hosted OFL sans | Mono |
| Themes | Theme list in the head script | Dark + light, plus `mono`, `terminal`; a `panel` may ship dark only, stated in its README | Dark + light |

- Change only the knobs in this table. Any other override of a core token is drift. List it in `AUDIT.md` or remove it.
- Set knobs in one `<style>` block right after the core block, never inside it.
- Keep one wordmark per page. The rest of the page carries no brand decoration.
- The wordmark face never becomes the body face. It is never fetched from a font CDN, and its license file ships next to it.
- Effects stay off under `prefers-reduced-motion: reduce` and `prefers-contrast: more`. The core already does this, so do not override it.
- A legacy relic look (black, `#00ff00`, blackletter) is allowed as the wordmark face plus the `terminal` theme. Never use raw `#00ff00` text.
- Record the chosen knobs in the repo `README.md` under "Web UI", one line, for example: `registry · $ · AUR · cursor · rule accent`.
