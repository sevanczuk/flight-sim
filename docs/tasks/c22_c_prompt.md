# CC Task Prompt: C2.2-C — GNX 375 Functional Spec V1 Fragment C (§§4.7–4.10)

**Created:** 2026-04-22T16:34:15-04:00
**Source:** CD Purple session — Turn 8 (post-resumption 2026-04-22) — third of 7 piecewise fragments per D-18
**Task ID:** GNX375-SPEC-C22-C (Stream C2, sub-task 2C for the 375 primary deliverable)
**Parent reference:** `docs/decisions/D-18-c22-format-decision-piecewise-manifest.md` §"Task partition"
**Authorizing decisions:** D-11 (outline-first), D-12 (pivot to 375), D-14 (procedural fidelity), D-15 (no internal VDI — critical for §4.7 Visual Approach and §4.10 CDI On Screen), D-16 (XPDR + ADS-B scope — critical for §4.9 ADS-B framing and §4.10 ADS-B Status), D-18 (piecewise format + 7-task partition), D-19 (fragment line-count expansion ratio — target ~575), D-20 (LLM-calibrated duration estimates)
**Predecessor tasks:** GNX375-SPEC-C22-A (archived; `docs/tasks/completed/c22_a_*.md`), GNX375-SPEC-C22-B (archived; `docs/tasks/completed/c22_b_*.md`). Both are authoritative backward-reference sources for this task.
**Depends on:** C2.2-A archived (✅ Turn 35), C2.2-B archived (✅ Turn 7 post-resumption), manifest at `docs/specs/GNX375_Functional_Spec_V1.md` exists and Fragment B status is ✅ Archived
**Priority:** Critical-path — third of 7 fragments; "display pages part 2" completing §4. Most distinctive framing: §4.9 ADS-B built-in-receiver flip (GNX 375 has no external hardware dependency, unlike GPS 175 / GNC 355/355A) and TSAA aural alerts (GNX 375-only).
**Estimated scope:** Medium — authors ~575 lines across 4 distinct display-page sub-sections (§4.7 ~240, §4.8 ~95, §4.9 ~145, §4.10 ~95, plus fragment header and Coupling Summary)
**Task type:** docs-only (no code, no tests)
**CRP applicability:** NO — single phase, single output file

---

## Source of Truth (READ ALL OF THESE BEFORE AUTHORING ANY SPEC BODY CONTENT)

### Tier 1 — Authoritative content source

1. **`docs/specs/GNX375_Functional_Spec_V1_outline.md`** — **THE PRIMARY BLUEPRINT.** For C2.2-C, authoritative content comes from:
   - **§4.7 Procedures Pages** (~200 lines estimated) — largest sub-section of this fragment; includes GPS Flight Phase annunciations, procedure types, ILS monitoring-only, Missed Approach, Hold, DME Arc, RF Leg, Vectors to Final, Visual Approach, Autopilot Outputs
   - **§4.8 Planning Pages** (~80 lines) — VCALC, Fuel Planning, DALT/TAS/Wind, RAIM; identical across all three units
   - **§4.9 Hazard Awareness Pages** (~120 lines) — **substantial framing flip**; FIS-B Weather, Traffic (with TSAA), Terrain pages; GNX 375 built-in dual-link ADS-B receiver
   - **§4.10 Settings and System Pages** (~80 lines) — Pilot Settings, CDI Scale, CDI On Screen (GNX 375/GPS 175 only), System Status, GPS Status, ADS-B Status (built-in framing), Logs (GNX 375 traffic logging)

   **Do not deviate from the outline's section numbering, sub-structure, or page references.** The outline is the contract; this task expands it into prose.

2. **`docs/decisions/D-18-c22-format-decision-piecewise-manifest.md`** — format contract. Re-read §"Fragment file conventions" and §"Coupling summary convention" before authoring.

3. **`docs/decisions/D-19-fragment-prompt-line-count-expansion-ratio.md`** — line-count authority. Target: **~575 lines** for Fragment C (per-task table in D-19).

4. **`docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`** — **Fragment A authoritative backward-reference source.** Appendix B glossary terms (TSAA, FIS-B, UAT, 1090 ES, TSO-C112e, TSO-C166b, TIS-B, WOW, Target State and Status, etc.), §1 framing (no internal VDI, GNX 375 baseline, sibling-unit distinctions), and §2 physical control terminology are defined here and must be used consistently — do not redefine.

5. **`docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`** — **Fragment B authoritative backward-reference source.** Specifically relevant:
   - §4.1 Home Page app icon inventory (Weather, Traffic, Terrain, Utilities, System Setup icons — DO NOT re-enumerate in §4.7/§4.9/§4.10 scope paragraphs; cross-ref instead)
   - §4.2 Map Page overlays (NEXRAD, Traffic, TFRs, Airspaces, SafeTaxi) — §4.9 deepens the page-level treatment but does not redefine the overlay inventory
   - §4.3 FPL Page structure (for procedure loading interactions where procedures are loaded via the FPL page's menu)
   - §4 parent scope paragraph — **authored by Fragment B; Fragment C MUST NOT re-author.** See framing commitment #1 below.

6. **`docs/specs/GNX375_Functional_Spec_V1.md`** — the fragment manifest. Confirm Fragment C manifest entry (order 3, covers §§4.7–4.10, target 575) matches your output path.

### Tier 2 — PDF source material (authoritative for content details)

7. **`assets/gnc355_pdf_extracted/text_by_page.json`** — primary PDF source. For C2.2-C, the relevant pages:
   - §4.7 Procedures: pp. 181–207 (Departure, Arrival, Approach selection, ILS display, Missed Approach, Holds, DME Arc, RF Leg, Vectors to Final, Visual Approach, Autopilot Outputs)
   - §4.8 Planning: pp. 209–221 (VCALC, Fuel Planning, DALT/TAS/Wind, RAIM)
   - §4.9 Hazard Awareness: pp. 223–269 (FIS-B Weather, Traffic Awareness, Terrain Awareness)
   - §4.10 Settings/System: pp. 86–109 (Pilot Settings, CDI Scale, CDI On Screen, System Status, GPS Status, ADS-B Status, Logs)

   Read the relevant pages (JSON `pages[N-1]` indexed from 0) when authoring to confirm specific facts. The outline already cites specific page numbers — honor those citations in the spec body.

8. **`assets/gnc355_pdf_extracted/extraction_report.md`** — extraction quality notes. Already enumerated in Fragment A Appendix C; do not re-enumerate. For §4.9, pages 270–271 are in the sparse list (noted in Fragment A's Appendix C); §4.9 Terrain content on pp. 257–269 is clean.

### Tier 3 — Cross-reference context

9. **`docs/knowledge/355_to_375_outline_harvest_map.md`** — harvest categorization for §§4.7–4.10:
   - §4.7: [FULL structure; XPDR-interaction notes added]
   - §4.8: [FULL]
   - §4.9: [PART: substantial framing flip] — ADS-B built-in framing, TSAA aural alerts
   - §4.10: [PART] — CDI On Screen addition, ADS-B Status reframing, Logs traffic-logging addition

10. **`docs/knowledge/amapi_by_use_case.md`** — A3 use-case index. Sections cited in the outline for C2.2-C: §1 (dataref subscribe for GPS flight phase, sensor inputs), §2 (command dispatch for approach activation), §10 (Map overlays for weather/traffic/terrain), §12 (User_prop_add_* for configurable settings).

11. **`docs/knowledge/amapi_patterns.md`** — B3 pattern catalog. Outline cites Pattern 17 (annunciator visible) for §4.9 traffic/terrain annunciations.

12. **`docs/knowledge/stream_b_readiness_review.md`** — B4 readiness review. For §4.9, **B4 Gap 1 is relevant** (canvas-drawn terrain/obstacle overlays for the Terrain page) — same gap as §4.2 Map Page; DO NOT resolve in spec body.

13. **`docs/decisions/D-01-project-scope.md`** — XPL primary + MSFS secondary
14. **`docs/decisions/D-12-pivot-gnc355-to-gnx375-primary-instrument.md`** — pivot rationale
15. **`docs/decisions/D-14-procedural-fidelity-additions-harvest-items-11-25.md`** — procedural fidelity context; relevant to §4.7 structure
16. **`docs/decisions/D-15-gnx375-display-architecture-internal-vs-external-turn-20-research.md`** — **critical for this task.** No internal VDI on GNX 375. §4.7 Visual Approach vertical guidance and §4.10 CDI On Screen framing both depend on this.
17. **`docs/decisions/D-16-gnx375-xpdr-adsb-scope-corrections-turn-21-research.md`** — **critical for this task.** XPDR scope + ADS-B built-in receiver framing. §4.9 ADS-B framing flip and §4.10 ADS-B Status both depend on this.

18. **`docs/tasks/completed/c22_b_prompt.md`** — **most recent structural template.** Use the same section structure, YAML front-matter format, heading-level conventions, Coupling Summary block format, and self-review checklist pattern. Do **not** copy the content — scope and hard constraints are different. This is a style/structure reference.

19. **`CLAUDE.md`** (project conventions, commit format, ntfy requirement)
20. **`claude-conventions.md`** §Git Commit Trailers (D-04)

**Audit level:** standard — CD will check completions and run a compliance verification modeled on the C2.2-B approach (~23-item check across F / S / X / C / N categories). Compliance bar consistent with C2.2-A and C2.2-B.

---

## Pre-flight Verification

**Execute these checks before authoring any fragment content. If any fails, STOP and write `docs/tasks/c22_c_prompt_deviation.md`.**

1. Verify Tier 1 source files exist:
   ```bash
   ls docs/specs/GNX375_Functional_Spec_V1_outline.md
   ls docs/decisions/D-18-c22-format-decision-piecewise-manifest.md
   ls docs/decisions/D-19-fragment-prompt-line-count-expansion-ratio.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md
   ls docs/specs/GNX375_Functional_Spec_V1.md
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

5. Verify Fragment B integrity (799 lines expected per archived completion report):
   ```bash
   wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md
   ```

6. Verify `text_by_page.json` structural integrity on relevant pages (saved `.py` script per D-08):
   Write a short Python script that reads the JSON and prints char counts for key pages: 86 (Pilot Settings), 89 (CDI On Screen), 107 (ADS-B Status), 181 (Procedures overview), 205 (Visual Approach), 225 (FIS-B framing), 245 (Traffic framing), 257 (Terrain overview). All should have non-trivial character counts.

7. Verify no conflicting fragment output exists:
   ```bash
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md 2>/dev/null
   ```
   Expect failure. If the file exists, STOP and note in deviation report.

---

## Phase 0: Source-of-Truth Audit

Before authoring any spec body content:

1. Read all Tier 1 documents in full (outline §§4.7–4.10, D-18, D-19, D-15, D-16, Fragment A, Fragment B).
2. Read Fragment A and Fragment B **in full** — not just the sub-sections directly cited. Both establish terminology and framing (especially no-internal-VDI, XPDR GNX 375-only, ADS-B built-in receiver, FIS-B built-in availability) that Fragment C must use consistently.
3. Read PDF pages listed in outline sub-section `[pp. N]` citations. Particular attention to:
   - §4.7 Visual Approach p. 205 (confirms external CDI/VDI only for vertical deviation per D-15)
   - §4.7 Autopilot Outputs p. 207 (roll steering / GPSS; LPV glidepath)
   - §4.9 p. 225 (FIS-B built-in framing)
   - §4.9 p. 245 (ADS-B In built-in dual-link)
   - §4.9 pp. 255–256 (TSAA aural alerts)
   - §4.10 p. 89 (CDI On Screen)
   - §4.10 pp. 107–108 (ADS-B Status — built-in receiver)
   - §4.10 p. 109 (Logs)
4. Read `docs/knowledge/355_to_375_outline_harvest_map.md` §§ covering §§4.7–4.10.
5. Read `docs/knowledge/stream_b_readiness_review.md` B4 Gap 1 section (canvas-drawn terrain/obstacle overlays).

**Definition — Actionable requirement:** A statement in the outline or an authorizing decision that, if not reflected in the fragment, would make the fragment incomplete relative to what C2.2-D through C2.2-G depend on. Includes: page-structure contracts that later fragments reference (e.g., §4.7 procedure types and GPS flight phase annunciations ground §7 operational workflows; §4.9 TSAA framing grounds §12.4 aural delivery; §4.10 CDI On Screen grounds §15.6 external output), framing decisions (ADS-B built-in, no-internal-VDI, TSAA GNX 375-only), and open-question preservation (XPDR-approach interaction, ADS-B data in sim, TSAA aural delivery mechanism, autopilot roll steering datarefs).

6. Extract actionable requirements. Particular attention to:
   - **§4.7 Procedures**: Procedures app access (Home or FPL menu); GPS Flight Phase annunciations (OCEANS, ENRT, TERM, DPRT, LNAV+V, LNAV, LP+V, LP, LPV — 9 phases + color semantics); Departure, Arrival (STAR), Approach selection pages (procedure-type enumeration: LNAV, LNAV/VNAV, LNAV+V, LPV, LP, LP+V, ILS monitoring-only); SBAS Channel ID key selection; ILS Approach page (monitoring only, pop-up on load); Missed Approach page (before/after MAP states); Approach Hold page (hold options, non-required holds); DME Arc indicator; RF Leg indicator; Vectors to Final indicator; Visual Approach page (active within 10 nm of destination; **external CDI/VDI only for vertical deviation** per D-15 and p. 205); Autopilot Outputs (roll steering/GPSS, LPV glidepath capture for compatible autopilots like KAP 140, KFC 225). XPDR-interaction context preserved as forward-refs to §7.9 and §11.4.
   - **§4.8 Planning**: VCALC page (Target ALT, altitude type MSL/Above WPT, target waypoint, time to TOD, required VS; warning: not sole means of terrain separation); Fuel Planning page (P.Position mode, waypoint-to-waypoint mode; EIS-sourced or manual fuel flow; fuel remaining + endurance); DALT/TAS/Wind Calculator (requires pressure altitude source; inputs: indicated altitude, BARO, CAS; outputs: density altitude, TAS, winds aloft); RAIM Prediction (requires active satellite constellation; inputs: waypoint/date/time; output: availability status). Identical across all three units.
   - **§4.9 Hazard Awareness**:
     - **FIS-B Weather page [pp. 225–244]**: **GNX 375 built-in 978 MHz UAT receiver — no external hardware required**. Data transmission: line-of-sight, 30-day NOTAM limitation. Weather page layout (dedicated page + map overlay). FIS-B products: NEXRAD (CONUS + Regional), METARs/TAFs, graphical AIRMETs, SIGMETs, PIREPs, cloud tops, lightning, CWA, winds/temps aloft, icing, turbulence, TFRs. Product status page states (unavailable/awaiting data/data available). Product age timestamp. WX Info Banner. FIS-B setup menu (orientation, G-AIRMET filters). Raw text reports (METARs, winds/temps aloft). FIS-B reception status page.
     - **Traffic Awareness page [pp. 245–256]**: **GNX 375 built-in dual-link ADS-B In (1090 ES + UAT) — no external hardware required**. Applications: ADS-B + **TSAA (Traffic Situational Awareness with Alerts — GNX 375 only; aural alerts present)**. Traffic display layout (ownship icon, traffic symbols directional/non-directional, altitude separation with vertical trend arrows, off-scale alerts as half symbols on range ring). Traffic setup (motion vectors absolute/relative/off, altitude filtering, ADS-B display, self-test). Traffic interactions (select symbol → registration/callsign, altitude, speed). Traffic annunciations table. Traffic alerting (TA/alert types, alerting parameters: altitude separation, closure rate, time to CPA). **TSAA aural alerts (GNX 375 only) — cross-ref §12.4**.
     - **Terrain Awareness page [pp. 257–269]**: requires terrain database; GPS altitude for terrain (3-D fix, 4 satellites minimum); database limitations (not all-inclusive, cross-validated per TSO-C151c); terrain page layout (ownship, terrain display with elevation colors, obstacle depictions); terrain alerting (FLTA and PDA; alert types, thresholds, inhibit control).
   - **§4.10 Settings/System**:
     - Pilot Settings page layout [p. 86]: CDI Scale, **CDI On Screen (GNX 375 / GPS 175 only)**, airport runway criteria, clocks/timers, page shortcuts, alerts settings, unit selections, display brightness, scheduled messages, crossfill
     - CDI Scale setup [p. 87]: 0.30 / 1.00 / 2.00 / 5.00 nm; full-scale deflection
     - **CDI On Screen setting [p. 89]**: GNX 375 / GPS 175 only (NOT GNC 355); toggle displays CDI scale on screen when active; when active, lateral deviation indicator below GPS NAV Status indicator key (see §4.3 in Fragment B); **lateral only — no vertical deviation indicator on 375 per D-15**; requires active flight plan; Visual Approach lateral advisory guidance annunciations when visual approach active
     - System Status page [p. 102]: serial number, software version, database info; **transponder software version (GNX 375 only)**
     - GPS Status page [pp. 103–106]: satellite graph (up to 15 SVIDs), accuracy fields (EPU, HFOM/VFOM, HDOP), SBAS providers, GPS annunciations, GPS alert conditions
     - **ADS-B Status page [pp. 107–108]**: **GNX 375 framing — built-in receiver (no external LRU required)**; last uplink time; GPS source; FIS-B WX Status (reception quality, ground station coverage); Traffic Application Status (TSAA state)
     - **Logs page [p. 109]**: WAAS diagnostic data logging; **ADS-B traffic data logging (GNX 375 only — NOT on GPS 175 or GNC 355)**; export to SD card (FAT32, 8–32 GB — already documented in Fragment A §3.5; cross-ref)

7. **Open-question preservation checklist:**
   - §4.7: XPDR altitude reporting during approach → forward-ref §7.9 + §11.4 — PRESERVE
   - §4.7: ADS-B traffic display during approach / TSAA behavior → forward-ref §7.9 — PRESERVE
   - §4.7: Autopilot integration roll steering dataref names not documented in Pilot's Guide; design-phase research — PRESERVE
   - §4.8: EIS integration for fuel flow optional equipment — PRESERVE
   - §4.9: B4 Gap 1 (canvas-drawn terrain/obstacle overlays — same gap as §4.2 Map) — PRESERVE as "design decision deferred"
   - §4.9: FIS-B weather data source in Air Manager (dataref-subscribed vs. external bridge) — PRESERVE as design-phase decision
   - §4.9: **OPEN QUESTION 6 — TSAA aural alert delivery mechanism** (GNX 375 emits aural directly via `sound_play` vs. external audio panel integration) — PRESERVE as design-phase decision
   - §4.9: ADS-B In data availability in XPL / MSFS — PRESERVE as research
   - §4.10: No open questions flagged in outline — none to add

8. If ALL requirements are covered by your planned fragment structure: print "Phase 0: all source requirements covered" and proceed to authoring.
9. If any requirement is uncovered: write `docs/tasks/c22_c_prompt_phase0_deviation.md` and STOP.

---

## Instructions

Produce the third fragment of the GNX 375 Functional Spec V1 body: the second half of §4 Display Pages (§§4.7–4.10). This fragment contains the most distinctive GNX 375 framing content in the display-pages section: the §4.9 ADS-B built-in receiver flip, TSAA aural alerts (GNX 375-only), and §4.10 CDI On Screen / ADS-B Status / Logs reframing.

**Primary output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md`

### Authoring strategy

Same as C2.2-A and C2.2-B: outline provides structural skeleton; task expands outline bullets into implementable prose while preserving structure, page references, and cross-references.

#### Authoring depth guidance

- **NO §4 parent scope paragraph.** Fragment B authored it. Fragment C opens directly with the §4.7 sub-section header (see framing commitment #1 below).

- **Scope paragraphs (per sub-section):** 2–4 sentences per sub-section. State what the page is for, its key GNX 375-specific framing (if any), and operational cross-refs. Example for §4.9: "The Hazard Awareness pages provide three dedicated display pages for weather (FIS-B), traffic (ADS-B), and terrain/obstacle awareness. The GNX 375 incorporates a built-in dual-link ADS-B In receiver..."

- **Sub-section prose:** each outline bullet expands into a short block (5–25 lines typical). Preserve source-page citations inline.

- **Tables:** use tables where content is naturally tabular. Expected tables in Fragment C:
  - §4.7: GPS Flight Phase annunciations (9 phases, color semantics)
  - §4.7: Approach types (LNAV, LNAV/VNAV, LNAV+V, LPV, LP, LP+V, ILS — with notes on GPS nav approval)
  - §4.7: Procedure-selection actions (Departure / Arrival / Approach options menus)
  - §4.8: Planning pages overview (4 pages; purpose; required inputs)
  - §4.9: FIS-B weather products (~12 product types)
  - §4.9: Product status states (unavailable / awaiting / available)
  - §4.9: Traffic display symbol types (directional, non-directional, off-scale)
  - §4.9: Traffic setup options (motion vectors, altitude filtering, display, self-test)
  - §4.9: Terrain alert types (FLTA / PDA; thresholds; inhibit)
  - §4.10: Pilot Settings page inventory (CDI Scale, CDI On Screen, runway criteria, clocks/timers, etc.)
  - §4.10: CDI Scale options (0.30 / 1.00 / 2.00 / 5.00 nm)

- **AMAPI cross-refs:** at the end of each sub-section where the outline cites AMAPI references, include an "AMAPI notes" block. Cite, don't expand.

- **Open questions / flags:** preserve every outline flag. Specifically flagged items (see framing commitments): XPDR-approach interaction (§4.7), Autopilot dataref (§4.7), B4 Gap 1 terrain overlays (§4.9), FIS-B sim data (§4.9), OPEN QUESTION 6 TSAA aural mechanism (§4.9), ADS-B sim availability (§4.9).

- **Cross-references:**
  - Backward-refs to Fragment A or Fragment B use "see §N.x" without fragment qualification (spec body is unified post-assembly)
  - Forward-refs to Fragments D, E, F, G use "see §N.x" without further qualification

#### Fragment file conventions (per D-18)

- **Path:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md`
- **YAML front-matter (required):**
  ```yaml
  ---
  Created: 2026-04-22T{HH:MM:SS}-04:00
  Source: docs/tasks/c22_c_prompt.md
  Fragment: C
  Covers: §§4.7–4.10 (Procedures, Planning, Hazard Awareness, Settings/System display pages)
  ---
  ```
- **Heading levels:**
  - `# GNX 375 Functional Spec V1 — Fragment C` — fragment header (stripped on assembly)
  - **NO `## 4. Display Pages` header.** Fragment C opens directly with the §4.7 sub-section. (See framing commitment #1.)
  - `### 4.7 Procedures Pages [pp. 181–207]` — sub-sections use `###`
  - Do NOT include harvest-category markers (`— [FULL]`, `— [PART]`) in spec-body headings.
- **Line count target:** ~575 lines per D-19. Under-delivery (<520) suggests under-coverage; over-delivery (>630) warrants completion-report classification.

#### Specific framing commitments

These are **hard constraints** that must appear in the fragment:

1. **Fragment C opens with `### 4.7 Procedures Pages` directly — NO `## 4. Display Pages` header and NO §4 parent scope paragraph.** Fragment B authored the §4 parent scope; Fragment C appends sub-sections to §4 without duplicating the parent header. This is a structural commitment essential for the assembly script's concatenation to produce a single continuous §4 section. **This is the MOST CRITICAL structural commitment for this fragment.** Verify by running `grep -c '^## 4\. Display Pages'` against the fragment — result must be 0.

2. **§4.7 Visual Approach and no internal VDI.** Per D-15, the GNX 375 has no internal VDI. §4.7 Visual Approach content must state that vertical deviation indications are output to external CDI/VDI only — not rendered on the GNX 375 screen. Pilot's Guide p. 205 confirms this. Frame consistently with Fragment A §1.

3. **§4.7 XPDR-interaction context: forward-refs only.** §4.7 documents procedure display-page structure. XPDR altitude reporting during approach and ADS-B traffic display during approach operational behavior live in §7.9 (Fragment D) and §11.4 (Fragment F). Preserve the outline's 3 open questions for §4.7 with explicit forward-refs.

4. **§4.9 ADS-B built-in receiver framing flip — GNX 375 has no external hardware dependency.** Both the FIS-B Weather page scope and the Traffic Awareness page scope must explicitly state the GNX 375 has a built-in dual-link ADS-B In receiver (978 MHz UAT + 1090 ES). Explicit contrast with GPS 175 (no ADS-B In) and GNC 355/355A (no ADS-B In, requires external GDL 88 or GTX 345 for these features). This is the most distinctive framing in Fragment C.

5. **§4.9 TSAA = GNX 375 only (with aural alerts).** TSAA (Traffic Situational Awareness with Alerts) is present only on the GNX 375. GPS 175 and GNC 355/355A do not have TSAA — they have ADS-B traffic display only (via external hardware). The aural-alerts aspect of TSAA is distinctive.

6. **§4.9 OPEN QUESTION 6 (TSAA aural alert delivery mechanism) preserved as design-phase decision.** Whether the GNX 375 instrument emits aural alerts via `sound_play` directly or depends on external audio panel integration is a spec-body design decision. Preserve verbatim: "TSAA aural alert delivery mechanism (OPEN QUESTION 6): whether the 375 instrument emits aural alerts via `sound_play` directly or depends on an external audio panel integration is a spec-body design decision. Behavior TBD."

7. **§4.9 B4 Gap 1 applies to terrain/obstacle canvas overlays.** Same gap as §4.2 Map Page. Preserve as "design decision deferred to design phase; same gap as §4.2." Do not resolve.

8. **§4.9 FIS-B data source in sim + ADS-B In sim availability open questions preserved.** Both are research-needed items for the design phase. Frame as "spec must define behavior when data is absent vs. degraded."

9. **§4.10 CDI On Screen = GNX 375 / GPS 175 only (NOT GNC 355); lateral only (no VDI per D-15).** The setting must be framed as available on GNX 375 and GPS 175 only. Explicit statement that only lateral deviation is displayed — no vertical deviation indicator on the GNX 375 per D-15.

10. **§4.10 ADS-B Status page = built-in receiver framing (no external LRU).** Contrast with external-LRU framing that would apply for GPS 175 or GNC 355/355A (both of which lack ADS-B Status in the GNX 375 form — they would have different ADS-B handling via external equipment).

11. **§4.10 Logs = GNX 375 ADS-B traffic logging capability (not on siblings).** Explicit GNX 375-only note for the ADS-B traffic data logging feature. WAAS diagnostic logging is present on all units; the ADS-B traffic logging is GNX 375-only.

12. **No COM present-tense on GNX 375.** Carry forward from Fragments A and B. Any COM content in §§4.7–4.10 must be in sibling-unit comparison context (e.g., "the GNC 355 adds a VHF COM radio for communications") or absent entirely. The CDI Scale / CDI On Screen settings do not involve COM.

13. **No §7 operational workflows in §4.7, no §11 XPDR internals in §4.9 or elsewhere.** §4.7 documents procedure page structure; operational workflows (loading, activating, executing procedures) live in §7 (Fragment D). §4.9 references XPDR status as a traffic source; XPDR panel internals (modes, squawk entry, IDENT) live in §11 (Fragment F).

#### Per-section page budget (informative)

| Section | Outline estimate | Fragment prose target |
|---------|------------------|------------------------|
| Fragment header + YAML | — | ~10 |
| §4.7 Procedures Pages | ~200 | ~240 |
| §4.8 Planning Pages | ~80 | ~95 |
| §4.9 Hazard Awareness Pages | ~120 | ~145 |
| §4.10 Settings/System Pages | ~80 | ~95 |
| Coupling Summary block | — | ~15 |
| **Total target** | **~480** | **~575** |

The ~95-line buffer over the outline sum accounts for fragment header, YAML, per-sub-section scope paragraphs, AMAPI notes blocks, and Coupling Summary block. Expansion ratio ~1.20× per D-19.

#### Coupling Summary block

At the end of the fragment (after §4.10), include a **Coupling Summary** section per D-18:

```markdown
---

## Coupling Summary

This section is authored per D-18 for CD/CC coordination across the 7-fragment spec. It is not part of the spec body and is stripped on assembly.

### Backward cross-references (sections this fragment references authored in prior fragments)

- Fragment A §1 (Overview): GNX 375 baseline framing, no-internal-VDI constraint (D-15) — referenced in §4.7 Visual Approach and §4.10 CDI On Screen; ADS-B built-in framing / TSO-C166b — referenced in §4.9 Weather and Traffic pages.
- Fragment A §2 (Physical Layout & Controls): knob and touchscreen behaviors — implicit throughout §§4.7–4.10 for page navigation interactions.
- Fragment A §3 (Power-On / Startup / Database): SD card format (FAT32, 8–32 GB) — referenced by §4.10 Logs page without re-documentation.
- Fragment A Appendix B (Glossary): FIS-B, TIS-B, UAT, 1090 ES, TSAA, TSO-C112e, TSO-C166b, TSO-C151c (terrain), EPU, HFOM/VFOM, HDOP, SBAS, WOW, IDENT, Flight ID — all referenced without redefinition.
- Fragment B §4.1 (Home Page): Weather, Traffic, Terrain, Utilities, System Setup app icons already enumerated; §§4.7/4.9/4.10 scope paragraphs do NOT re-enumerate; cross-ref §4.1.
- Fragment B §4.2 (Map Page): overlay inventory (NEXRAD, Traffic, TFRs, Airspaces, SafeTaxi, Terrain) defined there; §4.9 deepens page-level treatment but does not redefine the overlay set.
- Fragment B §4.3 (FPL Page): procedure loading is via FPL Menu → Procedures; cross-ref §4.3 for the FPL-side access point.

### Forward cross-references (sections this fragment writes that later fragments will reference)

- §4.7 Procedures display pages → §7 Procedures (Fragment D) for full operational workflow detail (procedure loading, activation, monitoring, missed-approach sequences).
- §4.7 XPDR altitude reporting during approach → §7.9 XPDR-interaction during approach (Fragment D) + §11.4 XPDR modes (Fragment F).
- §4.7 ADS-B traffic during approach / TSAA behavior → §7.9 (Fragment D) + §11.11 ADS-B In (Fragment F).
- §4.7 Autopilot Outputs (GPSS roll steering, LPV glidepath) → §15 External I/O / datarefs (Fragment G).
- §4.7 Visual Approach external CDI/VDI output → §15.6 External CDI/VDI output contract (Fragment G).
- §4.9 FIS-B weather data source / reception → §11.11 ADS-B In receiver source detail (Fragment F).
- §4.9 TSAA aural alert delivery → §12.4 Aural alert hierarchy (Fragment F).
- §4.9 Terrain/obstacle canvas overlays (B4 Gap 1) → design phase resolution (no fragment).
- §4.10 Pilot Settings page → §10 Settings/System full operational detail (Fragment E) — §4.10 documents the display page; §10 documents configuration workflows.
- §4.10 CDI On Screen → §15.6 External CDI/VDI output contract (Fragment G) for the external output side.
- §4.10 ADS-B Status page → §11 Transponder + ADS-B (Fragment F) for status source detail; §11.11 specifically for the built-in receiver.
- §4.10 Logs (ADS-B traffic logging) → §14 Persistent State (Fragment G) for log storage mechanism.

### §4 parent-scope inheritance note

Fragment C does NOT author the §4 parent scope paragraph. That scope is authored by Fragment B under `## 4. Display Pages`. Fragment C opens with `### 4.7 Procedures Pages` directly. On assembly, the concatenation produces a single continuous §4 section: Fragment B's `## 4. Display Pages` + parent scope + §§4.1–4.6, immediately followed by Fragment C's §§4.7–4.10.

### Outline coupling footprint

This fragment draws from outline §§4.7–4.10 only. No content from §§1–3, §§4.1–4.6, §§5–15, or Appendices A/B/C is authored here.
```

---

## Integration Context

- **Primary output file:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` (new)
- **Directory already exists:** `docs/specs/fragments/` was created by C2.2-A and now contains part_A and part_B.
- **No code modification in this task.** Docs-only.
- **No test suite run required.** Docs-only.
- **Do not modify the outline.** If you spot outline errors during authoring (e.g., PDF-vs-outline term discrepancies like the S13 finding from C2.2-B), note them in the completion report's Deviations section.
- **Do not modify Fragment A or Fragment B.** Both are archival.
- **Do not modify the manifest yet.** CD will update the manifest status entry for Fragment C after this task archives.

---

## Implementation Order

**Execute phases sequentially. Do not parallelize phases or launch subagents.**

### Phase A: Read and audit (Phase 0 per above)

Read all Tier 1 and Tier 2 sources. Read Fragments A and B in full. Extract actionable requirements. Confirm coverage of the open-question preservation checklist. Print the Phase 0 completion line OR write the Phase 0 deviation report and STOP.

### Phase B: Create fragment file skeleton

1. Create the fragment file at `docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` with YAML front-matter, fragment header (`# GNX 375 Functional Spec V1 — Fragment C`), and sub-section headers (`### 4.7`, `### 4.8`, `### 4.9`, `### 4.10`). **Do NOT add a `## 4. Display Pages` header — that's Fragment B's.**
2. Add the Coupling Summary placeholder at the end.

### Phase C: Author §4.7 Procedures Pages (~240 lines)

Largest sub-section. Expand outline §4.7:
- Scope paragraph (note: XPDR-interaction context forward-refs; page structure only; operational workflows in §7)
- Procedures app overview [p. 181]: access from Home or FPL menu
- GPS Flight Phase Annunciations table [pp. 184–185]: OCEANS, ENRT, TERM, DPRT, LNAV+V, LNAV, LP+V, LP, LPV with color semantics (green = normal, yellow = caution/integrity degraded)
- Departure selection page [pp. 186–187]: one departure per plan; Select Departure / Remove Departure options
- Arrival (STAR) selection page [pp. 188–189]: Select Arrival / Remove Arrival options
- Approach selection page [pp. 190–191, 199–206]:
  - Approach types table (LNAV, LNAV/VNAV, LNAV+V, LPV, LP, LP+V, ILS)
  - ILS: monitoring only; not approved for GPS nav
  - SBAS Channel ID key selection method
  - Flight Plan Approach Options: Remove Approach
- ILS Approach display [p. 198]: GPS provides monitoring only; pop-up on load
- Missed Approach page [p. 193]: before/after MAP states
- Approach Hold page [pp. 194–195]: hold options, non-required holds
- DME Arc indicator [p. 196]
- RF Leg indicator [p. 197]
- Vectors to Final indicator [p. 197]
- **Visual Approach page [pp. 205–206]**:
  - Active within 10 nm of destination
  - Accessible from Map or FPL page
  - Provides lateral guidance and optional vertical guidance
  - **External CDI/VDI only for vertical deviation indications (per p. 205 and D-15).** Explicit statement required.
- Autopilot Outputs display [p. 207]:
  - Roll steering (GPSS) availability and activation
  - LPV glidepath capture output to compatible autopilots (KAP 140, KFC 225)
- AMAPI notes block: §1 (dataref subscribe for GPS flight phase), §2 (command dispatch for approach activation)
- **Open questions / flags (3):**
  - XPDR altitude reporting during approach — forward-ref §7.9, §11.4
  - ADS-B traffic display during approach / TSAA behavior — forward-ref §7.9
  - Autopilot integration roll steering dataref names not documented — research during design phase

### Phase D: Author §4.8 Planning Pages (~95 lines)

Expand outline §4.8:
- Scope paragraph (note: identical across all three units per [FULL] harvest; utility pages)
- Planning apps overview [p. 210]: Target ALT, Fuel Planning, DALT/TAS/Wind, RAIM
- Vertical Calculator (VCALC) page [pp. 211–212]: Target ALT, Altitude Type (MSL or Above WPT), target waypoint, time to TOD, required VS; warning re: terrain separation
- Fuel Planning page [pp. 213–216]: P.Position mode, waypoint-to-waypoint mode; fuel on board, fuel flow (EIS or manual); fuel remaining + endurance
- DALT/TAS/Wind Calculator page [pp. 217–219]: requirements (pressure altitude source); inputs (indicated altitude, BARO, CAS); outputs (density altitude, TAS, winds aloft)
- RAIM Prediction page [pp. 220–221]: requirements (satellite constellation); inputs (waypoint, date, time); output (availability)
- AMAPI notes block: §1 (dataref subscriptions for sensor inputs to DALT calc); static data entry otherwise
- **Open questions / flags (1):**
  - EIS integration for fuel flow (optional equipment): spec should document manual vs. EIS-sourced distinction

### Phase E: Author §4.9 Hazard Awareness Pages (~145 lines)

Most framing-critical sub-section. Expand outline §4.9:
- Scope paragraph (**substantial framing flip note**: three dedicated pages; GNX 375 built-in dual-link ADS-B In receiver; TSAA aural alerts present)
- **FIS-B Weather page [pp. 225–244]**:
  - GNX 375 framing: built-in 978 MHz UAT receiver; no external hardware required [p. 225]
  - Data transmission limitations: line-of-sight, 30-day NOTAM limitation [pp. 225–226]
  - Weather page layout: dedicated page + map overlay
  - FIS-B weather products (~12 product types table): NEXRAD (CONUS + Regional), METARs/TAFs, graphical AIRMETs, SIGMETs, PIREPs, cloud tops, lightning, CWA, winds/temps aloft, icing, turbulence, TFRs
  - Product status page states table [p. 231]: unavailable / awaiting data / data available
  - Product age timestamp [p. 232]
  - WX Info Banner [p. 228]: tap weather icon shows info banner
  - FIS-B setup menu [pp. 229, 237]: orientation, G-AIRMET filters
  - Raw text reports [pp. 242–243]: METARs, winds/temps aloft
  - FIS-B reception status page [p. 244]
- **Traffic Awareness page [pp. 245–256]**:
  - GNX 375 framing: built-in dual-link ADS-B In (1090 ES + UAT); no external hardware required [p. 245]
  - Traffic applications [pp. 245–246]: ADS-B + **TSAA (Traffic Situational Awareness with Alerts — GNX 375 only; aural alerts present)**
  - Traffic display layout [pp. 247–250]: ownship icon; traffic symbols table (directional, non-directional, off-scale half-symbols on range ring); altitude separation + vertical trend arrows
  - Traffic setup [pp. 251–252]: motion vectors (absolute / relative / off); altitude filtering; ADS-B display; self-test
  - Traffic interactions [p. 253]: select symbol → registration/callsign, altitude, speed
  - Traffic annunciations table [p. 254]
  - Traffic alerting [pp. 255–256]: TA / alert types; parameters (altitude separation, closure rate, time to CPA)
  - **TSAA aural alerts (GNX 375 only)**: aural advisory when traffic threat detected; mute function for current alert only; cross-ref §12.4 (forward-ref Fragment F)
- **Terrain Awareness page [pp. 257–269]**:
  - Requirements: terrain database [p. 257]
  - GPS Altitude for Terrain: derived from satellite measurements; 3-D fix (4 satellites minimum) [p. 258]
  - Database limitations: not all-inclusive, cross-validated per TSO-C151c [p. 259]
  - Terrain page layout [pp. 260–264]: ownship icon; terrain display with elevation colors; obstacle depictions
  - Terrain alerting [pp. 265–269]: FLTA and PDA; alert types; thresholds; inhibit control
- AMAPI notes block: §10 (Map overlays for weather/traffic/terrain); canvas-drawn terrain/obstacle overlays → **B4 Gap 1**; Pattern 17 (annunciator visible)
- **Open questions / flags (4):**
  - FIS-B weather data source in Air Manager (dataref-subscribed vs. external bridge): spec-body design decision
  - **OPEN QUESTION 6 — TSAA aural alert delivery mechanism** (GNX 375 emits aural via `sound_play` directly vs. external audio panel integration): design-phase decision. Behavior TBD.
  - ADS-B In data availability in XPL / MSFS: partial/limited exposure; spec must define behavior when data absent vs. degraded
  - B4 Gap 1 (canvas-drawn terrain/obstacle overlays): same gap as §4.2 Map Page; design decision deferred

### Phase F: Author §4.10 Settings and System Pages (~95 lines)

Expand outline §4.10:
- Scope paragraph (note: GNX 375 adds CDI On Screen setting; ADS-B Status reframed for built-in receiver; Logs updated for 375 traffic logging capability)
- Pilot Settings page layout [p. 86]: inventory table (CDI Scale, **CDI On Screen (GNX 375 / GPS 175 only)**, airport runway criteria, clocks/timers, page shortcuts, alerts settings, unit selections, display brightness, scheduled messages, crossfill)
- CDI Scale setup page [p. 87]: 0.30 / 1.00 / 2.00 / 5.00 nm; full-scale deflection
- **CDI On Screen (GNX 375 / GPS 175 only — NOT GNC 355) [p. 89]**:
  - Toggle: displays CDI scale on screen when active
  - When active: lateral deviation indicator below GPS NAV Status indicator key (cross-ref §4.3 in Fragment B)
  - **Lateral only — no vertical deviation indicator on 375 (per D-15)**
  - Requires active flight plan
  - Visual Approach lateral advisory guidance annunciations when visual approach active
- System Status page [p. 102]: serial number, software version, database info; transponder software version (GNX 375 only)
- GPS Status page [pp. 103–106]: satellite graph (up to 15 SVIDs); accuracy fields (EPU, HFOM/VFOM, HDOP); SBAS providers; GPS annunciations; GPS alert conditions
- **ADS-B Status page [pp. 107–108] — GNX 375 framing: built-in receiver**:
  - Built-in receiver status (no external LRU required)
  - Last uplink time; GPS source
  - FIS-B WX Status sub-page: reception quality, ground station coverage
  - Traffic Application Status sub-page: TSAA state
- **Logs page [p. 109] — GNX 375 ADS-B traffic logging**:
  - WAAS diagnostic data logging (all units)
  - **ADS-B traffic data logging (GNX 375 only — NOT on GPS 175 or GNC 355)**
  - Export to SD card; FAT32, 8–32 GB (see §3.5 in Fragment A)
- AMAPI notes block: §12 (User_prop_add_* for configurable settings)
- **No open questions** (outline has none flagged for §4.10)

### Phase G: Author Coupling Summary

Write the Coupling Summary block per the template above under §"Coupling Summary block". Include both Fragment A and Fragment B backward-refs; enumerate forward-refs to Fragments D, E, F, G.

### Phase H: Self-review

Before writing the completion report, perform the following self-checks (per D-08 — completion report claim verification):

1. **Line count:** `wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — target ~575 ± 10% (~520–630 acceptable).
2. **Character encoding:** `grep -c '\\u[0-9a-f]\{4\}' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — expect 0.
3. **Replacement chars:** Python check (saved `.py` file per D-08) to count U+FFFD bytes — expect 0.
4. **NO `## 4. Display Pages` header:** `grep -c '^## 4\. Display Pages' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — **expect exactly 0.** This is the single most important structural check.
5. **§4.7 Visual Approach — external CDI/VDI only:** `grep -ni 'external CDI/VDI\|external CDI' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — expect matches in §4.7 Visual Approach context; NO prose implying internal VDI rendering.
6. **§4.7 XPDR-approach open questions preserved:** §4.7 Open questions section flags XPDR altitude reporting + ADS-B traffic during approach as forward-refs to §7.9 (+§11.4 for XPDR).
7. **§4.7 Autopilot dataref open question preserved:** §4.7 Open questions section notes roll steering dataref names require design-phase research.
8. **§4.9 ADS-B built-in framing:** `grep -ni 'built-in\|built in' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — expect multiple matches in §4.9 (both FIS-B Weather and Traffic sub-sections) stating "built-in" dual-link receiver or 978 MHz UAT receiver; contrast with GPS 175 (no ADS-B In) and GNC 355/355A.
9. **§4.9 TSAA = GNX 375 only:** `grep -ni 'TSAA' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — expect matches in §4.9 Traffic and in OPEN QUESTION 6 preservation; every present-tense TSAA reference must be framed as GNX 375-specific.
10. **§4.9 OPEN QUESTION 6 preserved:** `grep -ni 'OPEN QUESTION 6\|TSAA aural\|sound_play' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — expect matches preserving the design-phase decision about aural delivery mechanism.
11. **§4.9 B4 Gap 1 preserved:** `grep -ni 'B4 Gap 1' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — expect match in §4.9 AMAPI notes or Open questions flagging canvas-drawn terrain/obstacle overlays as design-phase decision (same gap as §4.2).
12. **§4.9 FIS-B data source + ADS-B sim availability open questions preserved:** §4.9 Open questions flags FIS-B weather data source and ADS-B In XPL/MSFS availability as research items.
13. **§4.10 CDI On Screen GNX 375/GPS 175 only; lateral only:** `grep -ni 'CDI On Screen' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — expect matches in §4.10 with "GNX 375 / GPS 175 only" (or equivalent) and "lateral only" (or equivalent no-VDI framing per D-15).
14. **§4.10 ADS-B Status built-in framing:** §4.10 ADS-B Status sub-block states built-in receiver (no external LRU required).
15. **§4.10 Logs GNX 375 traffic logging:** §4.10 Logs sub-block explicitly notes ADS-B traffic data logging is GNX 375-only (not on GPS 175 or GNC 355).
16. **No COM present-tense on GNX 375:** `grep -ni 'COM radio\|COM standby\|COM volume\|COM frequency\|COM monitoring\|VHF COM' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — any matches must be in sibling-unit comparison context; no "the GNX 375 has [COM feature]."
17. **No §7 operational workflows in §4.7:** §4.7 prose documents page structure (layouts, fields, controls, annunciations) — NOT operational sequences (loading a procedure step-by-step, activating a missed approach step-by-step, hold-entry procedures). Spot-check by reading §4.7 and confirming operational-step prose is absent or deferred via "see §7" forward-refs.
18. **No §11 XPDR internals anywhere:** `grep -ni 'XPDR' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — every match must be a cross-reference or peripheral mention (e.g., "transponder software version in System Status page"). No matches describing XPDR modes, squawk code entry, IDENT button, Extended Squitter mechanism, Mode S behaviors.
19. **Outline page citations preserved:** sample 6 outline page citations and confirm each appears in the fragment at the corresponding sub-section:
    - `[pp. 181–207]` at §4.7 heading
    - `[p. 205]` in §4.7 Visual Approach
    - `[p. 207]` in §4.7 Autopilot Outputs
    - `[pp. 209–221]` at §4.8 heading
    - `[pp. 225–244]` in §4.9 FIS-B Weather
    - `[pp. 245–256]` in §4.9 Traffic Awareness
    - `[pp. 257–269]` in §4.9 Terrain
    - `[p. 89]` in §4.10 CDI On Screen
    - `[pp. 107–108]` in §4.10 ADS-B Status
    - `[p. 109]` in §4.10 Logs
20. **Fragment file conventions:** YAML front-matter present with Created/Source/Fragment/Covers; fragment header `# GNX 375 Functional Spec V1 — Fragment C`; sub-sections use `###`; no harvest-category markers in `###` lines.
21. **Coupling Summary section present with backward-refs (Fragment A + Fragment B) and forward-refs (Fragments D, E, F, G) enumerated:** visual check.
22. **§4 parent-scope inheritance note:** Coupling Summary explicitly states Fragment C does NOT author §4 parent scope; Fragment B owns it.

Report all 22 check results in the completion report.

---

## Completion Protocol

1. Write completion report to `docs/tasks/c22_c_completion.md` with this structure:

   ```markdown
   ---
   Created: {ISO 8601 timestamp}
   Source: docs/tasks/c22_c_prompt.md
   ---

   # C2.2-C Completion Report — GNX 375 Functional Spec V1 Fragment C

   **Task ID:** GNX375-SPEC-C22-C
   **Output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md`
   **Completed:** 2026-04-22

   ## Pre-flight Verification Results
   {table of the 7 pre-flight checks with PASS/FAIL}

   ## Phase 0 Audit Results
   {summary of actionable requirements confirmed covered; include open-question preservation checklist}

   ## Fragment Summary Metrics
   | Metric | Value |
   |--------|-------|
   | Fragment file | `docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` |
   | Line count | {actual} |
   | Target line count | ~575 |
   | Sections covered | §§4.7–4.10 |
   | Sub-section count | 4 (4.7, 4.8, 4.9, 4.10) |
   | `## 4. Display Pages` header count | 0 (expected — Fragment B owns parent scope) |

   ## Self-Review Results (Phase H)
   {table of the 22 self-checks with PASS/FAIL and specifics}

   ## Hard-Constraint Verification
   {confirm each of the 13 framing commitments}

   ## Coupling Summary Preview
   {brief summary of backward-refs to Fragments A + B and forward-refs to Fragments D–G}

   ## Deviations from Prompt
   {table of any deviations with rationale; if none, state "None"}
   ```

2. `git add -A`

3. `git commit` with the D-04 trailer format. Write the commit message to a temp file via `[System.IO.File]::WriteAllText()` (BOM-free):

   ```
   GNX375-SPEC-C22-C: author fragment C (§§4.7–4.10 display pages)

   Third of 7 piecewise fragments per D-18. Covers GNX 375 Procedures,
   Planning, Hazard Awareness, and Settings/System display pages.
   Target: ~575 lines; actual: {N}.

   Framing commitments honored: no §4 parent scope header (Fragment B
   owns it); §4.7 Visual Approach external CDI/VDI only per D-15;
   §4.9 ADS-B built-in receiver framing flip with GPS 175 / GNC 355
   contrast; TSAA = GNX 375 only; OPEN QUESTION 6 (TSAA aural
   delivery) preserved as design-phase; B4 Gap 1 terrain canvas
   overlays preserved; §4.10 CDI On Screen GNX 375/GPS 175 only,
   lateral only; §4.10 ADS-B Status built-in; §4.10 Logs GNX 375
   traffic logging. No COM present-tense, no §7 operational
   workflows in §4.7, no §11 XPDR internals.

   Task-Id: GNX375-SPEC-C22-C
   Authored-By-Instance: cc
   Refs: D-15, D-16, D-18, D-19, D-20, GNX375-SPEC-C22-A, GNX375-SPEC-C22-B
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
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-C completed [flight-sim]"
   ```

6. **Do NOT git push.** Steve pushes manually.

---

## What CD will do with this report

After CC completes:

1. CD runs check-completions Phase 1: reads the prompt + completion report, cross-references claims against the fragment file, generates a compliance prompt modeled on the C2.2-B approach (~22-item check across F / S / X / C / N categories). The compliance prompt will verify the 22 self-checks plus additional items CD identifies from reading the fragment directly (PDF-sourcing spot checks for §4.9 FIS-B products and traffic display symbology; Fragment A + Fragment B cross-ref resolution; OPEN QUESTION 6 language verification; §4.7 XPDR-interaction forward-ref verification).

2. After CC runs the compliance prompt: CD runs check-compliance Phase 2. PASS → archive all four files to `docs/tasks/completed/`; update manifest (Fragment C → ✅ Archived); begin drafting C2.2-D task prompt. PASS WITH NOTES → log ITM if needed, archive, continue. FAIL → bug-fix task.

---

## Estimated duration

- CC wall-clock: ~10–20 min (LLM-calibrated per D-20: ~575-line docs-only fragment reusing C2.2-A and C2.2-B conventions; ×0.7 reuse adjustment applied to the 500-line docs baseline of 10–20 min, yielding 7–14 min; adjusted upward slightly for §4.9's heavier PDF read range of pp. 225–269 relative to C2.2-B's per-sub-section reads).
- CD coordination cost after this: ~1 check-completions turn + ~1 check-compliance turn + ~0.5 turn to update manifest and start C2.2-D prompt.

Proceed when ready.
