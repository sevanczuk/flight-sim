Review the spec at $ARGUMENTS using the spec review agent roster. Supports selective re-review, conditional agent auto-classification, and hybrid mode for multi-part specs.

**Note:** For hybrid mode, manifests are normally created by CC during spec delivery (see `docs/templates/CC_Task_Prompt_Template.md` § Spec Delivery Format). The `scripts/generate_manifest.sh` script exists as a manual escape hatch for legacy specs.

## Parse arguments

The input may include flags after the spec path:
- `--with {agents}` — force specific conditional agents ON (comma-separated short names: ux, editorial, error-recovery, perf); can force agents from outside the selected tier
- `--without {agents}` — force specific conditional agents OFF
- `--all` — run all 12 agents; equivalent to `--tier full` (takes precedence if both are specified)
- `--tier quick|standard|full` — selects the agent tier: `quick` (Batches 1–2, 5 agents), `standard` (Batches 1–3, 8 agents), `full` (Batches 1–4, 13 agents). Default: `standard`
- `--depth shallow [N]` — auto-stop after N cumulative CRITICAL + HIGH findings checked between batches (agents within a batch always run to completion). Default N=3 if `--depth shallow` is given without a number
- `-s {grade}` — selective re-review: re-run only agents that scored `{grade}` or worse in the previous review; skip agents that scored better. Composes with `--tier`: an agent must pass both the tier filter and the `-s` filter to run
- `--prev {path}` — explicit path to previous review file (used with -s)
- `--mode <section|full|hybrid|auto>` — review mode (default: auto)
- `--manifest <file>` — explicit path to manifest JSON (for hybrid mode)
- `--skip-integration` — in hybrid mode, skip Phase 2 (integration review on aggregate)
- `--skip-section` — in hybrid mode, skip Phase 1 (per-part section review)
- `--p1p2-only` — limits agent analysis to sections marked P1 and P2 in the spec's Review Priority Guide table. P3 sections are skipped entirely. If the spec has no Review Priority Guide, this flag is a no-op with a warning printed: "Warning: --p1p2-only specified but spec has no Review Priority Guide table. Reviewing all sections."
- `--no-diff` — forces full-spec review even when diff-based input would normally apply. Only relevant for specs above the diff threshold (default: 1,000 lines) that have a prior review. Useful when structural revisions make diffs unreliable, or when a fresh-eyes review of the entire spec is desired.
- `--sequential` — run agents within each batch one at a time instead of in parallel. Eliminates burst API load at the cost of 2–3× longer review time. Use when hitting API rate limit errors or running spec-review concurrently with other CC sessions.
- `--decisions {path}` — path to a conversation export file for the Decision Fidelity agent. When provided, the Decision Fidelity agent is added to Batch 1 regardless of tier. See Task Validation Architecture §15.4.

If no flags are present, run the standard tier (Batches 1–3, 8 agents) and auto-classify conditional agents within that tier.

## Mode Detection

After parsing flags, determine the review mode:

```
IF --mode is specified: use it
ELSE IF argument ends in _manifest.json: mode = hybrid
ELSE IF {basename}_manifest.json exists in same directory as spec file: mode = hybrid, load manifest
ELSE IF spec file line count > 2000: mode = hybrid, warn "No manifest found — falling back to full review"
ELSE IF spec file line count > 1000: mode = full, warn "Large spec (>1000 lines) — consider splitting with a manifest"
ELSE: mode = full
```

Print detected mode before proceeding:
```
Mode: {mode} ({reason})
```

## Mode Routing

```
CASE mode:
  "section" → run Section Review (Phase 1) only; skip Phase 2 and Phase 3
  "full"    → run existing full review (single-file path below); skip Phase 1 and Phase 2
  "hybrid"  → run Phase 1 (section review) → Phase 2 (integration review) → Phase 3 (consolidation)
  "auto"    → resolved above to one of the above
```

---

## Tier and Batch Definitions

*Used by Path A execution. Defines which agents belong to each batch and which batches each tier covers.*

```
DIFF_THRESHOLD_LINES = 1000

BATCH_1 = [spec-implementation-reviewer, spec-test-reviewer, spec-integration-reviewer]
BATCH_2 = [spec-api-reviewer, spec-assistant-parity-reviewer]
BATCH_3 = [spec-security-data-integrity-reviewer, spec-error-recovery-reviewer, spec-enhancement-reviewer]
BATCH_4 = [spec-editorial-convention-reviewer, spec-ux-reviewer, spec-performance-query-reviewer, spec-complexity-reviewer]

TIER_QUICK_BATCHES    = [BATCH_1, BATCH_2]                        (5 agents)
TIER_STANDARD_BATCHES = [BATCH_1, BATCH_2, BATCH_3]               (8 agents) — default
TIER_FULL_BATCHES     = [BATCH_1, BATCH_2, BATCH_3, BATCH_4]      (12 agents)
```

The tier determines how far down the batch sequence execution proceeds. Within each batch, all applicable agents run in parallel. Conditional auto-classification and `-s` grade filtering apply within the tier's batches. `--with` can force an agent ON regardless of tier. `--all` is equivalent to `--tier full` (12 agents).

**Domain agent auto-detection:** Domain agents matching `spec-*-reviewer.md` in `.claude/agents/` are auto-detected and default to Batch 4. Override by editing the batch constants above.

---

# PATH A: Full Review (single-file mode)

*Used when mode = "full". This is the original behavior, updated to use batch-sequential execution.*

## Agent selection sequence

### Step 1: Read the spec file

While reading, scan for a Review Priority Guide table: a section heading matching `## Review Priority Guide` or `### Review Priority Guide`. If found, parse the table rows for Priority (P1/P2/P3), Section, Title, Dependencies, and Rationale columns. Cache the result — this is passed to each agent as launch context in Step 7.

### Step 1b: Diff-based input detection

If ALL of the following conditions are met, generate a diff package:
1. The spec exceeds `DIFF_THRESHOLD_LINES` (default: 1,000 lines)
2. A prior review file exists (`{Name}_V{n-1}_review.md` in `docs/specs/`)
3. The `--no-diff` flag is not set
4. The review mode is `full` (not `hybrid`)

**Diff package generation:**
Compare the current spec V{n} against the previous spec V{n-1}. The diff package contains:
- **Changed sections:** Full text of any section with modifications, including ±5 lines of surrounding context
- **New sections:** Full text of sections not present in V{n-1}
- **Removed sections:** Section headers with note "(removed in V{n})"
- **Unchanged section inventory:** For each unchanged section, a one-line entry: "§X.Y: {title} — {line_count} lines, unchanged from V{n-1}"
- **Prior review summary:** The Agent Assessment Table and Counts from the V{n-1} review

When diff-based input is active, each agent receives the diff package instead of the full spec. Agents can use their Read tool to access the full spec file if they need the complete text of an unchanged section.

Print: `Input: diff from V{n-1} ({changed_lines} lines changed of {total_lines} total)` or `Input: full spec ({total_lines} lines)` if diff conditions not met.

### Step 2: If `-s` flag present, read previous review

Infer the previous review path by naming convention: if reviewing `{Name}_V2.md`, look for `{Name}_V1_review.md` in `docs/specs/`. If `--prev` is specified, use that path instead. If the inferred file doesn't exist and `--prev` wasn't specified, warn: "Previous review not found — falling back to full review" and proceed without `-s`.

Extract the Agent Assessment Table from the previous review. Parse each agent's letter grade.

### Step 3: Auto-classify conditional agents

Scan the spec text for trigger patterns:

| Agent | Short name | Triggers |
|-------|-----------|----------|
| spec-ux-reviewer | ux | Section headers containing `UI`, `Screen`, `Wireframe`, `Component`, `User Flow`, `Interaction`; references to `.jsx` files or `src/screens/` |
| spec-error-recovery-reviewer | error-recovery | Keywords `batch`, `multi-step`, `pipeline`, `print`, `physical output`; sections with 3+ sequential steps; references to `pending_operations` or `tool_runs` |
| spec-performance-query-reviewer | perf | SQL code blocks (```sql); references to `index.db`, `metadata_index`, `search`, `pagination`, `LIMIT`, `OFFSET`; batch operations mentioning file counts > 100 |

### Step 4: Apply `-s` grade filter

If `-s {grade}` is active, filter the agent roster:
- **Re-run** agents that scored `{grade}` or worse (lower letter grade) in the previous review
- **Skip** agents that scored better than `{grade}` (higher letter grade)
- Grade ordering from best to worst: A, B, C, D, F
- Examples: `-s C` re-runs agents that scored C, D, or F; skips A and B. `-s B` re-runs B, C, D, F; skips A only.
- The **spec-enhancement-reviewer** always runs regardless of `-s` (no letter grade)
- Agents not present in the previous review (newly added) always run
- Conditional agents newly triggered on this version (not in previous review) always run regardless of `-s`

### Step 5: Apply `--with` / `--without` overrides

- `--with` forces listed conditional agents ON regardless of trigger matching or `-s` filtering
- `--without` forces listed conditional agents OFF regardless of trigger matching
- `--all` forces all 12 agents ON (overrides both `-s` and trigger matching)

### Step 6: Print agent selection report

Print to console before launching. Show tier, depth metadata, and per-batch breakdown:

```
Spec review: {spec path}
Tier: standard (Batches 1–3)
Depth: shallow (threshold: 3) | full
{if --p1p2-only}: Scope: P1+P2 only
{if -s}: Previous review: {previous review path}
{if -s}: Selective re-review: -s {grade}

Batch 1: Implementation, Test Coverage, Integration
  ▶ Implementation {(grade) — re-running | — running}
  ▶ Test Coverage {(grade) — re-running | — running}
  ⏭ Integration (A) — carried from V{n-1}
Batch 2: API Contract, Assistant Parity
  ▶ API Contract — running
  ▶ Assistant Parity — running
Batch 3: Security, Error Recovery, Enhancement
  ▶ Security — running
  ✗ Error Recovery — no triggers matched
  ▶ Enhancement — always runs

Launching Batch 1 ({N} agents)...
```

Legend: `▶` = running this batch, `⏭` = carried from previous review (skipped by `-s`), `✗` = filtered out (no triggers, `--without`, or `-s` threshold passed). Batches beyond the selected tier are not shown. Agents with existing work-directory files are skipped (resume mode). The exact format adapts to the selected tier and active flags, but always shows the batch structure and tier metadata.

### Step 7: Launch agents in batch sequence

**Context compaction safety:** Each subagent writes its own findings to a file on disk. Files are the durable store — conversation context is transient and may be lost to compaction. The aggregation step reads files, not conversation context.

**Work directory:** `docs/specs/_review_work/{spec_review_basename}/`

Where `{spec_review_basename}` is the review filename without extension. For example, reviewing `My_Spec_V2.md` uses work directory `docs/specs/_review_work/My_Spec_V2_review/`.

Each agent writes its findings to `{work_dir}/{short_name}.md`:

| Agent | Output file |
|-------|------------|
| spec-api-reviewer | `api_contract.md` |
| spec-implementation-reviewer | `implementation.md` |
| spec-integration-reviewer | `integration.md` |
| spec-enhancement-reviewer | `enhancement.md` |
| spec-test-reviewer | `test_coverage.md` |
| spec-complexity-reviewer | `complexity.md` |
| spec-security-data-integrity-reviewer | `security.md` |
| spec-editorial-convention-reviewer | `editorial_convention.md` |
| spec-assistant-parity-reviewer | `assistant_parity.md` |
| spec-ux-reviewer | `ux.md` |
| spec-error-recovery-reviewer | `error_recovery.md` |
| spec-performance-query-reviewer | `performance.md` |

**Batch execution sequence:**

1. **Create work directory** if it doesn't exist: `mkdir -p {work_dir}`

2. **Determine tier's batch list** from `--tier` flag (default: `standard`). If `--all` is specified, use `TIER_FULL_BATCHES`. See Tier and Batch Definitions above.

3. **Resume detection:** Check for existing `{short_name}.md` files in the work directory. Any agent whose file already exists is considered complete — skip it regardless of which batch it belongs to. Print which agents are being skipped:
   ```
   Resume: found existing results for api_contract, implementation
   Remaining agents: test_coverage, integration, security, error_recovery, enhancement
   ```
   **Batch resume:** Determine which batch to start from based on which agents have completed files. Agents in a batch that have existing files are treated as already-complete; if all agents in a batch have files, the batch is fully done. Resume from the first batch with at least one agent still needing to run.

4. **Read or create `_status.md`** in the work directory. This file tracks batch execution state and adaptive parallelism:
   ```
   current_batch: 1
   batch_size: 3
   last_launched: implementation, test_coverage, integration
   last_launched_count: 3
   auto_stop_triggered: false
   cumulative_ch_count: 0
   ```
   If `_status.md` doesn't exist, create it with `current_batch: 1` and `batch_size` equal to the number of agents in the first batch.

5. **Adaptive back-off check (if resuming):** If `_status.md` exists from a prior run, compare `last_launched` against existing per-agent files. Agents in `last_launched` whose files do NOT exist are compaction/failure casualties. If there are casualties:
   - Set `batch_size = max(floor(previous_batch_size / 2), 1)`
   - Print: `Back-off: previous batch of {N} had {K} casualties. Reducing parallelism to {new_batch_size}.`

6. **For each batch in the tier's batch list** (starting from the resume batch):

   a. **Apply filters to each agent in this batch:**
      - Auto-classification (Step 3): is the agent triggered by spec content?
      - `-s` grade filter (Step 4): does the agent pass the re-run threshold?
      - `--with`/`--without` overrides (Step 5)
      - Resume skip: agent already has an output file
      - An agent runs only if it passes all applicable filters (or is forced via `--with`)

   b. **If no agents in this batch survive filtering:** Print `Batch {N}: all agents filtered or already complete — skipping` and proceed to the next batch.

   c. **Launch surviving agents.** Update `_status.md` with `current_batch: {N}`, `last_launched`, and `last_launched_count` before launching.
      - **Default (parallel):** Launch all surviving agents in the batch simultaneously. Launch in sub-batches of `batch_size` if needed (adaptive back-off). Wait for all agents in the batch to complete.
      - **`--sequential` mode:** Launch agents one at a time in the order listed in the batch table. Wait for each agent to complete before launching the next. This eliminates burst API load.

      **Timing:** Record `start_time = time.time()` before launching each agent and `elapsed = time.time() - start_time` after the agent completes and its file is verified. Store elapsed times in `_status.md` as:
      ```
      agent_times:
        implementation: 245
        test_coverage: 389
        integration: 178
      ```
      Times are in seconds. Also record `batch_start` and `batch_end` for each batch, and `review_start` at the top of Step 7 (before any batch launches).

      **Priority table context injection:** If the spec has a Review Priority Guide table (detected in Step 1), include this instruction in each agent's launch context:
      ```
      The spec contains a Review Priority Guide table. Review sections in priority order: P1 first, then P2, then P3. Read each section's listed dependencies before the section itself. {If --p1p2-only active: "Skip P3 sections entirely — review only P1 and P2 items."}
      ```
      If no Review Priority Guide was detected, omit this instruction (agents review in document order by default).

   d. **Verify each agent wrote its file.** Log any that didn't: `WARNING: {agent} completed but did not write {path}`

   e. **Between-batch depth check (if `--depth shallow N` is active):**
      - Count cumulative CRITICAL + HIGH findings across ALL per-agent files written so far (all completed batches)
      - Parse each `{short_name}.md` for lines matching `[CRITICAL]` or `[HIGH]`
      - If cumulative C+H ≥ N: print `Auto-stop: {count} C+H findings reached threshold ({N}) after Batch {M}. Remaining batches not executed.`
      - Update `_status.md`: set `auto_stop_triggered: true`, `cumulative_ch_count: {count}`
      - **Stop** — do not launch the next batch. Proceed directly to Aggregation.

   f. **If no auto-stop:** Print `Batch {M} complete in {elapsed}s ({count} C+H so far). Proceeding to Batch {M+1}.` and continue.

7. **Completion check:** After all batches (or auto-stop), verify all expected per-agent files exist. If any are still missing, report them and offer to re-launch.

**Per-agent file format:** Each agent writes a self-contained markdown file with this structure:
```markdown
# {Agent Name} Review

**Grade:** {letter grade}
**Assessment:** {one-line summary}

## Findings

### G-{n} [{severity}] {title}
**Location:** ...
**Issue:** ...
**Impact:** ...
**Fix:** ...

### G-{n+1} ...

## Opportunities (enhancement reviewer only)

### O-{n} [{value}] {title}
...
```

Gap and opportunity numbers within each agent file use local numbering (G-1, G-2... per agent). The aggregation step renumbers them globally.

## Aggregation (full mode)

After all agents complete:

1. **Read per-agent files** from `docs/specs/_review_work/{spec_review_basename}/`. Parse each `{short_name}.md` to extract: letter grade, one-line assessment, and all findings. If `-s` was used, merge in carried grades annotated with `(carried from V{n-1} review — agent not re-run)`.

2. **Sort assessments worst-to-best** by grade (F, D, C, B, A, —). This puts problem areas at the top.

3. **Deduplicate gaps:** If two or more reviewers found the same issue (including test reviewer findings that overlap with other reviewers), merge into one finding and note which reviewers flagged it.

4. **Number all items sequentially.** Gaps are numbered G-1, G-2, G-3... Opportunities are numbered O-1, O-2, O-3... Numbers are stable references for discussion.

5. **Rank gaps** by severity (CRITICAL first, then HIGH, MEDIUM, LOW). Within same severity, prioritize findings flagged by multiple reviewers.

6. **Rank opportunities** by value (HIGH, MEDIUM, LOW).

7. **Write the report** to `docs/specs/[spec_basename]_review.md`. The spec filename already contains its version suffix, so the review filename inherits it naturally (e.g., reviewing `My_Spec_V2.md` produces `docs/specs/My_Spec_V2_review.md`). Use this structure:

```markdown
# Spec Review Findings: [spec filename]

**Location:** `docs/specs/[spec_basename]_review.md`
**Date:** [today]
**Reviewed file:** `docs/specs/[exact spec filename]`
**Spec version:** [from spec header]
**Command:** `/spec-review [exact command as invoked, including all flags]`
**Tier:** [Quick|Standard|Full] (Batches 1–[N])
**Depth:** [full | shallow (threshold: N, triggered after Batch M) | shallow (threshold: N, not triggered)]
{If --p1p2-only was active:} **Scope:** P1+P2 only
**Input:** full spec ({N} lines) | diff from V{n-1} ({changed} changed of {total} total lines)
**Reviewers — run:** [list agents that ran, distinguishing default vs. conditional]
**Reviewers — not in tier:** [list agents in batches beyond the selected tier, or "None"]
**Selective re-review:** [if -s was used: "-s {grade}, {N} agents carried from {previous review filename}"; otherwise "No — full review"]
[If auto-stop triggered:] **Auto-stop:** Yes — {count} C+H findings reached threshold ({N}) after Batch {M}; Batches {M+1}–{K} not executed

## Agent Assessments (sorted worst-to-best)

| Agent | Grade | Time | Assessment |
|-------|-------|------|------------|
| {worst agent} | {grade} | {Xm Ys} | {one-liner, ⚠ CRITICAL: prefix if applicable} |
| ... | ... | ... | ... |
| {best agent} | {grade} | {Xm Ys} | {one-liner} |
| Enhancement | — | {Xm Ys} | {one-liner about opportunities} |

**Review duration:** {total}m{seconds}s wall clock ({N} agents, {M} batches)

## Counts
- Gaps: X critical, Y high, Z medium, W low
- Opportunities: X high, Y medium, Z low

## Summary Table — Gaps

| # | Severity | Title | Description | Flagged by | Source | Disposition |
|---|----------|-------|-------------|------------|--------|-------------|
| G-1 | CRITICAL | [short title] | [one-line description] | Implementation, Integration | | |
| G-2 | CRITICAL | [short title] | [one-line description] | API Contract | | |
| ... | ... | ... | ... | ... | | |

## Summary Table — Opportunities

| # | Value | Title | Category | Description | Source | Disposition |
|---|-------|-------|----------|-------------|--------|-------------|
| O-1 | HIGH | [short title] | UX Enhancement | [one-line description] | | |
| O-2 | HIGH | [short title] | Performance | [one-line description] | | |
| ... | ... | ... | ... | ... | | |

The **Source** column is for traceability: if a finding originates from or relates to an external document, enter the document name and item reference. Leave blank for findings discovered solely by the spec review agents. The user fills this in after the review.

The **Disposition** column is filled in by the user after reviewing findings. Valid values:
- **Accept** — will be addressed in the spec or implementation
- **Defer** — valid finding, will address later (add target milestone if known)
- **Reject** — not applicable or disagree with finding (add brief reason)
- *(blank)* — not yet triaged

---

## Part 1: Gap Details

### G-1 [CRITICAL] Finding title
**Flagged by:** [which reviewer(s)]
**Location:** Section/line reference in the spec
**Issue:** What's missing or wrong
**Impact:** What goes wrong if this isn't fixed
**Fix:** Specific text to add or change

### G-2 [CRITICAL] Finding title
...

[... all gap findings ...]

---

## Part 2: Opportunity Details

### O-1 [HIGH] Opportunity title
**Category:** UX Enhancement | Performance | Complementary Capability | Operational | Future-proofing
**What's missing:** What the spec doesn't describe
**Why it matters:** Concrete scenario where a user, operator, or developer benefits
**Effort:** Trivial (1-5 lines in spec) | Small (5-20 lines) | Medium (would need its own section)
**Suggestion:** Specific text or design to add

### O-2 [HIGH] Opportunity title
...

[... all opportunity findings ...]
```

8. **Append the test coverage matrix** from the test reviewer as a final section of the report (after Part 2), preserving its requirement → test status mapping.

9. **Print the summary to the console.** Show the agent assessment table first (sorted worst-to-best), then the counts, then the full summary tables (both Gaps and Opportunities). After the tables, list just the titles of CRITICAL and HIGH gap items and HIGH-value opportunity items as a quick action list. Then print:
   ```
   Review completed in {total}m{seconds}s ({N} agents across {M} batches)
   ```

10. **Do NOT update `docs/specs/Spec_Tracker.md`** — the Spec Tracker is maintained exclusively by CD (Claude AI). CC writes the review findings file only.

11. **Verify aggregated report completeness.** Before cleanup, re-read the final `{spec_basename}_review.md` and confirm it contains an Agent Assessment table row for every expected agent — both re-run agents and carried agents. For each agent, verify the report contains either (a) a grade + assessment row in the Agent Assessments table, or (b) a carried-from annotation. If any expected agent is missing from the report, do NOT delete the work directory — print: `ERROR: Aggregated report missing results for: {list}. Work directory preserved at {path}.` and stop.

12. **Clean up work directory.** Only after step 11 passes: delete the work directory `rm -rf docs/specs/_review_work/{spec_review_basename}/`. If the `_review_work/` parent directory is now empty, delete it too.

---

# PATH B: Hybrid Review (multi-part mode)

*Used when mode = "hybrid" or "section". Requires a manifest file.*

## Hybrid Phase 1: Section Review (per-part)

*Skip entirely if `--skip-section` flag is set.*

### H1.1: Load Manifest

If argument is a `_manifest.json` file, read it directly. Otherwise, look for `{basename}_manifest.json` in the same directory as the spec file. If not found and mode was explicitly set to `hybrid` or `section`, abort: "Hybrid/section mode requires a manifest file. Generate one with scripts/generate_manifest.sh".

Parse manifest to get:
- `spec_name`, `version` → used for review filename
- `parts[]` → list of part files with numbers and titles
- `aggregate` → aggregate file path

### H1.2: Set Up Work Directory

**Hybrid work directory:** `docs/specs/_review_work/{spec_name}_{version}_review/`

This is the same naming as full mode (based on aggregate name), so hybrid and full reviews share the same work directory namespace.

Create subdirectories:
```
{work_dir}/
├── parts/          ← per-part agent findings
├── integration/    ← integration review outputs
└── _status.md      ← hybrid session state
```

### H1.3: Per-Part Section Review

For each part in `manifest.parts[]`:

1. **Resume check:** If `parts/_part{N}_review_complete.md` exists, print "✓ Part {N} already reviewed — skipping" and continue.

2. **Determine agents for this part:**
   - Read the part file
   - Run the same conditional agent trigger scan as full mode
   - Apply any `--with`/`--without` overrides
   - Use same default 9 + matched conditionals

3. **Print:** `Reviewing Part {N}/{total}: {title} ({lines} lines)...`

4. **Launch agents** (same execution sequence as full mode Steps 7.1–7.6) but:
   - Each agent output file goes to `parts/part{N}_{short_name}.md`
   - Agent receives the part file path (not aggregate)
   - `_status.md` tracks part-level batch state

5. **Aggregate part findings:**
   - Read all per-agent files for this part
   - Merge, deduplicate, renumber locally as `P{N}-G-1`, `P{N}-G-2`, etc.
   - Write merged findings to `parts/part{N}_findings.md`
   - Write checkpoint: `parts/_part{N}_review_complete.md` with timestamp and finding count

6. **Print:** `✓ Part {N} reviewed — {count} findings ({agent_count} agents)`

### H1.4: Section Review Summary

After all parts:
```
Section Review Complete
=======================
Parts reviewed: {total}
Total findings: {N} ({X} critical, {Y} high, {Z} medium, {W} low)
```

---

## Hybrid Phase 2: Integration Review (aggregate)

*Skip entirely if `--skip-integration` flag is set or mode = "section".*

**Purpose:** Catch issues that only appear when the full document is read as a whole — cross-references, terminology drift, duplicated content, and boundary problems.

### H2.1: Resume Check

If `integration/_integration_review_complete.md` exists, print "Integration review already complete — skipping Phase 2" and proceed to Phase 3.

### H2.2: Read Aggregate File

Read the full aggregate file specified in `manifest.aggregate`. If it doesn't exist, warn: "Aggregate file not found at {path}. Run scripts/assemble_spec.sh first. Skipping integration review."

### H2.3: Cross-Reference Check

Scan aggregate for internal section references:
- Patterns: `Section X.Y`, `§N`, `see §`, `(see Section`, `F\d+`, `DOC-\d+`
- For each reference, verify the target heading or label exists in the document
- Flag broken references as MEDIUM findings

Write output to `integration/xref_findings.md`:
```markdown
# Cross-Reference Check

## Summary: {N} broken references, {M} valid references checked

### XR-1 [MEDIUM] Broken reference: "Section 4.3"
**Location:** Line ~{approx_line}, Part {N} context
**Issue:** Reference to "Section 4.3" but no heading matching that pattern exists
**Fix:** Update reference or add missing section
```

### H2.4: Terminology Consistency Check

1. Extract defined terms: headings in bold (`**Term**`), items in definition-style lists, terms introduced with "is defined as", "refers to", "means"
2. For each defined term, scan full document for variant spellings, capitalizations, or synonyms used inconsistently
3. Flag inconsistencies as LOW findings (style) or MEDIUM (if meaning differs)

Write output to `integration/terminology_findings.md`.

### H2.5: Duplicate Content Detector

1. Extract all paragraph blocks (3+ sentences or 5+ lines)
2. Find near-duplicate blocks (>70% content similarity) across different sections
3. Flag as LOW if minor repetition, MEDIUM if substantial duplication that should be a reference

Write output to `integration/duplicate_findings.md`.

### H2.6: Part Boundary Check

1. Read manifest parts list; read aggregate; locate `<!-- BEGIN: {part_file} -->` and `<!-- END: {part_file} -->` markers
2. Verify: each part begins at a clean section boundary (heading line)
3. Verify: heading numbers are continuous across boundaries (no gaps, no resets)
4. Verify: no content appears between `<!-- END -->` and `<!-- BEGIN -->` markers

Write output to `integration/boundary_findings.md`.

### H2.7: Integration Review Checkpoint

Write `integration/_integration_review_complete.md` with timestamp and finding counts.

Print:
```
Integration Review Complete
===========================
Cross-references: {N} issues
Terminology: {N} issues
Duplicates: {N} issues
Boundaries: {N} issues
```

---

## Hybrid Phase 3: Consolidation

### H3.1: Collect All Findings

Read:
- `parts/part{N}_findings.md` for each part (section review findings)
- `integration/xref_findings.md`
- `integration/terminology_findings.md`
- `integration/duplicate_findings.md`
- `integration/boundary_findings.md`

### H3.2: Canonicalize References

Integration findings reference aggregate line numbers. Convert these to canonical part file references:
- Determine which part the line belongs to using manifest `lines` field (cumulative)
- Rewrite location as: `{part_file}` (approximate section) rather than aggregate line N

### H3.3: Deduplicate

- If the same issue appears in both a section review (from an agent) and an integration reviewer, merge into one finding, note both sources
- Keep highest severity among duplicates

### H3.4: Sort and Number

1. Sort all findings by: severity (CRITICAL → HIGH → MEDIUM → LOW) then part number
2. Assign global numbers: G-1, G-2, G-3…
3. Sort all opportunities by value (HIGH → MEDIUM → LOW)
4. Assign global numbers: O-1, O-2, O-3…

### H3.5: Write Consolidated Report

Write to `docs/specs/{spec_name}_{version}_review.md` using the same report structure as full mode, with these additions:

**Header additions:**
```
**Review mode:** Hybrid (section + integration)
**Parts reviewed:** {N} parts ({total_lines} total lines)
**Manifest:** {manifest_path}
```

**Findings reference canonical part files**, not the aggregate:
```
### G-1 [CRITICAL] Finding title
**Flagged by:** [which reviewer(s)]
**Location:** `{part_file}`, Section {X.Y}
...
```

**Post-fix workflow** (append at end of report):
```markdown
## Post-Fix Workflow

1. Apply fixes to canonical part files (listed in **Location** fields above)
2. Regenerate aggregate: `./scripts/assemble_spec.sh {manifest_path}`
3. Re-run integration review: `/spec-review --mode hybrid --skip-section {manifest_path}`
```

### H3.6: Completeness Verification

Same as full mode step 11: verify report contains results for all expected agents across all parts. If any part's agent results are missing, preserve work directory and report error.

### H3.7: Cleanup

Same as full mode step 12: clean up work directory only after completeness verification passes.

Print final summary to console showing part-by-part finding breakdown before the global summary tables.
