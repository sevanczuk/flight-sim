# CC Compliance Prompt: C2.2-F — GNX 375 Functional Spec V1 Fragment F (§§11–13)

**Created:** 2026-04-24T07:36:04-04:00
**Source:** CD Purple session — Turn 13 (2026-04-24) — Phase 2 compliance verification
**Task ID:** GNX375-SPEC-C22-F-COMPLIANCE
**Parent task:** GNX375-SPEC-C22-F (completion report at `docs/tasks/c22_f_completion.md`; fragment at `docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md`)
**Predecessor:** C2.2-E compliance pattern (`docs/tasks/completed/c22_e_compliance_prompt.md`) — verification model; C2.2-E final verdict PASS WITH NOTES 33/3/0/0 across 36 checks
**Compliance scope:** 38 items across 5 categories (F / S / X / C / N), modeled on C2.2-E's 36-item pattern + 2 additional items for Fragment F's denser §11 content
**Task type:** docs-only verification (no code, no tests); read + grep + report only
**CRP applicability:** Not required

---

## Purpose

Verify CC's self-reported completion claims against the actual Fragment F file content. This is the **Phase 2 compliance** step in the C2.2-x lifecycle: CD has reviewed the completion report (Phase 1) and identified items warranting independent verification. CC's role here is to re-execute verification **against the actual file**, report PASS / PARTIAL / FAIL per item with evidence, and flag any discrepancies the completion report missed or mis-classified.

**Compliance bar:** consistent with C2.2-A through C2.2-E. Target: **ALL PASS** or **PASS WITH NOTES**. FAIL on any C-category (hard constraint) item triggers a bug-fix task.

---

## Ground Rules

1. **Read the fragment file fresh.** Do not trust the completion report's line numbers or self-review claims; independently grep/view the fragment and report actual evidence.

2. **Every check must cite file evidence.** Line numbers, grep counts, or exact quoted snippets. "PASS per completion report" is not acceptable — independent verification is the point of this step.

3. **Disagree with the completion report where warranted.** If CC's self-review claimed PASS but independent verification fails, mark FAIL and explain. Compliance is independent review, not rubber-stamping.

4. **Save verification scripts.** Per D-08, any Python or PowerShell used for the checks must be saved to `scripts/compliance/c22_f/` (create directory if needed). Do not use inline `python -c` or inline PowerShell one-liners for anything that reads files.

5. **Flag anything borderline as PARTIAL.** PARTIAL is the honest answer when a check is technically PASS but concerning. CD reviews PARTIALs individually.

6. **Specific attention flags** (CD flagged these during Phase 1 review):
   - **F3 encoding integrity:** CD observed `��` byte sequence where a `§` character should appear in the Coupling Summary forward-refs block. Self-check claimed 0 U+FFFD. Re-verify at byte level AND verify every `§` character in the file renders correctly.
   - **C1 ITM-08 grep-verify:** completion report claims all 20 terms present at specific line numbers in Fragment A Appendix B. Independently re-grep; verify line numbers match; verify the 5-term exclusion list (EPU, HFOM, VFOM, HDOP, TSO-C151c) is truly absent.
   - **C7 / S6 advisory text verbatim:** completion report claims §11.13 advisory text is verbatim from pp. 283–284 and p. 290. Independently read PDF pages via `text_by_page.json` and verify exact text match.

---

## Source Files (read all before verification)

1. `docs/tasks/completed/c22_f_prompt.md` — the original task prompt (16 hard constraints, 25 self-review items)
2. `docs/tasks/c22_f_completion.md` — CC's self-report
3. `docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` — **the artifact under review**
4. `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` — for Appendix B grep-verify (C1)
5. `docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — for §4.9 cross-ref verification (X3, X4)
6. `docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — for §7.2, §7.9 cross-ref verification
7. `docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` — for §10.11, §10.12, §10.13 cross-ref verification (X3, X5)
8. `assets/gnc355_pdf_extracted/text_by_page.json` — for PDF source-fidelity spot checks

**Note:** C2.2-F prompt has moved to `docs/tasks/completed/` only if CD archives it during Phase 2 review. Read it at whichever path exists; if only one copy exists, use that one.

Wait — CD has NOT yet archived the C2.2-F prompt. Read it at `docs/tasks/c22_f_prompt.md` (the pre-archive location). If that file was moved during prior work, fall back to `docs/tasks/completed/c22_f_prompt.md`.

---

## Compliance Checks

### F Category — File / Format (6 items)

**F1. Line count verification.**
- Run `(Get-Content docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md).Count` (PowerShell) OR `wc -l` equivalent.
- Completion report claims **606 lines**. Confirm.
- Per prompt: target ~540, acceptable band ~485–720, soft ceiling ~650. 606 is within band, below ceiling.
- Classification: over target by 12% — lowest relative overshoot in the E/D series (D was +22%, E was +82%). **Expected result:** PASS (line count verified).

**F2. No unicode escape sequences.**
- PowerShell: `(Select-String -Path "docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md" -Pattern '\\u[0-9a-fA-F]{4}' -AllMatches).Matches.Count`
- Expect 0.
- **Expected result:** PASS.

**F3. Character encoding integrity (§ symbol specifically). [CRITICAL ATTENTION]**

CD flagged during Phase 1 that `��` rendered in place of `§` in the Coupling Summary forward-refs bullet for §11.4. Self-check claimed 0 U+FFFD. Verify both globally and for `§` specifically:

- **Global U+FFFD check:** Save as `scripts/compliance/c22_f/check_ufffd.ps1` (or `.py`). Open the file in binary mode and count occurrences of the UTF-8 encoding of U+FFFD (EF BF BD). Report count — expect 0.

- **§ character integrity check:** Save as `scripts/compliance/c22_f/check_section_chars.ps1` (or `.py`). For each line of the file, check whether the line contains any `§` reference (search for 'section' context words OR the byte patterns `0xC2 0xA7` for § UTF-8). Count: (a) lines with correctly-encoded §; (b) lines with §-context that are missing § or have replacement characters. Report both counts. If (b) > 0, report affected line numbers and the byte sequence at the position where § should be.

- **Manual verification:** Read the Coupling Summary forward-refs section (around lines 580–600 depending on actual file structure). Quote the specific bullet that the completion report lists as "§11.4 Altitude Reporting + §11.8 Extended Squitter → §15.7 Altitude Source Dependency." Report whether the `§` before 11.4 is correctly present or corrupted.

**Decision rule:**
- 0 U+FFFD AND 0 malformed § characters → PASS.
- 1+ U+FFFD OR 1+ malformed § characters → PARTIAL (report exact location; fragment body is correct but has cosmetic encoding issue) OR FAIL if the corruption renders content ambiguous.

**F4. YAML front-matter and fragment header.**
- Read lines 1–8 of the fragment file.
- Confirm YAML has `Fragment: F` and `Covers: §§11–13 (Transponder + ADS-B Operation, Audio/Alerts/Annunciators, Messages)` (or equivalent substantive covers-line).
- Confirm line immediately after the second `---` is exactly `# GNX 375 Functional Spec V1 — Fragment F`.
- **Expected result:** PASS.

**F5. Coupling Summary block present.**
- PowerShell: `Select-String -Path "docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md" -Pattern '^## Coupling Summary'` — expect exactly 1 match.
- Confirm three sub-blocks: "Backward cross-references", "Forward cross-references", "Intra-fragment cross-references" OR "Outline coupling footprint" (C2.2-E used "Outline coupling footprint" as the 3rd block; C2.2-F prompt specified "Intra-fragment cross-references" as an additional block). Report which sub-blocks are present.
- Report line count of Coupling Summary (completion report implies ~80 lines).
- **Expected result:** PASS. Note budget: target ~80 lines (calibrated up from C2.2-D/E's ~60 for density).

**F6. No harvest-category markers in `###` lines.**
- PowerShell: `Select-String -Path "docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md" -Pattern '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])'` — expect 0 matches.
- **Expected result:** PASS.

---

### S Category — Structural / Source-Fidelity (10 items)

**S1. §11 sub-section count.**
- PowerShell: `(Select-String -Path "docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md" -Pattern '^### 11\.').Matches.Count`
- Expect **14** (11.1–11.14).
- List matches; confirm contiguous 11.1 → 11.14 ordering.
- **Expected result:** PASS.

**S2. §12 sub-section count.**
- Same pattern for `^### 12\.`. Expect **9** (12.1–12.9).
- **Expected result:** PASS.

**S3. §13 sub-section count.**
- Same pattern for `^### 13\.`. Expect **13** (13.1–13.13).
- **Expected result:** PASS.

**S4. §11.4 three-mode table structure. [CRITICAL]**
- Read §11.4 section content.
- Confirm:
  - Section heading is `### 11.4 XPDR Modes [p. 78]` (or equivalent with citation)
  - A table with exactly **3 data rows** (plus header row) listing modes
  - Row 1: Standby
  - Row 2: On
  - Row 3: Altitude Reporting
  - NO row for Ground, Test, or Anonymous mode
  - Body prose includes explicit "no Ground mode, no Test mode in the pilot UI, no Anonymous mode" framing (or equivalent)
  - WOW automatic framing explicit: "air/ground state... handled automatically" (or equivalent) with [p. 78] citation
- **Decision rule:** 3 rows + no Ground/Test/Anonymous + WOW automatic = PASS. Any additional modes in the table = FAIL. Missing WOW automatic framing = PARTIAL.

**S5. §11.5 Squawk Code Entry keypad specification.**
- Read §11.5 section content.
- Confirm:
  - 0–7 keys (ATCRBS range 0000–7777 octal) documented
  - Backspace OR outer knob for cursor movement documented
  - Unentered digits = underscores documented
  - Enter + Cancel key behaviors documented
  - Special codes (1200 VFR, 7500, 7600, 7700) listed as **informational only** — NOT as preset buttons
- **Decision rule:** All 5 elements present AND special codes informational-only = PASS. "Preset button" language for special codes = FAIL. Missing any element = PARTIAL.

**S6. §11.13 advisory table verbatim verification. [CRITICAL]**
Completion report claims 9 advisory messages — 4 from pp. 283–284 + 5 from p. 290 — with verbatim text. Independently verify:

- Read §11.13 section; enumerate all 9 advisory strings.
- Read `text_by_page.json` entries for pages 283, 284, 290.
- For each of the 9 advisories in Fragment F, locate the corresponding PDF string and compare character-by-character.

Expected advisories (from completion report):
1. "ADS-B Out fault. Pressure altitude source inoperative or connection lost." (pp. 283–284)
2. "Transponder has failed." (pp. 283–284)
3. "Transponder is operating in ground test mode." (pp. 283–284)
4. "ADS-B is not transmitting position." (pp. 283–284)
5. "1090ES traffic receiver fault." (p. 290)
6. "ADS-B traffic alerting function inoperative." (p. 290)
7. "ADS-B traffic function inoperative." (p. 290)
8. "Traffic/FIS-B functions inoperative." (p. 290)
9. "UAT traffic/FIS-B receiver fault." (p. 290)

**Decision rule:**
- All 9 strings match PDF verbatim → PASS.
- 1–2 minor punctuation/spacing deviations → PARTIAL (report exact deviations).
- 3+ deviations OR any substantive text difference → FAIL.
- Count mismatch (not 9) → FAIL.
- Messages from pp. 288–289 (GPS 175/GNC 355 + GDL 88 context) present in §11.13 → FAIL (should be excluded per Constraint C9).

**S7. §11.2 XPDR Control Panel 5 UI regions.**
- Read §11.2 section.
- Confirm 5 labeled UI regions present:
  1. Squawk Code Entry Field (or equivalent label for display of active code)
  2. VFR Key
  3. XPDR Mode Key
  4. Squawk Code Entry Keys (0–7)
  5. Data Field (toggle between pressure altitude and Flight ID)
- Read `text_by_page.json` page 75. Confirm PDF uses the same 5 UI elements.
- **Decision rule:** 5 elements present AND PDF-consistent = PASS.

**S8. §11.7 Status Indications 4-state table.**
- Read §11.7 section.
- Confirm table with 4 distinct states:
  1. IDENT active with unmodified squawk code
  2. IDENT with new squawk code entry
  3. Standby mode
  4. Altitude Reporting mode
- Tap behaviors per state documented.
- Read `text_by_page.json` page 81. Confirm PDF identifies these 4 states.
- **Decision rule:** 4 states present AND PDF-consistent = PASS.

**S9. §12.1 Alert Type Hierarchy 3-row table.**
- Read §12.1 section.
- Confirm 3-row table: Warning / Caution / Advisory with Color (red/yellow/white-or-amber), Meaning, Pilot Action columns (or equivalent structure).
- Read `text_by_page.json` page 98 to verify.
- **Expected result:** PASS.

**S10. Page citation preservation spot-check (10 citations).**
Confirm each of the following citations appears at the expected sub-section:
- `[p. 75]` in §11.2
- `[p. 76]` in §11.3 (XPDR Setup Menu)
- `[p. 77]` in §11.8 (Extended Squitter)
- `[p. 78]` in §11.4 (XPDR Modes)
- `[p. 79]` in §11.5 (Squawk Code Entry)
- `[p. 80]` in §11.6 (VFR Key + IDENT)
- `[p. 81]` in §11.7 (Status Indications)
- `[p. 82]` in §11.10 (Remote G3X Touch) OR §11.12 (XPDR Failure) — either is acceptable
- `[pp. 283–284]` in §11.13 and §13.9
- `[p. 290]` in §11.13 and §13.11
- **Expected result:** PASS for all 10.

---

### X Category — Cross-Reference Accuracy (7 items)

**X1. §13.9 cross-refs §11.13 items 1–4 WITHOUT re-enumeration.**
- Read §13.9 section.
- Verify:
  - 4 advisory conditions listed with cross-refs to §11.13 (e.g., "see §11.13 item 1")
  - Full verbatim advisory text is NOT duplicated in §13.9 (cross-ref only; the 4 conditions may be titled or summarized but not re-authored verbatim)
- **Decision rule:** Cross-refs present, no verbatim duplication = PASS. Full advisory text re-authored in §13.9 = PARTIAL (not necessarily a failure if §11.13 is still authoritative, but waste of space).

**X2. §13.11 cross-refs §11.13 items 5–9 + explicit pp. 288–289 distinction. [CRITICAL]**
- Read §13.11 section.
- Verify:
  - 5 conditions cross-ref §11.13 items 5–9 (no verbatim re-authoring)
  - **Explicit statement** that pp. 288–289 advisories (GPS 175/GNC 355 + GDL 88 LRU failures) are **NOT applicable to the GNX 375** (this is the Constraint C9 key text — must be present).
- **Decision rule:** Cross-refs present AND explicit pp. 288–289 exclusion statement = PASS. Missing exclusion statement = PARTIAL. Any pp. 288–289 advisory text appearing in §13.11 = FAIL.

**X3. §11.11 cross-refs §4.9 (Fragment C) and §10.12 (Fragment E); does NOT re-author.**
- Read §11.11 section.
- Verify:
  - Explicit cross-ref to §4.9 for FIS-B data types / Traffic display / TSAA display behavior (display-side content)
  - Explicit cross-ref to §10.12 for settings-page operational workflow (uplink time display, FIS-B WX Status sub-page, Traffic Application Status sub-page)
  - §11.11 content is limited to **receiver-side framing** (built-in, dual-link, 1090 ES + 978 UAT, no external LRU, TIS-B participant by mode)
  - No display-page layout or status-page workflow re-tabulation
- **Decision rule:** Both cross-refs present AND no re-authoring of §4.9 or §10.12 display/workflow content = PASS.

**X4. §12.4 cross-refs §4.9 for OPEN QUESTION 6; no verbatim re-preservation.**
- Read §12.4 section.
- Verify:
  - Explicit cross-ref to §4.9 (Fragment C) for OPEN QUESTION 6 (TSAA aural alert delivery mechanism)
  - Verbatim OPEN QUESTION 6 text block is NOT reproduced in §12.4 body (Fragment C is authoritative; Fragment F just cross-refs)
- `Select-String` for "aural delivery" OR "OPEN QUESTION 6" in §12.4 — acceptable matches are cross-refs ("see §4.9 for OPEN QUESTION 6") but NOT full question text
- **Decision rule:** Cross-ref present, no verbatim text = PASS.

**X5. §12.5 cross-refs §10.11 (Fragment E) for operational GPS Status page.**
- Read §12.5 section (GPS Status Annunciations).
- Verify cross-ref to §10.11 for the full operational GPS Status page (satellite graph, EPU/HFOM/VFOM/HDOP fields, SBAS Providers, annunciations).
- **Expected result:** PASS.

**X6. §12.7 and §12.8 are cross-ref-only.**
- §12.7 Traffic Annunciations — verify cross-ref to §4.9 Traffic Awareness; no re-tabulation of annunciation types.
- §12.8 Terrain Annunciations — verify cross-ref to §4.9 Terrain Awareness; no re-tabulation.
- **Decision rule:** Both are cross-ref-only (may be just a few lines each) = PASS. Full re-tabulation in either = FAIL (C3 no-re-authoring violation).

**X7. Intra-fragment cross-references present.**
- Verify in the Coupling Summary "Intra-fragment cross-references" block (or equivalent):
  - §11.7 Status Indications ↔ §12.9 XPDR Annunciations
  - §11.13 ↔ §13.9 (items 1–4)
  - §11.13 ↔ §13.11 (items 5–9)
  - §12.4 ↔ §13.9/§13.11 (aural delivery OPEN QUESTION 6)
- **Expected result:** PASS.

---

### C Category — Hard Constraint Honoring (12 items, mapping to 16 framing commitments)

**C1. ITM-08 Coupling Summary glossary-ref grep-verify — INDEPENDENT RE-CHECK. [CRITICAL]**

Completion report claims 20 Appendix B glossary terms verified-present at specific line numbers in Fragment A. Independently re-execute:

For each of the 20 claimed terms, grep Fragment A (`docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`) and report:
1. Is the term present as a formal glossary entry (in B.1, B.1 additions, B.2, or B.3 table)?
2. What is the actual line number?
3. Does the actual line number match the completion report's claimed line number (± 2 lines)?

Claimed terms (with claimed line numbers from completion report):
| # | Term | Claimed Appendix B location | Claimed line |
|---|------|----------------------------|--------------|
| 1 | CDI | B.1 main | 364 |
| 2 | GPSS | B.1 main | 371 |
| 3 | RAIM | B.1 main | 380 |
| 4 | SBAS | B.1 main | 381 |
| 5 | TSAA | B.1 main | 385 |
| 6 | VDI | B.1 main | 387 |
| 7 | WAAS | B.1 main | 390 |
| 8 | Mode S | B.1 additions | 402 |
| 9 | 1090 ES | B.1 additions | 404 |
| 10 | UAT | B.1 additions | 405 |
| 11 | Extended Squitter | B.1 additions | 406 |
| 12 | FIS-B | B.1 additions | 408 |
| 13 | TIS-B | B.1 additions | 409 |
| 14 | Flight ID | B.1 additions | 410 |
| 15 | IDENT | B.1 additions | 412 |
| 16 | WOW | B.1 additions | 413 |
| 17 | Target State and Status | B.1 additions | 414 |
| 18 | TSO-C112e | B.1 additions | 415 |
| 19 | TSO-C166b | B.1 additions | 416 |
| 20 | Connext | B.3 Garmin-specific | 440 |

**Exclusion list verification** (these must NOT be claimed as Appendix B entries in the Coupling Summary):
| Term | Required status |
|------|----------------|
| EPU | Absent from Appendix B; MAY appear in §12.5 spec-body prose only |
| HFOM | Absent from Appendix B |
| VFOM | Absent from Appendix B |
| HDOP | Absent from Appendix B |
| TSO-C151c | Absent from Appendix B |

Read the Coupling Summary in Fragment F. Verify that:
- All 20 claimed terms are listed as Appendix B backward-refs.
- None of the 5 exclusion-list terms are listed as Appendix B backward-refs.
- The exclusion list is explicitly stated ("NOT claimed: EPU, HFOM, VFOM, HDOP, TSO-C151c" or equivalent).

**Decision rule:**
- All 20 terms verified-present at correct lines (± 2) AND 5 exclusions confirmed absent from Coupling Summary → PASS.
- 1–3 terms not found OR line numbers off by > 2 → PARTIAL (report specific discrepancies).
- 4+ terms missing OR any of the 5 exclusions claimed in Coupling Summary → FAIL.

**C2. Coupling Summary ~80-line budget.**
- Count lines in the `## Coupling Summary` block.
- Target: ~80 lines (calibrated up from ~60 for Fragment F's density).
- Decision rule:
  - 60–100 lines → PASS.
  - <60 lines → PARTIAL (under-coverage concern; verify all required refs present).
  - >100 lines → PARTIAL (over-budget; verify it's density-justified not bloat).

**C3. No §4 re-authoring.**
- `Select-String -Pattern '^## 4\.|^### 4\.'` on Fragment F.
- Expect 0 matches.
- **Expected result:** PASS.

**C4. §11.11 BUILT-IN DUAL-LINK RECEIVER framing.**
- Read §11.11 section.
- Verify explicit framing:
  - (a) Built-in on GNX 375, no external LRU required
  - (b) Dual-link: 1090 ES (traffic) + 978 MHz UAT (FIS-B / UAT traffic)
  - (c) Operates in all three XPDR modes
  - (d) TIS-B participant status active only in On + Altitude Reporting (NOT Standby)
- `Select-String` for "GDL 88" or "GTX 345" — any matches must be in sibling-unit comparison context (explicitly "GPS 175 and GNC 355 require GDL 88 or GTX 345"), NEVER "GNX 375 requires GDL 88/GTX 345."
- **Decision rule:** All 4 framing elements present AND no "GNX 375 requires external" prose = PASS.

**C5. §11.10 v1 out-of-scope flag.**
- Read §11.10 section.
- Verify:
  - Explicit "not implemented in the v1 Air Manager instrument" (or equivalent) framing
  - Capabilities list preserved (G3X Touch can control squawk code, mode, IDENT, ADS-B Out toggle, Flight ID)
- **Expected result:** PASS.

**C6. §11.4 three-modes only. (Independently verified beyond S4.)**
- Same grep approach as S4, but cross-check §11 overall for any mode references beyond Standby/On/Altitude Reporting.
- `Select-String` Fragment F for "Ground mode" / "Test mode" / "Anonymous mode" — any matches must be in explicit denial context ("there is no Ground mode") OR sibling-unit context.
- **Decision rule:** Zero assertions of any 4th mode existing on GNX 375 = PASS.

**C7. §11.13 total = 9 advisories. (Covered by S6.)**
- Restate S6 outcome. PASS if S6 passed; FAIL if S6 failed.

**C8. §12.4 TSAA aural present on GNX 375.**
- Read §12.4.
- Verify explicit statement that aural alerts are present on GNX 375 via TSAA (not "GNX 375 only, not GNC 355" as in old GNC 355 spec; framing is now "present on GNX 375 via TSAA").
- Verify mute function = current alert only, not future alerts.
- **Decision rule:** Present-on-GNX-375 framing + mute-current-only = PASS.

**C9. §12.9 XPDR Annunciations replaces COM Annunciations. (Verified via no-COM-content check.)**
- Read §12.9.
- `Select-String` §12.9 for "COM " (with space) and "VHF COM" — any matches must be in explicit denial context ("GNX 375 has no VHF COM radio; all annunciations here are transponder-related") OR explicitly marking replacement of GNC 355's §12.9.
- Verify §12.9 content:
  - Squawk code display
  - Mode indicator (SBY / ON / ALT — three modes only)
  - Reply (R) indicator
  - IDENT active indicator
  - Failure indicator ("X" over IDENT key)
- **Decision rule:** 5 XPDR elements present AND no COM-on-GNX-375 content = PASS.

**C10. §13.9 XPDR Advisories replaces COM Radio Advisories.**
- Read §13.9.
- Verify explicit header or body statement that §13.9 replaces GNC 355's §13.9 COM Radio Advisories.
- Verify 4 XPDR/ADS-B Out advisory conditions cross-ref §11.13 items 1–4.
- No COM radio content.
- **Expected result:** PASS.

**C11. No COM present-tense on GNX 375 (fragment-wide).**
- `Select-String` Fragment F for `COM radio|COM standby|COM volume|COM frequency|COM monitoring|VHF COM`.
- Classify each match:
  - (a) Sibling-unit comparison ("GNC 355 has a VHF COM radio; GNX 375 does not") → ACCEPTABLE
  - (b) Explicit negation ("The GNX 375 has no VHF COM radio") → ACCEPTABLE
  - (c) Replacement framing ("replaces COM Radio Advisories from GNC 355") → ACCEPTABLE
  - (d) Present-tense assertion of COM capability on GNX 375 → FAIL
- Report count of each category.
- **Decision rule:** 0 matches in category (d) = PASS.

**C12. External altitude source framing consistent.**
- `Select-String` Fragment F for "ADC" / "ADAHRS" / "altitude encoder" / "altitude source".
- Verify references in §11.1, §11.3 (Setup Menu pressure altitude display), §11.4 (Altitude Reporting mode), §11.8 (Extended Squitter altitude content), §11.13 advisory #1 (altitude source loss), Coupling Summary Fragment A §3 backward-ref.
- All references frame altitude source as **external** (not internally computed).
- **Decision rule:** 5+ consistent external-source references across the listed locations AND no prose implying internal computation = PASS.

---

### N Category — Notes / Classification (3 items)

**N1. Line count 606 classification.**
- 606 vs. target 540 = +12% overage.
- Within acceptable band (485–720).
- Below soft ceiling (650).
- Lowest relative overshoot in the E/D fragment series (D: +22%, E: +82%).
- Classify content density per section:
  - §11 line count (target ~280, ~14 sub-sections = ~20 lines per sub-section)
  - §12 line count (target ~120, 9 sub-sections = ~13 lines per sub-section)
  - §13 line count (target ~180, 13 sub-sections = ~14 lines per sub-section)
  - Coupling Summary line count (target ~80)
- Report per-section approximate line counts. Assess whether §11's density is justified (14 sub-sections with D-16 framing, 9 advisory items, 5 UI regions, 4 status states, etc. — naturally dense) or if there's trimmable prose.
- **Expected result:** PASS WITH NOTES (classification) — density-justified.

**N2. Open-question preservation checklist verification.**

For each open question, verify preservation status in Fragment F:

| OQ # | Topic | Expected location in Fragment F |
|------|-------|-------------------------------|
| 4 | XPL XPDR dataref names | §11.14 open-questions block; §11.5/§11.6/§11.8 AMAPI notes |
| 5 | MSFS XPDR SimConnect variables | §11.14 open-questions block; same cross-refs |
| 6 | TSAA aural delivery mechanism | Cross-ref only to §4.9 Fragment C — NOT verbatim in Fragment F |
| §11.10 flag | Remote G3X Touch v1 scope | Explicit flag in §11.10 |
| §11.11 flag | Simulator ADS-B In availability | Flagged as design-phase decision |

Verify each; report status.
**Expected result:** PASS.

**N3. Coupling Summary block structure verification.**

Verify Coupling Summary contains 4 distinct sub-blocks:
1. Backward cross-references (to Fragments A, B, C, D, E)
2. Forward cross-references (to Fragment G)
3. Intra-fragment cross-references (within Fragment F)
4. Outline coupling footprint

Each sub-block should have substantive content. The intra-fragment block is new for Fragment F (most-coupled fragment); it should enumerate the §11↔§12↔§13 cross-refs.

**Expected result:** PASS.

---

## Reporting Format

Write compliance report to `docs/tasks/c22_f_compliance.md`:

```markdown
---
Created: {ISO 8601 timestamp}
Source: docs/tasks/c22_f_compliance_prompt.md
---

# C2.2-F Compliance Report — GNX 375 Functional Spec V1 Fragment F

**Task ID:** GNX375-SPEC-C22-F-COMPLIANCE
**Parent task:** GNX375-SPEC-C22-F
**Fragment under review:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md`
**Completed:** {ISO 8601 date}

## Summary

| Category | Total | PASS | PASS WITH NOTES | PARTIAL | FAIL |
|----------|-------|------|-----------------|---------|------|
| F (File/Format) | 6 | — | — | — | — |
| S (Structural/Source-Fidelity) | 10 | — | — | — | — |
| X (Cross-Reference) | 7 | — | — | — | — |
| C (Constraints) | 12 | — | — | — | — |
| N (Notes/Classification) | 3 | — | — | — | — |
| **Total** | **38** | — | — | — | — |

Overall verdict: [ALL PASS / PASS WITH NOTES / PARTIAL / FAIL]

## Per-Item Results

### F Category

**F1.** [PASS/PARTIAL/FAIL]. Evidence: line count = {N}; classification note.
**F2.** [PASS/PARTIAL/FAIL]. Evidence: unicode escape grep count = {count}.
**F3.** [PASS/PARTIAL/FAIL]. Evidence: U+FFFD byte count = {count}; § character integrity check result (specific lines affected if any).
**F4.** [PASS/PARTIAL/FAIL]. Evidence: lines 1–8 quoted.
**F5.** [PASS/PARTIAL/FAIL]. Evidence: Coupling Summary present; sub-blocks present: [list]; line count = {N}.
**F6.** [PASS/PARTIAL/FAIL]. Evidence: harvest marker grep count = {count}.

### S Category

**S1.** [PASS/PARTIAL/FAIL]. Evidence: §11 sub-section count = {N}; list of sub-section identifiers.
**S2.** [PASS/PARTIAL/FAIL]. Evidence: §12 sub-section count = {N}; list.
**S3.** [PASS/PARTIAL/FAIL]. Evidence: §13 sub-section count = {N}; list.
**S4.** [PASS/PARTIAL/FAIL]. Evidence: §11.4 table structure; mode list; WOW framing quote.
**S5.** [PASS/PARTIAL/FAIL]. Evidence: §11.5 keypad elements verified; special-codes framing quote.
**S6.** [PASS/PARTIAL/FAIL]. Evidence: 9 advisory texts from §11.13; PDF pp. 283–284 and 290 comparison (character-by-character for each of the 9).
**S7.** [PASS/PARTIAL/FAIL]. Evidence: §11.2 5 UI regions; PDF p. 75 cross-ref.
**S8.** [PASS/PARTIAL/FAIL]. Evidence: §11.7 4 states; PDF p. 81 cross-ref.
**S9.** [PASS/PARTIAL/FAIL]. Evidence: §12.1 3-row table; PDF p. 98.
**S10.** [PASS/PARTIAL/FAIL]. Evidence: 10 citation spot-checks; table of results.

### X Category

**X1.** [PASS/PARTIAL/FAIL]. Evidence: §13.9 cross-refs verified; no re-enumeration.
...continue for X2–X7

### C Category

**C1.** [PASS/PARTIAL/FAIL]. Evidence:
- Claimed terms grep results (table: term / claimed line / actual line / match):
  - SBAS: claimed 381, actual {N}, match: yes/no
  - ... (all 20)
- Exclusion list verification table:
  - EPU: absent/present; if present, context
  - ... (all 5)
- Coupling Summary exclusion-list statement verification: present/absent
- Decision rule outcome.
**C2–C12.** [same detailed format]

### N Category

**N1.** [PASS WITH NOTES / PARTIAL]. Evidence: per-section line counts; density classification.
**N2.** [PASS/PARTIAL/FAIL]. Evidence: open-question preservation checklist results.
**N3.** [PASS/PARTIAL/FAIL]. Evidence: Coupling Summary sub-block enumeration.

## Items Warranting New ITMs

List any findings that should become new ITMs in `docs/todos/issue_index.md`.

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

1. Write compliance report to `docs/tasks/c22_f_compliance.md`.
2. Save any Python/PowerShell scripts used to `scripts/compliance/c22_f/`.
3. `git add -A`
4. Commit with D-04 trailer format (write message to temp file via `[System.IO.File]::WriteAllText()`, BOM-free):

   ```
   GNX375-SPEC-C22-F-COMPLIANCE: verify fragment F compliance (38-item / 5-category)

   Phase 2 compliance verification of Fragment F (docs/specs/fragments/
   GNX375_Functional_Spec_V1_part_F.md, 606 lines). Independent re-
   verification of CC's self-review claims. Categories: F (File/Format)
   6 items, S (Structural/Source-Fidelity) 10 items, X (Cross-Reference)
   7 items, C (Constraints) 12 items, N (Notes/Classification) 3 items.
   Total: 38 items.

   Key verifications: § character integrity (CD flagged possible
   encoding anomaly in Coupling Summary); ITM-08 Appendix B grep-verify
   of 20 claimed terms with line-number match; §11.13 advisory text
   verbatim vs. PDF pp. 283-284, 290; §11.4 three-modes-only
   structural verification; §11.11 built-in dual-link framing.

   Task-Id: GNX375-SPEC-C22-F-COMPLIANCE
   Authored-By-Instance: cc
   Refs: D-15, D-16, D-18, D-19, D-21, D-22, ITM-08, GNX375-SPEC-C22-F
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
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-F-COMPLIANCE completed [flight-sim]"
   ```

7. **Do NOT git push.** Steve pushes manually.

---

## What CD will do with this report

CD runs check-compliance (Phase 2 review). Decision matrix:

- **ALL PASS (38/38):** archive Fragment F; update manifest (Fragment F → ✅ Archived); update Task flow plan; draft C2.2-G (D-21 gated).
- **PASS WITH NOTES:** archive Fragment F with new ITMs logged; proceed to C2.2-G.
- **PARTIAL on non-critical items:** archive with notes; log ITMs for future cleanup.
- **FAIL on any C-category item:** author bug-fix task; re-run compliance after fix.
- **Multiple PARTIALs on critical items (C1, C4, C6, C9, C11, C12) or critical S items (S4, S6):** bug-fix task required.

---

## Estimated duration

- CC wall-clock: ~10–15 min (docs-only verification; grep + PDF cross-check; § character integrity check is the longest non-automated step; ITM-08 20-term re-verify and §11.13 9-advisory verbatim verify are mechanical once scripts are written).
- CD coordination cost after this: ~1 check-compliance turn + archive or bug-fix decision.

Proceed when ready.
