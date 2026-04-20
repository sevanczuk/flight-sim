# Raw Notes: generic_garmin-gtn-650_1ae7feb5

## Metadata (from info.xml)

| Field | Value |
|---|---|
| Aircraft | Generic |
| Type | Garmin GTN 650 |
| Author | Sim Innovations |
| Version | 103 |
| Sim compat | XPL + FSX + P3D + FS2020 + FS2024 |
| Dimensions | 1600 × 675 |

## Structural outline

| Section | Lines | Summary |
|---|---|---|
| User props / device-ID setup | 1–5 | Adds Device ID integer prop, derives three sim-specific suffix forms |
| Background | 8 | `img_add_fullscreen("background.png")` |
| HOME button | 12–26 | Long-press button dispatching to all three sims |
| DIRECT-TO button | 27–31 | Simple triple-dispatch button |
| Top dial (VOL) | 34–46 | Triple-dispatch dial + decorative image overlay |
| Bottom outer dial (FMS OUTER) | 50–62 | Triple-dispatch outer dial + shadow/overlay images |
| Bottom inner dial (FMS INNER) | 64–78 | Triple-dispatch inner dial + custom mouse cursors |
| Rotary push buttons | 80–100 | Push buttons for VOL and FMS knob centers; both use long-press |

## API call inventory

| Function | Calls | Notes |
|---|---|---|
| `user_prop_add_integer` | 1 | Device ID prop (1..2) |
| `user_prop_get` | 4 | All at startup, to derive suffix variants |
| `fif` | 3 | Built-in ternary helper (not a standard standalone AMAPI function) |
| `img_add_fullscreen` | 1 | Background image |
| `img_add` | 3 | Decorative rotary overlays and shadow |
| `button_add` | 4 | home, direct, push_top, push_bottom |
| `dial_add` | 3 | top (VOL), bottom_outer (FMS outer), bottom_inner (FMS inner) |
| `mouse_setting` | 2 | CURSOR_LEFT/CURSOR_RIGHT on inner dial |
| `timer_start` | 2 | Long-press timers (1500ms HOME, 500ms push_bottom) |
| `timer_stop` | 4 | Called on press (to cancel stale) + on release (to cancel short-press) |
| `timer_running` | 2 | Guard in release callback |
| `xpl_command` | ~18 | Triple-dispatch: every action fires XPL command with device_id suffix |
| `fsx_event` | ~12 | Triple-dispatch: every action fires FSX event with device_id_rxp_fsx offset |
| `msfs_event` | ~14 | Triple-dispatch: every action fires MSFS H: event with device_id_pms suffix |

## Notable idioms observed

1. **Triple-dispatch (XPL + FSX + MSFS) on every interaction.** Every button press and dial rotation calls `xpl_command(...)`, `fsx_event(...)`, and `msfs_event(...)` in sequence. No sim-connected check — all three are always fired.

2. **Multi-instance device ID pattern.** At startup, `user_prop_get(device_id_prop)` derives three suffix forms:
   - XPL: `"_" .. tostring(device_id)` (e.g., `"HOME_1"` or `"HOME_2"`)
   - FSX: integer offset `device_id_rxp_fsx` = 0 or 8 (passed as second arg to fsx_event)
   - MSFS: `""` or `"_2"` string appended to event name

3. **Long-press detection via timer.** Press callback: `timer_stop(existing_timer)` then `timer_start(timeout, nil, long_press_cb)`. Release callback: check `timer_running(timer)` — if still running, it was a short press; cancel and fire short-press action. If not running, long-press already fired.
   - HOME: 1500ms threshold
   - push_bottom (FMS knob): 500ms threshold

4. **FSX press/release encoding.** The GTN 650 uses FSX event value offsets: +2 for press, +4 for release on the GPS_MENU_BUTTON and GPS_CURSOR_BUTTON events. This is a GTN 650 FSX convention, not a general AMAPI pattern.

5. **Decorative image layers over dials.** `img_add("rotary.png", ...)` is placed over the dial hit-area to provide the visual knob appearance. The dial hit-area itself uses a transparent or dark-version image for click registration.

6. **`fif()` helper.** Used three times at startup for ternary-style expressions. Appears to be a built-in AMAPI helper (not in the A2 reference docs as a standalone function — may be a scripting convenience).

## Sim-portability approach

Triple-dispatch without any sim-connected check. All three simulator APIs (XPL, FSX, MSFS) are called unconditionally on every user action. Only the device-ID suffixes vary. This is the simplest and most portable approach — dead code on the non-connected sim is harmless.

## Questions / anomalies

- `fif()` is used as a ternary helper but does not appear in the A2 AMAPI reference. Is it a built-in scripting helper or defined somewhere else?
- No dataref subscriptions at all — this instrument is purely input-side (drives the GPS unit's avionics). It does not read any sim state back to display. The GPS display itself is handled by the simulator's pop-out (or streaming). This is the key design difference from instruments like the KAP 140 that render their own display.
- The `img_add_fullscreen("background.png")` appears AFTER the button adds (lines 7–10), but it is a background. This is unusual — if z-order is declaration-order, background should be first. Likely the instrument drawing system does a z-sort by declared type, or the button hit-areas are independent of z-order.
