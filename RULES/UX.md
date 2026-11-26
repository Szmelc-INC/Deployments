---
id: deployments.rules.ux
---
# UI/UX
> Load when: designing what a web UI shows, how a user moves through it, or what an action does.

Sources: the Kombinat panel's UI decisions (a layout around "what waits for me", one accent action per view, status by shape), the CONVENTIONS WEBUI rules, and what the audited sites got right.

## Every UI
- Build each page around one question (`RULES/ARCHETYPES.md`). No intro paragraph and no "How it works" block. The page itself explains.
- Show the answer first and the controls second. Empty states say what fills them and offer the one action that does.
- One main action per view, in teal fill (`.btn.primary`). Other actions are plain. Destructive actions use the danger outline.
- Give every item one address (a hash or path). Old addresses keep working through a mapping, never through a 404.
- Copyable commands sit in a `pre` block with a copy button. Never "run this:" in prose.
- Show build-time data at once. A live refresh is optional, happens once and keeps the old value on failure. No spinners on first paint.
- Errors say what failed and what to do next, in one line, next to the thing that failed.
- Numbers carry units and use tabular figures. Dates are `YYYY-MM-DD`. Sizes are `K`/`M`/`G`.
- Counts in labels read "label: n" (or the count after the label). Never inflect around a number.
- No emoji as UI. Use a word or a Unicode glyph (`▸ ✕ ⌂ ↗`). Icons are an inline SVG sprite in `currentColor`.

## Navigation and keys
- Use the CONVENTIONS keyboard map (`/ 1–9 t ? Esc`). Lists add `j`/`k`. Apps add `g`+letter for places.
- A command palette on `Ctrl+K` (plus `/` where no filter exists) for sites with more than one view or more than 30 items. It indexes pages, items and commands.
- A visible control for every shortcut. `?` lists them from the same table the handler reads.

## Panel (apps)
- Places, each answering one question: Inbox (needs you), Work (list + details), plus the domain places. Five to seven at most.
- The Inbox is one queue, oldest first, with actions in place (Approve/Reject, Retry, Put aside). The count in the header is the only aquamarine badge.
- List + details: list on the left, details on the right; on a phone, the details open as a full view.
- A status bar at the bottom for what is running, queued and broken, plus the language and the key help.
- `C` or "New" opens one composer from anywhere.
- One poll for the whole UI (a pulse endpoint). Pages reload data only when the pulse changes. Timers tick in the browser.
- The UI shows commands to copy for anything that runs on the host. A human runs them.
- Keep the old CSS variable names as aliases when tokens change, so modules with their own markup survive.
