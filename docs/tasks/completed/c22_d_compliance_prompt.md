# CC Task: C2.2-D Compliance Verification

**Created:** 2026-04-23T09:20:16-04:00
**Source:** CD Purple session — Turn 18 (2026-04-23) — Phase 1 check-completions generating Phase 2 compliance verification
**Task ID:** GNX375-SPEC-C22-D-COMPLIANCE
**Purpose:** Independently verify the hard-constraint framing commitments, source fidelity, cross-reference fidelity, fragment file conventions, ITM-08 grep-verify accuracy, ITM-09 §7.9 authorship coverage, and negative checks declared in `docs/tasks/c22_d_completion.md`. Modeled on the C2.2-C compliance structure.

**Scope of verification:** all content in `docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` (913 lines per completion report). Do NOT verify anything outside this fragment except where explicitly instructed (PDF spot checks, Fragment A/B/C cross-references, outline forward-ref targets).

**Output:** `docs/tasks/c22_d_compliance.md` — a compliance report with a PASS/FAIL/PARTIAL verdict for each numbered check, each accompanied by specific evidence (line numbers, grep counts, PDF page citations, and short verbatim quotes where supportive).

**Verdict conventions:**
- **PASS** — constraint verifiably met
- **FAIL** — constraint verifiably violated (would require fix)
- **PARTIAL** — constraint met with a noted caveat (e.g., minor over-enumeration acceptable, PDF extraction limits)
- Use Notes section for observations that don't affect verdict but preserve context for future work

---

## Pre-flight

1. Verify the fragment file exists and has expected line count:
   ```bash
   wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md
   ```
   Expect: 913 lines (per completion report). If substantially different (>±5), note as pre-flight anomaly.

2. Verify Fragment A, B, C are available for backward-ref verification:
   ```bash
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md
   ```

3. Verify outline and PDF JSON are available for source-fidelity checks:
   ```bash
   ls docs/specs/GNX375_Functional_Spec_V1_outline.md
   ls assets/gnc355_pdf_extracted/text_by_page.json
   ```

4. Read the full fragment into working memory.

5. Read the completion report `docs/tasks/c22_d_completion.md`.

6. Read Fragment C sections that forward-ref §7.9 (Fragment C lines 226 and 232 per completion report).

---

## Checks

### F. Framing Commitments (14 checks)

**F1. `### 7.9` authored as a real sub-section exactly once (ITM-09 resolution).**

- `grep -c '^### 7\.9' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` must return exactly **1**
- Quote the heading line and its line number
- Confirm heading is in the §7 block (not misplaced)

**F2. §7.9 covers XPDR ALT mode during approach + WOW automatic handling.**

Locate §7.9 sub-section. Verify prose explicitly states:
- XPDR operates in Altitude Reporting (ALT) mode during approach flight phases
- Air/ground state / WOW (weight-on-wheels) is handled automatically by the unit — no pilot mode change required on landing/takeoff transitions
- Reference to p. 78 for the WOW-automatic behavior

Quote the key sentences and line numbers.

**F3. §7.9 covers ADS-B Out transmission during approach (1090 ES continuous in ALT mode).**

Verify §7.9 states:
- ADS-B Out (1090 ES Extended Squitter) is continuous when XPDR is in ALT mode
- Position + altitude transmitted throughout approach phases

Quote the key sentences and line numbers.

**F4. §7.9 covers TSAA-during-approach = GNX 375 only (aural alerts) with OPEN QUESTION 6 cross-ref.**

Verify §7.9 states:
- TSAA traffic alerting continues during approach flight phases
- TSAA is GNX 375 only (GPS 175 and GNC 355/355A do not have TSAA)
- OPEN QUESTION 6 (TSAA aural delivery mechanism) is cross-referenced to §4.9 (Fragment C) — NOT re-preserved verbatim here
- §12.4 (Fragment F) cross-referenced for aural alert hierarchy

Quote the TSAA-specific sentences + cross-refs. Confirm OPEN QUESTION 6 is NOT re-preserved verbatim in §7.9 (it should only cross-ref, per prompt hard constraint #11).

**F5. §7.9 covers flight phase + XPDR state concurrent display correlation.**

Verify §7.9 states:
- Annunciator bar flight phase (LPV, LNAV, LP+V, etc.) appears concurrent with XPDR mode indicator
- Both visible simultaneously on display during approach operations

Quote and line number.

**F6. §7.9 three XPDR modes only (per D-16): Standby / On / Altitude Reporting.**

`grep -ni 'Standby\|Altitude Reporting' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — verify §7.9 section explicitly states the three modes only. Confirm NO mention of Ground mode / Test mode / Anonymous mode as GNX 375 operational modes in §7.9.

**F7. §7.9 forward-refs §11, §11.4, §11.11, §12.4, §4.9, §15 for interaction details.**

Verify §7.9 cross-references resolve to:
- §11 (Fragment F) for XPDR control detail
- §11.4 (Fragment F) for XPDR modes
- §11.11 (Fragment F) for ADS-B In receiver
- §12.4 (Fragment F) for aural alert hierarchy
- §4.9 (Fragment C) for traffic display + OPEN QUESTION 6
- §15 (Fragment G) for XPDR + ADS-B datarefs

Enumerate which cross-refs are present.

**F8. §7.5 approach types table: 7 types matching Fragment C §4.7.**

Compare Fragment D §7.5 approach types to Fragment C §4.7 approach types. Expected 7 types (both fragments): LNAV, LNAV/VNAV, LNAV+V, LPV, LP, LP+V, ILS. Verify:
- Same 7 labels in both fragments
- No contradictions on "SBAS required" or "GPS nav approval" fields where those columns appear in both

If Fragment D's §7.5 table has additional columns (operational state machine, CDI scale), confirm the additional columns don't contradict Fragment C.

**F9. §7.2 GPS Flight Phase Annunciations: 11 rows matching Fragment C §4.7 (S13-pattern continued).**

Compare Fragment D §7.2 table to Fragment C §4.7 table. Expected 11 rows (both fragments): OCEANS, ENRT, TERM, DPRT, LNAV, LNAV/VNAV, LNAV+V, LP, LP+V, LPV, MAPR. Verify:
- Same 11 labels in both fragments
- Color semantics (green normal, yellow caution) consistent

If Fragment D's table has additional rows, flag. If fewer rows, FAIL.

**F10. No internal VDI throughout §7 (per D-15).**

`grep -ni 'VDI\|vertical deviation indicator' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — enumerate matches. Every match must either:
- Frame vertical deviation as external output only ("external CDI/VDI", "no internal VDI", "output to external instruments")
- Be a cross-reference to §15.6 (Fragment G) for the external output contract
- Be an explicit "no internal VDI per D-15" framing

NO match may imply the GNX 375 renders a VDI internally. Check §7.5 RNAV, §7.C ILS, §7.G CDI deviation, §7.8 autopilot outputs specifically.

**F11. ITM-08 grep-verify accuracy — re-grep Fragment A Appendix B.**

Fragment D completion report lists 25 terms as "confirmed present" in Fragment A Appendix B backward-refs: FAF, MAP, LPV, LNAV, SBAS, WAAS, TSAA, FIS-B, UAT, 1090 ES, Extended Squitter, TSO-C112e, TSO-C166b, WOW, IDENT, Flight ID, GPSS, VDI, CDI, OBS, RAIM, VCALC, DTK, ETE, XTK, XPDR.

Write a Python script (saved `.py` file) OR use grep to verify each of these 25 terms appears as a formal glossary entry in Fragment A's Appendix B section. Report FOUND / NOT FOUND per term with specific Fragment A line number.

If any term claimed as "present" is actually absent (parallel to the ITM-08 X17 finding for Fragment C), flag as FAIL with specific details. If all 25 are genuinely present, PASS.

Also verify the 4 excluded terms (EPU, HFOM/VFOM, HDOP, TSO-C151c) are NOT in Fragment D's Coupling Summary backward-refs list.

**F12. OPEN QUESTION 6 NOT re-resolved or re-preserved verbatim in Fragment D.**

`grep -ni 'sound_play\|OPEN QUESTION 6' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — enumerate matches. Expected:
- Cross-references to §4.9 (Fragment C) OR §12.4 (Fragment F) — these are acceptable
- Any verbatim preservation of the full question (including `sound_play` language) — flag as PARTIAL with rationale (the prompt's hard constraint #11 said "does NOT re-preserve verbatim; cross-refs only")

**F13. No COM present-tense on GNX 375.**

`grep -nEi 'COM radio|COM standby|COM volume|COM frequency|COM monitoring|VHF COM' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — enumerate matches. Each match must be:
- In a sibling-unit comparison context ("unlike the GNC 355 which has a VHF COM radio..."), OR
- In a forward-ref to the deferred 355 workstream (unlikely in Fragment D scope)

NO match may present-tense attribute COM functionality to the GNX 375.

**F14. No §4 content re-authored (Fragments B and C own §4).**

`grep -nE '^## 4\.|^### 4\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — expect **0 matches**. Fragment D does not author any `## 4.` or `### 4.X` headings. §4 content is cross-referenced in prose (e.g., "see §4.3 in Fragment B") but NOT authored as headings.

---

### S. Source Fidelity (5 checks)

**S15. §7.5 downgrade message text verbatim check.**

Fragment D §7.5 should quote "GPS approach downgraded. Use LNAV minima." (per outline line 201). Verify:
- Quoted string appears in Fragment D §7.5
- Under 15 words (it's 6 words — PASS on length)
- In quotation marks (not reflowed as prose)
- Attributed to approach downgrade condition

**S16. §7.C ILS pop-up text verbatim check.**

Fragment D §7.C should quote "ILS and LOC approaches are not approved for GPS." (per outline). Verify:
- Quoted string appears in Fragment D §7.C
- Under 15 words (it's 9 words — PASS on length)
- In quotation marks
- Attributed to ILS approach load pop-up

**S17. §7.8 autopilot KAP 140 / KFC 225 specific compatibility check.**

Fragment D §7.8 should mention KAP 140 and KFC 225 as LPV glidepath-capture-compatible autopilots (per outline). Verify both autopilot model names are present. Verify "Enable APR Output" advisory text is quoted.

**S18. §7.D CDI scale HAL table — PDF p. 88 verification.**

The completion report states §7.D HAL table is "0.30/1.00/2.00/2.00 nm" — note the duplicated "2.00". Write a Python script that extracts text from PDF p. 88 and reports HAL values by flight phase. Expected per outline: Approach 0.30 nm, Terminal 1.00 nm, En Route 2.00 nm. If PDF shows only 3 values, Fragment D's 4-value claim ("0.30/1.00/2.00/2.00") is either a typo or extending the outline. Report PDF findings.

**S19. §5.6 Parallel Track offset range — PDF pp. 147–148 verification.**

The completion report states §5.6 documents "1–99 nm offset" range. Write a Python script (or extend the one above) that extracts text from PDF pp. 147–148 and searches for the numeric offset range. Confirm Fragment D's claim matches the PDF.

**S20. §5.3 Waypoint Options menu — PDF pp. 152–153 verification.**

The completion report states §5.3 documents 8 Waypoint Options menu items: Insert Before, Insert After, Load PROC, Load Airway, Activate Leg, Hold at WPT, WPT Info, Remove. Outline listed fewer (Insert Before/After, Remove, Direct-to, Waypoint Info, Procedure from FPL — 6). Write a Python script (or extend) that extracts text from PDF pp. 152–153 and searches for each of the 8 claimed options. Report FOUND / NOT FOUND per option. If additions are PDF-sourced, this is S13-pattern (fragment extending outline from PDF). If any are absent from PDF, flag.

**S21. Page citation preservation — 12-citation spot check.**

Verify each citation appears in the fragment at the corresponding sub-section:

| Citation | Expected Sub-section |
|---|---|
| `[pp. 150–151]` | §5.1 Flight Plan Catalog |
| `[pp. 129–132]` | §5.4 Graphical FPL Editing |
| `[pp. 159–164]` | §6 Direct-to heading or §6.1 |
| `[pp. 181–207]` | §7 Procedures heading or §7.1 |
| `[pp. 184–185]` | §7.2 GPS Flight Phase Annunciations |
| `[p. 191]` | §7.5 SBAS Channel ID |
| `[p. 198]` | §7.5 ILS OR §7.C |
| `[pp. 199–206]` | §7.5 RNAV approaches |
| `[p. 207]` | §7.8 Autopilot Outputs |
| `[pp. 75–82]` | §7.9 XPDR heading |
| `[p. 89]` | §7.G CDI On Screen cross-ref |
| `[p. 157]` | §7.J Fly-over waypoint symbol |

Report PASS/FAIL per citation.

---

### X. Cross-Reference Fidelity (3 checks)

**X22. Fragment A/B/C backward-refs resolve to real sub-sections.**

Coupling Summary declares backward-ref categories:
- Fragment A §1 (GNX 375 baseline, no-internal-VDI)
- Fragment A §2 (inner knob = Direct-to)
- Fragment A Appendix B (25 glossary terms — covered by F11 re-grep)
- Fragment B §4.2 (Map graphical FPL editing target)
- Fragment B §4.3 (FPL Page — §5 target)
- Fragment B §4.4 (Direct-to Page — §6 target)
- Fragment C §4.7 (Procedures display — §7 target; approach types + GPS Flight Phase consistency)
- Fragment C §4.9 (TSAA — §7.9 cross-ref)
- Fragment C §4.10 (CDI Scale/CDI On Screen — §7.D/§7.G cross-refs)

Use `grep -n` to locate each target in Fragment A, B, or C as appropriate. Report PASS/FAIL per category.

**X23. Fragment C §4.7 forward-refs to §7.9 actually resolve to §7.9 content (ITM-09 verification).**

Fragment C §4.7 has two forward-refs to §7.9:
1. Line 226: XPDR altitude reporting / WOW state interaction → should resolve to §7.9 XPDR-ALT-mode-during-approach content (F2 verification)
2. Line 232: TSAA behavior during approach → should resolve to §7.9 TSAA-during-approach content (F4 verification)

Confirm both forward-refs semantically resolve (not just that §7.9 exists as a heading, but that its content covers both topics). Cross-link to F2 and F4 verdicts. If either topic is missing from §7.9, flag — this is the ITM-09 completeness verification.

**X24. Forward-ref targets exist in outline (E/F/G targets).**

Fragment D Coupling Summary forward-refs to later fragments. Verify each target section exists in the outline:

| Forward-ref | Expected outline location |
|---|---|
| §10 | `## 10. Settings / System Pages` |
| §11 | `## 11. Transponder + ADS-B Operation` |
| §11.4 | §11 sub-section for XPDR Modes |
| §11.11 | §11 sub-section for ADS-B In (Built-in Dual-link Receiver) |
| §12.2 | §12 Audio, Alerts sub-section for Alert Annunciations |
| §12.4 | §12 Aural Alerts |
| §13 | `## 13. Messages` |
| §15 | `## 15. External I/O` |
| §15.6 | §15 sub-section for External CDI/VDI Output Contract |

Use `grep -n` to locate each target. Report PASS/FAIL per target. PARTIAL acceptable if target is an outline-bullet rather than `##`/`###` heading (consistent with Fragment C §12.4 / §15.6 pattern).

---

### C. Fragment File Conventions (2 checks)

**C25. YAML front-matter, fragment header, heading levels correct per D-18.**

Verify:
- Lines 1–6: YAML front-matter with `Created`, `Source: docs/tasks/c22_d_prompt.md`, `Fragment: D`, `Covers: §§5–7 ...`
- Fragment header: `# GNX 375 Functional Spec V1 — Fragment D`
- Top-level sections: `## 5.`, `## 6.`, `## 7.`
- Sub-sections use `###` (numeric and lettered both `###`)
- No harvest-category markers: `grep -nE '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])'` — expect 0 matches

**C26. Coupling Summary correctly delineated; §7.9 authorship note present.**

Verify:
- `## Coupling Summary` heading exists
- Preceded by `---` horizontal rule
- "authored per D-18 for CD/CC coordination" and "stripped on assembly" language present
- Backward-refs (A + B + C) present
- Forward-refs (E + F + G) present
- **§7.9 authorship note present** stating Fragment D creates §7.9 per ITM-09
- Outline coupling footprint note present

Quote the §7.9 authorship note. Line-number the Coupling Summary start and end.

---

### N. Negative Checks (4 checks)

**N27. `grep -c '^### 7\.9'` returns exactly 1.**

Redundant with F1 but deliberately restated as independent negative check. Count must equal 1 (no more, no less). If 0, ITM-09 FAIL. If >1, duplicate heading FAIL.

**N28. No §§8–15 section headers authored in Fragment D.**

`grep -nE '^## [8-9]\.|^## 1[0-5]\.|^### (8|9|10|11|12|13|14|15)\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — expect **0 matches**. Forward-refs to §§8–15 appear only as prose cross-refs.

**N29. No §§1–4 section headers re-authored.**

`grep -nE '^## [1-4]\.|^### (1|2|3|4)\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — expect **0 matches**. §§1–4 are Fragments A and B/C; Fragment D does not re-author.

**N30. No §11 XPDR panel internals authored in §7.9 (page structure only; operations in §11 Fragment F).**

`grep -nEi 'squawk code entry|IDENT button press|Mode S protocol|Extended Squitter transmission mechanics' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` — enumerate matches. Each match must be:
- A cross-reference to §11 or §11.4
- A contextual mention (e.g., "ADS-B Out uses 1090 ES Extended Squitter" describing the signal, not panel mechanics)

NOT:
- Step-by-step squawk code entry workflow
- IDENT button press UI detail
- Mode S protocol mechanics
- XPDR mode transition UI workflow

§7.9 should describe what XPDR does during approach phases, not how to operate the XPDR panel (which is §11 Fragment F scope).

---

## Notes section

Include a Notes section at the end of the compliance report for observations that don't fit a PASS/FAIL check. Candidates:

1. **Line-count overage classification:** 913 vs. 750 target (+22%; 13 above 900 band upper bound). Continues the series trend (A=22%, B=11%, C=26%, D=22%). If S20 confirms §5.3 Waypoint Options menu is PDF-sourced (8 items vs. outline 6), that's a structural-overage contributor along with the 22 §7 sub-sections. Likely no action required; observation-level.

2. **§7.D HAL table "2.00/2.00" duplication:** completion report shows 4-value HAL ("0.30/1.00/2.00/2.00"). PDF p. 88 check (S18) resolves whether this is typo, extension, or legitimate per-phase-pair representation.

3. **§5.3 Waypoint Options menu: 8 items vs. outline 6.** If PDF-confirmed (S20), this is S13-pattern (fragment > outline on PDF accuracy). Third recurrence in the series (Fragment C added LNAV/VNAV + MAPR; Fragment B's S13 Search-by-City vs. outline).

4. **ITM-08 grep-verify executed at authoring time:** this is the first fragment where the grep-verify was embedded in the authoring phase (not post-hoc compliance). If F11 confirms the 25-term list, the ITM-08 watchpoint discipline is working as intended.

5. **ITM-09 §7.9 content completeness:** Fragment C forward-refs are the contract. X23 verifies semantic resolution, not just heading existence. If X23 PASS, ITM-09 can be closed during archive.

6. **Parallel-track and Dead Reckoning wording:** §5.6 claims "1–99 nm offset" and §5.7 claims "en route/oceanic only" Dead Reckoning. Both are PDF details worth spot-verifying as time permits (S19 covers parallel track; Dead Reckoning mention at outline line ~146 may deserve independent check).

---

## Completion

1. Write `docs/tasks/c22_d_compliance.md` with:
   - YAML front-matter: `Created`, `Source: docs/tasks/c22_d_compliance_prompt.md`
   - Summary table: total checks, PASS/FAIL/PARTIAL counts
   - Results sections in order (F, S, X, C, N) with evidence per check
   - Notes section
   - Verdict line: "ALL PASS", "PASS WITH NOTES", "PARTIAL PASS", or "FAIL"

2. `git add -A`

3. `git commit` with D-04 trailers (via `[System.IO.File]::WriteAllText` BOM-free + `git commit -F`):

   ```
   GNX375-SPEC-C22-D-COMPLIANCE: verify Fragment D compliance

   Phase 2 compliance for C2.2-D per check-compliance protocol.
   Verdict: {ALL PASS | PASS WITH NOTES | ...}
   Checks: {N} total ({P} PASS, {F} FAIL, {PR} PARTIAL)

   {1-2 sentence summary of notable findings, especially ITM-09 §7.9
   verification result and ITM-08 grep-verify accuracy}

   Task-Id: GNX375-SPEC-C22-D-COMPLIANCE
   Authored-By-Instance: cc
   Refs: D-14, D-15, D-16, D-18, D-19, D-20, D-21, ITM-08, ITM-09, GNX375-SPEC-C22-D
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

4. Send ntfy notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-D-COMPLIANCE completed [flight-sim]"
   ```

5. Do NOT git push.

---

## Estimated duration

~8–12 min CC wall-clock (LLM-calibrated per D-20: compliance is mostly grep + PDF-text search + Fragment A/B/C cross-reference lookup; 4 Python scripts for PDF spot checks S18–S20 + F11 re-grep add a few minutes of script authoring and execution).
