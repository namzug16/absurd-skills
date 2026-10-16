# Htmleez Patterns Reference

Use this file for less-common htmleez patterns or when checking an example before editing package code.

## Elements And Attributes

Tags are `Tag` constants. To define a custom element or missing tag, create a `Tag` and call it like the built-ins.

```dart
import "package:htmleez/htmleez.dart";

const myComponent = Tag("my-component");

HTML component(String id) => myComponent([
  $("id")(id),
  $("data-controller")("profile"),
  $("aria-label")("Profile component"),
  "Profile".t,
]);
```

Attributes and children share the same list. htmleez sorts them by component type during `add`; place attributes first for readability.

```dart
HTML card(String titleText, String bodyText) => article([
  $("class")("card"),
  h2([titleText.t]),
  p([bodyText.t]),
]);
```

## Reusable Attributes

Write attributes inline with `$("name")("value")`. Never wrap an attribute name by itself: the wrapper saves nothing and hides the HTML attribute.

```dart
// Wrong: useless wrappers around attribute names.
HTML cls(String c) => $("class")(c);
HTML id(String v) => $("id")(v);

final wrong = div([cls("card"), id("main")]);

// Right: use the attribute directly.
final right = div([$("class")("card"), $("id")("main")]);
```

Extract a reusable attribute only when its value is long and used in several places, so that retyping it would invite mistakes, or when the extraction genuinely reduces code. Name it after what it does and always prefix the name with `$`, like the built-in `$classes`, so call sites still read as attributes.

```dart
HTML $hxOnBeforeRequest() => $("hx-on:htmx:before-request")(
  "this.querySelector('[data-spinner]').hidden = false; this.querySelector('button[type=submit]').disabled = true",
);

HTML $primaryButtonClasses() => $("class")(
  "inline-flex items-center justify-center gap-2 rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground shadow hover:bg-primary/90 focus-visible:outline-none focus-visible:ring-2 disabled:pointer-events-none disabled:opacity-50",
);

HTML saveForm() => form([
  $("method")("post"),
  $hxOnBeforeRequest(),
  button([$("type")("submit"), $primaryButtonClasses(), "Save".t]),
]);
```

Short or one-off values stay inline, even when they appear more than once.

## Forms

Use exact HTML attribute names through `$()`. There are no built-in named-argument attributes in htmleez.

```dart
HTML signupForm() => form([
  $("method")("post"),
  $("action")("/signup"),
  label([$("for")("email"), "Email".t]),
  input([
    $("id")("email"),
    $("name")("email"),
    $("type")("email"),
    $("autocomplete")("email"),
    $("required")(),
  ]),
  button([$("type")("submit"), "Create account".t]),
]);
```

## Conditional Composition

Use Dart collection control flow directly inside tag lists.

```dart
HTML alert(String? message) => div([
  $("role")("status"),
  $("class")("alert"),
  if (message == null) "No alerts".t,
  if (message != null) strong([message.t]),
]);
```

Conditional attributes are the same pattern.

```dart
HTML tabButton(String label, bool selected) => button([
  $("type")("button"),
  $("role")("tab"),
  $("aria-selected")(selected.toString()),
  if (selected) $("class")("selected"),
  label.t,
]);
```

## Collections

Use `for` elements to render collections. Convert non-string data with normal Dart code before `.t`.

```dart
HTML taskList(List<String> tasks) => ul([
  for (final task in tasks) li([task.t]),
]);
```

## Fragments And Multiple Roots

Use fragments to return siblings without a wrapper.

```dart
HTML field(String id, String labelText) => HTML.fragment([
  label([$("for")(id), labelText.t]),
  input([$("id")(id), $("name")(id)]),
]);
```

Fragments can be nested and can be children of tags. A root fragment can render tags, nested fragments, text, and raw content. A root `List<HTML>.toHtml()` should contain tags or fragments, not standalone attributes.

```dart
final markup = <HTML>[
  h1(["Title".t]),
  HTML.fragment([p(["A".t]), p(["B".t])]),
].toHtml();
```

## Rendering And Escaping

Text and normal attribute values are escaped by the renderer.

```dart
final safe = div([
  $("title")('This "title" has <tags> & chars'),
  "Hello <World>".t,
]).toHtml();
```

Use `Raw` for trusted static markup or script/style bodies that must not be escaped.

```dart
HTML pageScript() => script([
  const Raw("console.log('loaded');"),
]);
```

Use `raw$` for trusted static raw attributes only. Prefer single quotes inside inline JavaScript so the generated double-quoted HTML attribute remains valid.

```dart
HTML actionButton() => button([
  raw$("onclick")("console.log('clicked')"),
  "Run".t,
]);
```

## Void Elements

Void elements render as self-closing tags. Pass attributes only.

```dart
HTML avatar(String url, String name) => img([
  $("src")(url),
  $("alt")(name),
]);
```

Common predefined void tags include `area`, `base`, `br`, `col`, `embed`, `hr`, `img`, `input`, `link`, `meta`, `source`, `track`, and `wbr`.

## Incremental Construction

Prefer constructing tags with their full list when possible. Use `.add()` and `.addAll()` when incremental composition is genuinely clearer; they only work on tag components.

```dart
final panel = div([$("class")("panel")]);
panel.add(h2(["Settings".t]));
panel.addAll([
  p(["Choose your preferences.".t]),
  button([$("type")("button"), "Close".t]),
]);
```
