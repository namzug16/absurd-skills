# Interaction recipes beyond loading

Use the matching recipe, not all of them on every page. Examples are HTMX 2.x
unless explicitly marked. Apply the main skill's pending/error/accessibility
requirements to every recipe. For 4.x differences, read
[HTMX 4 and local behavior](htmx4-local-behavior.md).

## Inline editing: implement the whole cycle

- View → edit: GET a prefilled form into the smallest coherent component.
- Save: validate/authorize on the server; return an updated read-only fragment
  on success or the submitted form with values/errors on failure.
- Cancel: return the unchanged read-only view without saving. Inside a form,
  the cancel button needs `type="button"`.
- Use `outerHTML` for the component contract and relative targets such as
  `closest tr` for repeated rows. Keep table markup valid: a form cannot directly
  wrap cells inside a row; use a valid form association or explicit inclusion.
- Focus an appropriate edit field on entry and the edit control after cancel
  or save. Do not discard unrelated fields or quietly lose concurrent edits.

Sources: [editable rows](https://htmx.org/examples/edit-row/),
[click to edit](https://htmx.org/examples/click-to-edit/).

## Dependent selects: invalidate downstream choices

Changing a parent invalidates dependent choices immediately, not only after the
new options arrive. Show local pending feedback and prevent submitting a stale
child selection; define reset, empty-options, and failure states.

The named parent control sends its own value. Explicitly include any additional
dependency fields; in particular, 4.x GET buttons/controls do not automatically
include their enclosing form. Coordinate rapid parent changes using a shared
scope with `replace` so old options cannot overwrite newer ones. Validate the
parent/child relationship again at final submission; filtered options are not
authorization.

Source: [cascading selects](https://htmx.org/examples/value-select/).

## Inline validation: submit takes priority

Do not let blur-triggered validation race a user's submit:

```html
<form hx-post="/articles" hx-target="#article-result">
  <label for="title">Title</label>
  <input id="title" name="title" required
         hx-post="/articles/validate-title" hx-trigger="change"
         hx-target="#title-feedback" hx-sync="closest form:abort"
         aria-describedby="title-feedback">
  <span id="title-feedback"></span>
  <!-- Add local submit/validation indicators and CSRF token. -->
  <button type="submit">Save</button>
</form>
<div id="article-result"></div>
```

The explicit input-level synchronization yields to the form request. Keep
validation feedback separate from the field to avoid overwriting current typing.
Native constraints handle simple immediate checks; server validation still runs
at submission. Handle returned status codes according to the installed version.
An aborted browser request does not undo work already executing on the server.

Source: [synchronization](https://htmx.org/attributes/hx-sync/).

## Bulk actions: native selection, explicit scope

Use a real form and repeated checkbox names, e.g. `name="selected" value="123"`.
Parse repeated parameters as a list rather than silently accepting only one ID.
Authorize every selected record and report affected/failed counts.

Define whether “select all” means visible rows or all matching records. Those
require different server contracts. Disable bulk actions for empty selection;
preserve selection on recoverable failure and deliberately clear or retain it
on success. Keep checked controls as the source of truth, not duplicate JS arrays.
If using hx-live, derive toolbar/count state as described in its reference.

Prefer a form POST action for a simple cross-version contract. A 4.x GET/DELETE
button needs explicit form inclusion. Do not confuse hiding a bulk-action button
with authorization for the operation.

Source: [bulk updates](https://htmx.org/examples/bulk-update/).

## Cross-region updates: choose coupling deliberately

Simplest first:

1. Widen a target when the affected regions form one coherent component.
2. Use OOB updates when one response can render the other changed regions.
3. Emit a semantic event when independent regions own their rendering.

After committing a successful contact change, the server can return:

```http
HX-Trigger: contactsChanged
```

A separate region listens and refreshes its own data:

```html
<section id="contact-count" hx-get="/contacts/count"
         hx-trigger="contactsChanged from:body" hx-swap="innerHTML">
  <!-- Current count. -->
</section>
```

Preserve filters/query state in refresh URLs and add pending/error feedback to
those requests. Do not emit success events before the mutation commits or on
validation failure. Avoid event chains that repeatedly refresh one another.
Events incur additional requests; OOB may be simpler when the data is already
available in the mutation handler.

**Timing differs:** 2.x has `HX-Trigger`, `HX-Trigger-After-Swap`, and
`HX-Trigger-After-Settle`. The 4.x reference consolidates these into `HX-Trigger`
after the swap. Choose timing/explicit event targets when the mutation replaces
the request owner or creates the listening region; don't assume identical timing.

Sources: [updating other content](https://htmx.org/examples/update-other-content/),
[4.x HX-Trigger](https://four.htmx.org/reference/headers/HX-Trigger).

## Long operations: separate transfer from processing

- For long server work, POST starts a job and returns a job-specific status
  component. Poll an authorized status URL at a sensible interval; render actual
  progress when known, otherwise use indeterminate status.
- Completion, failure, and cancellation return terminal components without the
  polling trigger. Do not leave polling running forever after an error.
- Start with polling; use SSE for justified server-pushed updates and WebSockets
  for genuinely bidirectional communication. Avoid new infrastructure for an
  occasional background report.
- Upload requests require `hx-encoding="multipart/form-data"` and appropriate
  server parsing/limits. Uploaded bytes and server processing are different
  progress phases; 100% transfer does not mean processing succeeded.
- **2.x** exposes `htmx:xhr:progress`. **4.x** uses Fetch and its official pattern
  explicitly says native upload-progress reporting is unavailable. Use an
  indeterminate uploading state or a deliberate uploader integration; don't
  copy XHR progress event handlers into a 4.x app.
- Preserve file selection on validation errors: keep the input outside the
  replaced region with a `form` association, or use supported `hx-preserve` with
  a stable matching ID in both responses. Keep error markup outside a preserved
  subtree so it can update. Deliberately reset invalid files when necessary.

Sources: [job progress](https://htmx.org/examples/progress-bar/),
[2.x uploads](https://htmx.org/examples/file-upload/),
[file-input preservation](https://htmx.org/examples/file-upload-input/),
[4.x uploads](https://four.htmx.org/patterns/file-upload).

## Offscreen content and incremental lists

Use immediate `load` for the main page skeleton. Consider `revealed` or
`intersect once` for expensive below-the-fold sections, with an appropriate
intersection root for scroll containers. Do not defer content the user needs
immediately just because lazy loading is available.

For long lists, start with an explicit “Load more” control. If infinite scroll
is justified, retain a keyboard-accessible fallback, avoid duplicate page/cursor
requests, stop on exhaustion, announce additions without moving focus, and test
Back navigation/scroll restoration. Differentiate “no items yet” from “no more
items.” Do not preload every possible next page.

Sources: [click to load](https://htmx.org/examples/click-to-load/),
[infinite scroll](https://htmx.org/examples/infinite-scroll/).
