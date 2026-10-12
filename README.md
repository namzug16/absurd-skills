# Absurd Skills

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

This is a collection of agent skills that are done by me and useful to me.

## Skills

| Skill | What it does |
| --- | --- |
| [`basecoat`](skills/basecoat/SKILL.md) | Build UIs with [Basecoat](https://basecoatui.com) 1.0 (`basecoat-css`), the shadcn/ui-style component library for plain HTML and Tailwind CSS. Covers the 1.0 API (`data-variant` / `data-size` attributes, semantic child elements), with a reference for every component plus installation, customization and templates. |
| [`basecoat-dart`](skills/basecoat-dart/SKILL.md) | Use Basecoat from server-rendered Dart: Jaspr, htmleez, Shelf, Dart Frog, Relic. Vendors Basecoat's Jinja macros into a Dart project, renders them with the `jinja` package, and exposes them through a typed interface (`bc.select(...)`, `bc.dialog(...)`, ...). Works alongside `basecoat`. |

## Installation

```sh
npx skills add namzug16/absurd-skills
```

## Acknowledgements

The `basecoat` skills are based on the documentation of [Basecoat](https://github.com/hunvreus/basecoat) by Ronan Berder, released under the MIT license.

## License

[MIT](LICENSE) © Gustavo Guzman
