---
name: basecoat
description: Build UIs with Basecoat (basecoat-css), the shadcn/ui-style component library for plain HTML and Tailwind CSS with no React. Use this skill whenever a project uses or should use Basecoat - when `basecoat-css` appears in package.json, a CSS import, or a CDN link; when the user mentions Basecoat, basecoatui.com, or "shadcn without React"; or when writing or editing HTML, Jinja, Nunjucks, Django, Flask, Rails, Laravel, Phoenix, HTMX, Alpine, or Astro templates in such a project - buttons, forms, dialogs, dropdowns, selects, tabs, sidebars, toasts, cards, tables, themes, dark mode. Read it before writing any Basecoat markup, because the 1.0 API (data-variant / data-size attributes and semantic child elements) differs from the pre-1.0 class names you may remember.
metadata:
  version: 1.0.x
  source: https://github.com/hunvreus/basecoat/tree/main/site/src/docs
---

# Basecoat 1.0

Basecoat is a CSS component library for Tailwind CSS v4 that brings the shadcn/ui design system to any stack: plain HTML, server-rendered templates, HTMX, or any JS framework. It ships as one npm package, `basecoat-css`, containing CSS, a small amount of vanilla JavaScript for interactive components, and optional Jinja/Nunjucks macros.

## How Basecoat markup works

Basecoat's public API is deliberately small. Almost every component follows the same four rules, and knowing them is most of what you need:

1. **One root class.** `btn`, `card`, `dialog`, `field`, `tabs`, `select`, ... goes on the root element.
2. **Variants and sizes are data attributes**, not classes: `data-variant="outline"`, `data-size="sm"`. Omit the attribute for the default.
3. **Children are semantic HTML, not classes.** A card is `<div class="card">` containing `<header>`, `<section>`, `<footer>`; the title is the `<h2>` inside the header. Basecoat styles children by element and position, so the element type and nesting matter. A `<div>` where a `<section>` is expected simply goes unstyled.
4. **State is native or ARIA.** `disabled`, `checked`, `open`, `aria-invalid="true"`, `aria-selected`, `aria-current="page"`, `aria-disabled="true"`. Basecoat styles off these, so setting them correctly is what makes the component look right.

```html
<div class="card">
  <header>
    <h2>Team settings</h2>
    <p>Manage who can access this workspace.</p>
  </header>
  <section>
    <div role="group" class="field">
      <label for="team-name">Name</label>
      <input id="team-name" type="text" />
    </div>
  </section>
  <footer>
    <button type="button" class="btn" data-variant="outline">Cancel</button>
    <button type="button" class="btn">Save</button>
  </footer>
</div>
```

### Pre-1.0 class names no longer exist

Earlier Basecoat versions (and most examples in the wild) used compound variant classes. They do nothing in 1.0 unless the `compat` stylesheet is loaded, so translate them:

| Pre-1.0 | 1.0 |
| --- | --- |
| `btn-outline`, `btn-secondary`, `btn-ghost`, `btn-link`, `btn-destructive` | `class="btn" data-variant="outline"` etc. (`btn-primary` is just `btn`) |
| `btn-sm`, `btn-lg`, `btn-icon` | `class="btn" data-size="sm"` / `"lg"` / `"icon"` |
| `btn-sm-outline`, `btn-sm-icon-ghost`, ... | `class="btn" data-variant="..." data-size="sm"` / `"icon-sm"` |
| `badge-secondary`, `badge-outline`, `badge-destructive` | `class="badge" data-variant="..."` |
| `alert-destructive` | `class="alert" data-variant="destructive"` |
| `basecoat-cli` | removed; templates ship inside `basecoat-css` |

If you are editing a project that still uses the old classes, match what is there and mention the migration path ([installation](./references/installation.md#migrating-from-pre-10)) rather than silently mixing both styles.

## Workflow

1. **Check the setup.** Look for `basecoat-css` in `package.json`, the CSS entry file, or a CDN `<link>`. Note the version, the style bundle in use, and whether JavaScript is loaded (`all` bundle or individual scripts). If Basecoat is not installed, read [installation](./references/installation.md).
2. **Pick components by function, not by name.** Scan the catalog below for what the request needs. A "modal" is `dialog`; a "confirm prompt" is `alert-dialog`; a "toggle" is `switch`; an "autocomplete" is `combobox`; "nav on the left" is `sidebar`. When two candidates could fit, read both references before choosing.
3. **Read the reference for every component you use** in `references/components/`. The files are short and contain the exact HTML structure, attributes, and JavaScript API. Interactive components in particular need specific roles, ids, and `aria-*` wiring that are impractical to guess, and their scripts silently do nothing when the structure is off.
4. **Load the JavaScript a component needs.** The catalog marks components that need it. If the project loads individual scripts rather than the `all` bundle, add the runtime plus that component's script.
5. **Lay out with Tailwind utilities.** Basecoat styles components; page layout, spacing, and grids are plain Tailwind (`flex`, `grid`, `gap-4`, `max-w-*`), with responsive prefixes where the layout should adapt.

## References

| Read | When |
| --- | --- |
| [references/installation.md](./references/installation.md) | Basecoat is not set up yet, you need a CDN snippet, a CSS/JS import path, the JS lifecycle (`initAll`) for HTMX/Turbo, or the pre-1.0 migration layer. |
| [references/customization.md](./references/customization.md) | Choosing a style pack, theming with shadcn/ui tokens, fonts, icons, dark mode, custom style packs, and the token reference. |
| [references/templates.md](./references/templates.md) | The project renders with Jinja or Nunjucks and you want the bundled macros (`select()`, `dialog()`, `toast()`, ...). |
| [references/components/](./references/components/) | Before using any component. One file per component. |

## Component catalog

`JS` marks components whose behavior needs Basecoat JavaScript. Everything else is CSS only.

### Actions and navigation

| Component | Root | Use for |
| --- | --- | --- |
| [button](./references/components/button.md) | `.btn` | Actions and links styled as buttons; variants, sizes, icon buttons. |
| [button-group](./references/components/button-group.md) | `.button-group` | Joined buttons, split buttons, buttons joined to inputs or menus. |
| [dropdown-menu](./references/components/dropdown-menu.md) `JS` | `.dropdown-menu` | Action menus, context actions, checkbox/radio menu items, shortcuts. |
| [command](./references/components/command.md) `JS` | `.command`, `.command-dialog` | Command palette, searchable action list (⌘K). |
| [breadcrumb](./references/components/breadcrumb.md) | `.breadcrumb` | Hierarchy trail. |
| [pagination](./references/components/pagination.md) | (uses `.btn`) | Page navigation; a pattern, not a dedicated component. |
| [tabs](./references/components/tabs.md) `JS` | `.tabs` | Switching panels in place; default and line variants, vertical. |
| [sidebar](./references/components/sidebar.md) `JS` | `.sidebar` | App navigation rail with groups, submenus, mobile overlay. |

### Forms

| Component | Root | Use for |
| --- | --- | --- |
| [field](./references/components/field.md) | `.field`, `.fieldset` | Label + control + help/error layout. The wrapper for almost every form control. |
| [label](./references/components/label.md) | `.label` | Standalone label outside a field. |
| [input](./references/components/input.md) | `.input` | Text-like inputs, file inputs. |
| [input-group](./references/components/input-group.md) | `.input-group` | Input with icons, text, buttons, or kbd addons inside one shell. |
| [textarea](./references/components/textarea.md) | `.textarea` | Multi-line text. |
| [checkbox](./references/components/checkbox.md) | `input[type=checkbox].input` | Checkboxes. |
| [radio-group](./references/components/radio-group.md) | `input[type=radio].input` | Mutually exclusive options. |
| [switch](./references/components/switch.md) | `input[type=checkbox][role=switch].input` | On/off toggles. |
| [slider](./references/components/slider.md) `JS` | `input[type=range].input` | Single-thumb range. |
| [native-select](./references/components/native-select.md) | `select.select` | Native `<select>`; best default for simple lists and mobile. |
| [select](./references/components/select.md) `JS` | `div.select` | Custom select: rich option content, groups, multiple selection. |
| [combobox](./references/components/combobox.md) `JS` | `.combobox` | Filterable select / autocomplete, chips for multiple values. |

### Overlays and feedback

| Component | Root | Use for |
| --- | --- | --- |
| [dialog](./references/components/dialog.md) | `dialog.dialog` | Modal with arbitrary content. Native `<dialog>` + `showModal()`. |
| [alert-dialog](./references/components/alert-dialog.md) | `dialog.alert-dialog` | Confirmation that requires an explicit choice. |
| [drawer](./references/components/drawer.md) `JS` (beta) | `dialog.drawer` | Panel sliding in from an edge. |
| [popover](./references/components/popover.md) `JS` | `.popover` | Floating panel anchored to a trigger, arbitrary content. |
| [tooltip](./references/components/tooltip.md) | `[data-tooltip]` | Text-only hint on hover/focus. |
| [toast](./references/components/toast.md) `JS` | `.toaster`, `.toast` | Transient notifications, from markup or `toaster.toast({...})`. |
| [alert](./references/components/alert.md) | `.alert` | Inline callout or error message. |
| [progress](./references/components/progress.md) | `.progress` | Determinate progress bar. |
| [spinner](./references/components/spinner.md) | (svg + `animate-spin`) | Indeterminate loading. |
| [skeleton](./references/components/skeleton.md) | `.skeleton` | Loading placeholder shapes. |
| [empty](./references/components/empty.md) | `.empty` | Empty state with icon, text, actions. |

### Display

| Component | Root | Use for |
| --- | --- | --- |
| [card](./references/components/card.md) | `.card` | Grouped content surface with header/section/footer. |
| [item](./references/components/item.md) | `.item`, `.item-group` | List rows: media + title + description + actions. |
| [table](./references/components/table.md) | `.table`, `.table-container` | Data tables. |
| [accordion](./references/components/accordion.md) `JS` | `.accordion` | Collapsible sections on native `<details>`. |
| [avatar](./references/components/avatar.md) | `.avatar`, `.avatar-group` | User images with fallback, badges, stacks. |
| [badge](./references/components/badge.md) | `.badge` | Status labels, counts, tags. |
| [kbd](./references/components/kbd.md) | `.kbd` | Keyboard key labels. |
| [scroll-area](./references/components/scroll-area.md) | `.scrollbar`, `.scrollbar-sm` | Styled scrollbars on an element that already scrolls. |
| [chart](./references/components/chart.md) `JS` (beta) | `window.basecoat.chart()` | Themed Chart.js charts. Needs Chart.js loaded separately. |
| [theme-switcher](./references/components/theme-switcher.md) | `window.basecoat.theme` | Light/dark toggle. |

There is no dedicated component for things like navbar, hero, footer, stepper, calendar/date picker, carousel, or rating. Build those from Tailwind utilities plus the pieces above (for example `btn`, `card`, `dropdown-menu`) and theme tokens, rather than inventing class names like `navbar` that Basecoat does not define.

## Rules of thumb

- **Use token colors so themes and dark mode work.** `bg-background`, `text-foreground`, `text-muted-foreground`, `bg-muted`, `border-border`, `bg-primary text-primary-foreground`, `text-destructive`. These flip automatically in dark mode. A fixed palette color such as `text-gray-600` or `bg-white` stays the same in both themes and usually becomes unreadable in one of them. Use fixed colors only when a color must not change, and pair them with a `dark:` variant.
- **Dark mode is the `dark` class on `<html>`.** It is not driven by `prefers-color-scheme` unless the page adds the small script from [theme-switcher](./references/components/theme-switcher.md).
- **Default to the default variant.** Reserve the primary `btn` for the main action in a view and use `outline`, `secondary`, or `ghost` for the rest, as shadcn/ui does. Do not add a variant the user did not ask for just to add color.
- **Customize with utilities on the root, tokens for everything broad.** `<button class="btn w-full rounded-full">` is fine. For a project-wide change, override a token or pick another style pack instead of repeating utilities everywhere or writing CSS against Basecoat's internals. See [customization](./references/customization.md).
- **Icons are inline SVG.** Basecoat bundles none. The docs use [Lucide](https://lucide.dev/icons); the references show icons as `<svg><!-- icon-name --></svg>` placeholders, so substitute the real SVG (or the project's icon helper). Components size direct-child SVGs for you, so no `size-*` class is needed inside a `btn`, `alert`, or menu item. Add `data-icon="inline-start"` or `"inline-end"` on an icon next to text in a button or badge, and `aria-label` on icon-only buttons.
- **Forms go through `field`.** Inside `<div role="group" class="field">`, a bare `<label>`, `<input>`, `<select>`, `<textarea>`, and helper `<p>` are styled automatically, with no `input`/`label` classes needed. For errors set `data-invalid` on the field and `aria-invalid="true"` on the control.
- **Dialogs are native.** Open with `document.getElementById(id).showModal()`, close with `.close()` or `<form method="dialog">`. No Basecoat JavaScript is involved for `dialog` and `alert-dialog`.
- **Overlays are positioned inline, not portalled.** Popovers, dropdown menus, selects, and comboboxes render next to their trigger, so an ancestor that clips overflow cuts them off. Two Basecoat components do this themselves: `.table-container` (horizontal scroll) and `.card` (`overflow-hidden` for its rounded corners). Leave a table with row menus out of `.table-container`, and add `overflow-visible` to a card whose popup needs to extend past its edge.
- **Menu and list items are styled by role, not by element.** `role="menuitem"` and `role="option"` work on `<div>`, `<a>`, or `<button>`, so a menu item that navigates can be a real link.
- **Ids must be unique and wired.** Interactive components link trigger, popup, and items through `id`, `aria-controls`, and `aria-labelledby`. When rendering one in a loop, derive the ids from the loop item.
- **Dynamically inserted HTML** is initialized automatically. Call `window.basecoat.initAll()` only after inserting markup in a way the runtime cannot observe, and `initAll({ force: true })` after a history-cache restore.
- **Server-rendered templates:** in Jinja or Nunjucks projects, check whether the Basecoat macros have been copied in (commonly `templates/basecoat/`) and prefer them for the large components; see [templates](./references/templates.md).

## When Basecoat is not installed

Do not add Basecoat to a project that uses another UI kit (daisyUI, Flowbite, Bootstrap, shadcn/ui with React) unless the user asks; the class names collide (`btn`, `card`, `badge`, `alert`, `input`, `select`, `tabs`). For a new or unstyled Tailwind project where the user wants Basecoat, follow [installation](./references/installation.md), using npm when a Tailwind build exists and the CDN for standalone HTML files.
