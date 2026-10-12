# Breadcrumb

- JavaScript: none (CSS only)

## Usage

Use a navigation landmark with an ordered list. Mark the current page with `aria-current="page"`.

```html
<nav class="breadcrumb" aria-label="Breadcrumb">
  <ol>
    <li><a href="#">Home</a></li>
    <li aria-hidden="true"><svg data-rtl-flip><!-- chevron-right --></svg></li>
    <li><span aria-current="page">Breadcrumb</span></li>
  </ol>
</nav>
```

## HTML structure

- `nav.breadcrumb` is the root landmark and should include `aria-label="Breadcrumb"`.
- `ol` contains the breadcrumb items in hierarchy order.
- `li > a` represents navigable ancestors.
- `li[aria-hidden="true"]` represents a visual separator.
- `[aria-current="page"]` represents the current page.
- `li > span[aria-hidden="true"]` represents a collapsed ellipsis.

## Examples

### Basic

```html
<nav class="breadcrumb" aria-label="Breadcrumb">
  <ol>
    <li><a href="#">Home</a></li>
    <li aria-hidden="true"><svg data-rtl-flip><!-- chevron-right --></svg></li>
    <li><a href="#">Components</a></li>
    <li aria-hidden="true"><svg data-rtl-flip><!-- chevron-right --></svg></li>
    <li><span aria-current="page">Breadcrumb</span></li>
  </ol>
</nav>
```

### Custom separator

```html
<nav class="breadcrumb" aria-label="Breadcrumb">
  <ol>
    <li><a href="#">Home</a></li>
    <li aria-hidden="true"><svg><!-- dot --></svg></li>
    <li><a href="#">Components</a></li>
    <li aria-hidden="true"><svg><!-- dot --></svg></li>
    <li><span aria-current="page">Breadcrumb</span></li>
  </ol>
</nav>
```

### Dropdown

```html
<nav class="breadcrumb" aria-label="Breadcrumb">
  <ol>
    <li><a href="#">Home</a></li>
    <li aria-hidden="true"><svg data-rtl-flip><!-- chevron-right --></svg></li>
    <li>
      <div id="breadcrumb-dropdown" class="dropdown-menu">
        <button type="button" id="breadcrumb-dropdown-trigger" class="btn" data-variant="ghost" data-size="icon-sm" aria-haspopup="menu" aria-controls="breadcrumb-dropdown-menu" aria-expanded="false"><svg><!-- ellipsis --></svg>
          <span class="sr-only">Toggle menu</span>
        </button>
        <div id="breadcrumb-dropdown-popover" data-popover aria-hidden="true">
          <div role="menu" id="breadcrumb-dropdown-menu" aria-labelledby="breadcrumb-dropdown-trigger">
            <nav role="menu">
              <button type="button" role="menuitem">Documentation</button>
              <button type="button" role="menuitem">Themes</button>
              <button type="button" role="menuitem">GitHub</button>
            </nav>
          </div>
        </div>
      </div>
    </li>
    <li aria-hidden="true"><svg data-rtl-flip><!-- chevron-right --></svg></li>
    <li><a href="#">Components</a></li>
    <li aria-hidden="true"><svg data-rtl-flip><!-- chevron-right --></svg></li>
    <li><span aria-current="page">Breadcrumb</span></li>
  </ol>
</nav>
```

### Collapsed

```html
<nav class="breadcrumb" aria-label="Breadcrumb">
  <ol>
    <li><a href="#">Home</a></li>
    <li aria-hidden="true"><svg data-rtl-flip><!-- chevron-right --></svg></li>
    <li> <span aria-hidden="true"><svg><!-- ellipsis --></svg></span></li>
    <li aria-hidden="true"><svg data-rtl-flip><!-- chevron-right --></svg></li>
    <li><a href="#">Components</a></li>
    <li aria-hidden="true"><svg data-rtl-flip><!-- chevron-right --></svg></li>
    <li><span aria-current="page">Breadcrumb</span></li>
  </ol>
</nav>
```
