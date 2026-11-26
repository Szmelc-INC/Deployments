---
id: deployments.rules.skins
---
# Period skins (szmelc.com)
> Load when: adding or changing a route on szmelc.com, or any page that imitates a period interface (OS, device, old website).

The site is a fake Windows 95 desktop. Every other route opens inside a window and wears its own period skin. The routes do not share a layout, and that is deliberate.

## Identity
- Every new route gets a new motif and one leading idea. Check the route catalog in the site's design notes first, and never reuse a motif.
- Pick the motif from a period interface, device or web era. Recreate the feeling, never a specific product's logo, art or trademarked UI.
- One lineage per surface: the hand-built Win95 OS chrome or the pixel kit, never both. Mixing them is drift.
- Win95 chrome: silver `#c3c3c3`, 2px white/black bevels, radius 0, title bar `#000082 → #1084d0`, hard offset shadows with no blur, press = bevel invert + 1px nudge.
- Loud color lives in a palette class (`--main --acc1 --acc2 --shadow`). A skin may declare its own full `:root`. Use at most two background colors per surface.
- Text is the UI face, with Polish diacritics patched into the pixel font. A display face goes on titles only.
- Icons are the period PNG set at 16 or 32px, `image-rendering: pixelated`. Never draw a new icon to "match", and never use emoji as an action.

## Shared technical layer
- Load the shared core in order: styles, then FX, modes, popups, music, window manager, template engine.
- Sound goes through the shared FX engine only. Respect the global mute, and play nothing inside an iframe window.
- Popups are rare, can be dragged and can be turned off per page. Their tone is parody and never misleads or asks for real data.
- Global modes (`crt`, `invert`, `vapor`, ...) apply on every skin. A skin that draws its own CRT does not stack a second one.
- Every route degrades to a readable page without its backend: empty, not broken.
- Hide at least one local secret behind an odd interaction, and hint that it exists.

## Accessibility floor (also on skins)
- A visible keyboard focus ring: a 1px dotted inner outline in period style is fine.
- Reduced motion stops loops, glitch and matrix rain. Everything can be muted, and nothing auto-plays sound.
- Body text keeps WCAG AA contrast against its own surface.
- No horizontal page scroll at 360px, except on viewport-locked desktop shells.
