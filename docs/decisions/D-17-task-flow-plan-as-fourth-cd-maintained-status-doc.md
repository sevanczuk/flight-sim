# D-17: Task_flow_plan_with_current_status.md as fourth CD-maintained status document

**Created:** 2026-04-21T12:00:00-04:00
**Source:** Purple Turn 26 — Steve saved the Turn 25 inline task-flow-plan output to `docs/tasks/Task_flow_plan_with_current_status.md` and directed that it be kept updated as work progresses
**Decision type:** convention / process refinement (Tripwire: prescriptive language + workflow change affecting CD operation)
**Refines:** prior three-file status-doc convention

## Context

Before this turn, the CD-maintained status documents were three: `Spec_Tracker.md`, `CC_Task_Prompts_Status.md`, `priority_task_list.md`. Each serves a distinct cross-cut:

- `Spec_Tracker.md` — spec lifecycle (versions, reviews, dispositions)
- `CC_Task_Prompts_Status.md` — task-prompt-level running status
- `priority_task_list.md` — cross-cutting priority ranking across specs/tasks/TODOs/followups

The Turn 25 task-flow-plan output was a distinct fourth view: a flat, phase-oriented list of all prep/design/implementation tasks with completion status. Useful enough that Steve saved it to disk and directed ongoing maintenance.

## Decision

`docs/tasks/Task_flow_plan_with_current_status.md` becomes the fourth CD-maintained status document.

**Update cadence:** CD updates this file in the same turn whenever a task status changes. Triggers:
- A task completes and gets archived to `docs/tasks/completed/`
- A new task is inserted into the sequence (e.g., C2.0 harvest was inserted between C2.1 and C2.1-375)
- A decision pivots the flow (e.g., D-12 restructuring Stream C)
- "check updates" command is invoked (refreshes all four CD-maintained status docs)

**Structure:** Phase-oriented, flat table view. Prep → Design → Implementation → Future. Each phase broken into streams. Each task has ID, description, and status (✅ Done / 🔶 Active / 🔵 Running / ⚪ Pending / deferred). Status transitions:
- ⚪ Pending → 🔵 Running (when CC starts a task)
- 🔵 Running → ✅ Done after compliance PASS and archive

**Live-state footer:** "Where we are right now" block at the bottom rolls forward each turn — current active task, next CD action, critical path description.

**Distinction from the other three:**
- `Spec_Tracker.md` is spec-centric; this file is task-centric.
- `CC_Task_Prompts_Status.md` is task-prompt-level (prompt lifecycle: drafted → launched → complete → archived); this file is phase-level (prep/design/impl with task hierarchy).
- `priority_task_list.md` ranks by criticality; this file preserves sequence.

## Consequences

- `Task_flow_plan_with_current_status.md` gets a provenance header with update cadence documented inline.
- `CLAUDE.md` Key Data Sources table adds the new file between CC task status and Spec tracker.
- Memory slot #6 updated to reference four CD-maintained status docs instead of three, with the Task_flow_plan update-cadence rule appended.
- `claude-memory-edits.md` mirror updated same-turn.
- `CLAUDE.md.needs_refresh` flag created for re-upload.
- No changes to Spec_Tracker, CC_Task_Prompts_Status, or priority_task_list responsibilities.

## What this decision does NOT change

- Existing CD-maintained status docs remain distinct (no merging or consolidation).
- CC does not update the new file (same rule as other three).
- Provenance-header convention (D-?; all `docs/` files have Created + Source) continues to apply.
- The narrative Implementation Plan V2 (`docs/specs/GNX375_Prep_Implementation_Plan_V2.md`) remains the authoritative stream-by-stream plan; the new file is a flat task-level view derived from it.

## Related

- `docs/tasks/Task_flow_plan_with_current_status.md` (the new file)
- `CLAUDE.md` §Key Data Sources (updated)
- `claude-memory-edits.md` slot #6 (updated)
- `docs/specs/GNX375_Prep_Implementation_Plan_V2.md` (narrative plan)
