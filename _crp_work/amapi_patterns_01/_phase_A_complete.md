# Phase A Complete — AMAPI-PATTERNS-01

**Completed:** 2026-04-20

## Samples read (6/6)

1. `generic_garmin-gtn-650_1ae7feb5` — raw_notes written ✓
2. `generic_garmin-gns-530_72b0d55c` — raw_notes written ✓
3. `generic_garmin-gns-430_24038c68` — raw_notes written ✓
4. `generic_bendixking-kap-140-autopilot-system_da394c59` — raw_notes written ✓
5. `generic_bendixking-kx-165a-ts0-com1nav1_a6f6d3b9` — raw_notes written ✓
6. `generic_garmin-gfc-500-autopilot_c154321a` — raw_notes written ✓

No `require` or `dofile` calls found in any sample — no lib/ files needed.

## Total distinct AMAPI functions observed across Tier 1

~49 distinct functions (excluding Lua builtins):

user_prop_add_integer, user_prop_add_boolean, user_prop_add_enum, user_prop_get, fif,
img_add_fullscreen, img_add, button_add, dial_add, dial_click_rotate, mouse_setting, touch_setting,
xpl_command, fsx_event, msfs_event, timer_start, timer_stop, timer_running,
xpl_dataref_subscribe, xpl_dataref_write, fsx_variable_subscribe, fs2020_variable_subscribe, fs2024_variable_subscribe, msfs_variable_subscribe, msfs_variable_write,
persist_add, persist_get, persist_put, canvas_add, canvas_draw,
video_stream_add, has_feature, instrument_prop,
xpl_connected, msfs_connected, request_callback,
group_add, opacity, visible, rotate, sound_add, sound_play,
si_variable_subscribe, txt_add, txt_set, var_round, var_cap,
scrollwheel_add_ver,
_rect, _fill, _txt (canvas drawing primitives)

## First pass of pattern candidates

| Pattern candidate | GTN650 | GNS530 | GNS430 | KAP140 | KX165A | GFC500 | Count |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Triple-dispatch button/dial (XPL+FSX+MSFS) | ✓ | ✓ | ✓ | ✓ | ✓ | — | **5/6** |
| Multi-variable subscription bus | — | ✓ | ✓ | ✓ | ✓ | ✓ | **5/6** |
| Power-state group visibility | — | — | — | ✓ | ✓ | ✓ | **3/6** |
| Named callback functions | — | — | — | ✓ | ✓ | ✓ | **3/6** |
| FS2024 reuses FS2020 callback | — | — | — | ✓ | ✓ | ✓† | **3/6** |
| Long-press via timer | ✓ | ✓ | ✓ | ✓ | — | — | **4/6** |
| Multi-instance device ID | ✓ | ✓ | ✓ | — | — | — | **3/6** |
| User prop boolean feature toggle | — | ✓ | ✓ | — | — | ✓ | **3/6** |
| Rotate-for-analog display | — | ✓ | ✓ | — | ✓ | — | **3/6** |
| img_add with initial style string | — | ✓ | ✓ | ✓ | — | — | **3/6** |
| Parallel XPL+MSFS subscriptions | — | ✓ | ✓ | — | — | — | **2/6** |
| Persist dial angle | — | ✓ | ✓ | — | — | — | **2/6** |
| Day/night group opacity | — | ✓ | ✓ | — | — | — | **2/6** |
| si_variable_subscribe backlight | — | ✓ | ✓ | — | — | — | **2/6** |
| Feature-detection guard (has_feature) | — | ✓ | ✓ | — | — | — | **2/6** |
| Platform-conditional canvas | — | ✓ | ✓ | — | — | — | **2/6** |
| mouse_setting + touch_setting pair | — | ✓ | ✓ | — | — | — | **2/6** |
| Sound-on-state-change | — | — | — | ✓ | — | ✓ | **2/6** |
| Annunciator visible pattern | — | — | — | ✓ | — | ✓ | **2/6** |
| Dual xpl_command (native+RXP) | — | ✓ | ✓ | — | — | — | **2/6** |
| xpl_command BEGIN/END for held key | — | ✓ | ✓ | — | — | — | **2/6** |
| Counted blink timer | — | — | — | ✓ | — | — | **1/6** (needs validation) |
| xpl_connected/msfs_connected branch | — | — | — | ✓ | — | — | **1/6** (needs validation) |
| request_callback force refresh | — | — | — | ✓ | — | — | **1/6** (needs validation) |
| FSX adapter function | — | — | — | — | ✓ | — | **1/6** (needs validation) |
| img_add with rotation animation style | — | — | — | — | ✓ | — | **1/6** (needs validation) |
| Animated opacity (LOG/LINEAR) | — | — | — | — | — | ✓ | **1/6** (needs validation) |
| FLC speed-capture pattern | — | — | — | — | — | ✓ | **1/6** (sample-specific) |
| Sync button (capture current value) | — | — | — | — | — | ✓ | **1/6** (needs validation) |
| L: LVAR in MSFS subscription | — | — | — | — | — | ✓ | **1/6** (needs validation) |
| Scrollwheel for VS input | — | — | — | — | — | ✓ | **1/6** (needs validation) |

† GFC 500 is MSFS-only so FS2024 and FS2020 share callbacks by definition.

**Confirmed patterns (≥2/6 Tier 1):** 21 candidates
**Single-sample candidates (need Tier 2 validation):** 10 candidates
