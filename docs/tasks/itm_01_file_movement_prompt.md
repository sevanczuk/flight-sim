# CC Task Prompt: ITM-01 File Movement Batch — Archive Completed Task Files

**Created:** 2026-04-21T06:29:27-04:00
**Source:** CD Purple session — Turn 7 — drafted to action ITM-01
**Task ID:** ITM-01-FILE-MOVEMENT
**Issue reference:** ITM-01 (`docs/todos/issue_index.md`)
**Priority:** Critical-path housekeeping — unblocks C2 (GNC 355 Functional Spec authoring) by clearing the `docs/tasks/` namespace
**Estimated scope:** Small — ~15 min wall-clock; 16 file moves + verification + commit
**Task type:** docs-only (no code, no tests)
**CRP applicability:** NO — single phase, small output, brief duration
**Source of truth:**
- `docs/todos/issue_index.md` §ITM-01 (issue definition and trigger)
- `docs/tasks/completed/` (destination — already exists; contains B3 task quad)
**Audit level:** self-check — rationale: the task is mechanical (file moves) and easy to verify by directory listing.

---

## Pre-flight Verification

**Execute these checks before moving any file. If any check fails, STOP and write `docs/tasks/itm_01_file_movement_prompt_deviation.md`.**

1. Verify destination directory exists:
   - `ls docs/tasks/completed/` — should succeed and show 4 existing files (the B3 quad: `amapi_patterns_*`)

2. Verify all 16 source files exist at the paths listed in §"Files to move" below:
   - Run `ls docs/tasks/{filename}` for each of the 16 files
   - All must succeed

3. Verify no naming collisions at the destination:
   - For each of the 16 files, confirm `docs/tasks/completed/{filename}` does NOT already exist
   - If any collision is found, STOP — collisions indicate an earlier partial move or an unexpected state

4. Verify the file that must NOT be moved is still present:
   - `ls docs/tasks/MANUAL_gnc355_eyeball_low_confidence_pages.md` — must succeed; this file stays in `docs/tasks/` per ITM-01

5. Verify git working tree is clean enough to commit (no unrelated staged changes):
   - `git status --short` — note any staged or unstaged changes; if substantial unrelated changes exist, flag in the deviation report and ask before proceeding

---

## Files to move

**16 files across 8 task sets.** Moves are from `docs/tasks/{filename}` → `docs/tasks/completed/{filename}` (filename preserved exactly).

### Set 1: AMAPI-CRAWLER-01 (A1)
- `amapi_crawler_prompt.md`
- `amapi_crawler_completion.md`

### Set 2: AMAPI-CRAWLER-BUGFIX-01
- `amapi_crawler_bugfix_01_prompt.md`
- `amapi_crawler_bugfix_01_completion.md`

### Set 3: AMAPI-CRAWLER-BUGFIX-02
- `amapi_crawler_bugfix_02_prompt.md`
- `amapi_crawler_bugfix_02_completion.md`

### Set 4: AMAPI-CRAWLER-BUGFIX-03
- `amapi_crawler_bugfix_03_prompt.md`
- `amapi_crawler_bugfix_03_completion.md`

### Set 5: AMAPI-CRAWLER-BUGFIX combined compliance
- `amapi_crawler_bugfix_combined_compliance_prompt.md`
- `amapi_crawler_bugfix_combined_compliance.md`

### Set 6: AMAPI-PARSER-01 (A2)
- `amapi_parser_prompt.md`
- `amapi_parser_completion.md`

### Set 7: GNC355-PDF-EXTRACT-01 (C1)
- `gnc355_pdf_extract_prompt.md`
- `gnc355_pdf_extract_completion.md`

### Set 8: SAMPLES-RENAME-01 (B1)
- `rename_instrument_samples_prompt.md`
- `rename_instrument_samples_completion.md`

---

## Files that must NOT move

- `MANUAL_gnc355_eyeball_low_confidence_pages.md` — Steve's active manual work list per ITM-01; stays in `docs/tasks/` until Steve explicitly closes it

If any other file appears in `docs/tasks/` that's not on the move list above and is not the MANUAL file, STOP and flag in the deviation report. Likely cause: a new task was started after this prompt was authored, in which case it should NOT be archived.

---

## Instructions

Execute the file moves using `git mv` (preserves rename detection in git history; required for clean diff display in `git log --follow`). Do NOT use `mv`, `Filesystem:move_file`, or PowerShell `Move-Item` — those break git's rename tracking.

**Also read `CLAUDE.md`** for project conventions and `claude-conventions.md` §Git Commit Trailers for the D-04 commit format.

---

## Implementation

Execute as a single phase. No CRP needed.

### Phase A: Execute moves

For each of the 16 files in §"Files to move", run:

```bash
git mv "docs/tasks/{filename}" "docs/tasks/completed/{filename}"
```

Order doesn't matter; do them grouped by task set for readability of the staged changes.

After all 16 `git mv` commands complete, run `git status --short` and verify the output shows exactly 16 lines of the form `R  docs/tasks/{filename} -> docs/tasks/completed/{filename}` (the `R` prefix is git's rename indicator). Any other status (`A`, `D`, `M`, `??`) on these paths indicates a problem.

### Phase B: Verify

Run these verification commands and capture the output for the completion report:

1. Source directory inventory:
   ```bash
   ls docs/tasks/*.md 2>/dev/null | wc -l
   ```
   Expected: 1 (only the MANUAL file remains; everything else moved or is in subdirs)

2. Source directory contents (sanity check):
   ```bash
   ls docs/tasks/*.md
   ```
   Expected: only `docs/tasks/MANUAL_gnc355_eyeball_low_confidence_pages.md`

3. Destination directory count:
   ```bash
   ls docs/tasks/completed/*.md | wc -l
   ```
   Expected: 20 (4 existing B3 files + 16 newly moved files)

4. Destination directory contents (full listing for the completion report):
   ```bash
   ls docs/tasks/completed/*.md | sort
   ```

5. Confirm the staged renames look right:
   ```bash
   git diff --cached --stat | tail -20
   ```
   Should show `R100` (rename, 100% similarity) for each of the 16 files.

If any verification check fails, STOP, leave moves unstaged-but-on-disk for inspection, and write the deviation report. Do NOT commit a partial or incorrect state.

---

## Completion Protocol

1. **Verify report claims against actual state** (per D-08 — re-run `ls` / `wc` commands at the moment of writing the completion report; do not carry numbers from earlier in the session).

2. Write completion report `docs/tasks/itm_01_file_movement_completion.md` with:
   - Provenance header (Created, Source)
   - Pre-flight verification results (which checks passed)
   - Phase A summary: 16 files moved (or actual count if different); list any anomalies
   - Phase B verification command outputs (quoted inline)
   - Final state: destination file count, source file count, MANUAL file confirmation
   - Any deviations from this prompt with rationale

3. Commit using the D-04 trailer format. Write the commit message to a temp file via `[System.IO.File]::WriteAllText()` (BOM-free) and use `git commit -F <file>`. Message structure:
   ```
   ITM-01-FILE-MOVEMENT: archive completed task files to docs/tasks/completed/

   Moves 16 files (8 task sets) from docs/tasks/ to docs/tasks/completed/
   per ITM-01. Sets archived: AMAPI-CRAWLER-01, three crawler bugfixes,
   crawler-bugfix combined compliance, AMAPI-PARSER-01,
   GNC355-PDF-EXTRACT-01, SAMPLES-RENAME-01.

   The MANUAL_gnc355_eyeball_low_confidence_pages.md file remains in
   docs/tasks/ per ITM-01 (Steve's active work list).

   Task-Id: ITM-01-FILE-MOVEMENT
   Authored-By-Instance: cc
   Refs: ITM-01
   Fixes: ITM-01
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

   Use the file-based commit pattern (NOT multi-`-m`):
   ```powershell
   $msg = @'
   ...message above...
   '@
   [System.IO.File]::WriteAllText((Join-Path $PWD ".git\COMMIT_EDITMSG_cc"), $msg)
   git commit -F .git\COMMIT_EDITMSG_cc
   Remove-Item .git\COMMIT_EDITMSG_cc
   ```

4. **Flag refresh check:** This task does not modify `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`. Do NOT create refresh flags.

5. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "ITM-01-FILE-MOVEMENT completed [flight-sim]"
   ```

6. **Do NOT git push.** Steve pushes manually.

---

## What This Unblocks

- ITM-01 closed (CD will move it to `issue_index_resolved.md` post-compliance)
- `docs/tasks/` namespace cleared down to active items only — easier for future-Purple to scan for in-flight work
- C2 (GNC 355 Functional Spec V1 draft) — the next critical-path deliverable — can now be authored with a clean working directory

---

## Rationale Notes (background — informational, not actionable)

- **Why `git mv` instead of plain `mv` or Filesystem MCP move:** preserves git's rename detection. Without it, `git log --follow docs/tasks/completed/{filename}.md` shows the file as starting at the new location with no history. With it, the full history walks back to creation. Worth the small overhead.
- **Why one commit instead of one-per-set:** the moves are mechanically uniform; a single commit is easier to revert atomically if needed and shows the batch as one unit in the log.
- **Why ITM-01 fires now:** per its own definition in `issue_index.md`, ITM-01 fires when Stream A and Stream B both reach "ready for design phase." A reached this state at A2+A3 completion; B reached it after B4 readiness review (Turn 5).
