# Absurd Skills

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

This is a collection of agent skills that are done by me and useful to me.

## Skills

| Skill | What it does |
| --- | --- |
| [`basecoat`](skills/basecoat/SKILL.md) | Build UIs with [Basecoat](https://basecoatui.com) 1.0 (`basecoat-css`), the shadcn/ui-style component library for plain HTML and Tailwind CSS. Covers the 1.0 API (`data-variant` / `data-size` attributes, semantic child elements), with a reference for every component plus installation, customization and templates. |
| [`basecoat-dart`](skills/basecoat-dart/SKILL.md) | Use Basecoat from server-rendered Dart with separate Jaspr, htmleez, and `absurd_templates` references. Covers optional typed Jinja macros for Jaspr/htmleez and direct HTML with typed fragments for Absurd. Works alongside `basecoat`. |
| [`dart-lucide-icons`](skills/dart-lucide-icons/SKILL.md) | Use pinned Lucide icons with renderer-specific references: generated SVG helpers for Jaspr/htmleez, and template icons with shared browser initialization for `absurd_templates`. Includes the Dart helper generator; that path needs no runtime JavaScript. |
| [`dart-tailwind`](skills/dart-tailwind/SKILL.md) | Compile Tailwind CSS for client-rendered, static, and server-rendered Dart web apps with one CSS entrypoint and the CLI, without a local npm project or frontend bundler. Covers Dart source scanning, Jaspr integration, build/watch commands, asset serving, and deployment, with a standalone executable option for Node-free builds. |
| [`htmleez-html`](skills/htmleez-html/SKILL.md) | Build HTML in Dart with htmleez 1.0: tags, `$("name")("value")` attributes, text and escaping, fragments, raw content, void elements, and rendering. Keeps attributes inline and only extracts long, repeated values into `$`-prefixed helpers. |
| [`htmx-interactivity`](skills/htmx-interactivity/SKILL.md) | Complete HTMX interactions: button loading states, same-route skeleton loading, boosted navigation, selective preloading, error/retry feedback, request synchronization, and version-aware HTMX 4/hx-live local behavior. |
| [`relic`](skills/relic/SKILL.md) | Build Dart HTTP servers with Relic's 2.0 prerelease API: apps, routing, middleware, request bodies, query parameters, forms, multipart uploads, cookies, headers, responses, static files, and WebSockets. |

## Installation

```sh
npx skills add namzug16/absurd-skills
```

## Acknowledgements

The `basecoat` skills are based on the documentation of [Basecoat](https://github.com/hunvreus/basecoat) by Ronan Berder, released under the MIT license.

## License

[MIT](LICENSE) © Gustavo Guzman
