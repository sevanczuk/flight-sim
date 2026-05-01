# CC Task Prompt: C2.2-ASSEMBLE Compliance Verification

**Task ID:** GNX375-SPEC-C22-ASSEMBLE-COMPLIANCE
**Verifying:** GNX375-SPEC-C22-ASSEMBLE (completed 2026-04-30)
**Prompt:** `docs/tasks/c22_assemble_gnx375_prompt.md`
**Completion:** `docs/tasks/c22_assemble_gnx375_completion.md`
**Outputs under verification:**
- `scripts/assemble_gnx375_spec.py` (249 lines)
- `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` (4433 lines)
**Created:** 2026-04-30T09:14:49-04:00
**Source:** Purple Turn 10 — Phase 1 check-completions cross-reference of c22_assemble_gnx375_prompt.md vs. c22_assemble_gnx375_completion.md

---

## Instructions

This is a **read-only verification task**. Do NOT modify any source files. Verify that the C2.2-ASSEMBLE implementation matches the original prompt by gathering concrete evidence from the script source, the aggregate output, and independent re-runs of the assembly process.

Read `CLAUDE.md` for project conventions.

For each checklist item below, report:
- **PASS** — with evidence (file, line number, command output)
- **FAIL** — with what was expected vs. what was found
- **PARTIAL** — with explanation of what's present and what's missing

Use `grep -nE` and `wc -l` liberally. Where the completion report claims a count or grep result, **independently re-run the command and report your own count** rather than trusting the completion report.

---

## Categories

- **F. Format / structure** — script + aggregate file basic properties
- **S. Script behavior** — flag handling, exit codes, partial-mode
- **V. Verification logic** — the 8 in-script checks the prompt mandates
- **A. Aggregate output content** — strip rules applied correctly
- **D. Determinism** — re-run produces identical structural output
- **N. Negative checks** — content that must NOT appear
- **C. CD-review-flagged items** — Appendix B/C placement, retained preambles

---

## Checklist

### F. Format / Structure

**F1.** `scripts/assemble_gnx375_spec.py` exists and is callable. Run `python scripts/assemble_gnx375_spec.py --help` and confirm a help text emits with the documented flags. Report the script line count via `wc -l`. Completion report claims 249.

**F2.** `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` exists. Run `wc -l` and report. Completion report claims 4433.

**F3.** Aggregate H1 count: `grep -cE '^# ' docs/specs/GNX375_Functional_Spec_V1_aggregate.md` → expect **1**. Report integer.

**F4.** Aggregate H2 count: `grep -cE '^## ' docs/specs/GNX375_Functional_Spec_V1_aggregate.md` → expect **18** (§§1–15 = 15, Appendix A/B/C = 3). Report integer.

**F5.** Aggregate H3 count: `grep -cE '^### ' docs/specs/GNX375_Functional_Spec_V1_aggregate.md`. Completion report claims 149. Report integer.

**F6.** Aggregate provenance comment: confirm lines 3–6 contain a `<!-- ... -->` block with "Assembled from seven part files", "Source manifest:", "Fragments:", "Generated:" markers. Quote the block.

**F7.** Aggregate H1 line: confirm line 1 is exactly `# GNX 375 Functional Spec V1`. Quote.

### S. Script Behavior

**S1.** Script depends only on Python standard library. Inspect imports in `scripts/assemble_gnx375_spec.py` and confirm no third-party imports. Report the import list.

**S2.** Default-run behavior: run `python scripts/assemble_gnx375_spec.py --check` from the project root. Confirm exit code 0 and that the verification summary is printed. Capture stdout to your report.

**S3.** `--verbose` flag: run `python scripts/assemble_gnx375_spec.py --check --verbose` and confirm strip statistics table prints (per-fragment lines, YAML stripped, H1+intro stripped, Coupling Summary stripped, body lines). Capture stdout.

**S4.** `--check` flag: confirm `--check` does NOT write to disk. Use `Get-FileHash docs/specs/GNX375_Functional_Spec_V1_aggregate.md` before and after running `--check`; hashes must match (file unchanged).

**S5.** `--manifest`, `--fragments-dir`, `--output` flags: confirm script accepts these flags via `python scripts/assemble_gnx375_spec.py --help`. No need to actually re-run with custom paths; just confirm the flags are documented.

**S6.** Exit codes: confirm script exits 0 when all gating checks pass. Report by running `python scripts/assemble_gnx375_spec.py --check; echo $LASTEXITCODE` (PowerShell) or equivalent.

**S7.** `--partial` flag exists and is documented in `--help`. Inspect the script source for the `--partial` code path: confirm it (a) substitutes a placeholder block for missing fragments, (b) skips section-numbering continuity in missing-fragment ranges, (c) still produces a valid aggregate. Quote the relevant code lines.

### V. Verification Logic (the 8 in-script checks)

The prompt mandated 8 specific verification checks in the script. Verify each is implemented:

**V1.** Section-numbering continuity check: §§1–15 each appear at H2; no §16+; no duplicates. Search the script source for this logic and quote the relevant lines.

**V2.** Sub-section integrity spot-checks: §4.1–§4.10, §7 numeric+lettered ordering, §14 has 6, §15 has 7, Appendix A has 5. Search the script source and quote the relevant lines.

**V3.** No duplicate H2 headings check. Search script source and quote.

**V4.** No `## Coupling Summary` in aggregate check. Search script source and quote.

**V5.** No fragment-header `# GNX 375 Functional Spec V1 — Fragment X` in aggregate check. Search script source and quote.

**V6.** No YAML front-matter `---` block check. Search script source and quote.

**V7.** Cross-reference resolution check: finds all `see §N`, `§N.x`, `Appendix X` patterns and reports unresolved count. Search script source and quote.

**V8.** Total line count print. Search script source and quote.

For each: report PASS (logic present) or FAIL (logic absent or materially incorrect).

### A. Aggregate Output Content (strip rules verified)

**A1.** No YAML front-matter: `grep -nE '^---$' docs/specs/GNX375_Functional_Spec_V1_aggregate.md`. Report count and contexts. The aggregate has structural `---` separators between sections (not front-matter); these are expected. Confirm no front-matter blocks (3+ consecutive `---` containing `Created:` or `Source:` markers) appear. Sample the first 3 `---` matches to confirm they're section separators, not front-matter.

**A2.** No fragment H1 headers: `grep -nE '^# GNX 375 Functional Spec V1 — Fragment [A-G]' docs/specs/GNX375_Functional_Spec_V1_aggregate.md` → expect 0 matches.

**A3.** No `## Coupling Summary` heading: `grep -cE '^## Coupling Summary' docs/specs/GNX375_Functional_Spec_V1_aggregate.md` → expect 0.

**A4.** §4 sub-section continuity: `grep -nE '^### 4\.' docs/specs/GNX375_Functional_Spec_V1_aggregate.md` → expect 4.1 through 4.10 in order. List the matches.

**A5.** §7 sub-section ordering: `grep -nE '^### 7\.' docs/specs/GNX375_Functional_Spec_V1_aggregate.md` → expect 7.1, 7.2, ..., 7.9, 7.A, 7.B, ..., 7.M in that order. List the matches.

**A6.** §14 sub-section count: `grep -cE '^### 14\.' docs/specs/GNX375_Functional_Spec_V1_aggregate.md` → expect 6.

**A7.** §15 sub-section count: `grep -cE '^### 15\.' docs/specs/GNX375_Functional_Spec_V1_aggregate.md` → expect 7.

**A8.** Appendix A sub-section count: `grep -cE '^### A\.' docs/specs/GNX375_Functional_Spec_V1_aggregate.md` → expect 5.

**A9.** §1 (Fragment A) opens cleanly: read aggregate lines 1–20 and confirm structure: H1 line 1, blank line 2, provenance comment lines 3–6, blank line 7, `---` line 8, blank line 9, `## 1. Overview` line 10 or near. Quote.

**A10.** Fragment A→B boundary (after §3, before §4): inspect aggregate around the §3/§4 transition. Locate `## 3.` (or last `### 3.x`) and the next `## 4. Display Pages`. Confirm: no `# GNX 375 Functional Spec V1 — Fragment B` between them; no `## Coupling Summary` from Fragment A. Note that Appendix B and C from Fragment A appear in this region (per CD-review item C1 below). Quote the boundary region context.

**A11.** Fragment B→C boundary (after §4.6, before §4.7): inspect around `### 4.7 Procedures Pages`. Confirm no fragment header, no Coupling Summary leakage, no duplicate `## 4.` heading. Quote.

**A12.** Fragment F→G boundary (after §13, before §14): inspect around `## 14. Persistent State`. Confirm no fragment header, no Coupling Summary leakage. Quote.

### D. Determinism

**D1.** Run `python scripts/assemble_gnx375_spec.py --check` twice and compare verification summary stdout. Confirm structural counts (line totals, H2/H3 counts, strip statistics) are identical between runs.

**D2.** Confirm the only per-run variation is the timestamp in the provenance comment. Quote the relevant code that generates the timestamp.

### N. Negative Checks

**N1.** No script imports of disallowed packages: confirm no `import requests`, `import yaml`, `import frontmatter`, or other third-party libraries. Use grep on the script source.

**N2.** No hardcoded fragment list in concatenation logic: confirm script reads fragment order from manifest table, not a hardcoded `['A', 'B', ..., 'G']` list. Quote the relevant code. **NOTE:** if the script uses a hardcoded list with a defensible reason (e.g., manifest parsing fallback), report PARTIAL with explanation rather than FAIL — this is a minor convention concern.

**N3.** No write to `docs/specs/fragments/` or `docs/specs/GNX375_Functional_Spec_V1.md`: confirm script writes only to the `--output` path (default: `docs/specs/GNX375_Functional_Spec_V1_aggregate.md`). Source files are read-only per CC safety discipline. Inspect script for any `open(..., 'w')` or write operations and confirm targets.

**N4.** No `print` debug statements left in script source not gated by `--verbose`. Inspect for stray `print(...)` calls outside the verification summary and verbose path.

### C. CD-Review-Flagged Items (informational; do NOT change)

**C1.** Appendix B/C placement: locate Appendix B and Appendix C in the aggregate. Report their line numbers.
- Expected: appear after §3 content, before §4 (Fragment A authoring order)
- Document the actual placement with line numbers
- Completion report claims B at line 337, C at line 442. Independently confirm.
- This is a CD review item per the original prompt — do NOT recommend a fix; just report the placement.

**C2.** Retained fragment preambles: the completion report claims Fragments B, C, D, E, F retain "Fragment X of 7..." intro paragraphs at each fragment boundary. Independently verify by grepping `^Fragment [A-G] of 7` in the aggregate. Report each match's line number and surrounding context (the line before and after).

**C3.** Appendix A placement: confirm Appendix A appears at the end of the spec (after §15). Report its line number. Completion report claims line 4314.

### Provenance and Git State

**P1.** Confirm a git commit was made for this task. Run `git log -1 --format=fuller` and verify:
- Subject line begins with `GNX375-SPEC-C22-ASSEMBLE`
- `Task-Id: GNX375-SPEC-C22-ASSEMBLE` trailer present
- `Authored-By-Instance: cc` trailer present
- `Refs: D-18` at minimum in the trailer set
- `Co-Authored-By: Claude Code <noreply@anthropic.com>` trailer present
- No BOM character (U+FEFF) at the start of the subject line

**P2.** Confirm no `git push` was executed. Inspect any push-related shell history if available; otherwise note that push restriction is enforced by convention and Steve is the only one who pushes.

---

## Output

Write the compliance report to `docs/tasks/c22_assemble_gnx375_compliance.md` with this structure:

```markdown
---
Created: {ISO 8601 timestamp}
Source: docs/tasks/c22_assemble_gnx375_compliance_prompt.md
---

# GNX375-SPEC-C22-ASSEMBLE Compliance Report

**Verified:** {ISO 8601 timestamp}
**Verdict:** [ALL PASS / PASS WITH NOTES / PARTIAL / FAILURES FOUND]

## Summary
- Total checks: {N}
- Passed: {N}
- Passed with notes: {N}
- Partial: {N}
- Failed: {N}

## Results

### F. Format / Structure
F1. [PASS/FAIL/PARTIAL] — evidence
F2. ...
...

### S. Script Behavior
...

### V. Verification Logic
...

### A. Aggregate Output Content
...

### D. Determinism
...

### N. Negative Checks
...

### C. CD-Review-Flagged Items
...

### P. Provenance and Git
...

## Notes

{Observations, minor deviations, or recommendations that don't rise to FAIL level.}
```

---

## Completion Protocol

1. Write compliance report to `docs/tasks/c22_assemble_gnx375_compliance.md`
2. `git add -A`
3. `git commit` with D-04 trailer format. Use the BOM-free `WriteAllText` + `git -F` PowerShell pattern. Subject:
   ```
   GNX375-SPEC-C22-ASSEMBLE-COMPLIANCE: verification report for assembly script and V1 aggregate
   ```
   Trailers:
   ```
   Task-Id: GNX375-SPEC-C22-ASSEMBLE-COMPLIANCE
   Authored-By-Instance: cc
   Refs: GNX375-SPEC-C22-ASSEMBLE, D-18, D-22
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```
4. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-ASSEMBLE-COMPLIANCE completed [flight-sim]"
   ```

**Do NOT git push.**
