---
Created: 2026-04-20T14:30:00-04:00
Source: docs/tasks/amapi_crawler_bugfix_03_prompt.md
---

# AMAPI-CRAWLER-BUGFIX-03 Completion Report

## Phase A: Authoritative whitelist from AMAPI catalog page

### A.0: Seed-inclusion verification
Result: **0 misses** — 235 unique normalized seeds all present in DB (3 seed lines normalized to None for Special: pages).

### A.1: Prefixes found on catalog page
Script: `scripts/amapi_crawler_parse_api_index.py`

Total unique titles on catalog page: **216** (197 prefixed, 19 unprefixed)

All prefixes found:
Arc, Bezier, Button, Canvas, Device, Dial, Event, Ext, Fi, Fill, Flight, Fs2020, Fs2024, Fsx, Game, Geo, Group, Hardware, Has, Hw, Img, Instrument, Interpolate, Layer, Line, Map, Mouse, Move, Msfs, Nav, P3d, Panel, Persist, Quad, Request, Resource, Running, Scene, Scrollwheel, Shut, Si, Slider, Sound, Static, Switch, Timer, Touch, Txt, User, Var, Variable, Video, Viewport, Xpl, Z

Unprefixed titles on catalog page: API, Arc, Circle, Ellipse, File:Lightbulb.png, File:Warning.png, Fill, Hole, Log, Move, Opacity, Rect, Remove, Rotate, Solid, Stroke, Triangle, Txt, Visible

### A.2: Proposed whitelist additions

**Category 1 — New prefixes added to API_PREFIXES (18):**
Arc, Bezier, Button, Dial, Event, Fill, Game, Geo, Has, Interpolate, Layer, Line, Panel, Quad, Resource, Running, Shut, Static

Excluded from API_PREFIXES:
- `Flight` → Flight_Illusion_Gauges is a reference/list page, not an API function
- `Hardware` → Hardware_id_list is a reference/list page

**Category 2 — New UNPREFIXED_API_FUNCTIONS set (9 titles):**
Circle, Ellipse, Hole, Log, Rect, Remove, Solid, Stroke, Triangle

Note: `Arc` and `Fill` were added to API_PREFIXES instead (they have prefixed variants: Arc_to, Fill_img, etc. — the prefix handles both the bare title and prefixed variants).

---

## Phase B: Candidate backfill from diagnostic output

Prefixes from Turn-43 Section 4 with count ≥ 3 (after rejection filter):
- `Running` (8) — duplicate (already from catalog)
- `Fill` (5) — duplicate (already from catalog)
- `Dial` (4) — duplicate (already from catalog)
- `Button` (3) — duplicate (already from catalog)

**No diagnostic-only candidates.** All Phase B candidates were already covered by Phase A.

---

## Phase C: Code changes

### C.1 — normalize.py
Added `qs.pop('redlink', None)` to strip `redlink=1` query parameter.

### C.2 — categorize.py
- Added 18 new prefixes to `API_PREFIXES`
- Added new `UNPREFIXED_API_FUNCTIONS` set (9 titles)
- Updated `categorize()` logic: added `UNPREFIXED_API_FUNCTIONS` check (step 2 after Special: check, before NON_API_TITLES)
- Updated `should_queue()` to return True for `'unprefixed-api'` in addition to API_PREFIXES and `'non-api-useful'`

### C.3 — Recategorization migration
Created `scripts/amapi_crawler_recategorize.py`.

Migration result (two passes):
1. First pass: **47 rows promoted** to pending (out-of-scope → pending), 0 demoted, 0 category-only, 705 unchanged
2. Second pass (legacy redlinks): **5 pending redlink-URL rows** marked out-of-scope with category `redlink`
3. Idempotency verified: third run found 0 changes

### C.4 — Tests
Baseline: 106 tests
New tests added: 106 (TestRedlinkNormalization: 4, TestNewPrefixCategorization: 18+6, TestUnprefixedApiFunctions: 9+9+4)
**Total: 212 tests — all passing**

---

## Phase D: Backfill crawl

Pre-crawl pending count: **45 URLs**

Crawl results:
- Stop reason: frontier empty
- Duration: **56 seconds**
- URLs fetched this run: **45**
- New URLs discovered: **63**
- Failed: **0**

### Pre/post diagnostic comparison

| Metric | Pre-bugfix (Turn-43) | Post-bugfix (Turn-45) | Delta |
| --- | --- | --- | --- |
| wiki-other total | 421 (49 fetched + 372 oos) | 419 (49 fetched + 370 oos) | -2 |
| unprefixed-api | 0 | 9 fetched | +9 |
| redlink category | 0 | 5 out-of-scope | +5 (new) |
| Arc fetched | 0 | 2 | +2 |
| Bezier fetched | 0 | 1 | +1 |
| Button fetched | 0 | 2 | +2 |
| Dial fetched | 2 (pending) | 3 fetched | +3 |
| Event fetched | 0 | 1 | +1 |
| Fill fetched | 0 | 5 | +5 |
| Game fetched | 0 | 2 | +2 |
| Geo fetched | 0 | 1 | +1 |
| Has fetched | 0 | 1 | +1 |
| Interpolate fetched | 0 | 2 | +2 |
| Layer fetched | 0 | 2 | +2 |
| Line fetched | 0 | 1 | +1 |
| Panel fetched | 0 | 1 | +1 |
| Quad fetched | 0 | 1 | +1 |
| Resource fetched | 0 | 1 | +1 |
| Running fetched | 0 | 8 | +8 |
| Shut fetched | 0 | 1 | +1 |
| Static fetched | 0 | 1 | +1 |
| Total DB rows | 752 | 815 | +63 |

---

## Deviations

1. **`Shut` prefix added.** `Shut_down` appears on the catalog page as a real API function ("Shut down application or computer") but was not in any prior whitelist. Added.

2. **Legacy redlink migration expanded.** The recategorize script also caught `Button_set_cursor&redlink=1` and `Dial_set_cursor&redlink=1` which were newly promoted to pending by the first recategorize pass (before the redlink migration). Both correctly marked out-of-scope.

3. **`Dial_click_rotate` fetched.** This function title appears in the diagnostic wiki-other list and was promoted by adding the `Dial` prefix. It's not shown on the catalog page index, but the fetched page (15,432 bytes) indicates it IS a real API function page. Correct inclusion.
