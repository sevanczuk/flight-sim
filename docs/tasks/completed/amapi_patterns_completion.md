---
Created: 2026-04-20T00:00:00Z
Source: docs/tasks/amapi_patterns_prompt.md
---

# Task Completion Report: AMAPI-PATTERNS-01

**Task ID:** AMAPI-PATTERNS-01 (Stream B3)
**Completed:** 2026-04-20

---

## Phase summary

| Phase | Status | Key artifacts |
|---|---|---|
| A — Per-sample reading (Tier 1) | Complete | 6 raw_notes_*.md files, _phase_A_complete.md |
| B — Cross-sample pattern extraction | Complete | function_usage_matrix.md, _phase_B_complete.md |
| C — Tier 2 reference pass | Complete | _phase_C_complete.md |
| D — Pattern catalog authoring | Complete | docs/knowledge/amapi_patterns.md, _phase_D_complete.md |
| E — Sample appendix | Complete | docs/knowledge/amapi_patterns_sample_appendix.md, _phase_E_complete.md |

---

## Pattern count: 24 ✓

Within the 15–30 target range.

---

## Pattern-by-category breakdown (aligned to A3 use-case sections)

| Category | A3 Section | Patterns | #s |
|---|---|:---:|---|
| Writing to the simulator | §2 | 5 | 1, 18, 19, 23, 24 |
| Reading simulator state | §1 | 4 | 2, 3, 14, 22 |
| Touchscreen / button input | §3 | 1 | 4 |
| Knob / hardware dial input | §4 | 4 | 11, 15, 20, 21 |
| Visual state management | §9 | 5 | 6, 7, 8, 10, 17 |
| Sound | §13 | 1 | 16 |
| User properties / configuration | §12 | 2 | 5, 9 |
| Persistence | §11 | 1 | 11 (cross-ref from §4) |
| Instrument metadata / platform | §17 | 2 | 12, 13 |

---

## Cross-reference count

- 34 distinct AMAPI functions referenced across the pattern catalog
- ~85 total cross-reference links to `docs/reference/amapi/by_function/` in pattern entries
- Pattern cross-reference table provides reverse lookup (function → patterns)

---

## Samples analyzed

- **Tier 1 (deep dissect):** 6 samples — GTN 650, GNS 530, GNS 430, KAP 140, KX 165A, GFC 500
- **Tier 2 (survey):** 8 samples — heading, altimeter, VOR, ADF, switch panel, Garmin 340, GMA 1347D, turn coordinator

---

## Notable pattern-category gaps

A3 sections with no confirmed patterns in this corpus:

| A3 Section | Reason |
|---|---|
| §5 Switches/sliders | `switch_add` seen only in Tier 2 switch panel (single sample) |
| §7 Dynamic canvas drawing | Canvas used for overlays/messages only; no instrument-face drawing |
| §8 Running displays | No `running_img_add` or `running_txt_add` in any Tier 1 or Tier 2 sample |
| §10 Maps / navigation data | GPS display delegated to sim pop-out or streaming; no `map_add` |
| §14 Timing (standalone) | Timers are supporting mechanism in Patterns 4, 16; no timer-as-primary pattern |
| §15 Data loading | No `static_data_load` in any sample |
| §16 Value helpers | `var_cap`, `var_round` are supporting helpers; not standalone patterns |

These gaps are expected. §8 and §10 are likely GNC 355 design-phase discoveries (running displays for frequency readouts, navigation map).

---

## Sample-specific techniques count: 13

Within expected range (5–15). All cataloged in `docs/knowledge/amapi_patterns_sample_appendix.md`.

---

## Spot-check results

5 cross-reference link targets verified as existing:

| Target file | Status |
|---|---|
| `docs/reference/amapi/by_function/Xpl_dataref_subscribe.md` | ✓ exists |
| `docs/reference/amapi/by_function/Timer_start.md` | ✓ exists |
| `docs/reference/amapi/by_function/Si_variable_subscribe.md` | ✓ exists |
| `docs/reference/amapi/by_function/Persist_add.md` | ✓ exists |
| `docs/reference/amapi/by_function/Group_add.md` | ✓ exists |

2 exemplar sample directories verified as existing:

| Sample directory | Status |
|---|---|
| `assets/instrument-samples-named/generic_garmin-gtn-650_1ae7feb5` | ✓ exists (info.xml, logic.lua, resources) |
| `assets/instrument-samples-named/cessna-172_altimeter_cf5829f6` | ✓ exists (info.xml, logic.lua) |

---

## Deviations from prompt

None. All phases executed as specified. Pattern count (24) is within the 15–30 target. The only notable finding is that `hw_dial_add` does not appear in the A2 reference docs as a standalone function — it is used in Tier 2 samples but lacks a `docs/reference/amapi/by_function/Hw_dial_add.md` file. Pattern 21 cross-references it by name without a working link. This gap should be flagged to the A2 reference documentation maintainer.
