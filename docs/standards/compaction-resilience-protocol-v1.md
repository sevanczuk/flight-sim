# Compaction Resilience Protocol (CRP)

**Version:** 1.0  
**Date:** 2026-Mar-20  
**Purpose:** Standard protocol for making Claude Code prompts resilient to compaction events, context resets, and other interruptions.

---

## When to Apply CRP

Apply this protocol to any Claude Code prompt where:

- Task involves **multiple phases** or **sequential operations**
- Task generates **documents longer than 500 lines**
- Task requires **reading multiple source files** and synthesizing output
- Task duration likely exceeds **15-20 minutes**
- Task involves **complex transformations** with intermediate states
- Claude Desktop estimates the task **might trigger compaction**

**Quick heuristic:** If losing progress would cost more than 5 minutes of re-work, apply CRP.

**Token estimation:** Run `python scripts/token_estimate.py <source_files> --budget 200000` to estimate the combined input size. If source files + prompt + expected output exceed 60% of the context window, CRP is strongly recommended regardless of the other criteria above.

---

## Core Principles

### 1. Everything to Disk
Never rely on context memory for state. Write all progress, decisions, and intermediate results to files.

### 2. Idempotent Operations
Every operation must be safe to re-run. Check for existing results before executing.

### 3. Atomic Writes
Never leave files in partial states. Write to `.tmp`, verify, then rename.

### 4. Granular Checkpoints
Checkpoint at the finest granularity that makes sense. Phases are good; sections within phases are better.

### 5. Verify Before Trusting
On resume, verify integrity of existing files before assuming they're complete.

---

## Standard Work Directory Structure

```
{project_root}/_crp_work/{task_id}/
├── _status.json          # Machine-readable state (primary)
├── _status.md            # Human-readable state (fallback)
├── _source_hashes.json   # Hashes of all input files
├── _phase_{X}_complete.md    # Phase completion markers
├── _checkpoint_{N}.json      # Granular checkpoints within phases
├── _operation_log.md         # Append-only operation history
├── _casualty_log.md          # Truncation/corruption records
├── _stall_checkpoint.md      # Watchdog state (if triggered)
├── {intermediate_files}      # Task-specific intermediate outputs
└── {intermediate}_backup     # Backups before overwrites
```

---

## Status File Schema

### _status.json (Primary)

```json
{
  "crp_version": "1.0",
  "task_id": "{unique_task_identifier}",
  "task_type": "{document_generation|code_refactor|analysis|...}",
  "created": "ISO8601",
  "updated": "ISO8601",
  "source_files": [
    {"path": "...", "hash": "sha256:..."}
  ],
  "current_phase": "{phase_id}",
  "completed_phases": ["A", "B", "..."],
  "total_units": 12,
  "completed_units": 5,
  "units_pending": ["unit_6", "unit_7", "..."],
  "stall_detected": false,
  "last_operation": "{description}",
  "custom_state": { }
}
```

### _status.md (Fallback)

```markdown
# CRP Status: {task_id}

**Task:** {description}  
**Current Phase:** {X}  
**Progress:** {N}/{Total} units  
**Last Updated:** {timestamp}  
**Source Hashes:** {OK|MISMATCH}

## Completed Phases
- [x] Phase A: {title}
- [x] Phase B: {title}
- [ ] Phase C: {title} ← CURRENT
- [ ] Phase D: {title}

## Units Status
| Unit | Status | File |
|------|--------|------|
| unit_1 | ✓ | _unit_1.md |
| unit_2 | ✓ | _unit_2.md |
| unit_3 | ⏳ | (pending) |
```

---

## Protocol Components

### Component 1: Initialization

Add to **start of every CRP-enabled prompt**:

```markdown
## CRP Initialization

Before any task work:

1. **Define Work Directory**
   ```
   WORK_DIR = {project_root}/_crp_work/{task_id}/
   ```

2. **Resume Detection**
   - If WORK_DIR exists:
     a. Read _status.json
     b. Verify source file hashes match current sources
     c. Print structured resume summary
     d. Skip to first incomplete phase/unit
   - If WORK_DIR does not exist:
     a. Create WORK_DIR
     b. Compute and store source file hashes
     c. Initialize _status.json and _status.md
     d. Begin Phase A

3. **Resume Summary Format**
   ```
   ╔════════════════════════════════════════╗
   ║          CRP RESUME POINT              ║
   ╠════════════════════════════════════════╣
   ║ Task: {task_id}                        ║
   ║ Last completed phase: {X}              ║
   ║ Next phase: {Y}                        ║
   ║ Units complete: {N}/{Total}            ║
   ║ Source hashes: {OK|MISMATCH}           ║
   ╠════════════════════════════════════════╣
   ║ Action: {next_step_description}        ║
   ╚════════════════════════════════════════╝
   ```
```

### Component 2: Atomic Write Protocol

Add to **any prompt that writes files**:

```markdown
## Atomic Write Protocol

For all critical files:

1. Write content to `{filename}.tmp`
2. Verify .tmp is complete:
   - Check file size > 0
   - Read last 10 lines to confirm no truncation
3. If backup needed:
   - Copy existing `{filename}` to `{filename}_backup`
4. Rename `{filename}.tmp` to `{filename}`
5. Only delete .tmp after rename succeeds

NEVER write directly to final filename.
```

### Component 3: Phase Template

Use this template for **each phase in multi-phase prompts**:

```markdown
## Phase {X}: {Title}

### {X}.0: Resume Check
- If `_phase_{X}_complete.md` exists AND "{X}" in completed_phases:
  - Print "Phase {X} already complete, skipping"
  - Proceed to Phase {X+1}

### {X}.1–{X}.N: Phase Work
[Original phase content here — unchanged]

### {X}.Z: Phase Checkpoint
1. Write `_phase_{X}_complete.md`:
   ```
   Phase {X} completed: {ISO8601 timestamp}
   Units processed: {count}
   Duration: {seconds}s
   ```
2. Update _status.json (atomic write):
   - Add "{X}" to completed_phases
   - Set current_phase to "{X+1}"
3. Update _status.md
4. Print: "✓ Phase {X} complete"
```

### Component 4: Unit-Level Checkpointing

For prompts that process **multiple discrete units** (sections, files, records):

```markdown
## Unit Processing Protocol

For each unit in processing queue:

1. **Skip Check**
   - If unit in completed_units AND file passes integrity check:
     - Print "Unit '{id}' complete, skipping"
     - Continue to next unit

2. **Backup** (if rewriting)
   - If output file exists: copy to `{filename}_backup`

3. **Chunking** (for large units)
   - If unit > {threshold} lines:
     a. Split into chunks at logical boundaries
     b. Write each chunk to `_unit_{id}_part{N}`
     c. After all chunks: concatenate to final file
     d. Delete chunk files

4. **Write Unit**
   - Process unit content
   - Write using Atomic Write Protocol

5. **Verify**
   - Re-read last 10 lines
   - Verify expected closing content
   - Check file size within expected range
   - If verification fails:
     a. Log to _casualty_log.md
     b. Restore from backup
     c. Retry once
     d. If retry fails: PAUSE for user

6. **Update Status**
   - Add unit to completed_units
   - Remove from units_pending
   - Update last_operation
   - Print: "✓ Unit '{id}' ({N}/{Total})"
```

### Component 5: Stall Detection

Add to prompts with **long-running operations**:

```markdown
## Stall Detection (Watchdog)

If {STALL_THRESHOLD} seconds elapse without file I/O:

1. Write current state to _status.json with stall_detected: true
2. Write _stall_checkpoint.md:
   ```
   Stall detected: {ISO8601}
   Last operation: {description}
   Current phase: {X}
   Current unit: {id}
   Recovery: Re-run prompt to continue from this point
   ```
3. Print: "⚠️ STALL DETECTED — State saved. Awaiting user confirmation."
4. PAUSE for user input

Default STALL_THRESHOLD: 90 seconds
```

### Component 6: Final Assembly and Archive

Add to prompts that **produce a final deliverable**:

```markdown
## Final Assembly

### Verification
1. Confirm all units have corresponding files
2. Verify each file passes integrity check
3. If any missing/corrupted: STOP and report

### Assembly
1. Concatenate unit files in correct order
2. Add front/back matter as needed
3. Write to final output location using Atomic Write Protocol

### Integrity Check
1. Compute MD5 and SHA256 of final output
2. Write to _final_checksums.txt
3. Verify size matches expected range

### Archive (NOT Delete)
1. Rename work directory:
   `_crp_work/{task_id}/` → `_crp_work/{task_id}_archived_{timestamp}/`
2. Print:
   ```
   ✓ Work archived to: {archive_path}
     Delete manually after verification: rm -rf {archive_path}
   ```

NEVER automatically delete work directory.
```

---

## Integration Checklist

When adding CRP to an existing prompt:

- [ ] Add CRP Initialization at the start
- [ ] Define WORK_DIR with unique task_id
- [ ] Wrap each phase with Resume Check + Checkpoint
- [ ] Apply Atomic Write Protocol to all file writes
- [ ] Add Unit-Level Checkpointing if processing multiple items
- [ ] Add Stall Detection if operations may exceed 60 seconds
- [ ] Add Final Assembly with archive (not delete)
- [ ] Test resume by manually stopping mid-task and re-running

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│                 CRP QUICK REFERENCE                         │
├─────────────────────────────────────────────────────────────┤
│ WORK DIR:    _crp_work/{task_id}/                           │
│ STATUS:      _status.json (primary), _status.md (fallback)  │
│ PHASES:      _phase_{X}_complete.md                         │
│ UNITS:       _unit_{id}.md, _unit_{id}_backup.md            │
│ LOGS:        _operation_log.md, _casualty_log.md            │
├─────────────────────────────────────────────────────────────┤
│ ATOMIC WRITE: .tmp → verify → backup → rename               │
│ IDEMPOTENT:   Check exists + verify before re-running       │
│ CHECKPOINT:   After every phase AND every unit              │
│ ARCHIVE:      Rename, don't delete                          │
├─────────────────────────────────────────────────────────────┤
│ ON RESUME:    Read status → verify hashes → print summary   │
│ ON STALL:     Save state → print warning → pause            │
│ ON TRUNCATE:  Log → restore backup → retry once → pause     │
└─────────────────────────────────────────────────────────────┘
```

---

## Examples

### Example 1: Document Generation Prompt

```markdown
# Generate Technical Specification v2

## CRP Configuration
- TASK_ID: spec_v2_generation
- WORK_DIR: docs/_crp_work/spec_v2_generation/
- STALL_THRESHOLD: 90
- UNIT_TYPE: section
- CHUNK_THRESHOLD: 200 lines

## CRP Initialization
[Standard initialization block]

## Phase A: Source Analysis
[Phase template with resume check + checkpoint]

## Phase B: Section Writing
[Unit processing protocol for each section]

## Phase C: Assembly
[Final assembly with archive]
```

### Example 2: Code Refactoring Prompt

```markdown
# Refactor Legacy Module

## CRP Configuration
- TASK_ID: legacy_refactor_auth
- WORK_DIR: src/_crp_work/legacy_refactor_auth/
- STALL_THRESHOLD: 120
- UNIT_TYPE: file
- CHUNK_THRESHOLD: 500 lines

## CRP Initialization
[Standard initialization block]

## Phase A: Dependency Analysis
[Phase template]

## Phase B: File-by-File Refactor
[Unit processing protocol for each source file]

## Phase C: Test Verification
[Phase template]

## Phase D: Cleanup
[Final assembly with archive]
```

---

## Changelog

### v1.0 (2026-Mar-20)
- Initial generalized protocol extracted from ppf_v8_spec_update_prompt_r3
- Parameterized for different task types
- Added integration checklist
- Added quick reference card
- Added examples
