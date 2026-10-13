---
name: relic
description: Build and maintain Dart HTTP servers with Relic, targeting the 2.0 prerelease API. Use this skill whenever working with package:relic, relic_core, or relic_io; creating a Relic app or router; adding routes or middleware; reading requests, query parameters, JSON, forms, or multipart uploads; setting cookies or headers; returning JSON, text, HTML, files, or WebSockets; or migrating older Relic or Shelf code. Consult it even for small Relic changes because the prerelease typed-header, cookie, and form APIs differ from older examples. Not for unrelated Dart or Serverpod application APIs.
---

# Relic for Dart — 2.0 prerelease

## Version and working rules

This skill is based on **Relic `2.0.0-rc.2`**, Dart **3.10+**, from the upstream checkout at revision `f91592b`. This is a verified baseline, not a promise that this version will remain the latest prerelease.

1. Inspect the target project's `pubspec.yaml` and lockfile before editing. Preserve existing structure and dependencies; do not silently upgrade an existing stable application.
2. For a new prerelease app, explicitly select `2.0.0-rc.2` or verify a newer prerelease and its changelog. An unqualified `dart pub add relic` can select a stable version without these APIs.
3. Import `package:relic/relic.dart`. It re-exports `relic_core` and `relic_io`, including `serve()`, static files, and temporary upload storage. Do not copy older `package:relic/io_adapter.dart` imports.
4. Prefer `RelicApp`, `RelicRouter`, ordinary handler functions, and scoped `use()`. Add abstractions only when they simplify the application.
5. Use actual source signatures over older README snippets or generated examples. Some upstream doc comments still show obsolete methods such as `req.ok()` or string-keyed path parameters.
6. Set response content type through `Body`, use typed headers where available, and read each body only once.

If the source reference is available, inspect `/Users/gustavo/clones/relic` (or the user's supplied checkout). Useful paths relative to the repository:

- `packages/relic/pubspec.yaml` and `CHANGELOG.md`: version, SDK, breaking changes.
- `packages/relic/lib/relic.dart`: public umbrella exports.
- `packages/relic_core/lib/src/`: router, request/response, body, headers, forms, middleware.
- `packages/relic_io/lib/src/`: IO adapter, server binding, static files, upload storage.
- `packages/examples/` and package `test/` directories: usage and edge cases.

Do not require this local checkout at application runtime. If it is unavailable, use the installed package source and version-specific upstream sources rather than guessing.

## Create and run an app

```sh
dart create -t console relic_app
cd relic_app
dart pub add 'relic:2.0.0-rc.2'
dart run bin/relic_app.dart
```

Use this `bin/relic_app.dart`:

```dart
import 'dart:convert';
import 'dart:io';
import 'package:relic/relic.dart';

Future<void> main() async {
  final app = RelicApp()
    ..use('/', logRequests())
    ..get('/', home)
    ..get('/health', health)
    ..fallback = (_) => Response.notFound(
      body: Body.fromString('Not found', mimeType: MimeType.plainText),
    );

  final server = await app.serve(
    address: InternetAddress.loopbackIPv4,
    port: 8080,
  );
  stdout.writeln('Listening on port ${server.port}');
}

Response home(Request req) => Response.ok(
  body: Body.fromString('<h1>Hello, Relic</h1>', mimeType: MimeType.html),
);

Response health(Request req) => Response.ok(
  body: Body.fromString(jsonEncode({'ok': true}), mimeType: MimeType.json),
);
```

`serve()` defaults to loopback IPv4 and port 8080. Use `InternetAddress.anyIPv4` when the app must be accessible from a container or other hosts; do not expose a development server unintentionally. `port: 0` requests an available port. Call `await app.close()` for shutdown. The returned server also supports `close(force: true)` when forced termination is required.

A `Handler` is `FutureOr<Result> Function(Request)`. A synchronous `Response` or asynchronous `Future<Response>` is already a valid handler; `respondWith()` is optional. Results can also be `WebSocketUpgrade` or `Hijack`, so middleware cannot assume every result is a response.

## Router, routes, and composition

```dart
RelicRouter buildApi() {
  final api = RelicRouter()
    ..get('/users', (_) => Response.ok(body: Body.fromString('Users')))
    ..post('/users', (_) => Response(201))
    ..anyOf({Method.put, Method.patch}, '/users/:id', (_) => Response.ok())
    ..delete('/users/:id', (_) => Response.noContent());
  return api;
}

RelicApp buildApp() {
  final app = RelicApp()..attach('/api', buildApi());
  final admin = app.group('/admin');
  admin.get('/status', (_) => Response.ok());
  return app;
}
```

- Methods: `get`, `post`, `put`, `patch`, `delete`, `head`, `options`, `trace`, `connect`, `any`, `anyOf`, or `add(Method.get, path, handler)`.
- `RelicRouter` is a typedef for `Router<Handler>`. Use `router.asHandler` when a handler is needed.
- `attach('/api', router)` prefixes its routes; `group('/api')` returns an attached subrouter.
- Duplicate registrations for the same method and normalized path throw. Routes are not an ordered list: literals take priority over dynamic segments, with backtracking enabled by default.
- `:id` captures a segment. `*` matches one segment without capturing. A terminal `/**` matches the remaining path, exposed as `req.remainingPath`; `req.matchedPath` holds the consumed prefix. Both are `NormalizedPath` values.
- The default is 404 for a path miss and 405 with `Allow` for a method miss. A custom `fallback` handles path misses only. Only the top-level fallback is used when composing routers.
- For modular registration, implement `RouterInjectable.injectIn(RelicRouter router)` and use `app.inject(module)` or `app.injectAt('/api', module)`.
- Avoid `consume: true` on manually attached routers unless intentional: it empties the source router. Replaying an already consumed router can lose routes on hot reload. `injectAt` on `RelicApp` rebuilds a fresh subrouter when reloaded.

### Path parameters

Use **Symbol keys**, not string indexing on `pathParameters`:

```dart
const userIdParam = IntPathParam(#id);

Response showUser(Request req) {
  final raw = req.pathParameters.raw[#id];
  final id = req.pathParameters.get(userIdParam);
  return Response.ok(body: Body.fromString('User $id (raw: $raw)'));
}
```

Register with `app.get('/users/:id', showUser)`. Built-ins include `IntPathParam`, `DoublePathParam`, `NumPathParam`, and `PathParam<T>(#name, decoder)`. Validate external input and convert invalid path decoding to an appropriate 400/404 rather than letting a parser exception become a 500.

### Request metadata and forwarding

Read `req.method`, `req.url`, `req.protocolVersion`, `req.headers`, `req.mimeType`, `req.encoding`, and `req.connectionInfo`. Connection information describes the nearest network peer, not automatically the original client behind a proxy. Trust forwarded headers only from configured proxies.

`req.copyWith(url: ..., headers: ..., body: ...)` creates a modified request sharing its context token. It does not rewind a body or automatically route again. To reroute from a routed handler:

```dart
Future<Result> forwardExample(Request req) async => await req.forwardTo(
  req.copyWith(url: req.url.replace(path: '/new-path')),
);
```

`forwardTo()` returns `FutureOr<Result>`. Avoid forwarding loops.

## Query parameters

For straightforward access, use the Dart URI API:

```dart
Response search(Request req) {
  final term = req.url.queryParameters['q'] ?? '';
  final tags = req.url.queryParametersAll['tag'] ?? const <String>[];
  final pageText = req.url.queryParameters['page'] ?? '1';
  final page = int.tryParse(pageText);
  if (page == null || page < 1) return Response.badRequest();
  return Response.ok(
    body: Body.fromString(
      jsonEncode({'q': term, 'tags': tags, 'page': page}),
      mimeType: MimeType.json,
    ),
  );
}
```

Use `queryParametersAll` when repeated values matter. For typed access, define `const pageParam = IntQueryParam('page')` and use `req.queryParameters.get(pageParam)` for a required decoded value or `req.queryParameters.tryGet(pageParam)` for null on missing/invalid input. Numeric built-ins also include `NumQueryParam` and `DoubleQueryParam`; custom accessors use `QueryParam<T>('key', decoder)`. Neither path nor query accessor failures are automatically converted to 400. `state[accessor]` returns the raw string, whereas `state(accessor)` decodes an optional value and still throws on invalid input.

Path values are already decoded; do not URI-decode them again. Typed parameter states are cached by request token: after `copyWith(url: ...)`, previously accessed typed query state can refer to the old URL. Use the rewritten request's `url.queryParameters` when rewriting URLs after parameter access.

## Read bodies and return responses

Both `Request` and `Response` expose `body`, `headers`, `mimeType`, `encoding`, `read(maxLength: ...)`, and `readAsString(maxLength: ..., encoding: ...)`. `Response` also exposes `statusCode`. Reading a response in middleware consumes it, just like a request: do not inspect its body and then return the same consumed body.

- `read()` yields `Stream<Uint8List>`.
- `readAsString()` uses the body encoding or UTF-8 by default.
- Bodies are **single-use**, including across `copyWith()`. Parse once and pass the parsed value through request context if needed.
- `maxLength` is a byte limit; exceeding it throws `MaxBodySizeExceeded`, converted by the server to 413.
- `isEmpty` only checks whether the known content length is zero. Unknown length is not evidence of an empty body.

```dart
Future<Response> receiveJson(Request req) async {
  if (req.mimeType != MimeType.json) return Response(415);
  try {
    final value = jsonDecode(await req.readAsString(maxLength: 1024 * 1024));
    if (value is! Map<String, dynamic>) return Response.badRequest();
    final name = value['name'];
    if (name is! String || name.trim().isEmpty) return Response.badRequest();
    return Response(201,
      body: Body.fromString(jsonEncode({'name': name}), mimeType: MimeType.json),
    );
  } on FormatException {
    return Response.badRequest(body: Body.fromString('Invalid JSON'));
  }
}
```

Response recipes (use `dart:convert` for `jsonEncode` and `Uint8List` from `dart:typed_data` for binary data):

```dart
Response textResponse(String text) => Response.ok(
  body: Body.fromString(text, mimeType: MimeType.plainText),
);

Response htmlResponse(String html) => Response.ok(
  body: Body.fromString(html, mimeType: MimeType.html),
);

Response jsonResponse(Object? value, {int status = 200}) => Response(
  status,
  body: Body.fromString(jsonEncode(value), mimeType: MimeType.json),
);
```

Use explicit MIME types: HTML fragments such as `<div>...</div>` are not reliably inferred. Escape untrusted values using the application's HTML renderer or `HtmlEscape` before interpolation; returning `MimeType.html` does not sanitize HTML. HTMX fragments are ordinary HTML responses; HTMX headers use the custom-header API below.

Use `Response.noContent()` for 204, `Response(201, ...)` for creation, and `Response.seeOther(Uri.parse('/success'))` for a 303 redirect after POST. Other constructors include `movedPermanently`, `found`, `badRequest`, `unauthorized`, `forbidden`, `notFound`, `internalServerError`, `notImplemented`, and `contentTooLarge`. Redirect constructors take a **Uri**, not a string. `copyWith()` changes headers/body, not status code; build a new `Response(status, ...)` to change status.

For binary output use `Body.fromData(Uint8List, mimeType: ...)`. For streamed output use `Body.fromDataStream(Stream<Uint8List>, mimeType: ..., contentLength: ...)`. `File.openRead()` yields lists: map chunks with `Uint8List.fromList` when constructing a streamed body. Do not buffer large files just to send them.

## Headers

Headers are case-insensitive and immutable. Raw values are `Iterable<String>`, not scalar strings. Read with `req.headers['x-request-id']`; prefer typed accessors such as `authorization`, `cookie`, `userAgent`, `contentType`, `cacheControl`, and `location` when appropriate. Typed parsing can throw `HeaderException`; the server converts uncaught header errors to 400.

```dart
Response withHeaders() => Response.ok(
  headers: Headers.build((h) {
    h['X-Request-ID'] = ['request-123'];
    h['HX-Trigger'] = ['saved'];
    h.cacheControl = CacheControlHeader(noStore: true);
  }),
  body: Body.fromString('Saved', mimeType: MimeType.plainText),
);

Response addHeader(Response response) => response.copyWith(
  headers: response.headers.transform((h) {
    h['X-App-Version'] = ['2'];
  }),
);
```

`Headers.fromMap({'X-Foo': ['bar']})` is another constructor. Remove a header with the mutable map's `remove()` inside `transform`. Header names/values are validated; do not bypass validation or concatenate untrusted values into raw headers. Read Content-Type with `req.headers.contentType` or `req.body.bodyType`; set outgoing MIME type/charset/parameters through `Body`, not a conflicting raw Content-Type header.

## Middleware and request-scoped data

```dart
Middleware responseHeaders() => (Handler next) => (Request req) async {
  final result = await next(req);
  if (result is! Response) return result;
  return result.copyWith(
    headers: result.headers.transform((h) {
      h['X-Content-Type-Options'] = ['nosniff'];
    }),
  );
};

final currentUserId = ContextProperty<String>('currentUserId');
```

Set `currentUserId[req] = verifiedUserId` in authentication middleware and read `currentUserId[req]` (nullable) or `currentUserId.get(req)` (throws if unset) downstream. Share derived data this way rather than a global variable or invented `req.context` map.

- `app.use('/', logRequests())` covers matched routes below root; `app.use('/api', middleware)` scopes to that subtree. Middleware can return early without calling `next`.
- Root scopes wrap more specific scopes. At the same scope, the first registered middleware is outermost: requests flow in registration order and responses unwind in reverse.
- Router `use()` **does not run on 404 or 405**. For logging, CORS, security headers, or error handling that must cover every request, wrap `router.asHandler` outside routing with a `Pipeline`.
- OPTIONS preflights need a matching OPTIONS route if CORS is applied through `use()`. Do not reflect arbitrary origins with credentials enabled; enforce an allowlist.
- If writing a broad error catcher, preserve `FormException`, `HeaderException`, and `MaxBodySizeExceeded` (rethrow or map appropriately) instead of turning input errors into 500. Log unexpected exceptions without exposing stack traces or secrets to clients.

Truly global middleware with the low-level server:

```dart
Future<RelicServer> serveRouter(RelicRouter router) async {
  final handler = const Pipeline()
    .addMiddleware(logRequests())
    .addMiddleware(responseHeaders())
    .addHandler(router.asHandler);
  final server = RelicServer(
    () => IOAdapter.bind(InternetAddress.loopbackIPv4, port: 8080),
  );
  await server.mountAndStart(handler);
  return server;
}
```

This manual server composition does not provide `RelicApp`'s automatic route-replay hot reload.

## URL-encoded forms

Use the native prerelease parsers instead of hand-written query-string parsing:

```dart
Future<Response> saveProfile(Request req) async {
  final form = await req.urlEncodedForm(
    limits: const FormLimits(maxBodySize: 64 * 1024),
  );
  final name = form.fields.get(const StringFormField('name'));
  final age = form.fields(const IntFormField('age'));
  final colors = form.fields.getAll(const StringFormField('color'));
  return jsonResponse({'name': name, 'age': age, 'colors': colors});
}
```

- `urlEncodedForm()` requires `MimeType.urlEncoded` (`application/x-www-form-urlencoded`). Ordinary HTML forms and typical HTMX form submissions use it.
- `formData()` chooses URL-encoded or multipart parsing from the body's MIME type. When the result is `MultipartFormData`, dispose it after processing; accepting both formats does not remove upload ownership responsibilities.
- `form.fields.raw['name']` is the first raw string. `get(accessor)` requires and decodes a field; `fields(accessor)` decodes an optional field; `tryGet(accessor)` returns null for missing/invalid input; `getAll(accessor)` preserves repeated values in order.
- Accessors: `StringFormField`, `IntFormField`, `NumFormField`, `DoubleFormField`, or `FormField<T>('name', decoder)`.
- Missing required fields throw `MissingFormFieldException`; decoder `Exception`s become `InvalidFormFieldException`. Throw `FormatException` for expected validation failures, not `ArgumentError` (an `Error`, which propagates).
- `+` becomes a space, percent escapes are decoded, and repeated field names are retained. Unchecked checkboxes are normally absent; do not treat an absent checkbox as a parser failure.
- Content-Type is required; otherwise the parser returns a 415 error. Calling `readAsString()` first consumes the stream and prevents parsing.

## Multipart and uploaded files

For file upload forms, the client must send `multipart/form-data` with a boundary (HTML forms use `enctype="multipart/form-data"`). Let the browser construct the boundary; do not manually set an incomplete Content-Type.

```dart
Future<Response> uploadAvatar(Request req) async {
  final form = await req.multipartForm(
    uploadStorage: TempUploadStorage(),
    limits: const FormLimits(
      maxBodySize: 12 * 1024 * 1024,
      maxFileCount: 1,
      maxFileSize: 10 * 1024 * 1024,
    ),
  );
  try {
    final file = form.files.get(const FormFile('avatar'));
    // Validate and copy/process file.read() into permanent storage here.
    // Generate the storage key yourself; never use file.filename as a path.
    return jsonResponse({'filename': file.filename, 'bytes': file.size});
  } finally {
    await form.dispose();
  }
}
```

`multipartForm()` returns `MultipartFormData` with `fields`, `files`, and ordered `entries`. `form.files.raw['avatar']`, `get(const FormFile('avatar'))`, `files(const FormFile('avatar'))`, and `getAll(const FormFile('photos'))` provide raw/required/optional/repeated file access.

`UploadedFile` exposes `filename`, `bodyType`, `headers`, `size`, `read()`, and `dispose()`. Unlike a request body, an uploaded-file handle can be read repeatedly until disposed. `size` and `filename` can be null.

- Default `MemoryUploadStorage` buffers files in memory. Prefer `TempUploadStorage()` or `TempUploadStorage(directory: privateDirectory)` for nontrivial uploads. Temporary files are private per-upload directories and are deleted by disposal.
- Parsing failure cleans up uploads already stored by the parser. Once parsing succeeds, the application owns cleanup: use `finally` around all processing/accessor calls.
- Process or copy files before returning. Do not return a response streaming a temporary upload and dispose it in `finally`: the response body is sent later, after the handler returns.
- Filenames are sanitized to a basename, but remain untrusted metadata. Validate type/content/size, generate a storage key, and keep uploads outside public asset directories. Raw `filename=""` parts are skipped by the aggregate parser. Other unusable names may produce a real file with null filename; `filename*` is not decoded as the upload filename.

### Stream parts instead of aggregating

```dart
Future<Response> streamMultipart(Request req) async {
  await for (final part in req.multipart(
    limits: const FormLimits(maxBodySize: 12 * 1024 * 1024),
  )) {
    switch (part) {
      case MultipartFieldPart():
        final value = await part.readAsString(maxLength: 64 * 1024);
        // Process part.name and value.
        stdout.writeln('${part.name}: ${value.length} characters');
      case MultipartFilePart(hasEmptyFilename: false):
        await for (final chunk in part.body.read(maxLength: 10 * 1024 * 1024)) {
          // Write/process chunk; do not collect the whole file in memory.
          stdout.writeln('Received ${chunk.length} bytes');
        }
      case MultipartFilePart():
      case MultipartOtherPart():
        await part.discard();
    }
  }
  return Response.noContent();
}
```

Consume or discard each part before advancing. Each part has `headers`, `contentDisposition`, `body`, `readAsString()`, and `discard()`.

Low-level `multipart()` enforces body/boundary/part-count/part-header limits, **not** aggregate file/field counts, file/field sizes, or total-file size. Add per-part limits and count/size accounting yourself, or prefer `multipartForm()`.

### Form limits and errors

`FormLimits` defaults: body 10 MiB, 100 fields, 8 files, 128 parts, field 64 KiB, file 10 MiB, total files 10 MiB, part headers 8 KiB, boundary 200 bytes. Configure `maxBodySize`, `maxFieldCount`, `maxFileCount`, `maxPartCount`, `maxFieldSize`, `maxFileSize`, `maxTotalFileSize`, `maxPartHeaderSize`, and `maxBoundarySize`, or use `FormLimits.defaults.copyWith(...)`. The body budget includes multipart framing/headers, so make it larger than the intended file budget.

The server converts uncaught `FormException` to its `statusCode`: unsupported media type 415, malformed/missing/invalid data 400, exceeded limits 413. `FormLimitExceededException.limit` identifies the limit. Parsing/media/limit failures also close the connection because body bytes may remain unread. If catching these to render a custom response, preserve the status and that connection-close behavior; accessor failures after successful parsing do not need it.

## Cookies

Incoming cookies use `CookieHeader`; outgoing cookies use **`SetCookie` for one cookie** and **`SetCookieHeader` for the collection**. Do not use the old `SetCookieHeader(name: ..., value: ...)` API.

```dart
String? sessionId(Request req) =>
  req.headers.cookie?.getCookie('session')?.value;

Response setSession(String token) => Response.noContent(
  headers: Headers.build((h) {
    h.setCookie = SetCookieHeader([
      SetCookie(
        name: 'session', value: token, path: '/',
        secure: true, httpOnly: true, sameSite: SameSite.lax,
        maxAge: 24 * 60 * 60,
      ),
    ]);
  }),
);

Response clearSession(Response response) => response.copyWith(
  headers: response.headers.transform((h) {
    h.setCookie = (h.setCookie ?? const SetCookieHeader.empty()).add(
      SetCookie(name: 'session', value: '', path: '/', maxAge: 0),
    );
  }),
);
```

- `maxAge` is integer seconds; `expires` is a `DateTime`; `domain` is `Host?` without a port; `path` is a string. Omit domain for a host-only cookie.
- Append via `.add(cookie)` instead of replacing existing cookies. Each cookie gets a separate Set-Cookie line; never comma-join them.
- Delete with the original name/path/domain scope and `maxAge: 0`; also invalidate the server-side session.
- Incoming cookie names are case-sensitive. `getCookie(name)` returns the first; `getCookies(name)` retains duplicates. Reject ambiguous duplicate authentication cookies if the application requires exactly one session token. For tolerant parsing use `Headers.cookie[req.headers].valueOrNullIfInvalid`.
- Use opaque, unpredictable server-validated tokens. No automatic application-level encoding, signing, session storage, or expiry enforcement is provided.
- Use Secure and HttpOnly for production session cookies. Disable Secure only deliberately for local HTTP development. Browsers require Secure with `SameSite.none`; Relic does not add it automatically. SameSite is not a replacement for CSRF protection on state-changing cookie-authenticated routes.
- If referring to `Cookie` with both Relic and `dart:io` imported, prefix/hide the conflicting IO type.

## Static assets, WebSockets, and operations

Serve only a dedicated public asset directory:

```dart
void addStaticAssets(RelicApp app) {
  app.injectAt('/static', StaticHandler.directory(
    Directory('public'),
    cacheControl: (_, __) => CacheControlHeader(maxAge: 3600),
  ));
}

WebSocketUpgrade welcomeSocket(Request req) => WebSocketUpgrade((socket) {
  socket.sendText('Welcome');
});
```

- `StaticHandler.directory` requires an existing directory and a `cacheControl` callback. Injection registers GET/HEAD with the required tail route. Alternatively mount `.call` on `/static/**` with `anyOf({Method.get, Method.head}, ...)`. A plain `/static` route does not expose child paths.
- `StaticHandler.file(File(...), cacheControl: ...)` handles a single existing file. Static handlers support MIME detection, ETags, conditional/range requests, and path traversal protection. They **do not hide dotfiles**: never mount the project root, `.env`, private uploads, or `.git`.
- Register WebSockets with `app.get('/ws', welcomeSocket)`. Use `socket.events`, `sendText`, `sendBytes`, and `tryClose` as needed. Event types come from `package:web_socket/web_socket.dart`; declare that dependency explicitly when importing it.
- Cross-origin WebSocket upgrades are rejected by default. Do not set `allowAnyOrigin: true` for cookie-authenticated sockets. Browser WebSockets are not protected by CORS.
- For hot reload, run with the VM service enabled (`dart run --enable-vm-service bin/relic_app.dart`) and trigger reload through compatible tooling. Enabling the service alone is not a file watcher. RelicApp replays registered route setup on reload; global state/resource changes may need restart. Keep the VM service private.
- `serve(noOfIsolates: ...)` enables multiple isolates. Handlers/middleware must be sendable and in-memory state is not a shared database. Start with one isolate unless measurements justify more.
- TLS can be configured with `serve(securityContext: ...)`; otherwise terminate TLS at a trusted reverse proxy. Manage database/storage resources and graceful shutdown explicitly.

## Completion checks

When implementing an application, run `dart analyze` and verify representative requests: successful routes, missing/invalid input, repeated query/form values, unsupported media types, upload limits/cleanup, cookies, and 404/405 middleware coverage. Reuse the project's existing tests and scripts. Do not add a benchmark/evaluation workspace just to use this skill.
