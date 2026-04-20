# Raw Notes: generic_garmin-gns-530_72b0d55c

## Metadata (from info.xml)

| Field | Value |
|---|---|
| Aircraft | Generic |
| Type | Garmin GNS 530 |
| Author | Sim Innovations (note: typo "Sim Innovavations" in XML) |
| Version | 110 |
| Sim compat | XPL + FS2020 + FS2024 (no FSX/P3D) |
| Dimensions | 1600 × 1180 |

## Structural outline

| Section | Lines | Summary |
|---|---|---|
| User props + globals | 1–6 | Streaming flag, unit selection (1/2), version + volume tracking vars |
| Persistence | 8–10 | `persist_add` for left and right dial angles |
| Canvas setup | 12–16 | Streaming background canvas + message canvas |
| Platform-conditional message (Raspberry Pi/tablet) | 17–31 | Canvas warning + dismiss button for non-desktop platforms |
| Platform-conditional message (desktop, one-time) | 33–49 | Persist-gated first-launch message |
| Streaming setup | 51–69 | Feature-gated video_stream_add with polling timer |
| XPL version subscription | 71–73 | Detect XPL12 for streaming eligibility |
| Background image | 75 | `img_add_fullscreen` |
| COM controls | 77–103 | Volume dial (xpl write + msfs event), subscribe (xpl+msfs), COM swap button |
| NAV controls | 105–130 | Same structure as COM |
| COM/NAV (C/V) outer+inner dials | 133–173 | Dual-concentric dual-sim dial pair with persist angle |
| CRSR outer+inner dials | 176–216 | Same pattern as C/V dials |
| Bottom buttons | 218–301 | CDI, OBS, MSG, FPL, VNAV, PROC + Range + Direct + Menu + CLR + ENT |
| Night/day groups | 303–313 | Group night images + day images, opacity controlled by si_variable_subscribe |

## API call inventory

| Function | Calls | Notes |
|---|---|---|
| `user_prop_add_boolean` | 1 | Streaming enable |
| `user_prop_add_integer` | 1 | Unit 1 or 2 |
| `user_prop_get` | 4+ | Startup + conditional checks |
| `persist_add` | 3 | angle_left, angle_right, msg_read |
| `persist_get` | 4+ | Dial angle + message-read flag |
| `persist_put` | 3+ | Dial angle on rotate + msg_read on dismiss |
| `canvas_add` | 2 | Streaming background + message overlay |
| `canvas_draw` | 2–3 | Platform-specific message content |
| `instrument_prop` | 2 | Platform detection ("PLATFORM") |
| `has_feature` | 1 | "VIDEO_STREAM" guard |
| `video_stream_add` | 1 | XPL12 pop-out stream |
| `timer_start` | 3 | Polling timer (2500ms), CLR long-press (2000ms), one implicit |
| `timer_stop` | 3 | Cancel polling timer + CLR timer |
| `timer_running` | 1 | CLR button release check |
| `xpl_dataref_subscribe` | 2 | XPL version (INT) + COM volume (FLOAT) |
| `xpl_dataref_write` | 2 | COM volume + NAV volume |
| `msfs_variable_subscribe` | 2 | COM volume + NAV volume |
| `xpl_command` | ~22 | Dual per button: sim native + RXP plugin |
| `msfs_event` | ~22 | MSFS H: events for every action |
| `img_add_fullscreen` | 2 | Background + night labels |
| `img_add` | ~10 | Rotary images, LED rings, shadows |
| `button_add` | ~15 | All control buttons + dismiss buttons |
| `dial_add` | 4 | com_outer, com_inner, page_outer, page_inner + 2 vol dials = 6 total |
| `mouse_setting` | 2 | CLICK_ROTATE setting on outer dials |
| `touch_setting` | 2 | ROTATE_TICK setting on outer dials |
| `rotate` | 6+ | Dial angle restore + volume-to-rotation mapping |
| `visible` | 4 | Canvas and button visibility for dismiss |
| `opacity` | 4 | Group opacity for day/night |
| `group_add` | 2 | night group + day group |
| `si_variable_subscribe` | 1 | backlight intensity |
| `var_cap` | 1 | Volume clamp |

## Notable idioms observed

1. **Triple-dispatch (XPL + MSFS) on every interaction.** Every button fires both `xpl_command` (sometimes two: sim-native + RXP) and `msfs_event`. No FSX since GNS530 is XPL+FS2020+FS2024 only.

2. **Dual xpl_command (sim-native + RXP plugin).** Buttons fire both `"sim/GPS/g430n..."` (default X-Plane GPS) AND `"RXP/GNS/..."` (RealityXP GNS plugin). This handles two different XPL GPS implementations simultaneously.

3. **Persist dial angle across sessions.** `persist_add("angle_left", 0)` stores the rotary knob's visual angle; every rotation does `persist_put(prs_angle_left, persist_get(prs_angle_left) + dir * 5)` + `rotate(img, persist_get(...))`. On startup, `img_add(..., "angle_z:" .. persist_get(prs_angle_left))` restores last angle in the style string.

4. **Platform-conditional one-time message.** `persist_add("msg_read", false)` + `if not persist_get(pers_msg_read)` shows a first-launch info message on desktop only. The dismiss button calls `persist_put(pers_msg_read, true)`. On Raspberry Pi / tablet, message shows unconditionally every launch.

5. **Feature-detection guard + streaming + polling timer.** `has_feature("VIDEO_STREAM")` gates the video_stream_add block. Then a periodic timer (`timer_start(nil, 2500, cb)`) polls `g_xpl_version >= 120000` to know when XPL12 is ready; stops timer and enables stream when ready.

6. **Parallel XPL + MSFS volume subscriptions.** COM volume: both `xpl_dataref_subscribe("...audio_volume_com...", "FLOAT", cb)` and `msfs_variable_subscribe("COM VOLUME:1", "Percent", cb)` are registered — different callbacks updating the same visual (rotate the dial image). XPL write uses `xpl_dataref_write`; MSFS write uses `msfs_event("K:COM1_VOLUME_INC/DEC")`.

7. **Day/night group opacity.** Night-mode images (LED rings, night dial variants) are grouped with `group_add(img_night, ...)` and day images with `group_add(img_day, ...)`. `si_variable_subscribe("si/backlight_intensity", "DOUBLE", cb)` toggles `opacity(group_night, intensity)` and `opacity(group_day, 1 - intensity)`.

8. **mouse_setting + touch_setting pair on dials.** For the outer C/V and CRSR dials: `mouse_setting(dial, "CLICK_ROTATE", 5)` sets 5° per mouse click, and `touch_setting(dial, "ROTATE_TICK", 5)` sets 5° per touch tick. Always paired together.

9. **Long-press for CLR button with xpl_command BEGIN/END.** Press callback: `xpl_command(..., "BEGIN")` + `timer_start(2000, long_press_cb)`. Release callback: `xpl_command(..., "END")` + `timer_running` check to distinguish short vs. long press.

10. **img_add with initial style string.** `img_add("rotary.png", x, y, w, h, "angle_z:45")` — style string sets initial visual state without a `rotate()` call.

## Sim-portability approach

XPL + MSFS (no FSX). Every action dispatches to both sims. Volume uses different APIs per sim (xpl_dataref_write vs msfs_event), reflecting that the two sims have different mechanisms for the same operation. No sim-connected checks; both are always called.

## Questions / anomalies

- `img_add_fullscreen("background.png")` is placed at line 75, AFTER buttons at lines 12+. Z-order must not be purely declaration-order, or this is a known pattern where background is declared last and the framework sorts it to z=0.
- `fif()` used in one call for avionics adapter — same observation as GTN 650. Built-in helper.
- The GNS530 logic.lua is functionally a pure **input passthrough** — all display is handled by the simulator's GPS pop-out window (or XPL12 video stream). No sim-state subscriptions except COM/NAV volume and XPL version.
