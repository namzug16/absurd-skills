# Pagination

- JavaScript: none (CSS only)

> **No dedicated component**: There is no dedicated pagination component in Basecoat.

## Usage

A pagination is fairly simple to implement with Tailwind using the Basecoat button classes:

```html
<nav role="navigation" aria-label="pagination" class="mx-auto flex w-full justify-center">
  <ul class="flex flex-row items-center gap-1">
    <li>
      <a href="#" class="btn" data-variant="ghost">
        <svg><!-- chevron-left --></svg>
        Previous
      </a>
    </li>
    <li><a href="#" class="btn" data-variant="ghost" data-size="icon">1</a></li>
    <li><a href="#" class="btn" data-variant="outline" data-size="icon">2</a></li>
    <li><a href="#" class="btn" data-variant="ghost" data-size="icon">3</a></li>
    <li><div class="size-9 flex items-center justify-center"><svg class="size-4 shrink-0"><!-- ellipsis --></svg></div></li>
    <li>
      <a href="#" class="btn" data-variant="ghost">
        Next
        <svg><!-- chevron-right --></svg>
      </a>
    </li>
  </ul>
</nav>
```

