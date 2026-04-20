# flight-sim Conventions — Full Reference

**Source:** Adapted from Basecamp claude-conventions.md for flight-sim
**Purpose:** Complete workflow conventions including key learnings, approach & patterns, spec review, versioning, check completions protocol, CC task prompt rules, parallel CC safety, Filesystem MCP patterns, PowerShell conventions, and artifact conventions
**Load when:** Running `/spec-review`, doing check completions, writing CC task prompts, reviewing specs, planning parallel CC sessions, or needing operational reference details not covered in CLAUDE.md

---

## Key Learnings & Principles

A subset of these are also stored in Claude.ai memory; this section is the authoritative reference.

- **CD/CC role boundary is strict:** CD does design, planning, coordination, task prompt authoring, check completions, compliance review, and status document maintenance. CC does all code and document generation. CD must never deep-dive into multi-file code tracing — package as a CC task instead.
- **Spec review diminishing returns:** after 2–3 full review cycles, targeted V-patch passes outperform another full rewrite cycle. Declare implementation-ready when zero CRITICAL/HIGH gaps remain (or explicit deferral rationale exists).
- **Fully self-contained CC prompts:** revised prompts (r2, r3…) must inline all inherited content. CC starts fresh with no access to prior prompts.
- **Check completions is two-phase:** Phase 1 (CD) cross-references prompt vs. completion report → writes compliance prompt using `docs/templates/Compliance_Verification_Guide.md`. Phase 2 (CC) executes compliance, writes report. CD reviews → PASS moves files / FAIL creates bug-fix task. Files never move to `completed/` without Steve's explicit "check completions" prompt.
- **Parallel CC safety requires file-level conflict verification** — never assert safety from memory; always verify disk state explicitly.
- **Don't speculate about file state** — always use Filesystem MCP to verify before asserting.
- **Rolling Decision Log:** decisions written to `docs/decisions/` in the same turn they're made. **Log broadly — over-logging is cheap; losing concepts that fall out of conversation is not.** What counts as a decision: (a) scope/design/architecture choices; (b) convention or process refinements ("X should Y", "the lesson is Y", "the right pattern is Y"); (c) revisions of prior decisions; (d) workflow/tooling changes affecting how CD or CC operate; (e) explicit tradeoffs where a path not taken is worth preserving. **Tripwire:** prescriptive language (should/must/lesson/pattern) or revising any prior convention requires a log entry. End substantive turns with "-> Decision log: wrote D-{seq}…" or "-> no decisions this turn" — the footer must be a real check against the tripwires, not habit. Never defer — compaction risk.

---

## Approach & Patterns

- Multi-instance workflow: Green/Yellow/Purple CD instances, CC for implementation
- Task lifecycle: CD writes prompt → CC executes → check completions → validation/compliance → `completed/`
- Spec review pipeline: 13 agents, `/spec-review` command
- Session initialization: colored CD instances read only their own color's checkpoint on init; three-step fallback (own-color → latest non-color-coded → no prior context). Colored instances never read another color's checkpoint.
- Checkpoints in `project-status/` with project name `flight-sim`. After writing a new checkpoint, archive files older than 14 days to `C:\Users\artroom\projects\flight-sim-project\checkpoint_archive\`; always keep the most recent file per color designator in `project-status/`.
- Rolling decision log in `docs/decisions/`; decisions captured same-turn.
- All responses begin with turn header (`## [Color ]Turn N - YYYY-MM-DDTHH:MM:SS-04:00 ET`) obtained via `TZ="America/New_York" date "+%Y-%m-%dT%H:%M:%S%:z"` — never guessed.
- CC launch: `$env:CLAUDE_CODE_DISABLE_TERMINAL_TITLE = "1"; $host.UI.RawUI.WindowTitle = "[task-name]"; claude --dangerously-skip-permissions --model opusplan`
- ntfy completion notification: `Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "{TASK-ID} completed [flight-sim]"` — required on all CC prompts.

---

## Spec Review Workflow

**Authoritative reference:** `docs/specs/Spec_Review_Workflow.md`

The `/spec-review` command runs a multi-agent review pipeline with batch-sequential execution. Agents are organized into 3 user-selectable tiers and 4 execution batches.

**Tier model (select with `--tier quick|standard|full`):**

| Tier | Batches | Agents | Token cost | Use when |
|------|---------|--------|------------|----------|
| **Quick** | 1–2 | 5 | ~42% of Full | Rapid iteration on early drafts |
| **Standard** | 1–3 | 8 | ~67% of Full | Pre-implementation reviews *(default)* |
| **Full** | 1–4 | 12 | 100% | Excellence reviews, final pre-ship checks |

**Batch assignments:**

| Batch | Agents |
|-------|--------|
| 1 | Implementation, Test Coverage, Integration |
| 2 | API Contract, Assistant Parity |
| 3 | Security/Data Integrity, Error Recovery, Enhancement |
| 4 | Editorial/Convention, UX, Performance, Complexity |

**Default agents (9, always run within their tier):** API Contract, Implementation, Integration, Enhancement, Test Coverage, Complexity, Security/Data Integrity, Editorial/Convention, Assistant Parity. Defined in `.claude/agents/spec-*-reviewer.md`.

**Conditional agents (3, auto-selected based on spec content within their tier):** UX Engineer (`ux`), Error Recovery (`error-recovery`), Performance/Query (`perf`). Auto-classification uses keyword/pattern matching; overridable with `--with`/`--without` flags.

**Depth control:** `--depth shallow [N]` — auto-stop after N cumulative CRITICAL + HIGH findings checked between batches (default N=3). Agents within a batch always run to completion before the check occurs.

**Selective re-review:** The `-s {grade}` flag skips agents that scored above the threshold in the previous review. Composes with `--tier`: an agent must pass both the tier filter and the `-s` filter to run.

**Flag quick reference:**
- `--tier quick|standard|full` — agent tier selection (default: `standard`)
- `--depth shallow [N]` — auto-stop between batches at N cumulative C+H findings
- `--with {agents}` — force agents ON (can force agents outside the selected tier)
- `--without {agents}` — force agents OFF
- `--all` — equivalent to `--tier full`
- `--p1p2-only` — review only P1 and P2 sections from the Review Priority Guide; skip P3
- `--no-diff` — force full-spec review even when diff-based input would normally apply (specs >1,000 lines with prior review)
- `-s {grade}` — re-run only agents at or worse than grade; composes with `--tier`
- `--prev {path}` — explicit previous review path (used with `-s`)
- `--sequential` — run agents within each batch one at a time instead of in parallel; use when hitting API rate limits or running alongside other CC sessions
- `--fast` — launch all agents in the tier as one parallel wave; incompatible with `--depth` and `--sequential`

Each agent produces findings + a letter grade (A–F) and one-line assessment. The aggregated report sorts grades worst-to-best so problem areas surface first.

CC task prompts are written from the template at `docs/templates/CC_Task_Prompt_Template.md`, which includes a mandatory pre-flight verification section.

---

## Specification Versioning

- Specs under the `/spec-review` workflow use `_V{n}` filename suffix: `{Name}_V1.md` (first draft), `{Name}_V2.md` (after first review), etc.
- Review findings use `{Name}_V{n}_review.md` naming, encoding which spec version was reviewed.
- Both specs and findings live in `docs/specs/`. Findings files are permanent audit records — never moved to `completed/`.
- Version bump = review findings have been incorporated. Initial draft is always V1.
- A spec is **implementation-ready** when (a) the most recent review has zero CRITICAL/HIGH gaps, or (b) remaining CRITICAL/HIGH items are explicitly deferred with rationale.
- CD maintains any spec tracker through each evolution. CC does not update trackers.
- Older specs (pre-review workflow) retain their original naming without `_V{n}` suffix.
- Changebars use bracketed prefixes: `[+]` added, `[~]` modified, `[-]` removed
- Changebar versions use `basename_changebar.md`

---

## File Provenance (docs/ only)

All files created under `docs/` include a provenance header block:

- **Created:** ISO 8601 timestamp
- **Source:** prompt file path (e.g., `docs/tasks/my_task_prompt.md`) or description if no prompt file (e.g., `CD session — spec review round 2 findings`)
- Archive files additionally include **Archived from:** and **Purpose:**
- Does NOT apply to `src/`, `tests/`, `config/`, `scripts/` — use `git blame` for those.

---

## CC Task Prompts

- Prompts longer than 20 lines are saved to dedicated files rather than included inline
- Include integration context: runtime environment, paths, toolchain expectations
- CC follows specs literally but doesn't infer environmental constraints — be explicit
- ONE deliverable per task: `docs/tasks/{name}_prompt.md`. No separate launcher file. To launch, CD provides the CC launch sequence (see CC Launch Format below).
- Prompts must be **fully self-contained**. Never use placeholders that reference content in other prompt files. CC starts every session fresh with no access to prior prompts. If a revised prompt inherits phases from an earlier revision, inline the full content.
- Task type field: `docs-only` | `code` | `mixed` — `docs-only` omits pytest from pre-flight and completion protocol.
- Must include git commit with descriptive message referencing task ID after tests pass and completion report written — CC does NOT push (Steve pushes manually).
- Must end with ntfy notification (see Approach & Patterns above).

---

## Check Completions Protocol

Two-phase verification process for completed CC tasks. Triggered by "check completions".

**Phase 1 — Completion Review + Compliance Prompt (CD):**

1. Read the task prompt (`{name}_prompt.md`) and completion report (`{name}_completion.md`)
2. Cross-reference: verify every prompt requirement is addressed in the completion report
3. Identify items needing code-level verification (anything CD cannot confirm from the completion report alone)
4. Generate a compliance prompt (`{name}_compliance_prompt.md`) using the template and guidelines in `docs/templates/Compliance_Verification_Guide.md`
5. Provide Steve the launch command for CC

**Phase 2 — Compliance Review (CD):**

Triggered by "check compliance" after CC produces `{name}_compliance.md`.

1. Read the compliance report; assess PASS/FAIL/PARTIAL verdicts
2. If ALL PASS or PASS WITH NOTES (no FAIL items): move `{name}_prompt.md`, `{name}_completion.md`, `{name}_compliance_prompt.md`, and `{name}_compliance.md` to `docs/tasks/completed/`. Update status docs.
3. If FAILURES FOUND: create a bug-fix CC task prompt for the failing items. Do not move files to `completed/` until the fix is verified.

Three-source verification principle: every claim is checked against (1) the original task prompt, (2) the completion report, and (3) actual source code via the compliance report.

---

## Spec Creation → Review Lifecycle

End-to-end workflow for creating or updating a spec and getting it reviewed:

1. **CD writes a CC task prompt** — saved to `docs/tasks/{name}_prompt.md`. CD provides the CC launch sequence (see CC Launch Format below). The prompt includes a `Delivery: complete` or `Delivery: piecewise` recommendation with rationale (heuristic: >1000 expected lines → piecewise).

2. **CC creates the spec** — follows the delivery recommendation, overriding it if the actual content clearly requires the other format (with stated justification). If piecewise, CC produces part files + manifest JSON + aggregate with boundary markers — all in one task.

3. **CC outputs a review launch command** — included both in the completion report and as the final line of CC console output. Examples:
   - Piecewise: `To review: /spec-review docs/specs/{Name}_V{n}_manifest.json`
   - Complete: `To review: /spec-review docs/specs/{Name}_V{n}.md`

4. **Steve launches the review in CC** using the provided command.

5. **CD assesses the review findings** — standard review assessment workflow (triage gaps/opportunities, determine disposition, decide if another review round is needed).

This lifecycle replaces the prior pattern where manifest creation and review invocation were separate manual steps.

---

## CC Launch Format

**All CC sessions** — single or parallel — use a two-step launch sequence: a PowerShell tab-title command followed by the CC prompt. The tab-title command uses `CLAUDE_CODE_DISABLE_TERMINAL_TITLE=1` to prevent CC from overwriting the custom Windows Terminal tab title.

**Tab title and CC prompt are always presented in separate code blocks** to prevent accidental paste of the tab-title command into the CC console. Each block is labeled with the task slug as a subhead.

**Single session example:**

**{TASK-ID} Tab title:**
```
$env:CLAUDE_CODE_DISABLE_TERMINAL_TITLE = "1"; $host.UI.RawUI.WindowTitle = "{label}"; claude --dangerously-skip-permissions --model opusplan
```

**{TASK-ID} CC prompt:**
```
{CC prompt — e.g., /spec-review docs/specs/... or Read and execute docs/tasks/...}
```

**Multiple sessions** are separated by a horizontal rule (`---`) between each tab/prompt pair:

**{TASK-A} Tab title:**
```
$env:CLAUDE_CODE_DISABLE_TERMINAL_TITLE = "1"; $host.UI.RawUI.WindowTitle = "{label-a}"; claude --dangerously-skip-permissions --model opusplan
```

**{TASK-A} CC prompt:**
```
Read and execute docs/tasks/{task_a}_prompt.md
```

---

**{TASK-B} Tab title:**
```
$env:CLAUDE_CODE_DISABLE_TERMINAL_TITLE = "1"; $host.UI.RawUI.WindowTitle = "{label-b}"; claude --dangerously-skip-permissions --model opusplan
```

**{TASK-B} CC prompt:**
```
Read and execute docs/tasks/{task_b}_prompt.md
```

**Label conventions (flight-sim):**
- Spec-related tasks: `spec-{name}`
- Task implementation: `task-{name}`
- Short descriptive slug for other tasks

---

## Parallel CC Session Safety

When recommending tasks or batches for parallel CC execution, **explicitly list the files each task modifies and verify no pairwise overlap** before declaring them safe to run concurrently. Do not assert "no conflicts" based on different task IDs alone — show the file-level evidence.

**Common flight-sim conflict points** will emerge as the codebase grows. Apply the same diligence: enumerate the actual set of files each task modifies based on reading the task prompts, and verify modified-file sets are disjoint between parallel tasks. "No logical dependency" does not imply "no file-level conflict."

---

## Filesystem MCP Patterns

- `copy_file_user_to_claude` + bash grep/sed = standard pattern for searching large source files (bash cannot access Windows paths directly)
- `sed -n '{start},{end}p'` after `grep -n` for targeted section reads of large files
- `edit_file` with oldText/newText pairs for surgical edits; avoid Unicode (em-dashes, arrows) in anchor text — use Python via bash for files with special characters
- Repeated `copy_file_user_to_claude` of same filename may return cached version; `rm /mnt/user-data/uploads/<filename>` before re-copy to force fresh fetch
- `Filesystem:write_file` for complete file creation/replacement; never write to project path without complete final content; use `/tmp/` for experimentation
- For large files (>~20KB), copy-to-claude-then-bash is more reliable than direct `read_text_file`

---

## PowerShell Conventions

- Use `curl.exe` (not `curl`, which aliases to `Invoke-WebRequest`)
- Use `Invoke-WebRequest -UseBasicParsing` for HTTP requests
- Never use inline `python -c` — always save to `.py` file and provide run command
- BOM-free file writes: use `[System.IO.File]::WriteAllText()` not `Set-Content`

---

## Git Commit Trailers (per D-04)

All commits use a structured trailer block at the end of the commit message. Trailers are searchable via `git log --grep` and machine-parseable by tools.

### Commit message format

```
{TASK-ID or verb-led description}: {brief description}

{optional body}

Task-Id: {TASK-ID | MANUAL | D-{n}}
Authored-By-Instance: {cc | cd-green | cd-yellow | cd-purple | cd | steve}
{optional: Decision: D-{n}}
{optional: Refs: {spec, decision, plan}, comma-separated}
{optional: Fixes: {ITM-{n} or similar}}
{optional: Supersedes: {commit short-sha}}
{optional: Co-Authored-By: Claude Code <noreply@anthropic.com> OR Claude Desktop <noreply@anthropic.com>}
```

### Trailer order

1. `Task-Id:`
2. `Authored-By-Instance:`
3. `Decision:` (if applicable)
4. `Refs:` (if applicable)
5. `Fixes:` (if applicable)
6. `Supersedes:` (if applicable)
7. `Co-Authored-By:` (if applicable)

### Examples

**CC task commit:**
```
SAMPLES-RENAME-01: copy instrument samples with safe names and generate manifest

Task-Id: SAMPLES-RENAME-01
Authored-By-Instance: cc
Refs: D-02, GNC355_Prep_Implementation_Plan_V1
Co-Authored-By: Claude Code <noreply@anthropic.com>
```

**CD decision commit:**
```
D-04: add commit trailer policy

Task-Id: D-04-AUTHORING
Authored-By-Instance: cd-purple
Decision: D-04
Co-Authored-By: Claude Desktop <noreply@anthropic.com>
```

**Steve manual commit:**
```
Remove stale refresh flag

Task-Id: MANUAL
Authored-By-Instance: steve
```

### Rejected trailers (do not add)

- `Signed-off-by:` — DCO sign-off. Not operating under a DCO.
- `Reviewed-by:` — Gerrit-style code review. Not our workflow.
- `Tested-by:` — CC always tests before commit; redundant.

### CD commit scope

CD commits its own direct file writes at natural turn seams:
- End of a substantive turn where files were written
- On explicit Steve request ("commit that")
- Before authoring a task prompt that will cite the files just written

CD commits use `Authored-By-Instance: cd-{color}` where color matches the active CD instance. Standard CD sessions (no color) use `cd`. **CD does NOT push.**

Full decision record: `docs/decisions/D-04-commit-trailer-policy.md`.

---

## Artifact Conventions

Changebar versions use bracketed prefixes indicating the nature of each change:

- `[+]` — content added
- `[~]` — content modified
- `[-]` — content removed

Each changebar file includes a change summary and revision history block at the top.

Naming:
- Changebar filename: `basename_changebar.md`
- Clean (final) filename: `basename.md`
- **No version numbers in filenames.** Version information lives in the revision history block, not the filename.

---

## Cross-File Linking

Cross-file links in markdown use **relative paths** so links survive repo relocations.

- From repo root: `[CLAUDE.md](CLAUDE.md)`, `[conventions](claude-conventions.md)`
- From repo root to subdirectory: `[CRP](docs/standards/compaction-resilience-protocol-v1.md)`
- Within `docs/`: paths relative to the linking file's directory

Avoid absolute workstation paths (`C:\Users\artroom\...`) — they break when the repo is moved or cloned elsewhere.

Links render as clickable in Typora and other markdown readers. In Claude.ai's system-prompt context they are rendered as raw markdown (not clickable), but cause no harm there — the trade-off favors the disk-reader experience.
