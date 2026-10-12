# Installation

Basecoat ships as one npm package, `basecoat-css` (current: 1.0.2). Use the CDN for static pages and prototypes; use npm when the project already has a Tailwind CSS v4 build step.

Before installing, check what the project already has (`package.json`, the CSS entry file, existing `<link>`/`<script>` tags) so you extend the existing setup instead of adding a second one.

## CDN

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/basecoat-css@1.0.2/dist/basecoat.cdn.min.css" />
<script src="https://cdn.jsdelivr.net/npm/basecoat-css@1.0.2/dist/js/all.min.js" defer></script>
```

The CDN stylesheets are standalone: they bundle Tailwind's reset and theme plus every Basecoat component, so Basecoat classes work with nothing else on the page. They do not contain Tailwind's utility classes. Layout utilities you write yourself (`flex`, `gap-4`, `w-72`, `dark:hidden`, ...) only work if Tailwind is also present. On a page with no build step, the Tailwind browser build is the way to get them (this pairing is not covered by the Basecoat docs, so check the result in a browser):

```html
<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
```

If the page needs more than a handful of utilities, prefer the npm setup below.

Pick a named style bundle by changing the file name (`vega`, `nova`, `maia`, `lyra`, `mira`, `luma`, `sera`, `rhea`):

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/basecoat-css@1.0.2/dist/basecoat-maia.cdn.min.css" />
```

To load only the JavaScript you use, load the runtime once and then the individual components:

```html
<script src="https://cdn.jsdelivr.net/npm/basecoat-css@1.0.2/dist/js/basecoat.min.js" defer></script>
<script src="https://cdn.jsdelivr.net/npm/basecoat-css@1.0.2/dist/js/dropdown-menu.min.js" defer></script>
<script src="https://cdn.jsdelivr.net/npm/basecoat-css@1.0.2/dist/js/select.min.js" defer></script>
```

| File | Description |
| --- | --- |
| `dist/basecoat.cdn.min.css` | Default standalone CDN stylesheet. Alias for the Vega style. |
| `dist/basecoat-{style}.cdn.min.css` | Standalone CDN stylesheet for one named style. |
| `dist/basecoat-base.cdn.min.css` | Base tokens, utilities, and component structure without a style pack. |
| `dist/basecoat-compat.cdn.min.css` | Optional pre-1.0 compatibility aliases. Load after Basecoat. |
| `dist/js/all.min.js` | All auto-initialized JavaScript components except Chart. |
| `dist/js/basecoat.min.js` | Runtime only. Load once before individual component scripts. |
| `dist/js/{component}.min.js` | Individual JavaScript component file. |

## npm

1. Install Tailwind CSS v4 first if the project does not have it (https://tailwindcss.com/docs/installation).
2. Install Basecoat with the project's package manager:

```bash
npm install basecoat-css   # or: pnpm add / bun add / yarn add
```

3. Import Tailwind, then exactly one Basecoat bundle, in the CSS entry file:

```css
@import "tailwindcss";
@import "basecoat-css";        /* default = Vega */
/* or a named style: @import "basecoat-css/maia"; */
```

Without a bundler, copy or serve files from `node_modules/basecoat-css/dist` and link them:

```html
<link rel="stylesheet" href="/assets/basecoat.css" />
<script src="/assets/js/all.min.js" defer></script>
```

**Stylesheet order matters.** Load Basecoat after any stylesheet that includes Tailwind base/preflight. A full Tailwind build loaded after Basecoat resets borders, inputs, and other component defaults.

4. Add JavaScript only if you use an interactive component:

```js
import "basecoat-css/all";            // everything except Chart
```

```js
import "basecoat-css/basecoat";       // runtime, once
import "basecoat-css/dropdown-menu";  // then only what you use
import "basecoat-css/select";
```

### CSS imports

| Import | Description |
| --- | --- |
| `basecoat-css` | Default full stylesheet. Alias for `basecoat-css/vega`. |
| `basecoat-css/{style}` | Full stylesheet for `vega`, `nova`, `maia`, `lyra`, `mira`, `luma`, `sera`, or `rhea`. |
| `basecoat-css/base` | Base tokens, utilities, and component structure without a style pack. Use this before a custom style. |
| `basecoat-css/components` | All component structure without a style pack. |
| `basecoat-css/components/button` | Individual component CSS. Replace `button` with any component file. |
| `basecoat-css/styles/maia` | Individual style-pack CSS. Use with `basecoat-css/base` or `basecoat-css/components`. |
| `basecoat-css/all.css` | Full default stylesheet plus all style-pack CSS. Only when every style pack must be available at runtime. |
| `basecoat-css/compat` | Optional pre-1.0 compatibility aliases. Load after Basecoat. |

Each import also resolves with a `.css` suffix (`basecoat-css/vega.css`, `basecoat-css/base.css`, ...).

To ship less CSS, import the base, the components you use, and one style pack:

```css
@import "tailwindcss";
@import "basecoat-css/base.css";
@import "basecoat-css/components/button.css";
@import "basecoat-css/styles/vega.css";
```

### JavaScript imports

| Import | Description |
| --- | --- |
| `basecoat-css/all` | All auto-initialized JavaScript components except Chart. |
| `basecoat-css/basecoat` | Runtime only. Import once before individual component scripts. |
| `basecoat-css/accordion` | Accordion controller (single-open behavior). |
| `basecoat-css/chart` | Chart helper. Load Chart.js separately. |
| `basecoat-css/combobox` | Combobox controller. |
| `basecoat-css/command` | Command controller. |
| `basecoat-css/drawer` | Drawer controller. |
| `basecoat-css/dropdown-menu` | Dropdown Menu controller. |
| `basecoat-css/popover` | Popover controller. |
| `basecoat-css/range` | Slider/range controller. |
| `basecoat-css/select` | Select controller. |
| `basecoat-css/sidebar` | Sidebar controller. |
| `basecoat-css/tabs` | Tabs controller. |
| `basecoat-css/toast` | Toast controller. |

## JavaScript lifecycle

Basecoat initializes registered components on page load and when new DOM is inserted, so HTMX swaps, Turbo frames, and similar partial updates normally work without extra code.

- `window.basecoat.initAll()` — call after manually inserting HTML that contains Basecoat components. It only initializes components that are not already initialized.
- `window.basecoat.initAll({ force: true })` — call when a framework or navigation library restores previously initialized DOM from a cache (for example an HTMX history restore). Force mode destroys existing instances first, so it also resets transient state such as open menus and focus.

## Icons

Basecoat does not bundle icons. The docs use inline [Lucide](https://lucide.dev/icons) SVGs; any icon set works. See [customization](./customization.md#icons).

## Templates

Optional Nunjucks and Jinja macros ship inside the package. See [templates](./templates.md).

```bash
cp -R node_modules/basecoat-css/templates/jinja ./templates/basecoat     # or templates/nunjucks
```

The old `basecoat-cli` package is deprecated; do not install it.

## Migrating from pre-1.0

Basecoat 1.0 replaced variant classes with a root class plus `data-variant` / `data-size` attributes and semantic child elements. To keep old markup working while migrating, load the compatibility layer after Basecoat. It targets the default style only and is for migration, not new code.

```css
@import "tailwindcss";
@import "basecoat-css";
@import "basecoat-css/compat";
```
