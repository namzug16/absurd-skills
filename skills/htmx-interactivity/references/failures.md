# Failure handling for lazy regions (HTMX 2.x)

Reuse existing application error handling first. This optional shared-script
pattern handles only explicitly marked regions, not every app request.

Add `data-lazy-region` to the skeleton wrapper from `SKILL.md`. Load this script
once in the head (deferred, after HTMX). Omit the marker from the loaded wrapper.
Use the project's localization and styles.

```js
function handleLazyFailure(event) {
  const elt = event.detail.elt;
  const region = elt instanceof Element
    ? elt.closest('[data-lazy-region]') : null;
  // Navigation may already have removed the failed request's region.
  if (!region || !region.isConnected) return;
  const url = region.getAttribute('hx-get');
  if (!url) return;

  region.setAttribute('aria-busy', 'false');
  const message = document.createElement('p');
  message.setAttribute('role', 'alert');
  message.textContent = 'Could not load this content. Please try again.';
  const retry = document.createElement('button');
  retry.type = 'button';
  retry.textContent = 'Retry';
  retry.setAttribute('hx-get', url);
  retry.setAttribute('hx-target', '#' + region.id);
  retry.setAttribute('hx-swap', 'outerHTML');
  retry.setAttribute('hx-push-url', 'false');
  retry.setAttribute('hx-disabled-elt', 'this');
  retry.setAttribute('hx-indicator', 'this');
  const pending = document.createElement('span');
  pending.className = 'htmx-indicator';
  pending.textContent = ' Retrying…';
  retry.append(pending);
  // Replace the old retry UI on repeated failures instead of duplicating alerts.
  region.replaceChildren(message, retry);
  htmx.process(retry);
}

document.addEventListener('htmx:responseError', handleLazyFailure);
document.addEventListener('htmx:sendError', handleLazyFailure);
document.addEventListener('htmx:timeout', handleLazyFailure);
```

This assumes a unique CSS-safe region ID such as `reports-content`. Use DOM APIs
and `textContent`, not error messages interpolated into `innerHTML`. Never insert
raw error response bodies, stack traces, or login documents into the region.

The retry button provides pending feedback, and the original busy state is no
longer stuck at `true`. If announcing busy state on each retry is needed, use
scoped lifecycle listeners to set it at request start and clear it on completion,
including aborts. Avoid one global boolean when requests can overlap.

Configure a finite timeout to fit the app's needs if requests must not wait
indefinitely. An intentional abort (e.g. superseded search) is not a server
failure; do not automatically alert or retry it.

Alternatively use a scoped `htmx:beforeSwap` handler to opt specific error statuses
into swapping server-rendered error/retry fragments into the appropriate region.
Do not globally swap arbitrary 500 bodies or mark every error successful.

Test initial HTTP failure, offline failure, timeout, repeated retry failure,
successful retry, and navigation away while pending. Verify events against the
installed version and avoid duplicate notifications with app-wide error handlers.
