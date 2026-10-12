# Scroll Area

- JavaScript: none (CSS only)

## Usage

Use `scrollbar` or `scrollbar-sm` on an element that already scrolls with `overflow-auto`, `overflow-y-auto`, or `overflow-x-auto`.

```html
<div class="scrollbar h-72 overflow-y-auto rounded-md border p-4">
  Your scrollable content here.
</div>
```

Use `scrollbar` or `scrollbar-sm` on an element that already scrolls with `overflow-auto`, `overflow-y-auto`, or `overflow-x-auto`.

The component class augments native scrolling for cross-browser styling. It does not wrap content, replace browser scroll behavior, or require JavaScript.

## Examples

These examples use Card as the framed surface so border and radius come from the active style pack.

### Horizontal

Use `scrollbar` with `overflow-x-auto` for horizontal scrolling.

```html
<div class="card w-full max-w-sm p-0">
  <div class="scrollbar overflow-x-auto">
    <div class="flex w-max gap-4 p-4">
      <figure class="shrink-0">
        <div class="aspect-[3/4] w-40 rounded-md bg-muted"></div>
        <figcaption class="text-muted-foreground pt-2 text-xs">Photo by Ornella Binni</figcaption>
      </figure>
      <figure class="shrink-0">
        <div class="aspect-[3/4] w-40 rounded-md bg-muted"></div>
        <figcaption class="text-muted-foreground pt-2 text-xs">Photo by Tom Byrom</figcaption>
      </figure>
      <figure class="shrink-0">
        <div class="aspect-[3/4] w-40 rounded-md bg-muted"></div>
        <figcaption class="text-muted-foreground pt-2 text-xs">Photo by Vladimir Malyavko</figcaption>
      </figure>
    </div>
  </div>
</div>
```

### Thin

Use `scrollbar-sm` for compact scrollable regions like menus, listboxes, sidebars, and command results.

```html
<div class="card w-full max-w-sm p-1">
  <div class="px-2 py-1.5 text-xs font-medium text-muted-foreground">Recent files</div>
  <div class="scrollbar-sm max-h-48 overflow-y-auto">
    <button type="button" class="flex w-full items-center justify-between rounded-sm px-2 py-1.5 text-sm hover:bg-accent">
      <span>project-roadmap.md</span>
      <span class="text-xs text-muted-foreground">2m</span>
    </button>
    <button type="button" class="flex w-full items-center justify-between rounded-sm px-2 py-1.5 text-sm hover:bg-accent">
      <span>release-notes.md</span>
      <span class="text-xs text-muted-foreground">8m</span>
    </button>
    <button type="button" class="flex w-full items-center justify-between rounded-sm px-2 py-1.5 text-sm hover:bg-accent">
      <span>api-contract.json</span>
      <span class="text-xs text-muted-foreground">16m</span>
    </button>
    <button type="button" class="flex w-full items-center justify-between rounded-sm px-2 py-1.5 text-sm hover:bg-accent">
      <span>pricing-table.html</span>
      <span class="text-xs text-muted-foreground">1h</span>
    </button>
    <button type="button" class="flex w-full items-center justify-between rounded-sm px-2 py-1.5 text-sm hover:bg-accent">
      <span>onboarding-flow.md</span>
      <span class="text-xs text-muted-foreground">2h</span>
    </button>
    <button type="button" class="flex w-full items-center justify-between rounded-sm px-2 py-1.5 text-sm hover:bg-accent">
      <span>settings-panel.ts</span>
      <span class="text-xs text-muted-foreground">3h</span>
    </button>
    <button type="button" class="flex w-full items-center justify-between rounded-sm px-2 py-1.5 text-sm hover:bg-accent">
      <span>invoice-template.html</span>
      <span class="text-xs text-muted-foreground">5h</span>
    </button>
  </div>
</div>
```
