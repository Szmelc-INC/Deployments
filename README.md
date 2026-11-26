# Deployments

[![CI](https://img.shields.io/github/actions/workflow/status/Szmelc-INC/Deployments/ci.yml?branch=main&label=ci)](https://github.com/Szmelc-INC/Deployments/actions/workflows/ci.yml)
[![Pages](https://img.shields.io/github/actions/workflow/status/Szmelc-INC/Deployments/pages.yml?branch=main&label=pages)](https://szmelc-inc.github.io/Deployments/)
[![License](https://img.shields.io/github/license/Szmelc-INC/Deployments?color=105c5c)](LICENSE)

**The Szmelc WebUI doctrine: one locked core, a few per-project flavor knobs, and a weekly audit of every public Szmelc deployment.**

It is built on [CONVENTIONS.md](https://github.com/Szmelc-INC/CONVENTIONS.md) and adds what that repo does not cover: scopes, flavors, archetypes, UX patterns, status marks, period skins, templates and the audit. Live site: <https://szmelc-inc.github.io/Deployments/>.

```sh
# start a new project UI from the starter and the Pages workflow
curl -fsSL https://szmelc-inc.github.io/Deployments/templates/starter.html -o site/index.html
curl -fsSL https://szmelc-inc.github.io/Deployments/templates/pages.yml --create-dirs -o .github/workflows/pages.yml
```

## Start here

| Read | Covers | When |
|---|---|---|
| [DOCTRINE.md](DOCTRINE.md) | Surfaces, the locked core, flavor knobs, settled conflicts | First |
| [RULES/UX.md](RULES/UX.md) | Page-per-question, actions, keys, panels | Designing what a UI shows and does |
| [RULES/FLAVORS.md](RULES/FLAVORS.md) | The only knobs a project may change | Giving a project its look |
| [RULES/ARCHETYPES.md](RULES/ARCHETYPES.md) | `catalog` `registry` `reader` `docs` `panel` `landing` | Laying out a page |
| [RULES/STATUS.md](RULES/STATUS.md) | Status by shape and word | Showing any state |
| [RULES/SKINS.md](RULES/SKINS.md) | szmelc.com period skins and their shared layer | Adding a szmelc.com route |
| [RULES/COPY.md](RULES/COPY.md) | Voice and words to avoid | Writing UI text |
| [AUDIT.md](AUDIT.md) | Every deployment, what is broken, migrations, findings | Fixing or reviewing sites |

## What's inside

```text
Deployments/
|-- DOCTRINE.md              # the binding one-pager
|-- RULES/                   # one topic per file, CONVENTIONS rule format
|-- AUDIT.md                 # findings and follow-ups (snapshot)
|-- audit/
|   |-- owners.conf          # owners to scan
|   |-- extra-urls.tsv       # sites no repo setting points at
|   |-- registry.tsv         # surface, archetype, flavor, migration per site
|   |-- deployments.json     # last audit result (committed snapshot)
|-- templates/
|   |-- szmelc.css           # the locked core
|   |-- starter.html         # self-contained single-page starter
|   |-- pages.yml            # Pages workflow
|   |-- hextra-custom.css    # Hugo Hextra docs override
|-- site/index.html          # this repo's own site (dogfood)
|-- tools/
    |-- audit.sh             # list, check and lint every public deployment
    |-- build.sh             # build public/ from docs, audit and templates
    |-- check.sh             # doctrine checks (CI)
    |-- sync-core.sh         # copy the core into every page that inlines it
```

## Usage

```sh
tools/audit.sh            # refresh audit/deployments.json (needs gh auth)
tools/build.sh            # build public/
tools/check.sh            # run the CI checks locally
tools/sync-core.sh        # after editing templates/szmelc.css
```

Open `public/index.html` over `file://` or serve `public/` over HTTP.

## Web UI

`catalog · ❯ · .2 · cursor · rule accent`

## Brief

The original brief this repo answers, verbatim:

> ### Deployments 2.0
> A central Modern Szmelc:tm: WebUI doctrine & automations
>
> 1. Analyze all deployed github-pages across my organizations, old repos with deployments (serainox420 etc), and create some modern templates & conventions for writing and designing WebUI's like Szajs:tm: (reuse default styles as much as possible, giving everything a suble unique flavor while all still tasting the same good old "ol-reliable" Szmelc Design.
> 2. Analyze all kombinats and branches, including henderson UI, chop everything into instructions on how to write solid WebUI's with exponential modern minimalism, full UI/UX MAXXING.
> 3. Analyze `szmelc.com` throughly... (there is full codebase as private repo under Szmelc-INC/, there are design packs and all the other usual ui kits etc, that too should be learned & understood (consumed basucally).
>
> For writing everything, use CONVENTIONS.md repo as "library" of templates++ !

## License

MIT. See [LICENSE](LICENSE).
