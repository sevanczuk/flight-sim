# AMAPI Function Usage Matrix — Tier 1 Samples

**Generated:** 2026-04-20 (Phase B, AMAPI-PATTERNS-01)

Columns: 6 Tier 1 samples. Cells: approximate call count in that sample's logic.lua.
"–" = not called. "?" = count approximate (due to inline conditionals).

| AMAPI Function | GTN650 | GNS530 | GNS430 | KAP140 | KX165A | GFC500 | Total |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **User properties** | | | | | | | |
| `user_prop_add_integer` | 1 | 1 | 1 | – | – | – | 3 |
| `user_prop_add_boolean` | – | 1 | 1 | – | – | 3 | 5 |
| `user_prop_add_enum` | – | – | – | 1 | – | – | 1 |
| `user_prop_get` | 4 | 4 | 4 | 2 | – | 4 | 14 |
| **Images** | | | | | | | |
| `img_add_fullscreen` | 1 | 2 | 2 | 1 | 1 | 1 | 8 |
| `img_add` | 3 | ~10 | ~12 | ~12 | 3 | ~15 | ~55 |
| **Buttons / dials / input** | | | | | | | |
| `button_add` | 4 | ~15 | ~14 | 10 | 2 | ~12 | ~57 |
| `dial_add` | 3 | 6 | 6 | 2 | 6 | 2–3 | ~25 |
| `dial_click_rotate` | – | – | – | 2 | – | – | 2 |
| `mouse_setting` | 2 | 2 | 2 | 4 | 2 | – | 12 |
| `touch_setting` | – | 2 | 2 | – | – | – | 4 |
| `scrollwheel_add_ver` | – | – | – | – | – | 1 | 1 |
| **Sim write — XPL** | | | | | | | |
| `xpl_command` | ~18 | ~22 | ~22 | ~12 | ~8 | – | ~82 |
| `xpl_dataref_write` | – | 2 | 2 | 2 | 3 | – | 9 |
| **Sim write — MSFS/FSX** | | | | | | | |
| `fsx_event` | ~12 | – | – | – | ~8 | – | ~20 |
| `msfs_event` | ~14 | ~22 | ~22 | ~14 | ~8 | ~14 | ~94 |
| `msfs_variable_write` | – | – | – | – | – | 1 | 1 |
| **Sim subscribe — XPL** | | | | | | | |
| `xpl_dataref_subscribe` | – | 2 | 2 | 1 | 1 | – | 6 |
| **Sim subscribe — FSX** | | | | | | | |
| `fsx_variable_subscribe` | – | – | – | – | 1 | – | 1 |
| **Sim subscribe — MSFS** | | | | | | | |
| `fs2020_variable_subscribe` | – | – | – | 1 | 1 | – | 2 |
| `fs2024_variable_subscribe` | – | – | – | 1 | 1 | – | 2 |
| `msfs_variable_subscribe` | – | 2 | 2 | – | – | 3 | 7 |
| **Sim state queries** | | | | | | | |
| `xpl_connected` | – | – | – | 2 | – | – | 2 |
| `msfs_connected` | – | – | – | 2 | – | – | 2 |
| `request_callback` | – | – | – | 2 | – | – | 2 |
| **Timers** | | | | | | | |
| `timer_start` | 2 | 3 | 3 | 5 | – | – | 13 |
| `timer_stop` | 4 | 3 | 3 | ~8 | – | – | 18 |
| `timer_running` | 2 | 1 | 1 | 3 | – | – | 7 |
| **Persistence** | | | | | | | |
| `persist_add` | – | 3 | 3 | 1 | – | – | 7 |
| `persist_get` | – | 4+ | 4+ | 3+ | – | – | 11+ |
| `persist_put` | – | 3+ | 3+ | 2 | – | – | 8+ |
| **Canvas** | | | | | | | |
| `canvas_add` | – | 2 | 2 | – | – | – | 4 |
| `canvas_draw` | – | 2–3 | 2–3 | – | – | – | 4–6 |
| `_rect` | – | 2 | 2 | – | – | – | 4 |
| `_fill` | – | 2 | 2 | – | – | – | 4 |
| `_txt` | – | 4 | 4 | – | – | – | 8 |
| **Streaming** | | | | | | | |
| `video_stream_add` | – | 1 | 1 | – | – | – | 2 |
| `has_feature` | – | 1 | 1 | – | – | – | 2 |
| **Instrument metadata** | | | | | | | |
| `instrument_prop` | – | 2 | 2 | – | – | – | 4 |
| **Groups / layers / visibility** | | | | | | | |
| `group_add` | – | 2 | 2 | 1 | 1 | – | 6 |
| `visible` | – | 4 | 6 | ~30 | 2 | ~12 | ~54 |
| `opacity` | – | 4 | 4 | – | – | 5+ | ~13 |
| **Node transforms** | | | | | | | |
| `rotate` | – | 6+ | 6+ | – | 2 | – | 14+ |
| **Text** | | | | | | | |
| `txt_add` | – | – | – | 6 | 4 | – | 10 |
| `txt_set` | – | – | – | ~25 | 4 | – | ~29 |
| **Sound** | | | | | | | |
| `sound_add` | – | – | – | 2 | – | 3 | 5 |
| `sound_play` | – | – | – | 3 | – | ~15 | ~18 |
| **SI bus** | | | | | | | |
| `si_variable_subscribe` | – | 1 | 1 | – | – | – | 2 |
| **Value helpers** | | | | | | | |
| `var_round` | – | – | – | 1 | – | – | 1 |
| `var_cap` | – | 1 | 1 | 2 | 1 | – | 5 |
| **Built-in helper** | | | | | | | |
| `fif` | 3 | 1 | 1 | 1 | 1 | – | 7 |

## Co-occurrence analysis (for pattern identification)

The following function groups co-occur across multiple samples — each group is a pattern candidate:

### Group A: Triple-dispatch click action
`xpl_command` + `msfs_event` (+ optionally `fsx_event`) together inside a button/dial callback.
Samples: GTN650, GNS530, GNS430, KAP140, KX165A — **5/6**

### Group B: Multi-variable subscription bus
`xpl_dataref_subscribe`/`msfs_variable_subscribe`/`fsx_variable_subscribe` with multiple "var, TYPE, var, TYPE, ..." args → single callback.
Samples: GNS530, GNS430 (xpl+msfs), KAP140 (xpl+fs2020+fs2024), KX165A (xpl+fsx+fs2020+fs2024), GFC500 (msfs) — **5/6**

### Group C: FS2024 reuses FS2020 callback
`fs2024_variable_subscribe(..., same_callback_as_fs2020)`.
Samples: KAP140, KX165A, GFC500 (single msfs covers both) — **3/6**

### Group D: Long-press via timer
`button_add(press_cb, release_cb)` where press_cb calls `timer_start(delay, nil, long_action)` and release_cb checks `timer_running()` + `timer_stop()`.
Samples: GTN650, GNS530, GNS430, KAP140 — **4/6**

### Group E: Multi-instance device ID suffix
`user_prop_add_integer("Device ID"/"Unit", ...)` + `tostring(user_prop_get(...))` → suffix appended to command/event strings.
Samples: GTN650, GNS530, GNS430 — **3/6**

### Group F: Power-state group visibility
`group_add(img1, txt1, ...)` + `visible(group, power_condition)` — group all powered-display nodes, toggle as one.
Samples: KAP140, KX165A, GFC500 — **3/6**

### Group G: Rotate-for-analog display
`rotate(img, linear_map_of_value)` — map a 0–1 (or 0–100) sim variable to rotation degrees for a knob/needle image.
Samples: GNS530, GNS430, KX165A — **3/6**

### Group H: img_add with initial style string
`img_add(img, x, y, w, h, "angle_z:N; visible:false")` — initial visual state via style string in the add call.
Samples: GNS530, GNS430, KAP140 — **3/6** (and GFC500 uses for KD opacity)

### Group I: User-prop boolean feature toggle
`user_prop_add_boolean(...)` + `if user_prop_get(prop) then ... add UI element ... end` — conditional UI elements based on user settings.
Samples: GNS530, GNS430 (streaming), GFC500 (YD, Knobster, sounds) — **3/6**

### Group J: Day/night group opacity via si backlight
`group_add(night_imgs...)` + `group_add(day_imgs...)` + `si_variable_subscribe("si/backlight_intensity", "DOUBLE", function(i) opacity(night_group, i); opacity(day_group, 1-i) end)`.
Samples: GNS530, GNS430 — **2/6**

### Group K: Persist dial angle across sessions
`persist_add("angle", 0)` + on rotate: `persist_put(prs, persist_get(prs) + dir*5)` + `rotate(img, persist_get(prs))` + on startup: `img_add(..., "angle_z:" .. persist_get(prs))`.
Samples: GNS530, GNS430 — **2/6**

### Group L: Feature-detection guard
`if user_prop_get(streaming_prop) and has_feature("VIDEO_STREAM") then` — guard optional API usage.
Samples: GNS530, GNS430 — **2/6**

### Group M: Platform-conditional canvas message
`if instrument_prop("PLATFORM") == "RASPBERRY_PI" or ... then canvas_draw(...); button_add(dismiss) end`.
Samples: GNS530, GNS430 — **2/6**

### Group N: Parallel XPL + MSFS subscriptions for same state
Same state variable subscribed via both `xpl_dataref_subscribe` and `msfs_variable_subscribe`, each wired to separate update callbacks.
Samples: GNS530, GNS430 (COM/NAV volume) — **2/6**

### Group O: mouse_setting + touch_setting pair on dials
`mouse_setting(dial, "CLICK_ROTATE", N)` + `touch_setting(dial, "ROTATE_TICK", N)` always together.
Samples: GNS530, GNS430 — **2/6**

### Group P: Sound-on-state-change
`sound_add` + `sound_play` triggered by a state transition detected inside a subscription callback.
Samples: KAP140 (AP disconnect beep), GFC500 (every button press + state sounds) — **2/6**

### Group Q: Annunciator visible pattern
`img_add("indicator.png", ..., "visible:false")` + `visible(img, state_condition)` in subscription callback.
Samples: KAP140, GFC500 — **2/6**

### Group R: Dual xpl_command (native + RXP plugin)
Two `xpl_command()` calls per button: `"sim/GPS/..."` (default) + `"RXP/GNS/..."` (RXP plugin).
Samples: GNS530, GNS430 — **2/6**

### Group S: xpl_command BEGIN/END for held-key actions
`xpl_command("...", "BEGIN")` in press callback + `xpl_command("...", "END")` in release callback.
Samples: GNS530, GNS430 (CLR button) — **2/6**

### Group T (Tier 2 to validate): Counted blink timer
`timer_start(nil, interval_ms, count, function(count, max_count) ... end)`.
Samples: KAP140 — **1/6**

### Group U (Tier 2 to validate): xpl_connected/msfs_connected routing
`if xpl_connected() then request_callback(xpl_cb) elseif msfs_connected() then request_callback(msfs_cb) end`.
Samples: KAP140 — **1/6**
