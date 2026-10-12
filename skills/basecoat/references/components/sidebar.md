# Sidebar

- JavaScript: required — `basecoat-css/sidebar` (or the `all` bundle)
- Templates: ships a `sidebar()` macro for Jinja and Nunjucks — see [templates](../templates.md)

## Usage

Sidebar uses a native `<aside>` next to your page content. Basecoat owns the fixed positioning, overlay behavior, active states, nested lists, and `details` submenu styling. Your app still owns the navigation data and current route.

```html
<aside id="sidebar" class="sidebar" data-side="left">
  <nav aria-label="Sidebar navigation">
    <section class="scrollbar-sm">
      <div role="group" aria-labelledby="group-label-content-1">
        <h3 id="group-label-content-1">Getting started</h3>
        <ul>
          <li>
            <a href="#">
              <svg><!-- square-terminal --></svg>
              <span>Playground</span>
            </a>
          </li>
          <li>
            <a href="#">
              <svg><!-- bot --></svg>
              <span>Models</span>
            </a>
          </li>
          <li>
            <details id="submenu-content-1-3">
              <summary aria-controls="submenu-content-1-3-content"><svg><!-- settings --></svg>
                <span>Settings</span>
              </summary>
              <ul id="submenu-content-1-3-content">
                <li><a href="#"><span>General</span></a></li>
                <li><a href="#"><span>Team</span></a></li>
                <li><a href="#"><span>Billing</span></a></li>
                <li><a href="#"><span>Limits</span></a></li>
              </ul>
            </details>
          </li>
        </ul>
      </div>
    </section>
  </nav>
</aside>
<main>
  <button type="button" onclick="document.getElementById('sidebar')?.toggle()">Toggle sidebar</button>
  <h1>Content</h1>
</main>
```

### RTL

Set `dir="rtl"` on the sidebar or a parent element. Logical spacing, nested borders, and item content follow document direction. `data-side` is physical: `left` and `right` refer to viewport sides.

> **Differences with shadcn/ui**: Basecoat intentionally supports the stable HTML sidebar surface: fixed left/right sidebars, mobile overlay behavior, grouped navigation, active states, and native `details` submenus. It does not expose shadcn/ui's React provider, rail, inset/floating variants, icon-only collapse mode, menu actions, menu badges, or menu skeleton API.

### HTML structure

Basecoat maps shadcn/ui's sidebar composition to regular navigation HTML: an `<aside>` root, one `<nav>`, optional header/footer regions, grouped lists, item controls, and native `<details>` for nested menus.

- `<aside class="sidebar">` — Sidebar root. Supports `id`, `data-side="left|right"`, `data-initial-open="false"`, `data-initial-mobile-open="true"`, and `data-breakpoint`. JavaScript manages `aria-hidden`, `inert`, and the internal `data-sidebar-initialized` flag.
  - `<nav aria-label="...">` — Navigation landmark inside the sidebar.
    - `<header>` — Optional header for branding, workspace controls, user controls, or persistent actions.
    - `<section>` — Scrollable content region between the optional header and footer.
      - `<div role="group" aria-labelledby="...">` — Named navigation group. Use a heading element as the group label.
      - `<ul>` + `<li>` — Menu and menu item structure. Top-level lists and nested submenu lists receive different spacing and borders.
        - `<a>` / `<button>` — Menu item control. Use links for navigation and buttons for actions. Supports `data-variant="default|outline"`, `data-size="default|sm|lg"`, `data-active="true"`, `disabled` on buttons, and `aria-disabled="true"` on custom-disabled controls. For links, prefer `<a aria-current="page">` for the current page. Add `data-keep-mobile-sidebar-open` on a clicked link, button, or ancestor when that control should not close the mobile sidebar.
        - `<details>` / `<summary>` — Native disclosure for collapsible submenus. Put the nested `<ul>` directly after `<summary>`. The `<summary>` supports the same active, variant, and size attributes as menu item controls. Add `id` and `aria-controls` when the relationship is not obvious from nearby markup.
        - `<hr role="separator">` — Optional separator between groups or menu sections.
    - `<footer>` — Optional footer for account controls, status, or persistent actions.
- `<main>` — Sibling content wrapper. The desktop margin applies to the sibling immediately after the sidebar.

Set `--sidebar-width` and `--sidebar-mobile-width` on `:root` or the sidebar root to override the default `16rem` desktop width and `18rem` mobile width.

### JavaScript API

| API | Type | Description |
| --- | --- | --- |
| `sidebar.open()` | Method | Opens the sidebar. |
| `sidebar.close()` | Method | Closes the sidebar. |
| `sidebar.toggle()` | Method | Toggles the sidebar. |
