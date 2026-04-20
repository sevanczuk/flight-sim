# Raw Notes: generic_garmin-gfc-500-autopilot_c154321a

## Metadata (from info.xml)

| Field | Value |
|---|---|
| Aircraft | Generic |
| Type | Garmin GFC 500 autopilot |
| Author | Sim Innovations / SIMSTRUMENTATION |
| Version | 115 |
| Sim compat | FS2020 + FS2024 ONLY (no XPL, no FSX) |
| Dimensions | 687 × 255 |
| Description | Made by SIMSTRUMENTATION; Knobster support; YD shown via user prop |

## Structural outline

| Section | Lines | Summary |
|---|---|---|
| File-level comment block | 1–39 | Version history, notes, attribution |
| User props | 41–43 | YD shown (bool), Knobster (bool), Play Sounds (bool) |
| Sound setup | 50–58 | Conditional sound_add — real or silence.wav based on prop |
| Global state variables | 60–64 | scroll_vs_mode, currentHeading, currentAltitude, power |
| Background images + backlighting | 66–76 | Black back, white backlight (opacity 0), AP background, dial shadows |
| Button callbacks (named) | 78–209 | release, callback_hdg/nav/ap/lvl/flc/alt/apr/fd/vs/vnv/yd, altitude_input, heading_input, vs_callback |
| MSFS FLC state subscription | 114 | msfs_variable_subscribe for FLC mode tracking |
| MSFS airspeed subscription | 132 | msfs_variable_subscribe for IAS capture |
| Button creation | 211–229 | 10+ mode buttons with press+release callbacks |
| Conditional YD button | 223–229 | if user_prop_get(up_yd_shown) → add YD button + annunciator |
| Sync buttons | 231–239 | Heading sync + altitude sync buttons |
| Annunciator images | 241–251 | white_triangle_lit images, all visible:false |
| Main MSFS subscription | 304–322 | 17-variable multi-var → ap_cb |
| Second airspeed subscription | 324–328 | Duplicate for FLC use |
| Backlighting + dial images | 330–368 | Z-order: backlit_labels + dials added last |
| Heading dial | 334 | dial_add with step count (3) |
| Altitude dial | 336 | dial_add with step count (3) |
| VS scrollwheel | 342 | scrollwheel_add_ver for thumbwheel |
| Conditional Knobster dial | 345–364 | if user_prop_get(knobster_prop) → dial_add over scrollwheel area |

## API call inventory

| Function | Calls | Notes |
|---|---|---|
| `user_prop_add_boolean` | 3 | YD shown, Knobster, Play Sounds |
| `user_prop_get` | 4+ | At setup + in conditionals |
| `sound_add` | 3 | press.wav (or silence), release.wav (or silence), dial.wav (or silence) |
| `sound_play` | ~15 | Every button press/release/dial rotation |
| `msfs_variable_subscribe` | 3 | FLC state + airspeed + main 17-var |
| `msfs_event` | ~14 | Every AP mode action |
| `msfs_variable_write` | 1 | L:SF50_vnav_enable (commented out) |
| `img_add` | ~15 | Backgrounds, shadows, annunciators, labels |
| `img_add_fullscreen` | 1 | AP background |
| `opacity` | 5+ | Backlight, shadows, labels, animated transitions |
| `button_add` | ~12 | All AP mode buttons, sync buttons (all with press+release) |
| `dial_add` | 2 (+ 1 conditional) | heading_dial (step 3), altitude_dial (step 3), optional Knobster dial |
| `scrollwheel_add_ver` | 1 | VS thumbwheel |
| `visible` | ~12 | Annunciator images, YD button |

## Notable idioms observed

1. **MSFS-only instrument.** All subscriptions are `msfs_variable_subscribe`; all writes are `msfs_event`. No `xpl_*` calls at all. This is the counterexample to the triple-dispatch instruments — a single-sim implementation for modern Garmin G5/GFC500 which has no meaningful XPL equivalent.

2. **Sound-on-every-interaction with silence fallback.** `user_prop_add_boolean("Play Sounds", ...)`. If true: `sound_add("press.wav")`. If false: `sound_add("silence.wav")`. The callback always calls `sound_play(press_snd)` — the silent file makes it a no-op. This avoids conditional checks in every callback.

3. **user_prop_add_boolean for UI feature toggle.** Three boolean user props: YD visibility, Knobster mode, sounds. All checked at instrument startup to configure the UI layout. Conditional `if user_prop_get(up_yd_shown)` adds the YD button and its annunciator; else they don't exist. This affects the DOM structure, not just visibility.

4. **Release callback for sound.** Every button uses `button_add(nil, press_img, x, y, w, h, press_callback, release)` where `release` is a shared function that just plays `release_snd`. This provides press-and-release audio feedback on every button.

5. **Animated opacity transitions.** `opacity(img_backlight, 1, "LOG", 0.1)` fades in with a logarithmic curve at speed 0.1. `opacity(img_backlight, 0, "LINEAR", 0.05)` fades out linearly. The `opacity()` call supports animation type + speed as optional arguments.

6. **L: variable subscription.** `msfs_variable_subscribe` includes `"L:XMLVAR_VNAVBUTTONVALUE", "Number"` — an LVAR (local variable from MSFS gauge code). AMAPI can subscribe to LVARs exactly like SimConnect variables.

7. **A: prefix override in subscription.** `"A:ELECTRICAL MAIN BUS VOLTAGE", "Volts"` — explicit `A:` prefix to force Aircraft variable resolution (vs default which might resolve ambiguously). Demonstrates that MSFS variable subscriptions accept SimConnect-style prefixes.

8. **FLC speed-capture pattern.** `AirspeedIndicated` is captured via a dedicated `msfs_variable_subscribe("AIRSPEED INDICATED", "knots", aspd_callback)`. When FLC is activated, `msfs_event("AP_SPD_VAR_SET", math.floor(AirspeedIndicated))` sets the FLC target speed to the current airspeed. This requires maintaining a "current value" global updated by a subscription, then reading it in a button callback.

9. **Sync button pattern.** `button_add` with a callback that fires `msfs_event("HEADING_BUG_SET", currentHeading)` or `msfs_event("AP_ALT_VAR_SET_ENGLISH", currentAltitude)`. The sync button "captures" the current sim value (stored in a global by a subscription callback) and sets the AP reference to it.

10. **Scrollwheel for VS thumbwheel.** `scrollwheel_add_ver("vs_thumb.png", x, y, w, h, 30, 30, vs_callback)` — a vertical scrollwheel widget distinct from `dial_add`. Used for the VS/IAS thumbwheel that maps to different events based on `scroll_vs_mode` state.

11. **Z-order via declaration order (dials added last).** Comment: "backlight labels and knobs added at the end to maintain z-order" (line 330). Dials and their top images are declared after all button and image creation to appear on top visually.

12. **VNAV via LVAR write (commented out).** The VNAV button has commented-out code for aircraft-specific LVARs (`L:SF50_vnav_enable`), falling back to a standard MSFS H: event. Shows the pattern for handling aircraft-specific MSFS behavior via LVARs.

13. **Dual variable-subscribe calls for same variable.** `msfs_variable_subscribe("AIRSPEED INDICATED", ...)` appears twice — once in the FLC setup block (line 132) and once in the ap_cb block (line 324). The second one shadows/duplicates the first. This appears to be a code evolution artifact rather than intentional.

## Sim-portability approach

MSFS-only. No dual-dispatch needed. This instrument represents the "single-sim modern" pattern — appropriate for instruments that only exist in FS2020/2024 aircraft (GFC 500 autopilot is native to G3/G5-equipped aircraft not in XPL's default avionics).

## Questions / anomalies

- The `callback_flc` function is defined twice (lines 106–108 and 116–125) — the second definition overrides the first. The first is a subscription callback that captures FLC state; the second is the button callback. This is a naming collision that works in Lua because function assignment is just variable binding. The `msfs_variable_subscribe` at line 114 captures the first `callback_flc`; by line 116 that function name is reassigned.
- The GFC 500 notably does NOT use `has_feature()` or platform detection, suggesting it's designed purely for desktop.
- `user_prop_get(knobster_prop)` creates a physical dial on top of the scrollwheel for Knobster hardware compatibility — shows how a single instrument can support both software touch and physical hardware inputs via conditional user props.
