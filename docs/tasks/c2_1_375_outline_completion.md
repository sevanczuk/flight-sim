---
Created: 2026-04-21T00:00:00-04:00
Source: docs/tasks/c2_1_375_outline_prompt.md
---

# C2.1-375 Completion Report — GNX 375 Functional Spec V1 Detailed Outline

**Task ID:** GNX375-SPEC-OUTLINE-01
**Output:** `docs/specs/GNX375_Functional_Spec_V1_outline.md`
**Completed:** 2026-04-21

---

## Pre-flight Verification Results

All checks passed:

| Check | Result |
|-------|--------|
| `docs/knowledge/355_to_375_outline_harvest_map.md` | EXISTS |
| `docs/knowledge/gnx375_ifr_navigation_role_research.md` | EXISTS |
| `docs/knowledge/gnx375_xpdr_adsb_research.md` | EXISTS |
| `docs/specs/GNC355_Functional_Spec_V1_outline.md` | EXISTS |
| `assets/gnc355_pdf_extracted/text_by_page.json` | EXISTS |
| `assets/gnc355_pdf_extracted/extraction_report.md` | EXISTS |
| `assets/gnc355_reference/land-data-symbols.png` | EXISTS |
| JSON structural integrity | 310 pages; p75 = 459 chars; p82 = 784 chars (both non-trivial) |
| Output file pre-existence check | PASS (file did not exist — safe to create) |

---

## Phase 0 Audit Results

All Tier 1 documents read in full (harvest map, IFR navigation role research, XPDR + ADS-B research). GNC 355 outline read in full. Extraction report confirmed sparse page list (pp. 75–82 are all clean). Relevant PDF pages read directly: pp. 89, 113–114, 158 (CDI On Screen, map user fields, GPS NAV Status key). Cross-cutting ADS-B content (pp. 18, 225, 244, 282–284, 290) covered by Turn 21 research document.

**Phase 0 verdict:** All source requirements covered by planned outline structure. Proceeding to authoring.

Key items confirmed from PDF reads:
- GNX 375 map user field 4 (§4.2): "distance/bearing from destination airport" (p. 114) — different from GNC 355's "from, to, and next waypoints"
- CDI On Screen (§4.10): lateral deviation only, below GPS NAV Status indicator key (p. 89)
- GPS NAV Status indicator key (§4.3): four states (no FPL, active route, CDI scale active, route indicator only) (p. 158)

---

## Outline Summary Metrics

| Metric | Value |
|--------|-------|
| Outline file | `docs/specs/GNX375_Functional_Spec_V1_outline.md` |
| Outline line count | 1,477 lines |
| Top-level section count | 15 numbered sections + 3 appendices = 18 divisions |
| Estimated spec body length | ~2,860 lines |
| Largest sections (by spec estimate) | §4 Display Pages (~800), §7 Procedures (~350), §11 XPDR + ADS-B (~200) |

---

## Format Recommendation Summary

**Recommendation: Piecewise + manifest** — same approach as the GNC 355 outline recommended.

The GNX 375 spec body is estimated at ~2,860 lines, comparable to the 355's ~2,800 lines. The addition of §11 XPDR + ADS-B (~200 lines of new outline content) and §7 procedural fidelity augmentations (~50 net new lines) is offset by the removal of §11 COM Radio (~200 lines) and §4.11 COM Standby Control Panel (~60 lines). Net change: roughly flat.

A single-task context window (typical limit ~600–800 output lines for spec-body authoring) cannot reliably produce the full 2,860-line spec in one pass. The piecewise + manifest approach assigns each major section group to a separate C2.2 sub-task, assembled by a manifest into the final document.

Recommended C2.2 grouping (6 tasks):
- Task C2.2-A: §§1–3 + Appendices B, C (~350 lines)
- Task C2.2-B: §4 Part 1 — Map + Hazard Awareness pages (~500 lines)
- Task C2.2-C: §4 Part 2 — FPL, Direct-to, Waypoint, Nearest, Procedures, Planning pages (~500 lines)
- Task C2.2-D: §§5–7 — FPL editing, Direct-to op, Procedures workflows (~550 lines)
- Task C2.2-E: §§8–11 — Nearest, Waypoints, Settings, XPDR + ADS-B (~560 lines)
- Task C2.2-F: §§12–15 + Appendix A — Alerts, Messages, Persistence, I/O, Family delta (~400 lines)

**Cross-section coupling note:** Tasks C2.2-E and C2.2-F share tight coupling between §11 (XPDR + ADS-B), §12.9 (XPDR Annunciations), §13.9 (XPDR Advisories), §14.1 (XPDR State), and §15 (External I/O). Each task prompt must include a coupling summary briefing CC on the cross-references it needs to honor.

---

## Page-Reference Spot-Check Results

Five sub-bullets selected at random (at least one from §11 [NEW] content):

| Check | Outline reference | PDF page | Content match |
|-------|-------------------|----------|---------------|
| 1 | §3.5 database types: FAT32, navigation/terrain/obstacle/basemap [pp. 40–52] | p. 40 | "FAT32 format only, 8–32 GB"; database types table lists Basemap, Navigation, Obstacles, SafeTaxi, Terrain — MATCH ✓ |
| 2 | §4.2 GNX 375 default user fields: distance, GS, DTK/TRK, dist/bearing to destination [p. 114] | p. 114 | "GPS 175/GNX 375: distance, ground speed, desired track and track, distance/bearing from destination airport" — MATCH ✓ |
| 3 | §7.I Turn anticipation: 10-second countdown [pp. 200, 202] | p. 200 | "Time to Turn advisory annunciates and 10 second timer counts down as the distance approaches zero" — MATCH ✓ |
| 4 | §11.4 XPDR modes: Standby/On/Altitude Reporting only; air/ground auto [p. 78] | p. 78 | Mode table shows three modes only; "During Altitude Reporting mode, all aircraft air/ground state transmissions are handled via the transponder and require no pilot action" — MATCH ✓ |
| 5 | §11.13 GNX 375 traffic advisories: 5 conditions at p. 290 | p. 290 | "Traffic Advisories, GNX 375" header; lists 1090ES receiver fault, ADS-B traffic alerting function inoperative, ADS-B traffic function inoperative, Traffic/FIS-B functions inoperative, UAT traffic/FIS-B receiver fault — all 5 present — MATCH ✓ |

All 5 spot checks pass.

---

## Harvest-Map Fidelity Check Results

**Three [PART] sections verified:**

| Section | Harvest category | Identified edits applied |
|---------|-----------------|--------------------------|
| §1 Overview | [PART] | TSO corrected to C112e (not C112d) per p. 18 and D-16 ✓; baseline flipped to GNX 375 ✓; GNC 375/GNX 375 disambiguation flag dropped per D-12 ✓; "COM functions" → "XPDR + ADS-B functions" in scope ✓ |
| §4.9 Hazard Awareness | [PART] | Built-in receiver framing applied throughout ("no external hardware required") ✓; TSAA aural alerts added as 375-only capability ✓; 355 framing "requires external ADS-B receiver" absent ✓; §4.9 FIS-B page cites p. 225 for built-in framing ✓ |
| §12 Audio, Alerts, Annunciators | [PART] | §12.4 flipped from "traffic alerts GNX 375 only, not GNC 355" to "aural traffic alerts present on GNX 375 via TSAA" ✓; §12.9 COM Annunciations entirely replaced by XPDR Annunciations (squawk code display, mode indicator SBY/ON/ALT, Reply R, IDENT active, failure X) ✓ |

**One [355] section verified omitted:**

| Section | Harvest category | Status |
|---------|-----------------|--------|
| §4.11 COM Standby Control Panel | [355] OMIT | Not present as a section header; noted in §4 scope statement as explicitly omitted; confirmed by grep (zero matches for `^### 4\.11` or `^## 4\.11`) ✓ |

---

## Open-Question Flag Check Results

All 6 open research questions are flagged with "Open questions / flags" entries (not resolved):

| # | Key phrase | Flagged in | Verified |
|---|-----------|-----------|---------|
| 1 | Altitude constraints on flight plan legs | §4.3, §7.L, Appendix C.2 | ✓ — "behavior unknown from available documentation; research needed during design phase" |
| 2 | ARINC 424 leg type enumeration | §7.5, §7.M, Appendix C.2 | ✓ — "full supported set not enumerated; research-needed or limited-source feature" |
| 3 | Fly-by vs. fly-over turn geometry | §7.J, §7 open questions, Appendix C.2 | ✓ — "behavioral turn-geometry details not prominently documented; research needed" |
| 4 | Exact XPL dataref names (XPDR) | §11, §15.1, §15.2, §15.3, Appendix C.2 | ✓ — "require verification against XPL datareftool during design phase" |
| 5 | MSFS SimConnect variable behavior | §11, §15.4, §15.5, Appendix C.2 | ✓ — "differ between FS2020 and FS2024; design-phase research required" |
| 6 | TSAA aural alert delivery mechanism | §4.9, §11, §12.4, Appendix C.2 | ✓ — "spec-body design decision; behavior TBD" |

All 6 flagged; none resolved.

---

## Coverage Flags

| Metric | Value |
|--------|-------|
| Sections with "Open questions / flags" entries | 11 of 18 divisions |
| Most significant flags | External I/O (§15) — all XPDR/ADS-B dataref names are design-phase open questions; Map page (§4.2) — implementation architecture (Map_add vs. canvas vs. video) deferred; §7.L — altitude constraint display behavior unknown |

---

## Deviations from Prompt

| Item | Deviation | Rationale |
|------|-----------|-----------|
| §4.10 "Open questions" | No explicit "Open questions" sub-block written (content integrated into scope text) | §4.10 is structurally [PART] with minor additions; the CDI On Screen and ADS-B Status items were straightforward and required no open flags |
| Section count note | Outline header lists "43" total `##`/`###` headers (19 `##` including nav-aids + 24 `###`); actual content divisions = 18 | The "43" count includes sub-section headers within §4, §11, etc. at `###` level; the 18 count is the spec-relevant division count |
| No deviations to D-15, D-16, D-12 scope | None — all constraints honored | No on-screen VDI specified anywhere; Ground/Test/Anonymous modes absent from §11; GNX 375 is baseline throughout |
