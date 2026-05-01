# check updates — Command Specification

**Created:** 2026-04-25T09:46:23-04:00
**Source:** Purple Turn 3 — adapted from `photoprinting/docs/commands/check_updates.md` after discovering flight-sim's copy was missing on disk; extended from 3 target files to 4 to include `Task_flow_plan_with_current_status.md` per CLAUDE.md Key Data Sources

---

## Purpose

Update the four CD-maintained status files to reflect current project state. Triggered by Steve saying "check updates".

## Target Files

| File | Location | Tracks |
|------|----------|--------|
| CC_Task_Prompts_Status.md | `docs/tasks/` | CC task lifecycle (active, completion pending, compliance pending, done) |
| Spec_Tracker.md | `docs/specs/` | Spec versions, review rounds, dispositions, implementation readiness |
| priority_task_list.md | `docs/todos/` | Combined priority ranking of all open work |
| Task_flow_plan_with_current_status.md | `docs/tasks/` | Flat per-task status across all prep / design / implementation streams |

## Procedure

For each of the four target files, execute steps 1–4 in order. Then execute step 5 once across all four.

### Step 1: Backup

Copy the current file to `{filename}_backup.md` in the same directory, overwriting any previous backup. Git/GitHub preserves full version history — the backup exists only as a quick-restore safety net during the update session.

### Step 2: Archive completed items

Move completed sections and entries to the corresponding archive file. Locations:

- `priority_task_list.md` → `docs/todos/completed/priority_task_list_archive.md`
- `CC_Task_Prompts_Status.md` → tasks already track archival via the `docs/tasks/completed/` four-file move; this file's "Archived" section receives a one-line entry per task
- `Spec_Tracker.md` → no separate archive file; specs that reach implementation-ready remain in the tracker with a status flag
- `Task_flow_plan_with_current_status.md` → no separate archive file; completed rows remain with ✅ Done status until the next major phase boundary, then bulk-moved to `docs/tasks/completed/Task_flow_plan_archive_{phase}.md`

The archive file (where one exists):

- Is created on first use with a provenance header per the file provenance rule (**Created**, **Source**, **Archived from**, **Purpose**).
- Receives the full detailed entry as it existed in the primary file.
- The primary file retains only a minimal one-line reference indicating the entry was archived and where (e.g., a row noting "✅ COMPLETE — see `priority_task_list_archive.md`").

Judgment call: only archive items that are definitively closed. Items that are "done but might reopen" (e.g., deferred review findings, ITMs marked low-severity carry-forward) stay in the primary file.

### Step 3: Update the primary file

Apply all pending updates based on what has happened since the last update:

- **CC_Task_Prompts_Status.md:** New tasks created, status transitions (active → completion written → compliance pending → done), new entries in Completed table.
- **Spec_Tracker.md:** Version bumps, review rounds completed, disposition changes, implementation-readiness assessments, fragment manifest updates for piecewise specs.
- **priority_task_list.md:** Items completed, new items added at appropriate tier, priority reordering, dependency changes.
- **Task_flow_plan_with_current_status.md:** Per-task status transitions, new tasks inserted into the sequence, decision-pivot annotations. This file is normally updated incrementally same-turn as state changes; `check updates` is its catch-up pass for any drift.

### Step 4: Update the "Last updated" line

Set the `**Last updated:**` metadata line near the top of each file to the current timestamp (ISO 8601, ET) with a brief note of what changed. If the file does not yet have a Last updated line, add one immediately below the provenance header. Example: `2026-04-25T09:46:23-04:00 — C2.2-G launched in CC; AFMS V2 amendment work itemized`.

### Step 5: Cross-consistency check

After all four files are updated, scan for drift between them:

- A task marked complete in `CC_Task_Prompts_Status.md` should be reflected in `priority_task_list.md` and `Task_flow_plan_with_current_status.md`.
- A spec that advanced a review round in `Spec_Tracker.md` should have its corresponding priority and task-flow entries updated.
- Items removed from one file should not still appear as active in another.
- An ITM logged in `issue_index.md` that crosses the priority threshold (active blocker, watchpoint, etc.) should be reflected in `priority_task_list.md`.

This is a quick sanity pass on items that changed this round, not an exhaustive cross-audit.

## Recommended Sequence

Update in this order: **CC_Task_Prompts_Status.md → Spec_Tracker.md → Task_flow_plan_with_current_status.md → priority_task_list.md**. The first three are factual records; `priority_task_list.md` synthesizes from them and benefits from having the others current.

## Scope

- **CD only.** CC does not execute `check updates` and does not modify these four files (except via task archival, which is part of the existing `check completions` flow, not `check updates`).
- **No git operations.** CD updates the files. CD may commit them at a natural turn seam per D-04. Steve pushes when convenient.
- **No same-turn substitution.** `check updates` is a discrete operation. Status files updated incrementally during normal work do NOT count as `check updates` having been run; the cross-consistency check (step 5) is the differentiator.

## Notes specific to flight-sim

- This file was authored from inference at Purple Turn 3 (2026-04-25). The original Basecamp template was not located in the flight-sim repo; the photoprinting sister project's copy was the working reference. If a canonical Basecamp source surfaces, reconcile.
- `Task_flow_plan_with_current_status.md` is normally maintained same-turn (per its own header and userMemories convention). Its inclusion here is for catch-up drift only.
