# Lucide with Absurd Templates

Read the `absurd-templates` skill and `abs.yaml` first. Edit HTML under its `input` directory, never the generated Dart `output`. Preserve the project's existing icon integration; the bundled Dart generator has no Absurd emitter.

## Template icons with browser JS

The absurd-starter pattern downloads pinned Lucide browser JS, serves it locally, loads it in the layout head, and initializes template placeholders from shared JavaScript. Reuse these pieces when already present; for a new setup:

### 1. Download the pinned browser bundle

Add this target to the existing Makefile (recipe lines use tabs):

```makefile
.PHONY: lucide

lucide:
	@mkdir -p public/js
	@set -eu; \
	temp=$$(mktemp public/js/lucide.min.js.XXXXXX); \
	trap 'rm -f "$$temp"' EXIT; \
	curl --fail --location https://unpkg.com/lucide@1.33.0/dist/umd/lucide.min.js --output "$$temp"; \
	mv "$$temp" public/js/lucide.min.js
```

Run `make lucide`. Here `1.33.0` is the starter's example pin, not a required version or a claim about the latest release. Preserve an existing project pin; for a new project choose and verify an available release. The temporary file keeps a failed download from replacing the working bundle. Preserve the upstream ISC license alongside redistributed assets.

Serve `public/` through the existing static handler, so `public/js/lucide.min.js` is available at `/js/lucide.min.js`. Adjust paths to the app's asset convention and deployment base path; do not expose the project root. Ship the vendored bundle with production assets, without requiring a download at server startup.

### 2. Load scripts once in the layout head

In the shared layout template declared under the `abs.yaml` input directory (the starter uses `lib/src/ui/templates/layout/primary.html`), add these tags inside the existing `<head>`, after any existing HTMX and Basecoat scripts:

```html
<script src="/js/lucide.min.js"></script>
<script src="/index.js"></script>
```

These are the starter's ordered, synchronous tags. Ordered `defer` tags also work if that is the app's convention; do not use `async` when initialization depends on load order. Reuse an existing `/index.js` tag rather than loading it twice. Do not repeat these tags in HTMX fragments.

### 3. Initialize in shared browser JavaScript

In `public/index.js`, merge this into the existing shared initializer instead of adding competing listeners:

```js
function initUi() {
  if (window.lucide) window.lucide.createIcons()
  // Keep existing Basecoat and dialog initialization here too.
}

document.addEventListener('DOMContentLoaded', initUi)
document.addEventListener('htmx:after:swap', initUi)
```

The swap event above is for the starter's **HTMX 4**. Inspect the installed version: for HTMX 2, use `htmx:afterSwap` instead. Do not add inline lifecycle scripts or a new listener per icon. With static SVG templates rather than browser placeholders, this initialization is unnecessary.

### 4. Write placeholders in templates

```html
<button type="button" aria-label="Close">
  <i data-lucide="x" class="size-4" aria-hidden="true"></i>
</button>
<button type="button">
  <i data-lucide="plus" class="size-4" aria-hidden="true"></i>
  Add item
</button>
```

Use upstream kebab-case icon names, not Dart helper names. Keep the project's Basecoat classes/attributes when adding icons to its controls. Follow the shared accessibility rules; an icon-only button needs a label even before the browser replaces the placeholder.

This path requires browser JavaScript, but no Dart icon-generation dependencies. Do not promise server-rendered SVG or no runtime JavaScript.

## Existing static SVG templates

If the project already keeps Lucide SVG markup in templates, preserve it instead of introducing browser JS. Trusted upstream `<svg>` markup can live directly in a template and be reused through `<x-fragment>` or a generated `Fragment` prop. Preserve the release and license provenance. Do not inject an SVG string through `{{ icon }}`: strings are escaped, not treated as raw HTML. Do not introduce htmleez/Jaspr or invent a raw-fragment constructor.

## Check

Run `abs check` on changed templates, then `abs`, analysis, and the project's tests. Use the vendored abs command if configured. For the browser path, verify icons on initial load and after an HTMX swap, asset loading order, sizing, and accessible button labels.
