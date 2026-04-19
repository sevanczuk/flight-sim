## Response Format

Begin every response with turn number and timestamp.

### Claude Desktop Instance Identification

If the user's first message in a session is `green`, `yellow`, or `purple` (case-insensitive, with or without additional text), this identifies a Claude Desktop instance. Use the colored turn header format for all turns in that session:

```
## Green Turn N - YYYY-MM-DDTHH:MM:SS-04:00 ET
### <Topic>
```

After recognizing the instance color, proceed seamlessly with normal session initialization (Mode 1/2/3 below). The colored turn header serves as acknowledgment—no separate confirmation needed.

### Standard Sessions

For sessions not starting with a color identifier, use the standard turn header:

```
## Turn N - YYYY-MM-DDTHH:MM:SS-04:00 ET
### <Topic>
```

### Timestamp Rules (All Sessions)

- Turn numbering restarts at 1 with each new conversation
- Timestamp MUST be obtained by running system command: `TZ="America/New_York" date "+%Y-%m-%dT%H:%M:%S%:z"`
- Do NOT guess or estimate the timestamp; always execute the command
- Format is ISO 8601 with timezone offset

## Session Initialization

Session startup adapts to how the user opens the conversation:

**Mode 1 — General resumption** (e.g., "continue", "what's next", "where are we"):
Read the latest checkpoint or pulse from `project-status/` using instance-aware file selection:
- **Colored instance** (green/yellow/purple): read the latest file whose filename contains this instance's color. If none found, fall back to the latest non-color-coded file. If none found, proceed with no prior context. A colored instance NEVER reads another color's checkpoint/pulse.
- **Standard session** (no color identifier): read the latest file regardless of color coding.
If it's a pulse file (filename ends in `-pulse.md`), do a quick read and proceed. If it's a full checkpoint, read it, summarize where we are, and ask what's next.

**Mode 2 — Direct task** (e.g., "check completions", "assess X_V2_review.md", "write task prompt for X"):
Skip the checkpoint read entirely. Go straight to the requested work.

**Mode 3 — Skip init** (e.g., "skip init", "no init"):
Skip the checkpoint read and don't assume any prior context. Wait for the user's next instruction.

**Combined with Instance ID:** If user opens with "green" alone, treat as Mode 1. If "yellow: check completions", treat as Mode 2 with Yellow instance. If "purple skip init", treat as Mode 3 with Purple instance.

## Project Status Tracking

**Project Name:** flight-sim

### Status Checkpoint (Full)
When user says "status checkpoint" or "full checkpoint":

1. **Ask for momentum score:** "On a scale of 1-5, how satisfied are you with progress this session? (5 = most satisfied). Optionally add a brief reason."

2. **Generate checkpoint file** with this structure:
```yaml
---
project: flight-sim
timestamp: 2026-04-19T00:00:00-04:00
checkpoint_type: full
instance: "[green|yellow|purple — omit for standard sessions]"
staleness_threshold_days: 3

phase: [current development phase]
phase_progress_pct: [estimate 0-100]

momentum_score: [user's 1-5 rating]
momentum_note: "[user's optional reason]"

session_summary: |
  [2-3 sentence summary of what was accomplished this session]

workflow:
  completed_count: [number of steps done]
  steps:
    - id: [step-id]
      name: "[step name]"
      status: [completed/active/blocked/pending]
      last_touched: 2026-04-19T00:00:00-04:00
      blocked_by: "[blocker if any]"
      depends_on: [step-id if any]
  remaining_known_count: [number of known future steps]
  remaining_unknown: [true/false]

recent_steps:
  - step: "[what was completed]"
    completed: 2026-04-19
    last_touched: 2026-04-19T00:00:00-04:00

next_steps:
  - step: "[immediate next task]"
    depends_on: "[dependency if any]"

blockers:
  - item: "[what's blocking progress]"
    since: 2026-04-19
    severity: [high/medium/low]

recent_decisions:
  - "[decision made this or recent sessions]"

pending_decisions:
  - "[decision that needs to be made]"

open_questions:
  - "[unresolved question needing input]"

artifacts_modified:
  - path: "[file path]"
    action: [created/updated/deleted]
---

## Context Recovery Notes

[Narrative paragraph for future-you to get back up to speed.]
```

3. **Archive old checkpoints:** After writing the new checkpoint to `project-status/`, archive any checkpoints older than 14 days to `C:\Users\artroom\projects\flight-sim-project\checkpoint_archive\`. Always keep the most recent file per color designator in `project-status/`, regardless of age.

### Pulse Check (Quick)
When user says "pulse" or "quick status":

```yaml
---
project: flight-sim
timestamp: 2026-04-19T00:00:00-04:00
checkpoint_type: pulse
instance: "[green|yellow|purple — omit for standard sessions]"
current_task: "[task ID and brief status]"
next: "[immediate next action with file path if applicable]"
blocker: "[if blocked, one-line description; otherwise omit]"
---
```

### Status File Location
- Full checkpoints: `project-status/flight-sim-YYYY-MM-DD-HHMM.md` or `flight-sim-YYYY-MM-DD-HHMM-{color}.md`
- Pulse: `project-status/flight-sim-YYYY-MM-DD-HHMM-pulse.md` or `flight-sim-YYYY-MM-DD-HHMM-{color}-pulse.md`

## Reference Files (Read on Demand)

These files are NOT pre-loaded in the project. Read them via filesystem tools when the conversation requires them.

| File | Location | Load when |
|------|----------|-----------|
| Decision log | `docs/decisions/` | Checking prior decisions, adding new ones |
| Spec Review Workflow | `docs/specs/Spec_Review_Workflow.md` | Running spec reviews, understanding agent tiers |
| CRP | `docs/standards/compaction-resilience-protocol-v1.md` | Planning multi-phase CC tasks, applying compaction recovery |
| Memory bootstrap | `docs/templates/memory_bootstrap.md` | Re-seeding Claude.ai memory, verifying Layer content |
| Compliance guide | `docs/templates/Compliance_Verification_Guide.md` | Writing compliance prompts after CC completion |
| CC task prompt template | `docs/templates/CC_Task_Prompt_Template.md` | Authoring new CC task prompts |

## Flag File Protocol

When CD/CC modifies a file that has a Claude.ai project counterpart, create a flag:

- `CLAUDE.md.needs_refresh` — re-upload to Claude.ai project Files
- `claude-project-instructions.md.needs_refresh` — re-paste into Claude.ai Instructions field
- `claude-conventions.md.needs_refresh` — re-upload to Claude.ai project Files
- `cc_safety_discipline.md.needs_refresh` — re-upload to Claude.ai project Files

Each flag contains a one-line description (who, when, what to do). Steve deletes after refreshing Claude.ai. Flags are gitignored (`*.needs_refresh`).

**Special case — `claude-memory-edits.md`:** this file mirrors the 30-slot Claude.ai Memory system (per D-55). When CD/CC modifies this file, also apply the change to the live memory system via the `memory_user_edits` tool in the same turn. Create `claude-memory-edits.md.needs_refresh` ONLY when the file and memory are actually out of sync — for instance, when same-turn memory sync was not possible from the editing session. If same-turn sync succeeded, no flag is needed. (Per D-63.)

## Rolling Decision Log

Decisions written to `docs/decisions/` in the same turn they're made. End substantive turns with "-> Decision log: wrote D-{seq}…" or "-> no decisions this turn." Never defer — compaction risk.

## Compaction Resilience Protocol (CRP)

When preparing prompts for CC that may trigger compaction (3+ phases, >500 lines output, 5+ source files, >15 min estimated duration), include CRP configuration. Reference: `docs/standards/compaction-resilience-protocol-v1.md`.
