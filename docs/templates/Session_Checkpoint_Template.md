# Session Checkpoint Template

A single checkpoint format for all sessions. Complete the sections that reflect the work done. Sections marked **(if applicable)** are skipped when irrelevant.

```yaml
---
project: {project_name}
timestamp: [ISO timestamp from system]
checkpoint_type: session
instance: "[green|yellow|purple — omit this field entirely for standard (non-colored) sessions]"
staleness_threshold_days: 3

# ── Session identification ──────────────────────────────────────
# instance: identifies the CD browser instance (green/yellow/purple) that
# wrote this checkpoint. Colored instances read only their own color's files
# on session init (fallback: latest non-colored file, then no prior context).
# Standard sessions omit this field and read the latest file regardless of color.

phase: [current development phase]
phase_progress_pct: [estimate 0-100]

momentum_score: [user's 1-5 rating]
momentum_note: "[optional reason]"

session_summary: |
  [2-3 sentence summary of what was accomplished this session]

# ── Vertical pass context (if applicable) ───────────────────────
# Complete this section if the session involved work on a specific
# pipeline stage, even if only partially.

vertical_pass:
  stage_name: "[e.g., Photo Selection Engine — or 'none' if not stage-scoped]"
  prn_task: "[e.g., PRN-10 — or blank]"
  skeleton_section: "[e.g., Section 6 — or blank]"
  stage_status: [complete / partial / blocked / not_applicable]
  stage_blocked_by: "[if blocked]"

  # Data model state at session end
  data_model_version: "[date of latest changelog entry — or 'unchanged']"
  schema_changes_count: [number of DDL changes introduced, 0 if none]

  # Interface contract health
  entry_verification:
    performed: [true / false]
    all_passed: [true / false / not_applicable]
    issues_found: "[description, or 'none']"

  # Deliverables produced for this stage
  deliverables:
    - path: "[interface document path, if produced]"
      status: [complete / draft / not_started]
    - path: "docs/specs/Print_Pipeline_Data_Model.md"
      status: [updated / unchanged]
      changes: "[brief description, or 'none']"
    - path: "docs/specs/PRN9_Print_Pipeline_Data_Model_Skeleton.md"
      status: [updated / unchanged]
      changes: "[brief description, or 'none']"

  # Cross-stage connective tissue
  upstream_regrets:
    # Things discovered that affect already-completed stages
    - regret: "[description]"
      affected_stage: "[stage name]"
      severity: [additive / modificative / structural]
    # Empty list [] if none

  downstream_assumptions:
    # Things this session is counting on a later stage to handle
    - assumption: "[description]"
      target_stage: "[stage name]"
    # Empty list [] if none

# ── Reconciliation context (if applicable) ──────────────────────
# Complete this section only during the reconciliation session.

reconciliation:
  performed: [true / false]
  vertical_passes_reviewed:
    - stage: "[stage name]"
      interface_doc: "[path]"
    # All reviewed stages

  regrets_resolved:
    - regret: "[description]"
      resolution: "[how resolved]"
      schema_impact: "[DDL changes, or 'none']"

  regrets_unresolved:
    - regret: "[description]"
      reason: "[why unresolved]"
      action: "[what needs to happen]"

  contracts_verified:
    - boundary: "[Stage A → Stage B]"
      status: [compatible / needs_amendment]
      notes: "[details if needs_amendment]"

  final_schema_status: [ready_for_implementation / needs_revision]
  migration_script_path: "[path, if generated]"

# ── General workflow tracking ───────────────────────────────────

workflow:
  completed_count: [number of steps done]
  steps:
    - id: [step-id]
      name: "[step name]"
      status: [completed / active / blocked / pending]
      last_touched: [ISO timestamp if known]
      blocked_by: "[blocker if any]"
      depends_on: [step-id if any]
  remaining_known_count: [number of known future steps beyond those listed]
  remaining_unknown: [true / false]

recent_steps:
  - step: "[what was completed]"
    completed: [date]
    last_touched: [ISO timestamp]

next_steps:
  - step: "[immediate next task]"
    depends_on: "[dependency if any]"

blockers:
  - item: "[what's blocking progress]"
    since: [date first noted]
    severity: [high / medium / low]

dependencies:
  - item: "[external dependency]"
    status: [received / pending / blocked]

# ── Decisions and deferrals ─────────────────────────────────────

recent_decisions:
  - "[decision made this session]"

pending_decisions:
  - "[decision that needs to be made]"

deferred:
  - item: "[what was deferred]"
    target: "[stage, session, or reconciliation]"
    reason: "[why deferred]"

open_questions:
  - "[unresolved question]"

# ── Artifacts ───────────────────────────────────────────────────

artifacts_modified:
  - path: "[file path]"
    action: [created / updated / deleted]

data_pipeline:
  status: [healthy / partial / broken / not-started / not-applicable]
  notes: "[brief status description]"
---

## Context Recovery Notes

[Narrative paragraph that would help future-you quickly get back up to speed.
Include key context, where you left off mentally, and any "aha moments" worth
preserving.]

## Entry Briefing for Next Session

[Concise reading list in priority order for the next session:
1. This checkpoint
2. Skeleton (specific sections if relevant)
3. Data model document (if updated)
4. Most recent stage interface document (if relevant)
5. Any upstream regrets or downstream assumptions targeting next work]
```
