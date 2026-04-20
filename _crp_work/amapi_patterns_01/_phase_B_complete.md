# Phase B Complete — AMAPI-PATTERNS-01

**Completed:** 2026-04-20

## Confirmed pattern count: 19

All patterns appearing in ≥2 Tier 1 samples are confirmed. See function_usage_matrix.md §Co-occurrence analysis for group definitions.

| # | Pattern | Group | Tier-1 count |
|---|---|---|:---:|
| 1 | Triple-dispatch button/dial (XPL + FSX + MSFS) | A | 5/6 |
| 2 | Multi-variable subscription bus | B | 5/6 |
| 3 | FS2024 reuses FS2020 callback | C | 3/6 |
| 4 | Long-press button via timer | D | 4/6 |
| 5 | Multi-instance device ID suffix | E | 3/6 |
| 6 | Power-state group visibility | F | 3/6 |
| 7 | Rotate-for-analog display | G | 3/6 |
| 8 | img_add with initial style string | H | 3/6 |
| 9 | User-prop boolean feature toggle | I | 3/6 |
| 10 | Day/night group opacity via si backlight | J | 2/6 |
| 11 | Persist dial angle across sessions | K | 2/6 |
| 12 | Feature-detection guard (has_feature) | L | 2/6 |
| 13 | Platform-conditional canvas message | M | 2/6 |
| 14 | Parallel XPL + MSFS subscriptions for same state | N | 2/6 |
| 15 | mouse_setting + touch_setting pair on dials | O | 2/6 |
| 16 | Sound-on-state-change | P | 2/6 |
| 17 | Annunciator visible pattern | Q | 2/6 |
| 18 | Dual xpl_command (native + RXP plugin) | R | 2/6 |
| 19 | xpl_command BEGIN/END for held-key actions | S | 2/6 |

## Pattern-candidates-rejected: 0

No candidates with ≥2 Tier 1 samples were rejected. All are elevated to confirmed patterns.

## Single-sample candidates (Tier 2 validation pending)

These appeared in exactly 1 Tier 1 sample. Will validate against Tier 2 in Phase C:

| Candidate | Source sample | Validation question |
|---|---|---|
| Counted blink timer (limited-count timer_start) | KAP140 | Do altimeter or other stateful instruments use this? |
| xpl_connected/msfs_connected routing for request_callback | KAP140 | Is this pattern in stateful instruments that need immediate refresh? |
| FSX adapter function (normalize FSX data to XPL scale) | KX165A | Is FSX-specific normalization seen in Tier 2 legacy instruments? |
| img_add with rotation animation style string | KX165A | Do volume dials in other instruments use this? |
| Animated opacity with curve type (LOG/LINEAR) | GFC500 | Seen in other instruments with backlight or power transitions? |
| FLC speed-capture pattern (global from subscription, used in button) | GFC500 | Is current-value-capture for button actions seen elsewhere? |
| Sync button: capture current sim value and set AP reference | GFC500 | Seen in other AP instruments? |
| L: LVAR in msfs_variable_subscribe | GFC500 | Do Tier 2 audio panels or instruments use LVARs? |
| Scrollwheel for VS input (scrollwheel_add_ver) | GFC500 | Do any Tier 2 instruments use scrollwheel? |
| Sound-or-silence pattern (silence.wav fallback) | GFC500 | Do other sound-enabled instruments use this? |

## Cluster assignments (category → pattern count)

Based on A3 use-case index sections:

| Category (A3 section) | Patterns | Pattern #s |
|---|:---:|---|
| §1 Reading simulator state | 3 | 2 (multi-var bus), 3 (fs2024 reuse), 14 (parallel XPL+MSFS) |
| §2 Writing to sim | 3 | 1 (triple-dispatch), 18 (dual xpl_command), 19 (BEGIN/END) |
| §3 Pilot input — touchscreen | 1 | 4 (long-press) |
| §4 Pilot input — knobs | 2 | 11 (persist dial angle), 15 (mouse+touch setting pair) |
| §6 Drawing — static | 1 | 8 (img_add style string) |
| §9 Visual state management | 4 | 6 (power-state group), 7 (rotate-for-analog), 10 (day/night opacity), 17 (annunciator visible) |
| §11 Persistence | 1 | 11 (persist dial angle, also §4) |
| §12 User properties | 2 | 5 (device ID), 9 (feature toggle) |
| §13 Sound | 1 | 16 (sound-on-state-change) |
| §17 Instrument metadata | 3 | 12 (has_feature), 13 (platform-conditional), 6 (power-state, also here) |

Note: Pattern 11 spans §4 and §11; Pattern 6 spans §9 and §17. Final catalog will place each in its primary category with cross-references.

A3 categories with NO confirmed patterns from Tier 1 alone:
- §5 Switches/sliders — no switch_add seen (KX165A uses dial_add for on/off, not switch_add)
- §7 Dynamic canvas drawing — canvas used for streaming overlay only (GNS530/430 message display), not instrument rendering
- §8 Running displays — no running_img_add or running_txt_add seen in any Tier 1 sample
- §10 Maps / navigation data — no map_add seen in Tier 1 (GPS display delegated to sim pop-out)
- §14 Timing (standalone) — timers used as supporting mechanism in other patterns; no timer-as-primary pattern
- §15 Data loading — no static_data_load seen
- §16 Value helpers — var_cap and var_round seen but as supporting functions, not patterns

These gaps are expected: Tier 2 samples (especially audio panels, simpler instruments) may fill some; others (§10 maps, §8 running displays) are likely GNC 355 design-phase discoveries.
