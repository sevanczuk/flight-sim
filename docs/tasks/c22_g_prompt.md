# CC Task Prompt: C2.2-G — GNX 375 Functional Spec V1 Fragment G (§§14–15 + Appendix A)

**Created:** 2026-04-24T10:51:26-04:00
**Source:** CD Purple session — Turn 21 (2026-04-24) — seventh and final of 7 piecewise fragments per D-18
**Task ID:** GNX375-SPEC-C22-G (Stream C2, sub-task 2G for the 375 primary deliverable)
**Parent reference:** `docs/decisions/D-18-c22-format-decision-piecewise-manifest.md` §"Task partition"
**Authorizing decisions:** D-11 (outline-first), D-12 (pivot to 375), D-14 (procedural fidelity), D-15 (no internal VDI — **§15.6 primary authority**), D-16 (XPDR + ADS-B scope — §14.1 + §15 relevance), D-18 (piecewise format + 7-task partition — **assembly readiness**), D-19 (fragment line-count expansion ratio — target ~300), D-20 (LLM-calibrated duration estimates), D-21 (sequential drafting — this prompt drafted after C2.2-F archived), D-22 (C3 spec review customization — implications for Coupling Summary expectations)
**Predecessor tasks:** C2.2-A through C2.2-F all archived (`docs/tasks/completed/c22_*`). All six are authoritative backward-reference sources.
**Depends on:** C2.2-A ✅, C2.2-B ✅, C2.2-C ✅, C2.2-D ✅, C2.2-E ✅, C2.2-F ✅, manifest at `docs/specs/GNX375_Functional_Spec_V1.md` (Fragment F status ✅ Archived).
**Priority:** Critical-path — **final fragment**; unblocks C2.2 aggregate-assembly + C3 spec review.
**Estimated scope:** Small-medium — authors ~300 lines across 3 major scopes:
- **§14 Persistent State** (~50 lines — 6 sub-sections, highly structured)
- **§15 External I/O** (~50 lines — 7 sub-sections; dataref/variable enumeration + OPEN QUESTIONS 4/5; D-15 §15.6 external CDI/VDI output contract)
- **Appendix A Family Delta** (~150 lines — 5 sub-sections; compact comparison of GNX 375 vs. GPS 175 vs. GNC 355/355A; D-12 pivot context)

Plus fragment header, Coupling Summary (~100 lines — **largest in series** because Fragment G is the closing fragment where every forward-ref from A–F lands).

**Task type:** docs-only (no code, no tests)
**CRP applicability:** Not required by default. ~300-line docs output; single file; no large intermediate artifacts.

---

## Source of Truth (READ ALL BEFORE AUTHORING ANY SPEC BODY CONTENT)

### Tier 1 — Authoritative content source

1. **`docs/specs/GNX375_Functional_Spec_V1_outline.md`** — **THE PRIMARY BLUEPRINT.** For C2.2-G, authoritative content comes from:
   - **§14 Persistent State** — 6 sub-sections (14.1–14.6): XPDR State (replaces COM State), Display and UI State, Flight Planning State, Scheduled Messages, Bluetooth Pairing, Crossfill Data
   - **§15 External I/O** — 7 sub-sections (15.1–15.7): XPL datarefs reads, XPL datarefs writes, XPL commands, MSFS variables reads, MSFS events writes, External CDI/VDI Output Contract (D-15), Altitude Source Dependency
   - **Appendix A Family Delta** — 5 sub-sections (A.1–A.5): Unit identification + D-12 context, GPS 175 vs. GNX 375 deltas, GNC 355/355A vs. GNX 375 deltas, GNX 375 variants, feature matrix

   **Do not deviate from the outline's section numbering, sub-structure, or page references.** The outline is the contract; this task expands it into prose.

2. **`docs/decisions/D-18-c22-format-decision-piecewise-manifest.md`** — format contract. §"Fragment file conventions", §"Coupling summary convention", §"Assembly readiness" (Fragment G is the assembly trigger per D-18).

3. **`docs/decisions/D-19-fragment-prompt-line-count-expansion-ratio.md`** — line-count authority. Target: **~300 lines** for Fragment G. Acceptable band ~270–450. Soft ceiling ~400.

   **Per manifest overage analysis:** Fragments A=+22%, B=+11%, C=+26%, D=+22%, E=+82%, F=+12%. Fragment G expected to land near +10–20% (like F) because scope is highly structured: §14 is a persistence enumeration; §15 is a dataref/variable enumeration; Appendix A is a compact feature comparison. The Coupling Summary is the primary inflation risk.

4. **All six archived fragments** — **read in full before authoring.** These are the sources Fragment G's Coupling Summary must correctly claim:
   - `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` (545 lines) — Appendix B glossary (for ITM-08 grep-verify), §1 framing, §2 physical controls, §3 power-on
   - `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` (799 lines) — §§4.1–4.6 display pages
   - `docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` (725 lines) — §§4.7–4.10, including §4.9 Hazard Awareness (OPEN QUESTION 6 source) and §4.10 Settings/System
   - `docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` (913 lines) — §§5–7 including §7.9 XPDR + ADS-B Approach Interactions + §7.B/§7.D/§7.G CDI cross-refs
   - `docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` (829 lines) — §§8–10 including §10.1 CDI On Screen, §10.11 GPS Status, §10.12 ADS-B Status, §10.13 Logs, §10.8 Scheduled Messages
   - `docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` (606 lines) — §§11–13 including §11.11 ADS-B In, §11.13 XPDR Advisory Messages, §11.14 Persistent State (§14.1 forward-ref target), §12.2 Annunciator Bar, §13.9, §13.11

### Tier 2 — PDF source material (authoritative for content details)

5. **`assets/gnc355_pdf_extracted/text_by_page.json`** — primary PDF source. For C2.2-G:
   - **§14 Persistent State**: pp. 58, 60, 63, 72, 97 (distributed persistence indications throughout manual); pp. 75–82 (XPDR state); p. 156 (FPL catalog persistence); pp. 175–176 (Bluetooth pairing persistence); p. 101 (scheduled messages persistence context)
   - **§15 External I/O**: **N/A from PDF** — dataref/variable names are not in the Pilot's Guide. External I/O sub-sections draw from AMAPI knowledge docs + OPEN QUESTIONS 4/5 preservation + D-15 §15.6 authoritative decision.
   - **Appendix A Family Delta**: pp. 18–20 (unit family feature tables in Introduction); distributed "AVAILABLE WITH" annotations throughout manual (e.g., p. 89 "CDI On Screen — GPS 175 + GNX 375 only", p. 158 "GPS NAV Status indicator key — GPS 175 + GNX 375 only"); pp. 18–19 for the comprehensive feature matrix

6. **`assets/gnc355_pdf_extracted/extraction_report.md`** — extraction quality notes. All §14/§15/Appendix A pages are **clean** (no sparse-page gaps relevant to Fragment G scope).

### Tier 3 — Cross-reference context

7. **`docs/knowledge/355_to_375_outline_harvest_map.md`** — harvest categorization for §§14–15 + Appendix A:
   - §14: [PART — §14.1 reframed to XPDR State replacing COM State]
   - §15: [PART — XPDR/ADS-B datarefs added; COM-specific datarefs dropped; §15.6 external CDI/VDI output per D-15; §15.7 altitude source dependency per D-16]
   - Appendix A: [NEW — 375-as-baseline comparison replacing the 355-as-baseline equivalent in the shelved GNC 355 outline]

8. **`docs/knowledge/amapi_by_use_case.md`** — A3 use-case index. Critical for §15:
   - §1 (dataref subscribe / MSFS variable subscribe) — §15.1 and §15.4 primary reference
   - §2 (command dispatch / event dispatch) — §15.3 and §15.5
   - §11 (Persist_add, Persist_get, Persist_put) — §14 primary reference

9. **`docs/knowledge/amapi_patterns.md`** — B3 pattern catalog. Outline cites for §14/§15:
   - Pattern 1 (triple-dispatch button/dial) — §15.2, §15.3, §15.5 XPDR write operations
   - Pattern 11 (persist dial angle / state across sessions) — §14 primary pattern
   - Pattern 14 (parallel XPL + MSFS subscriptions) — §15.1 vs. §15.4 — substantial dataref/variable differences
   - Pattern 23 (FS2024 B: event dispatch) — §15.5 MSFS Events note

10. **`docs/decisions/D-15-gnx375-display-architecture-internal-vs-external-turn-20-research.md`** — **PRIMARY AUTHORITY for §15.6 External CDI/VDI Output Contract.** D-15 established: no internal VDI on GNX 375; vertical deviation is output-only to external instruments. §15.6 must faithfully reflect this framing.

11. **`docs/decisions/D-16-gnx375-xpdr-adsb-scope-corrections-turn-21-research.md`** — **PRIMARY AUTHORITY for §14.1 XPDR State + §15.7 Altitude Source Dependency.** D-16 established: three XPDR modes only (Standby/On/Altitude Reporting); Flight ID editable-if-configurable persistence; ADS-B Out enable state persistence; external altitude source via ADC/ADAHRS/altitude encoder.

12. **`docs/decisions/D-12-gnc355-to-gnx375-pivot.md`** — **PRIMARY AUTHORITY for Appendix A.1 framing.** D-12 established: GNX 375 is the primary instrument; GNC 355 implementation deferred. Appendix A.1 must correctly reflect D-12's rationale and the shelved GNC 355 outline context.

13. **`docs/decisions/D-18-c22-format-decision-piecewise-manifest.md`** — **assembly readiness.** Fragment G archive triggers aggregate-spec assembly; Fragment G's Coupling Summary is the last CD/CC coordination metadata before assembly.

14. **`docs/todos/issue_index.md`** — **read ITM-08, ITM-10, ITM-11, and ITM-12 in full before authoring.**
    - **ITM-08**: Coupling Summary glossary-ref grep-verify — Phase G hard constraint. Discipline validated four times (Fragments D, E, F, compliance reports). Continue.
    - **ITM-10**: Fragment C §4.10 vs. PDF p. 94 Unit Selections — low-severity watchpoint; does not affect Fragment G (Fragment G does not touch Unit Selections).
    - **ITM-11**: Page-number offset (new extraction physical vs. Garmin logical) — watchpoint for C3 review tooling; Fragment G prose cites Garmin logical pages per archived-fragment convention (do not introduce physical-page citations in Fragment G).
    - **ITM-12 (NEW, from Fragment F compliance C2 PARTIAL)**: Coupling Summary line count watchpoint. **This is the key issue for Fragment G.** Fragment F's Coupling Summary was 39 lines vs. ~80 target — content complete but format was compact bullets instead of multi-sentence prose per ref. Fragment G's Coupling Summary must be **prose-per-ref expanded format** targeting **90–110 lines**.

15. **Predecessor CC task prompts** — **most recent structural template.** Read `docs/tasks/completed/c22_f_prompt.md` for the format, front matter, hard-constraint style, and self-review checklist pattern. Do NOT copy content — scope and constraints differ. Fragment G has **17 hard constraints** (one more than F due to assembly-readiness + Coupling Summary format).

16. **Predecessor compliance reports**:
    - `docs/tasks/completed/c22_f_compliance.md` — the 38-item compliance pattern just applied; Fragment G's compliance will be similar with adjustments for §14/§15/Appendix A content. Note the C2 PARTIAL on Fragment F Coupling Summary (drives Fragment G hard constraint #2).

17. **`CLAUDE.md`** (project conventions, commit format, ntfy requirement)
18. **`claude-conventions.md`** §Git Commit Trailers (D-04)

**Audit level:** standard — CD will check completions and run compliance modeled on the C2.2-F approach (~40-item check across F / S / X / C / N categories — slightly larger than F's 38 because Appendix A Family Delta adds comparison-consistency checks not present in earlier fragments).

---

## Pre-flight Verification

**Execute these checks before authoring any fragment content. If any fails, STOP and write `docs/tasks/c22_g_prompt_deviation.md`.**

1. Verify Tier 1 source files exist:
   ```bash
   ls docs/specs/GNX375_Functional_Spec_V1_outline.md
   ls docs/decisions/D-12-gnc355-to-gnx375-pivot.md
   ls docs/decisions/D-15-gnx375-display-architecture-internal-vs-external-turn-20-research.md
   ls docs/decisions/D-16-gnx375-xpdr-adsb-scope-corrections-turn-21-research.md
   ls docs/decisions/D-18-c22-format-decision-piecewise-manifest.md
   ls docs/decisions/D-19-fragment-prompt-line-count-expansion-ratio.md
   for letter in A B C D E F; do ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_$letter.md; done
   ls docs/specs/GNX375_Functional_Spec_V1.md
   ls docs/todos/issue_index.md
   ```

2. Verify Tier 2 source files exist:
   ```bash
   ls assets/gnc355_pdf_extracted/text_by_page.json
   ```

3. Verify outline + archived fragment line counts:
   ```bash
   wc -l docs/specs/GNX375_Functional_Spec_V1_outline.md
   for letter in A B C D E F; do wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_$letter.md; done
   ```
   Expected: outline 1,477 lines; A=545, B=798–799, C=725, D=913, E=829, F=606.

4. Verify `text_by_page.json` structural integrity on key §14/Appendix-A pages via a saved `.py` script per D-08. Key pages: 18–20 (Appendix A feature matrix source), 58 (persistence context), 60, 63, 72, 97, 75–82 (XPDR state for §14.1), 89 (CDI On Screen availability), 155 (FPL User Field GNC 355-only), 158 (GPS NAV Status key availability), 175–176 (Bluetooth pairing persistence), 183 (FROM/TO field for §15.1 CDI output context).

5. Verify no conflicting fragment output exists:
   ```bash
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md 2>/dev/null
   ```
   Expect failure. If the file exists, STOP and note in deviation report.

---

## Phase 0: Source-of-Truth Audit

Before authoring any spec body content:

1. Read all Tier 1 documents in full (outline §§14–15 + Appendix A, D-12, D-15 in full, D-16 in full, D-18 in full, D-19).
2. Read all six archived fragments (A, B, C, D, E, F) in full. Fragment G Coupling Summary must correctly claim forward-ref targets from all six.
3. **Read ITM-08, ITM-10, ITM-11, and ITM-12 in `docs/todos/issue_index.md` in full.** ITM-12 is the critical format constraint for this fragment.
4. Read PDF pages listed in outline sub-section `[pp. N]` citations for §14 (pp. 58, 60, 63, 72, 97), §15 (N/A; AMAPI-driven), Appendix A (pp. 18–20 + distributed "AVAILABLE WITH" annotations).
5. Read `docs/knowledge/amapi_by_use_case.md` §1 + §2 + §11 for §15 dataref patterns.
6. Read `docs/knowledge/amapi_patterns.md` for Pattern 1, 11, 14, 23 context.

7. **Assembly-readiness audit:** verify across all six archived fragments that forward-refs to Fragment G content (§14/§15/Appendix A) resolve to the sub-sections Fragment G plans to author. Specifically:
   - §11.14 (Fragment F) forward-refs §14 Persistent State — ✓ §14 authors this
   - Multiple fragments forward-ref §15 External I/O for dataref/variable names — ✓ §15 authors
   - Multiple fragments forward-ref Appendix A for sibling-unit deltas — ✓ Appendix A authors
   - §12.2 (Fragment F) forward-refs §15.6 External CDI/VDI Output Contract — ✓ §15.6 authors
   - §11 + §13.8 (Fragment F) reference §15.7 Altitude Source Dependency — ✓ §15.7 authors
   - Fragment F §12.4 cross-refs §4.9 (Fragment C) for OPEN QUESTION 6 — NOT a Fragment G concern; OQ6 preserved in Fragment C §4.9 verbatim

**Definition — Actionable requirement:** A statement in the outline or an authorizing decision that, if not reflected in Fragment G, would leave a forward-ref from archived fragments unresolved, leave an OPEN QUESTION unpreserved, or leave the aggregate spec incomplete. Includes: all §14 persistence categories, all §15 sub-sections, D-15 §15.6 framing, D-16 §14.1 + §15.7 framing, D-12 Appendix A.1 framing, Appendix A sibling-unit delta matrices, ITM-08 grep-verify, OPEN QUESTIONS 4 and 5 preservation.

8. Extract actionable requirements. Particular attention to:

   **§14 Persistent State (6 sub-sections):**
   - §14.1 XPDR State — replaces COM State; squawk code, mode, Flight ID, ADS-B Out enable, data field preference all persist
   - §14.2 Display and UI State — display brightness, unit selections, page shortcuts, CDI scale, CDI On Screen toggle (GNX 375 only), runway criteria
   - §14.3 Flight Planning State — FPL catalog, user waypoints (up to 1,000), active FPL, active direct-to (verify device behavior)
   - §14.4 Scheduled Messages — message definitions persist; trigger states may reset
   - §14.5 Bluetooth Pairing — paired devices (up to 13) + auto-connect preferences
   - §14.6 Crossfill Data — crossfill on/off setting

   **§15 External I/O (7 sub-sections):**
   - §15.1 XPL Datarefs — Reads — GPS pos/state, XPDR code/mode/reply (OQ4), ADS-B Out state (OQ4), pressure altitude (external ADC), avionics master, heading/GS/track, XTK, CDI source, active waypoint info, CDI lateral deviation
   - §15.2 XPL Datarefs — Writes — XPDR code, mode, ADS-B Out enable
   - §15.3 XPL Commands — XPDR IDENT, XPDR mode cycle/set, Direct-to activate, approach activation, missed approach
   - §15.4 MSFS Variables — Reads — TRANSPONDER CODE:1, TRANSPONDER STATE, TRANSPONDER IDENT (OQ5), GPS position/track, avionics master
   - §15.5 MSFS Events — Writes — XPNDR_SET, XPNDR_IDENT_ON, XPNDR_STATE_SET or equivalent; FS2024 B event equivalents (Pattern 23)
   - §15.6 **External CDI/VDI Output Contract** (D-15 PRIMARY AUTHORITY) — lateral deviation output, course angle output, CDI scale mode output, TO/FROM flag output, GPSS output, **vertical deviation output to external VDI for LPV/LP+V/LNAV+V**, glidepath capture output, no on-screen VDI on GNX 375
   - §15.7 Altitude Source Dependency — external ADC/ADAHRS altitude encoder input; XPDR data field shows altitude only when source available; advisory message triggered on source loss

   **Appendix A Family Delta (5 sub-sections):**
   - A.1 Unit identification + D-12 context — Pilot's Guide covers GPS 175 / GNC 355 / GNC 355A / GNX 375; GNX 375 is primary; 355 deferred; D-02 reference resolved per D-12
   - A.2 GPS 175 vs. GNX 375 — GPS 175 lacks: Mode S XPDR, ADS-B Out, built-in ADS-B In, TSAA, ADS-B traffic log; identical: all GPS/MFD, CDI On Screen, GPS NAV Status key, Direct-to via knob-push, FIS-B (with external LRU)
   - A.3 GNC 355/355A vs. GNX 375 — GNC 355 lacks: same as GPS 175 list + CDI On Screen + GPS NAV Status key; GNC 355 adds (not on GNX 375): VHF COM radio, COM Standby Control Panel, 25/8.33 kHz channels, COM volume/sidetone/monitor/RFL/user-freq/alerts, Flight Plan User Field, Direct-to via standby-freq-tune
   - A.4 GNX 375 variants — no 375A documented; placeholder for future variants
   - A.5 Feature matrix — all units table

9. **Open-question preservation checklist:**
   - **§15.1 + §15.2 + §15.3**: **OPEN QUESTION 4** (XPL XPDR dataref names — transponder_code, transponder_mode, ADS-B Out state, pressure altitude dataref) — **PRESERVE VERBATIM**; state that design-phase verification against XPL datareftool is required.
   - **§15.4 + §15.5**: **OPEN QUESTION 5** (MSFS XPDR SimConnect variables — TRANSPONDER CODE:1, TRANSPONDER STATE, TRANSPONDER IDENT; FS2020 vs. FS2024 B differences; Pattern 23 applies to FS2024 B) — **PRESERVE VERBATIM**.
   - **§15.6**: External CDI output dataref names (lateral deviation + GPS-specific dataref) — preserve as design-phase research flag.
   - **§15.6**: External VDI output dataref name (GPS glidepath deviation) — preserve as design-phase research flag.
   - **§14.3**: Active direct-to persistence (may or may not persist across power cycle) — preserve as device-behavior-verification flag.
   - **§14.1**: Flight plan catalog serialization scheme (Air Manager persist API is scalar; encoding required) — preserve as design-phase decision.
   - **Appendix A.4**: GNX 375A variant (no 375A documented in current Pilot's Guide) — preserve as placeholder for future.

10. If ALL requirements covered: print "Phase 0: all source requirements covered" and proceed.
11. If any uncovered: write `docs/tasks/c22_g_prompt_phase0_deviation.md` and STOP.

---

## Instructions

Produce the seventh and **final** fragment of the GNX 375 Functional Spec V1 body. After this fragment archives, the C2.2 aggregate spec is assemblable; CD will author `scripts/assemble_gnx375_spec.py` and prepend the Review Priority Guide per D-22.

**Primary output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md`

### Authoring strategy

Same as Fragments A–F: outline provides structural skeleton; task expands outline bullets into implementable prose while preserving structure, page references, and cross-references.

#### Authoring depth guidance

- **Scope paragraphs (per top-level section):** 2–4 sentences per top-level section (§14, §15, Appendix A). State what the section is for, its key GNX 375-specific framing, and operational cross-refs.

- **Sub-section prose:** each outline bullet expands into a short block (3–20 lines typical — §15 sub-sections tend to be shorter than §14 and Appendix A because they're enumerative).

- **Tables:** use tables where content is naturally tabular. Expected tables in Fragment G:
  - §14 persistence matrix (optional — could be inline prose + sub-section headers)
  - §15.1 XPL datarefs reads table (dataref name, type, purpose, state column)
  - §15.2 XPL datarefs writes table (same columns + trigger)
  - §15.4 MSFS variables reads table
  - §15.5 MSFS events writes table
  - §15.6 External CDI/VDI output contract table (output, target instrument class, purpose)
  - **Appendix A.5 feature matrix** — the most important table in Fragment G; compact tri-unit comparison (GPS 175 / GNC 355/355A / GNX 375)
  - Appendix A.2 and A.3 lack/identical tables (optional format; could be prose)

- **AMAPI cross-refs:** at the end of each top-level section, include an "AMAPI notes" block. §15 AMAPI block will be the densest.

- **Open questions / flags:** preserve every outline flag per the checklist above. §15.1–§15.5 carry OQ4 and OQ5. §14.1 + §14.3 carry persistence-scheme flags.

- **Cross-references:**
  - Backward-refs to Fragments A–F use "see §N.x" without fragment qualification.
  - **No forward-refs from Fragment G** (Fragment G is the closing fragment; nothing further to forward to).
  - **Intra-fragment cross-refs within Fragment G**: §14.1 ↔ §15.1–§15.5 (XPDR persistence state reflected in dataref/variable list); §15.6 ↔ §15.1 (external CDI output datarefs are a subset of §15.1 reads); §15.7 ↔ §14 (altitude source dependency is both a persistence concern and a dataref concern).

#### Fragment file conventions (per D-18)

- **Path:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md`
- **YAML front-matter (required):**
  ```yaml
  ---
  Created: 2026-04-24T{HH:MM:SS}-04:00
  Source: docs/tasks/c22_g_prompt.md
  Fragment: G
  Covers: §§14–15 + Appendix A (Persistent State, External I/O, Family Delta)
  ---
  ```
- **Heading levels:**
  - `# GNX 375 Functional Spec V1 — Fragment G` — fragment header (stripped on assembly)
  - `## 14. Persistent State` — top-level
  - `## 15. External I/O (Datarefs and Commands)` — top-level
  - `## Appendix A: Family Delta — GNX 375 as Baseline` — top-level
  - `### 14.1 XPDR State (GNX 375 — replaces COM State)` — sub-sections use `###`
  - `### 15.6 External CDI/VDI Output Contract [D-15]` — sub-sections
  - `### A.5 Feature Matrix` — appendix sub-sections
  - Do NOT include harvest-category markers (`— [PART]`, `— [FULL]`, `— [NEW]`) in spec-body headings.
- **Line count target:** ~300 lines per D-19. Under-delivery (<270) suggests under-coverage; over-delivery (>450) warrants completion-report classification. Soft ceiling ~400. Expected actual ~330–370 given structured scope.

#### Specific framing commitments

These are **hard constraints** that must appear in the fragment. There are **17** for Fragment G:

1. **ITM-08 Coupling Summary glossary-ref grep-verify — Phase G hard constraint.** Before finalizing the Coupling Summary, `grep` each Appendix B glossary term claimed as a backward-ref against `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`. Remove any terms not present in Appendix B. Do NOT claim EPU, HFOM/VFOM, HDOP, TSO-C151c (absent per C2.2-C X17, C2.2-D F11, C2.2-E C1, C2.2-F C1). Discipline validated four times; maintain.

2. **ITM-12 — Coupling Summary prose-per-ref format, target 90–110 lines.** This is the critical format constraint for Fragment G. Each backward-ref, forward-ref stub, and intra-fragment ref must be authored as a **multi-sentence prose block** (2–4 sentences per ref), NOT as a compact single-line bullet. Fragment F's 39-line Coupling Summary was the failure mode this constraint addresses. Target **95–105 lines**; acceptable range 90–110.

3. **No forward-refs in Fragment G.** Fragment G is the closing fragment; all refs are backward-refs (to Fragments A–F) or intra-fragment (within Fragment G). The Coupling Summary "Forward cross-references" block should read: "Fragment G is the closing fragment; no forward-refs to later fragments." Do NOT invent forward-refs to non-existent fragments.

4. **§14.1 = XPDR STATE (replacing COM State) per D-16.** §14.1 must enumerate: squawk code, mode (Standby/On/Altitude Reporting — **three modes per D-16**), Flight ID, ADS-B Out enable state, data field preference. No COM radio state on GNX 375. Cross-ref §11.14 (Fragment F) for operational context.

5. **§15 must NOT re-author §11 XPDR behavior (Fragment F authoritative).** §15 describes **dataref/variable/event surfaces** that bridge the simulator and the instrument; §11 describes the pilot-facing behavior. Cross-ref §11 for behavioral semantics; §15 authors interface names, types, and contracts only.

6. **§15.6 EXTERNAL CDI/VDI OUTPUT CONTRACT per D-15.** §15.6 must state:
   - GNX 375 drives external CDI/HSI via lateral deviation output
   - GPSS (roll steering) output to compatible autopilots
   - **Vertical deviation output to external VDI for LPV / LP+V / LNAV+V approaches** (D-15 no-internal-VDI framing)
   - **No on-screen VDI on GNX 375** — all vertical deviation is output-only (D-15 primary decision)
   - Glidepath capture output to autopilots
   - TO/FROM flag output drives external CDI flag indicator
   - Design-phase flag: exact XPL/MSFS dataref names for lateral + vertical deviation output require verification

7. **§15.7 ALTITUDE SOURCE DEPENDENCY per D-16.** §15.7 must state:
   - XPDR pressure altitude comes from **external ADC/ADAHRS** (altitude encoder, GDC 74, GAE 12, or equivalent) [p. 34]
   - GNX 375 does NOT compute pressure altitude internally
   - XPDR data field shows altitude ONLY when external source available
   - "ADS-B Out fault. Pressure altitude source inoperative or connection lost." advisory triggered on source loss (cross-ref §11.13 item 1 / §13.9)

8. **§15.1/§15.2/§15.3 OPEN QUESTION 4 preserved verbatim.** The OQ4 block must appear once in §15 (typically as a preamble to §15.1 or as an OQ block after §15.3). Content: XPL XPDR dataref names (transponder_code, transponder_mode, ADS-B Out state, pressure altitude dataref) require verification against XPL datareftool during design phase. Forward-flag for D1 Design Spec resolution.

9. **§15.4/§15.5 OPEN QUESTION 5 preserved verbatim.** The OQ5 block must appear once in §15 (typically after §15.5 or as a combined OQ4+OQ5 block). Content: MSFS XPDR SimConnect variable names (TRANSPONDER CODE:1, TRANSPONDER STATE, TRANSPONDER IDENT); FS2020 vs. FS2024 B behavioral differences; Pattern 23 applies to FS2024 B event dispatch. Forward-flag for D1 Design Spec resolution.

10. **Appendix A.1 D-12 CONTEXT.** A.1 must state:
    - Pilot's Guide 190-02488-01 Rev. C covers GPS 175, GNC 355/355A, and GNX 375
    - GNX 375 is primary per D-12 pivot
    - D-02 "GNC 375" reference resolved per D-12: GNX 375 is correct product designation
    - GNC 355 implementation deferred per D-12; shelved GNC 355 outline preserves 355-baseline version of Appendix A for eventual resumption

11. **Appendix A.2 GPS 175 lack list.** A.2 must list GPS 175 lacks-vs.-GNX-375: Mode S transponder (entire §11), ADS-B Out (no Extended Squitter), built-in ADS-B In (requires external GDL 88 or GTX 345), TSAA traffic application with aural alerts, ADS-B traffic logging. Identical list: all GPS/MFD navigation features, CDI On Screen (GPS 175 + GNX 375 only), GPS NAV Status indicator key (GPS 175 + GNX 375 only), Direct-to via knob-push, FIS-B (GPS 175 with external LRU).

12. **Appendix A.3 GNC 355/355A lack + adds lists.** A.3 must list:
    - GNC 355 lacks-vs.-GNX-375: Mode S XPDR, ADS-B Out, built-in ADS-B In, TSAA, ADS-B traffic logging, **CDI On Screen**, **GPS NAV Status indicator key**
    - GNC 355 adds (features NOT on GNX 375): **VHF COM radio** (GNC 355 §11), COM Standby Control Panel (GNC 355 §4.11), 25 kHz spacing (355) + 8.33 kHz (355A European), COM volume/sidetone/monitor/reverse-frequency-lookup/user-frequencies/COM alerts, Flight Plan User Field [p. 155], Direct-to via standby-frequency-tune
    - Identical: all GPS/MFD navigation; FIS-B/Traffic (355 external hardware; framing differs)

13. **Appendix A.5 feature matrix table.** A.5 must present a tri-unit comparison table covering: GPS/WAAS navigation, map, FPL, Direct-to, Procedures, Nearest, Waypoints, Planning pages (VCALC/Fuel/DALT/TAS/RAIM), FIS-B weather, Traffic, Terrain/TAWS, Bluetooth, Database Concierge, XPDR + ADS-B Out, CDI On Screen, GPS NAV Status indicator key, COM radio, ADS-B traffic logging. Each row indicates applicability per unit (identical / N/A / 375-only / 175+375 only / 355-only).

14. **No sibling-unit consistency drift.** Check every claim about what GNX 375 has/lacks vs. siblings against Fragments A §1, B/C display-page scope, D §7 procedure scope, F §11 XPDR + §12 alerts. Any statement in Fragment G must be consistent with archived fragment framing. `grep -ni 'GNC 355\|GPS 175'` — all matches must be consistent with archived content.

15. **No §4/§7/§10/§11 re-authoring.** `grep -nE '^## 4\.|^### 4\.|^## 7\.|^### 7\.|^## 10\.|^### 10\.|^## 11\.|^### 11\.|^## [5689]|^### [5689]\.|^## 12\.|^### 12\.|^## 13\.|^### 13\.|^## Appendix B|^## Appendix C' docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md` — expect **0 matches**. Fragment G authors §§14–15 + Appendix A only.

16. **No COM present-tense on GNX 375 anywhere in Fragment G.** `grep -ni 'COM radio\|COM standby\|COM volume\|COM frequency\|COM monitoring\|VHF COM' docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md` — all matches must be in Appendix A.3 sibling-unit comparison context (explicit "GNC 355 has VHF COM; GNX 375 does not") or §14.1 explicit replacement framing ("replaces COM State"). Zero "the GNX 375 has [COM feature]" statements.

17. **Assembly readiness — sub-section numbering continuous with archived fragments.** On concatenation, Fragment G's sections must integrate cleanly: §14 follows §13 (Fragment F); §15 follows §14; Appendix A follows §15. No duplicate headings. `grep -cE '^## 14\.|^## 15\.|^## Appendix A'` → **3 exact matches** (one per top-level section).

#### Per-section page budget (informative)

| Section | Outline estimate | Fragment prose target |
|---------|------------------|------------------------|
| Fragment header + YAML | — | ~10 |
| §14 Persistent State (6 sub-sections) | ~50 | ~60 |
| §15 External I/O (7 sub-sections) | ~50 | ~70 |
| Appendix A Family Delta (5 sub-sections) | ~150 | ~170 |
| Coupling Summary block | — | **~95–105 (prose-per-ref format per ITM-12)** |
| **Total target** | **~250** | **~410** |

The 410 total is ~37% above the 300 D-19 target. This is within the series trend (F was +12%; G's larger Coupling Summary per ITM-12 raises the expected overage). If actual trends above 450, classify in completion report.

#### Coupling Summary block — prose-per-ref format (per ITM-12)

At the end of the fragment, include a **Coupling Summary** section per D-18, authored in **expanded prose-per-ref format** per ITM-12. Use this template:

```markdown
---

## Coupling Summary

This section is authored per D-18 for CD/CC coordination across the 7-fragment spec. It is not part of the spec body and is stripped on assembly. Fragment G is the closing fragment — every forward-ref authored in Fragments A through F lands here, which makes this the most backward-ref-dense Coupling Summary in the series. Per ITM-12, this block is written in prose-per-ref format (2–4 sentences per ref) rather than compact bullets. Target length 95–105 lines.

### Backward cross-references (sections this fragment references authored in prior fragments)

**Fragment A §1 Overview.** Fragment G §14 Persistent State and Appendix A Family Delta both draw on the GNX 375 product positioning established in §1 — TSO-C112e Mode S Level 2els Class 1, 1090 ES ADS-B Out integrated, dual-link ADS-B In, GNX 375 as primary per D-12. Appendix A.1 explicitly cites §1 + D-12 for the unit-family context. §14.1 XPDR State list depends on §1's feature-set framing to justify what persists.

**Fragment A §3 Power-On.** Fragment G §15.7 Altitude Source Dependency cites §3's external altitude source framing (ADC/ADAHRS via altitude encoder, p. 34 — GDC 74, GAE 12 equivalents). §15.7 reiterates that the GNX 375 does not compute pressure altitude internally, which §3 established at the startup level.

**Fragment A Appendix B Glossary.** Terms verified present via grep before finalizing this list per ITM-08 discipline. **Verified-present terms claimed here** (add list after grep-verify): [TBD — run the grep during authoring; expected candidates include Mode S, 1090 ES, UAT, Extended Squitter, FIS-B, TSAA, TIS-B, WAAS, SBAS, Connext, TSO-C112e, TSO-C166b, WOW, IDENT, Flight ID, Target State and Status, CDI, VDI, GPSS]. **NOT claimed (absent from Appendix B per C2.2-C X17, C2.2-D F11, C2.2-E C1, C2.2-F C1):** EPU, HFOM, VFOM, HDOP, TSO-C151c.

(… continue with similar 2–4-sentence prose blocks for each of the remaining 15–20 backward-refs. Each block names the referenced fragment + section + what Fragment G uses it for. …)

**Fragment F §11.14 XPDR Persistent State.** §14.1 XPDR State in Fragment G is the canonical persistence specification; §11.14 in Fragment F was the forward-ref target. §14.1 enumerates squawk code, mode, Flight ID, ADS-B Out enable, and data field preference as retained state — consistent with §11.14's forward-ref claim that these fields persist. No conflict; §14.1 provides the formal definition that §11.14's operational cross-ref pointed to.

### Forward cross-references

Fragment G is the closing fragment of the GNX 375 Functional Spec V1 body. There are no forward-refs to later fragments because no later fragments exist. Any behavior, dataref, state, or delta that the earlier fragments deferred to §14, §15, or Appendix A resolves within this fragment.

### Intra-fragment cross-references (within Fragment G)

**§14.1 XPDR State ↔ §15.1/§15.2/§15.3 XPL Datarefs and Commands.** The persistent state items in §14.1 (squawk code, mode, Flight ID, ADS-B Out enable, data field preference) correspond one-for-one to dataref reads in §15.1 and dataref/command writes in §15.2/§15.3. The persistent state specification and the simulator-interface specification must stay synchronized; §14.1 is the what-persists spec and §15 is the how-we-read-and-write spec.

**§15.6 External CDI/VDI Output Contract ↔ §15.1 XPL Datarefs Reads.** The external CDI/VDI outputs defined in §15.6 are a subset of the datarefs read in §15.1 (lateral deviation, vertical deviation, flight phase, CDI scale, TO/FROM flag). §15.6 specifies the target-instrument contract and wire protocol; §15.1 specifies the dataref names to subscribe for those values.

**§15.7 Altitude Source Dependency ↔ §14 Persistent State and §15.1 Pressure Altitude Dataref.** §15.7's external altitude source framing affects both the persistence story (pressure altitude does not persist; it comes fresh from the external source each cycle) and the dataref subscription (§15.1 includes the pressure altitude dataref as a read from the external ADC/ADAHRS).

### Outline coupling footprint

This fragment draws from outline §§14–15 + Appendix A only. No content from §§1–13 (Fragments A–F), Appendix B Glossary, or Appendix C Extraction Gaps is authored here. This completes the 7-fragment decomposition per D-18 §"Task partition" — Fragments A–G together cover all 15 outline sections plus Appendices A/B/C with zero overlap.
```

---

## Integration Context

- **Primary output file:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md` (new)
- **Directory already exists:** contains part_A, part_B, part_C, part_D, part_E, part_F.
- **No code modification in this task.** Docs-only.
- **No test suite run required.** Docs-only.
- **Do not modify the outline.** If PDF-vs-outline discrepancies appear, note in completion report Deviations section.
- **Do not modify any of Fragments A–F.** All are archival.
- **Do not modify the manifest yet.** CD will update the manifest status entry for Fragment G after this task archives. CD will then author the assembly script per D-18 and the Review Priority Guide per D-22.

---

## Implementation Order

**Execute phases sequentially. Do not parallelize phases or launch subagents.**

### Phase A: Read and audit (Phase 0 per above)

Read all Tier 1 and Tier 2 sources. Read all six archived fragments in full. **Re-read D-15, D-16, D-12 in full.** **Read ITM-08, ITM-10, ITM-11, ITM-12 in full.** Perform assembly-readiness audit. Extract actionable requirements. Confirm coverage of the open-question preservation checklist. Print Phase 0 completion line OR write deviation report and STOP.

### Phase B: Create fragment file skeleton

1. Create `docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md` with YAML front-matter + fragment header + section headers (`## 14.`, `## 15.`, `## Appendix A`).
2. Add sub-section headers: §14 (14.1–14.6), §15 (15.1–15.7), Appendix A (A.1–A.5).
3. Add Coupling Summary placeholder at the end (with the four sub-blocks framed).

### Phase C: Author §14 Persistent State (~60 lines)

Scope paragraph: GNX 375 persists XPDR state, display/UI state, flight planning state, scheduled messages, Bluetooth pairing, and crossfill preferences across power cycles. §14.1 reframes COM State to XPDR State per D-16.

Expand §14.1–§14.6 per Phase 0 enumeration. Cross-ref §11.14 (Fragment F) for §14.1 operational context.

AMAPI notes block: Pattern 11 (persist dial angle/state); use-case §11 (Persist_add/get/put).

Open-question block: §14.1 flight plan catalog serialization; §14.3 active direct-to persistence.

### Phase D: Author §15 External I/O (~70 lines)

Scope paragraph: dataref/variable/event surfaces between the GNX 375 instrument and XPL (primary) / MSFS (secondary). COM-specific refs dropped; XPDR + ADS-B refs added per D-16. External CDI/VDI output contract per D-15. Altitude source dependency per D-16.

Expand §15.1–§15.7 per Phase 0 enumeration:
- §15.1 XPL reads (~15 lines): GPS pos/state, XPDR code/mode/reply/ADS-B (OQ4), pressure altitude, avionics master, heading/GS/track, XTK, CDI source, active waypoint info, CDI lateral deviation
- §15.2 XPL writes (~5 lines): XPDR code, mode, ADS-B Out enable
- §15.3 XPL commands (~5 lines): IDENT, mode set, Direct-to, approach activation, missed approach
- §15.4 MSFS reads (~10 lines): TRANSPONDER CODE:1, STATE, IDENT (OQ5); GPS position/track; avionics master
- §15.5 MSFS events (~5 lines): XPNDR_SET, XPNDR_IDENT_ON, XPNDR_STATE_SET; FS2024 B equivalents (Pattern 23)
- §15.6 External CDI/VDI Output Contract (~15 lines): lateral/vertical deviation, course angle, scale, TO/FROM, GPSS, glidepath capture — **D-15 no-internal-VDI framing explicit**
- §15.7 Altitude Source Dependency (~8 lines): external ADC/ADAHRS; no internal computation; advisory trigger

AMAPI notes block: use-case §1 (subscribe), §2 (command/event); Pattern 1 (triple-dispatch), Pattern 14 (parallel XPL+MSFS), Pattern 23 (FS2024 B).

Open-question block: OQ4 + OQ5 combined; CDI/VDI output dataref names.

### Phase E: Author Appendix A Family Delta (~170 lines)

Scope paragraph: compact comparison of GNX 375 vs. sibling units. GNX 375 is baseline per D-12. Shelved GNC 355 outline preserves 355-baseline version for eventual resumption.

Expand A.1–A.5:
- A.1 Unit identification + D-12 context (~15 lines)
- A.2 GPS 175 deltas (~30 lines): lacks list (5 items), identical list (5 items)
- A.3 GNC 355/355A deltas (~60 lines): lacks list (7 items), adds list (6 items), identical list
- A.4 GNX 375 variants (~5 lines): placeholder
- A.5 Feature matrix table (~55 lines): tri-unit comparison across ~18 feature categories

AMAPI notes block: minimal — Appendix A is descriptive, not operational.

### Phase F: Author Coupling Summary (~95–105 lines, prose-per-ref format per ITM-12)

Write per the template above. **Execute ITM-08 grep-verify before writing:**
1. Open Fragment A, locate Appendix B glossary
2. For each term planned as backward-ref (Mode S, 1090 ES, UAT, Extended Squitter, FIS-B, TSAA, TIS-B, WAAS, SBAS, Connext, TSO-C112e, TSO-C166b, WOW, IDENT, Flight ID, Target State and Status, CDI, VDI, GPSS), grep and confirm formal Appendix B entry
3. Remove any not-found from backward-refs list
4. Document verified-present and removed-if-any in completion report
5. Exclude: EPU, HFOM, VFOM, HDOP, TSO-C151c (absent per prior fragments)

**Format discipline per ITM-12:** each backward-ref gets 2–4 sentences of prose (what fragment+section it references; what Fragment G uses it for; any cross-ref resolution context). Do NOT use compact single-line bullets. Target 95–105 lines total; floor 90; ceiling 110.

Forward-refs block: single paragraph stating Fragment G is the closing fragment; no forward-refs.

Intra-fragment block: 3–4 prose blocks per the template (§14.1↔§15.1/§15.2/§15.3; §15.6↔§15.1; §15.7↔§14 and §15.1).

Outline footprint block: single paragraph confirming §§14–15 + Appendix A scope; noting 7-fragment decomposition is complete.

### Phase G: Self-review

Before writing the completion report, perform these self-checks (per D-08):

1. **Line count:** `wc -l` — target ~300; acceptable band 270–450; soft ceiling 400. Actual expected ~330–410.
2. **Character encoding:** `grep -c '\\u[0-9a-f]\{4\}'` → expect 0.
3. **Replacement chars:** saved `.py` file counts U+FFFD bytes → expect 0.
4. **No §§1–13 / §§11-on-GNX-375-as-present / Appendix B/C headers:** `grep -nE '^## 4\.|^### 4\.|^## 7\.|^### 7\.|^## 10\.|^### 10\.|^## 11\.|^### 11\.|^## [5689]|^### [5689]\.|^## 12\.|^### 12\.|^## 13\.|^### 13\.|^## Appendix B|^## Appendix C'` → expect **0 matches**.
5. **§14 = 6 sub-sections:** `grep -cE '^### 14\.'` → **6**.
6. **§15 = 7 sub-sections:** `grep -cE '^### 15\.'` → **7**.
7. **Appendix A = 5 sub-sections:** `grep -cE '^### A\.'` → **5**.
8. **Top-level headings = 3:** `grep -cE '^## 14\.|^## 15\.|^## Appendix A'` → **3 exact matches**.
9. **§14.1 = XPDR State framing:** grep §14.1 for "squawk code", "mode", "Flight ID", "ADS-B Out", "data field" — all 5 present. No COM radio content. "replaces COM State" framing explicit.
10. **§15.6 D-15 framing:** grep §15.6 for "no on-screen VDI", "external", "LPV", "LP+V", "LNAV+V", "vertical deviation output" — all 6 present. No prose implying internal VDI exists.
11. **§15.7 D-16 framing:** grep §15.7 for "external", "ADC", "ADAHRS", "altitude encoder" — all present. No prose implying internal altitude computation.
12. **§15 three-modes consistency:** grep §15.1/§15.2/§15.3 for "Standby", "On", "Altitude Reporting" — these three modes only; no Ground/Test/Anonymous mode references (except if any sibling-unit-context).
13. **OQ4 preserved:** grep §15 for "OPEN QUESTION 4" block with full verbatim text (XPL datareftool verification; transponder_code, transponder_mode, ADS-B Out, pressure altitude).
14. **OQ5 preserved:** grep §15 for "OPEN QUESTION 5" block with full verbatim text (MSFS SimConnect; TRANSPONDER CODE:1, STATE, IDENT; FS2020 vs. FS2024 B; Pattern 23).
15. **Appendix A.1 D-12 context:** grep A.1 for "D-12" and "GNX 375" and "GNC 355 implementation deferred".
16. **Appendix A.5 feature matrix:** grep A.5 for tri-unit row format; expect ~18 rows covering all features listed in constraint 13.
17. **No COM present-tense on GNX 375:** `grep -ni 'COM radio\|COM standby\|COM volume\|COM frequency\|COM monitoring\|VHF COM'` — all matches in sibling-unit comparison (Appendix A.3) or §14.1 "replaces COM State" context; zero "GNX 375 has [COM]" statements.
18. **Page citation preservation:** spot-check 5 outline citations appear in the correct sub-section:
    - `[pp. 58, 60, 63, 72, 97]` or subset in §14 Persistent State body
    - `[pp. 18–20]` in Appendix A.5 feature matrix source note
    - `[p. 89]` in Appendix A.2 CDI On Screen context
    - `[p. 158]` in Appendix A.2 GPS NAV Status key context
    - `[p. 155]` in Appendix A.3 Flight Plan User Field (GNC 355 only) context
19. **YAML front-matter correct; fragment header "Fragment G":** grep-inspect; confirm `Fragment: G`, `Covers: §§14–15 + Appendix A`.
20. **No harvest-category markers in `###` lines:** `grep -nE '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])'` → **0 matches**.
21. **Coupling Summary section present and prose-per-ref format per ITM-12:** grep for `## Coupling Summary`; confirm 4 sub-blocks; **count Coupling Summary line count — target 95–105; floor 90; ceiling 110**. Each backward-ref must span 2–4 sentences (not single bullets).
22. **Coupling Summary forward-refs block states "closing fragment":** grep for "closing fragment" in Forward cross-references block.
23. **ITM-08 grep-verify executed:** Appendix B terms verified-present; EPU/HFOM/VFOM/HDOP/TSO-C151c NOT claimed; verified list documented in completion report.
24. **Intra-fragment cross-refs present:** §14.1↔§15; §15.6↔§15.1; §15.7↔§14/§15.1 — all three prose blocks present in Coupling Summary intra-fragment section.
25. **Assembly readiness note:** Outline footprint block in Coupling Summary explicitly states "7-fragment decomposition complete" or equivalent.

Report all 25 results in the completion report.

---

## Completion Protocol

1. Write completion report to `docs/tasks/c22_g_completion.md` with this structure:

   ```markdown
   ---
   Created: {ISO 8601 timestamp}
   Source: docs/tasks/c22_g_prompt.md
   ---

   # C2.2-G Completion Report — GNX 375 Functional Spec V1 Fragment G

   **Task ID:** GNX375-SPEC-C22-G
   **Output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md`
   **Completed:** 2026-04-24

   ## Pre-flight Verification Results
   {table of the 5 pre-flight checks with PASS/FAIL}

   ## Phase 0 Audit Results
   {summary; include open-question preservation checklist: OQ4 (§15 XPL), OQ5 (§15 MSFS), §15.6 CDI/VDI output flag, §14.1 FPL catalog serialization, §14.3 active direct-to persistence, §15.7 altitude source; assembly-readiness audit results}

   ## Fragment Summary Metrics
   | Metric | Value |
   |--------|-------|
   | Fragment file | `docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md` |
   | Line count | {actual} |
   | Target line count | ~300 |
   | Soft ceiling | ~400 |
   | Acceptable band | 270–450 |
   | Sections covered | §§14–15 + Appendix A |
   | §14 sub-section count | 6 (14.1–14.6) |
   | §15 sub-section count | 7 (15.1–15.7) |
   | Appendix A sub-section count | 5 (A.1–A.5) |
   | Coupling Summary line count | {actual; target 95–105 per ITM-12} |

   ## Self-Review Results (Phase G)
   {table of the 25 self-checks with PASS/FAIL and specifics}

   ## Hard-Constraint Verification
   {confirm each of the 17 framing commitments}

   ## ITM-08 Coupling Summary Grep-Verify Report
   {list of Appendix B terms PLANNED; list CONFIRMED-PRESENT via grep with Appendix B location; list any REMOVED; list EXCLUSIONS honored (EPU, HFOM, VFOM, HDOP, TSO-C151c)}

   ## ITM-12 Coupling Summary Format Verification
   {confirm prose-per-ref format; cite 3 example refs with sentence counts; report total line count vs. 95–105 target}

   ## D-15 / D-16 Framing Verification
   {confirm D-15 no-internal-VDI explicit in §15.6; D-16 three-modes + external altitude explicit in §14.1 and §15.7}

   ## D-12 Appendix A Context Verification
   {confirm D-12 pivot rationale explicit in A.1}

   ## Assembly-Readiness Report
   {confirm all forward-refs from Fragments A–F to Fragment G content resolve; confirm no duplicate headings across fragments; confirm 7-fragment decomposition is complete per outline footprint note}

   ## Deviations from Prompt
   {table of deviations with rationale; if none, "None"}
   ```

2. `git add -A`

3. `git commit` with D-04 trailer format. Write commit message to temp file via `[System.IO.File]::WriteAllText()` (BOM-free):

   ```
   GNX375-SPEC-C22-G: author fragment G (§§14–15 + Appendix A — final fragment)

   Seventh and FINAL of 7 piecewise fragments per D-18. Completes the
   GNX 375 Functional Spec V1 body. Covers Persistent State (§14 — 
   §14.1 XPDR State replaces COM State per D-16), External I/O (§15 —
   XPL/MSFS datarefs/variables/events + §15.6 External CDI/VDI Output
   Contract per D-15 no-internal-VDI framing + §15.7 Altitude Source
   Dependency per D-16), and Family Delta Appendix A (GNX 375 as
   baseline per D-12; GPS 175 + GNC 355/355A comparison; feature
   matrix). Target: ~300 lines; actual: {N}.

   D-15 framing honored: §15.6 no on-screen VDI; vertical deviation
   output-only to external VDI for LPV/LP+V/LNAV+V. D-16 framing
   honored: §14.1 three XPDR modes persistence; §15.7 external
   ADC/ADAHRS altitude source only. D-12 framing honored: Appendix
   A.1 GNX 375 primary per pivot; GNC 355 deferred; shelved outline
   preserves 355-baseline version.

   ITM-08 discipline maintained: Coupling Summary Appendix B
   backward-refs grep-verified before finalization. EPU, HFOM/VFOM,
   HDOP, TSO-C151c NOT claimed.

   ITM-12 format discipline: Coupling Summary authored in prose-per-ref
   format ({N} lines; target 95–105) per post-Fragment-F compliance
   C2 PARTIAL finding. Each backward-ref spans 2–4 sentences.

   OPEN QUESTIONS 4 (XPL XPDR dataref names) and 5 (MSFS XPDR
   SimConnect variables) preserved verbatim for D1 Design Spec
   resolution.

   Assembly readiness: 7-fragment decomposition complete; forward-refs
   from Fragments A–F to Fragment G content all resolve; CD to author
   scripts/assemble_gnx375_spec.py + Review Priority Guide (per D-22)
   post-archive.

   Task-Id: GNX375-SPEC-C22-G
   Authored-By-Instance: cc
   Refs: D-12, D-15, D-16, D-18, D-19, D-20, D-21, D-22, ITM-08, ITM-12, GNX375-SPEC-C22-A through GNX375-SPEC-C22-F
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

   PowerShell pattern (mandatory — no inline `python -c`; no `-m` multi-flag commit):
   ```powershell
   $msg = @'
   ...commit message above with actual values substituted...
   '@
   [System.IO.File]::WriteAllText((Join-Path $PWD ".git\COMMIT_EDITMSG_cc"), $msg)
   git commit -F .git\COMMIT_EDITMSG_cc
   Remove-Item .git\COMMIT_EDITMSG_cc
   ```

4. **Flag refresh check:** No changes to CLAUDE.md / claude-project-instructions.md / claude-conventions.md / cc_safety_discipline.md / claude-memory-edits.md. Do NOT create refresh flags.

5. **Send completion notification:**
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-G completed [flight-sim] — FINAL FRAGMENT; spec body assembly-ready"
   ```

6. **Do NOT git push.** Steve pushes manually.

---

## What CD will do with this report

After CC completes:

1. CD runs check-completions Phase 1: reads prompt + completion report, cross-references claims, generates compliance prompt modeled on the C2.2-F approach (~40 items across F/S/X/C/N; slightly larger than F's 38 due to Appendix A Family Delta consistency checks + assembly-readiness checks). The compliance prompt verifies 25 self-checks + ITM-08 independent grep re-verify + D-15/D-16/D-12 framing + Appendix A sibling-unit consistency + assembly-readiness (7-fragment decomposition complete; forward-refs from A–F resolve; no duplicate headings).

2. After CC runs compliance: CD check-compliance Phase 2. PASS (or PASS WITH NOTES) → archive all 4 files to `docs/tasks/completed/`; update manifest (Fragment G → ✅ Archived; spec status → Assembly Ready); **begin aggregate assembly work per D-22**: author `scripts/assemble_gnx375_spec.py`, author `scripts/verify_gnx375_manifest.py`, prepend Review Priority Guide to aggregate spec, then draft 3 domain-specific review agents per D-22 §(2). FAIL → bug-fix task.

---

## Estimated duration

- CC wall-clock: ~12–20 min (LLM-calibrated per D-20: ~300-line docs-only fragment with heavy reuse of A–F conventions; baseline 300-line docs task = 8–15 min; reuse ×0.7 discount applies; prose-per-ref Coupling Summary adds ~3 min vs. compact-bullet pattern; ITM-08 grep-verify adds ~2 min; net ~12–20 min).
- CD coordination cost after: ~1 check-completions turn + ~1 check-compliance turn + ~0.5 turn to update manifest and begin assembly work.

Proceed when ready. This is the **final fragment** — on archive, the spec body is assembly-ready and C3 preparation can begin.
