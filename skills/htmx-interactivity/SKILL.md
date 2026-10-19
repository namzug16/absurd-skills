---
name: htmx-interactivity
description: >-
  Build complete HTMX interactions: button spinners, disabled submit states,
  skeleton loading with same-endpoint query parameters, hx-boost navigation,
  optional preload extension, error/retry states, request synchronization,
  and version-aware local UI behavior with hx-live for HTMX 4.
  Use whenever implementing or reviewing an HTMX page, form, button, navigation,
  lazy-loaded dashboard, search, filters, or pagination—even when the user only
  asks for the feature and does not explicitly ask for loading feedback.
  Detect the project's HTMX version before choosing APIs; examples target 2.x.
---

# HTMX Interactivity

Ship the interaction, not just the successful response. Every network-backed UI
needs visible pending feedback, a successful/empty result, and a recoverable error.
Use server-rendered HTML and HTMX attributes first; add small shared JavaScript
only for behavior HTMX does not supply, such as transport-error presentation.

## Start here

1. Inspect the installed core, extensions, layout, request helpers, and server
   rendering conventions. Keep the project's version; do not upgrade it as a side
   effect. Examples target **HTMX 2.x**, including 2.0.8. For 4.x or another version,
   verify equivalent APIs and extension compatibility; do not mix versioned APIs.
2. Identify the request owner, swap target, response shape, pending state, URL
   behavior, and failure recovery before writing the handler.
3. Reuse existing styles, icons, CSRF protection, and accessible components.
   Do not install a frontend framework or loading-state library.
4. Implement feedback as part of the feature, not as an optional follow-up.

### Read only the relevant reference

- HTMX 2.x lazy-region failures: [Failure handling](references/failures.md).
- Local UI state, HTMX 4, or hx-live: [HTMX 4 and local behavior](references/htmx4-local-behavior.md).
  Read this before translating any 2.x examples; this is not a migration request.
- Inline editing, dependent selects, validation races, bulk actions, cross-region
  updates, or upload/job progress: [Interaction recipes](references/interaction-recipes.md).

## Choose the loading pattern

| Interaction | Default |
| --- | --- |
| Submit, save, delete, refresh | Local spinner/loading text and disable the action during the request |
| Slow data-heavy page | Fast layout + structural skeleton, then lazy content from the same route |
| Fast page or SEO-critical content | Render content immediately; do not add a second request just for a skeleton |
| Internal page navigation | Boost normal links; retain real `href` values |
| Search, filters, pagination | Keep existing results visible, show local loading, coordinate overlapping requests |
| Likely next navigation | Consider selective preload after measuring and reviewing cache safety |

Skeletons improve perceived responsiveness, not backend execution time. Avoid
flashing placeholders for cheap work, blanking useful results on every refresh,
or inventing delays to make animations visible.

## 1. Same-route skeleton loading

Use one page handler and a reserved query parameter, for example `_content=1`.
Keep normal parameters (filters, sorting, page, tenant context) intact using the
language's URL/query builder. Replace an existing `_content` value rather than
concatenating strings or creating duplicate keys.

### Response contract for `GET /reports?page=2`

| Request | Response |
| --- | --- |
| Normal navigation, no `_content` | Full document: layout, heading, structural skeleton, lazy loader |
| Boosted navigation, no `_content` | Same document; HTMX swaps its body by default |
| `HX-Request: true`, `_content=1`, not boosted or history restore | Only the loaded content region |
| Direct navigation to `?_content=1` | Full document containing loaded content, not a bare fragment |
| `HX-History-Restore-Request: true` | Full document, never a content-only response |

Framework-neutral handler pseudocode:

```text
handleReports(request):
    user = requireAuthorizedUser(request)  // all branches, including preload
    wantsContent = request.query["_content"] == "1"
    isFragment = wantsContent
                 and request.header("HX-Request") == "true"
                 and request.header("HX-Boosted") != "true"
                 and request.header("HX-History-Restore-Request") != "true"

    if wantsContent:
        data = loadReports(user, validatedFilters(request.query))
        region = renderReportsRegion(data)  // includes empty state if needed
    else:
        region = renderReportsSkeleton(contentUrlFrom(request.url))

    if isFragment:
        return html(region)
    return html(renderDocument(title="Reports", region=region))
```

The skeleton branch must not run the slow query. Share the existing data loader
and loaded-region renderer; do not create another controller, API route, generic
loading abstraction, or JSON client fetch just for the skeleton. The query
parameter selects rendering/work, not authorization.

### Initial region inside the document

```html
<h1>Reports</h1>
<section id="reports-content" aria-label="Report results" aria-busy="true"
         hx-get="/reports?page=2&amp;_content=1" hx-trigger="load"
         hx-target="this" hx-swap="outerHTML" hx-push-url="false">
  <p role="status">Loading reports…</p>
  <div class="report-skeleton" aria-hidden="true">
    <div class="skeleton-card"></div>
    <div class="skeleton-row"></div>
    <div class="skeleton-row"></div>
  </div>
  <noscript><a href="/reports?page=2&amp;_content=1">View reports</a></noscript>
</section>
```

Implement these illustrative skeleton classes with the project's design system.
Reserve approximately the final cards/table dimensions to limit layout shift;
hide decorative blocks from assistive technology and honor reduced motion.
Keep navigation, headings, and useful actions real rather than an empty body.

### Loaded content response

```html
<section id="reports-content" aria-label="Report results" aria-busy="false">
  <!-- Actual server-rendered cards/table, or a useful empty state. -->
</section>
```

Return the **same ID** with `outerHTML`, and omit the automatic `load` trigger
from the loaded response to prevent a fetch loop. For `innerHTML`, return children
and explicitly clear the surviving wrapper's busy state. Prefer a normal swap
over `hx-swap="none"` plus OOB updates for one region.

Keep `_content` out of navigation links, canonicals, and browser history. The
second request must not push a URL. Preserve user-facing filter/page state
separately when updating history. The `noscript` link loads data in a complete
document from the same route; a skeleton alone is not a working no-JS fallback.

## 2. Buttons and forms need local feedback

HTMX adds `htmx-request` to the requesting element by default. `hx-indicator`
changes where that class goes; it does **not** disable anything. Use
`hx-disabled-elt` to prevent repeated activation. Place the spinner under the
element actually receiving `htmx-request`.

```html
<form id="profile-form" action="/profile" method="post"
      hx-post="/profile" hx-target="#profile-result"
      hx-indicator="this" hx-disabled-elt="find button[type='submit']">
  <!-- Include the project's CSRF token and labeled inputs here. -->
  <button type="submit">
    <span>Save profile</span>
    <span class="htmx-indicator" role="status">
      <svg class="request-spinner" aria-hidden="true" viewBox="0 0 24 24"
           width="16" height="16" fill="none" stroke="currentColor">
        <circle cx="12" cy="12" r="9" opacity=".25"></circle>
        <path d="M12 3a9 9 0 0 1 9 9"></path>
      </svg>
      <span class="sr-only">Saving…</span>
    </span>
  </button>
</form>
<div id="profile-result" aria-live="polite"></div>
```

Supply the project's `sr-only` utility and spinner animation, honoring reduced
motion. Default HTMX indicator CSS hides the spinner while reserving its space
to avoid a width jump. With strict CSP, disable injected indicator styles and
host equivalent CSS; do not silently add inline scripts.

For a standalone button, put `hx-disabled-elt="this"` and `hx-indicator="this"`
on it, with an indicator inside and an explicit swap target. Explicit `this`
overrides inherited global indicators that could keep its local spinner hidden.
A form owns its submit request, not its button; a button-only request class
does not provide reliable form loading feedback.

- Keep a meaningful accessible name during loading; label icon-only actions.
  Merely lowering opacity is not a loading indicator.
- Disable only relevant actions, not unrelated navigation or the entire UI.
  Do not disable inputs before serialization and lose submitted values.
- For multiple submit actions, preserve which action was selected and scope the
  indicator rather than animating every submit button.
- HTMX cleans up request classes and disabled states; test failures too. Client
  disabling does not replace server-side idempotency for duplicate-sensitive work.
- Return visible success/validation feedback, not just a disappearing spinner.

## 3. Boost page navigation

Enhance normal links within an intentional navigation boundary:

```html
<nav aria-label="Main" hx-boost="true" hx-indicator="#navigation-pending">
  <a href="/reports">Reports</a>
  <a href="/customers">Customers</a>
  <a href="/exports/report.csv" download hx-boost="false">Download CSV</a>
</nav>
<span id="navigation-pending" class="htmx-indicator" role="status">
  Loading page…
</span>
```

Boost navigation **into** the skeleton document, not just its later data fetch.
Boosted anchors push the destination URL and default to replacing the body's
inner HTML. Full documents are the simplest compatible server response; do not
treat every `HX-Request` as a content-fragment request.

- Scope boost to navigation first. Whole-body boost also affects forms and needs
  a form/redirect audit. In HTMX 2.0.8 boosted forms do not push history by default;
  set history behavior explicitly when needed and verify the project's version.
- Keep document rendering for refresh, pasted URLs, new tabs, and history cache
  misses. Handle history-restore headers before ordinary fragment logic.
- Default body swaps update navigation and headings together. If deliberately
  using `hx-target="#main"` + `hx-select="#main"`, keep that element on every
  page and update title, active navigation, and announcements as needed. Do not
  leak the navigation's `hx-select` onto nested fragment requests.
- Opt out downloads, incompatible pages, auth/OAuth handoffs, and flows requiring
  a real browser navigation with `hx-boost="false"` where appropriate.
- Load shared assets once in the head. Body replacement is not a full navigation:
  do not depend solely on `DOMContentLoaded` for widgets. Make post-swap
  initialization idempotent and clean up listeners/widgets.
- Preserve visible focus, focus the new main heading when appropriate, and
  verify scrolling, titles, and Back/Forward behavior.

## 4. Preload is optional, not magic

Load the version-compatible **preload extension** after core and enable it with
`hx-ext="preload"`. Pin or vendor it using existing asset conventions; core does
not include it. Do not copy unversioned CDN URLs into production.

```html
<nav hx-boost="true" hx-ext="preload">
  <a href="/reports" preload="mousedown">Reports</a>
</nav>
```

Start with `mousedown`; consider `mouseover` for likely destinations only when
speculative server cost is acceptable. Never preload mutations or unsafe GETs.

**Preloading a skeleton document does not execute its `hx-trigger="load"`.** It
warms only that document; content fetching still starts after insertion. Do not
promise to eliminate the data waterfall. First ship boost + skeleton loading.
Only add deliberate content warming when measurement justifies it and the real
content request can reuse the same URL, representation, and cache semantics.
Do not add a second content endpoint just for preload.

The extension relies on browser HTTP caching, not guaranteed in-memory response
storage. Verify hits in the network panel. `no-store` prevents reuse; `no-cache`
requires revalidation. Do not weaken sensitive-response caching for preload.
If authenticated caching is acceptable, use an explicit short-lived **private**
policy and review stale-data/logout behavior; never publicly cache per-user data.
Add appropriate `Vary` headers when responses differ by HTMX request headers,
even though `_content` separates URLs. Do not change response shape based on
`HX-Preloaded` unless the actual navigation can reuse that exact representation.

## 5. Errors, retries, and overlapping requests

- Skeleton failure must clear busy feedback and replace placeholders with an
  accessible error and explicit retry to the same `_content=1` URL. Keep unrelated
  content usable; no infinite skeleton, silent blank region, or endless retries.
- HTMX 2.x does not swap most 4xx/5xx responses by default. Handle server errors,
  transport failures, and timeouts with existing shared handlers. See
  [Failure handling](references/failures.md) for a small implementation pattern.
  Returning error HTML with status 500 alone is insufficient.
- Handle validation status 422 deliberately (scoped `beforeSwap` or compatible
  response handling configuration). Preserve values and show errors; do not
  globally turn all HTTP errors into successful swaps.
- Handle expired sessions deliberately rather than inserting a login document
  into a data region. HTMX response headers on 302s are not processed normally;
  follow the app's auth flow, e.g. `HX-Redirect` on an appropriate non-3xx response.
- Debounce search (e.g. `input changed delay:300ms, search`) and coordinate
  competing requests using `hx-sync` on a shared owner: `replace` for latest-query
  wins, `drop` for duplicate work, queues only when each action needs processing.
  Verify different controls targeting one region share a synchronization scope.
- Keep existing rows during refresh/filtering with nearby pending feedback;
  reserve full skeletons for initially missing content.

## 6. Decide whether the interaction needs a request

Use native HTML first (`details`, `dialog`, `popover`, native form constraints),
then CSS, then a small local event handler or the project's existing UI library.
Use hx-live in HTMX 4 when derived local state materially simplifies the feature;
do not install it just to display HTMX's existing request indicators.

- Local behavior: reveal a panel, count characters, enable a bulk-action toolbar,
  preview a choice, or dismiss a notice. No server round trip is needed.
- Server behavior: authorize, validate business rules, persist changes, query
  authoritative data, or load a tab's data. Keep these in HTMX/server handlers.
- Give each piece of state one owner. Reuse ARIA state when it describes the
  control correctly; use `data-*` for other local state. Do not maintain parallel
  classes, booleans, and ARIA attributes that can disagree.
- Choose a swap boundary that does not erase an in-progress form or local state.
  Morphing is a targeted option, not a universal fix or a core 2.x swap style.
- Keep reactive expressions cheap and repeatable; do not put unconditional
  requests, mutations, or event emission in expressions that rerun on DOM changes.

## Verification checklist

Test with throttling and a forced error, not just the fast happy path:

- Every action shows pending feedback and prevents accidental repeats.
- Skeleton renders before the slow query; the second request uses the same path
  plus `_content=1`, preserving filters and authorization.
- Loaded/empty content replaces the correct region once: no duplicate IDs,
  nested wrappers, repeated `load` loop, or internal parameters in history.
- Failure/timeout ends loading, re-enables actions, and exposes a working retry.
- Direct loads, boosted links, refresh, Back/Forward, history cache misses, and
  the chosen no-JS fallback return the intended document/fragment shape.
- Rapid search/filter actions cannot let stale responses overwrite newer results.
- Preload is selective, cache-safe, and measurably useful if enabled.
- Keyboard focus, screen-reader status, reduced motion, and layout stability work.
- Local UI state has one owner, survives the intended swaps, and never substitutes
  for server authorization or validation. Test keyboard behavior, not just clicks.

Add route tests for the response contract and integration/browser tests for
feedback and recovery. Report what was actually tested and any untested browser
behavior; do not describe markup inspection as runtime proof.

## Sources and companions

- [Indicators](https://htmx.org/attributes/hx-indicator/),
  [disabled elements](https://htmx.org/attributes/hx-disabled-elt/),
  [synchronization](https://htmx.org/attributes/hx-sync/)
- [Boost](https://htmx.org/attributes/hx-boost/),
  [history](https://htmx.org/docs/#history),
  [preload](https://htmx.org/extensions/preload/)
- Consult the project's HTML/framework skill when translating these patterns to
  Dart/htmleez, Relic, Go/templ, Basecoat, or another renderer. These are interaction
  contracts, not a new rendering abstraction.

The motivating app was `ddbexpress_site`: its newsletter page renders a layout
and skeleton, then uses `hx-trigger="load"` for data. This skill keeps that UX
while replacing separate content routes and single-region OOB plumbing with the
same-route query-parameter contract. Access to that app is not required.
