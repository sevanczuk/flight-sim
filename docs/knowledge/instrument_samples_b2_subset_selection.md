# B2: Instrument Sample Subset Selection for Pattern Analysis

**Created:** 2026-04-20T09:50:02-04:00
**Source:** Purple Turn 50 — CD selection work (no CC task; CD does this)
**Purpose:** Select the working subset of instrument samples from B1's 45-sample manifest that B3 (pattern analysis) will dissect in detail. The selected set collectively teaches all AMAPI idioms the GNC 355 instrument will need.
**Stream:** B (Instrument Samples), Wave 2
**Parent task:** SAMPLES-RENAME-01 (B1, complete)
**Dependent task:** B3 (pattern analysis — to be authored after this)

## Context

B1 copied all 45 samples with safe filenames to `assets/instrument-samples-named/` and produced a manifest at `docs/knowledge/instrument_samples_index.md`. Each sample is a full AMAPI instrument project with `logic.lua` (the behavior code) and `resources/` (images, sounds).

B3's job will be to read selected samples' `logic.lua` files, extract common patterns, and produce a pattern catalog. B3 can't productively analyze all 45 — too much surface, too much noise. It needs a focused subset.

This document is that selection.

## Selection criteria

A sample is a good candidate for pattern analysis if it demonstrates one or more of:

1. **Touchscreen interaction** — GNC 355 is a touch-driven GPS/COM. We need patterns for tap regions, virtual soft-keys, scrollable lists.
2. **Rotary knob interaction** — GPS units use click-to-select knobs for frequency, waypoint selection, menu navigation. `Dial_add`, `Dial_click_rotate` family.
3. **Multi-page display** — GPS units have pages (NAV, COM, FPL, NRST, DIRECT). Needs state machines or scene management.
4. **Sim variable subscription** — `xpl_dataref_subscribe`, `msfs_variable_subscribe`. The instrument needs to read aircraft state.
5. **Sim variable write / command** — sending frequency changes, waypoint selections back to sim.
6. **Persistent state** — `persist_add`, `persist_put`, `persist_get`. GNC 355 remembers flight plans between flights.
7. **Canvas drawing** — dynamic rendering (compass arcs, CDI needles, map overlays). GPS map display uses this heavily.
8. **Cross-simulator portability** — samples supporting XPL + FS2020 + FS2024 demonstrate the abstraction pattern we'll want for D-01's dual-sim scope.
9. **Hardware input binding** — `Hw_button_add`, `Hw_dial_add`. Optional for a software-only GNC 355, but useful for understanding the full API surface.
10. **Audio interaction** — GPS/COM units play alerts (TAWS warnings, comm audio). `sound_*` family.

Samples that only demonstrate ONE pattern (e.g., a simple altimeter — just subscribes to altitude, renders a needle) are lower priority. Samples that combine several in a clear reference-quality way are higher priority.

## Disqualified samples

These 5 samples are excluded from analysis — they are passive visual overlays with no interactive logic, providing no value for pattern learning:

- `generic_garmin-g1000-nxi-overlay_c380f8f5` (FS2020 only)
- `generic_garmin-g1000-pfd-mfd-overlay_0b852ee1`
- `generic_pms50-gtn650-overlay_76f533bf`
- `generic_tdi-simulations-garmin-gtnxi-650-overlay_b3f330e0`
- `generic_tds-simulations-garmin-gtnxi-750-overlay_f822e2ca`

That leaves 40 candidates for selection.

## Tier 1 — Primary study set (6 samples; deep analysis)

These are the core reference instruments. B3 will dissect `logic.lua` line-by-line, extract every API call, and produce a pattern catalog entry for each idiom. Estimated 1–2 hours of CC work per sample.

| # | Sample | Aircraft / Type | Why it's in Tier 1 |
|---|--------|----------------|--------------------|
| 1 | `generic_garmin-gtn-650_1ae7feb5` | Garmin GTN 650 (touchscreen GPS/NAV/COM) | **Closest structural analog to GNC 355.** Touchscreen GPS, COM integration, multi-page UI, dimensions 1600x675 so it has real layout complexity. Made by Sim Innovations (wiki authors) — idiomatic code expected. XPL+FS2020+FS2024. |
| 2 | `generic_garmin-gns-530_72b0d55c` | Garmin GNS 530 (older knob-driven GPS) | Legacy knob-driven GPS/NAV/COM. Teaches rotary encoder patterns that GNC 355 needs for COM frequency tuning. Dual-sim. Sim Innovations-authored. |
| 3 | `generic_garmin-gns-430_24038c68` | Garmin GNS 430 | Smaller sibling of GNS 530, same interaction pattern. Good for understanding layout scale differences between 430 and 530 — directly informs GNC 355's scale decisions. |
| 4 | `generic_bendixking-kap-140-autopilot-system_da394c59` | Bendix/King KAP 140 Autopilot | Non-GPS but similar complexity class: multi-state UI, mode buttons, LCD segments, sim-variable reactivity. Teaches "multi-state instrument with segmented display" which is structurally close to GNC 355's nav display. |
| 5 | `generic_bendixking-kx-165a-ts0-com1nav1_a6f6d3b9` | Bendix/King KX 165A COM1/NAV1 | Pure radio unit (simpler than GPS but close to GNC 355's COM side). Teaches frequency-tuning patterns, active/standby swap, sim-sync. Version 218 — mature, heavily-refined code. |
| 6 | `generic_garmin-gfc-500-autopilot_c154321a` | Garmin GFC 500 Autopilot | Modern Garmin UI — likely shares visual idioms with GNC 355 (Garmin design language). FS2020/FS2024 only. Teaches what "modern Garmin interaction patterns" look like in an AMAPI instrument. |

**Rationale for 6 and not more:** B3 needs enough samples to see patterns repeat (single-sample "patterns" aren't patterns) but not so many that analysis sprawls. 6 gives us 3 Garmin GPS-family instruments (GTN 650 + GNS 530 + GNS 430) to establish the GPS pattern language, plus 3 adjacent complexity-class instruments (KAP 140, KX 165A, GFC 500) to cross-check patterns.

## Tier 2 — Secondary reference set (8 samples; targeted pattern lookup)

These samples are not deep-dissected, but B3 keeps them in scope as specific-pattern references. When B3 needs to verify a pattern (e.g., "is this the idiomatic way to subscribe to a dataref?"), it compares against Tier 2 samples. Also a backup if Tier 1 turns out to be too narrow.

| # | Sample | Why it's in Tier 2 |
|---|--------|---------------------|
| 7 | `cessna-172_heading_079a54d1` | Simple single-variable subscription + canvas rotation. The "hello world" of sim-reactive instruments. |
| 8 | `cessna-172_altimeter_cf5829f6` | Altitude subscription + 2-needle composite rendering (100ft + 1000ft). Dual-needle pattern. |
| 9 | `cessna-172_vor-nav1ils_94a0e896` | VOR/ILS receiver — needle deflection + glideslope, flag states. Reference for NAV indicator logic. |
| 10 | `cessna-172_adf_04a6aa5d` | ADF bearing pointer — heading-relative bearing calculation. Good for nav-math patterns. |
| 11 | `cessna-172_switch-panel_0fb7ea63` | Multiple toggle switches + sim-state sync. Reference for switch/button patterns. Version 111. |
| 12 | `generic_garmin-340-audio-panel_d30c0bb4` | Audio panel with multiple buttons + sound routing. Reference for audio API patterns. |
| 13 | `generic_garmin-gma-1347d-audio-panel_965144b1` | Larger audio panel, Sim Innovations-authored. Alternative audio pattern source. |
| 14 | `cessna-172_turn-coordinator_487838a2` | Turn coordinator with ball indicator — 2-axis reactive rendering. |

## Tier 3 — Out-of-scope for B3 (26 samples; documented but not analyzed)

These 26 samples are NOT studied during B3. They remain in the manifest and available for ad-hoc reference if B3 discovers a pattern gap, but are not primary inputs.

Rationale: they're either very simple (single needle on single subscription) or duplicate coverage from Tier 1/2:

- Various Cessna 172 primary flight instruments (airspeed, VSI, attitude, annunciators, ident plate, OAT, oil temp, fuel gauge, tach, EGT, alt static, elevator trim, flaps lever, fuel selector, vacuum/ammeter, VOR NAV2) — redundant with Tier 2 examples; they'd teach no new idioms
- Generic callsign label, flap position, ident plate, landing gear handle, tach time — trivial single-purpose instruments
- Cessna 172 KT76C TSO transponder (XPL-only, version 2 — immature)
- Generic Garmin GI 260 (simple round instrument)
- Generic Garmin GTN 750 — same structural pattern as GTN 650 (already in Tier 1); studying both adds no new idioms
- Generic Garmin GTX 327/328/330 transponder — transponder patterns not needed for GNC 355
- Generic Bendix-King KN62A DME receiver (XPL only, niche)
- Generic Bendix/King KN DME display (display-only)

## Aircraft coverage

Tier 1 + Tier 2 = 14 samples total:

| Category | Count |
|---|---|
| Garmin avionics (GPS/autopilot) | 4 (GTN 650, GNS 530, GNS 430, GFC 500) |
| Bendix/King avionics (radio/autopilot) | 2 (KAP 140, KX 165A) |
| Audio panels | 2 (Garmin 340, Garmin GMA 1347D) |
| Cessna 172 primary flight instruments | 6 (heading, altimeter, VOR, ADF, switch panel, turn coord) |

## Sim compatibility coverage

Tier 1 (6 samples):
- Dual-sim (XPL + FS2020 + FS2024): 5 of 6
- FS2020+FS2024 only: 1 (GFC 500)
- XPL-only: 0

Good. Establishes that ALL studied samples demonstrate the XPL→MSFS abstraction pattern we'll need for D-01's dual-sim scope. The single exception (GFC 500) is a modern-Garmin UI that we include specifically for its visual language.

## Author coverage

Heavy Sim Innovations weighting in Tier 1 (5 of 6) — these are authoritative examples with idiomatic AMAPI usage. Tier 2 adds some Jason Tatum (prolific community author) and Russ Barlow samples for breadth.

## Physical dimension coverage

Tier 1 sample dimensions (the GNC 355 will likely be ~700-900 px wide based on typical touchscreen GPS overlays):

- GTN 650: 1600x675 — wide touchscreen
- GNS 530: 1600x1180 — wide knob-driven
- GNS 430: 1600x670 — wide knob-driven  
- KAP 140: 700x182 — horizontal strip (like a GNC 355-proportions unit, actually)
- KX 165A: 700x223 — horizontal strip
- GFC 500: 687x255 — horizontal strip

The KAP 140 / KX 165A / GFC 500 dimensions are actually in the GNC 355's likely proportion range (wide-short aspect ratio), which makes them more relevant for visual layout patterns than the wider GPS units.

## What this unlocks

After B2 selection (this document), Stream B progression:

- **B3:** Pattern analysis — CC task that reads Tier 1 logic.lua files in depth, Tier 2 as reference. Produces pattern catalog at `docs/knowledge/amapi_patterns.md`. Estimated 1-2 hour CC task.
- **B4:** Readiness review — confirm B3 output covers the GNC 355's needs; identify any gaps requiring Tier 3 look-up.

Then Stream B reaches "ready for design phase" alongside Stream A (AMAPI reference), triggering ITM-01's file movement batch and unblocking the GNC 355 Design Spec authoring.

## Open items for B3 prompt (notes for when we draft it)

- B3 should first read THIS document to understand why the subset was chosen.
- B3 output should cross-reference the `docs/reference/amapi/` docs that A2 produces — when a pattern uses `xpl_dataref_subscribe`, the pattern entry should link to `docs/reference/amapi/by_function/Xpl_dataref_subscribe.md`. A2 must complete before B3.
- B3 should be explicit about the dual-sim abstraction pattern since D-01 scope is XPL+MSFS.
- B3 does NOT modify instrument samples or their logic.lua — read-only.
