# CC Task Prompt: AMAPI-PATTERNS-01 Compliance Verification

**Created:** 2026-04-20T18:24:38-04:00
**Source:** CD Purple session — check completions for AMAPI-PATTERNS-01
**Task ID:** AMAPI-PATTERNS-01-COMPLIANCE
**Verifying:** AMAPI-PATTERNS-01 (B3 — pattern catalog from Tier 1+2 instrument samples)
**Prompt under review:** `docs/tasks/amapi_patterns_prompt.md`
**Completion under review:** `docs/tasks/amapi_patterns_completion.md`
**Spec context:** `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` §6.B.3

---

## Instructions

This is a **read-only verification task**. Do NOT modify any source files, instrument samples, the pattern catalog, the appendix, or the CRP scratch artifacts. Verify that the AMAPI-PATTERNS-01 implementation matches the original prompt and that the completion report's claims are substantiated by the deliverables.

Read `CLAUDE.md` for project conventions.

For each checklist item, report:
- **PASS** — with the evidence (file, line number, relevant snippet, or grep output)
- **FAIL** — with what was expected vs. what was found
- **PARTIAL** — with explanation of what is present and what is missing

Use `grep -n` and similar tools liberally. Quote specific lines that prove compliance. Where a count is asked for, show the command and the count.

The pattern catalog is the largest deliverable (~66 KB). Don't paste it wholesale; quote targeted sections.

---

## Checklist

### I. Inventory & Structure

**I1. Pattern count claim (24)** — Run a grep that counts pattern headings (e.g., `grep -cE '^### Pattern [0-9]+(\.[0-9]+)?:' docs/knowledge/amapi_patterns.md`). Report the actual count. PASS if 24; FAIL otherwise (and report the discrepancy).

**I2. Pattern count within target band (15–30)** — Confirm the actual count from I1 falls in 15–30.

**I3. Categories present** — Verify the pattern catalog contains category headers matching the completion-report breakdown:
- Writing to the simulator
- Reading simulator state
- Touchscreen / button input
- Knob / hardware dial input
- Visual state management
- Sound
- User properties / configuration
- Persistence
- Instrument metadata / platform

Use `grep -nE '^## Category:' docs/knowledge/amapi_patterns.md`. Report the list of category headers found.

**I4. Required structural sections** — Confirm the pattern catalog has:
- Front-matter provenance header (`Created:`, `Source:`)
- "How to use this document" section
- "Pattern index" section
- "Pattern cross-reference" section near the end
- "What this catalog does NOT cover" section

**I5. Sample appendix structure** — Verify `docs/knowledge/amapi_patterns_sample_appendix.md` contains:
- 6 per-Tier-1-sample sections (one for each of: GTN 650, GNS 530, GNS 430, KAP 140, KX 165A, GFC 500)
- 8 per-Tier-2-sample sections (heading, altimeter, VOR, ADF, switch panel, Garmin 340, GMA 1347D, turn coordinator)
- A "Sample-specific techniques" section with ~13 entries (completion report claim)

Show counts via grep on section headers.

---

### II. Per-pattern Quality (Spot-Check)

**II1. Pick 3 patterns** — Spot-check Pattern 1, Pattern 11, and Pattern 21 (one from early/middle/late in the catalog; Pattern 11 is also the cross-referenced persistence-from-knob-input pattern; Pattern 21 is the one whose completion report flagged a broken `Hw_dial_add` link). For each, verify:
- Has all required subsections: **Problem**, **Solution**, **Code sketch**, **Functions used**, **Exemplars**, optionally **Variants**, **Caveats**, **GNC 355 relevance**
- **Code sketch** is between 8 and 30 lines (allow some slack around the 10–25 prompt target)
- **Exemplars** lists at least 2 sample directory names

**II2. Exemplar samples actually contain the claimed idiom** — For Pattern 1 only (the most-emphasized pattern), pick one of its named exemplar samples and grep the corresponding `assets/instrument-samples-named/{exemplar}/logic.lua` to confirm the pattern's signature functions actually appear there. Report the grep output.

---

### III. Anticipated Patterns Presence

The CD-side prompt anticipated 5 patterns from spot-reading samples. Confirm each is represented in the catalog (it may have a different name; identify by behavior). For each, quote the pattern's heading and one defining sentence:

**III1. Triple-dispatch pattern** — Same pilot button fires `xpl_command` + `fsx_event` + `msfs_event` for cross-sim portability. Expected to be the most common pattern.

**III2. Parallel subscription pattern** — Same callback wired to `xpl_dataref_subscribe` + `fsx_variable_subscribe` + `msfs_variable_subscribe`.

**III3. Long-press detection** — `timer_start` (~1500 ms) in press callback; `timer_stop` in release callback; differentiates short vs long press.

**III4. Multi-instance device-ID** — `user_prop_add_integer("Device ID", ...)` plus string concatenation into command/event names so multiple panels of the same instrument can coexist.

**III5. Detent-type user prop** — `user_prop_add_enum` for rotary-encoder detent type, mapped to a `TYPE_*_DETENT_PER_PULSE` constant.

For each: PASS = present in catalog with matching idiom; PARTIAL = related pattern exists but differs from anticipated form; FAIL = absent. Absence of any of these would be surprising and is itself an informative finding — explain why if so.

---

### IV. Cross-Reference Integrity

**IV1. Total cross-link count** — Count the number of links of the form `../reference/amapi/by_function/*.md` in `docs/knowledge/amapi_patterns.md`. Use `grep -oE '\.\./reference/amapi/by_function/[^)]+\.md' docs/knowledge/amapi_patterns.md | wc -l`. Report the count. Completion report claims ~85.

**IV2. Distinct functions referenced** — From the same grep, count distinct targets. Completion report claims 34. Report the actual distinct count.

**IV3. Broken-link scan (full)** — For every distinct cross-link target in `amapi_patterns.md`, verify the file exists at `docs/reference/amapi/by_function/{Name}.md`. Report:
- Total distinct targets
- Targets that resolve
- Targets that do NOT resolve (list each broken link with the pattern that uses it)

The completion report acknowledges `Hw_dial_add.md` is missing as a known gap (Pattern 21). Confirm whether any OTHER broken links exist beyond that one. PASS = `Hw_dial_add` is the only broken link; PARTIAL = additional broken links exist; report all.

**IV4. Spot-check report's 5 named targets exist** — Re-verify the 5 targets the completion report spot-checked actually exist:
- `docs/reference/amapi/by_function/Xpl_dataref_subscribe.md`
- `docs/reference/amapi/by_function/Timer_start.md`
- `docs/reference/amapi/by_function/Si_variable_subscribe.md`
- `docs/reference/amapi/by_function/Persist_add.md`
- `docs/reference/amapi/by_function/Group_add.md`

---

### V. Source-of-Truth Coverage

**V1. Phase 0 audit was performed** — Confirm `_crp_work/amapi_patterns_01/_phase_A_complete.md` (or `_status.json`) reflects that source-of-truth docs were read before sample analysis. If a Phase 0 deviation file exists, that's a FAIL signal — check `docs/tasks/amapi_patterns_prompt_phase0_deviation.md` and `docs/tasks/amapi_patterns_prompt_deviation.md` are absent.

**V2. B2 Tier 1 / Tier 2 boundaries respected** — Confirm raw notes exist for exactly the 6 specified Tier 1 samples (no extras, none missing). Compare `_crp_work/amapi_patterns_01/raw_notes_*.md` filenames against the prompt's Phase A list.

**V3. Function usage matrix has Tier 2 columns** — Phase C explicitly required updating the matrix to include Tier 2 columns. Check `_crp_work/amapi_patterns_01/function_usage_matrix.md` headers — should include the 8 Tier 2 sample names alongside the 6 Tier 1 sample names. PASS = 14 sample columns; FAIL = only 6.

---

### VI. Negative Checks (No Modifications)

**VI1. Instrument sample files untouched** — Run `git status` and `git diff --stat HEAD~5..HEAD -- assets/instrument-samples-named/`. Should report ZERO modified files under `assets/instrument-samples-named/`. PASS = nothing modified there.

**VI2. AMAPI reference docs untouched by this task** — Verify `docs/reference/amapi/by_function/*.md` were not modified during this task (i.e., not in this task's commit). PASS if those files were last modified by AMAPI-PARSER-01 (or earlier), not by AMAPI-PATTERNS-01.

**VI3. No refresh flags created** — Confirm no `*.needs_refresh` files were created by this task. The prompt explicitly stated none should be. Use `ls *.needs_refresh 2>/dev/null` from project root.

---

### VII. Completion Protocol Conformance

**VII1. D-04 commit trailers** — Run `git log --format=full -5` (or `git log --format=fuller -5`) to view recent commits. Find the AMAPI-PATTERNS-01 commit. Verify it includes:
- `Task-Id: AMAPI-PATTERNS-01`
- `Authored-By-Instance: cc`
- `Co-Authored-By: Claude Code <noreply@anthropic.com>`
- `Refs:` line referencing parent tasks (SAMPLES-RENAME-01, AMAPI-PARSER-01, GNC355_Prep_Implementation_Plan_V1)

Quote the trailer block verbatim from the commit message.

**VII2. Commit format used `-F` (no multi-`-m`)** — This is harder to verify after the fact, but check that the commit message body has multi-paragraph structure (more than one line of content beyond the subject). PASS = trailer block is intact and properly formatted.

**VII3. CC did NOT push** — Run `git status` and `git log @{push}..HEAD --oneline` (or check whether the commit is on origin via `git branch -r --contains HEAD`). PASS = local commit not on remote, OR commit on remote BUT only because Steve pushed it after the fact (note this distinction in the report).

**VII4. ntfy completion notification sent** — Cannot fully verify post-hoc, but check whether the completion report mentions sending the notification, OR whether there is any persistent record. Mark PARTIAL if no evidence either way; FAIL if the completion report explicitly omits/forgets it.

---

### VIII. Reference Documentation Gap (from completion report)

**VIII1. Confirm `Hw_dial_add.md` is genuinely missing** — Verify `docs/reference/amapi/by_function/Hw_dial_add.md` does not exist. Then check whether any other `Hw_*` functions are referenced in patterns but lack reference docs. Run `grep -oE 'Hw_[a-z_]+' docs/knowledge/amapi_patterns.md | sort -u` and check each against the reference dir. Report any additional gaps.

**VIII2. Pattern 21 link form** — Show the exact text of how Pattern 21 references `hw_dial_add` (is it a markdown link to a missing file, or plain text without a link?). This informs the issue-tracking decision.

---

## Output

Write the compliance report to `docs/tasks/amapi_patterns_compliance.md` with this structure:

```markdown
---
Created: <ISO 8601 timestamp from `date` command>
Source: docs/tasks/amapi_patterns_compliance_prompt.md
---

# AMAPI-PATTERNS-01 Compliance Report

**Verified:** <timestamp>
**Verdict:** [ALL PASS / PASS WITH NOTES / FAILURES FOUND]

## Summary
- Total checks: <N>
- Passed: <N>
- Partial: <N>
- Failed: <N>

## Results

### I. Inventory & Structure
I1. [PASS/FAIL/PARTIAL] — <evidence>
...

### II. Per-pattern Quality (Spot-Check)
...

### III. Anticipated Patterns Presence
...

### IV. Cross-Reference Integrity
...

### V. Source-of-Truth Coverage
...

### VI. Negative Checks
...

### VII. Completion Protocol Conformance
...

### VIII. Reference Documentation Gap
...

## Notes

<Any observations, minor deviations, or recommendations not rising to FAIL but worth documenting. Particularly: any additional broken links beyond Hw_dial_add, any structural surprises in the pattern catalog, and any anticipated patterns that were absent or substantially different from prediction.>
```

---

## Completion Protocol

1. Write compliance report to `docs/tasks/amapi_patterns_compliance.md` (path above)
2. Stage and commit using D-04 trailer format. Message structure:
   ```
   AMAPI-PATTERNS-01-COMPLIANCE: verification report for B3 pattern catalog

   Task-Id: AMAPI-PATTERNS-01-COMPLIANCE
   Authored-By-Instance: cc
   Refs: AMAPI-PATTERNS-01
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```
   Write the message to a temp file via `[System.IO.File]::WriteAllText()` and commit with `git commit -F <file>`. Do NOT use multi-`-m`.
3. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "AMAPI-PATTERNS-01-COMPLIANCE completed [flight-sim]"
   ```
4. **Do NOT git push.** Steve pushes manually.
5. **Flag refresh check:** This task does not modify `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`. Do NOT create refresh flags.
