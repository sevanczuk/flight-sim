# CC Task Prompt: GNC355-SPEC-OUTLINE-01 Compliance Verification

**Created:** 2026-04-21T07:26:47-04:00
**Source:** CD Purple session — Turn 13 — check completions for GNC355-SPEC-OUTLINE-01
**Task ID:** GNC355-SPEC-OUTLINE-01-COMPLIANCE
**Verifying:** GNC355-SPEC-OUTLINE-01 (C2.1 — outline-first sub-task per D-11)
**Prompt under review:** `docs/tasks/c2_1_outline_prompt.md`
**Completion under review:** `docs/tasks/c2_1_outline_completion.md`
**Output under review:** `docs/specs/GNC355_Functional_Spec_V1_outline.md` (1,327 lines per completion report)

---

## Instructions

This is a **read-only verification task**. Do NOT modify any source files, the outline document, the completion report, or any reference docs. Verify that the outline matches the prompt's structural requirements and that the completion report's claims are substantiated by the actual artifact.

Read `CLAUDE.md` for project conventions.

For each checklist item, report:
- **PASS** — with the evidence (file, line number, relevant snippet, or grep/wc output)
- **FAIL** — with what was expected vs. what was found
- **PARTIAL** — with explanation of what is present and what is missing

Use `grep -n`, `wc -l`, `head`, `tail`, and Python JSON readers liberally. Quote specific lines and command outputs that prove compliance.

The outline is large (1,327 lines per claim). Don't paste it wholesale; quote targeted sections. For PDF page-reference verification, read only the specific pages being checked from `assets/gnc355_pdf_extracted/text_by_page.json`.

---

## Checklist

### I. Structural Inventory

**I1. Outline file line count** — Run `wc -l docs/specs/GNC355_Functional_Spec_V1_outline.md`. Report actual count vs. completion-report claim of 1,327.

**I2. All 15 top-level sections present** — Run `grep -nE '^## [0-9]+\.' docs/specs/GNC355_Functional_Spec_V1_outline.md`. Expect 15 lines (sections 1–15). Report the list.

**I3. All 3 appendices present** — Run `grep -nE '^## Appendix [A-C]' docs/specs/GNC355_Functional_Spec_V1_outline.md`. Expect 3 lines (A, B, C). Report the list.

**I4. Required outline fields per section** — For sections 1, 4, 11, and Appendix A (a sample covering small/large/COM-specific/comparison-style), confirm each contains all required subsections:
- `**Scope.**`
- `**Source pages.**` (or `**Source pages.** N/A` for §15)
- `**Estimated length.**`
- `**Sub-structure:**`
- `**AMAPI knowledge cross-refs.**` (or `**AMAPI cross-refs.**` — both forms are acceptable)
- `**Open questions / flags.**` (may be omitted if section legitimately has none — completion report claims 9 of 18 sections have entries)

Report which subsections are present/missing for each of the 4 sampled sections.

**I5. Format recommendation present in outline header** — Confirm `docs/specs/GNC355_Functional_Spec_V1_outline.md` contains a `**Format recommendation for C2.2:**` field at the top with a recommendation (one of: monolithic / piecewise + manifest / one task per section) AND rationale (1+ paragraph). Quote the recommendation field verbatim.

**I6. Outline navigation aids block present** — Confirm `## Outline navigation aids` section exists with section count, largest-sections list, and significant-coverage-gaps list. Quote the block.

---

### II. Page Reference Accuracy (Random Sample)

The completion report's spot-check verified 3 page references (§4.6, §11.5, §7.2). Verify 7 additional random page references — different from the 3 already-verified — to surface any systematic page-reference drift.

**II1. Sample 7 sub-bullets at random from the outline.** Use `grep -nE '\[pp?\. [0-9]+(–[0-9]+)?\]' docs/specs/GNC355_Functional_Spec_V1_outline.md | shuf -n 7` (or equivalent random sampling). Across the 7 selections, ensure coverage of:
- At least one from §1–3 (intro sections)
- At least one from §4 sub-sections (the largest section)
- At least one from §5–10 (workflow/lookup sections)
- At least one from §11–15 (COM/alerts/messages/persistence/IO)
- At least one from Appendix A (family delta)

If random selection doesn't naturally cover that distribution, supplement with one targeted pick per uncovered range.

**II2. For each of the 7 selections:**
- Quote the outline sub-bullet text
- Read the cited page(s) from `assets/gnc355_pdf_extracted/text_by_page.json` (the JSON has top-level key `pages`; each page dict has `page_number`, `text`, `text_char_count`, and other fields)
- Quote a relevant excerpt from the cited page(s)
- Report PASS (page content matches the sub-bullet topic), FAIL (content does not match), or PARTIAL (page contains related but not exact content)

**II3. Aggregate result.** Report total PASS / FAIL / PARTIAL counts. The threshold for an outline-quality PASS at this check is: at least 6 of 7 PASS, with FAIL count ≤ 1. If FAIL count ≥ 2 or PARTIAL count ≥ 3, flag for CD review as a systematic issue.

---

### III. AMAPI Cross-Reference Validity

**III1. List all AMAPI Pattern references** — Run `grep -oE 'Pattern [0-9]+' docs/specs/GNC355_Functional_Spec_V1_outline.md | sort -u`. Report all distinct pattern numbers cited.

**III2. Verify each cited pattern exists in B3 catalog** — For each distinct pattern number from III1, confirm the corresponding pattern heading exists in `docs/knowledge/amapi_patterns.md` via `grep -nE '^### Pattern N:' docs/knowledge/amapi_patterns.md`. Report any pattern numbers cited in the outline that do NOT exist in the catalog.

**III3. List all A3 use-case section references** — Run `grep -oE 'amapi_by_use_case\.md.*§[0-9]+' docs/specs/GNC355_Functional_Spec_V1_outline.md | sort -u` (or similar pattern matching `§N` references). Report all distinct A3 sections cited.

**III4. Verify A3 sections exist** — For each cited A3 section, confirm via `grep -nE '^## §?N\b' docs/knowledge/amapi_by_use_case.md` (use whatever section-heading pattern A3 actually uses). Report any A3 sections cited in the outline that do NOT exist.

**III5. Verify reference-doc paths cited in outline** — Run `grep -oE 'docs/reference/amapi/by_function/[A-Za-z_]+\.md' docs/specs/GNC355_Functional_Spec_V1_outline.md | sort -u`. For each distinct path, confirm the file exists. Report any broken file paths.

---

### IV. B4 Gap Coverage

The outline must acknowledge B4's three coverage gaps in appropriate sections per the prompt's Phase 0 requirement.

**IV1. Gap 1 (canvas-drawn faces)** — Search outline for "Gap 1" or "canvas drawing pattern precedent" or similar acknowledgment. Confirm presence in §4.2 (Map page) and §4.9 (Hazard Awareness terrain/weather overlays). Quote the relevant flag entries.

**IV2. Gap 2 (touchscreen idioms beyond button_add)** — Search for "Gap 2" or "scrollable list" or "GTN 650 sample" acknowledgment. Confirm presence in §4.3 (FPL page) and at least one other touchscreen-heavy section (§2.3, §4.5, or similar). Quote the relevant flag entries.

**IV3. Gap 3 (running displays §8 + maps §10)** — Search for "Gap 3" or "Running_txt_add" or "Running_img_add" acknowledgment. Confirm presence in §4.11 (COM Standby Control Panel — frequency display) and §11 (COM Radio Operation). Quote the relevant flag entries.

---

### V. Family Delta Appendix Coverage (per D-02 §9)

**V1. Appendix A structure** — Confirm Appendix A contains comparison sub-sections for each non-baseline unit:
- A.1 or equivalent: unit identification / coverage note (mentions GNC 375 vs. GNX 375 disambiguation)
- GPS 175 vs. GNC 355 differences
- GNX 375 vs. GNC 355 differences
- GNC 355A vs. GNC 355 differences
- Feature matrix or equivalent overview

Report which sub-sections are present.

**V2. GNC 375 disambiguation flagged** — Confirm Appendix A explicitly notes that D-02 §9 references "GNC 375" but the Pilot's Guide covers "GNX 375" as the third sibling unit. The disambiguation should be in Appendix A.1 (or wherever the unit identification sub-section is). Quote the flag.

**V3. Comparison content is structural, not full prose** — Per the prompt's hard constraint, the family-delta appendix outlines what to compare (which features, which pages), not the actual comparison content. Confirm sub-bullets are descriptors (e.g., "GPS 175 lacks: COM radio") rather than full paragraphs. Spot-check 5 sub-bullets.

---

### VI. Anti-Drift Checks (no prose authoring)

The prompt explicitly forbade drift into prose authoring. Verify:

**VI1. Sub-bullets are noun phrases or topic descriptors** — Spot-check 10 random sub-bullets across the outline. Each should be a phrase or descriptor list, NOT a complete sentence with subject-verb-object prose. Acceptable: `Outer knob: page shortcut navigation, cursor placement, COM major frequency digits`. Not acceptable: `When the pilot rotates the outer knob clockwise, the GNC 355 advances through page shortcuts in the locater bar, providing rapid access to user-pinned pages.` Report any sub-bullets that drift into full prose.

**VI2. Family delta avoids actual GPS 175/GNX 375 comparison content beyond what the Pilot's Guide explicitly compares** — Confirm Appendix A sub-bullets are claims directly traceable to the Pilot's Guide (with `[p. N]` citations) or stated as "differences per AVAILABLE WITH annotations throughout." Comparison facts that go beyond the PDF (e.g., conjectured behavior differences) should be flagged as open questions, not asserted as facts.

**VI3. No spec-body prose in sections** — Confirm no section contains a multi-paragraph prose draft of the spec content itself. Scope statements (1 paragraph) and rationale statements are acceptable; full content drafts are not.

---

### VII. Length Estimate Plausibility

**VII1. Sum of section length estimates** — Sum all `**Estimated length.** ~N lines` values across sections and appendices. Report the sum. Compare to completion-report claim of ~2,800 total lines.

**VII2. Section-to-source-page ratio sanity check** — For sections 4.2 (Map, claims ~200 lines from pp. 113–139 = 27 source pages), 7 (Procedures, claims ~300 lines from pp. 181–207 = 27 source pages), and 11 (COM, claims ~200 lines from pp. 57–74 = 18 source pages): compute lines-per-source-page ratio. Flag if any section's ratio is dramatically out of band (> 20 lines per source page, < 3 lines per source page) which suggests over- or under-scoping.

---

### VIII. Format Recommendation Grounding

**VIII1. Recommendation matches the recommended grouping** — The outline header recommends piecewise + manifest with 6 sub-tasks (C2.2-A through C2.2-F). For each recommended sub-task, sum the estimated lengths of the sections it covers and report whether the sum matches the per-task estimate (~350–550 lines per task). Flag any sub-task whose section-sum is more than ±30% off from the claimed per-task estimate.

**VIII2. Recommendation rationale is grounded** — Quote the rationale paragraph(s). Confirm the reasoning ties to specific outline characteristics (total length, largest-section size, cross-section coupling) rather than generic claims.

---

### IX. Completion Protocol Conformance

**IX1. D-04 commit trailers** — Run `git log --format=full -1 -- docs/specs/GNC355_Functional_Spec_V1_outline.md` (or `-3` and find the relevant commit). Verify the GNC355-SPEC-OUTLINE-01 commit includes:
- `Task-Id: GNC355-SPEC-OUTLINE-01`
- `Authored-By-Instance: cc`
- `Co-Authored-By: Claude Code <noreply@anthropic.com>`
- `Refs:` line referencing D-01, D-02, D-11, GNC355_Prep_Implementation_Plan_V1

Quote the trailer block verbatim.

**IX2. Single commit for the task** — Confirm only ONE commit is associated with the outline file creation (no in-progress commits, no later edits). Run `git log --oneline -- docs/specs/GNC355_Functional_Spec_V1_outline.md`.

**IX3. CC did NOT push** — Run `git log @{push}..HEAD --oneline` and confirm the GNC355-SPEC-OUTLINE-01 commit is in the local-only set.

**IX4. ntfy notification documentation** — The completion report does not explicitly confirm the ntfy notification was sent (only the prompt mandated it). If the completion report omits this confirmation, mark PARTIAL — same pattern as previous tasks per D-08; not a substantive failure.

**IX5. No refresh flags created by this task** — Run `git show --name-only HEAD~5..HEAD -- '*.needs_refresh' 2>/dev/null` (broad scope to catch any creation in recent commits). Confirm the GNC355-SPEC-OUTLINE-01 commit did not create any `.needs_refresh` files. (Pre-existing flags from prior sessions are unrelated; not a defect.)

---

### X. Coverage Flag Quality

**X1. Coverage flag count** — Run `grep -cE '^\*\*Open questions / flags\.\*\*' docs/specs/GNC355_Functional_Spec_V1_outline.md` and `grep -cE '^- ' <output capturing only the lines under each Open questions block>` (or read sections sequentially). Report total sections with non-trivial flags vs. completion-report claim of 9 of 18.

**X2. Significant flag presence** — Confirm the completion report's 5 most-significant flags are actually present in the outline at the cited sections:
- §15 External I/O — datarefs not in Pilot's Guide
- §4.2 Map Page — map rendering architecture choice deferred
- §4.3 / §14 Persistent state — flight plan / waypoint serialization schema
- §4.3 Scrollable list implementation — B4 Gap 2
- Appendix A — GNC 375 / GNX 375 disambiguation

Quote the flag from each cited location.

---

## Output

Write the compliance report to `docs/tasks/c2_1_outline_compliance.md` with this structure:

```markdown
---
Created: <ISO 8601 timestamp from `date` command>
Source: docs/tasks/c2_1_outline_compliance_prompt.md
---

# GNC355-SPEC-OUTLINE-01 Compliance Report

**Verified:** <timestamp>
**Verdict:** [ALL PASS / PASS WITH NOTES / FAILURES FOUND]

## Summary
- Total checks: <N>
- Passed: <N>
- Partial: <N>
- Failed: <N>

## Results

### I. Structural Inventory
I1. [PASS/FAIL/PARTIAL] — <evidence>
...

### II. Page Reference Accuracy (Random Sample)
...

### III. AMAPI Cross-Reference Validity
...

### IV. B4 Gap Coverage
...

### V. Family Delta Appendix Coverage
...

### VI. Anti-Drift Checks
...

### VII. Length Estimate Plausibility
...

### VIII. Format Recommendation Grounding
...

### IX. Completion Protocol Conformance
...

### X. Coverage Flag Quality
...

## Notes

<Any observations, minor anomalies, or recommendations not rising to FAIL but worth documenting. In particular: any patterns in the page-reference verification (e.g., "all 7 sampled refs were exact" vs. "sampled refs typically off by 1 page"), any cross-reference broken-link surprises, any structural choices that seemed unusual.>
```

---

## Completion Protocol

1. **Verify report claims against actual state** (per D-08 — re-run all `grep`/`wc`/`ls` commands at the moment of writing the compliance report; do not carry numbers from earlier in the session).

2. Write compliance report to `docs/tasks/c2_1_outline_compliance.md` (path above).

3. Commit using D-04 trailer format. Write the commit message to a temp file via `[System.IO.File]::WriteAllText()` (BOM-free) and use `git commit -F <file>`. Message structure:
   ```
   GNC355-SPEC-OUTLINE-01-COMPLIANCE: verification report for C2.1 outline

   Task-Id: GNC355-SPEC-OUTLINE-01-COMPLIANCE
   Authored-By-Instance: cc
   Refs: GNC355-SPEC-OUTLINE-01, D-11
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

4. **Flag refresh check:** This task does not modify `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`. Do NOT create refresh flags.

5. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNC355-SPEC-OUTLINE-01-COMPLIANCE completed [flight-sim]"
   ```

6. **Do NOT git push.** Steve pushes manually.
