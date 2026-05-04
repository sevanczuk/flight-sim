# CC Task Prompt: REVIEW-PRIORITY-GUIDE-01 Compliance Verification

**Task ID:** REVIEW-PRIORITY-GUIDE-01-COMPLIANCE
**Verifying:** REVIEW-PRIORITY-GUIDE-01 (completed 2026-05-04)
**Prompt:** `docs/tasks/review_priority_guide_01_prompt.md`
**Completion:** `docs/tasks/review_priority_guide_01_completion.md`
**Spec:** `docs/decisions/D-22-c3-spec-review-customization-for-gnx375-functional-spec.md` §5
**Audit commit pin:** the most recent commit on the current branch as of compliance launch (record its hash in the report; verifications run against that commit's tree state)

---

## Instructions

This is a **read-only verification task**. Do NOT modify any source files, do NOT regenerate the aggregate, do NOT commit any working-tree changes other than the compliance report itself.

Verify that the REVIEW-PRIORITY-GUIDE-01 implementation matches the original prompt and D-22 §5 by gathering concrete evidence from the source code, the regenerated aggregate, and the assembly script.

Read `CLAUDE.md` for project conventions.

For each checklist item, report:
- **PASS** — with evidence (file, line number, relevant snippet)
- **FAIL** — with what was expected vs. what was found
- **PARTIAL** — with explanation of what's present and what's missing

Use `grep -n`, `sed -n`, `wc -l`, and `md5sum` liberally. Quote specific lines that prove compliance.

---

## Checklist

### A. Source file integrity (Phase A deliverable)

**A1.** Source file exists at the expected path:
```
ls docs/specs/fragments/_review_priority_guide.md
wc -l docs/specs/fragments/_review_priority_guide.md
```
Expected: file present; line count is 33 (per completion report claim) or within 32–34 range. PASS if line count matches; FAIL otherwise.

**A2.** First line of source file is exactly `## Review Priority Guide` (no leading whitespace, no provenance comment, no front matter):
```
sed -n '1p' docs/specs/fragments/_review_priority_guide.md
```

**A3.** All four P1 sections explicitly named and matching D-22 §5:
```
grep -n "§11" docs/specs/fragments/_review_priority_guide.md
grep -n "§15" docs/specs/fragments/_review_priority_guide.md
grep -n "§4.9" docs/specs/fragments/_review_priority_guide.md
grep -n "§7" docs/specs/fragments/_review_priority_guide.md
```
Each must match a `- **§N — Title.**` bullet in the P1 section. Quote each matching line.

**A4.** All five P2 buckets present:
```
grep -nE "§§5–6|§§8–10|§14|§12|§13" docs/specs/fragments/_review_priority_guide.md
```
Expected: 5 hits in the P2 section.

**A5.** P3 buckets present:
```
grep -nE "§§1–4|Appendices A, B, C" docs/specs/fragments/_review_priority_guide.md
```
Expected: 2 hits (one for §§1–4, one for Appendices) in the P3 section.

**A6.** Triage reminder paragraph present and references D-22 §3:
```
grep -n "Triage reminder" docs/specs/fragments/_review_priority_guide.md
grep -n "D-22 §3" docs/specs/fragments/_review_priority_guide.md
```

### B. Assembly script edits (Phase B deliverable)

**B1.** Argparse flag definition present with the exact metavar, default, and help text claimed in the completion report:
```
grep -n -A 9 "review-priority-guide" scripts/assemble_gnx375_spec.py | head -40
```
Verify:
- `metavar="PATH"` is set
- `default=None` is the default
- The help text mentions "prepend", "H1 metadata block", and "absent, no priority guide is prepended"

**B2.** Prepend logic block present in `main()` between the provenance assembly and the fragment-body loop:
```
grep -n -B 1 -A 4 "args.review_priority_guide" scripts/assemble_gnx375_spec.py
```
Verify the block matches:
```python
if args.review_priority_guide:
    guide_text = Path(args.review_priority_guide).read_text(encoding="utf-8").rstrip()
    assembled.extend(guide_text.splitlines())
    assembled.append("")
```
Must be located AFTER the line `assembled: list[str] = list(provenance)` and BEFORE the `for i, body in enumerate(all_bodies):` loop. Quote the surrounding context.

**B3.** Module docstring lists the new flag in the usage example:
```
sed -n '1,15p' scripts/assemble_gnx375_spec.py
```
Verify the `--review-priority-guide <path>` line appears in the usage example block.

**B4.** Script's `--help` output includes the new flag:
```
python scripts/assemble_gnx375_spec.py --help
```
Verify `--review-priority-guide PATH` appears in the help text with the help description.

### C. Backward compatibility (Phase B.5)

**C1.** Flag-absent run is byte-identical to the post-flag run when the guide source file is empty or absent:
```
python scripts/assemble_gnx375_spec.py --check
```
Expected: all gating checks PASS; in-memory line count is 4464 (the current aggregate's line count, since the aggregate WAS regenerated with the flag).

**Note:** The pre-flag baseline of 4430 lines no longer reproduces because the aggregate was regenerated with the guide. This is expected. Do NOT regenerate the aggregate without the flag during this compliance check — that would re-do the work in reverse. Just confirm `--check` mode passes its verification suite.

**C2.** Confirm the flag-absent code path does NOT execute the prepend block. Read the conditional:
```
grep -n "if args.review_priority_guide:" scripts/assemble_gnx375_spec.py
```
Verify the guard exists and is the only entry point to the prepend block. PASS if the prepend logic is unreachable when the flag is None.

### D. Aggregate output structure (Phase C verification, independent re-run)

**D1.** Aggregate header structure is correct:
```
sed -n '1,10p' docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
Verify:
- Line 1: `# GNX 375 Functional Spec V1`
- Lines 3–6: HTML comment block (assembly metadata)
- Line 7: blank
- Line 8: `## Review Priority Guide`

**D2.** Exactly one occurrence of the priority-guide H2:
```
grep -c "^## Review Priority Guide" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
Expected: `1`.

**D3.** Exactly one occurrence of the H1 (no double H1 from guide injection):
```
grep -c "^# GNX 375 Functional Spec V1" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
Expected: `1`.

**D4.** All seven canonical fragment top-level sections still present exactly once:
```
for n in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
  count=$(grep -c "^## $n\\." docs/specs/GNX375_Functional_Spec_V1_aggregate.md)
  echo "§$n: $count"
done
grep -c "^## Appendix A" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
grep -c "^## Appendix B" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
grep -c "^## Appendix C" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
Expected: §1 through §15 each return `1`; each Appendix returns `1`. Any zero or duplicate is a FAIL.

**D5.** Line count of aggregate matches completion report claim:
```
wc -l docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
Expected: `4464`.

**D6.** Triage reminder paragraph appears in the aggregate (confirms guide was prepended in full, not truncated):
```
grep -n "Triage reminder (per D-22 §3)" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
Expected: exactly one match in the first ~50 lines.

**D7.** First Fragment A section header appears AFTER the priority guide:
```
grep -n "^## 1\\. Overview" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
grep -n "^## Review Priority Guide" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
The `## 1. Overview` line number must be GREATER than the `## Review Priority Guide` line number. Verify ordering.

### E. Idempotency

**E1.** Running assembly twice with the same flag produces byte-identical output (modulo `Generated:` timestamp):
```
python scripts/assemble_gnx375_spec.py --review-priority-guide docs/specs/fragments/_review_priority_guide.md --output /tmp/agg_run1.md
sleep 2
python scripts/assemble_gnx375_spec.py --review-priority-guide docs/specs/fragments/_review_priority_guide.md --output /tmp/agg_run2.md
diff <(grep -v "Generated:" /tmp/agg_run1.md) <(grep -v "Generated:" /tmp/agg_run2.md) | head -20
```
Expected: zero output from `diff`. Any diff output is a FAIL (idempotency violation).

**Important:** these runs write to `/tmp/`, not to the canonical aggregate path. After this check, restore-verify by ensuring the canonical aggregate is unchanged:
```
ls -l docs/specs/GNX375_Functional_Spec_V1_aggregate.md
git status --porcelain docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
The canonical aggregate should not be in modified state; if it is, that's a FAIL (the compliance run accidentally clobbered it).

### F. Negative checks

**F1.** No second H1 anywhere in the aggregate:
```
grep -c "^# " docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
Expected: `1` (only the one H1 at line 1). Any value >1 is a FAIL — guide content or fragment content introduced an unintended H1.

**F2.** No `## Coupling Summary` blocks in the aggregate (existing assembly invariant; verify the new flag didn't break this):
```
grep -c "^## Coupling Summary" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
Expected: `0`.

**F3.** No fragment H1 lines (e.g., `# GNX 375 Functional Spec V1 — Fragment A`) in aggregate:
```
grep -nE "^# GNX 375 Functional Spec V1 [—–-] Fragment [A-G]" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
Expected: empty output.

### G. Commit verification

**G1.** Most recent commit subject line matches D-29 format and references this task:
```
git log -1 --format="%H %s"
```
Verify the subject contains `REVIEW-PRIORITY-GUIDE-01:` and `[AI commit]`. Quote the commit hash and subject.

**G2.** Commit body trailer references D-22:
```
git log -1 --format="%B"
```
Verify the body includes `Refs: D-22`.

**G3.** Commit includes all five expected files (and only them):
```
git show --stat HEAD | head -30
```
Expected: changes to exactly these paths:
- `docs/tasks/review_priority_guide_01_prompt.md` (added)
- `docs/tasks/review_priority_guide_01_completion.md` (added)
- `docs/specs/fragments/_review_priority_guide.md` (added)
- `scripts/assemble_gnx375_spec.py` (modified)
- `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` (modified)

Any extra files or missing files is a FAIL/PARTIAL.

### H. Conformance to D-22 §5

**H1.** P1 buckets in source file match D-22 §5 verbatim. Cross-reference:
```
grep -A 1 "^- \\*\\*§" docs/specs/fragments/_review_priority_guide.md | head -30
```
The four P1 bullets must name §11 (Transponder + ADS-B), §15 (External I/O), §4.9 (Hazard Awareness), §7 (Procedures). Verify D-15 framing mentioned for §7 and D-16 framing mentioned for §11. Read D-22 §5 itself for the canonical bucket assignments and confirm.

---

## Output

Write the compliance report to `docs/tasks/review_priority_guide_01_compliance.md` with this structure:

```markdown
---
Created: <ISO 8601 timestamp>
Source: docs/tasks/review_priority_guide_01_compliance_prompt.md
---

# REVIEW-PRIORITY-GUIDE-01 Compliance Report

**Verified:** <timestamp>
**Audit commit:** <commit hash recorded at compliance launch>
**Verdict:** [ALL PASS / PASS WITH NOTES / FAILURES FOUND]

## Summary
- Total checks: <N>
- Passed: <N>
- Failed: <N>
- Partial: <N>

## Results

### A. Source file integrity
A1. [PASS/FAIL/PARTIAL] — <evidence>
A2. ...
[continue through all A items]

### B. Assembly script edits
[continue]

### C. Backward compatibility
[continue]

### D. Aggregate output structure
[continue]

### E. Idempotency
[continue]

### F. Negative checks
[continue]

### G. Commit verification
[continue]

### H. Conformance to D-22 §5
[continue]

## Notes

<Any observations, minor deviations, or recommendations that don't rise to FAIL level but are worth documenting.>
```

---

## Completion Protocol

1. Write compliance report to `docs/tasks/review_priority_guide_01_compliance.md`.
2. Stage and commit (D-29 simple format):
   ```
   git add docs/tasks/review_priority_guide_01_compliance_prompt.md docs/tasks/review_priority_guide_01_compliance.md
   git commit -m "REVIEW-PRIORITY-GUIDE-01-COMPLIANCE: verification report [AI commit]" -m "<one-line verdict summary>" -m "Refs: D-22, REVIEW-PRIORITY-GUIDE-01"
   ```
3. Send completion notification:
   ```
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "REVIEW-PRIORITY-GUIDE-01-COMPLIANCE completed [flight-sim]"
   ```
4. **Do NOT git push.** Steve pushes manually after CD review.
5. **Do NOT modify any source files** during compliance work. Only the compliance report file is created/written.
