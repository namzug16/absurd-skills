# HTMX 4 and local UI behavior

Read this for HTMX 4 projects, hx-live, local reactive interactions, or preserving
state during swaps. The main skill and `failures.md` contain **2.x** examples.
Do not paste those unchanged into a 4.x app or upgrade an app as a side effect.

## Version boundary: choose APIs before patterns

Verified against the linked official documentation, October 2026. Recheck the
installed version when implementing; the `four.htmx.org` documentation evolves.

| Concern | HTMX 2.x recipes in this skill | HTMX 4 documentation |
| --- | --- | --- |
| Inherit parent behavior | Implicit for inheritable attributes | Explicit, e.g. `hx-boost:inherited="true"` |
| Disable controls during requests | `hx-disabled-elt` | `hx-disable` |
| Error status swapping | Most 4xx/5xx not swapped | Responses swap except 204/304; use `hx-status:422`, `hx-status:5xx` deliberately |
| Events | `htmx:beforeRequest`, `htmx:responseError` | `htmx:before:request`, `htmx:response:error` |
| Event payload | Event-specific fields such as `detail.elt` | Request context in `detail.ctx`; consult the event reference |
| Extension setup | Usually script + `hx-ext` | Documented 4.x extensions load as scripts; do not reuse 2.x setup blindly |
| Morphing | Version-compatible extension, e.g. Idiomorph | Built-in `innerMorph` / `outerMorph` |
| History | DOM snapshot cache by default | Server refetch by default; optional history-cache extension |
| Page vs fragment request | Explicit server contract using request headers | `HX-Request-Type: full` / `partial` additionally identifies expected representation |

**Danger:** in HTMX 2, `hx-disable` disables HTMX processing, not the submit
button for the duration of a request. This is not a cross-version alias.

For the same-route skeleton contract in a 4.x app, keep `_content=1` as the work
selector. Return a fragment only for an actual partial request; when
`HX-Request-Type: full`, absent HTMX headers, or history navigation requires a
document, render a full document. Requests using `hx-select` can require full
responses too. Add appropriate `Vary` headers to cacheable representations.

In 4.x, an intentional 500 fragment can contain the retry UI, but a raw framework
500 page can also replace the target by default. Choose status routing deliberately.
`hx-status:5xx="swap:none"` prevents a destructive swap; it does not itself show
an error or provide recovery. Network failures still require a client-side path.

## Choose local behavior without rebuilding an SPA

1. Native HTML: `<details>` for a disclosure, `<dialog>` for a modal, `popover`
   for suitable overlays, native input constraints for immediate form feedback.
2. CSS: use attribute selectors or `:has()` for presentation that can be derived
   directly from the existing DOM.
3. Existing component library or a small event handler for a single local action.
4. hx-live for small derived/reactive behaviors that would otherwise require
   repetitive DOM synchronization. Load the compatible, pinned hx-live script
   after HTMX 4 using the app's asset conventions; do not add an npm build merely
   for this extension. It is not part of the 2.x core API.

Use an existing Basecoat/other component implementation rather than attaching a
second competing controller to the same disclosure, dialog, select, or tabs.

## Practical hx-live patterns

These snippets assume compatible HTMX 4 + hx-live scripts are already loaded.
They are partial markup to integrate with the existing styles, not standalone
accessible widget implementations.

### Disclosure with one accessible source of truth

Use `<details>` when possible. When trigger and content must be separated:

```html
<button id="filters-toggle" type="button" aria-expanded="false"
        aria-controls="filters-panel"
        hx-on:click="aria.expanded = !aria.expanded">
  Filters
</button>
<section id="filters-panel" aria-labelledby="filters-toggle" hidden
         hx-live:hidden="!q('#filters-toggle').aria.expanded">
  <!-- Actual filter controls. -->
</section>
```

Use the same `aria-expanded` state to drive CSS rather than also tracking
`data-open` and `.is-open`. This is a disclosure, not automatically a menu or
modal: those have additional keyboard/focus requirements.

### Character count and derived feedback

```html
<label for="message">Message</label>
<textarea id="message" name="message" maxlength="500"
          aria-describedby="message-count"></textarea>
<output id="message-count" for="message"
        hx-live:text="`${q('#message').value.length} / 500`">0 / 500</output>
```

Keep native constraints and server validation. Avoid an assertive announcement
on every keystroke; use appropriate separate feedback near an actual limit.
Use unique IDs, or component-scoped selectors in repeated markup.

### Bind busy semantics without a duplicate loading flag

```html
<form hx-post="/profile" hx-target="#profile-result"
      hx-indicator="this" hx-disable="find button[type='submit']"
      hx-live:aria-busy="matches('.htmx-request')">
  <!-- Labeled inputs and CSRF token. -->
  <button type="submit">
    Save
    <span class="htmx-indicator" role="status">Saving…</span>
  </button>
</form>
<div id="profile-result" aria-live="polite"></div>
```

Core HTMX owns the request and disabling. hx-live merely derives the ARIA state
from its request class. Do not create a separate `data-loading` boolean or a
manual `fetch()` wrapper for this. `aria-disabled` and `pointer-events:none` do
not block keyboard activation like a native disabled button does.

### Derived bulk-selection state

Read checked checkbox properties within the relevant component to derive a
selection count and whether bulk actions are available. Submit selected IDs
using real named controls, not a duplicate client-side collection. Handle the
select-all control's indeterminate **property**, not just its `checked` attribute.
Define whether selection means visible rows or all filtered results; never
silently turn a page selection into a cross-page mutation.

### Transient notices and animation completion

`forEvent('transitionend', 500)` can wait for an animation with a fallback;
`nextFrame()` separates class changes when replaying an animation. Prefer these
over guessing an animation's timing, and honor reduced motion. Cancel or scope
stale timers so an earlier success message cannot dismiss a newer error.
Do not auto-dismiss errors or important actions before users can read/use them.

## State lifetime and morphing

- Put shared local state on the nearest common ancestor, not a global JS store.
  hx-live's `data` supports typed DOM-backed values. Use explicit `local` or
  `closest` scopes when ownership matters; don't guess scope from proximity.
- `innerHTML`/`outerHTML` replacement destroys state in the replaced subtree.
  Keep state on an unswapped ancestor when that is the intended lifetime, or
  return authoritative state in the server's response.
- Morphing can preserve nodes, focus, selection, and playback. Use stable IDs
  for important nodes. It is useful for refreshing editable/live content, but
  ordinary targeted replacement is simpler for skeleton-to-results loading.
- In 4.x, a focused input's value is preserved during morphs. Unfocused values
  can change if the server changes the `value` attribute. Test before promising
  all unsaved edits survive. To reset a form intentionally, prefer a clean swap
  or an explicit successful reset rather than fighting morph preservation.
- Morphs still update attributes, including `data-*`. If specific client-owned
  attributes must survive, use a narrowly chosen `morphIgnore` prefix or a
  supported skip mechanism. Do not protect all server-owned attributes globally.
- `hx-preserve` and morph exclusions are for deliberately isolated widgets,
  not a substitute for synchronizing server and client state. A preserved stale
  widget may keep obsolete values or permissions; test both success and errors.

## Reactive safety and cost

- hx-live recomputes expressions on broad DOM changes; keep computations cheap,
  local, and safe to repeat. Avoid scanning thousands of rows per keystroke.
- Prefer `hx-get`/`hx-post` and `hx-trigger` for requests, even though hx-live can
  execute arbitrary JavaScript. Unconditional `fetch()` in reactive expressions
  can cause repeated requests; debouncing alone does not prevent stale responses.
- User input generates input/change events, but direct programmatic `.value`
  assignment may not trigger reactivity. Use hx-live's `q()` setter or the
  documented refresh mechanism when bridging an external widget; test it.
- Prefer text bindings (`hx-live:text` / `:text`) for untrusted content. HTML
  bindings and `insert()` parse HTML and require trusted/sanitized input.
- Long-form `hx-live:hidden` / `hx-live:text` avoids Alpine's competing `:` binding
  syntax and template tooling that strips colon-prefixed attribute names. Do
  not force competing libraries to both own `:class` on the same component.
- Expressions and `hx-on` are executable code. Check CSP compatibility before
  using them; keep untrusted content out of expression attributes. Do not loosen
  security policy just to use terse inline behavior.

## Official sources

- [hx-live programmers guide](https://four.htmx.org/docs/hx-live-guide)
- [hx-live extension reference](https://four.htmx.org/extensions/hx-live)
- [Morphing guide](https://four.htmx.org/docs/morphing-swaps-guide)
- [HTMX 4 migration differences](https://four.htmx.org/docs/#migrating-from-htmx-2x-to-4x)
- [hx-disable](https://four.htmx.org/reference/attributes/hx-disable)
- [hx-status](https://four.htmx.org/reference/attributes/hx-status)
- [HX-Request-Type](https://four.htmx.org/reference/headers/HX-Request-Type)
- [Locality of Behaviour](https://htmx.org/essays/locality-of-behaviour/)
