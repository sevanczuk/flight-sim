# C2.2-E Drafting Session — Briefing Document

**Created:** 2026-04-23T14:02:43-04:00
**Author:** Purple CD (session ending Turn 23)
**For:** Next Purple CD session
**Purpose:** Hand off context for drafting the C2.2-E task prompt and running C2.2-E through archive. Optimized for "Mode 2 — Direct task" session start: new Purple reads this, drafts, and launches CC — no exploratory checkpoint walk needed.

---

## Immediate task

Draft `docs/tasks/c22_e_prompt.md` covering **§§8–10** of the GNX 375 Functional Spec V1:

- **§8 Nearest Functions** (5 sub-sections §§8.1–8.5)
- **§9 Waypoint Information Pages** (5 sub-sections §§9.1–9.5)
- **§10 Settings / System Pages** (13 sub-sections §§10.1–10.13)

Outline location: `docs/specs/GNX375_Functional_Spec_V1_outline.md` lines ~826–910 (§8), lines ~910–960 (§9), lines ~960–1010 (§10). [Verify line ranges by grep on section dividers; the outline file is 1,477 lines total.]

**Target line count per D-19:** ~455 lines. Expected actual ~550 at the series ~20% overage baseline. **Fragment E is the smallest remaining fragment.**

**Template:** `docs/tasks/completed/c22_d_prompt.md` (most recent; the structural template for all framing-commitment-driven prompts).

---

## Project context (one-paragraph orientation)

The flight-sim project is building an Air Manager plugin for the Garmin GNX 375 touchscreen GPS/MFD + Mode S transponder + built-in dual-link ADS-B In/Out. The GNX 375 is the primary instrument per D-12 (the GNC 355 is deferred). We're ~57% through Stream C — the GNX 375 Functional Spec V1 authoring — using a piecewise+manifest format per D-18 (7 fragments, sequential execution and drafting per D-21). As of the current checkpoint: **4 of 7 fragments archived** (A/B/C/D). Fragment D's compliance was the cleanest in the series (ALL PASS 30/30); it resolved ITM-09 (§7.9 authorship) and validated the ITM-08 authoring-phase grep-verify discipline.

---

## Why you're drafting now and not earlier

**D-21 discipline.** Multi-fragment task prompts are drafted sequentially after the predecessor archives. This prevents drafting C2.2-E before Fragment D's compliance surfaces issues that might need to flow into C2.2-E as hard constraints. Benefit-per-gate has been dominant throughout the series (ITM-08 + ITM-09 both surfaced during C2.2-C review and flowed into C2.2-D's prompt as hard constraints).

For C2.2-E: Fragment D's compliance surfaced **zero new issues** — first such fragment in the series. So C2.2-E's prompt is a clean carry-forward of established constraints plus §§8–10-specific additions.

---

## Scope of §§8–10 in prose (to write the Phase 0 actionable-requirements enumeration)

### §8 Nearest Functions (~60 outline lines)

Identical across all three units (GPS 175 / GNC 355 / GNX 375). Operational workflows act on the Fragment B §4.6 Nearest display pages. Five sub-sections:

- **§8.1 Nearest Access** [p. 179] — Home > Nearest > select icon
- **§8.2 Nearest Airports** [p. 179] — up to 25 airports within 200 nm; identifier, distance, bearing, runway surface, runway length; runway criteria filter applied; tap → Airport Waypoint Information page
- **§8.3 Nearest NDB, VOR, Intersection, VRP** [p. 179] — identifier, type, frequency, distance, bearing
- **§8.4 Nearest ARTCC** [p. 180] — facility name, distance, bearing, frequency
- **§8.5 Nearest FSS** [p. 180] — facility name, distance, bearing, frequency; "RX" = receive-only stations

No outline-flagged open questions for §8.

### §9 Waypoint Information Pages (~120 outline lines)

Identical across all three units. Operational workflows act on the Fragment B §4.5 Waypoint Information display pages. Five sub-sections:

- **§9.1 Database Waypoint Types** [p. 165] — Airport, Intersection, VOR, VRP, NDB
- **§9.2 Airport Information Page** [p. 167] — Tabs: Info, Procedures, Weather (FIS-B; built-in on GNX 375), Chart (SafeTaxi if available)
- **§9.3 Intersection/VOR/VRP/NDB Pages** [p. 166] — common layout; VOR-specific: frequency, class, elevation, ATIS; NDB-specific: frequency, class
- **§9.4 User Waypoints** [pp. 168, 172–178]:
  - Storage: up to 1,000 user waypoints
  - Identifier format: "USRxxx" by default (up to 6 characters, uppercase)
  - Limitations: no duplicate identifiers; active FPL waypoints not editable
  - Create: three reference methods — Lat/Lon, Radial/Distance, Radial/Radial [pp. 172–175]
  - Edit: modify name, location, comment [p. 176]
  - Delete [p. 168]
  - Import: from SD card CSV file [pp. 177–178]
- **§9.5 Waypoint Search and FastFind** [pp. 169–171]:
  - FastFind Predictive Waypoint Entry: predictive matching by identifier
  - Search Tabs: Airport, Intersection, VOR, NDB, User, **Search by Name, Search by Facility Name** [note S13 watchpoint — Fragment B confirmed PDF uses "SEARCH BY CITY" not "Search by Facility Name"; check PDF pp. 169–171 during authoring and trust PDF]
  - User tab: lists all stored user waypoints (up to 1,000)

**Open question preservation:** §9.4 User Waypoints persistence — 1,000 waypoints in Air Manager persist API (scalar) requires JSON encoding design. Forward-ref §14 (Fragment G) for the persistence schema.

### §10 Settings / System Pages (~200 outline lines)

13 sub-sections. GNX 375 adds CDI On Screen to §10.1; §10.12 ADS-B Status reframed for built-in receiver; §10.13 Logs updated for 375 traffic logging. §§10.1–10.13 operational workflows act on Fragment C §4.10 display pages.

- **§10.1 CDI Scale** [pp. 87–88] — options 0.30, 1.00, 2.00, 5.00 nm; HAL follows CDI scale; override by flight phase. **CDI On Screen (GNX 375 / GPS 175 only) [p. 89]**: lateral-only on-screen CDI; toggle in Pilot Settings; affects GPS NAV Status key layout. **Cross-refs Fragment C §4.10 + Fragment D §7.D (auto-switching) + §7.G (deviation display).**
- **§10.2 Airport Runway Criteria** [p. 90] — runway surface filter; minimum runway length; include user airports
- **§10.3 Clocks and Timers** [p. 91] — countup, countdown, flight timer; UTC or local time display
- **§10.4 Page Shortcuts** [p. 92] — customize locater bar slots 2–3 (slot 1 = Map, fixed)
- **§10.5 Alerts Settings** [p. 93] — airspace alerts using 3D data; alert altitude settings; alert type by airspace type
- **§10.6 Unit Selections** [p. 94] — distance/speed, altitude, vertical speed, nav angle, wind, pressure, temperature
- **§10.7 Display Brightness Control** [p. 95] — automatic (photocell + optional dimmer bus); manual override
- **§10.8 Scheduled Messages** [p. 96] — one-time, periodic, event-based reminders; create/modify
- **§10.9 Crossfill** [p. 97] — dual Garmin GPS config; crossfill data: flight plans, user waypoints, pilot settings
- **§10.10 Connectivity — Bluetooth** [pp. 53–56] — Connext data link; pairing (up to 13 devices); flight plan import
- **§10.11 GPS Status** [pp. 103–106] — satellite graph; EPU, HFOM, VFOM, HDOP; SBAS Providers; GPS status annunciations
- **§10.12 ADS-B Status [pp. 107–108] — GNX 375 framing: built-in receiver** — built-in dual-link receiver status (no external LRU required); last uplink time; GPS source; FIS-B WX Status; Traffic Application Status (TSAA). **Must match Fragment C §4.10 framing.**
- **§10.13 Logs [p. 109] — GNX 375: ADS-B traffic logging** — WAAS diagnostic data logging; **ADS-B traffic data logging (GNX 375 only; not on GPS 175 or GNC 355)**; export to SD card. **Must match Fragment C §4.10 framing.**

**Open question preservation:** §10.10 Bluetooth — up to 13 devices; flight plan import. May be v1 out-of-scope (Connext/Garmin Pilot pairing complexity). Preserve as flag.

---

## Hard framing commitments for the C2.2-E prompt

Use the same 14-commitment structure from `c22_d_prompt.md`. The following commitments are the carry-forward + §§8–10-specific set:

1. **Coupling Summary Phase G grep-verify as hard constraint** (ITM-08 discipline). Before writing the Coupling Summary backward-refs list, grep each Appendix B glossary term claimed as a backward-ref against Fragment A. Remove any terms not present. Continue to exclude EPU, HFOM/VFOM, HDOP, TSO-C151c. Discipline validated at C2.2-D compliance F11 — maintain.
2. **Coupling Summary ~60-line budget.** Corrected from C2.2-C miscalibration; maintained through D.
3. **§10 operational workflows act on Fragment C §4.10 display pages. No §4 re-authoring.** §4.10 authored the CDI Scale, CDI On Screen, ADS-B Status, Logs display elements; §10 authors the operational workflows.
4. **§10.1 CDI Scale + CDI On Screen cross-refs §4.10 and §7.D/§7.G.** CDI On Screen = GNX 375 / GPS 175 only, lateral only (per D-15 and Fragment D §7.G).
5. **§10.12 ADS-B Status built-in framing** must match Fragment C §4.10 (GNX 375 built-in; no external LRU required).
6. **§10.13 Logs GNX 375 traffic logging** must match Fragment C §4.10 (GNX 375 only for ADS-B traffic log).
7. **§9 Waypoint Information operational workflows act on Fragment B §4.5 display pages. No §4 re-authoring.**
8. **§8 Nearest Functions operational workflows act on Fragment B §4.6 display pages. No §4 re-authoring.**
9. **No COM present-tense on GNX 375.** Carry-forward (low risk in §§8–10; §10 has no COM-related sub-sections).
10. **S13 trust-PDF-over-outline watchpoint remains active.** Validated three times (Fragment B Search-by-City, Fragment C LNAV/VNAV + MAPR, Fragment D §5.3 Waypoint Options). Particular attention in §9.5 Search Tabs labels and §10.11 GPS Status field labels. Continue to trust PDF when outline disagrees.
11. **No §§1–4 headers re-authored; no §§11–15 or Appendix headers authored.** Forward-refs as prose cross-refs only.
12. **§9.4 User Waypoints persistence forward-ref.** Cross-ref §14 Persistent State (Fragment G) for 1,000-waypoint storage schema. Do not specify persistence schema in Fragment E; Fragment G owns.
13. **§10.10 Bluetooth scope caveat.** Preserve as flag that Bluetooth/Connext/Garmin Pilot pairing may be v1 out-of-scope.
14. **§9.2 Weather tab + §10.12 ADS-B Status FIS-B reception behavior cross-ref Fragment C §4.9 (OPEN QUESTION 6 on TSAA aural delivery is cross-ref context — not re-preserved).**

---

## Self-review checklist for the prompt

Target ~22 items (fewer than Fragment D's 24 — Fragment E has smaller scope). Include:

1. Line count (target 455; acceptable band ~415–600; fragment smaller than D so soft ceiling ~550)
2. Encoding checks (UTF-8 no BOM; no U+FFFD)
3. No §4 headers re-authored (`grep -nE '^## 4\.|^### 4\.'` = 0)
4. No §§11–15 headers authored (`grep -nE '^## 1[1-5]\.|^### (11|12|13|14|15)\.'` = 0)
5. No §§1–3 headers re-authored (`grep -nE '^## [1-3]\.|^### (1|2|3)\.'` = 0)
6. No §§5–7 headers re-authored (`grep -nE '^## [5-7]\.|^### (5|6|7)\.'` = 0)
7. §8 has 5 sub-sections (§§8.1–8.5)
8. §9 has 5 sub-sections (§§9.1–9.5)
9. §10 has 13 sub-sections (§§10.1–10.13)
10. §10.1 CDI On Screen = GNX 375 / GPS 175 only, lateral only, D-15 framing
11. §10.12 ADS-B Status = built-in receiver framing consistent with Fragment C §4.10
12. §10.13 Logs = GNX 375 ADS-B traffic logging consistent with Fragment C §4.10
13. §9.4 User Waypoints persistence forward-ref to §14 (Fragment G)
14. §9.5 Search Tabs labels consistent with PDF (S13 watchpoint)
15. §10.10 Bluetooth scope caveat preserved
16. Page citation preservation (spot check 8–10 citations)
17. YAML front-matter correct; fragment header "Fragment E"
18. No harvest-category markers in `###` lines
19. Coupling Summary present with backward-refs (A/B/C/D) + forward-refs (F/G) + outline footprint note
20. ITM-08 grep-verify executed; documented in completion report
21. No COM present-tense on GNX 375
22. OPEN QUESTION 6 cross-ref only (not re-preserved)

---

## Backward-refs that Fragment E's Coupling Summary will claim (grep-verify before writing!)

- **Fragment A §1** — GNX 375 baseline framing, no-internal-VDI (D-15)
- **Fragment A §2** — Physical controls (inner knob push = Direct-to; outer knob = data entry)
- **Fragment A §3** — Power-on + database (for §10.10 Connext + §10.11 GPS Status context)
- **Fragment A Appendix B** — grep-verify against Fragment A lines 343–447. Expected terms (similar subset to Fragment D): SBAS, WAAS, CDI, VDI, GPSS, FIS-B, UAT, 1090 ES, TSAA, Connext, TSO-C166b, RAIM. **Do NOT claim EPU, HFOM/VFOM, HDOP, TSO-C151c** (absent from Appendix B). Note — some §10.11 field labels (EPU, HFOM, VFOM, HDOP) appear inline in Fragment E body but must NOT be claimed as Appendix B backward-refs.
- **Fragment B §4.5** — Waypoint Info display pages — §9 operational target
- **Fragment B §4.6** — Nearest display pages — §8 operational target
- **Fragment C §4.10** — Settings/System display pages — §10 operational target; §10.1 CDI Scale + CDI On Screen; §10.12 ADS-B Status built-in framing; §10.13 Logs GNX 375 traffic logging
- **Fragment C §4.9** — FIS-B + Traffic + TSAA framing (for §10.12 ADS-B Status + §9.2 Weather tab)
- **Fragment D §7.D** — CDI scale auto-switching (for §10.1 CDI Scale + flight-phase cap interaction)
- **Fragment D §7.G** — CDI deviation display on-screen vs. external (for §10.1 CDI On Screen)

---

## Forward-refs that Fragment E will make

- **§14 Persistent State (Fragment G)** — for §9.4 user waypoint persistence, §10.3 clocks/timers persistence, §10.6 unit selections persistence, §10.7 display brightness persistence, §10.8 scheduled messages persistence, §10.10 Bluetooth pairing persistence, §10.13 logs persistence (if any)
- **§15 External I/O (Fragment G)** — for §10.1 CDI Scale output to external CDI/HSI, §10.11 GPS Status datarefs, §10.12 ADS-B Status datarefs
- **§11 Transponder + ADS-B (Fragment F)** — for §10.12 ADS-B Status (built-in receiver detail)
- **§12 Alerts (Fragment F)** — for §10.5 Alerts Settings
- **§13 Messages (Fragment F)** — for §10.8 Scheduled Messages

---

## After drafting — standard lifecycle

1. Update `docs/tasks/Task_flow_plan_with_current_status.md` same-turn (D-17). Flip C2.2-E task prompt drafting → Done; C2.2-E execution → 🔶 READY TO LAUNCH.
2. Provide launch sequence using correct two-block format (**C22-E Tab title:** / **C22-E CC prompt:**).
3. After CC executes: check-completions (Phase 1) → generate compliance prompt → check-compliance (Phase 2) → archive.
4. On archive: update manifest (Fragment E → ✅ Archived); update Task flow plan; draft C2.2-F (D-21 gated).

**Expected CC duration per D-20:** ~10–15 min wall-clock (~500-line docs-only fragment; moderate reuse discount applies; no novel §-creation unlike Fragment D).

---

## What happens after C2.2-E

Three more fragments + assembly + review pipeline (the long tail):

### C2.2-F (§§11–13 Transponder + ADS-B, Audio/Alerts, Messages) — most-coupled fragment

- Target ~540 lines per D-19
- **§11 is the XPDR + ADS-B fragment** — the heart of the GNX 375 differentiation. 14 sub-sections per the outline (§§11.1–11.14).
- **Most-coupled Coupling Summary in the series.** Expect ~80 lines (vs. budget 60) for this one specifically — CD may want to write the C2.2-F prompt's Coupling Summary budget at ~80 lines as a calibrated extension.
- **Carry-forward hard constraints from D + E plus §11 D-16 three-modes-only framing.**
- §11.10 Remote G3X Touch is out-of-scope for v1 per outline; preserve as flag.
- §11.11 ADS-B In (built-in) framing critical; must match Fragment C §4.9 + Fragment E §10.12.
- §11.13 XPDR Advisory Messages (9 advisories) cross-ref §13.9 in same fragment.
- Gated on C2.2-E archive per D-21.

### C2.2-G (§§14–15 + Appendix A — Persistent State, External I/O, Family Delta) — smallest fragment but highest coupling footprint

- Target ~300 lines per D-19
- **§15 External I/O is where the deferred dataref names live.** OPEN QUESTION 4 (XPL XPDR datarefs) and OPEN QUESTION 5 (MSFS XPDR SimConnect vars) flow into §15 as preserved research-needed flags, not resolved.
- **§15.6 External CDI/VDI Output Contract** is the terminal for many Fragment D §7.x forward-refs.
- Appendix A flips to GNX 375 as baseline (per outline); sibling-unit deltas are the comparison content.
- Assembly script + manifest updates happen at C2.2-G archive.

### Assembly + review

1. **Assembly script** (`scripts/assemble_gnx375_spec.py`) — CD authors at C2.2-G archive per D-18. Concatenates fragments in order, strips YAML + H1 + Coupling Summary, verifies continuous section numbering and cross-ref resolution.
2. **C3 `/spec-review` V1** — tiered review pipeline (likely "standard" tier, 8 agents, 4 batches).
3. **C3 triage** — CD triages findings → G-/O-/FE- IDs → issue_index.
4. **C4** — iterate V2, V3 until implementation-ready (zero CRITICAL/HIGH). Likely 1–3 cycles.

After C4: GNX 375 Design phase (D1, D2), then Implementation (I1, I2, I3).

---

## Key file paths (verbatim, for quick access)

- **Project root:** `C:/Users/artroom/projects/flight-sim-project/flight-sim`
- **Outline (archival):** `docs/specs/GNX375_Functional_Spec_V1_outline.md` (1,477 lines)
- **Manifest:** `docs/specs/GNX375_Functional_Spec_V1.md`
- **Fragments archived:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_{A,B,C,D}.md` (545, 799, 725, 913 lines)
- **Task flow plan:** `docs/tasks/Task_flow_plan_with_current_status.md`
- **Issue index (open):** `docs/todos/issue_index.md`
- **Issue index (resolved):** `docs/todos/issue_index_resolved.md`
- **Recent archived prompts (C2.2-D as template):** `docs/tasks/completed/c22_d_prompt.md`, `docs/tasks/completed/c22_d_completion.md`, `docs/tasks/completed/c22_d_compliance_prompt.md`, `docs/tasks/completed/c22_d_compliance.md`
- **PDF source:** `assets/gnc355_pdf_extracted/text_by_page.json` (310 pages)
- **Relevant PDF pages for C2.2-E:** pp. 53–56 (Bluetooth §10.10), pp. 86–109 (Settings/System §§10.1–10.13), pp. 165–178 (Waypoint Information §9), pp. 179–180 (Nearest §8)

---

## Decisions in effect (D-01 through D-21)

Most relevant for C2.2-E drafting:
- **D-01** XPL primary + MSFS secondary
- **D-04** Commit trailer format
- **D-12** GNX 375 pivot
- **D-15** No internal VDI (affects §10.1 CDI On Screen framing)
- **D-16** Three XPDR modes only (affects §10.12 ADS-B Status framing marginally)
- **D-17** Task flow plan updated same-turn as status changes
- **D-18** Piecewise + manifest (fragment structure)
- **D-19** ~1.35× outline expansion; Fragment E target 455
- **D-20** LLM-calibrated CC duration estimates
- **D-21** Sequential drafting discipline (C2.2-E drafted now that D is archived)

No new decisions anticipated during C2.2-E drafting or lifecycle.

---

## Open ITMs carried forward

| ID | Severity | Status | Relevance to C2.2-E |
|----|----------|--------|---------------------|
| ITM-02 | Low | Open | AMAPI patterns matrix cleanup — unrelated to C2.2 |
| ITM-03 | Low | Open | AMAPI patterns hw_dial_add links — unrelated |
| ITM-04 | Low | Open | CC task prompt template update — unrelated |
| ITM-05 | Low | Open | Compliance Verification Guide update — unrelated |
| ITM-08 | Low | Open (validated) | Coupling Summary grep-verify — **enforce in C2.2-E Phase G as hard constraint** |
| FE-01 | Low | Deferred | AMAPI parser enhancement — unrelated |

Resolved: ITM-01, ITM-06, ITM-07, ITM-09.

---

## Launch format reminder

Per the convention reinforced Turn 20 (Purple 2026-04-23): every CC launch uses **two code blocks with labeled subheads**:

**{TASK-ID} Tab title:**
```
$env:CLAUDE_CODE_DISABLE_TERMINAL_TITLE = "1"; $host.UI.RawUI.WindowTitle = "{label}"; claude --dangerously-skip-permissions --model opusplan
```

**{TASK-ID} CC prompt:**
```
Read and execute docs/tasks/{file}.md
```

No exceptions. Drafting, compliance, archival triage, bug fixes — all of them.

---

## Turn-numbering reminder

New session starts at Turn 1 (or follows from whatever numbering the new instance uses). The current session ended at Turn 23. Per memory: every CD response begins with turn number and ISO 8601 timestamp from a `date` command (never estimated). Colored instances prefix with color.

---

## Quick start for the new session

1. New Purple reads this briefing doc + `project-status/purple_checkpoint_2026-04-23_c22e_drafting_pending_score_4.md` (or latest purple).
2. Draft `docs/tasks/c22_e_prompt.md` using `c22_d_prompt.md` as structural template and the §§8–10 content + 14 commitments + 22 self-review items enumerated above.
3. Update Task flow plan same-turn.
4. Provide CC launch sequence in correct two-block format.
5. Log decisions if any (no new decisions anticipated for C2.2-E drafting).

Success criteria: prompt is ~400–500 lines, enumerates all §§8–10 sub-sections with outline-sourced content, preserves the open-question flags (§9.4 persistence, §10.10 Bluetooth scope), embeds ITM-08 grep-verify as Phase G hard constraint, and has a self-review checklist that catches the S13 PDF-over-outline pattern in §9.5 Search Tabs.

End of briefing.
