# Compliance Verification Prompt: GNX375-SPEC-OUTLINE-01

**Created:** 2026-04-21T12:30:00-04:00
**Source:** CD Purple session — Turn 27 — generated per Compliance Verification Guide after check-completions Phase 1 review of `docs/tasks/c2_1_375_outline_completion.md`
**Task ID:** GNX375-SPEC-OUTLINE-01
**Original prompt:** `docs/tasks/c2_1_375_outline_prompt.md`
**Completion report:** `docs/tasks/c2_1_375_outline_completion.md`
**Output under verification:** `docs/specs/GNX375_Functional_Spec_V1_outline.md`
**Compliance report output:** `docs/tasks/c2_1_375_outline_compliance.md`

---

## Purpose

CD has completed Phase 1 review of the completion report. The task prompt directives and the completion report claims look well-aligned at the structural level. This compliance task is the Phase 2 code-level verification: confirm that the completion report's claims hold up against the actual outline file, that the Turn 22 character-encoding bug did not recur, and that harvest-map fidelity extends to sections the completion report did not self-spot-check.

Pass criteria: all verification items return the expected result. Fail criteria: any item returns unexpected results; CC should record each discrepancy and CD will triage per D-07.

---

## Verification Items

### Category 1: File structural integrity

1. **Line count verification.** Completion report claims 1,477 lines. Run:
   ```bash
   wc -l docs/specs/GNX375_Functional_Spec_V1_outline.md
   ```
   Report the actual count. Expected: within ±10 lines of 1,477 (minor whitespace-at-EOF variations acceptable).

2. **Character encoding cleanliness — the Turn 22 bug precedent.** The prior task prompt file had literal `\u2014` escape sequences instead of rendered em-dashes. Check the outline for the same pattern:
   ```bash
   grep -c '\\u[0-9a-f]\{4\}' docs/specs/GNX375_Functional_Spec_V1_outline.md
   grep -n '\\u00a7\|\\u2014\|\\u2192\|\\u2248' docs/specs/GNX375_Functional_Spec_V1_outline.md | head -10
   ```
   Expected: zero matches for both commands. If any literal `\u` escape sequences present, list them with line numbers.

3. **Corrupted character artifact in §4.9.** During CD Phase 1 review, a read of the file showed `§��10` (apparent mojibake) in the §4.9 AMAPI cross-refs block. Verify:
   ```bash
   grep -n 'AMAPI cross-refs' docs/specs/GNX375_Functional_Spec_V1_outline.md
   python3 -c "
   with open('docs/specs/GNX375_Functional_Spec_V1_outline.md', 'rb') as f:
       content = f.read()
   # Look for replacement character (U+FFFD) or question-mark-in-diamond (0xEF 0xBF 0xBD in UTF-8)
   replacement_count = content.count(b'\xef\xbf\xbd')
   print(f'U+FFFD replacement char count: {replacement_count}')
   if replacement_count > 0:
       # Find line numbers
       lines = content.decode('utf-8', errors='replace').split('\n')
       for i, line in enumerate(lines, 1):
           if '\ufffd' in line:
               print(f'line {i}: {line[:120]}')
   "
   ```
   Expected: 0 replacement characters. If present, report line numbers and attempted repair (re-type the section sign and re-save).

4. **Provenance header present.** Verify Created + Source fields:
   ```bash
   head -5 docs/specs/GNX375_Functional_Spec_V1_outline.md
   ```
   Expected: YAML front matter with `Created:` and `Source:` fields per §File Provenance convention.

### Category 2: Completion report spot-check re-verification

5. **Re-run the 5 page-reference spot checks from the completion report.** The report claims all 5 MATCH. Independently verify each by reading the cited PDF page and confirming the claim:

   Write a Python script that loads `assets/gnc355_pdf_extracted/text_by_page.json` and extracts the relevant text for each claim, then manually confirm the match. Specifically:
   - p. 40 should mention FAT32 and database types (Basemap, Navigation, Obstacles, SafeTaxi, Terrain)
   - p. 114 should list GPS 175/GNX 375 default user fields: distance, ground speed, DTK+TRK, and a fourth field
   - p. 200 should contain "Time to Turn advisory" with 10-second countdown
   - p. 78 should have XPDR mode table (Standby / On / Altitude Reporting) with the air/ground auto-handling note
   - p. 290 should have "Traffic Advisories, GNX 375" header with 5 listed conditions

   For each, report: CONFIRMED or DISCREPANCY (with details).

### Category 3: Harvest-map fidelity extension

6. **[FULL] section fidelity check — not done in completion report.** The completion report verified 3 [PART] sections and 1 [355] omission but did not sample any [FULL] sections. Pick 2 [FULL] sections at random (e.g., §5 Flight Plan Editing and §8 Nearest Functions) and verify they preserve the structure from the GNC 355 outline per the harvest map [FULL] category. Specifically:
   - Section title matches (modulo framing flips)
   - Sub-section count matches or differs only for documented reasons
   - Page references identical to the 355 outline
   - Any content deletions are COM-related (expected for [FULL] since COM is 355-only)

   For each sampled [FULL] section, report: FAITHFUL or DRIFT (with details).

7. **[355] omission check — extend beyond §4.11.** The completion report verified §4.11 is absent. Also verify:
   - No `§11.x COM ...` sub-sections present anywhere (old §11 COM Radio is fully replaced)
   - No references to `COM Standby Control Panel` as a present feature (only as a historical reference to the 355)
   - §12.9 contains XPDR Annunciations (not COM Annunciations)
   - §13.9 contains XPDR Advisories (not COM Radio Advisories)
   - §14.1 contains XPDR State (not COM State)
   - §15 has no COM frequency datarefs (no `COM ACTIVE FREQUENCY`, no `COM1_RADIO_SWAP`)

   ```bash
   grep -ni 'COM Standby\|COM Radio Operation\|COM active frequency\|COM1_RADIO_SWAP\|XFER key' docs/specs/GNX375_Functional_Spec_V1_outline.md
   ```
   Expected: any matches are historical context only (e.g., within "GNC 355 has X" comparison language), never as a present GNX 375 feature.

### Category 4: Open-question flag verification

8. **6 open questions properly flagged, not resolved.** The completion report's §"Open-Question Flag Check Results" claims each of the 6 is flagged. Independently verify by searching for the key phrases AND confirming the surrounding context is a flag, not a resolution:

   ```bash
   grep -n 'OPEN QUESTION' docs/specs/GNX375_Functional_Spec_V1_outline.md
   grep -n 'altitude constraint\|ARINC 424\|fly-over\|fly-by\|XPL dataref\|MSFS SimConnect\|TSAA aural' docs/specs/GNX375_Functional_Spec_V1_outline.md
   ```

   For each match, read the surrounding paragraph and confirm it uses non-speculative language: "not documented", "behavior unknown", "research needed", "require verification", "design-phase research". Flag any instance that speculates (e.g., "the 375 likely handles altitude constraints by...") — that would be a prompt violation.

### Category 5: Cross-reference validity

9. **Internal cross-reference validity.** The outline contains many "see §N.x" / "cross-ref" references. Enumerate them and verify targets exist:
   ```bash
   grep -no 'see §[0-9]\+\.\?[0-9]*\|cross-ref §[0-9]\+\.\?[0-9]*\|§11\|§4\.9\|§13\|§14\|§15\|§7\.[A-M0-9]' docs/specs/GNX375_Functional_Spec_V1_outline.md | head -30
   ```
   Sample 5 of the cross-references and verify each target section header exists in the outline. Report: all VALID or list any dangling references.

10. **Decision-doc cross-reference validity.** The outline cites decisions D-01, D-11, D-12, D-13, D-14, D-15, D-16. Verify each decision file exists:
    ```bash
    ls docs/decisions/D-01*.md docs/decisions/D-11*.md docs/decisions/D-12*.md docs/decisions/D-13*.md docs/decisions/D-14*.md docs/decisions/D-15*.md docs/decisions/D-16*.md 2>&1
    ```
    Expected: all 7 files exist.

### Category 6: Numeric consistency

11. **Section length estimates vs. top-level summary.** The outline header says "Largest sections: §4 Display pages (~800), §7 Procedures (~350), §11 XPDR + ADS-B (~200)". The individual section headers show §4 at ~740 lines and §7 at ~350 lines. Minor discrepancy on §4 (740 vs. 800). Verify:
    ```bash
    grep -n '^\*\*Estimated length' docs/specs/GNX375_Functional_Spec_V1_outline.md
    ```
    Sum the top-level section estimates (§§1–15 + appendices) and compare against the header's "~2,860 lines" total. Report: consistent (within ±100 lines) or flag the discrepancy with specifics.

12. **§4 sub-section length sum.** Sum §4.1 through §4.10 estimated lengths; verify they total ~740 (matching §4's top-level estimate). Report the sum.

### Category 7: Prompt directive negative checks

13. **No on-screen VDI specified.** Search for any language that specifies a VDI as a 375 internal display element:
    ```bash
    grep -ni 'VDI' docs/specs/GNX375_Functional_Spec_V1_outline.md
    ```
    For each match, confirm it is one of: (a) explicit statement that no on-screen VDI exists, (b) cross-reference to D-15, (c) output-contract language for external VDI, or (d) open-question language. Flag any instance that treats VDI as an on-375 display element.

14. **No Ground / Test / Anonymous modes.** Search for any language treating these as present XPDR modes on the 375:
    ```bash
    grep -ni 'Ground mode\|Test mode\|Anonymous mode\|GND mode\|TEST mode' docs/specs/GNX375_Functional_Spec_V1_outline.md
    ```
    All matches must be negative statements (e.g., "do not exist on GNX 375", "not applicable"). Flag any that specify these as features.

### Category 8: Appendix fidelity

15. **Appendix A baseline flip.** Verify:
    - Title references "GNX 375 as Baseline" (or equivalent)
    - A.2 compares GPS 175 vs. GNX 375 (not vs. GNC 355)
    - A.3 compares GNC 355 vs. GNX 375 (not vs. GPS 175)
    - No GNC 375/GNX 375 disambiguation flag present (resolved per D-12)

16. **Appendix B glossary additions.** Verify 375-specific terms added beyond the 355 glossary:
    - Mode S, 1090 ES, UAT, Extended Squitter, TSAA, FIS-B, TIS-B, Flight ID, squawk code, IDENT, TSO-C112e
    ```bash
    grep -n 'Mode S:\|1090 ES:\|UAT:\|Extended Squitter:\|TSAA:\|FIS-B:\|TIS-B:\|Flight ID:\|TSO-C112e' docs/specs/GNX375_Functional_Spec_V1_outline.md
    ```

17. **Appendix C disambiguation gap dropped.** The 355 outline's Appendix C had a "GNC 375 / GNX 375 disambiguation" flag. Per D-12 this is resolved. Verify it is NOT present in the 375 outline:
    ```bash
    grep -ni 'GNC 375/GNX 375 disambiguation\|GNC 375 disambiguation' docs/specs/GNX375_Functional_Spec_V1_outline.md
    ```
    Expected: only matches in negative context ("resolved per D-12; dropped").

---

## Execution Protocol

1. **Run all verification items in order.** For each item, capture the command output and report PASS / FAIL / PARTIAL / N-A with specifics.

2. **Any DISCREPANCY is recorded verbatim.** Do not attempt to fix the outline — this compliance pass is read-only with respect to the outline. Fixes happen in a subsequent bug-fix task if CD assigns one.

3. **Write compliance report `docs/tasks/c2_1_375_outline_compliance.md`** with:
   - Provenance header (Created, Source)
   - Per-item results (17 items; PASS/FAIL/PARTIAL/N-A + specifics)
   - Overall verdict: PASS / PASS WITH NOTES / PARTIAL / FAIL
   - Summary of any discrepancies for CD triage

4. **Commit using D-04 trailer format.** Write the commit message to a temp file via `[System.IO.File]::WriteAllText()` (BOM-free) and use `git commit -F <file>`:

   ```
   GNX375-SPEC-OUTLINE-01: compliance verification

   Phase 2 code-level verification of the GNX 375 outline against the
   task prompt directives and completion report claims. 17 verification
   items across 8 categories: file integrity, spot-check re-verification,
   harvest-map fidelity, open-question flags, cross-reference validity,
   numeric consistency, prompt directive negative checks, appendix
   fidelity.

   Overall verdict: <PASS / PASS WITH NOTES / PARTIAL / FAIL>

   Task-Id: GNX375-SPEC-OUTLINE-01
   Authored-By-Instance: cc
   Refs: D-07, D-08, GNX375-SPEC-OUTLINE-01
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

   ```powershell
   $msg = @'
   ...message above...
   '@
   [System.IO.File]::WriteAllText((Join-Path $PWD ".git\COMMIT_EDITMSG_cc"), $msg)
   git commit -F .git\COMMIT_EDITMSG_cc
   Remove-Item .git\COMMIT_EDITMSG_cc
   ```

5. **Flag refresh check:** This task does not modify `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`. Do NOT create refresh flags.

6. **Send completion notification:**
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-OUTLINE-01 compliance completed [flight-sim]"
   ```

7. **Do NOT git push.** Steve pushes manually.

---

## What CD will do with this report

- **PASS / PASS WITH NOTES:** archive `{prompt, completion, compliance_prompt, compliance}` to `docs/tasks/completed/` and update `Task_flow_plan_with_current_status.md` marking C2.1-375 ✅ Done. Proceed to D-17-NEXT (format decision for C2.2).
- **PARTIAL:** triage per D-07 — discharge minor items as ITM-n; escalate any blocking items to bug-fix task.
- **FAIL:** create bug-fix CC task for the failing items; do not archive until fix is verified.
