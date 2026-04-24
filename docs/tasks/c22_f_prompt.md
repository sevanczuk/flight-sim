# CC Task Prompt: C2.2-F — GNX 375 Functional Spec V1 Fragment F (§§11–13)

**Created:** 2026-04-24T06:26:22-04:00
**Source:** CD Purple session — Turn 4 (2026-04-24) — sixth of 7 piecewise fragments per D-18
**Task ID:** GNX375-SPEC-C22-F (Stream C2, sub-task 2F for the 375 primary deliverable)
**Parent reference:** `docs/decisions/D-18-c22-format-decision-piecewise-manifest.md` §"Task partition"
**Authorizing decisions:** D-11 (outline-first), D-12 (pivot to 375), D-14 (procedural fidelity — §13.9 XPDR advisory enumeration), D-15 (no internal VDI), D-16 (XPDR + ADS-B scope — **primary authority for this fragment**; three modes only + built-in dual-link ADS-B In), D-18 (piecewise format + 7-task partition), D-19 (fragment line-count expansion ratio — target ~540), D-20 (LLM-calibrated duration estimates), D-21 (sequential drafting — this prompt drafted after C2.2-E archived)
**Predecessor tasks:** C2.2-A archived (`docs/tasks/completed/c22_a_*.md`), C2.2-B archived (`docs/tasks/completed/c22_b_*.md`), C2.2-C archived (`docs/tasks/completed/c22_c_*.md`), C2.2-D archived (`docs/tasks/completed/c22_d_*.md`), C2.2-E archived (`docs/tasks/completed/c22_e_*.md`). All five are authoritative backward-reference sources.
**Depends on:** C2.2-A ✅, C2.2-B ✅, C2.2-C ✅, C2.2-D ✅, C2.2-E ✅, manifest at `docs/specs/GNX375_Functional_Spec_V1.md` (Fragment E status ✅ Archived).
**Priority:** Critical-path — sixth of 7 fragments; the **most-coupled** fragment in the series. §11 is the GNX 375's signature feature (XPDR + ADS-B) — wholesale replaces GNC 355's §11 COM Radio section. §12 alerts and §13 messages both have GNX 375-specific content (TSAA aural alerts in §12.4; XPDR advisories in §13.9; GNX 375 traffic advisories in §13.11). Coupling Summary will be densest in the series: §11 couples backward to Fragment C §4.9 and Fragment E §10.12, and forward within the same fragment to §12.4 and §13.9; §13 couples backward to Fragment A Appendix B (many new glossary terms referenced), Fragment C §4.9, Fragment E §10.12, and same-fragment §11.13. Expect Coupling Summary to run **~80 lines** (calibrated up from ~60).
**Estimated scope:** Medium-large — authors ~540 lines across 3 sections: §11 Transponder + ADS-B (~250 — the largest single section in Fragment F; 14 sub-sections), §12 Audio/Alerts/Annunciators (~110 — 9 sub-sections including XPDR Annunciations replacing COM Annunciations), §13 Messages (~180 — 13 sub-sections including XPDR Advisories replacing COM Radio Advisories and GNX 375 Traffic Advisories). Plus fragment header, Coupling Summary (~80 lines).
**Task type:** docs-only (no code, no tests)
**CRP applicability:** Not required by default. ~540-line docs output; single-file; no large intermediate artifacts. CC may opt in if mid-authoring suggests compaction risk (e.g., if §11 alone pushes past 350 lines).

---

## Source of Truth (READ ALL OF THESE BEFORE AUTHORING ANY SPEC BODY CONTENT)

### Tier 1 — Authoritative content source

1. **`docs/specs/GNX375_Functional_Spec_V1_outline.md`** — **THE PRIMARY BLUEPRINT.** For C2.2-F, authoritative content comes from:
   - **§11 Transponder + ADS-B Operation** (~200 outline lines, 14 sub-sections 11.1–11.14) — Overview, Control Panel, Setup Menu, Modes, Squawk Code Entry, VFR Key + IDENT, Status Indications, Extended Squitter (ADS-B Out), Flight ID, Remote G3X Touch (out of v1 scope), ADS-B In (built-in dual-link), Failure/Alert, Advisory Messages (9 conditions), Persistent State (cross-ref §14).
   - **§12 Audio, Alerts, and Annunciators** (~100 outline lines, 9 sub-sections 12.1–12.9) — Alert Type Hierarchy, Annunciator Bar, Pop-up Alerts, Aural Alerts (GNX 375 TSAA), GPS Status Annunciations, GPS Alerts, Traffic Annunciations (cross-ref §4.9), Terrain Annunciations (cross-ref §4.9), XPDR Annunciations (replaces COM Annunciations).
   - **§13 Messages** (~150 outline lines, 13 sub-sections 13.1–13.13) — Message System Overview, Airspace Advisories, Database Advisories, Flight Plan Advisories, GPS/WAAS Advisories, Navigation Advisories, Pilot-Specified Advisories, System Hardware Advisories, XPDR Advisories (replaces COM Radio Advisories), Terrain Advisories, Traffic System Advisories (GNX 375 built-in framing — distinct from GPS 175/GNC 355 external-LRU messages), VCALC Advisories, Waypoint Advisories.

   **Do not deviate from the outline's section numbering, sub-structure, or page references.** The outline is the contract; this task expands it into prose.

2. **`docs/decisions/D-18-c22-format-decision-piecewise-manifest.md`** — format contract. Re-read §"Fragment file conventions" and §"Coupling summary convention" before authoring.

3. **`docs/decisions/D-19-fragment-prompt-line-count-expansion-ratio.md`** — line-count authority. Target: **~540 lines** for Fragment F (per-task table in D-19). Acceptable band ~485–720. Soft ceiling ~650. **Series overage baseline ~20–30% is expected; E was +82% because §10 had 13 dense sub-sections each with PDF-sourced tables. Fragment F's §11 has 14 sub-sections but most are shorter (Flight ID, Remote G3X Touch, Persistent State cross-ref are each <15 lines). Expect actual ~600–700 lines.**

4. **`docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`** — **Fragment A authoritative backward-reference source.** Relevant for Fragment F:
   - **Appendix B glossary terms** — Fragment F will reference many: FIS-B, UAT, 1090 ES, Extended Squitter, TSAA, Mode S, TIS-B, WOW, IDENT, Flight ID, Target State and Status, TSO-C112e, TSO-C166b, Connext, RAIM, SBAS, WAAS, GPSS. **Phase F ITM-08 grep-verify applies** — do not claim terms not present in Appendix B.
   - §1 framing — GNX 375 baseline, Mode S Level 2els Class 1, 1090 ES ADS-B Out, built-in dual-link ADS-B In, sibling-unit distinctions (GPS 175 and GNC 355 have no XPDR, no ADS-B Out; need external hardware for ADS-B In).
   - §2 physical controls — tap/menu navigation referenced in §11.2 XPDR Control Panel access.
   - §3 SD card framing — no direct Fragment F coupling.

5. **`docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`** — **Fragment B authoritative backward-reference source.** Relevant for Fragment F:
   - §4.1 Home page + XPDR app icon on Home — §11.2 XPDR Control Panel access begins from Home > XPDR icon.
   - §4.3 FPL page context — no direct Fragment F coupling beyond general navigation model.
   - No §4 re-authoring in Fragment F.

6. **`docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md`** — **Fragment C authoritative backward-reference source. Critical for Fragment F.**
   - **§4.9 Hazard Awareness — FIS-B + Traffic + TSAA**: authoritative source for FIS-B data types, Traffic display, and TSAA framing. §11.11 ADS-B In cross-refs §4.9 for all display behavior. §12.4 Aural Alerts (TSAA aural) cross-refs §4.9 for the OPEN QUESTION 6 TSAA delivery mechanism. §12.7 Traffic Annunciations cross-refs §4.9 Traffic page. §13.11 Traffic System Advisories (GNX 375 framing) references §4.9 built-in receiver framing. **OPEN QUESTION 6 was preserved verbatim in Fragment C §4.9; Fragment F does NOT re-preserve it, only cross-refs.**
   - §4.10 Settings/System — referenced for §12 alert annunciator bar scale context and §12.5 GPS Status annunciations cross-ref to §10.11 (Fragment E) via §4.10.

7. **`docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md`** — **Fragment D authoritative backward-reference source.**
   - §7.2 GPS Flight Phase Annunciations — Fragment D's 11-row annunciation table is the source Fragment F §12.2 annunciator-bar flight-phase slot must remain consistent with (no re-tabulation needed; cross-ref).
   - §7.9 XPDR + ADS-B Approach Interactions — §11.4 XPDR Modes and §11.11 ADS-B In each cross-ref §7.9 for approach-phase interaction detail. Fragment D's §7.9 was the first place the three-modes framing appeared; Fragment F §11.4 is the full definition.
   - §7.8 Autopilot Outputs — no direct Fragment F coupling.

8. **`docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md`** — **Fragment E authoritative backward-reference source. Critical for Fragment F.**
   - **§10.12 ADS-B Status** (lines 700–751): the settings-page operational workflow for ADS-B Status. §11.11 ADS-B In in Fragment F describes the receiver hardware + data-reception behavior; §10.12 is the settings-page where pilots view that status. They must be consistent: built-in dual-link framing, no external LRU, Traffic Application Status sub-page with AIRB/SURF/ATAS(TSAA), FIS-B WX Status sub-page.
   - §10.13 Logs — §11 and §13 both reference GNX 375 ADS-B traffic logging; must match §10.13 framing (GNX 375-only ADS-B traffic log; WAAS diagnostic log all-units).
   - §10.1 CDI On Screen — no direct Fragment F coupling.
   - §10.5 Alerts Settings — §12.2 Annunciator Bar alert-level color semantics cross-ref (no re-tabulation).

9. **`docs/specs/GNX375_Functional_Spec_V1.md`** — the fragment manifest. Confirm Fragment F manifest entry (order 6, covers §§11–13, target 540) matches your output path.

### Tier 2 — PDF source material (authoritative for content details)

10. **`assets/gnc355_pdf_extracted/text_by_page.json`** — primary PDF source. For C2.2-F, the relevant pages:
    - **§11 Transponder + ADS-B**: pp. 18–20 (family/feature framing for §11.1 Overview), pp. 75 (XPDR Control Panel — §11.2), 76 (XPDR Setup Menu — §11.3; Flight ID — §11.9), 77 (Extended Squitter — §11.8), 78 (Three XPDR modes table — §11.4 — **primary source for D-16 three-modes framing and WOW automatic handling**), 79 (Squawk Code Entry — §11.5), 80 (VFR Key + IDENT 18-second framing — §11.6), 81 (Status Indications — §11.7), 82 (Remote G3X Touch + XPDR Failure/Alert — §11.10, §11.12), 102 (XPDR software version note — §11.1 context and §13.8), 225 (ADS-B In built-in receiver framing — §11.11; also Fragment C §4.9 source), 244 (FIS-B reception status — cross-ref §11.11), 282–284 (XPDR/ADS-B Out advisories — §11.13 and §13.9), 290 (GNX 375 traffic/ADS-B In advisories — §11.13 and §13.11).
    - **§12 Audio/Alerts/Annunciators**: pp. 98 (Alert Type Hierarchy — §12.1), 99 (Annunciator Bar — §12.2), 100 (Pop-up Alerts — §12.3), 101 (Aural Alerts — §12.4 — **GNX 375 TSAA aural framing here**), 104–106 (GPS Status Annunciations — §12.5; GPS Alerts — §12.6; also Fragment E §10.11 source), 254 (Traffic Annunciations table — §12.7 cross-ref only; authoritative source is Fragment C §4.9), 268–269 (Terrain Annunciations — §12.8 cross-ref only; authoritative source is Fragment C §4.9).
    - **§13 Messages**: pp. 271 (Section 6 Messages header — sparse; see §13.1 Message System Overview), 272 (Message System Overview — §13.1), 273 (Airspace Advisories — §13.2), 274 (Database Advisories — §13.3), 275–276 (Flight Plan Advisories — §13.4), 277–278 (GPS/WAAS Advisories — §13.5), 279–280 (Navigation Advisories — §13.6; Pilot-Specified Advisories — §13.7), 281–285 (System Hardware Advisories — §13.8; 282–284 overlap with §11.13), 287 (Terrain Advisories — §13.10), 288–289 (GPS 175/GNC 355 Traffic Advisories — **informational only, for §13.11 contrast**; GNX 375 uses p. 290 message set), 290 (GNX 375 Traffic/ADS-B In Advisories — §13.11 primary source), 291 (VCALC Advisories — §13.12; Waypoint Advisories — §13.13).

11. **`assets/gnc355_pdf_extracted/extraction_report.md`** — extraction quality notes. Fragment A's Appendix C already documents sparse pages. **Relevant for Fragment F:** p. 271 is sparse (Section 6 Messages header — TOC only; content on subsequent pages). p. 292 is sparse ("INTENTIONALLY LEFT BLANK"). No content gap for Fragment F scope — all message detail pages (272–291) are clean.

### Tier 3 — Cross-reference context

12. **`docs/knowledge/355_to_375_outline_harvest_map.md`** — harvest categorization for §§11–13:
    - §11: [NEW — XPDR + ADS-B replaces GNC 355's §11 COM Radio wholesale]
    - §12: [PART — §12.4 aural alerts reframed to present on GNX 375 via TSAA; §12.9 replaces COM Annunciations with XPDR Annunciations]
    - §13: [PART — §13.9 replaces COM Radio Advisories with XPDR Advisories; §13.11 reframed for GNX 375 built-in receiver]

13. **`docs/knowledge/amapi_by_use_case.md`** — A3 use-case index. Relevant for Fragment F: §1 (dataref subscribe — XPDR code/mode/reply, ADS-B state, GPS status for §12.5, alert states); §2 (command dispatch — XPDR mode set, squawk code set, IDENT, ADS-B Out toggle, VFR code set); §7 (Txt_add/Txt_set — squawk code display, data field, annunciator text, advisory message text); §11 (Persist_add — XPDR code, mode, Flight ID, ADS-B Out state per §11.14); §12 (User_prop_add — no direct §11–§13 use).

14. **`docs/knowledge/amapi_patterns.md`** — B3 pattern catalog. Outline cites:
    - Pattern 1 (triple-dispatch button/dial) — §11.6 IDENT, §11.4 mode selection, §11.5 squawk code entry, §11.8 ADS-B Out toggle (XPL + MSFS + FS2024 B if applicable)
    - Pattern 2 (multi-variable bus) — §11.7 Status Indications (code + mode + reply + IDENT + failure state on one bus); §10.11 GPS Status (cross-ref)
    - Pattern 6 (power-state group visibility) — §12.2 Annunciator Bar (alert visibility by power/alert state)
    - Pattern 14 (parallel XPL + MSFS subscriptions) — §11.11 ADS-B In (substantial dataref differences between sims)
    - Pattern 16 (sound on state change) — §12.4 Aural Alerts (TSAA aural delivery; also advisory message tones)
    - Pattern 17 (annunciator visible for state) — §11.7 XPDR status states, §12.9 XPDR Annunciations, §12.2 Annunciator Bar
    - Pattern 23 (FS2024 B: event dispatch) — §15 equivalent; §11 notes FS2024 B XPDR event dispatch may apply (forward-ref to §15)

15. **`docs/decisions/D-15-gnx375-display-architecture-internal-vs-external-turn-20-research.md`** — informational; no §11–§13 direct prose consequence, but §12.4 aural alerts framing is GNX 375-specific and ties to D-15's "built-in capabilities on GNX 375 vs. external on siblings" pattern.

16. **`docs/decisions/D-16-gnx375-xpdr-adsb-scope-corrections-turn-21-research.md`** — **PRIMARY FRAMING AUTHORITY for Fragment F.** Re-read in full before authoring. Key decisions:
    - **Three XPDR modes only**: Standby, On, Altitude Reporting (no Ground, no Test pilot-UI mode, no Anonymous mode — Anonymous is a GPS 175/GNC 355 + GDL 88 feature that does NOT apply to GNX 375).
    - **WOW state handled automatically** per p. 78 — no pilot mode change required on landing/takeoff.
    - **Built-in dual-link ADS-B In**: 1090 ES (for traffic) + 978 MHz UAT (for FIS-B weather/UAT traffic). No external LRU required. GPS 175 / GNC 355 require external GDL 88 or GTX 345.
    - **TSAA = GNX 375 only** (aural alerts; GPS 175 / GNC 355 have ADS-B traffic display without TSAA aural).
    - **ADS-B traffic logging = GNX 375 only** (not on GPS 175 / GNC 355).
    - **Remote G3X Touch out of v1 scope** (§11.10).

17. **`docs/decisions/D-21-multi-fragment-sequential-drafting-discipline.md`** — drafting discipline (informational; governs why this prompt is drafted now, not earlier).

18. **`docs/todos/issue_index.md`** — **read ITM-08 and ITM-10 in full before authoring.**
    - **ITM-08**: Coupling Summary glossary-ref grep-verify — Phase G hard constraint. Discipline validated three times (Fragments D, E, compliance reports). Continue.
    - **ITM-10 (new as of 2026-04-23)**: Fragment C §4.10 vs. PDF p. 94 Unit Selections discrepancy — low-severity watchpoint; **NOT a Fragment F constraint** but worth awareness. Fragment F does not touch Unit Selections.

19. **`docs/tasks/completed/c22_e_prompt.md`** — **most recent structural template.** Use the same section structure, YAML front-matter format, heading-level conventions, Coupling Summary block format (with ~80-line budget calibrated up from ~60), and self-review checklist pattern. Do **not** copy the content — scope and hard constraints are different. Fragment F has **16 hard constraints** (more than E's 14 because §11 is the signature XPDR section and has multiple D-16 specific constraints).

20. **`docs/tasks/completed/c22_e_compliance.md`** — **review before starting.** The 36-item compliance rubric is the likely Phase 2 standard for Fragment F. Key patterns to emulate: Phase G grep-verify for ITM-08 (continue to work); S13-pattern watchpoint (apply to any §11–§13 sub-section where outline and PDF may disagree).

21. **`CLAUDE.md`** (project conventions, commit format, ntfy requirement)
22. **`claude-conventions.md`** §Git Commit Trailers (D-04)

**Audit level:** standard — CD will check completions and run a compliance verification modeled on the C2.2-E approach (~35–40-item check across F / S / X / C / N categories — slightly larger than E's 36 because §11 is the densest single section in the series). Compliance bar consistent with C2.2-A through C2.2-E.

---

## Pre-flight Verification

**Execute these checks before authoring any fragment content. If any fails, STOP and write `docs/tasks/c22_f_prompt_deviation.md`.**

1. Verify Tier 1 source files exist:
   ```bash
   ls docs/specs/GNX375_Functional_Spec_V1_outline.md
   ls docs/decisions/D-18-c22-format-decision-piecewise-manifest.md
   ls docs/decisions/D-19-fragment-prompt-line-count-expansion-ratio.md
   ls docs/decisions/D-16-gnx375-xpdr-adsb-scope-corrections-turn-21-research.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md
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

8. Verify Fragment E integrity (829 lines expected):
   ```bash
   wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md
   ```

9. Verify `text_by_page.json` structural integrity on key pages (saved `.py` script per D-08):
   Write a short Python script that reads the JSON and prints char counts for key pages: 18–20 (overview), 75–82 (XPDR core pages — ALL must be non-trivial), 98–101 (alerts core pages), 102 (XPDR software version), 104–106 (GPS status for §12.5), 225 (ADS-B In), 244 (FIS-B reception), 254 (Traffic annunciations), 268–269 (Terrain annunciations), 272 (message overview), 273–280 (advisory detail pages), 281–285 (system hardware), 287 (terrain advisories), 288–290 (traffic advisories), 291 (VCALC + Waypoint advisories). All should have non-trivial character counts.

10. Verify no conflicting fragment output exists:
    ```bash
    ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md 2>/dev/null
    ```
    Expect failure. If the file exists, STOP and note in deviation report.

---

## Phase 0: Source-of-Truth Audit

Before authoring any spec body content:

1. Read all Tier 1 documents in full (outline §§11–13, D-14, D-15, **D-16 in full — this is the primary authority for §11**, D-18, D-19, Fragment A, Fragment B, Fragment C, Fragment D, Fragment E).
2. Read Fragments A, B, C, D, **and E in full** — not just the sub-sections directly cited. Fragment E is the newest and establishes the ADS-B Status operational workflow (§10.12) that §11.11 ADS-B In must be consistent with.
3. **Read ITM-08 in `docs/todos/issue_index.md` in full.** Phase G hard constraint. (ITM-09 resolved, ITM-10 is a Fragment C watchpoint — not a Fragment F concern.)
4. Read PDF pages listed in outline sub-section `[pp. N]` citations. Particular attention to:
   - **p. 78 — XPDR modes table.** This is the primary source for §11.4 three-modes framing and the "air/ground state handled automatically" framing. Read this page carefully. Verify: 3 modes present (Standby, On, Altitude Reporting); Ground mode is NOT on this page; Test mode is NOT on this page; Anonymous mode is NOT on this page (Anonymous is a GPS 175/GNC 355 + GDL 88 feature, confirmed by D-16 + p. 84 which is about GDL 88 integration).
   - **p. 75 — XPDR Control Panel layout.** Five labeled UI regions per outline. Verify all 5 are PDF-confirmed.
   - **p. 76 — XPDR Setup Menu.** Three menu items per outline. Verify PDF-accuracy.
   - **p. 77 — Extended Squitter.** ADS-B Out toggle detail.
   - **p. 78 — XPDR Modes.** Re-read.
   - **p. 79 — Squawk Code Entry.** Eight entry keys (0–7, ATCRBS 0000–7777 octal). Special codes (1200, 7500, 7600, 7700) informational-only per outline.
   - **p. 80 — VFR Key + IDENT.** IDENT 18-second duration. One-tap VFR preprogrammed code.
   - **p. 81 — Status Indications.** Four distinct visual states per outline.
   - **p. 82 — Remote G3X Touch + XPDR Failure.** Out-of-v1-scope for remote control; failure = red "X" over IDENT key.
   - **p. 101 — Aural Alerts.** GNX 375 TSAA aural framing. Mute function = current alert only, not future alerts.
   - **pp. 282–284 — XPDR/ADS-B Out advisories.** Four advisory conditions for §11.13 and §13.9.
   - **p. 290 — GNX 375 Traffic/ADS-B In advisories.** Five advisory conditions for §11.13 and §13.11. Contrast with pp. 288–289 which are GPS 175/GNC 355 + GDL 88 LRU failures — **NOT applicable to GNX 375**. Do NOT claim those messages for GNX 375.
5. Read `docs/knowledge/355_to_375_outline_harvest_map.md` §§ covering §§11–13.
6. **Re-read D-16 in full.** Confirm all D-16 framing decisions are internalized before authoring §11.4 modes, §11.11 ADS-B In, §11.10 Remote G3X Touch scope, §13.11 Traffic advisories.

**Definition — Actionable requirement:** A statement in the outline or an authorizing decision that, if not reflected in the fragment, would make the fragment incomplete relative to what C2.2-G depends on. Includes: operational-workflow contracts that Fragment G §14 Persistent State and §15 External I/O reference, ITM-08's Coupling Summary grep-verify, D-16 framing (three modes, built-in ADS-B, TSAA GNX 375 only, ADS-B traffic log GNX 375 only, Remote G3X Touch out of v1), D-14 procedural-fidelity items (§13.9 nine XPDR advisory enumeration), open-question preservation (OPEN QUESTIONS 4, 5, 6 — XPL dataref names, MSFS SimConnect variables, TSAA aural delivery mechanism).

7. Extract actionable requirements. Particular attention to:

   **§11 Transponder + ADS-B Operation (14 sub-sections):**
   - §11.1 Overview: TSO-C112e Level 2els Class 1; 1090 ES integrated (not separate transmitter); dual-link ADS-B In (1090 ES + 978 MHz UAT); external altitude source (ADC/ADAHRS via altitude encoder per p. 34 Fragment A framing); XPDR Control Panel access.
   - §11.2 XPDR Control Panel: 5 UI regions (Squawk Code Entry Field, VFR Key, XPDR Mode Key, Squawk Code Entry Keys 0–7, Data Field); XPDR key visibility rules.
   - §11.3 XPDR Setup Menu: 3 menu items (Data Field toggle pressure-altitude vs. Flight ID; 1090 ES ADS-B Out enable if configured; Flight ID assignment if editable).
   - §11.4 XPDR Modes: **THREE MODES ONLY** (Standby / On / Altitude Reporting per D-16). Mode characteristics table. Altitude Reporting note: air/ground handled automatically per p. 78. Reply (R) symbol in On + Altitude Reporting.
   - §11.5 Squawk Code Entry: 0–7 keypad (ATCRBS 0000–7777 octal); backspace or outer knob for cursor; unentered digits = underscores; Enter confirms; Cancel exits. Special codes informational-only (1200 VFR; 7500/7600/7700 emergency — no preset buttons).
   - §11.6 VFR Key + IDENT: VFR key = one-tap preprogrammed VFR code (1200 default; configurable at installation). IDENT = tap XPDR key from control panel → 18-second ATC-distinguishing-signal. Tap from another page opens control panel (not IDENT).
   - §11.7 Transponder Status Indications: 4 distinct visual states (IDENT active unmodified, IDENT with new code, Standby, Altitude Reporting). Tap behaviors per state.
   - §11.8 Extended Squitter (ADS-B Out): 1090 MHz integrated transmission; toggle via XPDR Setup Menu if configured; ON = ADS-B Out messages + position actively transmitted; transmitted content = GPS position + pressure altitude (ALT mode only) + Mode S squitter.
   - §11.9 Flight ID: usually installer-configured (not pilot-editable); if editable, alphanumeric uppercase 8-char max. Displays in data field when data-field = Flight ID mode. Remote editability via G3X Touch (out of scope for v1).
   - §11.10 Remote Control via G3X Touch: **OUT OF SCOPE FOR V1.** Document as "available on real GNX 375; not implemented in v1 Air Manager instrument." G3X Touch can control squawk code, mode, IDENT, ADS-B transmission, Flight ID.
   - §11.11 ADS-B In (Built-in Dual-link Receiver): 1090 ES (traffic) + 978 UAT (FIS-B + UAT traffic); no external receiver required (unlike GPS 175/GNC 355 which need GDL 88 or GTX 345); drives FIS-B page + Traffic Awareness page + TSAA (§4.9 Fragment C); operates in all three XPDR modes; TIS-B participant status: On + ALT modes only, NOT Standby. Cross-ref §4.9 for display pages and §10.12 (Fragment E) for operational settings workflow.
   - §11.12 XPDR Failure/Alert: red "X" over IDENT key on failure; advisory messages (cross-ref §11.13, §13); control page unavailable during failure; display auto-returns to previous page if failure occurs while control panel active. Specific failure: "GNX 375 ADS-B interboard communication failure" advisory [p. 82].
   - §11.13 XPDR Advisory Messages: **NINE distinct advisory conditions** applicable to GNX 375. From pp. 283–284 (XPDR/ADS-B Out): 1. "ADS-B Out fault. Pressure altitude source inoperative or connection lost." 2. "Transponder has failed." 3. "Transponder is operating in ground test mode." 4. "ADS-B is not transmitting position." From p. 290 (GNX 375 traffic/ADS-B In): 5. "1090ES traffic receiver fault." 6. "ADS-B traffic alerting function inoperative." 7. "ADS-B traffic function inoperative." 8. "Traffic/FIS-B functions inoperative." 9. "UAT traffic/FIS-B receiver fault." Cross-ref §13.9 and §13.11 for message-system context. Total: 9. Do NOT expand to 10+ by adding GPS 175/GNC 355 GDL 88-related advisories — those are not GNX 375 messages.
   - §11.14 XPDR Persistent State: squawk code, mode, Flight ID (if configurable), ADS-B Out enable, data field preference — all retained across power cycles. Forward-ref §14 (Fragment G) for persistence encoding schema.

   **§12 Audio, Alerts, and Annunciators (9 sub-sections):**
   - §12.1 Alert Type Hierarchy: Warning (red, immediate action), Caution (yellow, timely action), Advisory (white/amber, awareness).
   - §12.2 Alert Annunciations (Annunciator Bar): abbreviated at bottom of screen; color matches level; warnings white-on-red, cautions black-on-yellow, advisories white. FROM/TO field (p. 183) — pilot's authoritative TO/FROM reference. Flight phase annunciation slot (cross-ref §7.2 Fragment D 11-row table). CDI scale indicator slot (cross-ref §10.1 Fragment E).
   - §12.3 Pop-up Alerts: triggered by terrain/traffic warnings and cautions; appears only if alerted function's page is not already active; pop-up window with alert details; pilot acknowledgment required.
   - §12.4 Aural Alerts: **AURAL ALERTS PRESENT ON GNX 375 via TSAA** (D-16 — GNX 375 only). Mute function = current alert only; does not mute future alerts. **OPEN QUESTION 6 cross-ref** to §4.9 (Fragment C) for delivery mechanism design-phase decision. Do NOT re-preserve OPEN QUESTION 6 verbatim.
   - §12.5 GPS Status Annunciations: satellite signal strength bars (up to 15 SVIDs); GPS annunciations (ACQUIRING, 3D NAV, 3D DIFF NAV, LOI, GPS FAIL); SBAS/WAAS annunciations (LPV capability, provider selection). Cross-ref §10.11 (Fragment E) for operational GPS Status page.
   - §12.6 GPS Alerts: LOI (integrity not meeting requirements → yellow); GPS Fail (receiver or WAAS board failure).
   - §12.7 Traffic Annunciations: **CROSS-REF ONLY** to §4.9 Traffic Awareness (Fragment C) for full annunciation table. Do NOT re-tabulate.
   - §12.8 Terrain Annunciations: **CROSS-REF ONLY** to §4.9 Terrain Awareness (Fragment C) for alert conditions. Do NOT re-tabulate.
   - §12.9 XPDR Annunciations (**replaces COM Annunciations from GNC 355**): squawk code display on XPDR Control Panel; mode indicator (SBY / ON / ALT — **three modes only per D-16**); Reply (R) indicator; IDENT active indicator (18-second state); failure indicator (red "X" over IDENT key). Cross-ref §11.7 for full status state enumeration.

   **§13 Messages (13 sub-sections):**
   - §13.1 Message System Overview: queue; view-once advisories; MSG key flashes for unread messages.
   - §13.2 Airspace Advisories: Class B/C/D/E, TFR, MOA, restricted; informational only.
   - §13.3 Database Advisories: unavailable, corrupt, expired, region not found.
   - §13.4 Flight Plan Advisories: FPL import failure, GDU disconnected, crossfill inoperative.
   - §13.5 GPS/WAAS Advisories: GPS receiver fail, WAAS board failure, position accuracy degraded.
   - §13.6 Navigation Advisories: course CDI/HSI mismatch; non-WGS84 waypoint.
   - §13.7 Pilot-Specified Advisories: custom reminders from Scheduled Messages (cross-ref §10.8 Fragment E).
   - §13.8 System Hardware Advisories: knob stuck; SD card log error; various LRU failure advisories; **transponder software version note (GNX 375 only)** per p. 102.
   - §13.9 XPDR Advisories (**replaces COM Radio Advisories from GNC 355**): Four advisory conditions sourced from pp. 283–284 — ADS-B Out fault/altitude source loss, transponder failure, ground test mode, position not transmitting. Cross-ref §11.13 for full condition descriptions. Do NOT repeat the full enumeration from §11.13 here; cross-ref.
   - §13.10 Terrain Advisories: terrain alerts inhibited; re-enable instruction.
   - §13.11 Traffic System Advisories — **GNX 375 framing: built-in receiver message set** (per p. 290). Five advisory conditions: 1090ES traffic receiver fault, ADS-B traffic alerting function inoperative, ADS-B traffic function inoperative, Traffic/FIS-B functions inoperative, UAT traffic/FIS-B receiver fault. **Distinct from GPS 175/GNC 355 traffic advisories at pp. 288–289 which reference GDL 88 LRU failures.** Cross-ref §11.13 items 5–9 for full detail. Note the distinction from sibling-unit message sets explicitly.
   - §13.12 VCALC Advisories: "Approaching top of descent" advisory (60 seconds before TOD).
   - §13.13 Waypoint Advisories: non-WGS84 waypoints in flight plan.

8. **Open-question preservation checklist:**
   - §11 overall: **OPEN QUESTION 4** (XPL XPDR dataref names — `sim/cockpit2/radios/actuators/transponder_code`, `transponder_mode`, and ADS-B-related datarefs require XPL datareftool verification during design) — PRESERVE; forward-ref §15 (Fragment G).
   - §11 overall: **OPEN QUESTION 5** (MSFS XPDR SimConnect variables — `TRANSPONDER CODE:1`, `TRANSPONDER IDENT`, `TRANSPONDER STATE` differ between FS2020 and FS2024; Pattern 23 may apply) — PRESERVE; forward-ref §15.
   - §11.10: Remote G3X Touch v1 exclusion — confirmed at design phase — PRESERVE as design-phase confirmation flag.
   - §11.11: ADS-B In data availability in simulators (XPL partial, MSFS limited) — PRESERVE as design-phase flag for simulator-specific degraded-mode behavior.
   - §12.4: **OPEN QUESTION 6** (TSAA aural alert delivery mechanism — direct `sound_play` vs. external audio panel dependency — spec-body design decision) — cross-ref §4.9 (Fragment C), do NOT re-preserve verbatim.
   - §13.9 and §13.11: no new open questions; content is PDF-complete.

9. If ALL requirements are covered by your planned fragment structure: print "Phase 0: all source requirements covered" and proceed to authoring.
10. If any requirement is uncovered: write `docs/tasks/c22_f_prompt_phase0_deviation.md` and STOP.

---

## Instructions

Produce the sixth fragment of the GNX 375 Functional Spec V1 body: operational workflows covering §§11–13 (Transponder + ADS-B Operation + Audio/Alerts/Annunciators + Messages). This is the **most-coupled fragment** in the series, and §11 is the GNX 375's signature feature section that wholesale replaces GNC 355's §11 COM Radio content.

**Primary output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md`

### Authoring strategy

Same as Fragments A/B/C/D/E: outline provides structural skeleton; task expands outline bullets into implementable prose while preserving structure, page references, and cross-references.

#### Authoring depth guidance

- **Scope paragraphs (per top-level section):** 2–4 sentences per top-level section (§11, §12, §13). State what the section is for, its key GNX 375-specific framing (critical for §11 which is wholesale-new; important for §12 which is reframed; important for §13 which adds two new sub-sections), and operational cross-refs.

- **Sub-section prose:** each outline bullet expands into a short block (5–25 lines typical). Preserve source-page citations inline.

- **Tables:** use tables where content is naturally tabular. Expected tables in Fragment F:
  - §11.1 Overview may include: GNX 375 vs. siblings feature matrix for XPDR/ADS-B (optional; could be inline prose + cross-ref Appendix A)
  - §11.2 XPDR Control Panel 5 UI regions (either table or labeled list; table is fine for clarity)
  - §11.3 XPDR Setup Menu 3 items (table or list)
  - §11.4 XPDR Modes characteristics table (3 rows: Standby / On / Altitude Reporting; columns: Reply Behavior, Altitude Inclusion, ADS-B In State, Bluetooth, TIS-B Participant Status)
  - §11.5 Squawk Code Entry keypad (may include special codes reference list; codes are informational, not preset buttons)
  - §11.7 Status Indications 4-state table (State / Reply Status / Code Status / IDENT Status / Tap Behavior)
  - §11.8 ADS-B Out transmitted content list (bullets or compact list)
  - §11.13 Nine advisory messages (numbered list with source page + condition + cross-ref)
  - §12.1 Alert Type Hierarchy (3-row table: Warning / Caution / Advisory; columns: Color, Meaning, Pilot Action)
  - §12.2 Annunciator Bar slots (list or table: alert level slot, FROM/TO slot, flight phase slot, CDI scale slot)
  - §12.5 GPS Status Annunciations table (5 states)
  - §13.1 Message System Overview (brief; not tabular)
  - §13.8 System Hardware Advisories partial enumeration (brief; may cross-ref)
  - §13.11 GNX 375 Traffic Advisories (5-row table or numbered list)

- **S13-pattern watchpoint for Fragment F:** particular attention in:
  - **§11.2 XPDR Control Panel UI region labels** — verify against PDF p. 75 (5 regions).
  - **§11.4 Three-mode framing** — verify against PDF p. 78. If PDF shows anything additional beyond Standby/On/Altitude Reporting, flag it; per D-16 the spec is locked at three modes.
  - **§11.5 Special squawk codes** — verify "informational only, no preset buttons" against PDF p. 79 (do not imply preset buttons exist for 7500/7600/7700).
  - **§11.13 Advisory message text** — verify the exact text of the 9 advisories against pp. 283–284 and 290. Do not paraphrase key advisory text that pilots will see on-screen.
  - **§13.11 Traffic advisories** — verify 5-message set against p. 290. Do NOT include pp. 288–289 messages (those are GPS 175/GNC 355 external-LRU failures, not GNX 375).

- **AMAPI cross-refs:** at the end of each top-level section (§11, §12, §13), include an "AMAPI notes" block. Cite use-case sections (A3) and patterns (B3), don't expand. §11 AMAPI block will be the densest (multiple patterns apply).

- **Open questions / flags:** preserve every outline flag per the open-question preservation checklist above. §11 carries OPEN QUESTIONS 4 and 5 (XPL + MSFS dataref/variable names). §11.10 Remote G3X Touch flagged as v1 out-of-scope. §11.11 simulator-availability flagged. §12.4 cross-refs OPEN QUESTION 6 (Fragment C §4.9 verbatim preservation).

- **Cross-references:**
  - Backward-refs to Fragments A/B/C/D/E use "see §N.x" without fragment qualification (spec body is unified post-assembly)
  - Forward-refs to Fragment G use "see §N.x" without further qualification
  - **Intra-fragment cross-refs within Fragment F are common**: §11.7 ↔ §12.9 (XPDR status ↔ XPDR annunciations); §11.13 ↔ §13.9 (XPDR advisories ↔ XPDR advisories in message system); §11.13 ↔ §13.11 (XPDR traffic advisories ↔ Traffic System Advisories); §12.4 ↔ §13.9/§13.11 (aural alerts ↔ advisory messages that may trigger them). Use standard "see §N.x" notation; readers understand they're in the same fragment.

#### Fragment file conventions (per D-18)

- **Path:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md`
- **YAML front-matter (required):**
  ```yaml
  ---
  Created: 2026-04-24T{HH:MM:SS}-04:00
  Source: docs/tasks/c22_f_prompt.md
  Fragment: F
  Covers: §§11–13 (Transponder + ADS-B Operation, Audio/Alerts/Annunciators, Messages)
  ---
  ```
- **Heading levels:**
  - `# GNX 375 Functional Spec V1 — Fragment F` — fragment header (stripped on assembly)
  - `## 11. Transponder + ADS-B Operation (GNX 375 Only)` — top-level section header; **note the "(GNX 375 Only)" qualifier is appropriate and expected per outline**
  - `## 12. Audio, Alerts, and Annunciators` — top-level section header
  - `## 13. Messages` — top-level section header
  - `### 11.1 XPDR Overview and Capabilities [pp. 18–19, 75]` — sub-sections use `###`
  - `### 11.4 XPDR Modes [p. 78]` — critical sub-section
  - `### 11.11 ADS-B In (Built-in Dual-link Receiver) [pp. 18, 225]` — critical sub-section
  - `### 11.13 XPDR Advisory Messages [pp. 283–284, 290]`
  - `### 12.4 Aural Alerts [p. 101]`
  - `### 12.9 XPDR Annunciations`
  - `### 13.9 XPDR Advisories [pp. 283–284]`
  - `### 13.11 Traffic System Advisories [p. 290]`
  - Do NOT include harvest-category markers (`— [PART]`, `— [FULL]`, `— [NEW]`) in spec-body headings.
- **Line count target:** ~540 lines per D-19. Under-delivery (<485) suggests under-coverage; over-delivery (>720) warrants completion-report classification. Soft ceiling ~650. **Expect actual ~600–700 lines given §11 has 14 sub-sections.**

#### Specific framing commitments

These are **hard constraints** that must appear in the fragment. There are **16** for Fragment F (more than E's 14 because §11 has multiple D-16 specific constraints):

1. **ITM-08 Coupling Summary glossary-ref grep-verify — Phase G hard constraint.** Before finalizing the Coupling Summary, `grep` each Appendix B glossary term claimed as a backward-ref against `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`. Remove any terms not present in Appendix B from the Coupling Summary backward-refs list. **Specifically: do not claim EPU, HFOM/VFOM, HDOP, TSO-C151c as Appendix B entries** (these were established as absent from Appendix B in C2.2-C X17 and confirmed by C2.2-D F11 and C2.2-E C1). Discipline validated three times; maintain. Expected verified-present glossary terms that Fragment F will reference: Mode S (if present in B.1 additions; if not present, claim as informal), 1090 ES, UAT, Extended Squitter, FIS-B, TIS-B (if present), TSAA, WAAS, SBAS, RAIM, Connext, TSO-C112e, TSO-C166b, WOW, IDENT, Flight ID, Target State and Status (if present), GPSS, CDI, VDI. Verify each via grep before claiming.

2. **Coupling Summary ~80-line budget (calibrated up from ~60).** Fragment F has the densest cross-reference pattern in the series: §11 couples backward to Fragment A (Appendix B glossary + §1 framing), Fragment B (§4.1 Home XPDR icon), Fragment C (§4.9 Hazard Awareness), Fragment D (§7.2 flight phase, §7.9 XPDR approach), Fragment E (§10.12 ADS-B Status, §10.13 Logs), and forward-refs within same fragment (§12.4, §13.9, §13.11) and to Fragment G (§14 persistence, §15 external I/O for XPDR datarefs, §15.6 external CDI output). Budget expansion is justified; do not cut cross-refs to stay under ~60.

3. **§11 must NOT re-author §4.9 Hazard Awareness content (Fragment C authoritative).** §11.11 ADS-B In describes the **receiver hardware** (built-in dual-link, 1090 ES + 978 UAT, no external LRU); it does NOT re-author FIS-B data types, Traffic display, TSAA display behavior — all of which are Fragment C §4.9. Cross-ref §4.9 for display; §11.11 authors the receiver-side framing only.

4. **§11.11 must NOT re-author §10.12 ADS-B Status operational workflow (Fragment E authoritative).** §11.11 describes the ADS-B In receiver; §10.12 (Fragment E) authors the Settings/System page operational workflow for viewing ADS-B status (uplink time, FIS-B WX Status sub-page, Traffic Application Status sub-page with AIRB/SURF/ATAS states). Cross-ref §10.12; do not re-tabulate.

5. **§11.4 THREE MODES ONLY, per D-16.** §11.4 must state XPDR modes are Standby / On / Altitude Reporting — **no Ground mode, no Test mode in pilot UI, no Anonymous mode on GNX 375.** The mode characteristics table has exactly 3 rows. Air/ground state handled automatically per p. 78 — no pilot mode change required. This framing must be consistent with Fragment A §1, Fragment D §7.9, and Fragment E §10.12 Traffic Application Status sub-page. No prose in §11 may imply a fourth mode exists or that pilot must change modes based on WOW/air-ground state.

6. **§11.10 Remote G3X Touch OUT OF V1 SCOPE, per D-16.** §11.10 must state "available on real GNX 375; not implemented in v1 Air Manager instrument." Preserve the G3X Touch capability description (squawk, mode, IDENT, ADS-B Out toggle, Flight ID) for completeness but explicitly mark out-of-scope for v1. Forward-flag for design-phase confirmation.

7. **§11.11 BUILT-IN DUAL-LINK RECEIVER framing, per D-16.** §11.11 must consistently frame the ADS-B In receiver as: (a) built-in on GNX 375, no external LRU required; (b) dual-link — 1090 ES for traffic + 978 MHz UAT for FIS-B weather and UAT traffic; (c) operates in all three XPDR modes (not only in On/ALT); (d) TIS-B participant status active only in On + Altitude Reporting modes (NOT Standby). No prose may imply the GNX 375 requires an external GDL 88, GTX 345, or similar LRU for ADS-B In.

8. **§11.13 and §13.9 — EXACTLY 4 XPDR/ADS-B-Out advisories sourced from pp. 283–284.** The four messages are: "ADS-B Out fault. Pressure altitude source inoperative or connection lost."; "Transponder has failed."; "Transponder is operating in ground test mode."; "ADS-B is not transmitting position." Do NOT add, paraphrase, or omit. §13.9 cross-refs §11.13; §11.13 is the primary enumeration.

9. **§11.13 and §13.11 — EXACTLY 5 GNX 375 Traffic/ADS-B-In advisories sourced from p. 290.** The five messages are: "1090ES traffic receiver fault."; "ADS-B traffic alerting function inoperative."; "ADS-B traffic function inoperative."; "Traffic/FIS-B functions inoperative."; "UAT traffic/FIS-B receiver fault." Do NOT include advisories from pp. 288–289 — those are GPS 175/GNC 355 + GDL 88 LRU failures, NOT applicable to GNX 375. §13.11 must explicitly note this distinction from sibling-unit message sets.

10. **§11.13 total = 9 advisories** (4 from pp. 283–284 + 5 from p. 290). §11.13 authors the full enumeration; §13.9 references items 1–4; §13.11 references items 5–9.

11. **§12.4 AURAL ALERTS PRESENT ON GNX 375 (via TSAA), per D-16.** §12.4 must state aural alerts are available on GNX 375 through the TSAA traffic alerting application. Mute function = current alert only; does not mute future alerts. **OPEN QUESTION 6 cross-ref to §4.9 (Fragment C)** — do NOT re-preserve the verbatim OPEN QUESTION 6 text in §12.4. §12.4 acknowledges that aural delivery mechanism (`sound_play` direct vs. external audio panel dependency) is a design-phase decision and cross-refs §4.9 for the question.

12. **§12.9 XPDR ANNUNCIATIONS replaces GNC 355's COM Annunciations entirely.** No COM annunciation content in §12.9. Elements: squawk code display, mode indicator (SBY/ON/ALT — three modes only), Reply (R) indicator, IDENT active indicator, failure "X" indicator. Cross-ref §11.7 for full status state enumeration.

13. **§13.9 XPDR ADVISORIES replaces GNC 355's COM Radio Advisories entirely.** No COM advisory content in §13.9. Covers 4 XPDR/ADS-B Out conditions (cross-ref §11.13 items 1–4).

14. **No §4 re-authoring; no other-section re-authoring.** `grep -nE '^## 4\.|^### 4\.|^## [1-9]$|^## 10\.|^## 1[4-5]\.|^### (1|2|3|4|5|6|7|8|9|10|14|15)\.|^## Appendix' docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` — expect **0 matches**. Fragment F authors §§11–13 only. Forward-refs to §§14–15 appear only as prose cross-refs.

15. **No COM present-tense on GNX 375, anywhere in Fragment F.** §13.4 Flight Plan Advisories mentions GDU-related messages — these are informational about external displays, not COM. §13.8 System Hardware Advisories may reference LRU failures — verify all LRU references are either sibling-unit comparisons or GNX 375-specific (like the transponder software version note). `grep -ni 'COM radio\|COM standby\|COM volume\|COM frequency\|COM monitoring\|VHF COM' docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` — all matches must be sibling-unit comparison context or explicit "GNX 375 does not have a VHF COM radio" framing. Zero "the GNX 375 has [COM feature]" statements.

16. **Altitude source dependency framed consistently with D-15 and Fragment A §3.** §11 consistently frames XPDR pressure altitude source as **external** (from ADC/ADAHRS via altitude encoder input; see Fragment A §3 for SD/power-on framing, see Fragment C §4.10 for settings page, see §15 Fragment G for dataref contract). The GNX 375 does NOT compute pressure altitude internally. §11.1 Overview, §11.3 Setup Menu (pressure altitude display in data field), §11.4 Altitude Reporting mode, §11.8 Extended Squitter (pressure altitude when in ALT mode), §11.13 advisory #1 (ADS-B Out fault on altitude source loss), §13.9 advisory set — all must consistently reflect external altitude source.

#### Per-section page budget (informative)

| Section | Outline estimate | Fragment prose target |
|---------|------------------|------------------------|
| Fragment header + YAML | — | ~10 |
| §11 Transponder + ADS-B (14 sub-sections) | ~200 | ~280 |
| §12 Audio/Alerts/Annunciators (9 sub-sections) | ~100 | ~120 |
| §13 Messages (13 sub-sections) | ~150 | ~180 |
| Coupling Summary block | — | **~80** |
| **Total target** | **~450** | **~670** |

The 670 total is ~25% above the 540 D-19 target; this is within the series overage baseline. If actual output trends significantly above 720, classify in completion report. CC may proactively trim (e.g., condensing §12.2 Annunciator Bar slot description or §13 individual advisory sub-sections) to approach 540 more closely but is not required to.

#### Coupling Summary block

At the end of the fragment (after §13 content ends), include a **Coupling Summary** section per D-18. Use this template (calibrated to ~80 lines):

```markdown
---

## Coupling Summary

This section is authored per D-18 for CD/CC coordination across the 7-fragment spec. It is not part of the spec body and is stripped on assembly. Fragment F is the most-coupled fragment in the series; the backward-refs and forward-refs blocks are correspondingly denser.

### Backward cross-references (sections this fragment references authored in prior fragments)

- Fragment A §1 (Overview): GNX 375 baseline framing (Mode S Level 2els Class 1, TSO-C112e, 1090 ES ADS-B Out, built-in dual-link ADS-B In, sibling-unit distinctions) — referenced throughout §11; §11.1 Overview relies on §1 for product positioning.
- Fragment A §2 (Physical Layout & Controls): Home page + menu navigation — §11.2 XPDR Control Panel access begins from Home > XPDR icon.
- Fragment A §3 (Power-On / Startup / Database): external altitude source framing (ADC/ADAHRS via altitude encoder input, p. 34) — §11.1, §11.3, §11.4, §11.8, §11.13 advisory #1 all reference external altitude source.
- Fragment A Appendix B (Glossary): Terms verified present via grep before finalizing this list. **Verified-present terms claimed here:** [LIST after grep-verify; expected candidates: 1090 ES, UAT, Extended Squitter, FIS-B, TSAA, WAAS, SBAS, RAIM, Connext, TSO-C112e, TSO-C166b, WOW, IDENT, Flight ID, GPSS, CDI, VDI, Mode S (if present in B.1 or B.1 additions), TIS-B (if present), Target State and Status (if present)]. **NOT claimed (absent from Appendix B per C2.2-C X17, C2.2-D F11, C2.2-E C1):** EPU, HFOM, VFOM, HDOP, TSO-C151c.
- Fragment B §4.1 (Home Page): XPDR app icon on Home — §11.2 access.
- Fragment C §4.9 (Hazard Awareness — FIS-B + Traffic + TSAA): §11.11 ADS-B In cross-refs §4.9 for display pages (no re-authoring); §12.4 Aural Alerts cross-refs §4.9 for OPEN QUESTION 6 (TSAA aural delivery); §12.7 Traffic Annunciations cross-refs §4.9; §12.8 Terrain Annunciations cross-refs §4.9; §13.11 Traffic System Advisories references §4.9 built-in receiver framing.
- Fragment D §7.2 (GPS Flight Phase Annunciations): §12.2 Annunciator Bar flight phase slot — 11-row annunciation table authored in §7.2; §12.2 cross-refs.
- Fragment D §7.9 (XPDR + ADS-B Approach Interactions): §11.4 XPDR Modes and §11.11 ADS-B In cross-ref §7.9 for approach-phase interaction detail.
- Fragment E §10.11 (GPS Status): §12.5 GPS Status Annunciations cross-refs §10.11 for the full operational GPS Status page (satellite graph, EPU/HFOM/VFOM/HDOP fields, SBAS Providers, annunciations).
- Fragment E §10.12 (ADS-B Status): §11.11 ADS-B In cross-refs §10.12 for the operational settings workflow (uplink time display, FIS-B WX Status sub-page, Traffic Application Status sub-page AIRB/SURF/ATAS states).
- Fragment E §10.13 (Logs): §11 context and §13.8 System Hardware Advisories reference §10.13 for GNX 375-only ADS-B traffic log; WAAS diagnostic log all-units.
- Fragment E §10.5 (Alerts Settings): §12.2 Annunciator Bar alert-level color semantics context (no re-tabulation).
- Fragment E §10.8 (Scheduled Messages): §13.7 Pilot-Specified Advisories cross-refs §10.8 for message creation/modify/delete workflow.

### Forward cross-references (sections this fragment writes that later fragments will reference)

- §11.14 XPDR Persistent State → §14 Persistent State (Fragment G): squawk code, mode, Flight ID (if configurable), ADS-B Out enable state, data field preference persistence.
- §11 overall → §15 External I/O (Fragment G): XPDR code/mode/reply datarefs (XPL + MSFS); ADS-B Out state datarefs; IDENT command; Flight ID dataref (if editable). **OPEN QUESTIONS 4 and 5 forward-referenced.**
- §11.11 → §15 External I/O (Fragment G): ADS-B In receiver status datarefs; FIS-B reception datarefs; Traffic Application state datarefs.
- §11.4 Altitude Reporting, §11.8 Extended Squitter → §15.7 Altitude Source Dependency (Fragment G): external pressure altitude dataref contract.
- §12.2 Annunciator Bar FROM/TO slot + CDI scale slot → §15.6 External CDI/VDI Output Contract (Fragment G).
- §13.8 and §13 overall: system hardware advisories may reference §15 external interface datarefs for LRU status.

### Intra-fragment cross-references (within Fragment F)

- §11.7 Status Indications ↔ §12.9 XPDR Annunciations — status states rendered as annunciator elements.
- §11.13 XPDR Advisory Messages ↔ §13.9 XPDR Advisories (items 1–4, pp. 283–284).
- §11.13 XPDR Advisory Messages ↔ §13.11 Traffic System Advisories (items 5–9, p. 290).
- §12.4 Aural Alerts ↔ §13.9 / §13.11 — advisory messages may trigger aural alerts per TSAA; delivery mechanism cross-ref §4.9 OPEN QUESTION 6.

### Outline coupling footprint

This fragment draws from outline §§11–13 only. No content from §§1–10 (Fragments A + B + C + D + E), §§14–15, or Appendices A/B/C is authored here.
```

---

## Integration Context

- **Primary output file:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` (new)
- **Directory already exists:** `docs/specs/fragments/` contains part_A, part_B, part_C, part_D, part_E.
- **No code modification in this task.** Docs-only.
- **No test suite run required.** Docs-only.
- **Do not modify the outline.** If you spot outline errors during authoring (PDF-vs-outline discrepancies, S13-pattern opportunities), note them in the completion report's Deviations section and continue with the PDF-accurate content.
- **Do not modify Fragment A, Fragment B, Fragment C, Fragment D, or Fragment E.** All are archival.
- **Do not modify the manifest yet.** CD will update the manifest status entry for Fragment F after this task archives.

---

## Implementation Order

**Execute phases sequentially. Do not parallelize phases or launch subagents.**

### Phase A: Read and audit (Phase 0 per above)

Read all Tier 1 and Tier 2 sources. Read Fragments A, B, C, D, E in full. **Re-read D-16 in full.** **Read ITM-08 in full.** Extract actionable requirements. Confirm coverage of the open-question preservation checklist. Print the Phase 0 completion line OR write the Phase 0 deviation report and STOP.

### Phase B: Create fragment file skeleton

1. Create the fragment file at `docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` with YAML front-matter, fragment header (`# GNX 375 Functional Spec V1 — Fragment F`), and section headers (`## 11.`, `## 12.`, `## 13.`).
2. Add sub-section headers for §11 (11.1–11.14), §12 (12.1–12.9), §13 (13.1–13.13).
3. Add the Coupling Summary placeholder at the end.

### Phase C: Author §11 Transponder + ADS-B Operation (~280 lines)

Scope paragraph: GNX 375 signature feature (TSO-C112e Mode S Level 2els Class 1 + 1090 ES ADS-B Out + built-in dual-link ADS-B In); replaces GNC 355's §11 COM Radio wholesale; GPS 175 and GNC 355/355A lack XPDR and ADS-B Out entirely. Reference D-16 for scope framing.

Expand §§11.1–11.14 per Phase 0 enumeration:
- §11.1 Overview (~25 lines): product framing, compliance, capabilities, altitude source external, control panel access
- §11.2 XPDR Control Panel (~20 lines): 5 UI regions table; XPDR key visibility rules
- §11.3 XPDR Setup Menu (~15 lines): 3 menu items
- §11.4 XPDR Modes (~25 lines): 3-row characteristics table; WOW handled automatically; Reply (R) symbol
- §11.5 Squawk Code Entry (~20 lines): keypad + cursor/enter/cancel; special codes informational-only list
- §11.6 VFR Key + IDENT (~15 lines): VFR one-tap preprogrammed; IDENT 18-second from control panel; tap-from-other-page opens control panel (not IDENT)
- §11.7 Status Indications (~25 lines): 4-state table with tap behaviors
- §11.8 Extended Squitter (ADS-B Out) (~15 lines): 1090 MHz integrated; toggle via Setup Menu; ON = active transmission; content list
- §11.9 Flight ID (~10 lines): installer-configured default; editable if configured; data field display
- §11.10 Remote Control via G3X Touch (~15 lines): capabilities list; **v1 out-of-scope flag explicit**
- §11.11 ADS-B In — Built-in Dual-link Receiver (~25 lines): dual-link receiver; no external LRU (contrast GPS 175/GNC 355); drives FIS-B + Traffic + TSAA (cross-ref §4.9); operates in all three modes; TIS-B participant On/ALT only; simulator-availability flag
- §11.12 XPDR Failure/Alert (~10 lines): red "X"; advisory cross-refs; control page unavailable
- §11.13 XPDR Advisory Messages (~35 lines): numbered list of 9 (4 from pp. 283–284 + 5 from p. 290); source page + condition for each
- §11.14 XPDR Persistent State (~10 lines): persistence list; forward-ref §14

AMAPI notes block: Patterns 1, 2, 14, 16, 17, 23. Open questions 4, 5 preserved with §15 forward-ref; §11.10 v1 out-of-scope flag; §11.11 simulator-availability flag.

### Phase D: Author §12 Audio, Alerts, and Annunciators (~120 lines)

Scope paragraph: alert system — type hierarchy, annunciations, aurals (GNX 375 has aurals via TSAA), annunciator bar, pop-ups. §12.4 reframed to present on GNX 375 (not "GNX 375 only, not GNC 355"). §12.9 replaces COM Annunciations with XPDR Annunciations.

Expand §§12.1–12.9 per Phase 0 enumeration:
- §12.1 Alert Type Hierarchy (~15 lines): 3-row table (Warning / Caution / Advisory)
- §12.2 Annunciator Bar (~20 lines): slots (alert, FROM/TO cross-ref §7.H Fragment D, flight phase cross-ref §7.2 Fragment D, CDI scale cross-ref §10.1 Fragment E); color semantics; abbreviated text
- §12.3 Pop-up Alerts (~10 lines): terrain/traffic triggers; acknowledgment required
- §12.4 Aural Alerts (~20 lines): **GNX 375 TSAA aural**; mute current-alert-only; cross-ref §4.9 for OPEN QUESTION 6 (do NOT re-preserve verbatim); cross-ref §13.11 for aural-triggering advisory message set
- §12.5 GPS Status Annunciations (~15 lines): 5-state table; cross-ref §10.11 Fragment E for full page
- §12.6 GPS Alerts (~10 lines): LOI and GPS Fail conditions
- §12.7 Traffic Annunciations (~5 lines): cross-ref §4.9 Fragment C; no re-tabulation
- §12.8 Terrain Annunciations (~5 lines): cross-ref §4.9 Fragment C; no re-tabulation
- §12.9 XPDR Annunciations (~15 lines): squawk, mode (SBY/ON/ALT — **3 modes only**), Reply (R), IDENT active, failure "X"; cross-ref §11.7

AMAPI notes block: Patterns 6, 16, 17; use-case §7, §9.

### Phase E: Author §13 Messages (~180 lines)

Scope paragraph: advisory message system; categories; view-once with queue and MSG key flash. §13.9 replaces COM Radio Advisories with XPDR Advisories. §13.11 Traffic System Advisories reframed for GNX 375 built-in receiver message set (distinct from GPS 175/GNC 355 GDL 88 LRU failures).

Expand §§13.1–13.13 per Phase 0 enumeration:
- §13.1 Message System Overview (~10 lines): queue, MSG key flash, view-once
- §13.2 Airspace Advisories (~10 lines): Class B/C/D/E, TFR, MOA, restricted — informational
- §13.3 Database Advisories (~10 lines): unavailable, corrupt, expired, region not found
- §13.4 Flight Plan Advisories (~15 lines): FPL import failure, GDU disconnected, crossfill inoperative
- §13.5 GPS/WAAS Advisories (~15 lines): GPS fail, WAAS board failure, position degraded
- §13.6 Navigation Advisories (~10 lines): CDI/HSI mismatch, non-WGS84 waypoint
- §13.7 Pilot-Specified Advisories (~10 lines): custom reminders; cross-ref §10.8 Fragment E for Scheduled Messages workflow
- §13.8 System Hardware Advisories (~25 lines): knob stuck, SD card log error, various LRU failures, **transponder software version note GNX 375 only (p. 102)**
- §13.9 XPDR Advisories (~15 lines): 4 conditions; cross-ref §11.13 items 1–4; do NOT re-enumerate full text (cross-ref is sufficient for §13.9; full text in §11.13)
- §13.10 Terrain Advisories (~10 lines): inhibit/re-enable
- §13.11 Traffic System Advisories (~20 lines): **GNX 375 framing** — 5 conditions from p. 290; cross-ref §11.13 items 5–9; **explicit distinction from pp. 288–289 sibling-unit message sets (GDL 88 LRU failures NOT applicable to GNX 375)**
- §13.12 VCALC Advisories (~10 lines): "Approaching top of descent" 60-sec-before-TOD
- §13.13 Waypoint Advisories (~10 lines): non-WGS84 waypoints in FPL

AMAPI notes block: use-case §7 (Txt_add for message text); Pattern 17 (MSG key flash).

### Phase F: Author Coupling Summary (~80 lines)

Write the Coupling Summary block per the template above. **Execute ITM-08 grep-verify before writing:**
1. Open Fragment A (`docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`)
2. Locate Appendix B glossary
3. For each term you plan to claim as an Appendix B backward-ref (Mode S, 1090 ES, UAT, Extended Squitter, FIS-B, TSAA, TIS-B, WAAS, SBAS, RAIM, Connext, TSO-C112e, TSO-C166b, WOW, IDENT, Flight ID, Target State and Status, GPSS, CDI, VDI), `grep` the Appendix B section and confirm the term exists as a formal glossary entry
4. Remove any terms that do NOT appear as formal Appendix B entries from the backward-refs list
5. Document in the completion report which terms were verified-present and which were removed (if any) due to absence

Specifically exclude from the Fragment A Appendix B backward-refs list: EPU, HFOM/VFOM, HDOP, TSO-C151c (these are NOT formal glossary entries per C2.2-C X17, C2.2-D F11, C2.2-E C1).

### Phase G: Self-review

Before writing the completion report, perform the following self-checks (per D-08 — completion report claim verification):

1. **Line count:** `wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` — target ~540, soft ceiling ~650; acceptable band ~485–720.
2. **Character encoding:** `grep -c '\\u[0-9a-f]\{4\}' docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` — expect 0.
3. **Replacement chars:** Python check (saved `.py` file per D-08) to count U+FFFD bytes — expect 0.
4. **No §§1–10 or §§14–15 or Appendix headers authored:** `grep -nE '^## [1-9]$|^## 10\.|^## 1[4-5]\.|^### (1|2|3|4|5|6|7|8|9|10|14|15)\.|^## Appendix' docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` — expect **0 matches**.
5. **§11 has 14 sub-sections:** `grep -cE '^### 11\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` — expect **14**.
6. **§12 has 9 sub-sections:** `grep -cE '^### 12\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` — expect **9**.
7. **§13 has 13 sub-sections:** `grep -cE '^### 13\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` — expect **13**.
8. **§11.4 three modes only:** grep §11.4 for "Standby", "On", "Altitude Reporting". Verify **no** "Ground", "Test" (as pilot mode), or "Anonymous" mode content in §11.4 body. The 3-row mode table has exactly 3 rows.
9. **§11.10 v1 out-of-scope flag explicit:** grep §11.10 for "out of scope" or "not implemented in v1".
10. **§11.11 built-in dual-link framing:** grep §11.11 for "built-in" and "dual-link". No prose may imply external LRU required.
11. **§11.13 = 9 advisory conditions:** count advisory list items or table rows in §11.13 = exactly 9 (4 from pp. 283–284 + 5 from p. 290).
12. **§13.9 cross-refs §11.13 items 1–4:** grep §13.9 for cross-ref language pointing to §11.13 (items 1–4). No full advisory text re-enumeration in §13.9.
13. **§13.11 cross-refs §11.13 items 5–9 + distinguishes from pp. 288–289:** grep §13.11 for cross-ref to §11.13 (items 5–9) + explicit statement that GPS 175/GNC 355 + GDL 88 LRU messages (pp. 288–289) are NOT applicable to GNX 375.
14. **§12.4 TSAA aural on GNX 375:** grep §12.4 for "TSAA" and "aural". No prose claiming aural alerts are unavailable on GNX 375.
15. **§12.4 OPEN QUESTION 6 cross-ref only:** grep §12.4 for "§4.9" cross-ref and absence of verbatim "OPEN QUESTION 6" text block in §12.4 body (cross-ref is fine; verbatim re-preservation is not).
16. **§12.9 XPDR Annunciations replaces COM:** grep §12.9 for "XPDR", "squawk", "mode indicator", "Reply", "IDENT". No COM radio content.
17. **§13.9 XPDR Advisories replaces COM Radio Advisories:** grep §13.9 for "XPDR" and absence of "COM radio" content.
18. **No COM present-tense on GNX 375:** `grep -ni 'COM radio\|COM standby\|COM volume\|COM frequency\|COM monitoring\|VHF COM' docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` — all matches in sibling-unit comparison context or explicit "does not have VHF COM" framing.
19. **External altitude source framing consistent:** grep §11.1, §11.3, §11.4, §11.8, §11.13 for "external", "ADC", "ADAHRS", or "altitude encoder". Consistent framing — no prose implying GNX 375 computes pressure altitude internally.
20. **Page citation preservation:** sample 10 outline page citations and confirm each appears in the fragment at the corresponding sub-section:
    - `[p. 75]` at §11.2 XPDR Control Panel
    - `[p. 76]` at §11.3 XPDR Setup Menu and §11.9 Flight ID
    - `[p. 77]` at §11.8 Extended Squitter
    - `[p. 78]` at §11.4 XPDR Modes
    - `[p. 79]` at §11.5 Squawk Code Entry
    - `[p. 80]` at §11.6 VFR Key + IDENT
    - `[p. 81]` at §11.7 Status Indications
    - `[p. 82]` at §11.10 Remote G3X Touch and §11.12 XPDR Failure
    - `[pp. 283–284]` at §11.13 (items 1–4) and §13.9
    - `[p. 290]` at §11.13 (items 5–9) and §13.11
21. **YAML front-matter correct; fragment header "Fragment F":** grep-inspect line 1 (`---`) through first closing `---`; confirm `Fragment: F` and `Covers: §§11–13`. Fragment header `# GNX 375 Functional Spec V1 — Fragment F` present on line immediately after YAML.
22. **No harvest-category markers in `###` lines:** `grep -nE '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])' docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` — expect **0 matches**.
23. **Coupling Summary section present:** grep for `## Coupling Summary`; confirm backward-refs (A/B/C/D/E), forward-refs (G + intra-fragment), outline footprint note all present.
24. **ITM-08 grep-verify executed:** Appendix B backward-ref terms verified-present in Fragment A via grep before writing Coupling Summary. EPU, HFOM/VFOM, HDOP, TSO-C151c NOT claimed as Appendix B entries. List of verified-present terms documented in completion report.
25. **OPEN QUESTIONS 4, 5 preserved:** grep §11 for "§15" or "design phase" or "OPEN QUESTION 4" / "OPEN QUESTION 5" context (without re-preserving verbatim). §11 overall open-question block acknowledges XPL and MSFS dataref/variable names require design-phase research.

Report all 25 check results in the completion report.

---

## Completion Protocol

1. Write completion report to `docs/tasks/c22_f_completion.md` with this structure:

   ```markdown
   ---
   Created: {ISO 8601 timestamp}
   Source: docs/tasks/c22_f_prompt.md
   ---

   # C2.2-F Completion Report — GNX 375 Functional Spec V1 Fragment F

   **Task ID:** GNX375-SPEC-C22-F
   **Output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md`
   **Completed:** 2026-04-24

   ## Pre-flight Verification Results
   {table of the 10 pre-flight checks with PASS/FAIL}

   ## Phase 0 Audit Results
   {summary of actionable requirements confirmed covered; include open-question preservation checklist: OPEN QUESTIONS 4, 5 (XPL/MSFS dataref names); OPEN QUESTION 6 cross-ref (§12.4 → §4.9); §11.10 v1 out-of-scope; §11.11 simulator-availability}

   ## Fragment Summary Metrics
   | Metric | Value |
   |--------|-------|
   | Fragment file | `docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` |
   | Line count | {actual} |
   | Target line count | ~540 |
   | Soft ceiling | ~650 |
   | Acceptable band | ~485–720 |
   | Sections covered | §§11–13 |
   | §11 sub-section count | 14 (11.1–11.14) |
   | §12 sub-section count | 9 (12.1–12.9) |
   | §13 sub-section count | 13 (13.1–13.13) |
   | §11.13 advisory count | 9 (4 from pp. 283–284 + 5 from p. 290) |

   ## Self-Review Results (Phase G)
   {table of the 25 self-checks with PASS/FAIL and specifics}

   ## Hard-Constraint Verification
   {confirm each of the 16 framing commitments}

   ## ITM-08 Coupling Summary Grep-Verify Report
   {list of Appendix B terms you PLANNED to claim as backward-refs; list of terms CONFIRMED-PRESENT via grep (name each by Appendix B location — B.1, B.1 additions, B.2, B.3); list of terms REMOVED from the Coupling Summary because grep returned 0 matches in Fragment A Appendix B or terms reclassified as informal}

   ## D-16 Framing Verification
   {confirm for each D-16 decision: three modes only (§11.4); WOW automatic (§11.4 note); built-in dual-link ADS-B In (§11.11); TSAA aural GNX 375 (§12.4); ADS-B traffic log GNX 375 (§13.8 and §13.11 context); Remote G3X Touch v1 out-of-scope (§11.10)}

   ## S13-Pattern Instances (if any)
   {report any sub-section where outline and PDF disagreed and PDF was used; particular focus on §11.4 mode set, §11.5 special codes, §11.13 advisory text verbatim from PDF}

   ## Coupling Summary Preview
   {brief summary of backward-refs to Fragments A/B/C/D/E and forward-refs to Fragment G + intra-fragment}

   ## Deviations from Prompt
   {table of any deviations with rationale; if none, state "None"}
   ```

2. `git add -A`

3. `git commit` with the D-04 trailer format. Write the commit message to a temp file via `[System.IO.File]::WriteAllText()` (BOM-free):

   ```
   GNX375-SPEC-C22-F: author fragment F (§§11–13 XPDR + Alerts + Messages)

   Sixth of 7 piecewise fragments per D-18. Covers Transponder + ADS-B
   Operation (§11 — the GNX 375 signature feature, wholesale replaces
   GNC 355's §11 COM Radio), Audio/Alerts/Annunciators (§12 — with
   GNX 375-specific TSAA aural framing and XPDR Annunciations), and
   Messages (§13 — with XPDR Advisories and GNX 375 built-in Traffic
   System Advisories). Target: ~540 lines; actual: {N}.

   D-16 framing honored: three XPDR modes only (§11.4 Standby / On /
   Altitude Reporting — no Ground, no Test, no Anonymous); WOW handled
   automatically per p. 78 (§11.4); built-in dual-link ADS-B In
   receiver (§11.11 — no external LRU required); TSAA aural alerts on
   GNX 375 (§12.4); ADS-B traffic logging GNX 375 only (§13.8, §13.11);
   Remote G3X Touch v1 out-of-scope (§11.10).

   Honors ITM-08 discipline: Coupling Summary Appendix B backward-refs
   grep-verified against Fragment A before finalization. EPU,
   HFOM/VFOM, HDOP, TSO-C151c NOT claimed (absent from Appendix B per
   C2.2-C X17, C2.2-D F11, C2.2-E C1).

   §11.13 = 9 advisory conditions (4 from pp. 283–284 for XPDR/ADS-B
   Out + 5 from p. 290 for GNX 375 Traffic/ADS-B In). §13.9 cross-refs
   §11.13 items 1–4; §13.11 cross-refs §11.13 items 5–9 with explicit
   distinction from pp. 288–289 GPS 175/GNC 355 + GDL 88 LRU failures
   (NOT applicable to GNX 375). §12.4 OPEN QUESTION 6 cross-ref only
   (not re-preserved verbatim — Fragment C §4.9 is authoritative).
   OPEN QUESTIONS 4, 5 (XPL/MSFS XPDR dataref names) preserved for
   §15 (Fragment G).

   Task-Id: GNX375-SPEC-C22-F
   Authored-By-Instance: cc
   Refs: D-14, D-15, D-16, D-18, D-19, D-20, D-21, ITM-08, GNX375-SPEC-C22-A, GNX375-SPEC-C22-B, GNX375-SPEC-C22-C, GNX375-SPEC-C22-D, GNX375-SPEC-C22-E
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
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-F completed [flight-sim]"
   ```

6. **Do NOT git push.** Steve pushes manually.

---

## What CD will do with this report

After CC completes:

1. CD runs check-completions Phase 1: reads the prompt + completion report, cross-references claims against the fragment file, generates a compliance prompt modeled on the C2.2-E approach (~35–40-item check across F / S / X / C / N categories; likely slightly larger than E's 36 because §11 is the densest single section). The compliance prompt will verify the 25 self-checks plus ITM-08 grep-verify independent re-check plus PDF source-fidelity spot checks for key tables (§11.4 modes, §11.7 status indications, §11.13 advisory text verbatim, §13.11 traffic advisory set) plus D-16 framing verification.

2. After CC runs the compliance prompt: CD runs check-compliance Phase 2. PASS → archive all four files to `docs/tasks/completed/`; update manifest (Fragment F → ✅ Archived); **begin drafting C2.2-G per D-21** (gated on C2.2-F archive). PASS WITH NOTES → log any new ITMs if needed, archive, continue. FAIL → bug-fix task.

---

## Estimated duration

- CC wall-clock: ~15–25 min (LLM-calibrated per D-20: ~540-line docs-only fragment with heavy reuse of Fragments A/B/C/D/E conventions; baseline 500-line docs task = 10–20 min; scale 1.1× for line count; reuse ×0.7 discount applies; §11's 14 sub-sections + §13's 13 sub-sections + dense cross-references add ~5 min vs. baseline; ITM-08 grep-verify adds ~2 min; net ~15–25 min).
- CD coordination cost after this: ~1 check-completions turn + ~1 check-compliance turn + ~0.5 turn to update manifest + start C2.2-G prompt.

Proceed when ready.
