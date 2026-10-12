# Empty

- JavaScript: none (CSS only)

## Usage

Add `class="empty"` to a semantic container. The component styles common children like `header`, `figure`, headings, descriptions, and `footer`.

```html
<section class="empty">
  <header>
    <figure><svg><!-- folder-code --></svg></figure>
    <h3>No Projects Yet</h3>
    <p>You haven't created any projects yet. Get started by creating your first project.</p>
  </header>
  <footer>
    <div class="flex gap-2">
      <button class="btn">Create Project</button>
      <button class="btn" data-variant="outline">Import Project</button>
    </div>
    <a href="#" class="btn text-muted-foreground" data-variant="link" data-size="sm">
      Learn More
<svg><!-- arrow-up-right --></svg>
    </a>
  </footer>
</section>
```

### HTML structure

- `<section class="empty">` — The empty-state container.
  - `<header>` — Groups the media, title, and description.
    - `<figure>` *(optional)* — Icon, avatar, image, or avatar group. An icon-only figure is styled automatically with `:has(> svg:only-child)`.
    - `<h2>`, `<h3>`, or `<h4>` — The empty-state title.
    - `<p>` *(optional)* — The empty-state description.
  - `<section>` or `<footer>` *(optional)* — Actions and supporting content.

## Examples

### Outline

```html
<section class="empty border border-dashed">
  <header>
    <figure><svg><!-- cloud --></svg></figure>
    <h3>Cloud Storage Empty</h3>
    <p>Upload files to your cloud storage to access them anywhere.</p>
  </header>
  <footer>
    <button class="btn" data-variant="outline" data-size="sm">Upload Files</button>
  </footer>
</section>
```

### Background

```html
<section class="empty h-full bg-muted/30">
  <header>
    <figure><svg><!-- bell --></svg></figure>
    <h3>No Notifications</h3>
    <p class="max-w-xs text-pretty">You're all caught up. New notifications will appear here.</p>
  </header>
  <footer>
    <button class="btn" data-variant="outline"><svg><!-- refresh-ccw --></svg>
      Refresh
    </button>
  </footer>
</section>
```

### Avatar

```html
<section class="empty">
  <header>
    <figure class="size-12 rounded-full">
      <img class="grayscale" alt="@shadcn" src="https://github.com/shadcn.png" />
    </figure>
    <h3>User Offline</h3>
    <p>This user is currently offline. You can leave a message to notify them or try again later.</p>
  </header>
  <footer>
    <button class="btn" data-size="sm">Leave Message</button>
  </footer>
</section>
```

### Avatar group

```html
<section class="empty">
  <header>
    <figure class="-space-x-2 [&_img]:ring-background [&_img]:ring-2 [&_img]:grayscale [&_img]:size-12 [&_img]:rounded-full">
      <img alt="@shadcn" src="https://github.com/shadcn.png" />
      <img alt="@maxleiter" src="https://github.com/maxleiter.png" />
      <img alt="@evilrabbit" src="https://github.com/evilrabbit.png" />
    </figure>
    <h3>No Team Members</h3>
    <p>Invite your team to collaborate on this project.</p>
  </header>
  <footer>
    <button class="btn" data-size="sm"><svg><!-- plus --></svg>
      <span>Invite Members</span>
    </button>
  </footer>
</section>
```

### Input group

```html
<section class="empty">
  <header>
    <h3>404 - Not Found</h3>
    <p>The page you're looking for doesn't exist. Try searching for what you need below.</p>
  </header>
  <footer>
    <div class="input-group sm:w-3/4">
      <input type="search" placeholder="Try searching for pages..." />
      <span data-align="start" aria-hidden="true"><svg><!-- search --></svg></span>
      <span data-align="end"><kbd class="kbd">/</kbd></span>
    </div>
    <p>Need help? <a href="#">Contact support</a></p>
  </footer>
</section>
```
