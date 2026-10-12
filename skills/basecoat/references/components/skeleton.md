# Skeleton

- JavaScript: none (CSS only)

## Usage

Add `class="skeleton"` with sizing utilities to create loading placeholders.

```html
<div class="skeleton h-4 w-[150px]"></div>
```

## Examples

### Avatar

```html
<div class="flex items-center gap-4">
  <div class="skeleton size-10 shrink-0 rounded-full"></div>
  <div class="grid gap-2">
    <div class="skeleton h-4 w-[150px]"></div>
    <div class="skeleton h-4 w-[100px]"></div>
  </div>
</div>
```

### Card

```html
<div class="card w-full">
  <header>
    <div class="skeleton h-4 w-2/3"></div>
    <div class="skeleton h-4 w-1/2"></div>
  </header>
  <section> <div class="skeleton aspect-video w-full"></div></section>
</div>
```

### Text

```html
<div class="flex flex-col gap-2">
  <div class="skeleton h-4 w-full"></div>
  <div class="skeleton h-4 w-full"></div>
  <div class="skeleton h-4 w-3/4"></div>
</div>
```

### Form

```html
<div class="flex flex-col gap-7">
  <div class="flex flex-col gap-3">
    <div class="skeleton h-4 w-20"></div>
    <div class="skeleton h-10 w-full"></div>
  </div>
  <div class="flex flex-col gap-3">
    <div class="skeleton h-4 w-24"></div>
    <div class="skeleton h-10 w-full"></div>
  </div>
  <div class="skeleton h-9 w-24"></div>
</div>
```

### Table

```html
<div class="flex flex-col gap-2">
  <div class="flex gap-4">
    <div class="skeleton h-4 flex-1"></div>
    <div class="skeleton h-4 w-24"></div>
    <div class="skeleton h-4 w-20"></div>
  </div>
  <div class="flex gap-4">
    <div class="skeleton h-4 flex-1"></div>
    <div class="skeleton h-4 w-24"></div>
    <div class="skeleton h-4 w-20"></div>
  </div>
  <div class="flex gap-4">
    <div class="skeleton h-4 flex-1"></div>
    <div class="skeleton h-4 w-24"></div>
    <div class="skeleton h-4 w-20"></div>
  </div>
</div>
```
