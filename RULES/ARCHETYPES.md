---
id: deployments.rules.archetypes
---
# Archetypes
> Load when: laying out a new project UI, or deciding the page structure of a Pages, docs or tool site.

| Archetype | Answers | Layout | Reference |
|---|---|---|---|
| `catalog` | "Which item applies?" | Wordmark, sticky tabs and filter, collapsible groups with counts, sidebar index | CONVENTIONS site |
| `registry` | "What is there and how do I get it?" | Wordmark, one install command block, filter and sort, one dense table with row actions | SAUR |
| `reader` | "Explain this one thing" | Sticky list on the left, one reading well on the right, tags as badges | Password123 |
| `docs` | "How do I do X?" | Nav tree, article at 92ch, table of contents on wide screens, search on `/` | hyperland-wiki |
| `panel` | "What needs me now?" | Header with tabs, inbox, list + details, status bar | Kombinat |
| `landing` | "What is this and where do I go?" | Wordmark, one line, 3–7 link cards, byline footer | Org and product home pages |

- Pick one archetype per page. A site may mix them across pages, never within one page.
- Each archetype's first screen answers its question without scrolling at 1280×800.
- `landing` has no hero image, no tagline paragraph and no feature grid. One sentence and links.
- `registry` and `catalog` show counts in tabs and group headers, and the filter updates them.
- `reader` and `docs` keep one reading width (92ch) and one well. Navigation never scrolls the article.
- `panel` follows `RULES/UX.md` in full.
- At 360px, every archetype collapses to one column, with no horizontal page scroll.
