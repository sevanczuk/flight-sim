# CC Task Prompt: C2.2-E — GNX 375 Functional Spec V1 Fragment E (§§8–10)

**Created:** 2026-04-23T14:11:39-04:00
**Source:** CD Purple session — Turn 1 (2026-04-23) — fifth of 7 piecewise fragments per D-18
**Task ID:** GNX375-SPEC-C22-E (Stream C2, sub-task 2E for the 375 primary deliverable)
**Parent reference:** `docs/decisions/D-18-c22-format-decision-piecewise-manifest.md` §"Task partition"
**Authorizing decisions:** D-11 (outline-first), D-12 (pivot to 375), D-15 (no internal VDI — relevant to §10.1 CDI On Screen framing), D-16 (XPDR + ADS-B scope — relevant to §10.12 ADS-B Status built-in framing and §10.13 Logs GNX 375 traffic logging), D-18 (piecewise format + 7-task partition), D-19 (fragment line-count expansion ratio — target ~455), D-20 (LLM-calibrated duration estimates), D-21 (sequential drafting — this prompt drafted after C2.2-D archived)
**Predecessor tasks:** C2.2-A archived (`docs/tasks/completed/c22_a_*.md`), C2.2-B archived (`docs/tasks/completed/c22_b_*.md`), C2.2-C archived (`docs/tasks/completed/c22_c_*.md`), C2.2-D archived (`docs/tasks/completed/c22_d_*.md`). All four are authoritative backward-reference sources.
**Depends on:** C2.2-A archived ✅, C2.2-B archived ✅, C2.2-C archived ✅, C2.2-D archived ✅, manifest at `docs/specs/GNX375_Functional_Spec_V1.md` (Fragment D status ✅ Archived)
**Priority:** Critical-path — fifth of 7 fragments; smallest remaining fragment at ~455 lines target. Lower risk profile than Fragment D: no novel sub-section creation, no procedural-fidelity augmentations, straightforward operational workflows on established §4.5 / §4.6 / §4.10 display pages. Expect clean compliance.
**Estimated scope:** Medium — authors ~455 lines across 3 sections: §8 Nearest Functions (~70), §9 Waypoint Information Pages (~150), §10 Settings/System Pages (~240). Plus fragment header, Coupling Summary (~60 lines per D-19 corrected budget).
**Task type:** docs-only (no code, no tests)
**CRP applicability:** Not required. Fragment E is the smallest remaining fragment; single-file docs output typically does not trigger compaction since no large intermediate artifacts accumulate. Default: no CRP.

---

## Source of Truth (READ ALL OF THESE BEFORE AUTHORING ANY SPEC BODY CONTENT)

### Tier 1 — Authoritative content source

1. **`docs/specs/GNX375_Functional_Spec_V1_outline.md`** — **THE PRIMARY BLUEPRINT.** For C2.2-E, authoritative content comes from:
   - **§8 Nearest Functions** (~60 outline lines) — sub-structure 8.1–8.5: Nearest Access, Nearest Airports, Nearest NDB/VOR/Intersection/VRP, Nearest ARTCC, Nearest FSS
   - **§9 Waypoint Information Pages** (~120 outline lines) — sub-structure 9.1–9.5: Database Waypoint Types, Airport Information Page, Intersection/VOR/VRP/NDB Pages, User Waypoints, Waypoint Search and FastFind
   - **§10 Settings / System Pages** (~200 outline lines) — sub-structure 10.1–10.13: CDI Scale, Airport Runway Criteria, Clocks and Timers, Page Shortcuts, Alerts Settings, Unit Selections, Display Brightness Control, Scheduled Messages, Crossfill, Connectivity (Bluetooth), GPS Status, ADS-B Status, Logs

   **Do not deviate from the outline's section numbering, sub-structure, or page references.** The outline is the contract; this task expands it into prose.

2. **`docs/decisions/D-18-c22-format-decision-piecewise-manifest.md`** — format contract. Re-read §"Fragment file conventions" and §"Coupling summary convention" before authoring.

3. **`docs/decisions/D-19-fragment-prompt-line-count-expansion-ratio.md`** — line-count authority. Target: **~455 lines** for Fragment E (per-task table in D-19). Acceptable band ~415–600. Soft ceiling ~550 (series baseline ~20% overage; Fragment E is scope-smallest so expect ~550 actual).

4. **`docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`** — **Fragment A authoritative backward-reference source.** Appendix B glossary terms (SBAS, WAAS, CDI, VDI, GPSS, FIS-B, UAT, 1090 ES, TSAA, Connext, TSO-C166b, RAIM, etc.), §1 framing (no internal VDI, GNX 375 baseline, sibling-unit distinctions), §2 physical control terminology, §3 SD card specs + Connext data link framing. Do not redefine.

5. **`docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`** — **Fragment B authoritative backward-reference source.** Specifically relevant:
   - §4.5 Waypoint Information display pages — §9 operational workflows act on this display
   - §4.6 Nearest display pages — §8 operational workflows act on this display
   - §4 parent scope paragraph — already authored; DO NOT re-author §4 anything

6. **`docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md`** — **Fragment C authoritative backward-reference source.** Specifically relevant:
   - §4.9 Hazard Awareness — FIS-B + Traffic + TSAA framing (relevant to §9.2 Weather tab FIS-B behavior and §10.12 ADS-B Status built-in receiver)
   - §4.10 Settings/System display pages — §10 operational workflows act on these displays. Includes CDI Scale + CDI On Screen display elements (§10.1), ADS-B Status built-in framing (§10.12), and Logs GNX 375 traffic logging (§10.13). **§10 prose must match §4.10's framing on all three.**

7. **`docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md`** — **Fragment D authoritative backward-reference source.** Specifically relevant:
   - §7.D CDI scale auto-switching — §10.1 CDI Scale operational workflow cross-refs §7.D for flight-phase interaction
   - §7.G CDI deviation display on-screen vs. external — §10.1 CDI On Screen operational toggle cross-refs §7.G for lateral-only framing and D-15 consistency

8. **`docs/specs/GNX375_Functional_Spec_V1.md`** — the fragment manifest. Confirm Fragment E manifest entry (order 5, covers §§8–10, target 455) matches your output path.

### Tier 2 — PDF source material (authoritative for content details)

9. **`assets/gnc355_pdf_extracted/text_by_page.json`** — primary PDF source. For C2.2-E, the relevant pages:
   - §8 Nearest Functions: pp. 179–180
   - §9 Waypoint Information: pp. 165–178 (primary), including pp. 167 (Airport Info tabs), pp. 168 (User Waypoints delete), pp. 169–171 (FastFind + Search Tabs), pp. 172–175 (User Waypoint create — Lat/Lon, Radial/Distance, Radial/Radial), p. 176 (User Waypoint edit), pp. 177–178 (User Waypoint import)
   - §10 Settings/System: pp. 53–56 (Bluetooth / Connext — §10.10), pp. 86–89 (CDI Scale + CDI On Screen — §10.1), p. 90 (Airport Runway Criteria — §10.2), p. 91 (Clocks and Timers — §10.3), p. 92 (Page Shortcuts — §10.4), p. 93 (Alerts Settings — §10.5), p. 94 (Unit Selections — §10.6), p. 95 (Display Brightness — §10.7), p. 96 (Scheduled Messages — §10.8), p. 97 (Crossfill — §10.9), pp. 103–106 (GPS Status — §10.11), pp. 107–108 (ADS-B Status — §10.12), p. 109 (Logs — §10.13)

   Read the relevant pages when authoring. The outline already cites specific page numbers — honor those citations in the spec body.

10. **`assets/gnc355_pdf_extracted/extraction_report.md`** — extraction quality notes. Fragment A's Appendix C already documents sparse pages. The §§8–10 page range has no identified sparse pages.

### Tier 3 — Cross-reference context

11. **`docs/knowledge/355_to_375_outline_harvest_map.md`** — harvest categorization for §§8–10:
    - §8: unit-agnostic ([FULL])
    - §9: unit-agnostic ([FULL])
    - §10: [FULL structure; §10.1 CDI On Screen GNX 375 / GPS 175 only; §10.12 ADS-B Status GNX 375 built-in framing; §10.13 Logs GNX 375 ADS-B traffic logging addition]

12. **`docs/knowledge/amapi_by_use_case.md`** — A3 use-case index. Sections relevant to Fragment E: §1 (dataref subscribe — GPS status, ADS-B status), §3 (menu navigation — Nearest access, Waypoint search tabs, Settings navigation), §11 (Persist_add — user waypoints, clocks/timers, unit selections, display brightness, scheduled messages, Bluetooth pairings).

13. **`docs/knowledge/amapi_patterns.md`** — B3 pattern catalog. Outline cites Pattern 11 (persist state across sessions) for §10.3 / §10.6 / §10.7 / §10.8 / §10.10 persistence, and Pattern 2 (multi-variable bus) for §10.11 GPS Status + §10.12 ADS-B Status data buses.

14. **`docs/decisions/D-15-gnx375-display-architecture-internal-vs-external-turn-20-research.md`** — **relevant for §10.1 CDI On Screen.** CDI On Screen = lateral only on GNX 375 / GPS 175. No vertical deviation shown on-screen. Consistent with Fragment A §1 and Fragment D §7.G.

15. **`docs/decisions/D-16-gnx375-xpdr-adsb-scope-corrections-turn-21-research.md`** — **relevant for §10.12 ADS-B Status and §10.13 Logs.** §10.12 built-in ADS-B receiver framing (no external LRU required). §10.13 GNX 375 only for ADS-B traffic data logging (GPS 175 and GNC 355 do not have this capability per D-16).

16. **`docs/decisions/D-21-multi-fragment-sequential-drafting-discipline.md`** — drafting discipline (informational; governs why this prompt is drafted now, not earlier).

17. **`docs/todos/issue_index.md`** — **read ITM-08 in full before authoring.** ITM-08 is the Coupling Summary glossary-ref watchpoint; Fragment D's authoring-phase grep-verify validated the discipline (see `issue_index_resolved.md` ITM-09 entry for Fragment D resolution). Carry forward as Phase F hard constraint.

18. **`docs/tasks/completed/c22_d_prompt.md`** — **most recent structural template.** Use the same section structure, YAML front-matter format, heading-level conventions, Coupling Summary block format, and self-review checklist pattern. Do **not** copy the content — scope and hard constraints are different. Fragment E has 14 hard constraints (similar count to D but different subset) and 22 self-review items (2 fewer than D since no §7.9 novel creation or §7 ordering check).

19. **`CLAUDE.md`** (project conventions, commit format, ntfy requirement)
20. **`claude-conventions.md`** §Git Commit Trailers (D-04)

**Audit level:** standard — CD will check completions and run a compliance verification modeled on the C2.2-D approach (~25-item check across F / S / X / C / N categories). Compliance bar consistent with C2.2-A through C2.2-D.

---

## Pre-flight Verification

**Execute these checks before authoring any fragment content. If any fails, STOP and write `docs/tasks/c22_e_prompt_deviation.md`.**

1. Verify Tier 1 source files exist:
   ```bash
   ls docs/specs/GNX375_Functional_Spec_V1_outline.md
   ls docs/decisions/D-18-c22-format-decision-piecewise-manifest.md
   ls docs/decisions/D-19-fragment-prompt-line-count-expansion-ratio.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md
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

7. Verify Fragment D integrity (913 lines expected):
   ```bash
   wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md
   ```

8. Verify `text_by_page.json` structural integrity on key pages (saved `.py` script per D-08):
   Write a short Python script that reads the JSON and prints char counts for key pages: 53, 55 (Bluetooth), 86, 88, 89 (CDI Scale + On Screen), 90–97 (Settings §§10.2–10.9), 103, 105, 106 (GPS Status), 107, 108 (ADS-B Status), 109 (Logs), 165, 167, 168, 169, 171, 172, 174, 175, 176, 178 (Waypoint Information), 179, 180 (Nearest). All should have non-trivial character counts.

9. Verify no conflicting fragment output exists:
   ```bash
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md 2>/dev/null
   ```
   Expect failure. If the file exists, STOP and note in deviation report.

---

## Phase 0: Source-of-Truth Audit

Before authoring any spec body content:

1. Read all Tier 1 documents in full (outline §§8–10, D-15, D-16, D-18, D-19, Fragment A, Fragment B, Fragment C, Fragment D).
2. Read Fragments A, B, C, **and D in full** — not just the sub-sections directly cited. Fragment D is the newest and establishes forward-ref contracts to §10 (from §7.D and §7.G) that Fragment E must honor.
3. **Read ITM-08 in `docs/todos/issue_index.md` in full.** Carry forward as Phase F hard constraint. (ITM-09 is resolved — see `issue_index_resolved.md` — no action needed in Fragment E.)
4. Read PDF pages listed in outline sub-section `[pp. N]` citations. Particular attention to:
   - pp. 53–56 (Bluetooth / Connext data link — required for §10.10)
   - pp. 86–89 (CDI Scale + CDI On Screen — required for §10.1; cross-ref §4.10 and §7.D/§7.G)
   - pp. 103–106 (GPS Status — EPU, HFOM, VFOM, HDOP, SBAS Providers — required for §10.11)
   - pp. 107–108 (ADS-B Status — built-in receiver, FIS-B WX Status, Traffic Application Status — required for §10.12)
   - p. 109 (Logs — WAAS diagnostic + ADS-B traffic logging — required for §10.13)
   - pp. 167 (Airport Information Page tabs — required for §9.2)
   - pp. 169–171 (FastFind + Search Tabs — required for §9.5; **S13 watchpoint applies** — PDF uses "SEARCH BY CITY" not outline's "Search by Facility Name"; trust PDF)
   - pp. 172–175 (User Waypoint create via Lat/Lon, Radial/Distance, Radial/Radial — required for §9.4)
   - pp. 177–178 (User Waypoint SD card CSV import — required for §9.4)
   - pp. 179–180 (Nearest Functions — required for §§8.1–8.5)
5. Read `docs/knowledge/355_to_375_outline_harvest_map.md` §§ covering §§8–10.

**Definition — Actionable requirement:** A statement in the outline or an authorizing decision that, if not reflected in the fragment, would make the fragment incomplete relative to what C2.2-F and C2.2-G depend on. Includes: operational-workflow contracts that later fragments reference, ITM-08's Coupling Summary grep-verify, framing decisions (no internal VDI for §10.1 CDI On Screen, built-in ADS-B for §10.12, GNX 375 ADS-B traffic logging for §10.13), S13 PDF-over-outline trust, and open-question preservation (§9.4 persistence forward-ref to §14, §10.10 Bluetooth scope caveat).

6. Extract actionable requirements. Particular attention to:

   **§8 Nearest Functions:**
   - §8.1 Nearest Access [p. 179]: Home > Nearest > select function icon
   - §8.2 Nearest Airports [p. 179]: up to 25 airports within 200 nm; columns (identifier, distance, bearing, runway surface, runway length); runway criteria filter applied (from §10.2); tap → Airport Waypoint Information page
   - §8.3 Nearest NDB, VOR, Intersection, VRP [p. 179]: columns (identifier, type, frequency, distance, bearing)
   - §8.4 Nearest ARTCC [p. 180]: columns (facility name, distance, bearing, frequency)
   - §8.5 Nearest FSS [p. 180]: columns (facility name, distance, bearing, frequency); "RX" suffix = receive-only

   **§9 Waypoint Information Pages:**
   - §9.1 Database Waypoint Types [p. 165]: Airport, Intersection, VOR, VRP, NDB
   - §9.2 Airport Information Page [p. 167]: Info / Procedures / Weather (FIS-B on GNX 375 built-in) / Chart (SafeTaxi if available) tabs; cross-ref §4.9 for FIS-B WX Status source
   - §9.3 Intersection/VOR/VRP/NDB Pages [p. 166]: common layout; VOR-specific (frequency, class, elevation, ATIS); NDB-specific (frequency, class)
   - §9.4 User Waypoints [pp. 168, 172–178]:
     - Storage: up to 1,000 user waypoints
     - Identifier format: "USRxxx" default (up to 6 characters, uppercase)
     - Limitations: no duplicate identifiers; active FPL waypoints not editable
     - Create: three reference methods — Lat/Lon, Radial/Distance, Radial/Radial [pp. 172–175]
     - Edit: modify name, location, comment [p. 176]
     - Delete [p. 168]
     - Import: from SD card CSV file [pp. 177–178]
     - **Forward-ref §14 (Fragment G) for persistence schema** — 1,000-waypoint persist encoding is Fragment G scope
   - §9.5 Waypoint Search and FastFind [pp. 169–171]:
     - FastFind Predictive Waypoint Entry: predictive matching by identifier
     - Search Tabs: Airport, Intersection, VOR, NDB, User, plus additional — **S13 watchpoint: PDF uses "SEARCH BY CITY" not outline's "Search by Facility Name"; trust PDF on exact label**
     - User tab lists all stored user waypoints (up to 1,000)

   **§10 Settings / System Pages:**
   - §10.1 CDI Scale [pp. 87–88] + CDI On Screen [p. 89]:
     - CDI Scale options: 0.30, 1.00, 2.00, 5.00 nm
     - HAL (Horizontal Alarm Limit) follows CDI scale per flight phase
     - Manual setting caps upper end (auto-switching still lowers for approach)
     - CDI On Screen (GNX 375 / GPS 175 only; GNC 355 excluded): toggle in Pilot Settings; lateral-only indicator (per D-15; no vertical deviation on-screen per D-15); affects GPS NAV Status key layout
     - Cross-refs §4.10 display (Fragment C) + §7.D auto-switching (Fragment D) + §7.G deviation display (Fragment D)
   - §10.2 Airport Runway Criteria [p. 90]: runway surface filter (Any, Hard Only, Hard or Soft); minimum runway length (ft); include user airports toggle; applies to Nearest Airports (§8.2) and Direct-to Airport searches
   - §10.3 Clocks and Timers [p. 91]: Count Up, Count Down, Flight Timer types; UTC or Local display; persistence across sessions
   - §10.4 Page Shortcuts [p. 92]: Locater bar slots 2–3 customizable (slot 1 = Map, fixed); select pages available from main menu
   - §10.5 Alerts Settings [p. 93]: airspace alerts using 3D data; alert altitude buffer settings; enable/disable by airspace type (Class B, Class C, Class D, TMA, TRSA, MOA, Prohibited, Restricted)
   - §10.6 Unit Selections [p. 94]: distance/speed (NM/KT, MI/MPH, KM/KPH), altitude (FT, M), vertical speed (FPM, MPS), nav angle (Magnetic, True), wind (Vector, Headwind/Crosswind), pressure (inHg, mb/hPa), temperature (°C, °F)
   - §10.7 Display Brightness Control [p. 95]: automatic (photocell + optional dimmer bus input); manual override; bezel/screen separate or unified
   - §10.8 Scheduled Messages [p. 96]: One Time, Periodic, Event-Based; create/modify/delete messages; message types and triggers
   - §10.9 Crossfill [p. 97]: dual Garmin GPS configuration; crossfill data types (flight plans, user waypoints, pilot settings); configured unit authority
   - §10.10 Connectivity — Bluetooth [pp. 53–56]: Connext data link; pair Connext devices (up to 13; tablets running Garmin Pilot); flight plan import; **scope caveat — may be v1 out-of-scope (Connext/Garmin Pilot pairing complexity); preserve as flag**
   - §10.11 GPS Status [pp. 103–106]: satellite reception bar graph; EPU (Estimated Position Uncertainty), HFOM (Horizontal Figure of Merit), VFOM (Vertical Figure of Merit), HDOP (Horizontal Dilution of Precision); SBAS Providers selection (WAAS, EGNOS, MSAS, GAGAN); GPS status annunciations (INTEG, LOI, GPS FAIL)
   - §10.12 ADS-B Status [pp. 107–108] — **GNX 375 framing: built-in receiver**:
     - Built-in dual-link ADS-B In receiver status (no external LRU required on GNX 375)
     - Last uplink time (FIS-B)
     - GPS source (built-in GPS drives ADS-B Out position source)
     - FIS-B WX Status (with cross-ref §4.9 for data types)
     - Traffic Application Status (TSAA on GNX 375)
     - **Must match Fragment C §4.10 framing** (built-in, not external LRU)
   - §10.13 Logs [p. 109] — **GNX 375 ADS-B traffic logging**:
     - WAAS diagnostic data logging (all units)
     - **ADS-B traffic data logging — GNX 375 only** (not available on GPS 175 or GNC 355; per D-16)
     - Export to SD card
     - **Must match Fragment C §4.10 framing**

7. **Open-question preservation checklist:**
   - §9.4 User Waypoints persistence → forward-ref to §14 Persistent State (Fragment G) — 1,000-waypoint persist encoding schema is Fragment G scope, NOT resolved in Fragment E
   - §10.10 Bluetooth scope caveat — may be v1 out-of-scope (Connext/Garmin Pilot pairing complexity); preserve as flag
   - No other outline-flagged open questions for §§8–10

8. If ALL requirements are covered by your planned fragment structure: print "Phase 0: all source requirements covered" and proceed to authoring.
9. If any requirement is uncovered: write `docs/tasks/c22_e_prompt_phase0_deviation.md` and STOP.

---

## Instructions

Produce the fifth fragment of the GNX 375 Functional Spec V1 body: operational workflows covering §§8–10 (Nearest Functions + Waypoint Information Pages + Settings/System Pages). This is the second operational-workflow fragment (Fragment D was the first, covering §§5–7). Fragment E is the smallest remaining fragment and has the cleanest scope: no novel sub-section creation, no procedural-fidelity augmentations, straightforward operational workflows on established §4.5 (Fragment B) / §4.6 (Fragment B) / §4.10 (Fragment C) display pages.

**Primary output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md`

### Authoring strategy

Same as Fragments A/B/C/D: outline provides structural skeleton; task expands outline bullets into implementable prose while preserving structure, page references, and cross-references.

#### Authoring depth guidance

- **Scope paragraphs (per top-level section):** 2–4 sentences per top-level section (§8, §9, §10). State what the section is for, its key GNX 375-specific framing (if any), and operational cross-refs.

- **Sub-section prose:** each outline bullet expands into a short block (5–25 lines typical). Preserve source-page citations inline.

- **Tables:** use tables where content is naturally tabular. Expected tables in Fragment E:
  - §8.2 Nearest Airports columns (or row-per-data-column description)
  - §8.3 Nearest NDB/VOR/Intersection/VRP columns
  - §9.1 Database Waypoint Types (5 types)
  - §9.4 User Waypoint create methods (3 methods: Lat/Lon, Radial/Distance, Radial/Radial — each with required inputs)
  - §9.5 Search Tabs list (PDF-sourced labels; S13 watchpoint)
  - §10.1 CDI Scale options (4 options) + HAL mapping (optional; Fragment D §7.D has the authoritative 4-row table — cross-ref rather than re-tabulate)
  - §10.5 Alerts airspace types (8+ types with enable/disable)
  - §10.6 Unit Selections (7 quantity types with available units)
  - §10.11 GPS Status field definitions (EPU, HFOM, VFOM, HDOP — with units/meaning)
  - §10.12 ADS-B Status fields (uplink time, GPS source, FIS-B status, Traffic Application Status)

- **S13-pattern watchpoint for §9.5 Search Tabs:** Fragment B confirmed outline's "Search by Facility Name" is PDF's "SEARCH BY CITY". Fragment E's §9.5 must use the PDF-accurate label. Trust PDF over outline.

- **AMAPI cross-refs:** at the end of each top-level section (§8, §9, §10), include an "AMAPI notes" block. Cite use-case sections (A3) and patterns (B3), don't expand.

- **Open questions / flags:** preserve every outline flag. See the open-question preservation checklist above. Specifically:
  - §9.4 User Waypoints persistence: forward-ref §14 (Fragment G) for 1,000-waypoint persist schema
  - §10.10 Bluetooth: scope caveat as flag (may be v1 out-of-scope)

- **Cross-references:**
  - Backward-refs to Fragments A/B/C/D use "see §N.x" without fragment qualification (spec body is unified post-assembly)
  - Forward-refs to Fragments F, G use "see §N.x" without further qualification

#### Fragment file conventions (per D-18)

- **Path:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md`
- **YAML front-matter (required):**
  ```yaml
  ---
  Created: 2026-04-23T{HH:MM:SS}-04:00
  Source: docs/tasks/c22_e_prompt.md
  Fragment: E
  Covers: §§8–10 (Nearest Functions, Waypoint Information Pages, Settings/System Pages)
  ---
  ```
- **Heading levels:**
  - `# GNX 375 Functional Spec V1 — Fragment E` — fragment header (stripped on assembly)
  - `## 8. Nearest Functions` — top-level section headers use `##`
  - `## 9. Waypoint Information Pages`
  - `## 10. Settings / System Pages`
  - `### 8.1 Nearest Access [p. 179]` — sub-sections use `###`
  - `### 9.4 User Waypoints [pp. 168, 172–178]`
  - `### 10.1 CDI Scale [pp. 87–88] + CDI On Screen [p. 89]`
  - Do NOT include harvest-category markers (`— [FULL]`, `— [PART]`) in spec-body headings.
- **Line count target:** ~455 lines per D-19. Under-delivery (<415) suggests under-coverage; over-delivery (>600) warrants completion-report classification. Soft ceiling ~550 (series baseline ~20% overage).

#### Specific framing commitments

These are **hard constraints** that must appear in the fragment:

1. **ITM-08 Coupling Summary glossary-ref grep-verify — Phase F hard constraint.** Before finalizing the Coupling Summary, `grep` each Appendix B glossary term claimed as a backward-ref against `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`. Remove any terms not present in Appendix B from the Coupling Summary backward-refs list. **Specifically: do not claim EPU, HFOM/VFOM, HDOP, TSO-C151c as Appendix B entries** — these are §10.11 GPS Status field labels used inline in Fragment E body, but they are NOT formal Appendix B glossary entries (per C2.2-C compliance X17 finding and C2.2-D F11 validation). Discipline validated at Fragment D; maintain.

2. **Coupling Summary ~60-line budget.** Corrected from C2.2-C miscalibration; maintained through D. Fragment E's Coupling Summary should follow the same budget.

3. **§10 operational workflows act on Fragment C §4.10 display pages. No §4 re-authoring.** §4.10 (Fragment C) authored the CDI Scale, CDI On Screen, ADS-B Status, Logs display elements; §10 authors the operational workflows. No re-enumeration of page layouts, menu structures, or display fields that Fragment C already covered.

4. **§10.1 CDI Scale + CDI On Screen cross-refs §4.10 and §7.D/§7.G.** §10.1's operational workflow (selecting scale, toggling On Screen) cross-refs §4.10 for the settings-page display, §7.D for flight-phase auto-switching behavior, and §7.G for on-screen CDI deviation display. **CDI On Screen = GNX 375 / GPS 175 only, lateral only (per D-15 and Fragment D §7.G).**

5. **§10.12 ADS-B Status built-in framing must match Fragment C §4.10.** §10.12 operational workflow must consistently frame the ADS-B receiver as GNX 375 built-in (no external LRU required). No prose in Fragment E may imply GNX 375 requires an external GDL 88/GDL 82/similar for ADS-B In.

6. **§10.13 Logs GNX 375 ADS-B traffic logging must match Fragment C §4.10.** §10.13 must state ADS-B traffic data logging is GNX 375 only (not available on GPS 175 or GNC 355; per D-16). WAAS diagnostic logging is common to all units.

7. **§9 Waypoint Information operational workflows act on Fragment B §4.5 display pages. No §4 re-authoring.** §4.5 (Fragment B) authored the Waypoint Information display pages; §9 authors the operational workflows (creating user waypoints, searching, FastFind).

8. **§8 Nearest Functions operational workflows act on Fragment B §4.6 display pages. No §4 re-authoring.** §4.6 (Fragment B) authored the Nearest display pages; §8 authors the operational workflows (selecting Nearest function, filtering, tap-to-info).

9. **No COM present-tense on GNX 375.** Carry-forward from Fragments A/B/C/D. Low risk in §§8–10 since none of the sub-sections are COM-related, but verify on self-check. Any COM content (e.g., Nearest FSS frequency column) must be factual reference to the frequency data, not imply the GNX 375 has a COM radio that can tune/monitor that frequency.

10. **S13 trust-PDF-over-outline watchpoint.** Validated three times (Fragment B Search-by-City, Fragment C LNAV/VNAV + MAPR, Fragment D §5.3 Waypoint Options). For Fragment E, particular attention in:
    - **§9.5 Search Tabs labels** — PDF uses "SEARCH BY CITY" not outline's "Search by Facility Name"; use PDF label
    - **§10.11 GPS Status field labels** (EPU, HFOM, VFOM, HDOP) — verify exact label-set against PDF pp. 103–106; trust PDF
    - Any other sub-section where outline and PDF may disagree — trust PDF

11. **No §§1–4 headers re-authored; no §§11–15 or Appendix headers authored.** Backward-refs to §§1–4 appear only as prose cross-refs; forward-refs to §§11–15 appear only as prose cross-refs. No `## 11.` or `### 11.x` headers anywhere in Fragment E.

12. **§9.4 User Waypoints persistence forward-ref to §14.** Fragment E §9.4 must forward-ref §14 Persistent State (Fragment G) for the 1,000-waypoint persist encoding schema. Do NOT specify the persistence schema in Fragment E. Fragment G owns the encoding contract.

13. **§10.10 Bluetooth scope caveat preserved.** Fragment E §10.10 must include a scope flag that Bluetooth / Connext / Garmin Pilot pairing may be v1 out-of-scope. Preserve as flag; do not resolve the scope question in Fragment E.

14. **§9.2 Weather tab + §10.12 ADS-B Status FIS-B reception behavior cross-ref Fragment C §4.9.** Fragment C §4.9 authored the FIS-B + Traffic + TSAA framing. Fragment E §9.2 Weather tab and §10.12 FIS-B WX Status both cross-ref §4.9 for data types, refresh behavior, and TSAA framing. OPEN QUESTION 6 (TSAA aural delivery) was preserved verbatim in Fragment C §4.9 — **Fragment E does NOT re-preserve the verbatim question**; §9.2 and §10.12 cross-ref §4.9 for the open question context.

#### Per-section page budget (informative)

| Section | Outline estimate | Fragment prose target |
|---------|------------------|------------------------|
| Fragment header + YAML | — | ~10 |
| §8 Nearest Functions (5 sub-sections) | ~60 | ~70 |
| §9 Waypoint Information Pages (5 sub-sections) | ~120 | ~150 |
| §10 Settings/System Pages (13 sub-sections) | ~200 | ~240 |
| Coupling Summary block | — | **~60** |
| **Total target** | **~380** | **~530** |

The 530 total slightly exceeds the 455 D-19 target; this is expected at series baseline ~20% overage. Acceptable band ~415–600; soft ceiling ~550. If actual output trends significantly above 600, classify in completion report. CC may proactively trim to approach 455 more closely but is not required to.

#### Coupling Summary block

At the end of the fragment (after §10 content ends), include a **Coupling Summary** section per D-18:

```markdown
---

## Coupling Summary

This section is authored per D-18 for CD/CC coordination across the 7-fragment spec. It is not part of the spec body and is stripped on assembly.

### Backward cross-references (sections this fragment references authored in prior fragments)

- Fragment A §1 (Overview): GNX 375 baseline framing, no-internal-VDI constraint (D-15) — referenced in §10.1 CDI On Screen (lateral only, no vertical).
- Fragment A §2 (Physical Layout & Controls): Home key and menu navigation pattern — referenced in §8.1 Nearest Access, §10 Settings access.
- Fragment A §3 (Power-On / Startup / Database): Connext data link framing — referenced in §10.10 Bluetooth; GPS acquisition — referenced in §10.11 GPS Status.
- Fragment A Appendix B (Glossary): **only claim terms actually present as formal glossary entries.** Verified via grep before writing this Coupling Summary. Expected terms that ARE present: SBAS, WAAS, CDI, VDI, GPSS, FIS-B, UAT, 1090 ES, Extended Squitter, TSAA, Connext, TSO-C166b, RAIM. Do NOT claim: EPU, HFOM/VFOM, HDOP, TSO-C151c (absent from Appendix B per C2.2-C X17; these are §10.11 GPS Status field labels used inline, NOT formal glossary entries). Do NOT claim: Bluetooth, MAC Address, any §10-specific UI labels (unless explicitly present in Appendix B).
- Fragment B §4.3 (FPL Page): GPS NAV Status indicator key — §10.1 CDI On Screen toggles affect key layout; cross-ref.
- Fragment B §4.5 (Waypoint Information Display Pages): §9.1–9.5 operational workflows act on these displays.
- Fragment B §4.6 (Nearest Display Pages): §8.1–8.5 operational workflows act on these displays.
- Fragment C §4.9 (Hazard Awareness — FIS-B + Traffic + TSAA): §9.2 Airport Information Weather tab + §10.12 ADS-B Status FIS-B WX Status + Traffic Application Status cross-ref; OPEN QUESTION 6 (TSAA aural delivery) cross-ref context only.
- Fragment C §4.10 (Settings/System Display Pages): §10.1–10.13 operational workflows act on these displays; §10.1 CDI Scale + CDI On Screen; §10.12 ADS-B Status built-in framing; §10.13 Logs GNX 375 traffic logging.
- Fragment D §7.D (CDI Scale auto-switching): §10.1 CDI Scale operational workflow cross-refs §7.D for flight-phase auto-switching and manual-cap behavior.
- Fragment D §7.G (CDI deviation display): §10.1 CDI On Screen operational workflow cross-refs §7.G for lateral-only framing and D-15 consistency.

### Forward cross-references (sections this fragment writes that later fragments will reference)

- §9.4 User Waypoints → §14 Persistent State (Fragment G): 1,000-waypoint persist encoding schema.
- §10.3 Clocks and Timers → §14 Persistent State (Fragment G): timer state persistence.
- §10.6 Unit Selections → §14 Persistent State (Fragment G): unit-preference persistence.
- §10.7 Display Brightness → §14 Persistent State (Fragment G): brightness override persistence.
- §10.8 Scheduled Messages → §14 Persistent State (Fragment G): message list persistence.
- §10.10 Bluetooth → §14 Persistent State (Fragment G): paired-device list persistence.
- §10.1 CDI Scale → §15 External I/O (Fragment G) §15.6: external CDI/HSI output contract.
- §10.11 GPS Status → §15 External I/O (Fragment G): GPS status datarefs.
- §10.12 ADS-B Status → §15 External I/O (Fragment G): ADS-B status datarefs; §11 Transponder + ADS-B (Fragment F) for built-in receiver detail and §11.11 ADS-B In.
- §10.5 Alerts Settings → §12 Alerts (Fragment F): alert-type hierarchy and aural delivery.
- §10.8 Scheduled Messages → §13 Messages (Fragment F): message queue display and dismiss behavior.
- §10.12 FIS-B WX Status → §11.11 ADS-B In receiver status (Fragment F).

### Outline coupling footprint

This fragment draws from outline §§8–10 only. No content from §§1–7 (Fragments A + B + C + D), §§11–15, or Appendices A/B/C is authored here.
```

---

## Integration Context

- **Primary output file:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` (new)
- **Directory already exists:** `docs/specs/fragments/` contains part_A, part_B, part_C, part_D.
- **No code modification in this task.** Docs-only.
- **No test suite run required.** Docs-only.
- **Do not modify the outline.** If you spot outline errors during authoring (PDF-vs-outline discrepancies, S13-pattern opportunities), note them in the completion report's Deviations section and continue with the PDF-accurate content.
- **Do not modify Fragment A, Fragment B, Fragment C, or Fragment D.** All are archival.
- **Do not modify the manifest yet.** CD will update the manifest status entry for Fragment E after this task archives.

---

## Implementation Order

**Execute phases sequentially. Do not parallelize phases or launch subagents.**

### Phase A: Read and audit (Phase 0 per above)

Read all Tier 1 and Tier 2 sources. Read Fragments A, B, C, D in full. **Read ITM-08 in full.** Extract actionable requirements. Confirm coverage of the open-question preservation checklist. Print the Phase 0 completion line OR write the Phase 0 deviation report and STOP.

### Phase B: Create fragment file skeleton

1. Create the fragment file at `docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` with YAML front-matter, fragment header (`# GNX 375 Functional Spec V1 — Fragment E`), and section headers (`## 8.`, `## 9.`, `## 10.`).
2. Add sub-section headers for §8 (8.1–8.5), §9 (9.1–9.5), §10 (10.1–10.13).
3. Add the Coupling Summary placeholder at the end.

### Phase C: Author §8 Nearest Functions (~70 lines)

Scope paragraph noting unit-agnostic (identical across GPS 175 / GNC 355 / GNX 375); operational workflows act on §4.6 display pages (Fragment B). Expand §§8.1–8.5 per Phase 0 actionable-requirements enumeration. Include tabular column descriptions for §8.2 and §8.3 where natural. Note runway criteria filter inheritance from §10.2. AMAPI notes block.

### Phase D: Author §9 Waypoint Information Pages (~150 lines)

Scope paragraph noting unit-agnostic; operational workflows act on §4.5 display pages (Fragment B). Expand §§9.1–9.5 per Phase 0 enumeration:
- §9.1 Database Waypoint Types (5-type table or list)
- §9.2 Airport Information Page (4 tabs — Info, Procedures, Weather with FIS-B cross-ref §4.9, Chart with SafeTaxi availability)
- §9.3 Intersection/VOR/VRP/NDB Pages (common layout + VOR/NDB-specific fields)
- §9.4 User Waypoints (storage limit, identifier format, limitations, create 3 methods table, edit, delete, SD card CSV import; **forward-ref §14 for persistence schema**)
- §9.5 Waypoint Search and FastFind (FastFind predictive entry, Search Tabs with **S13 PDF-accurate labels** including "SEARCH BY CITY" per Fragment B confirmation, User tab)

AMAPI notes block. Open question preservation (§9.4 persistence forward-ref).

### Phase E: Author §10 Settings / System Pages (~240 lines)

Scope paragraph noting §10 operational workflows act on §4.10 display pages (Fragment C); §10.1 CDI On Screen GNX 375 / GPS 175 only per D-15; §10.12 ADS-B Status built-in framing per D-16; §10.13 GNX 375 ADS-B traffic logging per D-16. Expand §§10.1–10.13 per Phase 0 enumeration:
- §10.1 CDI Scale (4 options) + CDI On Screen (toggle; lateral only; GNX 375 / GPS 175 only); cross-refs §4.10 + §7.D + §7.G
- §10.2 Airport Runway Criteria (surface filter, length minimum, user airports toggle); referenced by §8.2 and Direct-to
- §10.3 Clocks and Timers (types, UTC/Local); §14 persistence forward-ref
- §10.4 Page Shortcuts (locater bar slots 2–3)
- §10.5 Alerts Settings (airspace-type table with 3D data); §12 cross-ref forward
- §10.6 Unit Selections (7 quantity-type table); §14 persistence forward-ref
- §10.7 Display Brightness Control (automatic + manual); §14 persistence forward-ref
- §10.8 Scheduled Messages (3 types: One Time, Periodic, Event-Based); §13 cross-ref forward
- §10.9 Crossfill (data types: FPL, user waypoints, pilot settings; configuration)
- §10.10 Connectivity — Bluetooth (up to 13 Connext devices, FPL import); **scope caveat flag**
- §10.11 GPS Status (satellite graph; EPU, HFOM, VFOM, HDOP field definitions; SBAS Providers; status annunciations)
- §10.12 ADS-B Status (built-in receiver framing; uplink time, GPS source, FIS-B WX Status with §4.9 cross-ref, Traffic Application Status / TSAA)
- §10.13 Logs (WAAS diagnostic common; **ADS-B traffic logging GNX 375 only**; SD card export)

AMAPI notes block. Open question preservation (§10.10 Bluetooth scope caveat).

### Phase F: Author Coupling Summary (~60 lines)

Write the Coupling Summary block per the template above. **Execute ITM-08 grep-verify before writing:**
1. Open Fragment A (`docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`)
2. Locate Appendix B glossary
3. For each term you plan to claim as an Appendix B backward-ref, `grep` the Appendix B section and confirm the term exists as a formal glossary entry
4. Remove any terms that do NOT appear as formal Appendix B entries from the backward-refs list
5. Document in the completion report which terms were verified-present and which were removed (if any) due to absence

Specifically exclude from the Fragment A Appendix B backward-refs list: EPU, HFOM/VFOM, HDOP, TSO-C151c (these are NOT formal glossary entries per C2.2-C compliance finding X17 and C2.2-D F11 validation). These labels appear inline in Fragment E §10.11 body but must NOT be claimed as Appendix B backward-refs.

### Phase G: Self-review

Before writing the completion report, perform the following self-checks (per D-08 — completion report claim verification):

1. **Line count:** `wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — target ~455, soft ceiling ~550; acceptable band ~415–600.
2. **Character encoding:** `grep -c '\\u[0-9a-f]\{4\}' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect 0.
3. **Replacement chars:** Python check (saved `.py` file per D-08) to count U+FFFD bytes — expect 0.
4. **No §4 headers re-authored:** `grep -nE '^## 4\.|^### 4\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect **0 matches**.
5. **No §§11–15 or Appendix headers authored:** `grep -nE '^## 1[1-5]\.|^### (11|12|13|14|15)\.|^## Appendix' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect **0 matches**.
6. **No §§1–3 headers re-authored:** `grep -nE '^## [1-3]\.|^### (1|2|3)\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect **0 matches**.
7. **No §§5–7 headers re-authored:** `grep -nE '^## [5-7]\.|^### (5|6|7)\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect **0 matches**.
8. **§8 has 5 sub-sections:** `grep -cE '^### 8\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect **5**.
9. **§9 has 5 sub-sections:** `grep -cE '^### 9\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect **5**.
10. **§10 has 13 sub-sections:** `grep -cE '^### 10\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect **13**.
11. **§10.1 CDI On Screen framing:** grep-inspect §10.1 for "GNX 375 / GPS 175" (or equivalent), "lateral only", and D-15 consistency. No prose may imply vertical deviation on-screen.
12. **§10.12 ADS-B Status built-in framing:** grep-inspect §10.12 for "built-in" receiver framing. No prose may imply external LRU required. Consistent with Fragment C §4.10.
13. **§10.13 Logs GNX 375 traffic logging:** grep-inspect §10.13 for "GNX 375 only" (or equivalent) on ADS-B traffic logging. Consistent with Fragment C §4.10 and D-16.
14. **§9.4 User Waypoints persistence forward-ref:** grep-inspect §9.4 for "§14" (forward-ref to Fragment G). Persistence schema NOT specified in §9.4.
15. **§9.5 Search Tabs PDF-accurate labels:** grep-inspect §9.5 for "SEARCH BY CITY" (or PDF-exact label). Outline's "Search by Facility Name" should NOT appear unless flagged as S13-corrected.
16. **§10.10 Bluetooth scope caveat:** grep-inspect §10.10 for scope caveat prose (e.g., "may be v1 out-of-scope", "scope caveat", "deferred"). Flag preserved.
17. **Page citation preservation:** sample 8 outline page citations and confirm each appears in the fragment at the corresponding sub-section:
    - `[p. 179]` at §8.1 / §8.2 / §8.3
    - `[p. 180]` at §8.4 / §8.5
    - `[p. 167]` at §9.2
    - `[pp. 169–171]` at §9.5
    - `[pp. 172–175]` at §9.4 create methods
    - `[pp. 87–88]` at §10.1 CDI Scale
    - `[pp. 107–108]` at §10.12 ADS-B Status
    - `[p. 109]` at §10.13 Logs
18. **YAML front-matter correct; fragment header "Fragment E":** grep-inspect line 1 (`---`) through first `---` closing line; confirm `Fragment: E` and `Covers: §§8–10`. Fragment header `# GNX 375 Functional Spec V1 — Fragment E` present on line immediately after YAML.
19. **No harvest-category markers in `###` lines:** `grep -nE '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect **0 matches**.
20. **Coupling Summary section present:** grep for `## Coupling Summary`; confirm backward-refs (A/B/C/D) + forward-refs (F/G) + outline footprint note all present.
21. **ITM-08 grep-verify executed:** Appendix B backward-ref terms verified-present in Fragment A via grep before writing Coupling Summary. EPU, HFOM/VFOM, HDOP, TSO-C151c NOT claimed as Appendix B entries. List of verified-present terms documented in completion report.
22. **No COM present-tense on GNX 375:** `grep -ni 'COM radio\|COM standby\|COM volume\|COM frequency\|COM monitoring\|VHF COM' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — all matches must be in factual frequency-data reference context (e.g., §8.4/§8.5 ARTCC/FSS frequency columns) or in sibling-unit comparison context. No prose may imply GNX 375 has a COM radio.

Report all 22 check results in the completion report.

---

## Completion Protocol

1. Write completion report to `docs/tasks/c22_e_completion.md` with this structure:

   ```markdown
   ---
   Created: {ISO 8601 timestamp}
   Source: docs/tasks/c22_e_prompt.md
   ---

   # C2.2-E Completion Report — GNX 375 Functional Spec V1 Fragment E

   **Task ID:** GNX375-SPEC-C22-E
   **Output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md`
   **Completed:** 2026-04-23

   ## Pre-flight Verification Results
   {table of the 9 pre-flight checks with PASS/FAIL}

   ## Phase 0 Audit Results
   {summary of actionable requirements confirmed covered; include open-question preservation checklist: §9.4 persistence forward-ref, §10.10 Bluetooth scope caveat}

   ## Fragment Summary Metrics
   | Metric | Value |
   |--------|-------|
   | Fragment file | `docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` |
   | Line count | {actual} |
   | Target line count | ~455 |
   | Soft ceiling | ~550 |
   | Acceptable band | ~415–600 |
   | Sections covered | §§8–10 |
   | §8 sub-section count | 5 (8.1–8.5) |
   | §9 sub-section count | 5 (9.1–9.5) |
   | §10 sub-section count | 13 (10.1–10.13) |

   ## Self-Review Results (Phase G)
   {table of the 22 self-checks with PASS/FAIL and specifics}

   ## Hard-Constraint Verification
   {confirm each of the 14 framing commitments}

   ## ITM-08 Coupling Summary Grep-Verify Report
   {list of Appendix B terms you PLANNED to claim as backward-refs; list of terms CONFIRMED-PRESENT via grep; list of terms REMOVED from the Coupling Summary because grep returned 0 matches in Fragment A Appendix B}

   ## S13-Pattern Instances (if any)
   {report any §9.5 Search Tabs or §10.11 GPS Status field label corrections made during authoring; confirm PDF-accurate labels used}

   ## Coupling Summary Preview
   {brief summary of backward-refs to Fragments A/B/C/D and forward-refs to Fragments F/G}

   ## Deviations from Prompt
   {table of any deviations with rationale; if none, state "None"}
   ```

2. `git add -A`

3. `git commit` with the D-04 trailer format. Write the commit message to a temp file via `[System.IO.File]::WriteAllText()` (BOM-free):

   ```
   GNX375-SPEC-C22-E: author fragment E (§§8–10 operational workflows)

   Fifth of 7 piecewise fragments per D-18. Covers Nearest Functions
   (§8), Waypoint Information Pages (§9), and Settings/System Pages
   (§10) operational workflows acting on Fragment B §4.5/§4.6 and
   Fragment C §4.10 display pages. Target: ~455 lines; actual: {N}.

   Honors ITM-08 discipline: Coupling Summary Appendix B backward-refs
   grep-verified against Fragment A before finalization. EPU,
   HFOM/VFOM, HDOP, TSO-C151c NOT claimed (absent from Appendix B).

   Framing commitments honored: §10.1 CDI On Screen lateral-only per
   D-15 (GNX 375 / GPS 175 only); §10.12 ADS-B Status built-in
   receiver framing per D-16 (no external LRU required); §10.13 Logs
   GNX 375-only ADS-B traffic logging per D-16; §9 and §8 act on §4.5
   and §4.6 without re-authoring §4; §10 acts on §4.10 without
   re-authoring §4. S13-pattern PDF-over-outline: §9.5 Search Tabs
   label "SEARCH BY CITY" per PDF (not outline's "Search by Facility
   Name"). Open questions preserved: §9.4 User Waypoints persistence
   forward-ref to §14 (Fragment G); §10.10 Bluetooth scope caveat.

   Task-Id: GNX375-SPEC-C22-E
   Authored-By-Instance: cc
   Refs: D-15, D-16, D-18, D-19, D-20, D-21, ITM-08, GNX375-SPEC-C22-A, GNX375-SPEC-C22-B, GNX375-SPEC-C22-C, GNX375-SPEC-C22-D
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
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-E completed [flight-sim]"
   ```

6. **Do NOT git push.** Steve pushes manually.

---

## What CD will do with this report

After CC completes:

1. CD runs check-completions Phase 1: reads the prompt + completion report, cross-references claims against the fragment file, generates a compliance prompt modeled on the C2.2-D approach (~25-item check across F / S / X / C / N categories). The compliance prompt will verify the 22 self-checks plus ITM-08 grep-verify independent re-check plus PDF source-fidelity spot checks for new tables (§9.4 create methods, §10.5 airspace types, §10.6 unit selections, §10.11 GPS Status fields, §10.12 ADS-B Status fields).

2. After CC runs the compliance prompt: CD runs check-compliance Phase 2. PASS → archive all four files to `docs/tasks/completed/`; update manifest (Fragment E → ✅ Archived); **begin drafting C2.2-F per D-21** (gated on C2.2-E archive). PASS WITH NOTES → log any new ITMs if needed, archive, continue. FAIL → bug-fix task.

---

## Estimated duration

- CC wall-clock: ~10–15 min (LLM-calibrated per D-20: ~455-line docs-only fragment with heavy reuse of Fragments A/B/C/D conventions; baseline 500-line docs task = 10–20 min; scale 0.9× for line count; reuse ×0.7 discount applies strongly since no novel structure; ITM-08 grep-verify adds ~2 min; net ~10–15 min).
- CD coordination cost after this: ~1 check-completions turn + ~1 check-compliance turn + ~0.5 turn to update manifest + start C2.2-F prompt.

Proceed when ready.
