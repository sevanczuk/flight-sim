---
Created: 2026-04-20T00:00:00Z
Source: docs/tasks/amapi_patterns_prompt.md
---

# AMAPI Pattern Catalog — Sample Appendix

**Companion document:** [AMAPI Pattern Catalog](amapi_patterns.md)

This appendix provides per-sample summaries for all 6 Tier 1 and 8 Tier 2 instruments analyzed during AMAPI-PATTERNS-01. It also catalogs sample-specific techniques — idioms that appeared in only one Tier 1 sample and did not validate broadly enough to become full patterns.

---

## Tier 1 Sample Summaries

### generic_garmin-gtn-650_1ae7feb5

| Field | Value |
|---|---|
| Type | Garmin GTN 650 |
| Sim compat | XPL + FSX + P3D + FS2020 + FS2024 |
| Dimensions | 1600 × 675 |
| Version | 103 |

**Description.** Pure input passthrough instrument — no display state. The GTN 650 delegates all GPS display to the simulator's pop-out window. The logic.lua is entirely buttons and dials firing triple-dispatch commands. 100 lines, no subscriptions. The simplest Tier 1 instrument structurally.

**Patterns exhibited.**
- [Pattern 1: Triple-dispatch button/dial](amapi_patterns.md#pattern-1-triple-dispatch-buttondial) — every button and dial fires XPL + FSX + MSFS
- [Pattern 4: Long-press button via timer](amapi_patterns.md#pattern-4-long-press-button-via-timer) — HOME (1500ms) and FMS push (500ms)
- [Pattern 5: Multi-instance device ID suffix](amapi_patterns.md#pattern-5-multi-instance-device-id-suffix) — Device ID 1–2 for pilot/copilot

**Sample-specific techniques.**
- *FSX press/release encoding:* FSX event value offsets (+2 press, +4 release) for GPS_MENU_BUTTON and GPS_CURSOR_BUTTON. GTN 650-specific convention.
- *Decorative image over dial hit-area:* `img_add("rotary.png")` is placed over the dial's hit-area for visual appearance. The dial itself has a dark/transparent image for click registration.

---

### generic_garmin-gns-530_72b0d55c

| Field | Value |
|---|---|
| Type | Garmin GNS 530 |
| Sim compat | XPL + FS2020 + FS2024 |
| Dimensions | 1600 × 1180 |
| Version | 110 |

**Description.** More complex input passthrough than GTN 650 — adds COM/NAV volume control with subscription-based display (rotate dials), persistent knob angles, day/night theming, streaming, and first-launch messaging. Represents the full feature set for a non-autopilot GPS navigator.

**Patterns exhibited.**
- [Pattern 1: Triple-dispatch button/dial](amapi_patterns.md#pattern-1-triple-dispatch-buttondial) — dual-dispatch (XPL + MSFS; no FSX on GNS 530)
- [Pattern 2: Multi-variable subscription bus](amapi_patterns.md#pattern-2-multi-variable-subscription-bus) — COM/NAV volume subscriptions (small 2-var buses)
- [Pattern 4: Long-press button via timer](amapi_patterns.md#pattern-4-long-press-button-via-timer) — CLR button (2000ms)
- [Pattern 5: Multi-instance device ID suffix](amapi_patterns.md#pattern-5-multi-instance-device-id-suffix) — Unit 1 or 2
- [Pattern 7: Rotate-for-analog display](amapi_patterns.md#pattern-7-rotate-for-analog-display) — volume dials rotated by subscription callback
- [Pattern 8: img_add with initial style string](amapi_patterns.md#pattern-8-img_add-with-initial-style-string) — rotary images initialized with persisted angle
- [Pattern 9: User-prop boolean feature toggle](amapi_patterns.md#pattern-9-user-prop-boolean-feature-toggle) — streaming enable gates video_stream_add
- [Pattern 10: Day/night group opacity via si backlight](amapi_patterns.md#pattern-10-daynight-group-opacity-via-si-backlight) — night LEDs vs. day dial images
- [Pattern 11: Persist dial angle across sessions](amapi_patterns.md#pattern-11-persist-dial-angle-across-sessions) — outer knob angle persisted
- [Pattern 12: Feature-detection guard](amapi_patterns.md#pattern-12-feature-detection-guard-has_feature) — `has_feature("VIDEO_STREAM")` guards streaming
- [Pattern 13: Platform-conditional canvas message](amapi_patterns.md#pattern-13-platform-conditional-canvas-message) — Pi/tablet vs. desktop first-launch message
- [Pattern 14: Parallel XPL + MSFS subscriptions](amapi_patterns.md#pattern-14-parallel-xpl--msfs-subscriptions-for-same-state) — COM/NAV volume separate XPL + MSFS subs
- [Pattern 15: mouse_setting + touch_setting pair](amapi_patterns.md#pattern-15-mouse_setting--touch_setting-pair-on-dials) — outer dials get both settings
- [Pattern 18: Dual xpl_command](amapi_patterns.md#pattern-18-dual-xpl_command-native--rxp-plugin) — every button fires sim-native + RXP command
- [Pattern 19: xpl_command BEGIN/END](amapi_patterns.md#pattern-19-xpl_command-beginend-for-held-key-actions) — CLR button press/release

**Sample-specific techniques.**
- *Polling timer for XPL12 readiness:* `timer_start(nil, 2500, poll_cb)` polls `g_xpl_version >= 120000` before enabling streaming. Not broadly used across other instruments.
- *Platform-gated first-launch persist:* Desktop shows a first-launch message once (persist-gated dismiss). Pi/tablet shows it every launch. The distinction and per-platform message content are sample-specific.

---

### generic_garmin-gns-430_24038c68

| Field | Value |
|---|---|
| Type | Garmin GNS 430 |
| Sim compat | XPL + FS2020 + FS2024 |
| Dimensions | 1600 × 1180 |
| Version | 112 |

**Description.** Functionally identical to GNS 530 in structure and pattern set — confirms all GNS 530 patterns apply to the 430 variant. Minor differences: NAV2 vs. NAV1 frequency IDs; slightly different button layout. A close structural sibling rather than an independent design.

**Patterns exhibited.** All 16 patterns from GNS 530 — confirmed:
- Patterns 1, 2, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 18, 19 (see GNS 530 list above)

**Sample-specific techniques.** Same techniques as GNS 530 (polling timer, per-platform message). The GNS 430 adds no novel techniques beyond the 530.

---

### generic_bendixking-kap-140-autopilot-system_da394c59

| Field | Value |
|---|---|
| Type | Bendix/King KAP 140 Autopilot System |
| Sim compat | XPL + FS2020 + FS2024 |
| Dimensions | 700 × 182 |
| Version | 110 |

**Description.** The most complex Tier 1 sample — a fully stateful display instrument with its own LCD state machine. Unlike the GPS passthrough instruments, the KAP 140 renders all display text and annunciators itself. The 787-line logic.lua contains named callback functions, parallel XPL/MSFS display paths, multiple concurrent alert timers, and sound-on-state-change. The reference implementation for stateful autopilot instruments.

**Patterns exhibited.**
- [Pattern 1: Triple-dispatch button/dial](amapi_patterns.md#pattern-1-triple-dispatch-buttondial) — all AP mode buttons dispatch to XPL + MSFS
- [Pattern 2: Multi-variable subscription bus](amapi_patterns.md#pattern-2-multi-variable-subscription-bus) — 17 XPL vars → `new_xpl_data`; 21 MSFS vars → `new_fs2020_data`
- [Pattern 3: FS2024 reuses FS2020 callback](amapi_patterns.md#pattern-3-fs2024-reuses-fs2020-callback) — explicit `fs2024_variable_subscribe(..., new_fs2020_data)`
- [Pattern 4: Long-press button via timer](amapi_patterns.md#pattern-4-long-press-button-via-timer) — ALT mode button long-press
- [Pattern 6: Power-state group visibility](amapi_patterns.md#pattern-6-power-state-group-visibility) — `item_group` contains all 6 LCD text items
- [Pattern 8: img_add with initial style string](amapi_patterns.md#pattern-8-img_add-with-initial-style-string) — all 12 annunciator images start with `"visible:false"`
- [Pattern 16: Sound on state change](amapi_patterns.md#pattern-16-sound-on-state-change) — AP disconnect beep + altitude deviation beeps
- [Pattern 17: Annunciator visible pattern](amapi_patterns.md#pattern-17-annunciator-visible-pattern) — 12 annunciators toggled throughout state machine callbacks

**Sample-specific techniques.**
- *Counted blink timer:* `timer_start(nil, 250, 20, function(count, max_count) ... end)` — 4th argument limits timer to N firings total. Used for HDG blink on REV mode. Not seen in other Tier 1 or Tier 2 samples.
- *xpl_connected / msfs_connected routing:* `if xpl_connected() then request_callback(new_xpl_data) elseif msfs_connected() then request_callback(new_fs2020_data) end` — force immediate display refresh after a button press by routing to the active sim's callback. Seen in KAP 140 + Garmin 340 (Tier 2) → not elevated to full pattern but is a recognized idiom.
- *Counter-based timed visibility:* `baro_vis_time` is a countdown integer decremented by a 100ms periodic timer (30 = 3 seconds). Different from timer duration — more like a frame counter. Sample-specific.
- *Named function declarations before widget creation:* All callbacks are `local function name() ... end` at top of file; `button_add` references the names later. Contrasts with GTN 650's inline callbacks. A style convention, not a distinct pattern.

---

### generic_bendixking-kx-165a-ts0-com1nav1_a6f6d3b9

| Field | Value |
|---|---|
| Type | Bendix/King KX 165A TS0 - COM1/NAV1 |
| Sim compat | XPL + FSX + P3D + FS2020 + FS2024 |
| Dimensions | 700 × 223 |
| Version | 218 |

**Description.** Five-sim COM/NAV radio — the only Tier 1 sample supporting all five simulator platforms. Contains the FSX adapter normalization function (Pattern 22) for translating FSX's MHz float format to the XPL Hz integer format. A mature instrument (v218) with clean separation between display logic and sim-specific adapters.

**Patterns exhibited.**
- [Pattern 1: Triple-dispatch button/dial](amapi_patterns.md#pattern-1-triple-dispatch-buttondial) — five-sim variant (XPL + FSX + MSFS)
- [Pattern 2: Multi-variable subscription bus](amapi_patterns.md#pattern-2-multi-variable-subscription-bus) — three separate buses: 16-var XPL, 10-var FSX, 14-var MSFS
- [Pattern 3: FS2024 reuses FS2020 callback](amapi_patterns.md#pattern-3-fs2024-reuses-fs2020-callback) — FS2024 wired to same callback as FS2020
- [Pattern 6: Power-state group visibility](amapi_patterns.md#pattern-6-power-state-group-visibility) — `group_powered` contains all COM/NAV display elements
- [Pattern 7: Rotate-for-analog display](amapi_patterns.md#pattern-7-rotate-for-analog-display) — volume dial rotated with XPL 0–1 → 15°–265° mapping
- [Pattern 8: img_add with initial style string](amapi_patterns.md#pattern-8-img_add-with-initial-style-string) — volume knob images with `"rotate_animation_type: LINEAR; rotate_animation_speed: 0.05"`
- [Pattern 22: FSX/MSFS sim-adapter normalization](amapi_patterns.md#pattern-22-fsxmsfs-sim-adapter-normalization-function) — `new_navcom_fsx()` normalizes MHz floats + bool power to Hz ints + int power

**Sample-specific techniques.** None — all observed idioms generalized to confirmed patterns.

---

### generic_garmin-gfc-500-autopilot_c154321a

| Field | Value |
|---|---|
| Type | Garmin GFC 500 Autopilot |
| Sim compat | FS2020 + FS2024 ONLY |
| Dimensions | 687 × 255 |
| Version | 115 |

**Description.** MSFS-only autopilot — the counterexample to the triple-dispatch instruments. Demonstrates modern single-sim development for G5/GFC500 aircraft that have no meaningful XPL equivalent. Rich user-prop feature system (YD button, Knobster, sounds) shows how to build configurable instruments.

**Patterns exhibited.**
- [Pattern 2: Multi-variable subscription bus](amapi_patterns.md#pattern-2-multi-variable-subscription-bus) — 17-var MSFS bus → `ap_cb`
- [Pattern 6: Power-state group visibility](amapi_patterns.md#pattern-6-power-state-group-visibility) — opacity-based power animation (variant)
- [Pattern 9: User-prop boolean feature toggle](amapi_patterns.md#pattern-9-user-prop-boolean-feature-toggle) — YD Shown, Knobster, Play Sounds
- [Pattern 16: Sound on state change](amapi_patterns.md#pattern-16-sound-on-state-change) — interaction sounds on every button press/release
- [Pattern 17: Annunciator visible pattern](amapi_patterns.md#pattern-17-annunciator-visible-pattern) — white triangle annunciators for each AP mode
- [Pattern 24: L: LVAR in MSFS subscriptions](amapi_patterns.md#pattern-24-l-lvar-in-msfsxpl-subscriptions-and-writes) — `L:XMLVAR_VNAVBUTTONVALUE` subscribed; `L:SF50_vnav_enable` write

**Sample-specific techniques.**
- *Sound-or-silence fallback:* `if user_prop_get(up_sounds) then sound_add("press.wav") else sound_add("silence.wav") end` — the callback always calls `sound_play(press_snd)` without conditionals. Silent file makes it a no-op. Avoids callback branching at runtime. Clever one-sample idiom; not seen broadly.
- *FLC speed-capture:* Separate `msfs_variable_subscribe` for airspeed maintains `g_airspeed_indicated` global. FLC button callback reads the global and passes it to `msfs_event("AP_SPD_VAR_SET", math.floor(g_airspeed_indicated))`. Pattern of "subscribe to maintain a global, read the global in a button callback." Single Tier 1 instance.
- *Sync button:* Button callback that reads a global (currentHeading, currentAltitude maintained by subscription) and writes it back to the sim via `msfs_event("HEADING_BUG_SET", currentHeading)`. The "sync current sim value to AP bug" pattern. Single Tier 1 instance.
- *Scrollwheel for VS thumbwheel:* `scrollwheel_add_ver("vs_thumb.png", x, y, w, h, 30, 30, vs_callback)` — distinct from `dial_add`; a vertical scrollwheel widget. Single Tier 1 instance.
- *Dual variable_subscribe for same variable:* `msfs_variable_subscribe("AIRSPEED INDICATED", ...)` appears twice — code evolution artifact, not intentional. The second subscription overwrites the first's callback binding.
- *Z-order comment / late declaration:* Backlight labels and dials are declared last in the file to appear on top in z-order (comment explains this explicitly). Convention, not a distinct API pattern.

---

## Tier 2 Sample Summaries

### cessna-172_heading_079a54d1

**Description.** Simple heading indicator — heading needle driven by sim subscription, heading bug input via knob. Basic instrument representative of the Cessna 172 suite.

**Patterns confirmed:**
- Pattern 2 (multi-var bus), Pattern 7 (rotate-analog), Pattern 20 (detent user prop), Pattern 21 (hw_dial_add), Pattern 22 (FSX adapter — heading degrees format normalization)

---

### cessna-172_altimeter_cf5829f6

**Description.** Altimeter — altitude needle + barometric pressure setting. First Tier 2 instrument to exhibit the detent user prop and hw_dial_add patterns (Patterns 20, 21). Rotation animation style string confirmed (Pattern 8 variant).

**Patterns confirmed:**
- Pattern 2 (multi-var bus), Pattern 7 (rotate-analog), Pattern 8 (animation style string), Pattern 20 (detent user prop), Pattern 21 (hw_dial_add), Pattern 22 (FSX adapter — pressure normalization)

---

### cessna-172_vor-nav1ils_94a0e896

**Description.** VOR/NAV1/ILS indicator — course deviation, flag states, OBS knob. Confirms hw_dial_add pattern for OBS setting.

**Patterns confirmed:**
- Pattern 2 (multi-var bus), Pattern 7 (rotate-analog), Pattern 17 (annunciator — TO/FROM/GS flags), Pattern 20 (detent user prop), Pattern 21 (hw_dial_add)

---

### cessna-172_adf_04a6aa5d

**Description.** ADF indicator — ADF needle rotation, frequency display. Confirms hw_dial_add for frequency tuning knob.

**Patterns confirmed:**
- Pattern 2 (multi-var bus), Pattern 7 (rotate-analog), Pattern 20 (detent user prop), Pattern 21 (hw_dial_add)

---

### cessna-172_switch-panel_0fb7ea63

**Description.** Cessna 172 switch panel — master battery, alternator, avionics, lights. Primarily toggle switches. Confirms FS2024 B: event dispatch (Pattern 23) and FSX adapter (Pattern 22).

**Patterns confirmed:**
- Pattern 1 (triple-dispatch), Pattern 22 (FSX adapter), Pattern 23 (FS2024 B: event)

---

### generic_garmin-340-audio-panel_d30c0bb4

**Description.** Garmin 340 audio panel — COM/NAV/ADF/DME audio routing. Extensive annunciator array. Includes power-up test sequence timer (sample-specific). Confirms annunciator pattern and power-state group.

**Patterns confirmed:**
- Pattern 6 (power-state group), Pattern 17 (annunciator visible)

**Sample-specific technique:** *Power-up test sequence timer* — `STATE_POWERUP_LIGHTS_ON` animation cycles through all annunciators on power-up. A splash-screen animation driven by a timer sequence. Single sample.

---

### generic_garmin-gma-1347d-audio-panel_965144b1

**Description.** Garmin GMA 1347D audio panel — COM/NAV/ADF audio routing with FS2024 COM TRANSMIT:3 variable support. Demonstrates inline anonymous callback style and FS2024 B: event bus. Confirms Pattern 23 and Pattern 24 (L: LVAR).

**Patterns confirmed:**
- Pattern 2 (multi-var bus), Pattern 17 (annunciator), Pattern 23 (FS2024 B: event), Pattern 24 (L: LVAR)

**Sample-specific technique:** *Inline anonymous callback:* Some subscriptions define their callback inline as an anonymous function inside the `_variable_subscribe` call, rather than a named function. Both styles appear in the same instrument — a style variant, not a distinct pattern.

---

### cessna-172_turn-coordinator_487838a2

**Description.** Turn coordinator — gyroscope ball position and needle. Uses `move()` for ball position (2D positional movement, distinct from `rotate()`). Single Tier 2 sample using this function.

**Patterns confirmed:**
- Pattern 2 (multi-var bus), Pattern 7 (rotate-analog — turn needle)

**Sample-specific technique:** *move() for ball position:* `move(img_ball, x_offset, 0)` positions the inclinometer ball laterally based on slip value. `move()` is a 2D translation function distinct from `rotate()`. Not seen in any other Tier 1 or Tier 2 sample.

---

## Sample-specific techniques catalog

These idioms appeared in only one Tier 1 sample and did not generalize to the broader corpus. They are documented here for completeness and future reference.

| Technique | Source | Description |
|---|---|---|
| Counted blink timer | KAP 140 (Tier 1) | `timer_start(nil, interval, N, cb)` — 4th arg limits total firings. Used for HDG blink on REV mode (20 firings × 250ms = 5 seconds). |
| xpl_connected / msfs_connected routing | KAP 140 (Tier 1) + Garmin 340 (Tier 2) | Route `request_callback` to the active sim's handler after a button press to force immediate display refresh. Not elevated because it's a supporting detail within Pattern 2 (multi-var bus) rather than a standalone pattern. |
| Polling timer for XPL12 readiness | GNS 530/430 (Tier 1) | `timer_start(nil, 2500, poll_cb)` polls `g_xpl_version >= 120000` before enabling video stream. Used only in streaming-capable GPS instruments. |
| Sound-or-silence fallback | GFC 500 (Tier 1) | `sound_add("silence.wav")` when sounds are disabled so `sound_play` calls are always safe. Avoids runtime conditional checks. |
| FLC speed-capture | GFC 500 (Tier 1) | Maintain current airspeed global via subscription; read it in FLC button callback to set AP speed target. |
| Sync button (capture current value) | GFC 500 (Tier 1) | Button reads subscription-maintained global (heading, altitude) and writes it back to sim as AP reference. |
| Scrollwheel for VS input | GFC 500 (Tier 1) | `scrollwheel_add_ver` for a vertical thumbwheel distinct from `dial_add`. |
| Power-up test sequence timer | Garmin 340 (Tier 2) | Timer-driven annunciator sweep on power-up (splash screen animation). |
| Inline anonymous callback | GMA 1347D (Tier 2) | Anonymous function defined inline in `_variable_subscribe` call instead of named function. Style variant. |
| move() for ball position | Turn coordinator (Tier 2) | `move(img, x, y)` for 2D translation of an inclinometer ball image. |
| Animated opacity with LOG/LINEAR curve | KX 165A / GFC 500 (Tier 1) | `opacity(img, value, "LOG", speed)` — animate opacity with curve type. Present in two samples but as supporting detail within Pattern 6 (power-state group) rather than a standalone pattern. |
| Platform-gated first-launch persist | GNS 530/430 (Tier 1) | Desktop: first-launch message dismissed via persist flag. Pi/tablet: message shows every launch. The per-platform differentiation logic is sample-specific even though the underlying patterns (12, 13) are confirmed. |
| FSX press/release encoding | GTN 650 (Tier 1) | FSX event value offsets (+2 press, +4 release) for GPS_MENU_BUTTON. GTN 650 / RXP plugin convention. |
