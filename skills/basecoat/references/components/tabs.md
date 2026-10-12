# Tabs

- JavaScript: required — `basecoat-css/tabs` (or the `all` bundle)
- Templates: ships a `tabs()` macro for Jinja and Nunjucks — see [templates](../templates.md)

## Usage

```html
<div class="tabs w-full" id="demo-tabs-with-panels">
  <nav role="tablist" aria-orientation="horizontal" class="w-full">
    <button type="button" role="tab" id="demo-tabs-with-panels-tab-1" aria-controls="demo-tabs-with-panels-panel-1" aria-selected="true" tabindex="0">Account</button>
    <button type="button" role="tab" id="demo-tabs-with-panels-tab-2" aria-controls="demo-tabs-with-panels-panel-2" aria-selected="false" tabindex="-1">Password</button>
  </nav>
  <div role="tabpanel" id="demo-tabs-with-panels-panel-1" aria-labelledby="demo-tabs-with-panels-tab-1" tabindex="-1" aria-selected="true">
    <div class="card">
      <header>
        <h2>Account</h2>
        <p>Make changes to your account here. Click save when you're done.</p>
      </header>
      <section>
        <form class="grid gap-4">
          <div role="group" class="field">
            <label for="demo-tabs-account-name">Name</label>
            <input type="text" id="demo-tabs-account-name" value="Pedro Duarte" />
          </div>
          <div role="group" class="field">
            <label for="demo-tabs-account-username">Username</label>
            <input type="text" id="demo-tabs-account-username" value="@peduarte" />
          </div>
        </form>
      </section>
      <footer>
        <button type="button" class="btn">Save changes</button>
      </footer>
    </div>
  </div>
  <div role="tabpanel" id="demo-tabs-with-panels-panel-2" aria-labelledby="demo-tabs-with-panels-tab-2" tabindex="-1" aria-selected="false" hidden>
    <div class="card">
      <header>
        <h2>Password</h2>
        <p>Change your password here. After saving, you'll be logged out.</p>
      </header>
      <section>
        <form class="grid gap-4">
          <div role="group" class="field">
            <label for="demo-tabs-password-current">Current password</label>
            <input type="password" id="demo-tabs-password-current" />
          </div>
          <div role="group" class="field">
            <label for="demo-tabs-password-new">New password</label>
            <input type="password" id="demo-tabs-password-new" />
          </div>
        </form>
      </section>
      <footer>
        <button type="button" class="btn">Save password</button>
      </footer>
    </div>
  </div>
</div>
```

### HTML structure

- `<div class="tabs">` — Root tabs container. It becomes horizontal or vertical based on the child tablist's `aria-orientation`.
  - `<nav role="tablist" aria-orientation="horizontal">` — Tablist containing tab buttons. Set `aria-orientation="vertical"` for vertical tabs and `data-variant="line"` for the line style.
    - `<button role="tab" id="{ TAB_ID }" aria-controls="{ PANEL_ID }" aria-selected="true" tabindex="0">` — Tab trigger. The active tab has `aria-selected="true"` and `tabindex="0"`. Inactive tabs use `tabindex="-1"`. Disabled tabs use `disabled` or `aria-disabled="true"`.
  - `<div role="tabpanel" id="{ PANEL_ID }" aria-labelledby="{ TAB_ID }">` — Panel controlled by a tab. Inactive panels are hidden.

### JavaScript API

| API | Type | Description |
| --- | --- | --- |
| `tabs.select(tab)` | Method | Selects a tab button in the tablist. |
| `tabs.refresh()` | Method | Rescans tabs and panels after children change inside the existing tablist/panel structure. |

## Examples

### Line

```html
<div class="tabs" id="tabs-line">
  <nav role="tablist" aria-orientation="horizontal" data-variant="line">
    <button type="button" role="tab" id="tabs-line-tab-overview" aria-controls="tabs-line-panel-overview" aria-selected="true" tabindex="0">Overview</button>
    <button type="button" role="tab" id="tabs-line-tab-analytics" aria-controls="tabs-line-panel-analytics" aria-selected="false" tabindex="-1">Analytics</button>
    <button type="button" role="tab" id="tabs-line-tab-reports" aria-controls="tabs-line-panel-reports" aria-selected="false" tabindex="-1">Reports</button>
  </nav>
  <div role="tabpanel" id="tabs-line-panel-overview" aria-labelledby="tabs-line-tab-overview" tabindex="-1">Overview content.</div>
  <div role="tabpanel" id="tabs-line-panel-analytics" aria-labelledby="tabs-line-tab-analytics" tabindex="-1" hidden>Analytics content.</div>
  <div role="tabpanel" id="tabs-line-panel-reports" aria-labelledby="tabs-line-tab-reports" tabindex="-1" hidden>Reports content.</div>
</div>
```

### Vertical

```html
<div class="tabs" id="tabs-vertical">
  <nav role="tablist" aria-orientation="vertical">
    <button type="button" role="tab" id="tabs-vertical-tab-account" aria-controls="tabs-vertical-panel-account" aria-selected="true" tabindex="0">Account</button>
    <button type="button" role="tab" id="tabs-vertical-tab-password" aria-controls="tabs-vertical-panel-password" aria-selected="false" tabindex="-1">Password</button>
    <button type="button" role="tab" id="tabs-vertical-tab-notifications" aria-controls="tabs-vertical-panel-notifications" aria-selected="false" tabindex="-1">Notifications</button>
  </nav>
  <div role="tabpanel" id="tabs-vertical-panel-account" aria-labelledby="tabs-vertical-tab-account" tabindex="-1">Account content.</div>
  <div role="tabpanel" id="tabs-vertical-panel-password" aria-labelledby="tabs-vertical-tab-password" tabindex="-1" hidden>Password content.</div>
  <div role="tabpanel" id="tabs-vertical-panel-notifications" aria-labelledby="tabs-vertical-tab-notifications" tabindex="-1" hidden>Notifications content.</div>
</div>
```

### Disabled

```html
<div class="tabs" id="tabs-disabled">
  <nav role="tablist" aria-orientation="horizontal">
    <button type="button" role="tab" id="tabs-disabled-tab-home" aria-controls="tabs-disabled-panel-home" aria-selected="true" tabindex="0">Home</button>
    <button type="button" role="tab" id="tabs-disabled-tab-settings" aria-controls="tabs-disabled-panel-settings" aria-selected="false" tabindex="-1" disabled>Disabled</button>
  </nav>
  <div role="tabpanel" id="tabs-disabled-panel-home" aria-labelledby="tabs-disabled-tab-home" tabindex="-1">Home content.</div>
  <div role="tabpanel" id="tabs-disabled-panel-settings" aria-labelledby="tabs-disabled-tab-settings" tabindex="-1" hidden>Settings content.</div>
</div>
```

### Icons

```html
<div class="tabs" id="tabs-with-icons">
  <nav role="tablist" aria-orientation="horizontal">
    <button type="button" role="tab" id="tabs-with-icons-tab-preview" aria-controls="tabs-with-icons-panel-preview" aria-selected="true" tabindex="0"><svg><!-- app-window --></svg> Preview</button>
    <button type="button" role="tab" id="tabs-with-icons-tab-code" aria-controls="tabs-with-icons-panel-code" aria-selected="false" tabindex="-1"><svg><!-- code --></svg> Code</button>
  </nav>
  <div role="tabpanel" id="tabs-with-icons-panel-preview" aria-labelledby="tabs-with-icons-tab-preview" tabindex="-1">Preview content.</div>
  <div role="tabpanel" id="tabs-with-icons-panel-code" aria-labelledby="tabs-with-icons-tab-code" tabindex="-1" hidden>Code content.</div>
</div>
```

## RTL

To enable RTL support, set `dir="rtl"` on the tabs root or a parent element.

```html
<div class="tabs w-full max-w-sm" id="tabs-rtl" dir="rtl">
  <nav role="tablist" aria-orientation="horizontal" dir="rtl">
    <button type="button" role="tab" id="tabs-rtl-tab-overview" aria-controls="tabs-rtl-panel-overview" aria-selected="true" tabindex="0">نظرة عامة</button>
    <button type="button" role="tab" id="tabs-rtl-tab-analytics" aria-controls="tabs-rtl-panel-analytics" aria-selected="false" tabindex="-1">التحليلات</button>
    <button type="button" role="tab" id="tabs-rtl-tab-reports" aria-controls="tabs-rtl-panel-reports" aria-selected="false" tabindex="-1">التقارير</button>
    <button type="button" role="tab" id="tabs-rtl-tab-settings" aria-controls="tabs-rtl-panel-settings" aria-selected="false" tabindex="-1">الإعدادات</button>
  </nav>
  <div role="tabpanel" id="tabs-rtl-panel-overview" aria-labelledby="tabs-rtl-tab-overview" tabindex="-1">
    <div class="card">
      <header>
        <h2>نظرة عامة</h2>
        <p>عرض مقاييسك الرئيسية وأنشطة المشروع الأخيرة. تتبع التقدم عبر جميع مشاريعك النشطة.</p>
      </header>
      <section>
        <p class="text-muted-foreground text-sm">لديك ١٢ مشروعًا نشطًا و٣ مهام معلقة.</p>
      </section>
    </div>
  </div>
  <div role="tabpanel" id="tabs-rtl-panel-analytics" aria-labelledby="tabs-rtl-tab-analytics" tabindex="-1" hidden>
    <div class="card">
      <header>
        <h2>التحليلات</h2>
        <p>تتبع مقاييس الأداء ومشاركة المستخدمين. راقب الاتجاهات وحدد فرص النمو.</p>
      </header>
      <section>
        <p class="text-muted-foreground text-sm">زادت مشاهدات الصفحة بنسبة ٢٥٪ مقارنة بالشهر الماضي.</p>
      </section>
    </div>
  </div>
  <div role="tabpanel" id="tabs-rtl-panel-reports" aria-labelledby="tabs-rtl-tab-reports" tabindex="-1" hidden>
    <div class="card">
      <header>
        <h2>التقارير</h2>
        <p>إنشاء وتنزيل تقاريرك التفصيلية. تصدير البيانات بتنسيقات متعددة للتحليل.</p>
      </header>
      <section>
        <p class="text-muted-foreground text-sm">لديك ٥ تقارير جاهزة ومتاحة للتصدير.</p>
      </section>
    </div>
  </div>
  <div role="tabpanel" id="tabs-rtl-panel-settings" aria-labelledby="tabs-rtl-tab-settings" tabindex="-1" hidden>
    <div class="card">
      <header>
        <h2>الإعدادات</h2>
        <p>إدارة تفضيلات حسابك وخياراته. تخصيص تجربتك لتناسب احتياجاتك.</p>
      </header>
      <section>
        <p class="text-muted-foreground text-sm">تكوين الإشعارات والأمان والسمات.</p>
      </section>
    </div>
  </div>
</div>
```
