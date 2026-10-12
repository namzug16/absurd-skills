#!/usr/bin/env python3
"""Programmatic grader for the basecoat skill evals. Usage: grade.py <iteration-dir>"""
import json, re, sys, pathlib

LEGACY = re.compile(r'\b(btn|badge|alert)-(?:(?:xs|sm|lg)-)?(?:icon-)?(primary|secondary|outline|ghost|link|destructive)\b|\bbtn-(xs|sm|lg|icon)\b')

def classes(html):
    return ' '.join(re.findall(r'class="([^"]*)"', html))

def tag_with(html, cls, *needles):
    """True if some opening tag has class token `cls` and all needles."""
    for t in re.findall(r'<[a-zA-Z][^<>]*>', html, re.S):
        m = re.search(r'class="([^"]*)"', t)
        if m and cls in m.group(1).split() and all(n in t for n in needles):
            return t
    return None

def has_class(html, cls):
    return any(cls in c.split() for c in re.findall(r'class="([^"]*)"', html))

def no_legacy(h):
    m = LEGACY.search(classes(h))
    return (not m, f'legacy class found: {m.group(0)}' if m else 'no pre-1.0 compound classes')

def chk(cond, yes, no):
    return (bool(cond), yes if cond else no)

EVALS = {
 0: ('settings.html', [
  ('Loads a Basecoat 1.x stylesheet from the CDN', lambda h: chk(re.search(r'basecoat-css@1[^"\']*/dist/basecoat[a-z-]*\.cdn(\.min)?\.css', h), 'found 1.x cdn css', 'no basecoat-css@1.x *.cdn.css link')),
  ('Loads Basecoat 1.x JavaScript (all bundle, or runtime + select + toast)', lambda h: chk(re.search(r'basecoat-css@1[^"\']*/dist/js/all(\.min)?\.js', h) or all(re.search(rf'basecoat-css@1[^"\']*/dist/js/{n}(\.min)?\.js', h) for n in ('basecoat','select','toast')), 'found 1.x js', 'missing 1.x js bundle')),
  ('Uses no pre-1.0 compound classes (btn-outline, btn-destructive, ...)', no_legacy),
  ('Custom select uses div.select with listbox, options and a hidden input', lambda h: chk(re.search(r'<div[^>]*class="[^"]*\bselect\b', h) and 'role="listbox"' in h and 'role="option"' in h and re.search(r'<input[^>]*type="hidden"', h), 'select structure present', 'custom select structure incomplete')),
  ('Select popup uses the data-popover container', lambda h: chk('data-popover' in h, 'data-popover present', 'no data-popover')),
  ('Toggle is a native checkbox with role="switch"', lambda h: chk(re.search(r'<input[^>]*type="checkbox"[^>]*role="switch"|<input[^>]*role="switch"[^>]*type="checkbox"', h), 'switch found', 'no checkbox role=switch')),
  ('Form controls are wrapped in .field', lambda h: chk(has_class(h, 'field'), '.field used', 'no .field wrapper')),
  ('Has a .toaster container and triggers a toast via the toast API', lambda h: chk(has_class(h, 'toaster') and re.search(r'\.toast\(', h), 'toaster + .toast({..})', 'missing .toaster or .toast({...}) call')),
  ('Delete confirmation is a native <dialog class="alert-dialog"> opened with showModal()', lambda h: chk(re.search(r'<dialog[^>]*class="[^"]*\balert-dialog\b', h) and 'showModal()' in h, 'alert-dialog + showModal', 'no dialog.alert-dialog with showModal')),
  ('Delete button uses class="btn" with data-variant="destructive"', lambda h: chk(tag_with(h, 'btn', 'data-variant="destructive"'), 'found', 'no btn[data-variant=destructive]')),
  ('Dark mode toggles the dark class on <html> (basecoat.theme or classList)', lambda h: chk(re.search(r'basecoat\.theme\.(toggle|set)|documentElement\.classList\.(toggle|add)\(\s*[\'"]dark', h), 'found', 'no dark-class toggle')),
 ]),
 1: ('members.html.jinja', [
  ('Extends base.html.jinja and fills the content block', lambda h: chk(re.search(r'{%-?\s*extends\s+"base\.html\.jinja"', h) and re.search(r'{%-?\s*block\s+content', h), 'ok', 'missing extends/block')),
  ('Uses no pre-1.0 compound classes', no_legacy),
  ('Table uses class="table"', lambda h: chk(re.search(r'<table[^>]*class="[^"]*\btable\b', h), 'ok', 'no table.table')),
  ('Row menu uses .dropdown-menu with data-popover, role="menu" and role="menuitem"', lambda h: chk(has_class(h, 'dropdown-menu') and 'data-popover' in h and 'role="menu"' in h and 'role="menuitem"' in h, 'ok', 'dropdown-menu structure incomplete')),
  ('Menu trigger is wired with aria-haspopup="menu" and aria-controls', lambda h: chk('aria-haspopup="menu"' in h and 'aria-controls=' in h, 'ok', 'missing aria-haspopup/aria-controls')),
  ('Per-row ids are unique (derived from member.id or loop index)', lambda h: chk(re.search(r'id="[^"]*{{\s*(member\.id|m\.id|loop\.index0?|[a-z_]*id)\s*[^}]*}}', h), 'ok', 'ids not derived from the row')),
  ('Dropdown is not placed inside a scrolling .table-container', lambda h: chk(not has_class(h, 'table-container') and not re.search(r'overflow-(x-)?(auto|scroll)', h), 'no scrolling wrapper around the table', 'table wrapped in a scrolling container that clips inline menus')),
  ('Avatar uses .avatar with a fallback when avatar_url is None', lambda h: chk(has_class(h, 'avatar') and re.search(r'{%-?\s*if\s+[a-z_.]*avatar_url', h), 'ok', 'no .avatar or no avatar_url conditional')),
  ('Status uses .badge with a variant or color per status', lambda h: chk(has_class(h, 'badge') and all(s in h for s in ('active', 'invited', 'suspended')), 'ok', 'badge/status mapping missing')),
  ('Remove action is styled as destructive', lambda h: chk(re.search(r'destructive', h), 'ok', 'no destructive styling')),
  ('Empty state uses the .empty component', lambda h: chk(has_class(h, 'empty'), 'ok', 'no .empty')),
  ('Pagination uses .btn links with page / total_pages', lambda h: chk(has_class(h, 'btn') and 'total_pages' in h and re.search(r'page\s*[-+]\s*1', h), 'ok', 'pagination incomplete')),
 ]),
 2: ('billing.html', [
  ('No pre-1.0 compound classes remain', no_legacy),
  ('Does not paper over the problem by loading the compat stylesheet', lambda h: chk('compat' not in h, 'no compat layer', 'compat layer loaded')),
  ('Outline button is class="btn" data-variant="outline"', lambda h: chk(re.search(r'<button[^>]*class="btn"[^>]*data-variant="outline"[^>]*>\s*Change plan', h), 'ok', 'not migrated')),
  ('Small ghost button has data-variant="ghost" and data-size="sm"', lambda h: chk(tag_with(h, 'btn', 'data-variant="ghost"', 'data-size="sm"'), 'ok', 'not migrated')),
  ('Icon button has data-variant="outline" and data-size="icon"', lambda h: chk(tag_with(h, 'btn', 'data-variant="outline"', 'data-size="icon"'), 'ok', 'not migrated')),
  ('Destructive button is class="btn" data-variant="destructive"', lambda h: chk(tag_with(h, 'btn', 'data-variant="destructive"'), 'ok', 'not migrated')),
  ('Primary button is a plain class="btn"', lambda h: chk(re.search(r'<button[^>]*class="btn"(?![^>]*data-variant="(?!primary)[a-z]+")[^>]*>\s*Update card', h), 'ok', 'not plain btn')),
  ('Alert is class="alert ..." with data-variant="destructive"', lambda h: chk(tag_with(h, 'alert', 'data-variant="destructive"'), 'ok', 'not migrated')),
  ('Badges are class="badge" with data-variant secondary / outline', lambda h: chk(tag_with(h, 'badge', 'data-variant="secondary"') and tag_with(h, 'badge', 'data-variant="outline"'), 'ok', 'not migrated')),
  ('CDN script is bumped off 0.3.2 to a 1.x version', lambda h: chk('0.3.2' not in h and re.search(r'basecoat-css@1', h), 'ok', 'script still on old version or unversioned')),
  ('Preserves the card structure and utility classes (max-w-xl, mb-6)', lambda h: chk(has_class(h, 'card') and has_class(h, 'max-w-xl') and has_class(h, 'mb-6'), 'ok', 'layout classes lost')),
 ]),
}

it = pathlib.Path(sys.argv[1])
for ev in sorted(it.glob('eval-*')):
    eid = int(ev.name.split('-')[1]); fname, checks = EVALS[eid]
    for run in sorted(ev.glob('*/run-*')):
        f = run / 'outputs' / fname
        if not f.exists():
            cands = [p for p in (run / 'outputs').glob('*') if p.suffix in ('.html', '.jinja')]
            f = cands[0] if cands else f
        h = f.read_text() if f.exists() else ''
        exps = []
        for text, fn in checks:
            ok, ev_ = fn(h) if h else (False, f'output file {fname} missing')
            exps.append({'text': text, 'passed': bool(ok), 'evidence': ev_})
        p = sum(e['passed'] for e in exps)
        out = {'expectations': exps, 'summary': {'passed': p, 'failed': len(exps) - p, 'total': len(exps), 'pass_rate': round(p / len(exps), 2)}}
        (run / 'grading.json').write_text(json.dumps(out, indent=2))
        print(f'{ev.name:38} {run.parent.name:14} {p}/{len(exps)}  ' + '; '.join(e['text'][:40] for e in exps if not e['passed']))
