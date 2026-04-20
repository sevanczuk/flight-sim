# Raw Notes: generic_bendixking-kx-165a-ts0-com1nav1_a6f6d3b9

## Metadata (from info.xml)

| Field | Value |
|---|---|
| Aircraft | Generic |
| Type | Bendix/King KX 165A TS0 - COM1/NAV1 |
| Author | Sim Innovations |
| Version | 218 (mature, heavily refined) |
| Sim compat | XPL + FSX + P3D + FS2020 + FS2024 (all five!) |
| Dimensions | 700 × 223 |

## Structural outline

| Section | Lines | Summary |
|---|---|---|
| Global state variables | 1–6 | Power, channel, vol tracking vars |
| Named callback functions | 8–170 | new_onoff, new_navvol, new_comtransfer, new_navtransfer, new_combig, new_comsmall, new_navbig, new_navsmall |
| Images | 172–177 | Background + redline + two volume-dial images with animation style |
| Text nodes | 179–183 | COM active/standby + NAV active/standby |
| Power state group | 185–188 | group_add of display elements + visible(false) initially |
| Subscription callbacks | 190–280 | new_navcomm (XPL), new_navcom_fsx (FSX adapter), new_navcom_fs2020 (MSFS) |
| Widget creation | 283–295 | switch_onoff, nav_volume dials; comtransfer, navtransfer buttons; combig, comsmall, navbig, navsmall dials |
| XPL multi-var subscribe | 297–314 | 16 variables → new_navcomm |
| FSX multi-var subscribe | 315–324 | 10 variables → new_navcom_fsx |
| FS2020 multi-var subscribe | 325–338 | 14 variables → new_navcom_fs2020 |
| FS2024 multi-var subscribe | 339–352 | Same 14 variables → new_navcom_fs2020 |

## API call inventory

| Function | Calls | Notes |
|---|---|---|
| `img_add_fullscreen` | 1 | Background |
| `img_add` | 3 | Redline + two volume knob images with animation style |
| `txt_add` | 4 | COM active, COM standby, NAV active, NAV standby |
| `txt_set` | 4 | In new_navcomm callback |
| `group_add` | 1 | group_powered — all display elements |
| `visible` | 2 | Initially hide group, toggle in callbacks |
| `dial_add` | 6 | switch_onoff (power/vol), nav_volume, combig, comsmall, navbig, navsmall |
| `button_add` | 2 | comtransfer, navtransfer |
| `mouse_setting` | 2 | CURSOR_LEFT/RIGHT on comsmall, navsmall |
| `xpl_command` | ~8 | COM/NAV frequency, transfer, power |
| `xpl_dataref_write` | 3 | Volume write + power write |
| `fsx_event` | ~8 | FSX COM/NAV events (parallel with XPL + MSFS) |
| `msfs_event` | ~8 | MSFS COM/NAV events |
| `xpl_dataref_subscribe` | 1 | 16-variable multi-var → new_navcomm |
| `fsx_variable_subscribe` | 1 | 10-variable multi-var → new_navcom_fsx |
| `fs2020_variable_subscribe` | 1 | 14-variable multi-var → new_navcom_fs2020 |
| `fs2024_variable_subscribe` | 1 | Same 14 → new_navcom_fs2020 |
| `rotate` | 2 | Volume dial rotation (maps vol % to degrees) |
| `var_cap` | 1 | Volume clamp |
| `string.format` | 4 | Frequency formatting |
| `fif` | 1 | FSX avionics adapter (bool → int) |

## Notable idioms observed

1. **Triple-dispatch (XPL + FSX + MSFS) — full four-sim version.** The KX 165A supports XPL + FSX + P3D + FS2020 + FS2024. Every action fires `xpl_command(...)`, `fsx_event(...)`, and `msfs_event(...)` in sequence. FSX covers both FSX and P3D; msfs_event covers both FS2020 and FS2024.

2. **FSX adapter function.** `new_navcom_fsx()` receives FSX variable values in Mhz (float) and converts to the integer Hz format used by the XPL callback `new_navcomm()`, then delegates to it. This normalizes FSX's different data scale into a single display function. The adapter also handles FSX's boolean avionics (true/false) → integer (1/0) conversion using `fif()`.

3. **Quad-subscription: XPL + FSX + FS2020 + FS2024.** Four separate subscription calls, each with its own variable names and callback. FSX and FS2020 use Mhz floats; XPL uses integer Hz. FS2024 reuses the fs2020 callback.

4. **img_add with rotation animation style string.** `img_add("offswitch.png", x, y, w, h, "rotate_animation_type: LINEAR; rotate_animation_speed: 0.05")` — the image will animate to new rotation values smoothly, without any code changes to the `rotate()` call. The animation is configured once in the style string.

5. **power-state group for display.** `group_powered = group_add(redline, txt_com, txt_comstby, txt_nav, txt_navstby)` + `visible(group_powered, false)` initially. In the callback, `visible(group_powered, gbl_power)` shows/hides all display elements together.

6. **Rotate-for-analog-dial.** Volume dial: `rotate(img_com_vol, 15 + com_vol * 250)` maps 0–1 float volume to 15°–265° rotation. When power off: `rotate(img_com_vol, 0)` snaps to off position. For MSFS (0–100%): `rotate(img_com_vol, 15 + com_vol * 2.5)` — different scale factor.

7. **Stateless channel dispatch.** `gbl_channel` is a Lua global (0 or 1 for COM1/COM2). All callback functions use `if gbl_channel == 0 then ... else ... end` to select correct frequency commands. The UI doesn't visually switch channels — it's a single-instrument that serves both channels by sharing display. (Actually: the display shows whichever channel is active based on how the instrument was configured, not a runtime toggle in this version.)

8. **Named functions for dial callbacks.** All eight action functions (new_combig, new_comsmall, etc.) are named declarations. The dial_add calls reference them by name: `dial_add("dialbig.png", x, y, w, h, new_combig)`. Note: this form includes the step count as the 5th positional argument (or it may be absorbed differently — the GFC 500 pattern shows `dial_add(..., 3, callback)` explicitly).

## Sim-portability approach

Full four-sim: XPL + FSX + FS2020 + FS2024. Uses separate subscriptions and adapter callbacks per sim. The display logic is unified in `new_navcomm()`; sim-specific data normalization happens in adapter functions.

## Questions / anomalies

- Version 218 is notably high — this instrument has been through many revisions, suggesting it's battle-tested and idiomatic.
- The `gbl_channel` variable (0 or 1) does not appear to be set anywhere visible in the 352-line file — it starts at 0 and remains 0. Either the channel selection mechanism was removed in a prior refactor, or it's controlled by a user prop not visible here. Channel 0 = COM1/NAV1 by default.
- `fsx_event` + `msfs_event` being fired together in every callback is notable: MSFS and FSX get the same event names, so this is a convenient dual-dispatch that works because MSFS retained FSX event compatibility.
