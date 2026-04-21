---
Created: 2026-04-20T21:42:46-04:00
Source: CD Purple session — Turn 5 — B4 Stream B readiness review
---

# B4 — Stream B Readiness Review

**Stream:** B (Instrument Sample Analysis)
**Plan reference:** `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` §5 (Stream B), §7 (third-wave B4)
**Status:** PASS — Stream B is ready for design phase (C2 GNC 355 Functional Spec authoring)

---

## Purpose

Per the implementation plan, B4 is a follow-up review of the pattern catalog produced by B3 (AMAPI-PATTERNS-01) to (a) validate that Stream B's output is sufficient to inform the GNC 355 Design Spec, (b) surface any gaps that require additional work, and (c) declare readiness or scope a follow-up task. This is a CD-authored review (not a CC task) consistent with the plan's "third wave" scoping.

---

## Inputs reviewed

| Artifact | Status | Notes |
|---|---|---|
| `docs/knowledge/amapi_patterns.md` | Drafted | 24 patterns, ~66 KB; compliance PASS WITH NOTES (Turn 3) |
| `docs/knowledge/amapi_patterns_sample_appendix.md` | Drafted | 6 Tier 1 + 8 Tier 2 per-sample notes; 13 sample-specific techniques |
| `docs/knowledge/instrument_samples_b2_subset_selection.md` | Authoritative | B2 selection rationale; defines Tier 1 / Tier 2 scope |
| `docs/knowledge/amapi_by_use_case.md` | Drafted | 18-section use-case index; complements pattern catalog |
| `docs/knowledge/amapi_function_inventory.md` | Authoritative | 214-function inventory from A2 |
| `docs/reference/amapi/by_function/*.md` | Drafted | 214 per-function reference docs from A2 |
| AMAPI-PATTERNS-01 compliance report | Archived | Verdict PASS WITH NOTES; 2 FAILs discharged as ITM-02, ITM-03 per D-07 |

---

## Coverage assessment

### GPS/touchscreen idioms (GNC 355's primary shape)

The GNC 355 is a touchscreen GPS/COM instrument. The pattern catalog's GPS-family coverage is strong:

- **Triple-dispatch** (Pattern 1) — validated across 5/6 Tier 1 samples including the GTN 650 (closest analog) and both GNS 430/530. Primary dispatch mechanism for every pilot action.
- **Long-press detection** (Pattern 4) — used by GTN 650 HOME and FMS push, GNS 530 CLR (multi-level menu clear), KAP 140 ALT. Directly applicable to GNC 355 CRSR, CLR, MENU buttons.
- **Multi-instance device ID suffix** (Pattern 5) — GTN 650, GNS 430/530 all implement Device ID for pilot/copilot dual-panel. GNC 355 spec will decide whether to support this.
- **Multi-variable subscription bus** (Pattern 2) — 5/6 Tier 1 samples; core pattern for the GNC 355's 15–25 variable display state.
- **Parallel XPL + MSFS subscriptions** (Pattern 14) — GNS 430/530 validate this for volume; applies directly to GNC 355 for any state with different variable names between sims.
- **Feature-detection guard** (Pattern 12) and **video streaming** — GNS 430/530 use `has_feature("VIDEO_STREAM")` for XPL12 pop-out streaming. If the GNC 355 spec decides to use pop-out streaming for the map/chart pages, this pattern is ready. If software-drawn canvas is chosen instead, an alternative approach is needed (see gap §3 below).

### Dual-sim (X-Plane + MSFS) portability

D-01 scopes the GNC 355 to XPL primary + MSFS secondary. Coverage:

- **Triple-dispatch** (Pattern 1) covers XPL + FSX + MSFS; for GNC 355's XPL + MSFS scope, use the "dual-sim variant" documented in Pattern 1's Variants section.
- **FS2024 callback reuse** (Pattern 3) — covered; applies if spec targets both FS2020 and FS2024 via explicit subs rather than the generic `msfs_variable_subscribe`.
- **L: LVAR subscriptions** (Pattern 24) — covered; likely needed for GNC 355 on MSFS (Working Title GNC mod or native Garmin avionics typically expose state via LVARs).
- **B: event dispatch for FS2024** (Pattern 23) — covered; may apply to specific FS2024 avionics actions.
- **FSX adapter normalization** (Pattern 22) — covered but low-priority since GNC 355 doesn't target FSX.

### Input patterns (touchscreen + knob)

- **Button triple-dispatch** (Pattern 1) + **long-press** (Pattern 4) — covered.
- **Rotary knob (virtual)** — `dial_add` + `mouse_setting` + `touch_setting` pair (Pattern 15) — covered.
- **Rotary knob (hardware / Knobster)** — `hw_dial_add` (Pattern 21) + detent-type user prop (Pattern 20) — covered.
- **Persistent dial angle** (Pattern 11) — covered.

### Visual state management

- **Power-state group visibility** (Pattern 6) — covered.
- **Rotate-for-analog** (Pattern 7) — covered (CDI deviation needle if included).
- **Image initial style string** (Pattern 8) — covered.
- **Day/night opacity via si backlight** (Pattern 10) — covered.
- **Annunciator visible** (Pattern 17) — covered (GPS/VLOC/TO/FROM flags).

### Persistence and configuration

- **`persist_add` family** (Pattern 11 via knob angle; Pattern 13 via first-launch message flag) — covered for simple scalar state.
- **User-prop boolean feature toggle** (Pattern 9) — covered.
- **Integer user prop** (Pattern 5) — covered (Device ID).
- **Enum user prop** (Pattern 20) — covered (detent type).

---

## Gaps identified

Three gaps surface when matching the pattern catalog against likely GNC 355 design needs. None blocks C2 authoring; all can be addressed during spec drafting or deferred.

### Gap 1: Complex canvas-drawn instrument faces

The pattern catalog's §"What this catalog does NOT cover" explicitly notes: "Canvas was observed only for platform-conditional messages and streaming overlays in the analyzed samples; complex canvas-drawn instrument faces (gauges drawn in code) were not found and are not documented here."

**Impact:** If the GNC 355 spec decides to draw the moving map, chart overlays, or CDI deviation indicator via canvas (rather than via rotation of pre-rendered PNGs or video streaming), there is no pattern precedent in the reviewed corpus.

**Mitigation options (for C2 to choose):**
1. **Prefer video-streaming (XPL pop-out) + PNG-rotation** — well-supported by existing patterns (12, 7); requires XPL12+ and MSFS pop-out equivalent.
2. **Prefer pre-rendered PNG sprites + rotate()** — well-supported by Pattern 7 (rotate-for-analog); limited to needle-style displays.
3. **Use canvas with custom drawing code** — would require invention of new patterns; out of scope for Stream B but acceptable as a spec-authored design decision.

**Recommendation:** Defer the decision to C2. The spec author (CD on behalf of the GNC 355 design) will encounter this choice naturally when specifying the map/chart page. No pre-work needed.

### Gap 2: Touchscreen-specific interaction idioms beyond button_add

The Tier 1 set includes only one true touchscreen instrument (GTN 650). Tier 2 sample types are traditional aircraft instruments (altimeter, VOR, ADF, switch panel, audio panels, turn coordinator) — not touchscreen navigators.

**What's covered well from GTN 650:** triple-dispatch, long-press, multi-instance device ID, feature-toggle user props.

**What may be under-documented:** scrollable list navigation (waypoint search, procedure selection), text entry via on-screen keyboard, multi-touch gestures (pan/zoom on map), touch-drag (knob rotation via drag arc). None of these appear as distinct patterns because only GTN 650 exercises them, and the B2 selection was optimized for breadth across instrument families rather than depth on one instrument class.

**Impact:** When C2 specifies the GNC 355's FPL page (scrollable flight plan), procedure selection, direct-to waypoint entry, and map page pan/zoom, the spec author may need to consult the GTN 650 source directly or invent UI patterns without cross-sample validation.

**Mitigation options:**
1. **Read GTN 650 source during C2 spec drafting.** The sample is well-documented (`raw_notes_generic_garmin-gtn-650_1ae7feb5.md` in `_crp_work/amapi_patterns_01/`). Spec author can extract needed idioms opportunistically.
2. **B5 follow-up task** (new, not in plan) — deep-dive the GTN 650 for touchscreen-specific patterns; produce a supplemental `docs/knowledge/gtn650_touchscreen_deep_dive.md`. Estimated 1–2 hours CC. Only needed if C2 authoring stalls without it.
3. **Pull additional touchscreen samples from the Tier 3 (unselected 26)** into analysis if the manifest surfaces any. Check `docs/knowledge/instrument_samples_b2_subset_selection.md` Tier 3 rationale — likely that no strong touchscreen analog exists beyond GTN 650 in the 45-sample corpus.

**Recommendation:** Proceed to C2 without B5. If C2 authoring hits a wall on specific touchscreen mechanics, spin up B5 then. Writing a pre-emptive deep-dive would risk extracting patterns that C2 doesn't actually need.

### Gap 3: Pattern catalog's acknowledged A3 use-case section gaps

The B3 completion report documented 7 A3 use-case sections with no confirmed patterns in the corpus: §5 Switches/sliders, §7 Dynamic canvas drawing, §8 Running displays, §10 Maps/navigation data, §14 Timing (standalone), §15 Data loading, §16 Value helpers.

**Assessment of each vs. GNC 355 relevance:**

| A3 section | GNC 355 relevance | Disposition |
|---|---|---|
| §5 Switches/sliders | Low — GNC 355 has buttons, not sliders | Ignore |
| §7 Dynamic canvas drawing | Medium — may be needed for map (see Gap 1) | Spec-driven decision in C2 |
| §8 Running displays | **HIGH — frequency readouts, waypoint IDs, text scrolling** | See below |
| §10 Maps/navigation data | High — moving map is a core GNC 355 page | See below |
| §14 Timing (standalone) | Low — timers appear as support for Patterns 4, 16 | No gap in practice |
| §15 Data loading | Low — static config only; AMAPI `static_data_load` is for panel-level data | Ignore for GNC 355 |
| §16 Value helpers | N/A — `var_cap`, `var_round` appear inside patterns; not patterns themselves | No gap in practice |

The two real gaps are §8 Running displays and §10 Maps/navigation data. These are design-phase discoveries — the pattern catalog correctly notes they weren't found in the corpus because the corpus didn't include instruments that exercise these APIs (no sample had `running_img_add`/`running_txt_add`, and no sample had `map_add`).

**Impact on C2:** When specifying the GNC 355's frequency text (COM/NAV readouts that may scroll during edit), waypoint ID display, and the moving map page, C2 will need to consult the AMAPI reference docs directly (Running_img_add, Running_txt_add, Map_add in `docs/reference/amapi/by_function/`) rather than lean on pattern precedent.

**Mitigation:** C2 spec author reads the relevant A2 reference docs when authoring those sections. The A3 use-case index already names the relevant functions. No additional prep work needed — reference docs exist; just no patterns abstracted from samples.

**Recommendation:** Proceed. Document in C2 spec that these areas were designed from AMAPI reference rather than instrument-sample pattern precedent.

---

## Readiness decision

**Stream B is ready for design phase.** The pattern catalog and sample appendix together provide:

- Strong coverage of the core dispatch, subscription, visual-state-management, persistence, user-configuration, and input patterns the GNC 355 will need
- Explicit GNC 355 relevance annotations in every pattern entry (C2 spec author can grep for "GNC 355 relevance" to find pattern applicability)
- Clear documentation of what the corpus did NOT cover (running displays, maps, complex canvas) so the spec author knows where to consult reference docs directly
- Three gaps identified above, all with deferral rationale; none blocks C2 authoring

**Two outstanding followups (non-blocking):**
- ITM-02 — function usage matrix missing Tier 2 columns (scratch artifact; discharged per D-07)
- ITM-03 — Patterns 20/21 plain-text `hw_dial_add` should be markdown links (file exists)

Neither ITM affects pattern catalog usefulness for C2 authoring.

---

## What this unblocks

With Stream A ready (A2 + A3) and Stream B now declared ready (B3 + this B4 review), the critical path is:

1. **ITM-01 — File-movement batch CC task** (~10 completed task file sets moved to `docs/tasks/completed/`). Fires next.
2. **C2 — GNC 355 Functional Spec V1 draft.** Large CC task; likely piecewise + manifest given expected >1500 lines. The pattern catalog (B3 output) and use-case index (A3 output) are the two primary knowledge-base inputs the spec will cite.

---

## Related

- `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` — plan defining B4 scope
- `docs/tasks/completed/amapi_patterns_prompt.md` — B3 task prompt
- `docs/tasks/completed/amapi_patterns_completion.md` — B3 completion report
- `docs/tasks/completed/amapi_patterns_compliance.md` — B3 compliance verdict
- `docs/decisions/D-01-project-scope.md` — GNC 355 scope (XPL primary + MSFS secondary)
- `docs/decisions/D-02-gnc355-prep-scoping.md` — three-stream scoping that defined B
- `docs/decisions/D-07-compliance-triage-scratch-vs-published.md` — discharge rationale for ITM-02
- `docs/todos/issue_index.md` — ITM-02, ITM-03 tracking entries
