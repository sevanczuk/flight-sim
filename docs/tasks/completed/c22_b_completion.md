---
Created: 2026-04-22T15:45:00-04:00
Source: docs/tasks/c22_b_prompt.md
---

# C2.2-B Completion Report — GNX 375 Functional Spec V1 Fragment B

**Task ID:** GNX375-SPEC-C22-B
**Output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`
**Completed:** 2026-04-22

---

## Pre-flight Verification Results

| Check | Expected | Actual | Result |
|-------|---------|--------|--------|
| 1. Tier 1 files exist (5 files) | All present | All present | PASS |
| 2. Tier 2 files exist (3 files) | All present | All present | PASS |
| 3. Outline line count | 1,477 lines | 1,477 lines | PASS |
| 4. Fragment A line count | 545 ± 5 | 545 | PASS |
| 5. text_by_page.json structure (key pages non-trivial char counts) | 310 pages; p113=813, p140=478, p158=789, p165=1001, p179=989 | Matched | PASS |
| 6. Fragment B does not exist yet | File absent | Absent | PASS |

---

## Phase 0 Audit Results

All Tier 1, Tier 2, and Tier 3 source documents were read before authoring. Actionable
requirements extracted and confirmed covered:

**§4.1 Home Page:**
- XPDR app icon present and framed as GNX 375-only (not GPS 175, not GNC 355/355A) ✓
- Complete app icon inventory (12 icons) documented in table with target section and unit
  presence columns ✓
- Locater bar Slot 1 = Map (fixed), Slots 2-3 user-configurable ✓
- Outer knob page navigation, Back key, Power/Home key all backward-referenced to Fragment A ✓

**§4.2 Map Page:**
- Default user fields per-unit table authored: GNX 375 / GPS 175 defaults differ from GNC
  355/355A ✓
- Field options table (~25 options) present ✓
- Map orientation modes table: North Up, Track Up, Heading Up, North Up Above ✓
- TOPO, Range ring, Track vector, Ahead View described ✓
- Map detail levels documented (full/high/medium/low) ✓
- Aviation data symbols table: all symbol types from p. 124 ✓
- Land data symbols referencing supplement `assets/gnc355_reference/land-data-symbols.png` ✓
- Map interactions: zoom, pan, object selection, stacked objects, graphical FPL editing ✓
- Map overlays table: TOPO, Terrain, Traffic, NEXRAD, Lightning, METAR, TFRs, Airspaces,
  Airways, Obstacles and Wires, SafeTaxi ✓
- Overlay status icons (Data Not Available, Stale Data) documented ✓
- Smart Airspace altitude threshold documented inline ✓
- SafeTaxi hot spots documented ✓
- B4 Gap 1 PRESERVED as unresolved open question ✓

**§4.3 FPL Page:**
- Waypoint list layout, coloring (magenta/white/gray) ✓
- Airport Info shortcut, Active leg status indications ✓
- Data columns (3 columns, 6 options, defaults DTK/DIS/CUM) ✓
- Collapse All Airways, OBS mode, Dead Reckoning, Parallel Track ✓
- Flight Plan Catalog (Activate, Invert & Activate, Preview, Edit, Copy, Delete) ✓
- GPS NAV Status indicator key: 3 states table; GNX 375 / GPS 175 only, NOT GNC 355 ✓
- User Airport Symbol, Fly-over Waypoint Symbol ✓
- Flight Plan User Field OMITTED noted explicitly ✓
- B4 Gap 2 PRESERVED as unresolved open question ✓
- OPEN QUESTION 1 (altitude constraints) PRESERVED ✓

**§4.4 Direct-to Page:**
- Search tabs (Waypoint, FPL, NRST APT) ✓
- Direct-to activation, navigation modes (new, flight plan, off-route) ✓
- Remove direct-to, User holds (all parameters) ✓
- No open questions (content well-extracted) ✓

**§4.5 Waypoint Info Pages:**
- Waypoint types table (Airport, INT, VOR, VRP, NDB, User) ✓
- Common page layout for non-airport types ✓
- Airport tabs (Info, Procedures, Runways, Frequencies, WX Data, NOTAMs, VRPs, Chart) ✓
- Airport Weather tab: FIS-B built-in framing for GNX 375; contrast with GPS 175 (no built-in) ✓
- VOR and NDB page specific fields ✓
- User Waypoint page (Edit, View List, Delete, Delete All; 1,000 limit) ✓
- FastFind documented, including Garmin-specific term note ✓
- Search tabs (Recent, Nearest, Flight Plan, User, Search by Name, Search by City) ✓
- Airport Weather tab degraded-state open question PRESERVED ✓

**§4.6 Nearest Pages:**
- All nearest types: Airports (25), INT (25), VOR (25), VRP (25), NDB (25), User (25),
  Airspace (20), ARTCC (5), FSS (5), Weather FREQ (25) ✓
- Entry limits table ✓
- Update intervals (30s, except airspace = 1s) ✓
- Runway criteria filter noted with forward-ref to §10 ✓
- No open questions ✓

**Open-question preservation checklist:**
- §4.1 Home page icon layout (image-based; requires screen captures): PRESERVED ✓
- §4.2 B4 Gap 1 (Map rendering architecture — Map_add API vs. canvas vs. video streaming): PRESERVED as "major design decision deferred to design phase" ✓
- §4.2 NEXRAD/Traffic overlay behavior when ADS-B In unavailable: PRESERVED ✓
- §4.3 B4 Gap 2 (scrollable list implementation mechanism): PRESERVED ✓
- §4.3 OPEN QUESTION 1 (altitude constraints on FPL legs, VCALC not automatic): PRESERVED ✓
- §4.5 Airport Weather tab behavior with no FIS-B uplink: PRESERVED ✓
- §4.4: No open questions ✓
- §4.6: No open questions ✓

Phase 0 conclusion: **All source requirements covered.** Proceeding to authoring.

---

## Fragment Summary Metrics

| Metric | Value |
|--------|-------|
| Fragment file | `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` |
| Line count | 798 |
| Target line count | ~720 (acceptable range 650–800) |
| Sections covered | §4 parent scope + §§4.1–4.6 |
| Sub-section count | 6 (4.1, 4.2, 4.3, 4.4, 4.5, 4.6) |
| Tables authored | 10 required + 2 supplemental |

**Line count classification:** 798 is within the 650–800 acceptable range per D-19 (±10%).
Initial draft was 917 lines; targeted trimming of non-required tables (Data Drawing Priority,
Map Detail level, Smart Airspace criteria, Active Leg Status, User Holds, Parallel Track,
Nearest per-type breakout) reduced the file to the acceptable range. All required tables
(User Field Options, Aviation Data Symbols, Default Map User Fields, Map Orientation Modes,
FPL Data Column Options, GPS NAV Status States, Waypoint Types, Airport Tabs, Search Tabs,
App Icon Inventory, Nearest Entry Limits) are retained.

---

## Self-Review Results (Phase K)

| # | Check | Result | Detail |
|---|-------|--------|--------|
| 1 | Line count | PASS | 798 lines (target ~720, acceptable 650–800) |
| 2 | Character encoding (unicode escapes) | PASS | 0 matches |
| 3 | Replacement chars (U+FFFD) | PASS | 0 bytes |
| 4 | B4 Gap 1 preserved as unresolved | PASS | Lines 334, 341, 347: flagged as "major design decision deferred to design phase"; no rendering tech committed |
| 5 | B4 Gap 2 preserved as unresolved | PASS | Lines 504, 511–515: flagged as design-phase decision; no scrollable list implementation committed |
| 6 | OPEN QUESTION 1 preserved | PASS | Lines 517–521: VCALC noted as separate tool; behavior unknown flagged for design phase |
| 7 | XPDR icon GNX 375-only framing | PASS | Lines 59, 63–64: table shows GNX 375-only column; "GNX 375-only" stated; §11 forward-ref; no XPDR internals in §4.1 |
| 8 | GPS NAV Status indicator key framing | PASS | Line 470: heading states "GNX 375 / GPS 175 only — NOT GNC 355"; line 560 confirms for direct-to context |
| 9 | Flight Plan User Field omission | PASS | Lines 498–501: explicit "NOT present on GNX 375" statement; no behavior documented |
| 10 | FIS-B built-in receiver framing | PASS | Lines 605–652: built-in dual-link receiver stated; GPS 175 and GNC 355/355A contrast noted |
| 11 | No COM present-tense on GNX 375 | PASS | Lines 24–25: §4.11 COM Standby Control Panel noted as GNC 355/355A only and omitted; no COM app icon in §4.1 table; GNC 355 inner-knob standby tuning mentioned as absent on GNX 375 (contextually correct) |
| 12 | Default Map user fields per-unit table | PASS | Lines 103–118: table with GNX 375 / GPS 175 / GNC 355/355A rows; distinction noted in §4.2 prose |
| 13 | Land-data-symbols supplement reference | PASS | Line 252: `assets/gnc355_reference/land-data-symbols.png` cited |
| 14 | Outline page references preserved | PASS | §4.2 [pp. 113–139], §4.2 Land Data [p. 125], §4.3 GPS NAV Status [p. 158], §4.4 [pp. 159–164], §4.6 [pp. 179–180] all present |
| 15 | YAML front-matter + fragment header + heading levels | PASS | Created/Source/Fragment/Covers in front-matter; `# GNX 375 Functional Spec V1 — Fragment B`; `## 4. Display Pages`; sub-sections use `###`; no harvest-category markers |
| 16 | Coupling Summary present with backward/forward refs | PASS | Coupling Summary at line 747; backward-refs cover Fragment A §§1, 2, 2.1, 2.3, 2.4, 2.5–2.7, Appendix B, §3; forward-refs cover §§5–11, §§14, Fragment C–G targets |
| 17 | §4 parent scope authored exactly once | PASS | `grep -c "^## 4\. Display Pages"` = 1 |

---

## Hard-Constraint Verification

| # | Framing Commitment | Status |
|---|-------------------|--------|
| 1 | B4 Gap 1 (Map rendering architecture) NOT resolved in spec body | PASS — flagged as deferred design decision; no rendering tech committed |
| 2 | B4 Gap 2 (scrollable list) NOT resolved in spec body | PASS — flagged as design-phase decision; no mechanism committed |
| 3 | OPEN QUESTION 1 (altitude constraints) PRESERVED | PASS — VCALC noted as separate tool; unknown behavior flagged |
| 4 | §4.1 XPDR app icon framed as GNX 375-only | PASS — table and prose confirm; §11 forward-ref for internals |
| 5 | GPS NAV Status indicator key: GNX 375 / GPS 175 only, NOT GNC 355 | PASS — heading and prose explicit |
| 6 | Flight Plan User Field OMITTED on GNX 375 | PASS — explicit "NOT present" statement; behavior not documented |
| 7 | §4.5 Airport Weather FIS-B: built-in on GNX 375, contrast with GPS 175 | PASS — built-in framing with GPS 175 and GNC 355/355A contrast |
| 8 | No COM radio content as present GNX 375 feature | PASS — §4.11 COM Standby noted as omitted; no COM app icon; inner-knob COM function noted as absent on GNX 375 |
| 9 | Default Map user fields per-unit distinction documented | PASS — table in §4.2 with GNX 375/GPS 175 vs. GNC 355/355A rows |
| 10 | Land data symbols supplement referenced | PASS — supplement path cited in §4.2 Land Data Symbols |
| 11 | No internal VDI framing | PASS — no content implying GNX 375 renders VDI internally; no VDI references in §§4.1–4.6 |

---

## Coupling Summary Preview

**Backward references to Fragment A:**
- §1 (Overview): baseline framing, no-internal-VDI, sibling-unit distinctions — used in §§4.1, 4.5
- §2 (Physical Controls): inner knob push (§2.7), touchscreen gestures (§2.3), locater bar (§2.5–2.6), Power/Home (§2.1), Back key (§2.4) — used in §4.1 and §4.2
- Appendix B (Glossary): FastFind, FIS-B, METAR, TAF, CDI, OBS, NDB, VOR, VRP, ARTCC, FSS, Smart Airspace, SafeTaxi, TSAA — used throughout without redefinition
- §3 (Startup): not directly referenced; Fragment B assumes post-startup state

**Forward references authored here that later fragments target:**
- §4.1 XPDR app icon → §11 (Fragment F); §4.1 Procedures icon → §7 (Fragment D)
- §4.2 Map overlays → §11.11 (Fragment F for ADS-B In source); §4.9 (Fragment C for Hazard Awareness)
- §4.2 Graphical FPL editing → §5 (Fragment D); §4.2 B4 Gap 1 → design phase
- §4.3 OBS / FPL Catalog → §5 (Fragment D); GPS NAV Status key → §11.7 (Fragment F)
- §4.3 Dead Reckoning → §14 (Fragment G); §4.4 Direct-to/holds → §6 (Fragment D)
- §4.5 Airport Weather → §11.11 (Fragment F); User Waypoints / FastFind → §9 (Fragment E)
- §4.6 Runway criteria filter → §10 (Fragment E)

**§4 parent scope authoring note:** Fragment B is the sole author of `## 4. Display Pages`.
Fragment C opens directly with `### 4.7 Procedures Pages`.

---

## Deviations from Prompt

| Item | Deviation | Rationale |
|------|-----------|-----------|
| Line count | Initial draft 917; trimmed to 798 (within 650–800 range) | Non-required tables converted to prose to meet the 800-line ceiling. All content preserved. Required tables per "Expected tables" list retained. |
| Map Detail level table | Converted to prose description instead of full feature matrix | Not in the "expected tables" list; prose captures the same content (full/high/medium/low levels with feature descriptions) |
| Data Drawing Priority table | Converted to inline prose with layer ordering | Not in the "expected tables" list; prose summary with key levels noted |
| Smart Airspace criteria table | Converted to inline values | 3-row table → 2-sentence prose; same content |
| Active Leg Status table | Converted to inline labels | Inline label listing (iaf, faf, map, mahp, -p) preserves all content |
| User Holds parameters | Converted to prose list | 7-row table → prose sentence; same content |
| §4.6 per-type format | Consolidated to bullet list instead of separate bold paragraphs | Reduces repetitive "Up to 25 ... within 200 nm" prose; content preserved |
