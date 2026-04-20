# Raw Notes: generic_bendixking-kap-140-autopilot-system_da394c59

## Metadata (from info.xml)

| Field | Value |
|---|---|
| Aircraft | Generic |
| Type | Bendix/King KAP 140 Autopilot System |
| Author | Sim Innovations |
| Version | 110 |
| Sim compat | XPL + FS2020 + FS2024 (no FSX/P3D) |
| Dimensions | 700 × 182 |
| Note | "Does not work perfect with FS2020, because of lack of functionality and variables in FS2020." |

## Structural outline

| Section | Lines | Summary |
|---|---|---|
| Copyright comment | 1–4 | Header comment block |
| User props | 5–6 | Enum prop for sound on/off |
| Global state variables | 8–22 | Power, autopilot mode, altitude, alert states, VS visibility |
| Persistence | 24–25 | inHg/hPA unit selection |
| Images | 27–42 | Background + all annunciator images (most initially hidden) |
| Text nodes | 44–49 | Six text display items for LCD segment display |
| Window overlay image | 52–53 | img_add for LCD window frame |
| Item group | 55–56 | group_add for all text/visual items |
| Sounds | 58–60 | sound_add for 2seconds.wav + 5beeps.wav |
| Dial/button callback functions | 63–258 | Named function declarations (not inline) |
| Baro timer | 259–266 | Periodic baro display countdown |
| XPL subscription callback (new_xpl_data) | 268–470 | State-machine display update function |
| FS2020 subscription callback (new_fs2020_data) | 473–702 | Parallel display function for MSFS |
| Buttons and dials | 704–725 | Actual widget creation, referencing named callbacks |
| XPL multi-var subscribe | 727–744 | 17 variables → new_xpl_data |
| FS2020 multi-var subscribe | 746–766 | 21 variables → new_fs2020_data |
| FS2024 multi-var subscribe | 768–787 | Same 21 variables → new_fs2020_data (reused callback) |

## API call inventory

| Function | Calls | Notes |
|---|---|---|
| `user_prop_add_enum` | 1 | "Aural alert" — "On,Off" enum |
| `user_prop_get` | 2 | At callback time (not startup) for sound check |
| `persist_add` | 1 | inHg/hPa unit preference |
| `persist_get` | 3+ | Read unit pref in callbacks |
| `persist_put` | 2 | Toggle unit pref in baro callback |
| `img_add_fullscreen` | 1 | Background |
| `img_add` | ~12 | Annunciator images (all initially visible:false) |
| `txt_add` | 6 | LCD segment display items |
| `txt_set` | ~25 | Display update throughout new_xpl_data + new_fs2020_data |
| `group_add` | 1 | item_group for power-gated display |
| `visible` | ~30 | Annunciator + text visibility throughout callbacks |
| `sound_add` | 2 | 2seconds.wav + 5beeps.wav |
| `sound_play` | 3 | Disconnect sound + altitude alert beeps |
| `dial_add` | 2 | big_dial, small_dial |
| `dial_click_rotate` | 2 | 2° per click for both dials |
| `mouse_setting` | 4 | CURSOR_LEFT + CURSOR_RIGHT for each dial |
| `button_add` | 8 | AP, HDG, NAV, APR, REV, ALT, UP, DN, ARM, BARO (10 total with ARM+BARO) |
| `xpl_command` | ~12 | XPL AP commands (in named callbacks) |
| `xpl_dataref_write` | 2 | Direct altitude + barometer write |
| `msfs_event` | ~14 | MSFS AP events in parallel |
| `xpl_dataref_subscribe` | 1 | 17-variable multi-var → new_xpl_data |
| `fs2020_variable_subscribe` | 1 | 21-variable multi-var → new_fs2020_data |
| `fs2024_variable_subscribe` | 1 | Same 21 variables → new_fs2020_data |
| `xpl_connected` | 2 | Guards request_callback routing |
| `msfs_connected` | 2 | Guards request_callback routing |
| `request_callback` | 2 | Force immediate redraw after button press |
| `timer_start` | 5 | Baro countdown, baro switching, HDG blink, deviation blink, altitude reached flash |
| `timer_stop` | ~8 | Cancel timers in various states |
| `timer_running` | 3 | Guard duplicate timer starts |
| `var_round` | 1 | Round VS FPM to 0 decimals |
| `var_cap` | 2 | Clamp altitude values |
| `fif` | 1 | Used in FSX-compat adapter call |
| `string.format` | ~10 | LCD display formatting |

## Notable idioms observed

1. **Named callback functions declared before widget creation.** All button and dial callbacks (big_dial_callback, hdg_callback, api_callback, etc.) are defined as named `function ... end` declarations in the top half of the file. Button/dial creation happens later, referencing these names. Contrast with GTN 650 where callbacks are all inline.

2. **Multi-variable subscription bus (single call, multiple vars).** `xpl_dataref_subscribe("var1", "TYPE1", "var2", "TYPE2", ..., callback)` — 17 XPL variables all subscribe to one callback `new_xpl_data`. The callback receives all values as parameters. Same for FS2020 (21 variables). This is the core AMAPI pattern for reading instrument state.

3. **FS2024 reuses FS2020 callback.** `fs2024_variable_subscribe(..., new_fs2020_data)` — identical variable list as the fs2020 subscription but wired to the same callback. This works because FS2024 exposes the same variable names as FS2020.

4. **Parallel XPL / MSFS state callbacks.** Two large callback functions: `new_xpl_data(...)` and `new_fs2020_data(...)` — each handles all display update logic for their respective simulator. They share the same output operations (txt_set, visible) but interpret different input parameters in sim-specific ways.

5. **xpl_connected / msfs_connected branching for request_callback.** In button callbacks that need to force an immediate display refresh: `if xpl_connected() then request_callback(new_xpl_data) elseif msfs_connected() then request_callback(new_fs2020_data) end`. Routes the forced callback to the active sim's handler.

6. **user_prop_add_enum for discrete choice.** `user_prop_add_enum("Aural alert", "On,Off", "On", "description")` creates a dropdown; `user_prop_get(prop_sound) == "On"` checked at callback time to gate sound playback.

7. **Counted blink timer.** `timer_start(nil, 250, 20, function(count, max_count) ... end)` — the third argument limits the timer to 20 firings (5 seconds at 250ms). Used for the HDG blink animation on REV mode selection.

8. **Sound-on-state-change.** Tracks `old_autopilot_mode`; plays `snd_2seconds` (disconnect beep) when autopilot transitions from engaged to off. Sound fired by comparing old vs new state in the subscription callback.

9. **Alert state machine with multiple concurrent timers.** The altitude alerter manages three timers (deviation blink, momentary flash, HDG blink) with state variables (`within_200_stb`, `alt_reached`, `beep_alert`) interacting across XPL and MSFS callbacks. Complex but self-contained.

10. **power-state group for LCD display.** `group_add(txt_item2, txt_item3, ..., txt_item6)` is the `item_group`. `visible(item_group, gbl_power)` shows/hides all LCD elements at once when power comes on/off.

11. **img_add with "visible:false" initial style.** `img_add("ap_light.png", x, y, w, h, "visible:false")` — all annunciator images start hidden. `visible(img_ap, condition)` in the callback toggles them.

12. **dial_click_rotate separate from dial_add.** Dial sensitivity is set after creation: `dial_click_rotate(dial_big, 2)` (2° per mouse click). Always paired with `dial_add`.

## Sim-portability approach

XPL and MSFS (no FSX). Uses separate subscription paths and separate callback functions per sim. Uses `xpl_connected()` / `msfs_connected()` to route `request_callback()` after button presses. The MSFS path has two subs (fs2020 + fs2024) sharing the same callback.

## Questions / anomalies

- `arm_callback()` only calls `xpl_command("sim/autopilot/altitude_arm")` — no MSFS equivalent. The comment says "-- FS2020?" indicating incomplete MSFS support for the ARM mode. This is consistent with the info.xml note about limited FS2020 support.
- The KAP 140 is the most sophisticated stateful instrument in Tier 1 — it fully manages its own display state machine unlike the Garmin GPS units (which delegate display to the simulator's pop-out).
- `baro_vis_time` is a countdown counter (decremented by a periodic timer at 100ms, so 30 = 3 seconds visibility). An interesting approach to timed UI visibility without storing timestamps.
