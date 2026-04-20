# Phase C Complete — AMAPI-PATTERNS-01

**Completed:** 2026-04-20

## Tier 2 patterns confirmed (vs Phase B confirmed list)

All 19 Phase B confirmed patterns were validated or not contradicted by Tier 2:

| Pattern | Tier 2 confirmation |
|---|---|
| Triple-dispatch button/dial | ✓ All Tier 2 samples that dispatch to sim use this |
| Multi-variable subscription bus | ✓ Heading, altimeter, VOR, ADF, switch panel, audio panels |
| FS2024 reuses FS2020 callback | ✓ Heading, altimeter, turn coord share callback |
| Long-press via timer | ✓ Garmin 340 power-up timer similar; ADF animation timer |
| Multi-instance device ID | Not tested (Tier 2 simpler instruments) |
| Power-state group visibility | ✓ Garmin 340 uses gbl_power explicit gate; GMA 1347D uses power check in callback |
| Rotate-for-analog display | ✓ Heading, altimeter (rotate needle images) |
| img_add with initial style string | ✓ Altimeter uses "rotate_animation_type: LOG; rotate_animation_speed: 0.08; rotate_animation_direction: FASTEST" |
| User-prop boolean feature toggle | ✓ Heading (background, dimming, animated flag, pilot/copilot), switch panel (Knobster) |
| Day/night group opacity via si backlight | ✓ GMA 1347D si_variable_subscribe backlight |
| Persist dial angle | Not tested (Tier 2 instruments don't have navigation dials) |
| Feature-detection guard | Not tested |
| Platform-conditional canvas | Not tested |
| Parallel XPL + MSFS subscriptions | ✓ Altimeter uses SAME callback for all three sims |
| mouse_setting + touch_setting pair | Not tested in Tier 2 survey |
| Sound-on-state-change | Not tested |
| Annunciator visible pattern | ✓ Garmin 340 and GMA 1347D — extensive use |
| Dual xpl_command (native + RXP) | Not applicable to Tier 2 (simpler instruments, no RXP) |
| xpl_command BEGIN/END for held key | Not tested |

## New patterns discovered from Tier 2 (5 new)

| # | New pattern | Source samples | Count |
|---|---|---|:---:|
| 20 | Detent-type user prop for hw_dial_add | Altimeter, VOR, ADF, heading | 4/8 Tier 2 |
| 21 | hw_dial_add for hardware rotary encoder binding | Altimeter, VOR, ADF, heading | 4/8 Tier 2 |
| 22 | FSX/MSFS sim-adapter normalization function | Heading, turn coord, switch panel (+ KX165A, KAP140 Tier 1) | 3/8 T2 + 2/6 T1 |
| 23 | FS2024 B: event dispatch (separate from H: and K: events) | GMA 1347D, switch panel | 2/8 Tier 2 |
| 24 | L: LVAR in MSFS/FSX subscriptions and writes | GMA 1347D, heading (T2) + GFC500 (T1) | 2/8 T2 + 1/6 T1 |

Note: Pattern 22 (FSX adapter) was a 1/6 Tier 1 candidate — now confirmed by multiple Tier 2 samples. Elevated to full pattern.
Note: Pattern 24 (L: LVAR) was a 1/6 Tier 1 candidate — confirmed by Tier 2. Elevated to full pattern.

## Single-sample candidates — final disposition

| Candidate | Disposition | Reason |
|---|---|---|
| Counted blink timer | → sample-specific appendix | Not seen in Tier 2 |
| xpl_connected/msfs_connected routing | → full pattern (grouped with request_callback, seen in KAP140+Garmin340) | Two instruments use request_callback routing |
| FSX adapter function | → Pattern 22 (confirmed) | 3/8 Tier 2 + 2/6 Tier 1 |
| img_add with rotation animation style | → merged into Pattern 8 (img_add style string) | Altimeter confirms; same idiom |
| Animated opacity LOG/LINEAR | → sample-specific appendix | Not broadly confirmed in Tier 2 |
| FLC speed-capture | → sample-specific appendix | Not seen in Tier 2 |
| Sync button: capture current value | → sample-specific appendix | Not seen in Tier 2 |
| L: LVAR in subscriptions | → Pattern 24 (confirmed) | GMA 1347D, heading (Tier 2) + GFC500 (Tier 1) |
| Scrollwheel for VS | → sample-specific appendix | Not seen in Tier 2 |
| Sound-or-silence pattern | → sample-specific appendix | Not seen in Tier 2 |

**Updated:** xpl_connected/msfs_connected routing merged into existing patterns (KAP140 Tier 1, request_callback_all Garmin340 Tier 2) → treated as variant of pattern 6 (power-state group) rather than separate pattern.

## Additional Tier 2 observations (not elevated to full patterns)

- **switch_add + switch_set_position** (switch panel only): toggle switch bidirectional sync. Single Tier 2 sample → appendix.
- **move() for ball position** (turn coordinator): 2D positional movement. Single Tier 2 sample → appendix.
- **Power-up test sequence timer** (Garmin 340): STATE_POWERUP_LIGHTS_ON animation. Single Tier 2 sample → appendix.
- **FS2024 separate subscription with different variable set** (GMA 1347D): FS2024 sub has COM TRANSMIT:3, COM RECEIVE:3 not in FS2020 sub. Single Tier 2 sample.
- **Inline anonymous callback in subscription** (GMA 1347D): callback defined inline as anonymous function in `_variable_subscribe` call. Used alongside named-function style. Interesting style variant.

## Updated final pattern count: 24

Phases A+B: 19 patterns
Phase C additions: 5 patterns (20–24)
Total: **24 patterns** ← within 15–30 target range
