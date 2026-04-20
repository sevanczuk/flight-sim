---
Created: 2026-04-20T14:27:48-04:00
Source: docs/tasks/amapi_crawler_bugfix_03_prompt.md
---

# AMAPI Crawler Backfill Completion Report

This is the backfill crawl summary for AMAPI-CRAWLER-BUGFIX-03.
Source: `assets/air_manager_api/crawl_complete.md` (post-backfill snapshot)

---

**Stop reason:** frontier empty
**Duration:** 0h 0m 56s

## URL counts by source and status

- source=discovered, status=fetched: 6
- source=discovered, status=out-of-scope: 525
- source=pre-existing, status=fetched: 54
- source=seed, status=fetched: 210
- source=seed, status=out-of-scope: 20

## Top 10 categories (post-backfill)

- wiki-other: 419
- file: 101
- external: 50
- Hw: 28
- youtube: 19
- Scene: 12
- User: 11
- unprefixed-api: 9
- Map: 8
- Running: 8

**Total bytes this run:** 764,333
**Discovered this run:** 63
**Failed this run:** 0

## New categories added by BUGFIX-03

| Category | Count | Notes |
| --- | --- | --- |
| unprefixed-api | 9 | Canvas draw callbacks: Circle, Ellipse, Hole, Log, Rect, Remove, Solid, Stroke, Triangle |
| redlink | 5 | Legacy redlink URLs marked out-of-scope during migration |
| Arc | 2 | Arc, Arc_to |
| Bezier | 1 | Bezier_to |
| Button | 2 | Button_add, Button_connection_tutorial |
| Dial | 3 | Dial_add, Dial_click_rotate, Dial_set_acceleration |
| Event | 1 | Event_subscribe |
| Fill | 5 | Fill, Fill_gradient_box/linear/radial, Fill_img |
| Game | 2 | Game_controller_add, Game_controller_list |
| Geo | 1 | Geo_rotate_coordinates |
| Has | 1 | Has_feature |
| Interpolate | 2 | Interpolate_linear, Interpolate_settings_from_user_prop |
| Layer | 2 | Layer_add, Layer_mouse_cursor |
| Line | 1 | Line_to |
| Panel | 1 | Panel_prop |
| Quad | 1 | Quad_to |
| Resource | 1 | Resource_info |
| Running | 8 | Running_img_add_cir/hor/ver/carot, Running_txt_add_cir/hor/ver/carot |
| Shut | 1 | Shut_down |
| Static | 1 | Static_data_load |
