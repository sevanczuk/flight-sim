# CC Compliance Prompt: C2.2-E — GNX 375 Functional Spec V1 Fragment E (§§8–10)

**Created:** 2026-04-23T14:48:13-04:00
**Source:** CD Purple session — Turn 3 (2026-04-23) — Phase 2 compliance verification
**Task ID:** GNX375-SPEC-C22-E-COMPLIANCE
**Parent task:** GNX375-SPEC-C22-E (completion report at `docs/tasks/c22_e_completion.md`; fragment at `docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md`)
**Predecessor:** C2.2-D compliance pattern (`docs/tasks/completed/c22_d_compliance_prompt.md`) — verification model
**Compliance scope:** 30 items across 5 categories (F / S / X / C / N), modeled on C2.2-D's 30-item pattern
**Task type:** docs-only verification (no code, no tests); read + grep + report only
**CRP applicability:** Not required

---

## Purpose

Verify CC's self-reported completion claims against the actual Fragment E file content. This is the **Phase 2 compliance** step in the C2.2-x lifecycle: CD has reviewed the completion report (Phase 1) and identified items warranting independent verification. CC's role here is to re-execute verification **against the actual file**, report PASS / PARTIAL / FAIL per item with evidence, and flag any discrepancies the completion report missed or mis-classified.

**Compliance bar:** consistent with C2.2-A through C2.2-D. Target: **ALL PASS** or **PASS WITH NOTES**. FAIL on any C-category (hard constraint) item triggers a bug-fix task.

---

## Ground Rules

1. **Read the fragment file fresh.** Do not trust the completion report's line numbers; independently grep/view the fragment and report actual evidence.

2. **Every check must cite file evidence.** Line numbers, grep counts, or exact quoted snippets. "PASS per completion report" is not acceptable — independent verification is the point of this step.

3. **Disagree with the completion report where warranted.** If CC's self-review claimed PASS but independent verification fails, mark FAIL and explain. Compliance is independent review, not rubber-stamping.

4. **Save verification scripts.** Per D-08, any Python or PowerShell used for the checks must be saved to `scripts/compliance/c22_e/` (create directory if needed). Do not use inline `python -c` or inline PowerShell one-liners for anything that reads files.

5. **Flag anything borderline as PARTIAL.** PARTIAL is the honest answer when a check is technically PASS but concerning. CD reviews PARTIALs individually.

---

## Source Files (read all before verification)

1. `docs/tasks/c22_e_prompt.md` — the original task prompt (14 hard constraints, 22 self-review items)
2. `docs/tasks/c22_e_completion.md` — CC's self-report
3. `docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — **the artifact under review** (829 lines per completion report)
4. `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` — for Appendix B grep-verify
5. `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — for §4.5, §4.6 cross-ref verification
6. `docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — for §4.9, §4.10 cross-ref verification
7. `docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — for §7.D, §7.G cross-ref verification
8. `assets/gnc355_pdf_extracted/text_by_page.json` — for PDF source-fidelity spot checks

---

## Compliance Checks

### F Category — File / Format (5 items)

**F1. Line count verification.**
- Run `wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md`.
- Completion report claims **829 lines**. Confirm.
- Per prompt: target ~455, soft ceiling ~550, acceptable band ~415–600. 829 is 38% over the 600 band upper.
- Classification: confirm this as over-band but within series pattern of structural overage. **Expected result:** PASS (line count verified; classification matches).

**F2. Character encoding integrity.**
- `grep -c '\\u[0-9a-f]\{4\}' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect 0.
- Python check (save as `scripts/compliance/c22_e/check_ufffd.py`): count U+FFFD bytes in file — expect 0.
- **Expected result:** PASS.

**F3. YAML front-matter and fragment header.**
- Read lines 1–8 of the fragment file.
- Confirm YAML has `Fragment: E` and `Covers: §§8–10 (Nearest Functions, Waypoint Information Pages, Settings/System Pages)`.
- Confirm line 9 (or the line immediately after the second `---`) is exactly `# GNX 375 Functional Spec V1 — Fragment E`.
- **Expected result:** PASS.

**F4. Coupling Summary block present.**
- `grep -n '^## Coupling Summary' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect exactly 1 match.
- Confirm three sub-blocks: "Backward cross-references", "Forward cross-references", "Outline coupling footprint".
- Report line count of Coupling Summary (completion report claims 37 lines).
- **Expected result:** PASS. Note: 37 lines is under the ~60 budget; flag under N3 for classification.

**F5. No harvest-category markers in `###` lines.**
- `grep -nE '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect 0 matches.
- **Expected result:** PASS.

---

### S Category — Structural / Source-Fidelity (8 items)

**S1. §8 sub-section count.**
- `grep -cE '^### 8\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect **5**.
- List matches: should be `### 8.1`, `### 8.2`, `### 8.3`, `### 8.4`, `### 8.5`.
- **Expected result:** PASS.

**S2. §9 sub-section count.**
- `grep -cE '^### 9\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect **5**.
- List matches: should be `### 9.1` through `### 9.5`.
- **Expected result:** PASS.

**S3. §10 sub-section count.**
- `grep -cE '^### 10\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect **13**.
- List matches: should be `### 10.1` through `### 10.13`.
- **Expected result:** PASS.

**S4. Page citation preservation spot-check (10 citations).**
- For each of the following, confirm the citation appears at the expected sub-section:
  - `[p. 179]` in §8.1 and §8.2 and §8.3
  - `[p. 180]` in §8.4 and §8.5
  - `[p. 167]` in §9.2
  - `[pp. 169–171]` or equivalent in §9.5
  - `[pp. 172–175]` in §9.4 create methods
  - `[pp. 87–88]` in §10.1
  - `[p. 89]` in §10.1 (CDI On Screen)
  - `[pp. 103–106]` in §10.11
  - `[pp. 107–108]` in §10.12
  - `[p. 109]` in §10.13
- **Expected result:** PASS for all 10.

**S5. §10.11 GPS Status field labels match PDF p. 104.**
- Grep Fragment E §10.11 for the field-definition table. Expect 4 fields: EPU, HDOP, HFOM, VFOM.
- Read `assets/gnc355_pdf_extracted/text_by_page.json` entry for page 104. Confirm the exact label set (EPU, HDOP, HFOM, VFOM) or identify any discrepancy.
- S13 discipline: PDF wins; if Fragment E uses labels not in PDF p. 104, FAIL.
- **Expected result:** PASS (per completion report's S13 instance table).

**S6. §10.6 Unit Selections — PDF/Fragment C/Prompt reconciliation. [CRITICAL]**

The completion report flags a deviation: "PDF p. 94 shows a partially different list (Distance/Speed, Fuel, Temperature, NAV Angle, Magnetic Variation). Fragment E uses the 7-type list from the task prompt Phase 0 enumeration."

Per S13 discipline, PDF trumps outline/prompt-derived sources. But per Fragment E's framing commitment #3 (no §4 re-authoring), if Fragment C §4.10 already established the authoritative 7-type list, §10.6 must match §4.10.

Execute this reconciliation:

1. Read `assets/gnc355_pdf_extracted/text_by_page.json` entry for page 94. Extract the exact list of Unit Selections parameters shown in the PDF. Report the full PDF list.
2. Grep Fragment C (`docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md`) for §4.10 Unit Selections or Units content. Report the parameter list Fragment C establishes.
3. Read Fragment E §10.6 (around line 533 in the current fragment). Report the parameter list Fragment E uses.
4. Compare all three lists. Determine:
   - (a) Are Fragment C and the PDF consistent? If YES → Fragment E should match both. If NO → Fragment C is itself a prior S13 issue that's already archived (not Fragment E's responsibility to re-litigate).
   - (b) Does Fragment E match Fragment C? (If Fragment C is authoritative per commitment #3, this is the governing comparison.)
   - (c) Does Fragment E match the PDF? (If Fragment C is not definitive on this sub-section, PDF should govern.)

**Decision rule for compliance:**
- If Fragment E matches Fragment C §4.10 → PASS (consistency with established spec trumps re-litigating outline-vs-PDF).
- If Fragment E matches PDF but not Fragment C → PARTIAL (Fragment E correct per S13, but Fragment C may need a separate correction — log as a potential future ITM).
- If Fragment E matches neither PDF nor Fragment C → FAIL.
- If Fragment E's 7-type list is justifiable as a reasonable spec expansion across PDF partial list + Fragment C baseline + AMAPI use-case needs → PASS WITH NOTES (document the reconciliation).

Report full evidence (exact lists from all three sources, side-by-side).

**S7. §9.5 Search Tabs PDF-accurate labels.**
- Grep Fragment E §9.5 for search tab labels. Expect: RECENT, NEAREST, FLIGHT PLAN, USER, SEARCH BY NAME, SEARCH BY CITY.
- Per completion report's S13 note: PDF p. 171 shows two distinct tabs (SEARCH BY NAME + SEARCH BY CITY); outline collapsed them into "Search by Facility Name". Fragment E correctly separates them.
- Read `assets/gnc355_pdf_extracted/text_by_page.json` entry for page 171. Confirm whether PDF shows two separate tabs or a single collapsed tab.
- **Expected result:** PASS (S13 correction applied). If PDF actually shows a single tab, mark FAIL and recommend restoring outline's single-tab structure.

**S8. §9.4 User Waypoint create methods table accuracy.**
- Grep Fragment E §9.4 for the 3-method table (LAT/LON, Radial/Distance, Radial/Radial).
- Read `assets/gnc355_pdf_extracted/text_by_page.json` entries for pages 172–175. Confirm the three reference methods match PDF content.
- **Expected result:** PASS.

---

### X Category — Cross-Reference Accuracy (5 items)

**X1. §10.1 cross-refs §4.10 + §7.D + §7.G.**
- Grep Fragment E §10.1 (lines ~328–411 per completion report) for three cross-refs:
  - Reference to §4.10 (Fragment C — CDI Scale display page)
  - Reference to §7.D (Fragment D — CDI Scale auto-switching)
  - Reference to §7.G (Fragment D — CDI deviation display on-screen vs. external)
- All three must be present as explicit section cross-refs (not just prose mentions of concepts).
- **Expected result:** PASS.

**X2. §10.12 built-in framing + §4.9 cross-ref.**
- Grep Fragment E §10.12 for "built-in" and reference to §4.9 (for FIS-B framing).
- Confirm no prose implies external LRU required.
- **Expected result:** PASS.

**X3. §9.2 Weather tab cross-ref §4.9.**
- Grep Fragment E §9.2 for reference to §4.9 (FIS-B weather framing) and built-in ADS-B In framing.
- Confirm OPEN QUESTION 6 (TSAA aural delivery) is NOT re-preserved verbatim in §9.2 — cross-ref only.
- **Expected result:** PASS.

**X4. §9.4 forward-ref §14 (Fragment G) for persistence.**
- Grep Fragment E §9.4 for "§14" or "Fragment G" in the persistence context.
- Confirm no persistence schema (encoding, byte layout, JSON structure) is specified in §9.4 — only the forward-ref.
- **Expected result:** PASS.

**X5. No forward-refs imply §§11–15 headers within Fragment E.**
- `grep -nE '^## 1[1-5]\.|^### (11|12|13|14|15)\.|^## Appendix' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect 0 matches.
- Forward-refs to §§11–15 appear only as inline prose cross-refs (e.g., "see §14").
- **Expected result:** PASS.

---

### C Category — Hard Constraint Honoring (14 items, one per framing commitment)

**C1. ITM-08 Coupling Summary grep-verify independently re-verified. [CRITICAL]**

Completion report claims 17 Appendix B glossary terms verified-present in Fragment A. Independently re-execute the grep:

For each of the 17 claimed terms, run against `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`:
```
grep -inE '^\*\*<TERM>\*\*:|^\*\*<TERM>\b|^### <TERM>' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
```
Or a more robust grep targeting Appendix B entries (depends on Fragment A glossary format — adjust pattern to match the actual glossary entry pattern used in Fragment A).

Terms to verify:
1. SBAS
2. WAAS
3. CDI
4. VDI
5. GPSS
6. FIS-B
7. UAT
8. 1090 ES
9. Extended Squitter
10. TSAA
11. Connext
12. TSO-C166b
13. RAIM
14. FastFind
15. CDI On Screen
16. GPS NAV Status indicator key
17. SafeTaxi

For each term, report: found at line N as formal glossary entry / found only in prose context (not a glossary entry — still a problem per ITM-08) / not found at all.

Additionally, verify the **exclusion list** (these should NOT be claimed as Appendix B entries):
- EPU
- HFOM
- VFOM
- HDOP
- TSO-C151c

Confirm these 5 terms are genuinely absent from Fragment A Appendix B (use grep against Fragment A restricted to Appendix B lines).

**Decision rule:**
- All 17 terms verified-present as formal Appendix B entries AND 5 exclusions confirmed absent → PASS.
- 1–3 terms found only in prose (not formal glossary entries) → PARTIAL. Log as ITM-08 watchpoint recurrence.
- 4+ terms missing or any of the 5 exclusions found → FAIL. Log as new ITM.

**Note on "FastFind", "CDI On Screen", "GPS NAV Status indicator key", "SafeTaxi":** These were claimed as B.3 entries in the completion report. B.3 of Fragment A Appendix B (if it exists) would be a secondary glossary section — verify its existence and content. If no B.3 section exists in Fragment A, these 4 terms need re-classification (either as B.1 entries if actually present there, or removed from claim).

**C2. Coupling Summary budget.**
- Completion report states 37 lines vs. ~60 target.
- Confirm all three required blocks are present (backward-refs, forward-refs, outline coupling footprint).
- Decision rule: if all three blocks present with adequate content → PASS (under-budget is not a failure). If any block missing or thin → PARTIAL or FAIL.
- **Expected result:** PASS.

**C3. §10 acts on §4.10, no §4 re-authoring.**
- `grep -nE '^## 4\.|^### 4\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect 0 matches.
- Read §10 scope paragraph (around lines 314–327) — confirm it references §4.10 (Fragment C) as the authoritative display source.
- **Expected result:** PASS.

**C4. §10.1 CDI On Screen = GNX 375 / GPS 175 only, lateral only, D-15 consistency.**
- Grep Fragment E §10.1 (CDI On Screen sub-section, around lines 369–411) for:
  - "GNX 375 / GPS 175" or "GNX 375 and GPS 175" (or equivalent unit specification)
  - "lateral only" (or equivalent no-vertical-on-screen language)
  - Reference to D-15
- Confirm no prose in §10.1 implies vertical deviation is shown on the GNX 375 screen.
- **Expected result:** PASS.

**C5. §10.12 ADS-B Status built-in receiver framing, consistent with Fragment C §4.10.**
- Read Fragment C §4.10 ADS-B Status framing. Read Fragment E §10.12. Confirm framing consistency (built-in receiver; no external LRU; GNX 375 primary context).
- `grep -ni "external LRU\|GDL 88\|GDL 82" docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — all matches must be in sibling-unit comparison context (GPS 175 / GNC 355 require external) or absent entirely.
- **Expected result:** PASS.

**C6. §10.13 Logs GNX 375-only ADS-B traffic logging.**
- Grep Fragment E §10.13 for "GNX 375 only" or equivalent wording applied specifically to ADS-B traffic data logging (not WAAS diagnostic logging, which is all-units).
- Confirm consistency with Fragment C §4.10 Logs framing and with D-16.
- **Expected result:** PASS.

**C7. §9 acts on §4.5, no §4 re-authoring.**
- `grep -nE '^## 4\.|^### 4\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect 0 matches (same grep as C3; both pass if grep returns 0).
- Read §9 scope paragraph (around lines 89–97) — confirm it references §4.5 (Fragment B).
- **Expected result:** PASS.

**C8. §8 acts on §4.6, no §4 re-authoring.**
- Same grep as C3/C7 — 0 matches.
- Read §8 scope paragraph (around lines 11–19) — confirm it references §4.6 (Fragment B).
- **Expected result:** PASS.

**C9. No COM present-tense on GNX 375.**
- `grep -ni 'COM radio\|COM standby\|COM volume\|COM frequency\|COM monitoring\|VHF COM' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md`
- For each match, verify it is:
  - Factual reference to frequency data (ARTCC/FSS frequency columns in §8.4/§8.5), OR
  - Explicit sibling-unit or negative statement ("GNX 375 does not have a VHF COM radio"), OR
  - In a cross-ref to Fragment A §1 framing
- No prose may state or imply "the GNX 375 has [COM feature]" in present tense.
- **Expected result:** PASS (completion report claims 4 COM matches all in factual/negative context).

**C10. S13 trust-PDF discipline applied.**
- Verify §9.5 uses "SEARCH BY CITY" per PDF (already checked in S7).
- Verify §10.11 uses EPU/HDOP/HFOM/VFOM per PDF p. 104 (already checked in S5).
- Flag any additional §§8–10 sub-section where outline and PDF might disagree and CC's choice needs inspection. Particular areas:
  - §8.2 Nearest Airports column labels (PDF p. 179 vs. outline)
  - §9.2 Airport Information tabs (PDF p. 167 vs. outline)
  - §10.5 Alerts Settings airspace types (PDF p. 93 vs. Fragment E 7-type list)
  - **§10.6 Unit Selections (handled in S6)**
- **Expected result:** PASS unless S6 changes the outcome.

**C11. No §§1–4 or §§11–15 or Appendix headers.**
- `grep -nE '^## [1-4]\.|^## 1[1-5]\.|^### ([1-4]|11|12|13|14|15)\.|^## Appendix' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — expect 0 matches.
- **Expected result:** PASS.

**C12. §9.4 persistence forward-ref to §14.**
- Grep Fragment E §9.4 for "§14" in persistence context. Verify at least one explicit forward-ref.
- Verify no persistence schema (byte layout, JSON structure, specific encoding) is in §9.4.
- **Expected result:** PASS.

**C13. §10.10 Bluetooth scope caveat preserved.**
- Grep Fragment E §10.10 for scope caveat language ("may be v1 out-of-scope", "scope caveat", "deferred to design phase", or equivalent).
- Confirm the caveat is explicit and preserves the question for design-phase resolution.
- **Expected result:** PASS.

**C14. §9.2 + §10.12 FIS-B cross-ref §4.9; OPEN QUESTION 6 not re-preserved verbatim.**
- §9.2: grep for §4.9 cross-ref in Weather tab context.
- §10.12: grep for §4.9 cross-ref in FIS-B context.
- Search for verbatim OPEN QUESTION 6 language in Fragment E — expect 0 matches (Fragment E should cross-ref Fragment C §4.9 where it's preserved, not re-preserve here).
  - Search pattern: `grep -nE 'OPEN QUESTION 6|aural delivery|aural alert' docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md`
  - Matches that are cross-refs (e.g., "see §4.9") are fine; matches that are verbatim re-preservations are a FAIL on this constraint.
- **Expected result:** PASS.

---

### N Category — Notes / Classification (4 items)

**N1. Line count 829 — content justification.**

Fragment E is 829 lines vs. target ~455, acceptable band ~415–600 upper. This is a substantially larger overshoot than any prior fragment in the series:

- Fragment A: 545 vs. target 400 — +36%
- Fragment B: 799 vs. target 720 — +11%
- Fragment C: 725 vs. target 575 — +26%
- Fragment D: 913 vs. target 750 — +22%
- Fragment E: 829 vs. target 455 — **+82%**

Classify whether the 829 lines are justified by content necessity or whether there is unnecessary verbosity.

Sampling method:
1. Count table rows in Fragment E by sub-section. Report which sub-sections have unusually dense tables.
2. Check whether AMAPI notes blocks are over-elaborated (target: 3–6 lines each, brief cross-refs; not expanded tutorials).
3. Check whether any sub-section prose repeats information already established in Fragment B §4.5/§4.6 or Fragment C §4.10 (would indicate inadvertent §4 re-authoring leaking into §8/§9/§10).
4. Check whether scope paragraphs are proportionate (target: 2–4 sentences each; not multi-paragraph essays).

Decision rule:
- Content is dense but PDF-accurate and non-duplicative → PASS WITH NOTES (series pattern; Fragment E is the smallest-target fragment so any absolute overage shows as a large relative overshoot).
- Notable duplicative content, over-elaborated AMAPI blocks, or §4 concept repetition → PARTIAL. Recommend targeted trimming (do NOT perform trimming; just report).
- Systemic bloat across many sub-sections → FAIL. Recommend CC task for restructured re-authoring.

Report line distribution across sub-sections (approximate): §8 lines, §9 lines, §10 lines, Coupling Summary lines. Compare with the per-section prose target (§8 ~70, §9 ~150, §10 ~240, Coupling Summary ~60; total ~530 budget).

**N2. §10.6 Unit Selections reconciliation (cross-ref S6).**

Cross-reference with S6 result. Regardless of S6's PASS/PARTIAL/FAIL outcome, document:
- The PDF p. 94 list (exact text).
- The Fragment C §4.10 list (exact text).
- The Fragment E §10.6 list (exact text).
- Which source CC's 7-type list traces to, and whether that choice is defensible.

If S6 returns PASS or PASS WITH NOTES, N2 is informational — no action required. If S6 returns PARTIAL or FAIL, N2 provides the evidence for the bug-fix task.

**N3. Coupling Summary 37 lines (under 60 budget).**

Completion report claims 37 lines, all three required blocks present. Verify:
- Does the Coupling Summary adequately cover the backward-refs Fragment E makes? Cross-check against Fragment E body content — for each prior-fragment reference in §§8–10, is it in the backward-refs block?
- Does the Coupling Summary adequately cover the forward-refs Fragment E makes? Cross-check against Fragment E body content — for each §§11–15 cross-ref in §§8–10, is it in the forward-refs block?
- If all coverage is complete → PASS; under-budget is not a failure.
- If gaps → PARTIAL. Recommend targeted addition.

**N4. §9.5 two-tab structural expansion.**

CC expanded the single outline tab "Search by Facility Name" into two PDF-accurate tabs ("SEARCH BY NAME" + "SEARCH BY CITY"). This is an S13-pattern Fragment E instance (counted as the second S13 occurrence in Fragment E after §10.11 field labels; fourth total across the series if counted as distinct instances).

Verify:
- The two tabs are genuinely distinct in the PDF (not the same tab with different wording).
- The S13 note in the fragment body is explicit and cites PDF page.
- The expansion does not introduce any content not in the PDF (no fabricated details).

**Expected result:** PASS as S13-pattern application. Log as fourth S13 recurrence in the completion report.

---

## Reporting Format

Write compliance report to `docs/tasks/c22_e_compliance.md`:

```markdown
---
Created: {ISO 8601 timestamp}
Source: docs/tasks/c22_e_compliance_prompt.md
---

# C2.2-E Compliance Report — GNX 375 Functional Spec V1 Fragment E

**Task ID:** GNX375-SPEC-C22-E-COMPLIANCE
**Parent task:** GNX375-SPEC-C22-E
**Fragment under review:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md`
**Completed:** {ISO 8601 date}

## Summary

| Category | Total | PASS | PARTIAL | FAIL |
|----------|-------|------|---------|------|
| F (File/Format) | 5 | — | — | — |
| S (Structural/Source-Fidelity) | 8 | — | — | — |
| X (Cross-Reference) | 5 | — | — | — |
| C (Constraints) | 14 | — | — | — |
| N (Notes/Classification) | 4 | — | — | — |
| **Total** | **36** | — | — | — |

Overall verdict: [ALL PASS / PASS WITH NOTES / PARTIAL / FAIL]

## Per-Item Results

### F Category

**F1.** [PASS/PARTIAL/FAIL]. Evidence: `wc -l` = {N}; classification note.
**F2.** [PASS/PARTIAL/FAIL]. Evidence: grep \uXXXX = {count}; U+FFFD count = {count}.
**F3.** [PASS/PARTIAL/FAIL]. Evidence: lines 1–8 quoted.
**F4.** [PASS/PARTIAL/FAIL]. Evidence: `grep -n '^## Coupling Summary'` = line {N}; sub-blocks present: [yes/no for each].
**F5.** [PASS/PARTIAL/FAIL]. Evidence: `grep -nE` for harvest markers = {count}.

### S Category

**S1.** [PASS/PARTIAL/FAIL]. Evidence: `grep -cE '^### 8\.'` = {N}; matches: [list].
...
**S6.** [PASS/PARTIAL/FAIL/PASS WITH NOTES]. Evidence:
- PDF p. 94 list: [exact list]
- Fragment C §4.10 list: [exact list]
- Fragment E §10.6 list: [exact list]
- Decision: [which governs, why]
...

### X Category
...

### C Category

**C1.** [PASS/PARTIAL/FAIL]. Evidence:
- Claimed terms grep results (one line per term):
  - SBAS: found at line N [as formal entry / in prose only / not found]
  - WAAS: ...
  - [all 17]
- Exclusion list verification:
  - EPU: absent (confirmed) / present at line N (unexpected!)
  - [all 5]
- Decision rule outcome.
...

### N Category
...

## Items Warranting New ITM

List any findings that should become new ITMs in `docs/todos/issue_index.md` (e.g., Fragment C §4.10 inconsistency with PDF if found in S6; any new S13 pattern recurrence worth tracking).

## Recommendation to CD

- [ ] Archive as-is (ALL PASS or PASS WITH NOTES on non-critical items)
- [ ] Archive with new ITMs logged (PASS WITH NOTES)
- [ ] Bug-fix task required (FAIL on any C-category item)
- [ ] Bug-fix task required (multiple PARTIALs on C-category or critical S-category items)

## Deviations from Compliance Prompt

{Any departures from the compliance checks as specified; rationale}
```

---

## Completion Steps

1. Write compliance report to `docs/tasks/c22_e_compliance.md`.
2. Save any Python/PowerShell scripts used to `scripts/compliance/c22_e/`.
3. `git add -A`
4. Commit with D-04 trailer format (write message to temp file via `[System.IO.File]::WriteAllText()`, BOM-free):

   ```
   GNX375-SPEC-C22-E-COMPLIANCE: verify fragment E compliance (30-item / 5-category)

   Phase 2 compliance verification of Fragment E (docs/specs/fragments/
   GNX375_Functional_Spec_V1_part_E.md, 829 lines). Independent re-
   verification of CC's self-review claims. Categories: F (File/Format)
   5 items, S (Structural/Source-Fidelity) 8 items, X (Cross-Reference)
   5 items, C (Constraints) 14 items, N (Notes/Classification) 4 items.
   Total: 36 items.

   Key verifications: ITM-08 Appendix B grep-verify of 17 claimed terms;
   §10.6 Unit Selections PDF / Fragment C / prompt reconciliation;
   §9.5 two-tab S13 expansion; line count 829 classification.

   Task-Id: GNX375-SPEC-C22-E-COMPLIANCE
   Authored-By-Instance: cc
   Refs: D-15, D-16, D-18, D-19, D-20, D-21, ITM-08, GNX375-SPEC-C22-E
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

   PowerShell pattern:
   ```powershell
   $msg = @'
   ...
   '@
   [System.IO.File]::WriteAllText((Join-Path $PWD ".git\COMMIT_EDITMSG_cc"), $msg)
   git commit -F .git\COMMIT_EDITMSG_cc
   Remove-Item .git\COMMIT_EDITMSG_cc
   ```

5. **Flag refresh check:** No changes to CLAUDE.md / claude-project-instructions.md / claude-conventions.md / cc_safety_discipline.md / claude-memory-edits.md. Do NOT create refresh flags.

6. **Send completion notification:**
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-E-COMPLIANCE completed [flight-sim]"
   ```

7. **Do NOT git push.** Steve pushes manually.

---

## What CD will do with this report

CD runs check-compliance (Phase 2 review). Decision matrix:

- **ALL PASS (36/36):** archive Fragment E; update manifest (Fragment E → ✅ Archived); update Task flow plan; draft C2.2-F (D-21 gated).
- **PASS WITH NOTES:** archive Fragment E with new ITMs logged; proceed to C2.2-F.
- **PARTIAL on non-critical items:** archive with notes; log ITMs for future cleanup.
- **FAIL on any C-category item:** author bug-fix task; re-run compliance after fix.
- **Multiple PARTIALs on critical items (C1, C5, C6, C10, C12) or S6:** bug-fix task required.

---

## Estimated duration

- CC wall-clock: ~8–12 min (docs-only verification; mostly grep + spot-check reads; no authoring; ITM-08 re-verification + §10.6 PDF reconciliation are the longest steps).
- CD coordination cost after this: ~1 check-compliance turn + archive or bug-fix decision.

Proceed when ready.
