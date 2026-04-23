# CC Task Prompt: C2.2-D — GNX 375 Functional Spec V1 Fragment D (§§5–7)

**Created:** 2026-04-23T06:23:57-04:00
**Source:** CD Purple session — Turn 15 (2026-04-23) — fourth of 7 piecewise fragments per D-18
**Task ID:** GNX375-SPEC-C22-D (Stream C2, sub-task 2D for the 375 primary deliverable)
**Parent reference:** `docs/decisions/D-18-c22-format-decision-piecewise-manifest.md` §"Task partition"
**Authorizing decisions:** D-11 (outline-first), D-12 (pivot to 375), D-14 (procedural fidelity — §7 augmentations are D-14 items), D-15 (no internal VDI — critical for §7 approach content and §7.G CDI deviation display), D-16 (XPDR + ADS-B scope — critical for §7.9 XPDR-approach interactions), D-18 (piecewise format + 7-task partition), D-19 (fragment line-count expansion ratio — target ~750), D-20 (LLM-calibrated duration estimates), D-21 (sequential drafting — this prompt drafted after C2.2-C archived)
**Predecessor tasks:** C2.2-A archived (`docs/tasks/completed/c22_a_*.md`), C2.2-B archived (`docs/tasks/completed/c22_b_*.md`), C2.2-C archived (`docs/tasks/completed/c22_c_*.md`). All three are authoritative backward-reference sources.
**Depends on:** C2.2-A archived ✅, C2.2-B archived ✅, C2.2-C archived ✅, manifest at `docs/specs/GNX375_Functional_Spec_V1.md` (Fragment C status ✅ Archived)
**Priority:** Critical-path — fourth of 7 fragments; the first operational-workflow fragment (Fragments A/B/C were foundation + display pages only). Largest upcoming fragment at ~750 lines target. Introduces §7.9 as a new sub-section required to resolve Fragment C's forward-refs (per ITM-09). Carries the densest procedural-fidelity content in the spec.
**Estimated scope:** Large — authors ~750 lines across 3 sections: §5 Flight Plan Editing (~200), §6 Direct-to Operation (~80), §7 Procedures (~450 including all §7.1–7.8 + §7.A–§7.M lettered augmentations + §7.9 new). Plus fragment header, Coupling Summary (~60 lines per D-19 miscalibration correction).
**Task type:** docs-only (no code, no tests)
**CRP applicability:** **BORDERLINE.** Fragment D is the largest fragment in the series. At 750-line target it's right at the 700-line soft ceiling per D-19. If final content trends toward 850+ lines, CRP phase-completion markers are worth using — however, single-file docs output typically doesn't trigger compaction since no large intermediate artifacts accumulate. Default: no CRP; CC may opt-in if mid-authoring suggests compaction risk.

---

## Source of Truth (READ ALL OF THESE BEFORE AUTHORING ANY SPEC BODY CONTENT)

### Tier 1 — Authoritative content source

1. **`docs/specs/GNX375_Functional_Spec_V1_outline.md`** — **THE PRIMARY BLUEPRINT.** For C2.2-D, authoritative content comes from:
   - **§5 Flight Plan Editing** (~200 lines estimated) — sub-structure 5.1–5.9: Flight Plan Catalog, Create FPL, Waypoint Options, Graphical FPL Editing, OBS Mode, Parallel Track, Dead Reckoning, Airway Handling, FPL Data Fields
   - **§6 Direct-to Operation** (~80 lines) — sub-structure 6.1–6.6: Basics, Search Tabs, Activation, Direct-to New Waypoint, Removal, User Holds
   - **§7 Procedures** (~350 outline lines, expand to ~450 per D-19) — sub-structure 7.1–7.8 (numeric): Flight Procedure Basics, GPS Flight Phase Annunciations, Departures, Arrivals, Approaches, Missed Approach, Approach Hold, Autopilot Outputs. Plus §7.A–§7.M lettered augmentations per D-14 (procedural-fidelity items 11–25). Plus **new §7.9 authored here per ITM-09** (XPDR + ADS-B approach interactions).

   **Do not deviate from the outline's section numbering, sub-structure, or page references** (with the single exception of adding §7.9 per the hard constraint below). The outline is the contract; this task expands it into prose.

2. **`docs/decisions/D-18-c22-format-decision-piecewise-manifest.md`** — format contract. Re-read §"Fragment file conventions" and §"Coupling summary convention" before authoring.

3. **`docs/decisions/D-19-fragment-prompt-line-count-expansion-ratio.md`** — line-count authority. Target: **~750 lines** for Fragment D (per-task table in D-19). **Note:** this is the largest fragment target; monitor during authoring.

4. **`docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`** — **Fragment A authoritative backward-reference source.** Appendix B glossary terms (FAF, MAP, HAL, LPV, LNAV, LP, SBAS, WAAS, TSAA, FIS-B, UAT, 1090 ES, TSO-C112e, TSO-C166b, WOW, IDENT, Flight ID, GPSS, etc.), §1 framing (no internal VDI, GNX 375 baseline, sibling-unit distinctions), §2 physical control terminology (knob push = Direct-to on GNX 375), §3 SD card specs — all defined here. Do not redefine.

5. **`docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`** — **Fragment B authoritative backward-reference source.** Specifically relevant:
   - §4.3 Active FPL page (scrollable list structure; GPS NAV Status indicator key layout) — §5 FPL editing workflows act on this display
   - §4.4 Direct-to page (search tabs, waypoint activation UI) — §6 operational workflows act on this display
   - §4.2 Map page — §5.4 Graphical FPL Editing acts on the Map page
   - §4 parent scope paragraph — already authored; DO NOT re-author §4 anything

6. **`docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md`** — **Fragment C authoritative backward-reference source.** Specifically relevant:
   - §4.7 Procedures display pages (page structure, annunciator bar, approach selection UI) — §7 operational workflows act on these displays
   - §4.7 Visual Approach external CDI/VDI framing — §7.5 RNAV + §7.8 Autopilot Outputs must stay consistent (no internal VDI)
   - §4.7 Open questions (XPDR altitude reporting, TSAA behavior, Autopilot dataref) — **§7.9 authored here resolves the first two** via operational-detail content; the Autopilot dataref question carries forward to §15
   - §4.9 Traffic Awareness + TSAA framing — §7.9 cross-refs to §4.9 for traffic display detail
   - §4.10 CDI Scale setup + CDI On Screen — §7.D CDI scale auto-switching workflow + §7.G CDI deviation display cross-ref §4.10

7. **`docs/specs/GNX375_Functional_Spec_V1.md`** — the fragment manifest. Confirm Fragment D manifest entry (order 4, covers §§5–7, target 750) matches your output path.

### Tier 2 — PDF source material (authoritative for content details)

8. **`assets/gnc355_pdf_extracted/text_by_page.json`** — primary PDF source. For C2.2-D, the relevant pages:
   - §5 FPL Editing: pp. 129–132 (Graphical FPL editing), pp. 144–157 (FPL page content), pp. 150–151 (Flight Plan Catalog)
   - §6 Direct-to: pp. 159–164 (Direct-to basics, search tabs, activation, holds)
   - §7 Procedures: pp. 75–82 (XPDR state for §7.9), pp. 86–89 (CDI scale settings for §7.D + §7.G), pp. 157 (fly-over waypoint symbol for §7.J), pp. 181–207 (all procedure content), pp. 245–256 (traffic for §7.9 TSAA interaction)

   Read the relevant pages when authoring. The outline already cites specific page numbers — honor those citations in the spec body.

9. **`assets/gnc355_pdf_extracted/extraction_report.md`** — extraction quality notes. Fragment A's Appendix C already documents sparse pages. The §§5–7 page range is clean — no sparse pages to note.

### Tier 3 — Cross-reference context

10. **`docs/knowledge/355_to_375_outline_harvest_map.md`** — harvest categorization for §§5–7:
    - §5: unit-agnostic ([FULL])
    - §6: unit-agnostic ([FULL])
    - §7: [FULL structure; D-12 Q3c + D-14 procedural-fidelity augmentations added]

11. **`docs/knowledge/amapi_by_use_case.md`** — A3 use-case index. Sections cited in the outline for C2.2-D: §1 (dataref subscribe — GPS flight phase, CDI source, deviation), §2 (command dispatch — approach activation, missed approach, direct-to, OBS toggle), §10 (Nav_get / Nav_calc_distance / Nav_calc_bearing for direct-to waypoint queries), §11 (Persist_add — FPL catalog, user waypoints).

12. **`docs/knowledge/amapi_patterns.md`** — B3 pattern catalog. Outline cites Pattern 2 (multi-variable bus for flight phase + deviation data), Pattern 11 (persist dial angle / state across sessions), Pattern 17 (annunciator visible for flight phase annunciations).

13. **`docs/knowledge/stream_b_readiness_review.md`** — B4 readiness review. **B4 Gap 2 is relevant** for §5 FPL editing (scrollable list manipulation UI) — preserved as design-phase decision; not resolved here.

14. **`docs/decisions/D-01-project-scope.md`** — XPL primary + MSFS secondary
15. **`docs/decisions/D-12-pivot-gnc355-to-gnx375-primary-instrument.md`** — pivot rationale
16. **`docs/decisions/D-14-procedural-fidelity-additions-harvest-items-11-25.md`** — **critical for this task.** Items 11–25 map to §7.A–§7.M lettered augmentations.
17. **`docs/decisions/D-15-gnx375-display-architecture-internal-vs-external-turn-20-research.md`** — **critical for this task.** No internal VDI on GNX 375. §7.5 RNAV approaches, §7.8 Autopilot Outputs, §7.C ILS approach behavior, §7.G CDI deviation display all depend on this. Fragment C's Visual Approach framing must be consistent here.
18. **`docs/decisions/D-16-gnx375-xpdr-adsb-scope-corrections-turn-21-research.md`** — **critical for this task.** §7.9 XPDR + ADS-B approach interactions rely on D-16's "three modes only" framing (Standby / On / Altitude Reporting — no Ground, no Test, no Anonymous) and the WOW-handled-automatically framing (p. 78).
19. **`docs/decisions/D-21-multi-fragment-sequential-drafting-discipline.md`** — drafting discipline (informational; governs why this prompt is drafted now, not earlier).

20. **`docs/todos/issue_index.md`** — **read ITM-08 and ITM-09 in full before authoring.** Both flag corrective actions required during this task.

21. **`docs/tasks/completed/c22_c_prompt.md`** — **most recent structural template.** Use the same section structure, YAML front-matter format, heading-level conventions, Coupling Summary block format, and self-review checklist pattern. Do **not** copy the content — scope and hard constraints are different. **Note:** C2.2-C's section-budget table had the Coupling Summary budget miscalibrated at ~15 lines; this prompt corrects to ~60.

22. **`CLAUDE.md`** (project conventions, commit format, ntfy requirement)
23. **`claude-conventions.md`** §Git Commit Trailers (D-04)

**Audit level:** standard — CD will check completions and run a compliance verification modeled on the C2.2-C approach (~25-item check across F / S / X / C / N categories). Compliance bar consistent with C2.2-A, C2.2-B, C2.2-C.

---

## Pre-flight Verification

**Execute these checks before authoring any fragment content. If any fails, STOP and write `docs/tasks/c22_d_prompt_deviation.md`.**

1. Verify Tier 1 source files exist:
   ```bash
   ls docs/specs/GNX375_Functional_Spec_V1_outline.md
   ls docs/decisions/D-18-c22-format-decision-piecewise-manifest.md
   ls docs/decisions/D-19-fragment-prompt-line-count-expansion-ratio.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md
   ls docs/specs/GNX375_Functional_Spec_V1.md
   ls docs/todos/issue_index.md
   ```

2. Verify Tier 2 source file exists:
   ```bash
   ls assets/gnc355_pdf_extracted/text_by_page.json
   ```

3. Verify outline integrity (1,477 lines expected):
   ```bash
   wc -l docs/specs/GNX375_Functional_Spec_V1_outline.md
   ```

4. Verify Fragment A integrity (545 lines expected):
   ```bash
   wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
   ```

5. Verify Fragment B integrity (798 or 799 lines expected; trailing-newline off-by-one is acceptable):
   ```bash
   wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md
   ```

6. Verify Fragment C integrity (725 lines expected):
   ```bash
   wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md
   ```

7. Verify `text_by_page.json` structural integrity on key pages (saved `.py` script per D-08):
   Write a short Python script that reads the JSON and prints char counts for key pages: 78 (XPDR modes — for §7.9), 86–89 (CDI scale/on screen — for §7.D + §7.G), 129, 132 (Graphical FPL editing), 144, 149, 150–152, 155, 157, 159–164 (Direct-to), 181–185, 190–194, 196–207 (Procedures). All should have non-trivial character counts.

8. Verify no conflicting fragment output exists:
   ```bash
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md 2>/dev/null
   ```
   Expect failure. If the file exists, STOP and note in deviation report.

---

## Phase 0: Source-of-Truth Audit

Before authoring any spec body content:

1. Read all Tier 1 documents in full (outline §§5–7, D-14, D-15, D-16, D-18, D-19, Fragment A, Fragment B, Fragment C).
2. Read Fragments A, B, **and C in full** — not just the sub-sections directly cited. Fragment C is the newest and establishes forward-ref contracts (to §7.9, §7.D, §10, §12.4, §15.6) that Fragment D must honor.
3. **Read ITM-08 and ITM-09 in `docs/todos/issue_index.md` in full.** These flag required corrective actions for this fragment (see framing commitments #12 and #13 below).
4. Read PDF pages listed in outline sub-section `[pp. N]` citations. Particular attention to:
   - p. 78 (XPDR modes — required for §7.9 XPDR-approach framing)
   - pp. 86–89 (CDI scale settings — required for §7.D CDI auto-switching and §7.G on-screen CDI framing)
   - pp. 129–132 (Graphical flight plan editing)
   - pp. 144–157 (FPL page detail — §§5.1, 5.3, 5.5–5.9)
   - p. 157 (Fly-over waypoint symbol — for §7.J)
   - pp. 159–164 (Direct-to)
   - pp. 181–183 (procedure basics + GPSS + TO/FROM)
   - pp. 184–185 (GPS Flight Phase Annunciations detail)
   - pp. 190–195 (approach loading + missed approach + approach hold)
   - pp. 199–206 (RNAV approaches detail for §7.5 sub-types)
   - p. 200 (approach arming/active transitions — §7.E)
   - pp. 200–203 (approach mode transitions — §7.F)
   - p. 207 (Autopilot outputs — §7.8)
   - pp. 245–256 (Traffic + TSAA — for §7.9 TSAA interaction)
5. Read `docs/knowledge/355_to_375_outline_harvest_map.md` §§ covering §§5–7.
6. Read `docs/decisions/D-14` sections covering items 11–25 → maps to §7.A–§7.M.

**Definition — Actionable requirement:** A statement in the outline or an authorizing decision that, if not reflected in the fragment, would make the fragment incomplete relative to what C2.2-E through C2.2-G depend on. Includes: operational-workflow contracts that later fragments reference, ITM-09's §7.9 structural requirement, ITM-08's Coupling Summary grep-verify, framing decisions (no internal VDI, TSAA = GNX 375 only aural interactions during approach, three XPDR modes only), open-question preservation, and D-14 procedural-fidelity items 11–25 → §7.A–§7.M.

7. Extract actionable requirements. Particular attention to:

   **§5 Flight Plan Editing:**
   - §5.1 Flight Plan Catalog: view list, Route Options menu (Activate, Invert & Activate, Copy to Active, Delete, Preview); delete-active note
   - §5.2 Create FPL: three methods (from active route, from scratch, wireless import); note about unverified modified procedures
   - §5.3 Waypoint Options: Insert Before / Insert After / Remove; other options (Direct-to, Waypoint Info, Procedure from FPL)
   - §5.4 Graphical FPL Editing: tap-drag on Map; add-waypoint / remove / new legs; parallel track offset limitation
   - §5.5 OBS Mode: manual sequencing toggle; external OBS selector requirement
   - §5.6 Parallel Track: offset distance + direction; external CDI/HSI driven from parallel track; activate/deactivate
   - §5.7 Dead Reckoning: activation on GPS signal loss; last-known position + heading/speed; warning
   - §5.8 Airway Handling: airways display as individual legs; Collapse All Airways
   - §5.9 FPL Data Fields: up to 3 columns per leg; Restore Defaults

   **§6 Direct-to Operation:**
   - §6.1 Basics: access via Direct-to key OR inner knob push (GNX 375 pattern)
   - §6.2 Search Tabs: Waypoint, Flight Plan, Nearest
   - §6.3 Activation: point-to-point; guidance persistence (until waypoint reached / course removed / FPL leg resumed)
   - §6.4 Direct-to New Waypoint: step-by-step; off-route vs. in-route course behavior
   - §6.5 Removing: via Menu > Remove or activating an FPL leg
   - §6.6 User Holds: holding pattern at direct-to waypoint; direction/course/leg-time/distance; suspend until expire/remove

   **§7 Procedures — numeric sub-sections:**
   - §7.1 Flight Procedure Basics: loading rules, advisory climb altitudes caveat, roll steering (GPSS) availability, TO/FROM leg CDI behavior
   - §7.2 GPS Flight Phase Annunciations: OCEANS / ENRT / TERM / DPRT / LNAV / LNAV+V / LNAV/VNAV / LP / LP+V / LPV; color semantics (green normal, yellow caution); integrity-degraded / approach-downgrade behaviors
   - §7.3 Departures (SIDs): one per plan; Options menu (Select Departure / Remove Departure); waypoints/transitions inserted at beginning
   - §7.4 Arrivals (STARs): one per plan; Options menu (Select Arrival / Remove Arrival)
   - §7.5 Approaches: one per plan (replaces on reload); SBAS Channel ID key method [p. 191]; procedure turns [p. 192]; non-required holding patterns [p. 195]; ILS monitoring-only [p. 198]; RNAV sub-types (LNAV, LNAV/VNAV, LNAV+V, LPV, LP, LP+V) [pp. 199–204]; downgrade "GPS approach downgraded. Use LNAV minima." [p. 201]; Visual Approaches [pp. 205–206] external CDI/VDI only; DME Arc [p. 196]; RF Legs [p. 197]; Vectors to Final [p. 197]; ARINC 424 leg type handling (OPEN QUESTION 2 preserved)
   - §7.6 Missed Approach: before/after MAP states; pop-up prompt at MAP crossing
   - §7.7 Approach Hold: Activate Hold / Insert After; hold direction / inbound course / leg time or distance; non-required holding pop-up on RNP init
   - §7.8 Autopilot Outputs: GPSS termination on autopilot approach mode selection; resumption on missed approach; heading bug caveat; LPV glidepath capture (KAP 140, KFC 225); "Enable APR Output" advisory; autopilot coupling during approach (XPL dataref names — OPEN QUESTION preserved)

   **§7 Procedures — lettered augmentations (§7.A–§7.M per D-14 items 11–25):**
   - §7.A Glidepath vs. glideslope nomenclature (Garmin distinction; +V suffix = advisory)
   - §7.B Advisory vs. primary vertical distinction (LPV primary; +V advisory; LNAV/VNAV baro-VNAV advisory)
   - §7.C ILS approach display behavior (GPS monitoring only; "ILS and LOC approaches are not approved for GPS" pop-up; annunciator stays TERM; no VDI on 375; external CDI/HSI follows NAV receiver; 375 not connected to NAV receiver)
   - §7.D CDI scale auto-switching by flight phase (Auto: 2.0 → 1.0 → angular; HAL table 0.30 / 1.00 / 2.00 nm; output to external CDI/HSI + on-screen CDI + annunciator bar; manual settings cap upper end)
   - §7.E Approach arming vs. active states (Armed: approach loaded, TERM scale, GPS lateral only; Active: FAF crossed, approach scale, vertical engaged; 60-second integrity check before FAF)
   - §7.F Approach mode transitions (LPV → LNAV downgrade; LP → LNAV+V downgrade; LNAV/VNAV → LNAV on baro-VNAV loss; annunciator change + message queue + external CDI change per transition)
   - §7.G CDI deviation display — on-screen vs. external (CDI On Screen toggle GNX 375 only lateral only per p. 89 and D-15; primary external CDI/HSI driven by 375 lateral output; no on-375 VDI per D-15; output contract cross-ref §15)
   - §7.H TO/FROM flag rendering (annunciator bar authoritative; external CDI TO/FROM driven by 375; composite CDI caveat p. 183 shows TO only; both sides require spec coverage)
   - §7.I Turn anticipation / "Time to Turn" advisory (10-second countdown; LPV and LP walkthroughs pp. 200, 202; related "Arriving at Waypoint" and "Missed Approach Waypoint Reached" pop-ups)
   - §7.J Fly-by vs. fly-over waypoint turn behavior (Fly-over Waypoint Symbol p. 157 with v3.20+; fly-by anticipates + cuts corner; fly-over overflies then turns; turn-geometry detail is limited-source — OPEN QUESTION 3 preserved)
   - §7.K Active leg transition visual feedback (magenta active-leg indicator on Map + FPL; CDI scale behavior during transition — spec needs UX detail)
   - §7.L Altitude constraints on FPL legs (OPEN QUESTION 1 preserved; VCALC is pilot-input planning — not automatic from procedure data; behavior unknown from available docs; research needed during design phase)
   - §7.M ARINC 424 leg type handling (OPEN QUESTION 2 preserved; TF / CF / DF / RF mentioned in examples; full set not enumerated; list confirmed types; flag enumeration as research-needed)

   **§7.9 XPDR + ADS-B approach interactions (NEW — per ITM-09):**
   - XPDR ALT mode during approach: Altitude Reporting typically active; air/ground state handled automatically per p. 78 — no pilot mode change required on approach flight-phase transitions; no separate Ground mode on the GNX 375 per D-16
   - ADS-B Out transmission during approach: 1090 ES Extended Squitter active when in ALT mode; transmits position + altitude during approach phases
   - TSAA traffic display during approach: TSAA application runs when ADS-B In data available; traffic alerts continue during approach flight phases; TSAA aural alerts per OPEN QUESTION 6 (delivery mechanism design-phase decision); cross-ref §12.4 (Fragment F) + §4.9 (Fragment C)
   - Flight phase annunciation + XPDR state correlation: annunciator bar flight phase (LPV, LNAV, etc.) concurrent with XPDR mode indicator; both appear simultaneously on display
   - Forward-refs: §11 Transponder + ADS-B (Fragment F) for XPDR control detail; §4.9 (Fragment C) for traffic display detail; §11.4 (Fragment F) for XPDR modes; §11.11 (Fragment F) for ADS-B In receiver; §12.4 (Fragment F) for aural alert hierarchy

8. **Open-question preservation checklist:**
   - §5: Flight plan storage — serializing full flight plan (persist API is scalar; JSON encoding strategy) — PRESERVE in §5 AMAPI notes or open questions
   - §5: Wireless import (Bluetooth / Garmin Pilot pairing) — may be out of scope for v1 — PRESERVE
   - §6: no open questions flagged in outline
   - §7.5: ARINC 424 leg type handling (OPEN QUESTION 2) — PRESERVE in §7.5 or §7.M
   - §7.8: Autopilot integration (XPL dataref names for GPSS/APR) — PRESERVE
   - §7 (overall): XPL dataref names for GPS flight phase → §15 research — PRESERVE
   - §7 (overall): SBAS/WAAS dataref availability in XPL → research — PRESERVE
   - §7.J: Fly-by vs. fly-over turn geometry details (OPEN QUESTION 3) — PRESERVE
   - §7.L: Altitude constraints (OPEN QUESTION 1) — PRESERVE as "behavior unknown from available documentation; research needed during design phase"
   - §7.M: ARINC 424 leg types (OPEN QUESTION 2) — PRESERVE with confirmed-types list + flag

9. If ALL requirements are covered by your planned fragment structure: print "Phase 0: all source requirements covered" and proceed to authoring.
10. If any requirement is uncovered: write `docs/tasks/c22_d_prompt_phase0_deviation.md` and STOP.

---

## Instructions

Produce the fourth fragment of the GNX 375 Functional Spec V1 body: the first operational-workflow fragment covering §§5–7 (Flight Plan Editing + Direct-to Operation + Procedures). This is the largest fragment in the series and carries the densest procedural-fidelity content. It also introduces **§7.9** as a new sub-section required to resolve Fragment C's forward-refs (per ITM-09).

**Primary output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md`

### Authoring strategy

Same as Fragments A/B/C: outline provides structural skeleton; task expands outline bullets into implementable prose while preserving structure, page references, and cross-references.

#### Authoring depth guidance

- **Scope paragraphs (per top-level section):** 2–4 sentences per top-level section (§5, §6, §7). State what the section is for, its key GNX 375-specific framing (if any), and operational cross-refs.

- **Sub-section prose:** each outline bullet expands into a short block (5–25 lines typical). Preserve source-page citations inline.

- **Tables:** use tables where content is naturally tabular. Expected tables in Fragment D:
  - §5.1 Route Options menu (Activate, Invert & Activate, Copy to Active, Delete, Preview)
  - §5.3 Waypoint Options menu (Insert Before, Insert After, Remove, Direct-to, Waypoint Info, Procedures)
  - §5.9 FPL data columns (selectable column types: ETE, ETA, DTK, XTK, etc.)
  - §6.2 Direct-to search tabs (Waypoint, Flight Plan, Nearest)
  - §7.2 GPS Flight Phase Annunciations (9–11 rows — may extend outline per S13 pattern from Fragment C; see below)
  - §7.5 Approach types (LNAV, LNAV/VNAV, LNAV+V, LPV, LP, LP+V, ILS — same 7 types Fragment C already tabulated; cross-ref OR re-tabulate with operational detail)
  - §7.7 Approach Hold menu options (Activate Hold, Insert After, Edit Hold, Exit Hold, Remove)
  - §7.D CDI scale HAL table (Approach 0.30 / Terminal 1.00 / En Route 2.00 nm — or fuller per-phase mapping)
  - §7.F Approach mode transitions (LPV→LNAV, LP→LNAV+V, LNAV/VNAV→LNAV; triggers, advisory messages)
  - §7.9 XPDR mode × flight-phase matrix (if useful — optional)

- **S13-pattern watchpoint for §7.2 GPS Flight Phase Annunciations:** Fragment C extended the outline's 9-item list with LNAV/VNAV and MAPR, both PDF-confirmed. Fragment D's §7.2 should match Fragment C's annunciation list exactly (11 rows, same color semantics). Trust the PDF over the outline when in conflict.

- **AMAPI cross-refs:** at the end of each top-level section (§5, §6, §7), include an "AMAPI notes" block. Cite, don't expand.

- **Open questions / flags:** preserve every outline flag. See the open-question preservation checklist above.

- **Cross-references:**
  - Backward-refs to Fragments A/B/C use "see §N.x" without fragment qualification (spec body is unified post-assembly)
  - Forward-refs to Fragments E, F, G use "see §N.x" without further qualification

#### Fragment file conventions (per D-18)

- **Path:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md`
- **YAML front-matter (required):**
  ```yaml
  ---
  Created: 2026-04-23T{HH:MM:SS}-04:00
  Source: docs/tasks/c22_d_prompt.md
  Fragment: D
  Covers: §§5–7 (Flight Plan Editing, Direct-to Operation, Procedures)
  ---
  ```
- **Heading levels:**
  - `# GNX 375 Functional Spec V1 — Fragment D` — fragment header (stripped on assembly)
  - `## 5. Flight Plan Editing` — top-level section headers use `##`
  - `## 6. Direct-to Operation`
  - `## 7. Procedures`
  - `### 5.1 Flight Plan Catalog [pp. 150–151]` — numeric sub-sections use `###`
  - `### 7.A Glidepath vs. Glideslope Nomenclature [pp. 184–185, 200–203]` — lettered augmentations use `###`
  - `### 7.9 XPDR + ADS-B Approach Interactions [pp. 75–82, 245–256]` — **NEW per ITM-09**
  - Do NOT include harvest-category markers (`— [FULL]`, `— [PART]`) in spec-body headings.
- **Line count target:** ~750 lines per D-19. Under-delivery (<675) suggests under-coverage; over-delivery (>825) warrants completion-report classification.

#### Specific framing commitments

These are **hard constraints** that must appear in the fragment:

1. **§7.9 must be authored as a real `### 7.9` sub-section under §7.** Title: "XPDR + ADS-B Approach Interactions" (or equivalent). This resolves ITM-09. Fragment C forward-refs §7.9 twice; §7.9 must exist to make those forward-refs resolve on assembly. Content per Phase 0 actionable-requirements enumeration above. Verify with `grep -c '^### 7\.9'` returning exactly 1.

2. **§7 sub-section ordering:** §§7.1 → 7.2 → 7.3 → 7.4 → 7.5 → 7.6 → 7.7 → 7.8 → 7.9 → 7.A → 7.B → 7.C → 7.D → 7.E → 7.F → 7.G → 7.H → 7.I → 7.J → 7.K → 7.L → 7.M. Numeric sub-sections 7.1–7.9 come first (§7.9 inserted after §7.8); then lettered augmentations 7.A–7.M per D-14. Confirm ordering by reading sub-section headings sequentially.

3. **§5–§7 scope paragraphs do NOT re-author §4 content.** §4 display pages were authored across Fragments B and C. §5, §6, §7 operational-workflow sections reference §4 display pages via "see §4.X" cross-refs. No re-enumeration of page layouts, icon inventories, or annunciator slot lists.

4. **§7.5 RNAV approaches + §7.C ILS + §7.G CDI deviation — no internal VDI (per D-15).** All approach-vertical-guidance prose must state that vertical deviation is output to external CDI/VDI only. Re-assert this framing consistently with Fragment A §1 and Fragment C §4.7 Visual Approach. **No prose anywhere in Fragment D may imply the GNX 375 renders a VDI internally.**

5. **§7.5 approach types table must match Fragment C §4.7 approach types table.** Seven types: LNAV, LNAV/VNAV, LNAV+V, LPV, LP, LP+V, ILS. Same columns if re-tabulated (type / vertical guidance / SBAS required / GPS nav approval). §7.5 may add operational columns (e.g., "Operational state machine" or "CDI scale behavior") not present in §4.7's display-focused table; that's fine. Do NOT contradict Fragment C's table on the 7 types.

6. **§7.2 GPS Flight Phase Annunciations table: 11 rows matching Fragment C §4.7.** Outline lists 9 annunciations; Fragment C (S13-pattern) extended to 11 with LNAV/VNAV and MAPR. Fragment D §7.2 must match Fragment C §4.7's 11-row table. Color semantics same. If new operational detail for §7.2 justifies additional rows, add them with PDF citation; do NOT contradict Fragment C's 11-row set.

7. **§7.8 Autopilot Outputs + §7.G + §15.6 forward-ref.** §7.8 documents GPSS + LPV glidepath capture (KAP 140, KFC 225) + "Enable APR Output" advisory + manual activation requirement. Autopilot coupling datarefs (XPL + MSFS) are in §15 (Fragment G); forward-ref §15 / §15.6 for the dataref contract. §7.G CDI deviation display cross-refs §15.6 for the external output side.

8. **§7.D CDI scale auto-switching cross-refs §4.10 + §10.1 + §15.6.** §4.10 (Fragment C) authored CDI On Screen + CDI Scale settings page. §10.1 (Fragment E, future) will author CDI Scale + CDI On Screen operational workflows. §15.6 (Fragment G, future) will author external CDI output contract. §7.D is the approach-phase scale-switching operational behavior.

9. **§7.9 "three XPDR modes only" framing (per D-16).** §7.9 must state XPDR modes are Standby / On / Altitude Reporting — **no Ground mode, no Test mode, no Anonymous mode on the GNX 375.** Air/ground state handled automatically per p. 78. This framing must be consistent with Fragment C §4.9 and Fragment A §1.

10. **§7.9 TSAA = GNX 375 only.** §7.9's TSAA content must be consistent with Fragment C §4.9's TSAA framing (GNX 375 only; GPS 175 and GNC 355/355A do not have TSAA — they have ADS-B traffic display only via external hardware). Cross-ref §4.9 and §11.11 for source-side detail.

11. **OPEN QUESTION 6 (TSAA aural delivery mechanism) cross-ref in §7.9.** §7.9's TSAA-during-approach content must acknowledge that aural alert delivery is deferred to design phase (OPEN QUESTION 6 originally preserved verbatim in Fragment C §4.9). §7.9 does not re-preserve the verbatim question; it cross-refs to §4.9 for the question and §12.4 (Fragment F) for the aural alert hierarchy.

12. **ITM-08 corrective action — Coupling Summary glossary-ref grep-verify.** Before finalizing the Coupling Summary, `grep` each Appendix B glossary term claimed as a backward-ref against `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`. Remove any terms not present in Appendix B from the Coupling Summary backward-refs list. Specifically: do not claim EPU, HFOM/VFOM, HDOP, TSO-C151c as Appendix B entries (they are not). Only claim terms actually present in Appendix B as formal glossary entries. This corrects the Fragment C over-enumeration pattern at authoring time.

13. **No COM present-tense on GNX 375.** Carry forward from Fragments A/B/C. Any COM content in §5/§6/§7 must be in sibling-unit comparison context (rare — §5/§6/§7 are largely unit-agnostic) or absent entirely. The CDI Scale / OBS mode / parallel track prose does not involve COM.

14. **§5 Graphical FPL Editing (§5.4) cross-refs §4.2.** Fragment B authored §4.2 Map page including graphical-edit overlay. §5.4 operational workflow acts on the §4.2 display; cross-ref, don't re-author.

#### Per-section page budget (informative; Coupling Summary corrected per D-21 watchpoint)

| Section | Outline estimate | Fragment prose target |
|---------|------------------|------------------------|
| Fragment header + YAML | — | ~10 |
| §5 Flight Plan Editing (9 sub-sections) | ~200 | ~235 |
| §6 Direct-to Operation (6 sub-sections) | ~80 | ~90 |
| §7 Procedures — numeric (§§7.1–7.9) | ~200 | ~240 (7.1–7.8 from outline + new 7.9 ~25 lines) |
| §7 Procedures — lettered (§§7.A–7.M) | ~150 | ~180 (13 augmentations) |
| Coupling Summary block | — | **~60** (corrected per D-21 C2.2-B/C miscalibration) |
| **Total target** | **~630** | **~815** |

The 815 total slightly exceeds the 750 D-19 target; this is a soft ceiling. If actual output trends significantly above 815, classify in completion report. CC may proactively trim (e.g., compress lettered-augmentation prose) to approach 750 more closely.

#### Coupling Summary block

At the end of the fragment (after §7 content ends), include a **Coupling Summary** section per D-18:

```markdown
---

## Coupling Summary

This section is authored per D-18 for CD/CC coordination across the 7-fragment spec. It is not part of the spec body and is stripped on assembly.

### Backward cross-references (sections this fragment references authored in prior fragments)

- Fragment A §1 (Overview): GNX 375 baseline framing, no-internal-VDI constraint (D-15) — referenced throughout §7 RNAV/Visual/Autopilot and §7.C/§7.G content.
- Fragment A §2 (Physical Layout & Controls): knob push = Direct-to (GNX 375 pattern) — referenced in §6.1.
- Fragment A §3 (Power-On / Startup / Database): no direct Fragment D dependency.
- Fragment A Appendix B (Glossary): **only claim terms actually present as formal glossary entries.** Verified via grep before writing this Coupling Summary. Expected terms that ARE present: FAF, MAP, LPV, LNAV, LP, SBAS, WAAS, TSAA, FIS-B, UAT, 1090 ES, Extended Squitter, TSO-C112e, TSO-C166b, WOW, IDENT, Flight ID, GPSS. Do NOT claim: EPU, HFOM/VFOM, HDOP, TSO-C151c (absent from Appendix B per X17 finding in C2.2-C compliance; these are display-field labels or cert standards used inline but NOT formal glossary entries).
- Fragment B §4.2 (Map Page): §5.4 Graphical FPL Editing acts on this display — cross-ref.
- Fragment B §4.3 (FPL Page): §5.1–5.9 act on this display; GPS NAV Status indicator key cross-ref for CDI On Screen.
- Fragment B §4.4 (Direct-to Page): §6.1–6.6 act on this display.
- Fragment C §4.7 (Procedures Display Pages): §7.1–7.9 + §7.A–7.M operational workflows act on these displays; approach types table matches §4.7; GPS Flight Phase annunciations table matches §4.7.
- Fragment C §4.9 (Hazard Awareness): §7.9 TSAA-during-approach cross-refs §4.9; TSAA GNX 375-only framing consistent; B4 Gap 1 not re-authored.
- Fragment C §4.10 (Settings/System): §7.D CDI scale auto-switching cross-refs §4.10 CDI Scale + CDI On Screen; §7.G CDI deviation display cross-refs §4.10 CDI On Screen.

### Forward cross-references (sections this fragment writes that later fragments will reference)

- §5 FPL editing → §10 Settings (Fragment E) for pilot-settings-side behaviors (no direct dependencies, but conceptually adjacent).
- §5.4 Graphical FPL Editing → §15 External I/O (Fragment G) for flight-plan-change datarefs.
- §6 Direct-to Operation → §15 External I/O (Fragment G) for direct-to command dispatch.
- §7 Procedures → §10 Settings (Fragment E) for CDI Scale + CDI On Screen settings; §15 External I/O (Fragment G) for autopilot output datarefs.
- §7.5 / §7.C / §7.G / §7.8 → §15.6 External CDI/VDI Output Contract (Fragment G) for the external-output side of all vertical-deviation behavior.
- §7.8 Autopilot Outputs → §15 External I/O (Fragment G) for GPSS + APR output datarefs; OPEN QUESTION preserved for dataref names.
- §7.9 XPDR + ADS-B approach interactions → §11 Transponder + ADS-B (Fragment F) for XPDR control detail; §11.4 XPDR modes; §11.11 ADS-B In receiver; §12.4 aural alert hierarchy (Fragment F); §15 External I/O (Fragment G) for XPDR + ADS-B datarefs.
- §7.2 GPS Flight Phase Annunciations → §12.2 Alert Annunciations (Fragment F) for annunciator-bar rendering.
- §7.F Approach mode transitions → §13 Messages (Fragment F) for advisory message text ("GPS approach downgraded. Use LNAV minima.").

### §7.9 authorship note

Fragment D introduces §7.9 as a new numeric sub-section under §7 to resolve Fragment C's forward-refs (per ITM-09). The outline did not have a §7.9 heading; Fragment D creates it. On assembly, §7 is presented with §§7.1–7.9 numeric (in order) followed by §§7.A–7.M lettered augmentations. Fragment C's two forward-refs to §7.9 (in §4.7 Open Questions) resolve to this new sub-section.

### Outline coupling footprint

This fragment draws from outline §§5–7 only. No content from §§1–4 (Fragments A + B + C), §§8–15, or Appendices A/B/C is authored here.
```

---

## Integration Context

- **Primary output file:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` (new)
- **Directory already exists:** `docs/specs/fragments/` contains part_A, part_B, part_C.
- **No code modification in this task.** Docs-only.
- **No test suite run required.** Docs-only.
- **Do not modify the outline.** If you spot outline errors during authoring (PDF-vs-outline discrepancies, S13-pattern opportunities), note them in the completion report's Deviations section and continue with the PDF-accurate content.
- **Do not modify Fragment A, Fragment B, or Fragment C.** All are archival.
- **Do not modify the manifest yet.** CD will update the manifest status entry for Fragment D after this task archives.
- **Do not modify `docs/todos/issue_index.md` to close ITM-09.** CD closes ITMs during the archive step (after compliance PASS). CC authors the §7.9 sub-section that satisfies ITM-09 but does not mark the ITM resolved.

---

## Implementation Order

**Execute phases sequentially. Do not parallelize phases or launch subagents.**

### Phase A: Read and audit (Phase 0 per above)

Read all Tier 1 and Tier 2 sources. Read Fragments A, B, C in full. **Read ITM-08 and ITM-09 in full.** Extract actionable requirements. Confirm coverage of the open-question preservation checklist. Print the Phase 0 completion line OR write the Phase 0 deviation report and STOP.

### Phase B: Create fragment file skeleton

1. Create the fragment file at `docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` with YAML front-matter, fragment header (`# GNX 375 Functional Spec V1 — Fragment D`), and section headers (`## 5.`, `## 6.`, `## 7.`).
2. Add sub-section headers for §5 (5.1–5.9), §6 (6.1–6.6), §7 (7.1–7.9 numeric, 7.A–7.M lettered).
3. Add the Coupling Summary placeholder at the end.

### Phase C: Author §5 Flight Plan Editing (~235 lines)

Scope paragraph noting identical across all three units (unit-agnostic, §§5.1–5.9 from outline). Expand each sub-section per Phase 0 actionable-requirements enumeration. Include Route Options table (§5.1), Waypoint Options table (§5.3), FPL Data Columns table (§5.9). AMAPI notes block. Open questions / flags (persistence schema + wireless import). B4 Gap 2 (scrollable list) cross-ref to §4.3 (Fragment B) where the design decision lives.

### Phase D: Author §6 Direct-to Operation (~90 lines)

Scope paragraph noting identical across all three units. Expand §§6.1–6.6 per Phase 0 enumeration. Search tabs table (§6.2). Operational steps for Activation, New Waypoint, Removal, User Holds. AMAPI notes block. No outline-flagged open questions for §6.

### Phase E: Author §7 Procedures numeric sub-sections (§§7.1–7.9) (~240 lines)

Scope paragraph noting full procedural fidelity per D-12 Q3c + D-14; 375 distinction (no internal VDI per D-15; XPDR + ADS-B interactions per D-16). Expand §§7.1–7.8 per Phase 0 enumeration:
- §7.1 Flight Procedure Basics (loading rules, roll steering, TO/FROM)
- §7.2 GPS Flight Phase Annunciations (11-row table matching Fragment C §4.7; color semantics; integrity-degraded / downgrade behaviors)
- §7.3 Departures
- §7.4 Arrivals
- §7.5 Approaches (7-type table consistent with Fragment C; SBAS Channel ID; procedure turns; non-required holding; ILS monitoring; RNAV sub-types; downgrade message; Visual Approaches external CDI/VDI; DME Arc; RF Legs; VTF; ARINC 424 open-question preservation)
- §7.6 Missed Approach (before/after MAP states; pop-up prompt)
- §7.7 Approach Hold (Hold Options menu with Activate / Insert After / Edit / Exit / Remove; non-required holding)
- §7.8 Autopilot Outputs (GPSS + LPV glidepath capture; manual APR activation; open-question for dataref names)

Then **§7.9 XPDR + ADS-B Approach Interactions (NEW per ITM-09)** (~25 lines):
- XPDR ALT mode during approach; air/ground state handled automatically per p. 78
- ADS-B Out transmission (1090 ES) during approach
- TSAA traffic display + aural alerts during approach (cross-ref §4.9 OPEN QUESTION 6)
- Flight phase annunciation + XPDR state correlation
- Forward-refs to §11, §11.4, §11.11, §12.4, §15

### Phase F: Author §7 Procedures lettered augmentations (§§7.A–7.M) (~180 lines)

Expand §7.A through §7.M per Phase 0 enumeration (13 sub-sections, ~14 lines average). Each augmentation:
- One-sentence scope statement
- Key behavioral details (bullet list or short paragraphs)
- Cross-refs to related numeric sub-sections (e.g., §7.B cross-refs §7.2 for annunciation color; §7.G cross-refs §4.10 for CDI On Screen; §7.J cross-refs Fragment B §4.3 for fly-over symbol)
- PDF citations preserved
- OPEN QUESTION preservations: §7.J (turn geometry), §7.L (altitude constraints), §7.M (ARINC 424 legs)

### Phase G: Author Coupling Summary (~60 lines)

Write the Coupling Summary block per the template above. **Execute ITM-08 grep-verify before writing:**
1. Open Fragment A (`docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`)
2. Locate Appendix B glossary
3. For each term you plan to claim as an Appendix B backward-ref, `grep` the Appendix B section and confirm the term exists as a formal glossary entry
4. Remove any terms that do NOT appear as formal Appendix B entries from the backward-refs list
5. Document in the completion report which terms were verified-present and which were removed (if any) due to absence

Specifically exclude from the Fragment A Appendix B backward-refs list: EPU, HFOM/VFOM, HDOP, TSO-C151c (these are NOT formal glossary entries per C2.2-C compliance finding X17).

Include §7.9 authorship note in the Coupling Summary explaining that Fragment D creates §7.9 to resolve Fragment C's forward-refs per ITM-09.

### Phase H: Self-review

Before writing the completion report, perform the following self-checks (per D-08 — completion report claim verification):

1. **Line count:** `wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — target ~750, soft ceiling 815; acceptable band ~675–900.
2. **Character encoding:** `grep -c '\\u[0-9a-f]\{4\}' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — expect 0.
3. **Replacement chars:** Python check (saved `.py` file per D-08) to count U+FFFD bytes — expect 0.
4. **§7.9 authored as a sub-section:** `grep -c '^### 7\.9' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — **expect exactly 1**. This is the ITM-09 structural fix verification.
5. **§7 sub-section ordering:** `grep -nE '^### 7\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — should yield headings in order 7.1 → 7.2 → 7.3 → 7.4 → 7.5 → 7.6 → 7.7 → 7.8 → 7.9 → 7.A → 7.B → 7.C → 7.D → 7.E → 7.F → 7.G → 7.H → 7.I → 7.J → 7.K → 7.L → 7.M (22 total).
6. **§7.5 approach types consistent with Fragment C §4.7:** Confirm 7 approach types match Fragment C's 7 types (LNAV, LNAV/VNAV, LNAV+V, LPV, LP, LP+V, ILS). If §7.5 uses a different table structure (adding operational columns), verify the 7 type labels are identical to Fragment C's.
7. **§7.2 GPS Flight Phase Annunciations consistent with Fragment C §4.7:** Confirm the annunciation table includes the 11 rows Fragment C established (OCEANS, ENRT, TERM, DPRT, LNAV, LNAV/VNAV, LNAV+V, LP, LP+V, LPV, MAPR). Color semantics (green normal, yellow caution) match.
8. **No internal VDI:** `grep -ni 'VDI\|vertical deviation indicator' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — every match either frames vertical deviation as external-output-only OR is in a cross-ref context OR is an explicit "no internal VDI" framing. No match implies GNX 375 renders VDI internally.
9. **§7.9 TSAA GNX 375-only + three modes framing:** `grep -ni 'TSAA\|Standby\|Altitude Reporting' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — §7.9 TSAA refs are GNX 375-consistent; §7.9 XPDR modes framing matches "three modes only" per D-16.
10. **§7.9 OPEN QUESTION 6 cross-reference:** `grep -ni 'OPEN QUESTION 6\|§4\.9\|§12\.4' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — §7.9 cross-refs §4.9 and §12.4 for the aural delivery mechanism. §7.9 does not re-preserve OPEN QUESTION 6 verbatim; it cross-refs.
11. **§7.L OPEN QUESTION 1 preserved:** §7.L (altitude constraints on FPL legs) flagged as "behavior unknown from available documentation; research needed during design phase." VCALC-is-separate framing present.
12. **§7.M OPEN QUESTION 2 preserved:** §7.M (ARINC 424 leg types) flagged with confirmed-types list (TF, CF, DF, RF from examples) + enumeration-is-research-needed framing.
13. **§7.J OPEN QUESTION 3 preserved:** §7.J (fly-by vs. fly-over turn geometry) flagged with behavioral distinction + turn-geometry-details-limited-source framing.
14. **§7.8 autopilot dataref open question preserved:** §7.8 notes XPL dataref names for GPSS/APR require design-phase research.
15. **§5 flight plan persistence open question preserved:** §5 AMAPI notes or open questions flag flight plan persistence schema (scalar persist API requires JSON encoding strategy).
16. **§5 wireless import open question preserved:** §5 flags Bluetooth / Garmin Pilot wireless import as possibly out of scope for v1 instrument.
17. **No COM present-tense on GNX 375:** `grep -ni 'COM radio\|COM standby\|COM volume\|COM frequency\|COM monitoring\|VHF COM' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — all matches in sibling-unit comparison context or absent entirely. No "GNX 375 has [COM feature]."
18. **No §4 display-page content re-authored:** `grep -nE '^## 4\.|^### 4\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — expect **0 matches**. §4 is Fragments B and C; Fragment D does not re-author any §4 content.
19. **No §§8–15 scope content in Fragment D:** `grep -nE '^## [8-9]\.|^## 1[0-5]\.|^### (8|9|10|11|12|13|14|15)\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — expect **0 matches**. Forward-refs to §§8–15 appear only as prose cross-refs (e.g., "see §10"), not as authored section headers.
20. **Outline page citations preserved:** sample 10 outline page citations and confirm each appears in the fragment at the corresponding sub-section:
    - `[pp. 150–151]` at §5.1
    - `[pp. 129–132]` in §5.4
    - `[pp. 159–164]` at §6 heading or §6.1
    - `[pp. 181–207]` at §7 heading
    - `[pp. 184–185]` in §7.2
    - `[p. 191]` in §7.5 SBAS Channel ID
    - `[p. 198]` in §7.5 ILS + §7.C
    - `[p. 207]` in §7.8
    - `[pp. 75–82]` in §7.9 XPDR
    - `[p. 89]` in §7.G CDI On Screen cross-ref
21. **Fragment file conventions:** YAML front-matter present with Created/Source/Fragment/Covers; fragment header `# GNX 375 Functional Spec V1 — Fragment D`; top-level sections use `##`; sub-sections use `###`; no harvest-category markers in `###` lines. `grep -nE '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])'` returns 0 matches.
22. **Coupling Summary section present:** backward-refs (Fragments A/B/C) + forward-refs (Fragments E/F/G) enumerated; §7.9 authorship note present; outline coupling footprint note present.
23. **ITM-08 Coupling Summary grep-verify executed:** Appendix B backward-ref terms verified-present in Fragment A via grep before writing Coupling Summary. EPU, HFOM/VFOM, HDOP, TSO-C151c NOT claimed as Appendix B entries. List of verified-present terms documented in completion report.
24. **§7.9 authorship honors ITM-09:** `### 7.9` sub-section exists (count = 1), covers XPDR-interaction during approach + TSAA behavior during approach + WOW state interaction (three open-question concepts from Fragment C §4.7). Forward-refs to §11.4, §11.11, §12.4, §15 present.

Report all 24 check results in the completion report.

---

## Completion Protocol

1. Write completion report to `docs/tasks/c22_d_completion.md` with this structure:

   ```markdown
   ---
   Created: {ISO 8601 timestamp}
   Source: docs/tasks/c22_d_prompt.md
   ---

   # C2.2-D Completion Report — GNX 375 Functional Spec V1 Fragment D

   **Task ID:** GNX375-SPEC-C22-D
   **Output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md`
   **Completed:** 2026-04-23

   ## Pre-flight Verification Results
   {table of the 8 pre-flight checks with PASS/FAIL}

   ## Phase 0 Audit Results
   {summary of actionable requirements confirmed covered; include open-question preservation checklist}

   ## Fragment Summary Metrics
   | Metric | Value |
   |--------|-------|
   | Fragment file | `docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` |
   | Line count | {actual} |
   | Target line count | ~750 |
   | Soft ceiling | 815 |
   | Sections covered | §§5–7 |
   | §7 sub-section count | 22 (7.1–7.9 numeric + 7.A–7.M lettered) |
   | §7.9 sub-section created | {yes/no — ITM-09 resolution} |

   ## Self-Review Results (Phase H)
   {table of the 24 self-checks with PASS/FAIL and specifics}

   ## Hard-Constraint Verification
   {confirm each of the 14 framing commitments}

   ## ITM-08 Coupling Summary Grep-Verify Report
   {list of Appendix B terms you PLANNED to claim as backward-refs; list of terms CONFIRMED-PRESENT via grep; list of terms REMOVED from the Coupling Summary because grep returned 0 matches in Fragment A Appendix B}

   ## ITM-09 §7.9 Authorship Confirmation
   {confirm §7.9 sub-section exists; quote its heading; list forward-refs it satisfies from Fragment C}

   ## Coupling Summary Preview
   {brief summary of backward-refs to Fragments A/B/C and forward-refs to Fragments E/F/G}

   ## Deviations from Prompt
   {table of any deviations with rationale; if none, state "None"}
   ```

2. `git add -A`

3. `git commit` with the D-04 trailer format. Write the commit message to a temp file via `[System.IO.File]::WriteAllText()` (BOM-free):

   ```
   GNX375-SPEC-C22-D: author fragment D (§§5–7 operational workflows)

   Fourth of 7 piecewise fragments per D-18. Covers Flight Plan Editing
   (§5), Direct-to Operation (§6), and Procedures (§7) including
   full §§7.1–7.9 numeric + §§7.A–7.M lettered procedural-fidelity
   augmentations per D-14. Target: ~750 lines; actual: {N}.

   Resolves ITM-09: §7.9 "XPDR + ADS-B Approach Interactions" authored
   as a real sub-section (outline lacked this heading; Fragment C
   forward-refs §7.9 for XPDR-interaction and TSAA during approach).

   Honors ITM-08 watchpoint: Coupling Summary Appendix B backward-refs
   grep-verified against Fragment A before finalization. EPU,
   HFOM/VFOM, HDOP, TSO-C151c NOT claimed (absent from Appendix B).

   Framing commitments honored: §7.5 + §7.C + §7.G no internal VDI
   per D-15 (vertical deviation output to external only); §7.5
   approach-types table consistent with Fragment C §4.7 (7 types);
   §7.2 GPS Flight Phase annunciations consistent with Fragment C
   (11 rows; S13-pattern); §7.9 three XPDR modes only per D-16;
   §7.9 TSAA = GNX 375 only; OPEN QUESTION 6 cross-ref. Open
   questions preserved: §5 persistence + wireless import, §7.L
   altitude constraints, §7.M ARINC 424, §7.J fly-by/over geometry,
   §7.8 autopilot dataref.

   Task-Id: GNX375-SPEC-C22-D
   Authored-By-Instance: cc
   Refs: D-14, D-15, D-16, D-18, D-19, D-20, D-21, ITM-08, ITM-09, GNX375-SPEC-C22-A, GNX375-SPEC-C22-B, GNX375-SPEC-C22-C
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

   PowerShell pattern (mandatory — do not use inline `python -c`):
   ```powershell
   $msg = @'
   ...message above with actual {N} values substituted...
   '@
   [System.IO.File]::WriteAllText((Join-Path $PWD ".git\COMMIT_EDITMSG_cc"), $msg)
   git commit -F .git\COMMIT_EDITMSG_cc
   Remove-Item .git\COMMIT_EDITMSG_cc
   ```

4. **Flag refresh check:** This task does NOT modify `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`. Do NOT create refresh flags.

5. **Send completion notification:**
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-D completed [flight-sim]"
   ```

6. **Do NOT git push.** Steve pushes manually.

---

## What CD will do with this report

After CC completes:

1. CD runs check-completions Phase 1: reads the prompt + completion report, cross-references claims against the fragment file, generates a compliance prompt modeled on the C2.2-C approach (~25-item check across F / S / X / C / N categories). The compliance prompt will verify the 24 self-checks plus ITM-08 and ITM-09 resolution verification plus PDF source-fidelity spot checks for new tables (§7.D HAL, §7.F approach transitions, §7.9 XPDR×flight-phase correlation).

2. After CC runs the compliance prompt: CD runs check-compliance Phase 2. PASS → archive all four files to `docs/tasks/completed/`; update manifest (Fragment D → ✅ Archived); close ITM-09 (move to resolved index); **begin drafting C2.2-E per D-21** (gated on C2.2-D archive). PASS WITH NOTES → log any new ITMs if needed, archive, continue. FAIL → bug-fix task.

---

## Estimated duration

- CC wall-clock: ~15–25 min (LLM-calibrated per D-20: ~750-line docs-only fragment with moderate reuse of Fragments A/B/C conventions; baseline 500-line docs task = 10–20 min; scale 1.5× for line count; reuse ×0.7 discount partially offsets; §7.9 novel content + ITM-08 grep-verify adds ~3 min; net ~15–25 min).
- CD coordination cost after this: ~1 check-completions turn + ~1 check-compliance turn + ~0.5 turn to update manifest + close ITM-09 + start C2.2-E prompt.

Proceed when ready.
