# Compliance Verification Prompt: GNX375-SPEC-C22-A

**Created:** 2026-04-21T17:00:00-04:00
**Source:** CD Purple session — Turn 33 — generated per Compliance Verification Guide after check-completions Phase 1 review of `docs/tasks/c22_a_completion.md`
**Task ID:** GNX375-SPEC-C22-A
**Original prompt:** `docs/tasks/c22_a_prompt.md`
**Completion report:** `docs/tasks/c22_a_completion.md`
**Output under verification:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`
**Compliance report output:** `docs/tasks/c22_a_compliance.md`

---

## Purpose

CD has completed Phase 1 review. The fragment's 8 hard framing commitments all appear honored at the structural level, and the 9 self-review checks CC ran all PASS except for line count (545 vs. ~445 target — +22%, which CC flagged as a deviation but is below the 550 "significant over-delivery" reassessment threshold). This compliance task is the Phase 2 code-level verification.

Because this is the first C2.2 fragment, compliance bar is higher than later fragments will face — this run establishes the verification template for C2.2-B through C2.2-G.

Pass criteria: all items return expected results. Line-count deviation is already flagged; the judgment on whether to accept-as-is or require trimming is a CD decision based on compliance outcomes, not CC's.

---

## Verification Items

### Category 1: File structural integrity

1. **Line count re-confirmation.** CC's self-review reported 545 lines. Independently verify:
   ```bash
   wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
   ```
   Report actual count. Expected: 545 ± 2 (trailing whitespace tolerance).

2. **Character encoding cleanliness (Turn 22 bug precedent).** Check for literal `\u` escape sequences:
   ```bash
   grep -c '\\u[0-9a-f]\{4\}' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
   grep -n '\\u00a7\|\\u2014\|\\u2192\|\\u2248\|\\u00d7' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md | head -10
   ```
   Expected: zero matches for both commands. Note: this fragment contains many em-dashes (—) in glossary definitions and section separators, making encoding correctness especially important.

3. **U+FFFD replacement character scan.** Save to `.py` and run:
   ```python
   # scripts/check_fragment_a_encoding.py
   with open('docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md', 'rb') as f:
       content = f.read()
   replacement_count = content.count(b'\xef\xbf\xbd')
   print(f'U+FFFD count: {replacement_count}')
   if replacement_count > 0:
       lines = content.decode('utf-8', errors='replace').split('\n')
       for i, line in enumerate(lines, 1):
           if '\ufffd' in line:
               print(f'line {i}: {line[:120]}')
   ```
   Expected: 0 replacement characters.

4. **Fragment file conventions per D-18.** Verify:
   ```bash
   head -7 docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
   ```
   Expected YAML front-matter with `Created`, `Source`, `Fragment: A`, `Covers` fields.

   Count heading levels:
   ```bash
   grep -c '^# ' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md    # H1 count
   grep -c '^## ' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md   # H2 count
   grep -c '^### ' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md  # H3 count
   ```
   Expected: exactly 1 H1 (fragment header); 6 H2 (§1, §2, §3, Appendix B, Appendix C, Coupling Summary); ~25–30 H3 (sub-sections).

### Category 2: PDF page reference fidelity (sampled)

5. **Page-reference spot checks.** For each of the following claims, read the corresponding PDF page in `assets/gnc355_pdf_extracted/text_by_page.json` (index N-1) and verify the fragment's claim matches:

   | Claim | Fragment cite | PDF page to verify |
   |-------|--------------|---------------------|
   | SD card requirements: FAT32, 8–32 GB | §2.2 | p. 22 |
   | Inner knob push = Direct-to (GPS 175/GNX 375 pattern) | §2.5, §2.7 | pp. 27–30 |
   | Power-off: hold Power/Home key ≥0.5 s | §3.4 | p. 39 (or p. 38 — confirm) |
   | Database types: Navigation, Obstacles, SafeTaxi, Basemap, Terrain (with expiry flags) | §3.5 | p. 40 |
   | Color conventions include gray and blue | §2.9 | p. 32 |

   Write a Python script (`scripts/verify_fragment_a_page_refs.py`) that loads the JSON, extracts the text for each cited page, and prints whether each claim's key phrases are present. Report CONFIRMED or DISCREPANCY for each of the 5 items with specifics.

6. **Unexpected content additions — verify PDF-sourced or drop.** CC added some detail not explicitly in the outline:
   - §1.1: "GNC 355 has TSO-C169a VHF COM" — verify against PDF (likely pp. 18–20)
   - §2.2: Specific SD card insertion/ejection procedure ("label facing display's left edge", spring latch) — verify against PDF p. 22
   - §2.8: Screenshot capture mechanics ("push and hold inner knob; while depressed, push Home/Power") and "camera icon in annunciator bar" — verify against PDF p. 31
   - §2.9: Gray and Blue color entries beyond outline's 6 colors — verify against PDF p. 32
   - §3.5 "DB SYNC" specific product list (GI 275, GDU TXi v3.10+, GTN v6.72, GTN Xi v20.20+) — verify against PDF pp. 40–52

   For each, report CONFIRMED (found in PDF) or DISCREPANCY (not in PDF — content invention).

### Category 3: Outline fidelity

7. **Outline sub-section coverage.** For each sub-section in the outline that maps to this fragment, verify a corresponding sub-section exists in the fragment:

   Outline sub-sections (expected in fragment):
   - §1: 1.1, 1.2, 1.3, 1.4 (4)
   - §2: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9 (9)
   - §3: 3.1, 3.2, 3.3, 3.4, 3.5 (5)
   - Appendix B: B.1, B.1 additions, B.2, B.3 (4)
   - Appendix C: C.1, C.2, C.3 (3)

   Total: 25 expected sub-sections. Run:
   ```bash
   grep -cE '^### (1\.[1-4]|2\.[1-9]|3\.[1-5]|B\.[1-3]|C\.[1-3])' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
   ```
   Expected: ~25 matches. List any missing.

8. **Outline-to-fragment scope parity on [PART] vs. [FULL] categorizations.** Per harvest map:
   - §1 is [PART] — verify XPDR/ADS-B framing + baseline flip are present (already covered by hard-constraint checks)
   - §2 is [PART] — verify knob push = Direct-to framing is present (covered by check 5)
   - §3 is [FULL] — verify unit-agnostic language (no GNX-only claims in §3 beyond the standard framing). Quick check:
     ```bash
     grep -ni 'GNX 375 only\|375 only\|only on GNX' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
     ```
     Matches in §3 would be suspicious (§3 behavior should be identical across all three units).

### Category 4: Hard-constraint re-verification

9. **TSO-C112e exclusive presence.** Grep for all TSO-C112 occurrences:
   ```bash
   grep -n 'TSO-C112' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
   ```
   Expected: all matches are `TSO-C112e`; at least one match explicitly contrasts with `TSO-C112d` (e.g., "(not TSO-C112d)").

10. **COM absence on GNX 375.** Grep for COM-as-feature statements:
    ```bash
    grep -ni 'COM radio\|COM standby\|COM volume\|COM active frequency\|VHF COM' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
    ```
    For each match, read surrounding context. Expected: every match is in one of (a) GNC 355/355A comparison context, (b) explicit "the GNX 375 has no COM" negative statement, (c) color-convention note that the Pilot's Guide's COM color coding applies to GNC 355/355A only. Flag any match that specifies COM as a present GNX 375 feature.

11. **No internal VDI language.** Grep for VDI:
    ```bash
    grep -ni 'VDI' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
    ```
    Expected: all matches are negative ("no internal VDI", "no on-screen VDI") OR cross-refs to external VDI output (pointing to §15.6) OR the Appendix B glossary entry that defines VDI as "external instrument driven by GNX 375 output".

12. **Disambiguation gap not active.** Grep:
    ```bash
    grep -ni 'disambiguation' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
    ```
    Expected: 2–3 matches, all in "resolved per D-12" or "not an active flag" context.

### Category 5: Glossary completeness

13. **Appendix B XPDR/ADS-B term count.** Count table rows in B.1 additions section. Expected: exactly 15 terms. Required set: Mode S, Mode C, 1090 ES, UAT, Extended Squitter, TSAA, FIS-B, TIS-B, Flight ID, Squawk code, IDENT, WOW, Target State and Status, TSO-C112e, TSO-C166b.

    ```bash
    grep -n '^| \*\*Mode S\*\*\|^| \*\*Mode C\*\*\|^| \*\*1090 ES\*\*\|^| \*\*UAT\*\*\|^| \*\*Extended Squitter\*\*\|^| \*\*TSAA\*\*\|^| \*\*FIS-B\*\*\|^| \*\*TIS-B\*\*\|^| \*\*Flight ID\*\*\|^| \*\*Squawk code\*\*\|^| \*\*IDENT\*\*\|^| \*\*WOW\*\*\|^| \*\*Target State and Status\*\*\|^| \*\*TSO-C112e\*\*\|^| \*\*TSO-C166b\*\*' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
    ```
    Expected: 15 matches. List any missing terms.

14. **Appendix B.1 aviation abbreviation count.** Prompt required "at least 20" aviation abbreviations. Completion report claims 35. Count table rows in B.1 section (before B.1 additions). Expected: ≥20.

### Category 6: Cross-reference validity

15. **Forward cross-references point at valid outline sections.** The Coupling Summary forward-refs claim:
    - §6 Direct-to Operation in Fragment D (C2.2-D) — verify outline has §6 and C2.2-D plan covers §§5–7
    - §7 Procedures in Fragment D (C2.2-D) — verify
    - §10.9 Crossfill in Fragment E (C2.2-E) — verify outline §10 has a §10.9 Crossfill sub-section
    - §15.6 external CDI/VDI output in Fragment G (C2.2-G) — verify outline §15 has §15.6
    - Appendix A in Fragment G — verify D-18 plan places Appendix A in C2.2-G

    Read outline relevant sub-sections and D-18 task partition table. Report each target as VALID or INVALID with specifics.

16. **AMAPI cross-reference validity.** The fragment cites:
    - §2.3: `amapi_by_use_case.md` §3, Pattern 4
    - §2.5: `amapi_by_use_case.md` §4, Patterns 11, 15, 20, 21; Pattern 15 specifically
    - §3.5: `amapi_by_use_case.md` §11; `amapi_patterns.md` Pattern 6

    Verify each exists:
    ```bash
    grep -n '^## 3\|^## 4\|^## 11' docs/knowledge/amapi_by_use_case.md
    grep -n '^### Pattern 4\|^### Pattern 6\|^### Pattern 11\|^### Pattern 15\|^### Pattern 20\|^### Pattern 21' docs/knowledge/amapi_patterns.md
    ```
    Report each reference as VALID or INVALID.

### Category 7: Completion report claim re-verification

17. **Re-verify completion-report self-check claims.** Pick 3 of CC's 9 self-checks at random and independently re-run them:
    - Self-check #2 (character encoding) — covered by item 2 above
    - Self-check #7 (glossary term count = 15) — covered by item 13 above
    - Self-check #9 (file conventions: YAML, H1, ## sections, ### sub-sections) — partially covered by item 4 above

    Extend with: are the completion report's metric claims accurate?
    - "28 sub-sections" — count `###` matches globally and compare
    - "35 aviation abbreviations" — count B.1 rows (pre-additions) and compare
    - "8 AMAPI terms" in B.2 — count rows
    - "6 Garmin terms" in B.3 — count rows

    Report each as CONFIRMED or DISCREPANCY with actual counts.

---

## Execution Protocol

1. **Run all verification items in order.** For each item, capture command output and report PASS / FAIL / PARTIAL / N-A with specifics.

2. **Any DISCREPANCY recorded verbatim.** Do not modify the fragment — compliance is read-only.

3. **Write compliance report `docs/tasks/c22_a_compliance.md`** with:
   - Provenance header (Created, Source)
   - Per-item results (17 items across 7 categories; PASS/FAIL/PARTIAL/N-A + specifics)
   - Overall verdict: PASS / PASS WITH NOTES / PARTIAL / FAIL
   - Summary of discrepancies for CD triage
   - **Explicit recommendation on the line-count overage** — CC already flagged this as a deviation; compliance should note whether the overage content is PDF-sourced (accept), outline-expansion (accept), or invented (trim). Not a pass/fail judgment — CD decides.

4. **Commit using D-04 trailer format.** Write commit message via `[System.IO.File]::WriteAllText()` (BOM-free), use `git commit -F <file>`:

   ```
   GNX375-SPEC-C22-A: compliance verification

   Phase 2 code-level verification of GNX 375 spec Fragment A against
   the task prompt directives and completion report claims. 17 items
   across 7 categories: file integrity, PDF page fidelity, outline
   fidelity, hard-constraint re-verification, glossary completeness,
   cross-reference validity, completion report claim re-verification.

   Overall verdict: <PASS / PASS WITH NOTES / PARTIAL / FAIL>

   Notes: line count 545 vs. target 445 previously flagged by CC;
   compliance-side assessment: <accept / trim recommended>.

   Task-Id: GNX375-SPEC-C22-A
   Authored-By-Instance: cc
   Refs: D-07, D-08, D-18, GNX375-SPEC-C22-A
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

   ```powershell
   $msg = @'
   ...message above with actual verdict substituted...
   '@
   [System.IO.File]::WriteAllText((Join-Path $PWD ".git\COMMIT_EDITMSG_cc"), $msg)
   git commit -F .git\COMMIT_EDITMSG_cc
   Remove-Item .git\COMMIT_EDITMSG_cc
   ```

5. **Flag refresh check:** No refresh flags needed (no modification to `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`).

6. **Send completion notification:**
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-A compliance completed [flight-sim]"
   ```

7. **Do NOT git push.** Steve pushes manually.

---

## What CD will do with this report

- **PASS / PASS WITH NOTES:** archive all four files to `docs/tasks/completed/`; begin manifest authoring at `docs/specs/GNX375_Functional_Spec_V1.md` per D-18; draft C2.2-B task prompt.
- **PARTIAL:** triage per D-07 — minor discrepancies logged as ITM-n; escalate any blocking items to bug-fix task. Line-count deviation is a judgment call by CD, not a compliance FAIL unless content invention is identified.
- **FAIL:** create bug-fix CC task. Line-count by itself does not trigger FAIL — content correctness does.
