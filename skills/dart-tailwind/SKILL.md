---
name: dart-tailwind
description: Set up and maintain Tailwind CSS for Dart web applications, client-rendered or server-rendered, using a CSS input file and the Tailwind CLI without a package.json, local npm dependencies, or a frontend bundler. Use whenever using Tailwind with Jaspr, htmleez, absurd_templates (Absurd Templates / abs), Relic, Shelf, Dart Frog, or HTMX; adding CSS build/watch commands; scanning Dart components or HTML templates; fixing missing generated styles; or packaging CSS for deployment. Includes renderer-specific references for Jaspr, htmleez, and Absurd. Not for Flutter widget styling, including Flutter Web's non-DOM widget rendering.
---

# Tailwind for Dart web

Write utility classes directly in Dart components or templates, compile one CSS entrypoint into a static asset, and load it in the HTML document. Serve the asset through the Dart backend or the application's static hosting. Tailwind is a build-time tool, not a runtime dependency; the same pipeline works for client rendering, static generation, and SSR.

Use Tailwind v4's CSS-first configuration for new setups. Do not introduce `package.json`, `node_modules`, Vite, PostCSS, `build_runner`, or `tailwind.config.js` just to compile CSS. Preserve existing working tooling; do not migrate a v3 project implicitly.

## Choose the renderer first

Inspect `abs.yaml`, `pubspec.yaml`, UI sources, the CSS entrypoint, and build commands. Absurd's generated Dart has no runtime dependency, so do not rely on the package manifest alone. For mixed projects, scan each source directory that actually contains UI class literals.

| Renderer | Read | Source and layout |
| --- | --- | --- |
| Jaspr | [references/jaspr.md](./references/jaspr.md) | Dart components and mode-specific document/assets |
| htmleez | [references/htmleez.md](./references/htmleez.md) | Dart HTML builders and shared document head |
| absurd_templates | [references/absurd-templates.md](./references/absurd-templates.md) | HTML input templates plus non-generated Dart, layout template |

Read the relevant reference and specialized renderer skill before editing markup. The CLI, class-detection, and deployment rules below are shared; do not install another renderer to use Tailwind.

## Workflow

1. Inspect the existing CSS entrypoint, `pubspec.yaml`, Makefile/build scripts, HTML entrypoint or layout, asset directories, and deployment files. Determine whether the app is client-rendered, statically generated, or server-rendered. Reuse existing names and conventions rather than creating a second pipeline.
2. Create or update a root `input.css` (or keep the project's existing `index.css` entrypoint). Register the Dart and/or HTML template sources that contain class names, following the renderer reference.
3. Add CLI build and watch commands. Prefer the `npx` workflow unless Node/npm is unavailable or the user wants a Node-free build; then use the standalone executable.
4. Link the generated stylesheet in the HTML entrypoint or shared layout. Use the existing static-file handler or asset build/hosting pipeline.
5. Rebuild and verify a class from a real Dart component or template is generated and the stylesheet URL responds correctly.
6. Ensure deployment includes freshly generated CSS. Report the changed paths, build/watch commands, and any verification you could not run.

## CSS entrypoint

For a root-level `input.css`:

```css
@import "tailwindcss";
@source "./lib/**/*.dart";
```

Tailwind scans source as plain text, so no Dart-specific plugin is needed. The Dart-only example applies to UI built in Dart; Absurd also needs its HTML input directory registered, as shown in its reference.

`@source` paths are relative to the **input stylesheet**, not the generated file. If the input lives at `assets/input.css`, use `../lib/**/*.dart`. Add sources for `bin/`, HTML/Jinja templates, or other directories only when those actually contain UI classes.

Automatic scanning remains enabled with the import above. If strict source boundaries are needed, use `@import "tailwindcss" source(none);` and explicitly register every relevant source.

Keep input and output separate: for example, `input.css` → `public/index.css`. Use the project's actual asset directory; a client app may use `web/index.css` instead. Update the CLI commands and stylesheet link consistently. Never overwrite the input or hand-edit the generated output.

### Optional vendored CSS

If the project uses a component library or other third-party styles, vendor its browser-ready CSS and import it alongside Tailwind:

```css
@import "tailwindcss";
@import "./vendor/components.css";
@source "./lib/**/*.dart";
```

Replace the example path with the actual local bundle. Only add imports for libraries the project uses, and preserve existing theme paths, required companion assets, and upstream license notices. Pin downloaded assets to a verified release. Tailwind itself does not require a component library.

This pattern works with browser-ready bundles from libraries such as Basecoat or daisyUI. Follow the selected library's documentation for its distributed CSS, themes, and any required JavaScript; do not assume every library publishes the same bundle format.

Distinguish precompiled CSS from a Tailwind plugin. A library's npm plugin cannot be substituted directly into a CSS `@import`. For a no-local-npm setup, use its documented precompiled CSS or standalone-CLI-compatible integration if available. If the desired features require npm plugin dependencies, explain that requirement rather than claiming vendored CSS provides the same build-time behavior. Consult any applicable library-specific skill before writing its component markup.

## CLI without a local npm project

Run from the application root:

```sh
mkdir -p public
npx @tailwindcss/cli -i ./input.css -o ./public/index.css --minify
```

This requires Node/npm: `npx` downloads/caches the npm CLI package and may ask for confirmation, but does not require installing dependencies into the application or creating a package manifest. Do not describe it as a Node-free or download-free build.

For development, run a separate watcher alongside the application's development server:

```sh
npx @tailwindcss/cli -i ./input.css -o ./public/index.css --watch
```

A small Makefile is sufficient (recipe lines use tabs):

```makefile
.PHONY: css css-watch

css:
	mkdir -p public
	npx @tailwindcss/cli -i ./input.css -o ./public/index.css --minify

css-watch:
	mkdir -p public
	npx @tailwindcss/cli -i ./input.css -o ./public/index.css --watch
```

Merge these targets into the existing Makefile without replacing unrelated targets. The watcher rebuilds CSS; it does not reload the browser or restart the application's development server.

For reproducible builds, pin an exact verified v4 CLI version: replace `@tailwindcss/cli` with `@tailwindcss/cli@<version>`. For noninteractive CI, use `npx --yes @tailwindcss/cli@<version> ...`. Replace the placeholder with a real release; do not invent a version or claim an unpinned command is reproducible.

### Fully Node-free alternative

Download the appropriate standalone executable from the official [Tailwind releases](https://github.com/tailwindlabs/tailwindcss/releases). Choose a pinned release and match the build machine's OS, CPU architecture, and, on Linux, libc. Make it executable on Unix and use it instead of `npx`:

```sh
./tools/tailwindcss -i ./input.css -o ./public/index.css --minify
./tools/tailwindcss -i ./input.css -o ./public/index.css --watch
```

The standalone binary includes Tailwind itself and supports `@import "tailwindcss"`. It does not automatically supply arbitrary third-party npm plugins; use existing local CSS imports where appropriate. Do not assume a macOS binary can run in a Linux Docker build.

## Detectable class names

Keep full utility names in scanned source. Tailwind does not execute Dart interpolation:

```dart
// Not detectable: the complete class name never appears in source.
final classes = 'bg-$color-600';

// Detectable: both complete utility names appear in source.
final classes = hasError ? 'bg-red-600' : 'bg-green-600';
```

Use maps or branches of complete strings for finite variants. For a small set of classes supplied outside scanned files, explicitly include them in the CSS entrypoint:

```css
@source inline("bg-red-600 bg-green-600");
```

Do not generate huge safelists to compensate for avoidable interpolation. For truly runtime values, use validated inline styles or CSS custom properties with a statically written utility, rather than expecting Tailwind to compile new classes per request or client-side state change.

## Serving and deployment

- Add a stylesheet link such as `<link rel="stylesheet" href="/index.css">` to the HTML entrypoint or shared document head. Match the actual asset URL and deployment base path; a root-relative URL may be wrong when hosted under a subpath. Include the viewport meta tag if absent. Follow the selected renderer reference for placement and markup syntax.
- For Dart backends, serve the generated asset with a CSS content type through the existing framework's static handler. Preserve route precedence and do not expose the entire project root. For client/static apps, ensure the hosting/build pipeline serves and packages that asset.
- HTMX fragments use the stylesheet already loaded by the document; they do not need their own stylesheet links or runtime Tailwind script.
- Build CSS before packaging production assets. Either build in CI/a dedicated build stage or include an up-to-date prebuilt file according to the project's policy. No CLI or Node runtime is needed on the production host or in the browser.
- A Dart compile alone will not regenerate CSS. Ensure the CSS build runs before the asset copy/package step, and check `.dockerignore`/artifact rules do not exclude the generated file.
- For backend serving, ensure static directory resolution matches the deployed working directory. For static hosting, verify the stylesheet URL against the deployment base path. Use the project's existing cache/versioning strategy so browsers do not retain stale CSS after deployment.

## Verification and troubleshooting

Run the build command and confirm the output exists and contains a known utility from the Dart UI. With the server running, request the stylesheet (for example, `curl -I http://localhost:8080/index.css`, adjusting the port) and check the status and content type. When possible, inspect the rendered page to verify the stylesheet loads and styles apply.

If a utility is missing, check complete class literals, `@source` paths relative to the input, whether the class's file is covered, and whether the watcher/build has run. If CSS exists but the page is unstyled, check the layout URL, static route, deployment asset copy, and browser cache before changing the Tailwind configuration.

References: [CLI installation](https://tailwindcss.com/docs/installation/tailwind-cli) · [Source detection](https://tailwindcss.com/docs/detecting-classes-in-source-files).
