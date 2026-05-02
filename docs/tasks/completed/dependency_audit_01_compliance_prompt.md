# CC Task Prompt: DEPENDENCY-AUDIT-01 Compliance Verification

**Task ID:** DEPENDENCY-AUDIT-01-COMPLIANCE
**Verifying:** DEPENDENCY-AUDIT-01 (completed 2026-05-02)
**Prompt:** `docs/tasks/dependency_audit_01_prompt.md`
**Completion:** `docs/tasks/dependency_audit_01_completion.md`
**Report under verification:** `docs/tasks/dependency_audit_01_report.md`
**Source of truth:** `assets/retired/README.md` and the prompt above

---

## Instructions

This is a **read-only verification task**. Do NOT modify any source files. The only file you write is the compliance report at `docs/tasks/dependency_audit_01_compliance.md`.

Read `CLAUDE.md` for project conventions (D-29 commit format). Per CLAUDE.md, never use inline `python -c` — save multi-step Python checks to `.py` files in a temp scratch directory.

For each checklist item below, report:

- **PASS** — with evidence (file path, line numbers, command output excerpts)
- **FAIL** — with what was expected vs. what was found
- **PARTIAL** — with explanation of what's present and what's missing

Quote specific lines that prove compliance. When a check is "compare report claim to ground truth," the report's number must match ground truth exactly — "approximate" matches do not satisfy a PASS for count checks.

---

## Checklist

### M. Math verification (the audit's primary deliverable is counts)

**M1. Total unique file:line matches.** Re-run all 10 grep patterns from the prompt's Inventory Targets table and compute the deduplicated total.

Save the following to `/tmp/audit_recount.py` (or equivalent scratch path) and run it:

```python
import subprocess
from collections import defaultdict

patterns = [
    "assets/retired/gnc355_pdf_extracted",
    "assets/retired/gnc355_reference",
    "assets/gnc355_pdf_extracted",
    "assets/gnc355_reference",
    "gnc355_pdf_extracted",
    "gnc355_reference",
    "llamaparse_agentic_v1",
    "text_by_page.json",
    "land-data-symbols.png",
    "gnc355_pdf_extract",
]

unique_matches = set()  # (path, line_num) tuples
per_pattern = {}

for pattern in patterns:
    result = subprocess.run(
        ["git", "grep", "-n", "-F", pattern],
        capture_output=True, text=True, cwd="."
    )
    lines = [l for l in result.stdout.split("\n") if l.strip()]
    matches = []
    for line in lines:
        # format: path:lineno:content
        parts = line.split(":", 2)
        if len(parts) >= 2:
            try:
                path = parts[0]
                lineno = int(parts[1])
                matches.append((path, lineno))
                unique_matches.add((path, lineno))
            except ValueError:
                pass
    per_pattern[pattern] = len(matches)

distinct_files = set(m[0] for m in unique_matches)
print(f"Total unique file:line matches: {len(unique_matches)}")
print(f"Distinct files: {len(distinct_files)}")
print(f"Per-pattern match counts:")
for p, c in per_pattern.items():
    print(f"  {p!r}: {c}")
```

Compare:
- Computed `len(unique_matches)` against the report's "Total references found" claim of ~304.
- Computed `len(distinct_files)` against the report's "~95 distinct files" claim.

PASS if both numbers match within ±2 of the report's claim (the report's "~" caveat allows minor counting variation but not large drift). FAIL if either drifts more than ±5%. Quote the exact computed numbers as evidence.

**M2. Sum check on executive-summary classification.** Verify `28 + 109 + 167 == 304` exactly. Then compare each summand to the underlying classification:

- "Patch-recommended: 28 lines in 17 files" — count entries in the report's Patch List section
- "Flag-for-decision: 109 lines in 29 files" — count entries in the report's Flag List section
- "Leave-as-is: 167 lines in 49 files" — leave-as-is is a paragraph summary, not a table; compare to category-D-line-count claim in Phase B summary

PASS if the executive-summary numbers match the section totals. FAIL if they differ.

### N. Negative / Source integrity (audit performed no destructive ops)

**N1. No source files modified by the audit.** Run:

```bash
git status --porcelain
git diff --stat HEAD
```

Expected: the only files showing as modified or new since the prompt commit (which is already in HEAD per Turn 15) are `docs/tasks/dependency_audit_01_report.md` and `docs/tasks/dependency_audit_01_completion.md`. Note: `docs/tasks/CC_Task_Prompts_Status.md` may show as modified due to pre-existing CD work (Side Finding #2 in the report); that's allowable here because it predates the audit. Quote the full file list.

PASS if only the two new audit files are added and no other files (besides the optional pre-existing CC_Task_Prompts_Status.md modification) appear in the diff. FAIL if any other file shows as modified.

**N2. Salvage-assessment file claims are real.** Verify by `ls`:

- `assets/retired/gnc355_reference/land-data-symbols.png` exists with size 65,861 bytes
- `assets/retired/gnc355_pdf_extracted/land-data-symbols.png` exists with size 65,861 bytes
- `assets/gnx375_llama_extract/images_screenshot/page_125.jpg` exists
- `assets/gnx375_llama_extract/images_screenshot/page_125_chart_1_v2.jpg` exists
- `assets/gnx375_llama_extract/images_layout/` does NOT contain any `page_125*` file

Quote `ls -la` output for each. PASS if all five claims hold; FAIL otherwise.

### O. Sort ordering (deterministic ordering claim)

**O1. Spot-check 3 tables for ascending path-then-line order.** Pick three tables in the report:

1. `### Subpath: text_by_page.json` (the first detail table)
2. `#### Subpath: text_by_page.json (scripts — functional dependencies)` (the script-heavy table)
3. The "Patch list" in Recommended Actions Summary

For each, verify entries are sorted ascending by `(path, line_number)`. PASS if all three are sorted; PARTIAL if 2/3; FAIL if fewer.

### S. Sample classification verification

**S1. Five random A/B classifications.** Pick 5 entries from the report's Category-A or Category-B tables. For each, verify:

- The cited file exists at the cited path
- The cited line number contains the claimed retired-path reference (or contains it within ±2 lines if line numbering shifted slightly)
- The category assignment matches the rubric (active spec/doc → A; active task → B)

Pick the 5 across at least 3 different retired paths to spread coverage. Quote the actual file content at each cited line.

PASS if 5/5 classifications check out. FAIL if any are misplaced.

**S2. Three random D classifications.** Pick 3 entries from the report's Leave-as-is summary (the Category-D paragraph mentions specific files like decisions, completed task records, project-status checkpoints).

For each, verify the file is actually in one of:
- `docs/tasks/completed/`
- `docs/decisions/`
- `docs/todos/issue_index_resolved.md`
- `project-status/`

PASS if 3/3 are in immutable territory. FAIL if any are misclassified active files that should have been A/B/E.

### E. High-stakes E-category items (functional regression risk)

**E1. Verify each script in the E-category patch + flag lists actually contains the cited reference.** From the report, the E-category lines are:

Patch list (active scripts):
- `assets/gnx375_llama_extract/page_number_map.json:4`
- `scripts/build_page_number_map.py:327`
- `scripts/build_page_number_map.py:332`
- `scripts/build_page_number_map.py:360`
- `.gitignore:47`

Flag list (compliance scripts to archive):
- All 14 `scripts/c22_*` and `scripts/compliance/c22_f/*` scripts and `scripts/verify_fragment_a_page_refs.py`
- `scripts/gnc355_pdf_extract.py:373, 384`
- `scripts/pdf_reextraction/reextract_*.py:` (cited line numbers)

For each cited line, run `sed -n '<line>p' <file>` and verify the cited path appears in the line. Sample 5 from the patch list (cover all unique files) and 5 from the flag list. Quote the actual line content as evidence.

PASS if all 10 sampled lines contain the claimed retired-path reference. PARTIAL if line numbers are off by ±2 but the reference is found nearby. FAIL if any cited line does not contain the reference.

**E2. Side Finding #4 specificity check.** The report's Side Finding #4 claims `scripts/build_page_number_map.py` has stale defaults pointing to the defective 330-page extraction. Verify by running:

```bash
grep -n "default=" scripts/build_page_number_map.py | head -10
```

Confirm the defaults at lines 327 and 332 do indeed reference `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/...`. Quote the lines.

PASS if the side finding's claim is verified by the actual script. FAIL otherwise.

### G. Git / Commit compliance

**G1. Commit message uses D-29 simple format.** Run `git log -1 --grep="DEPENDENCY-AUDIT-01:" --format="%H%n%n%B" HEAD`.

Verify all of:

- Subject begins with `DEPENDENCY-AUDIT-01:`
- Subject ends with ` [AI commit]`
- Subject does NOT contain a colon-prefixed `Task-Id:` trailer (D-29 dropped these)
- Body paragraph(s) describe the work
- A `Refs:` line appears as a final paragraph
- No `Authored-By-Instance:`, `Co-Authored-By:`, or other D-04-style trailers

PASS if all hold. FAIL if any are violated.

**G2. No BOM in commit subject.** Run:

```bash
git log -1 --grep="DEPENDENCY-AUDIT-01:" --format="%s" | head -c 50 | od -c | head -2
```

Verify the first byte is the ASCII letter `D` (0x44, "D" of "DEPENDENCY"), not the BOM sequence (0xEF 0xBB 0xBF). PASS if clean. FAIL if BOM present.

---

## Output

Write the compliance report to `docs/tasks/dependency_audit_01_compliance.md` with this structure:

```markdown
---
Created: <iso8601>
Source: docs/tasks/dependency_audit_01_compliance_prompt.md
---

# DEPENDENCY-AUDIT-01 Compliance Report

**Verified:** <timestamp>
**Verdict:** <ALL PASS | PASS WITH NOTES | FAILURES FOUND>

## Summary
- Total checks: 10 (M1, M2, N1, N2, O1, S1, S2, E1, E2, G1, G2 — 11 if M1 is split; treat as 11)
- Passed: <N>
- Failed: <N>
- Partial: <N>

## Results

### M. Math verification
M1. <PASS|FAIL|PARTIAL> — <evidence: computed total vs claim>
M2. <PASS|FAIL|PARTIAL> — <evidence: 28+109+167 = 304 sum check + section-vs-summary cross-checks>

### N. Negative / Source integrity
N1. <PASS|FAIL|PARTIAL> — <evidence: git status output>
N2. <PASS|FAIL|PARTIAL> — <evidence: ls output for all 5 paths>

### O. Sort ordering
O1. <PASS|FAIL|PARTIAL> — <evidence: 3 tables verified ascending>

### S. Sample classification verification
S1. <PASS|FAIL|PARTIAL> — <evidence: 5 spot checks with actual file content>
S2. <PASS|FAIL|PARTIAL> — <evidence: 3 D-category items verified immutable>

### E. High-stakes E-category items
E1. <PASS|FAIL|PARTIAL> — <evidence: 10 line-content checks>
E2. <PASS|FAIL|PARTIAL> — <evidence: build_page_number_map.py defaults grep>

### G. Git / Commit compliance
G1. <PASS|FAIL|PARTIAL> — <evidence: commit message structure>
G2. <PASS|FAIL|PARTIAL> — <evidence: BOM check via od>

## Notes

<Any observations, minor deviations, or recommendations that don't rise to FAIL level but are worth documenting. Particularly: any classification edge cases or counts that needed adjustment.>
```

---

## Completion Protocol

1. Write compliance report to `docs/tasks/dependency_audit_01_compliance.md`.

2. Stage and commit (D-29 simple format):

   ```
   git add docs/tasks/dependency_audit_01_compliance_prompt.md docs/tasks/dependency_audit_01_compliance.md
   ```

   Commit message:
   ```
   git commit -m "DEPENDENCY-AUDIT-01-COMPLIANCE: verification report [AI commit]" -m "Verifies DEPENDENCY-AUDIT-01 against prompt requirements. <N>/11 checks passed. Math verification, source-integrity, sort ordering, sample classification, E-category line-content, and commit-format compliance covered." -m "Refs: DEPENDENCY-AUDIT-01"
   ```

3. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "DEPENDENCY-AUDIT-01-COMPLIANCE completed [flight-sim]"
   ```

4. **Do NOT git push.** Steve pushes after CD reviews compliance.
