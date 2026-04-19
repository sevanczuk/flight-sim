# Spec Review Workflow

**Location:** `docs/specs/Spec_Review_Workflow.md`
**Maintained by:** CD (Claude AI, browser) — CC does not update this file.

Process documentation for the specification review lifecycle, including the parallel review pipeline (9 default + 3 conditional agents), agent scoring, pre-implementation readiness checks, and CD/CC role boundaries.

---

## 1. Purpose

The spec review workflow exists to catch design errors, missing edge cases, integration conflicts, and improvement opportunities *before* CC implements a spec. The goal is to make CC's implementation work correct-by-construction: CC follows specs literally and does not infer constraints, so every constraint, parameter, error case, and behavioral detail must be explicit in the spec.

Empirical observation across the first five-spec suite (~15 review rounds, ~500 total findings) confirmed that multi-pass reviews find different things per pass because analytical lenses cannot fully switch in a single forward pass. This insight drove the design of the parallel multi-agent architecture.

---

## 2. Lifecycle Overview

```
CD writes {Name}_V1.md                (first draft)
    ↓
CC runs /spec-review {Name}_V1.md     (auto-classifies → selects agents → runs in parallel)
    ↓
CC writes {Name}_V1_review.md         (aggregated findings + agent assessments)
    ↓
CD assesses findings                   (Accept / Defer / Reject each item)
    ↓
CD writes {Name}_V2.md                (incorporates accepted findings)
    ↓
CC runs /spec-review {Name}_V2.md     (repeat)
    ↓
CC writes {Name}_V2_review.md
    ↓
CD assesses → CD writes V3 → ...      (iterate until exit criteria met)
    ↓
Spec declared implementation-ready
    ↓
CD runs pre-implementation readiness check (soft)
    ↓
CD writes CC task prompt (from template)
    ↓
CC runs pre-flight verification (hard, built into prompt)
    ↓                         ↓ (if deviations found)
CC implements                 CC writes {name}_prompt_deviation.md → CD reviews
```

The version number in the filename tracks how many review cycles the spec has been through. V1 is always the first draft. A version bump means review findings have been incorporated.

### Typical cadence

Most specs reach implementation-ready in 2–3 review rounds. The first round catches structural issues (missing sections, wrong defaults, incomplete migrations). The second round catches precision issues (parameter types, boundary values, error response shapes). A third round is needed only when the second round's fixes introduced new material that itself needs review.

---

## 3. Roles and Boundaries

| Activity | Owner | Notes |
|----------|-------|-------|
| Write spec drafts (V1, V2, V3…) | CD | Incorporates review findings between versions |
| Run `/spec-review` command | CC | Produces review findings file only |
| Assess findings (Accept/Defer/Reject) | CD | Fills Disposition column in review file |
| Update Spec_Tracker.md | CD | CC never touches the tracker |
| Pre-implementation readiness check | CD (soft) + CC (hard) | See §9.2 |
| Write CC task prompts | CD | From template; after spec is implementation-ready |
| Implement spec | CC | Follows spec literally |
| File movement after compliance | CC | Mechanical task; CD retains judgment/analysis |

**Key constraint:** CC does not update `Spec_Tracker.md` or the issue indexes. CC writes exactly one artifact per review: the `{Name}_V{n}_review.md` findings file.

---

## 4. Parallel Review Architecture

### 4.1 Motivation

A single reviewer applying multiple analytical lenses sequentially produces diminishing returns as context accumulates — earlier findings bias the search for later ones, and attention drifts toward the first lens applied. Running independent reviewers in parallel eliminates this interference. Each agent starts with a clean context, applies a single focused lens, and produces findings that are later merged.

The agent roster is split into two tiers:

- **Default agents (9)** — run within their tier on every spec review, covering concerns that are universally relevant
- **Conditional agents (3)** — auto-selected based on spec content, covering concerns that are only relevant to certain spec types

Analysis of six PPF review rounds (V2–V7) showed that 5 agents account for all CRITICALs and ~75% of unique HIGH findings. This empirical data led to a three-tier execution model (Quick / Standard / Full) that allows focused, cost-effective reviews calibrated to the spec's current stage and risk profile. The default is Standard (8 agents, Batches 1–3). See `docs/specs/Spec_Review_Agent_Tier_Analysis.md` for the full analysis and batch assignments.

### 4.2 Default Agents

All agents are defined in `.claude/agents/`. Each has read-only access to the codebase (Read, Grep, Glob tools). Agents use tier-aware model assignments — see §4.11 Model Assignments.

#### spec-api-reviewer

**Focus:** API contract completeness — endpoint parameters, response shapes, error cases, pagination, boundary conditions.

For every endpoint or tool interface in the spec, this agent checks: parameter types/defaults/validation, JSON response structure, exhaustive failure modes with HTTP status codes, pagination at boundaries, idempotency, and consistency with existing endpoint conventions in `src/routes/`.

**Domain-specificity check:** Are error responses specific to the Conductor's domain (e.g., "file_uuid not found in index.db") rather than generic ("resource not found")? Do parameter names use project vocabulary consistently?

**Typical findings:** Missing error response for invalid parameter types, unspecified behavior for empty inputs, inconsistent parameter naming vs. existing endpoints.

#### spec-implementation-reviewer

**Focus:** Code path tracing — mentally executing every algorithm to find data structure ambiguities, performance issues, memory concerns, concurrency problems, and error propagation gaps.

Walks through each operation step by step asking: what's the input type, what's the output type, what if it's empty/None/wrong type? Checks for hidden O(n²) loops, unbounded memory allocations, race conditions, and silent exception swallowing.

**Domain-specificity check:** Does the spec reuse existing project utilities (`metadata_index.py`, `search_utils.py`, shared fixtures) rather than describing parallel implementations? Are data structures described in terms of the project's existing patterns?

**Typical findings:** Spec says "cache" without specifying the data structure CC should build, O(n²) nested loop hidden in "for each file, check all existing files", missing error handling when a sub-operation fails mid-batch.

#### spec-integration-reviewer

**Focus:** Cross-system consistency — how the new feature interacts with the existing codebase, startup sequence, schema migrations, configuration, and existing UI state.

Reads `CLAUDE.md`, `config/app_config.yaml`, `src/serve_db.py` startup code, and existing route files to check for: naming conflicts, migration ordering issues, startup failures when dependencies are missing, graceful degradation when the feature fails at runtime, and test suite breakage from new heavy dependencies.

**Domain-specificity check:** Does the new feature integrate with the Conductor's existing infrastructure (SSE event bus, preview cache, metadata indexer, tool registry) or does it create parallel mechanisms? Do migration and startup patterns match the established chain in `system.py`?

**Typical findings:** New migration depends on a column added by a prior migration but doesn't verify ordering, new config section uses different naming convention than existing sections, feature failure at runtime cascades to unrelated endpoints.

#### spec-enhancement-reviewer

**Focus:** Missing capabilities and improvement opportunities — things the spec doesn't attempt to cover but should, examined from user, operator, and system perspectives.

Unlike the other agents (which find errors in what's written), this agent identifies what's *not written*. Checks for: UX friction points, performance optimizations (>2x impact only), natural companion capabilities, operational diagnostics, and trivial-now/painful-later design decisions.

**Domain-specificity check:** Are suggested enhancements grounded in the Conductor's actual workflow (photo pipeline, print preparation, enrichment tools) rather than generic application patterns? Do opportunities reference the real user profiles (Steve, Susan, Guest) and their actual tasks?

**Filtering criteria:** Only reports opportunities with material impact, reasonable scope (1–20 spec lines), and non-obvious value. Does not suggest generic best practices.

**Typical findings:** Search results don't explain *why* something matched, no way to check feature health after deployment, missing "find similar" capability that would pair naturally with the search feature.

#### spec-test-reviewer

**Focus:** Test coverage mapping — for every specified behavior, identifies which test covers it and which tests are missing. Also checks mock fidelity (do mocks accurately represent production behavior?).

Maps spec requirements to existing test files, then checks for: untested endpoints, edge cases without coverage, mocks that create synthetic structures masking real bugs, `pytest.importorskip` hiding entire test categories, and integration test gaps where only unit tests exist.

**Typical findings:** Endpoint has tests for success path but no test for the 404 case, mock creates an in-memory table that doesn't match production schema, no integration test exercises the full API→backend→DB→response path.

#### spec-complexity-reviewer

**Focus:** Accidental complexity — finding places where the spec introduces unnecessary new mechanisms when existing ones suffice, or where configuration could be eliminated by choosing a sensible default.

This agent asks: does this spec *need* a new table, or could it be a column on an existing table? Does this need a new endpoint, or could an existing one be extended? Is this three-state enum actually two states with a computed third? Could this multi-step process be collapsed? Does this introduce a new concept when an existing concept already covers the need?

**Scope constraint:** Targets *accidental* complexity (complexity that doesn't serve the domain), not *essential* complexity (complexity inherent in the problem). Multi-user support, per-tool enrichment tracking, and derivative chain management are genuinely complex domains — this agent does not challenge their existence. It challenges unnecessary *additions* to them.

**Typical findings:** New config option that could be a sensible default instead, new table that duplicates information already queryable from an existing table with a JOIN, abstraction layer that adds indirection without enabling any actual flexibility, three-endpoint design that could be one endpoint with a mode parameter.

#### spec-security-data-integrity-reviewer

**Focus:** Enforcing the project's core data safety invariants — source file immutability, copy-on-write for irreversible operations, reversible-by-default, multi-user data isolation, and audit trail completeness.

For every operation in the spec, this agent checks: can this leave orphaned database records? Can this expose one user's data to another (SXE vs SJM vs Guest)? Does this migration preserve existing data or risk silent loss? Can this batch operation fail partway and leave the database in an inconsistent state? Does this respect the XMP sidecar-only metadata write rule? Is the audit trail complete enough to reconstruct what happened?

**Reference invariants:** The agent checks against the safety rules in CLAUDE.md §CC Safety Discipline, the reversibility table, and the multi-user schema requirements (MU-1 through MU-50).

**Typical findings:** Endpoint modifies a file in `Photos\` directly instead of writing an XMP sidecar, batch operation has no rollback path if step 3 of 5 fails, new query doesn't filter by `creator_code` so one user can see another's private data, migration drops a column without preserving its data in the audit record.

#### spec-editorial-convention-reviewer

**Focus:** Dual-lens review combining convention compliance (naming patterns, response shapes, config structure, test fixtures, migration patterns) with language precision (terminology consistency, ambiguity, cross-references, procedural clarity).

**Convention compliance lens:** Reads the existing codebase (routes, config, tests, migrations) and checks whether the spec's proposed additions match: endpoint response shape conventions, parameter naming patterns, config section naming in `app_config.yaml`, test fixture patterns and helper usage, migration structure in `src/routes/system.py`, and error response formatting.

**Language precision lens:** Reads the spec as a document and asks: are terms used consistently throughout (same concept, same name)? Are cross-references to other specs/docs present where needed? Are procedural instructions unambiguous (which fields, in what order, with what defaults)? Would CC be able to implement each behavioral requirement from the spec text alone without guessing?

**Domain-specificity check:** Does the spec use project-specific terminology consistently, or does it drift into generic CRUD vocabulary? Does user-facing content reference actual hardware (Canon PRO-4600, LUCIA PRO II inks, specific paper profiles) and workflow (Fuji X-T5 RAFs, XMP sidecars, Qimage layouts) rather than generic terms?

**Typical findings:** Spec uses `paper_id` but existing code uses `profile_id` for the same concept; new endpoint returns `{results: [...]}` but existing endpoints return `{items: [...]}`, same concept called "paper profile" in §3 and "media configuration" in §7; step says "update the record" without specifying which fields or what values.

#### spec-assistant-parity-reviewer

**Focus:** Dual-path execution parity (Principle 7) — verifying that every UI action described in the spec has a corresponding Print Assistant tool equivalent, and vice versa.

For every button, form submission, state change, or workflow action in the spec, this agent checks: is there a matching assistant tool definition? Do the tool parameters align with the API parameters? Are SSE events specified for both UI-triggered and assistant-triggered paths? Does the assistant tool produce the same backend state change as the UI action? Are there assistant-only actions that lack a UI equivalent?

**Reference:** Checks against `src/assistant_tools.py` for existing tool patterns and the assistant parity spec for the dual-path contract.

**Typical findings:** Spec adds a "Cancel Project" button but no corresponding `cancel_project` assistant tool, assistant tool parameters use different names than the API endpoint parameters, SSE event specified for UI path but not for assistant-triggered path, new scope-selection action is client-side only with no assistant equivalent.

### 4.3 Conditional Agents

Conditional agents are auto-selected based on spec content analysis (see §5.2 for the invocation mechanism). They cover concerns that are relevant only to certain types of specs.

#### spec-ux-reviewer

**Trigger:** Spec contains UI sections — screen descriptions, wireframes, user interaction flows, JSX component references, or references to `src/screens/`.

**Focus:** Workflow-level user experience — tracing user journeys through the spec's proposed UI to find friction, confusion, and interaction design issues.

This agent thinks from the perspective of both user profiles (Steve = technical/low-initiative, Susan = higher-initiative/concise-deferential) and asks: will the user understand what just happened after this action? Is this three clicks when it should be one? Is status feedback present and interpretable? Are common actions prominent and rare actions accessible but not in the way? Are interaction patterns consistent across screens? Does the empty state guide the user or leave them stranded?

**Domain-specificity check:** Do UI patterns reflect the Conductor's specific workflow (photo pipeline, not generic CRUD)? Are UI labels, status messages, and guidance written for photographers, not developers?

**Typical findings:** Confirmation dialog interrupts a flow that should be low-friction, action completes silently with no visible feedback, common operation buried two levels deep in a menu, inconsistent interaction pattern (drag-to-reorder in one screen, up/down arrows in another), empty state shows a blank area instead of guidance.

#### spec-error-recovery-reviewer

**Trigger:** Spec describes multi-step workflows (3+ sequential steps), batch operations, physical output (print), or operations referencing `pending_operations` or `tool_runs`.

**Focus:** Failure scenarios and recovery paths — what happens when things go wrong partway through, and whether the user can recover without losing work or wasting resources.

For every multi-step operation in the spec, this agent asks: what happens when step N of M fails? Can the user resume from step N without re-running steps 1 through N-1? Is partial completion detectable (can the system tell you "3 of 5 succeeded")? Are error messages actionable (does the user know what to do next)? For print operations specifically: what safeguards prevent ink and paper waste from failed or incorrect prints?

**Typical findings:** Batch import has no resume capability — failure at file 47 of 200 requires restarting from file 1, error message says "operation failed" without identifying which file or why, print operation has no pre-flight check for sufficient ink, multi-step workflow stores intermediate state only in memory so a server restart loses progress.

#### spec-performance-query-reviewer

**Trigger:** Spec contains SQL code blocks, references to `index.db` or `metadata_index`, search operations, pagination patterns (`LIMIT`/`OFFSET`), or batch operations mentioning file counts over 100.

**Focus:** Database query efficiency, indexing requirements, and scalability concerns for the 32K+ image library.

For every query or data access pattern in the spec, this agent checks: does this query need an index that doesn't exist? Will this pagination strategy degrade at 100K images? Does this batch operation hold a transaction lock too long? Is this doing N+1 queries inside a loop? Are there opportunities for query batching or precomputation? For search operations: does the query plan use the expected index, or will it fall back to a full table scan?

**Typical findings:** Query joins three tables without an index on the join column — O(n²) at scale, pagination uses OFFSET which degrades linearly with page depth, batch operation executes one INSERT per file instead of a bulk INSERT, search query doesn't use the SigLIP embedding index and falls back to brute-force comparison.

### 4.4 Finding Classification

All agents (default and conditional) use the same severity scale for gaps:

| Severity | Meaning |
|----------|---------|
| **CRITICAL** | CC will implement incorrectly, runtime crash, or data corruption is guaranteed |
| **HIGH** | Significant degradation to functionality, UX, or performance |
| **MEDIUM** | Edge case that should be handled but won't break the core flow |
| **LOW** | Improvement that can be deferred |

The enhancement reviewer uses a separate value scale for opportunities:

| Value | Meaning |
|-------|---------|
| **HIGH** | Most users would notice and benefit; significantly improves the feature |
| **MEDIUM** | Improves experience for power users or specific workflows |
| **LOW** | Nice-to-have polish or future convenience |

### 4.5 Severity Calibration Guide

To maintain consistency across 15 agents, all agents reference these calibration examples when assigning severity:

**CRITICAL examples:**
- Migration DDL missing a column that the spec's API code reads from → runtime crash on first request
- Endpoint writes directly to a source file instead of an XMP sidecar → violates core safety invariant
- Schema version not bumped → migration won't execute, all new features silently missing

**HIGH examples:**
- Error response returns 500 instead of 404 for a not-found case → degraded UX, misleading diagnostics
- N+1 query inside a loop over all photos → works but unacceptably slow at library scale
- SSE event missing for assistant-triggered path → UI doesn't update when assistant executes an action

**MEDIUM examples:**
- Pagination doesn't handle offset > total gracefully → edge case, returns empty rather than error
- Config option lacks a documented default → CC will pick something, may not be optimal
- Test covers success path but not the empty-input edge case → low-probability regression risk

**LOW examples:**
- Parameter could have a shorter, more idiomatic name → cosmetic
- Test assertion checks status code but not response body shape → weaker verification
- Documentation section could cross-reference a related spec → convenience

### 4.6 Agent Assessment Grades

In addition to individual findings, each agent produces a **letter grade** (A/B/C/D/F) and a **one-line summary assessment** of how well the spec satisfies that agent's concerns. The one-liner must explicitly flag any CRITICAL findings.

Grade meanings:

| Grade | Meaning |
|-------|---------|
| **A** | Spec fully addresses this agent's concerns; at most minor LOW findings |
| **B** | Solid coverage with a few MEDIUM gaps; no CRITICAL or HIGH |
| **C** | Notable gaps; one or more HIGH findings or multiple MEDIUM findings |
| **D** | Significant problems; one or more CRITICAL findings or many HIGH findings |
| **F** | Fundamental issues; spec cannot be implemented safely without major revision |

The review report header includes an **Agent Assessment Table** sorted worst-to-best by grade, so CD immediately sees the problem areas first:

```
Agent Assessments (sorted worst-to-best):
  Error Recovery:      D  — ⚠ CRITICAL: no resume path for batch failure
  Complexity:          C  — Two unnecessary new tables; could reuse existing
  Integration:         C  — ⚠ CRITICAL: migration ordering conflict with v3.13
  API Contract:        B  — 3 missing error responses; no CRITICAL issues
  UX Engineer:         B  — Empty state guidance missing on 2 screens
  Assistant Parity:    B  — 2 UI actions missing tool equivalents
  Implementation:      A  — All code paths traceable; clean data structures
  Security:            A  — All safety invariants upheld
  Consistency:         A  — Follows existing conventions throughout
  Test Coverage:       A  — Good requirement-to-test mapping
  Enhancement:         —  — 4 opportunities identified (see Part 2)
```

The enhancement reviewer gets a dash instead of a letter grade because it reports opportunities, not gaps — grading it would penalize ambitious specs for having room to grow.

### 4.7 Tier Model

The three-tier execution model controls which agents are eligible to run, allowing reviews to be calibrated to the spec's stage and the available token budget. Select with `--tier quick|standard|full` (default: `standard`).

#### Agent batch assignments

Agents are organized into 4 ordered batches. The tier determines how far down the sequence execution proceeds. Within each batch, all applicable agents run in parallel.

| Batch | Agents | Tier coverage |
|-------|--------|--------------|
| 1 | Implementation, Test Coverage, Integration | Quick, Standard, Full |
| 2 | API Contract, Assistant Parity | Quick, Standard, Full |
| 3 | Security/Data Integrity, Error Recovery, Enhancement | Standard, Full |
| 4 | Editorial/Convention, UX, Performance, Complexity | Full only |

#### Tier definitions

- **Quick** (Batches 1–2, 5 agents): Structural correctness — will the code compile and run? Use for rapid iteration on early drafts.
- **Standard** (Batches 1–3, 8 agents): Quick + safety and domain fidelity — is it correct for this system? *(Default — saves ~33% tokens vs. Full while retaining the highest-value agents.)*
- **Full** (Batches 1–4, 12 agents): Standard + quality and polish — is it excellent? Use when excellence matters or for final pre-implementation checks.

#### Tier interaction with other flags

- **Conditional agents** are only eligible within their tier. An agent must be both (a) in the selected tier's batches AND (b) triggered by spec content (or forced via `--with`).
- **`--with`** can force any agent ON regardless of tier — e.g., `--tier quick --with perf` runs the 5 Quick agents plus Performance.
- **`--all`** is equivalent to `--tier full` (takes precedence if both specified).
- **`-s`** composes with `--tier`: an agent must pass both the tier filter and the `-s` grade filter to run.

### 4.8 Review Priority Guide

Specs may include a Review Priority Guide table that tells agents which sections to review first. This is a table near the top of the spec with columns: Priority (P1/P2/P3), Section, Title, Dependencies, and Rationale.

When present:
- Agents review P1 sections first, then P2, then P3
- Dependency sections are read before the section that depends on them
- `--p1p2-only` skips P3 sections entirely

When absent: agents review in document order. `--p1p2-only` is a no-op with a warning.

**Priority levels:**
- **P1** — Correctness-critical. Errors here block implementation or cause runtime failures.
- **P2** — Functionality-critical. Errors here degrade behavior, safety, or UX significantly.
- **P3** — Quality/polish. Errors here are cosmetic or deferrable.

See `docs/specs/Spec_Review_Tiered_Execution_Spec_V1.md` §6 for the full table format and examples.

### 4.9 Phase 0 — CD Rapid Cycles (Recommended Practice)

Before launching the agent pipeline, CD (Claude AI, browser) can perform one or more rapid review cycles. Each cycle is a single read of the spec (using the Review Priority Guide if present, starting with P1 items) that identifies the top 5–10 structural issues — the overlapping CRITICALs that multiple agents would independently discover.

**Rationale:** In early PPF review rounds (V2–V4), nearly every agent found the same CRITICALs (wrong table names, missing schema columns). A single CD pass catches these overlapping issues at a fraction of the cost. The agent pipeline then catches domain-specific issues that require specialized lenses.

**When to use:**
- Always recommended for V1 specs (highest density of structural issues)
- Optional for V2+ specs where the prior review had few CRITICALs
- Especially valuable for large specs where agent review is expensive

This is not a formal command — it is a recommended practice performed by CD before invoking `/spec-review`.

### 4.10 Diff-Based Review Input

For specs exceeding 1,000 lines (configurable via `DIFF_THRESHOLD_LINES` in `.claude/commands/spec-review.md`) that have a prior review, agents receive a diff package containing only changed/new sections plus an inventory of unchanged sections. This reduces token consumption by 50–70% on iterative reviews of large specs.

**Trigger conditions (all must be met):**
1. Spec exceeds the diff threshold (default: 1,000 lines)
2. Prior review file exists (`{Name}_V{n-1}_review.md` in `docs/specs/`)
3. `--no-diff` flag is not set
4. Review mode is `full` (not `hybrid` — hybrid already has section-level granularity via per-part review)

**Diff package contents:** Changed sections (full text ±5 lines context), new sections, removed section headers, unchanged section inventory (one-line entry per section), and the prior review's Agent Assessment Table and Counts.

Agents can read the full spec via their Read tool if they need unchanged section context.

Use `--no-diff` to force full-spec review when structural revisions make diffs unreliable, or when a fresh-eyes review of the entire spec is desired.

### 4.11 Model Assignments

Agents use tier-aware model assignments to balance review quality against API rate limits. Judgment-heavy agents (those that reason about hypothetical scenarios, trace code paths, or evaluate safety invariants) use Opus. Pattern-matching agents (those that check conventions, map requirements to tests, or identify structural redundancy) use Sonnet.

| Model | Agents | Rationale |
|-------|--------|-----------|
| **Opus** | API Contract, Implementation, Security/Data Integrity, Error Recovery | High-reasoning: failure scenario simulation, code path tracing, edge case detection, safety invariant enforcement |
| **Sonnet** | Editorial/Convention, Enhancement, Complexity, Test Coverage, UX, Performance/Query, Integration, Assistant Parity | Pattern-matching: convention compliance, requirement mapping, redundancy spotting, checklist-style verification |

Model is declared in each agent's frontmatter (`model: opus` or `model: sonnet`). The spec-review command reads this field and dispatches accordingly.

**Rationale:** Running 3–4 concurrent Opus agents per batch can trigger API rate limits, especially when other CC sessions are active. Moving 8 of 12 agents to Sonnet halves the Opus load per batch while retaining Opus quality where it matters most — the 4 agents that historically produce all CRITICALs and ~75% of HIGH findings.

### 4.12 Sequential Execution Mode

The `--sequential` flag runs agents within each batch one at a time instead of in parallel. This eliminates burst API load at the cost of 2–3× longer review time.

```
/spec-review --sequential docs/specs/{Name}_V{n}.md
```

**When to use:**
- API rate limit errors during reviews (the immediate trigger for this feature)
- Running spec-review concurrently with other CC sessions
- Large specs where each agent consumes significant tokens

**Behavior:** Batches still execute in order (1 → 2 → 3 → 4). The `--depth shallow` between-batch check still applies. Within each batch, agents run sequentially in the order listed in the batch table (§4.7). All other flags compose normally with `--sequential`.

---

## 5. The `/spec-review` Command

Defined in `.claude/commands/spec-review.md`. Invoked in CC as:

```
/spec-review docs/specs/{Name}_V{n}.md
/spec-review docs/specs/{Name}_V{n}.md --tier quick
/spec-review docs/specs/{Name}_V{n}.md --tier full -s C
/spec-review docs/specs/{Name}_V{n}.md --depth shallow 5
/spec-review docs/specs/{Name}_V{n}.md --p1p2-only
/spec-review docs/specs/{Name}_V{n}.md --with ux,error-recovery
/spec-review docs/specs/{Name}_V{n}.md -s C --with editorial
/spec-review docs/specs/{Name}_V{n}_manifest.json --mode hybrid
```

**Agent quick reference for `--with` / `--without`:**

| Short name | Agent | Role |
|---|---|---|
| `ux` | UX Engineer | User journey friction, interaction design, empty states |
| `editorial` | Editorial/Convention | Convention compliance + language precision (default agent; force with `--with editorial` to run outside Full tier) |
| `error-recovery` | Error Recovery | Failure scenarios, resume paths, partial-completion handling |
| `perf` | Performance/Query | SQL efficiency, indexing, pagination, transaction lock duration |

Default agents (always run unless filtered by `-s`) do not need short names for `--with`/`--without`:

| Agent | Role |
|---|---|
| API Contract | Endpoint parameters, response shapes, error cases, pagination |
| Implementation | Code path tracing, data structures, concurrency, error propagation |
| Integration | Cross-system consistency, migrations, startup, degradation |
| Enhancement | Missing capabilities, improvement opportunities (always runs, no grade) |
| Test Coverage | Requirement-to-test mapping, mock fidelity, edge case gaps |
| Complexity | Accidental complexity, unnecessary mechanisms, simplification |
| Security/Data Integrity | Source immutability, data isolation, audit trail, rollback safety |
| Editorial/Convention | Convention compliance + language precision (dual-lens merged agent) |
| Assistant Parity | Dual-path execution, tool/UI equivalence, SSE event coverage |

### 5.1 Flag Reference

All flags accepted by `/spec-review`. The **Authoritative source** is `.claude/commands/spec-review.md`; this table is a summary for quick reference.

| Flag | Parameters | Default | Description |
|------|-----------|---------|-------------|
| `--tier` | `quick`, `standard`, `full` | `standard` | Selects the agent tier. Quick = Batches 1–2 (5 agents). Standard = Batches 1–3 (8 agents). Full = Batches 1–4 (12 agents). |
| `--depth` | `shallow [N]` | `full` (no limit) | Auto-stop after N cumulative CRITICAL + HIGH findings, checked between batches. Default N=3 if no number given. Agents within a batch always complete before the check. |
| `--p1p2-only` | *(none)* | Off | Limits agent analysis to P1 and P2 sections in the spec's Review Priority Guide table. P3 sections skipped entirely. No-op with warning if spec has no Review Priority Guide. |
| `--no-diff` | *(none)* | Off | Forces full-spec review even when diff-based input would normally apply (specs >1,000 lines with a prior review). Use when structural revisions make diffs unreliable. |
| `-s` | `{grade}` (A, B, C, D, F) | Off (all agents run) | Selective re-review: re-run agents that scored `{grade}` or worse in the previous review; skip agents that scored better. Enhancement reviewer always runs (no grade). |
| `--prev` | `{path}` | Auto-inferred | Explicit path to the previous review file. Used with `-s` when the naming convention doesn't apply. |
| `--with` | `{agents}` (comma-separated short names) | *(none)* | Force specific agents ON regardless of tier, trigger matching, or `-s` filtering. Can force agents from outside the selected tier. |
| `--without` | `{agents}` (comma-separated short names) | *(none)* | Force specific agents OFF regardless of trigger matching. |
| `--all` | *(none)* | Off | Run all 12 agents. Equivalent to `--tier full`. Takes precedence if both `--all` and `--tier` are specified. |
| `--mode` | `section`, `full`, `hybrid`, `auto` | `auto` | Review mode. `auto` selects based on file type and line count (see Mode Detection below). |
| `--manifest` | `{path}` | Auto-inferred | Explicit path to a manifest JSON file for hybrid mode. |
| `--skip-integration` | *(none)* | Off | In hybrid mode only: skip Phase 2 (integration review on aggregate). |
| `--skip-section` | *(none)* | Off | In hybrid mode only: skip Phase 1 (per-part section review). |

#### Flag combinability

Most flags compose freely. The table below shows notable interactions and restrictions.

| Combination | Behavior |
|-------------|----------|
| `--tier` + `-s` | Both filters apply: an agent must be in the tier's batches AND pass the grade threshold to run. |
| `--tier` + `--with` | `--with` can force agents from outside the selected tier. E.g., `--tier quick --with perf` runs the 5 Quick agents plus Performance. |
| `--tier` + `--all` | `--all` wins (equivalent to `--tier full`). |
| `--depth shallow` + `--tier` | Depth check occurs between batches. A smaller tier means fewer batches, so fewer check points. |
| `--depth shallow` + `-s` | Both apply independently. Depth limits total findings; `-s` limits which agents run. |
| `--p1p2-only` + `--depth shallow` | Agents review only P1/P2 sections; pipeline stops at N cumulative C+H. Maximum focus. |
| `--p1p2-only` (no Priority Guide in spec) | No-op with warning. All sections reviewed. |
| `--no-diff` + spec < 1,000 lines | No-op. Diff-based input only applies above the threshold. |
| `--no-diff` + `--mode hybrid` | No-op. Diff-based input only applies in `full` mode; hybrid has its own section-level granularity. |
| `--mode hybrid` + `--skip-integration` | Runs per-part section review (Phase 1) only, skips integration review (Phase 2). |
| `--mode hybrid` + `--skip-section` | Runs integration review (Phase 2) only, skips per-part review (Phase 1). |
| `--skip-integration` or `--skip-section` outside hybrid mode | Ignored (these flags are hybrid-only). |
| `-s` + `--with` | `-s` filters by grade, then `--with` forces listed agents back ON regardless of grade. E.g., `-s C --with editorial` re-runs all C-or-worse agents plus Editorial/Convention. |
| `--with` + `--without` (same agent) | `--without` takes precedence. |

#### Mode detection (when `--mode` is `auto` or not specified)

```
IF --mode is specified → use it
ELSE IF argument ends in _manifest.json → hybrid
ELSE IF {basename}_manifest.json exists in same directory → hybrid (load manifest)
ELSE IF spec > 2,000 lines → hybrid (warn: "No manifest found — falling back to full review")
ELSE IF spec > 1,000 lines → full (warn: "Large spec — consider splitting with a manifest")
ELSE → full
```

### 5.2 Invocation Examples

The command supports flexible invocation. CC auto-classifies conditional agents within the selected tier; CD can override with flags.

| Syntax | Behavior |
|--------|----------|
| `/spec-review {path}` | Standard tier (Batches 1–3, 8 agents), auto-classify conditionals, full depth |
| `/spec-review {path} --tier quick` | Quick tier (Batches 1–2, 5 agents) |
| `/spec-review {path} --tier standard` | Standard tier explicitly (same as default) |
| `/spec-review {path} --tier full` | Full tier (Batches 1–4, 12 agents) — old default behavior |
| `/spec-review {path} --with {agents}` | Force conditional agents ON; can force agents from outside the selected tier |
| `/spec-review {path} --without {agents}` | Force conditional agents OFF |
| `/spec-review {path} --all` | All 12 agents; equivalent to `--tier full` |
| `/spec-review {path} --depth shallow [N]` | Auto-stop between batches at N cumulative C+H findings (default N=3) |
| `/spec-review {path} --p1p2-only` | Review only P1 and P2 sections; skip P3 |
| `/spec-review {path} --no-diff` | Force full-spec review even when diff-based input would apply |
| `/spec-review {path} -s {grade}` | Selective re-review: re-run agents at or worse than grade; composes with `--tier` |
| `/spec-review {path} -s {grade} --prev {review_path}` | Selective re-review with explicit previous review path |
| `/spec-review {path} --mode hybrid` | Force hybrid mode (requires manifest) |
| `/spec-review {manifest_path}` | Hybrid mode (auto-detected from manifest filename) |
| `/spec-review {path} --manifest {manifest_path}` | Full-mode path with explicit manifest for hybrid |
| `/spec-review {manifest_path} --skip-integration` | Hybrid: per-part review only, skip integration phase |
| `/spec-review {manifest_path} --skip-section` | Hybrid: integration review only, skip per-part phase |

**Combined examples:**
```
/spec-review docs/specs/Foo_V1.md --tier quick                    # Fast structural check
/spec-review docs/specs/Foo_V2.md --tier full -s C                # Full roster, re-run C-or-worse only
/spec-review docs/specs/Foo_V1.md --depth shallow 5               # Stop after 5 C+H findings
/spec-review docs/specs/Foo_V1.md --tier quick --with perf        # Quick + Performance agent
/spec-review docs/specs/Foo_V2.md -s C --with editorial           # Grade filter + force editorial
/spec-review docs/specs/Foo_V1.md --p1p2-only --depth shallow 3   # Maximum focus: P1/P2 only, stop at 3
/spec-review docs/specs/Foo_V2.md --no-diff -s B                  # Force fresh review despite diff availability
/spec-review docs/specs/Foo_V1_manifest.json                      # Hybrid mode (auto-detected)
/spec-review docs/specs/Foo_V1_manifest.json --skip-integration   # Hybrid: section review only
```

Note: The default is `--tier standard`. Users who want the old all-agents behavior should use `--tier full`.

Short names for `--with`/`--without`: `ux`, `editorial`, `error-recovery`, `perf`, plus any future additions. Default agents always run in their tier unless filtered by `-s`.

### 5.3 Agent Selection Sequence

When the command is invoked, it executes this sequence before launching any subagents:

```
1. Read the spec file; detect Review Priority Guide table if present
1b. Diff-based input detection (if spec > 1,000 lines, prior review exists, --no-diff not set, mode is full)
2. If -s flag present: read previous review file, extract agent grades
3. Scan for trigger patterns (keyword/section-header matching — not LLM reasoning)
4. Apply -s grade filter (if any) — re-run agents at or worse than threshold; skip better
5. Apply --with/--without overrides (if any)
6. Print agent selection report to console (with batch structure)
7. Launch agents in batch sequence with per-agent file persistence and adaptive back-off (see §5.8)
```

**Steps 2–4 — Previous review, trigger matching, and grade filtering:**

When `-s` is used, CC first reads the previous review file (Step 2). The path is inferred by naming convention: reviewing `{Name}_V2.md` looks for `{Name}_V1_review.md` in the same directory. If the inferred file doesn't exist, CC warns and falls back to running all agents. The `--prev` flag provides an explicit path when the convention doesn't apply.

Step 3 scans the spec for conditional agent triggers (see table below). Step 4 applies the `-s` grade filter: CC reads the agent assessment table from the previous review and determines which agents to re-run based on their grade. The rule is: **re-run agents that scored the threshold grade or worse; skip agents that scored better.** Grade ordering from best to worst: A, B, C, D, F. Concretely:

- `-s C` — re-runs agents that scored C, D, or F; skips A and B
- `-s B` — re-runs agents that scored B, C, D, or F; skips A only
- `-s D` — re-runs agents that scored D or F; skips A, B, and C

Agents without a grade in the previous review (newly added, or the enhancement reviewer which gets `—`) always run regardless of the `-s` threshold.

**Trigger pattern matching (Step 3):**

| Conditional Agent | Trigger Patterns |
|-------------------|-----------------|
| UX Engineer | Section headers matching `UI`, `Screen`, `Wireframe`, `Component`, `User Flow`, `Interaction`; references to `.jsx` files or `src/screens/` |
| Error Recovery | Keywords `batch`, `multi-step`, `pipeline`, `print`, `physical output`; sections describing sequential operations with 3+ steps; references to `pending_operations` or `tool_runs` |
| Performance/Query | SQL code blocks; references to `index.db`, `metadata_index`, `search`, `pagination`, `LIMIT`, `OFFSET`; batch operations mentioning file counts > 100 |

Trigger matching is intentionally simple (string/pattern matching on the spec text). It does not require LLM reasoning, keeping the classification step fast and deterministic.

**Step 6 — Agent selection report (batched format):**

The command prints a report before launching, showing tier, depth, scope metadata and per-batch breakdown:

```
Spec review: docs/specs/Print_Pipeline_Frontend_Spec_V8.md
Tier: standard (Batches 1–3)
Depth: shallow (threshold: 3)
Scope: P1+P2 only
Previous review: docs/specs/Print_Pipeline_Frontend_Spec_V7_review.md
Selective re-review: -s C

Batch 1: Implementation, Test Coverage, Integration
  ▶ Implementation (C) — re-running
  ▶ Test Coverage (D) — re-running
  ⏭ Integration (A) — carried from V7
Batch 2: API Contract, Assistant Parity
  ▶ API Contract (C) — re-running
  ▶ Assistant Parity (C-) — re-running
Batch 3: Security, Error Recovery, Enhancement
  ▶ Security — running
  ✗ Error Recovery — no triggers matched
  ▶ Enhancement — always runs

Launching Batch 1 (2 agents)...
```

Legend: `▶` = running this batch, `⏭` = carried from previous review (skipped by `-s`), `✗` = filtered out (no triggers, `--without`, or `-s` threshold passed). Batches beyond the selected tier are not shown. Agents with existing work-directory files are skipped (resume mode).

Without `-s`, the report omits the previous-review and selective lines and shows all agents as running. Without `--depth shallow` or `--p1p2-only`, those lines are omitted. The report adapts to the selected tier and active flags but always shows the batch structure.

### 5.4 Selective Re-review (`-s` flag)

On review rounds after the first, the `-s` flag enables grade-based agent filtering to focus review effort where it's needed.

**Semantics:** `-s {grade}` means "re-run agents that scored `{grade}` or worse; skip agents that scored better." An agent scoring exactly at the threshold grade is re-run, not skipped.

**When NOT to use `-s`:** When the revision was structural — rewriting whole sections, adding major new capabilities, or reorganizing the spec. Structural changes can introduce issues in areas that previously scored well. Use the bare command (all agents) for structural revisions.

### 5.5 Aggregation

After all agents complete (or auto-stop triggers):

1. **Read** per-agent files from the work directory.
2. **Merge** in carried grades (if `-s` was used) annotated with "(carried from V{n-1} review — agent not re-run)".
3. **Deduplicate** across agents — if two reviewers found the same issue, merge into one finding noting both.
4. **Rank:** Gaps sorted by severity (CRITICAL first), with multi-reviewer findings ranked higher within the same severity. Opportunities sorted by value (HIGH first).

### 5.6 Output

The command writes a single file: `docs/specs/{Name}_V{n}_review.md`

The report contains:

- **Header:** Location (review file path), date, spec filename, spec version; plus the exact command invoked (`Command:` field), tier selection (Quick/Standard/Full, batch range), depth setting, scope, input mode, agents run vs. not-in-tier, selective re-review annotation, and auto-stop status if triggered. Fields that don't apply are omitted.
- **Agent Assessment Table:** Letter grades + one-liners sorted worst-to-best (see §4.6)
- **Counts:** Gap and opportunity totals by severity/value
- **Summary Table — Gaps:** Compact table with columns: #, Severity, Title, Description, Flagged by, Source, Disposition
- **Summary Table — Opportunities:** Compact table with columns: #, Value, Title, Category, Description, Source, Disposition
- **Part 1 — Gap Details:** Full write-up per gap (location, issue, impact, fix)
- **Part 2 — Opportunity Details:** Full write-up per opportunity (category, what's missing, why it matters, effort, suggestion)
- **Test Coverage Matrix:** Appendix mapping spec requirements to test status (✓ covered, ✗ not covered, ⚠ partially)

**Header fields:**
```
**Command:** `/spec-review docs/specs/Foo_V2.md --tier standard -s C`
**Tier:** Standard (Batches 1–3)
**Depth:** full | shallow (threshold: N, triggered after Batch M) | shallow (threshold: N, not triggered)
**Scope:** P1+P2 only
**Input:** full spec ({N} lines) | diff from V{n-1} ({changed} changed of {total} total lines)
**Reviewers — run:** [list]
**Reviewers — not in tier:** [list]
**Selective re-review:** -s {grade}, {N} agents carried from {previous review} | No — full review
**Auto-stop:** Yes — {count} C+H reached threshold ({N}) after Batch {M}; Batches {M+1}–{K} not executed
```
The `Command` field records the exact invocation for reproducibility. `Scope` is included only when `--p1p2-only` was active. `Input` is included only when diff-based mode was active. `Auto-stop` is included only when triggered.

The **Source** and **Disposition** columns are left blank by CC. CD fills them in during assessment.

### 5.7 Console output

After writing the file, the command prints to the console: the agent assessment table, counts, both summary tables, and a quick-action list of CRITICAL/HIGH gap titles and HIGH-value opportunity titles.

### 5.8 Compaction-Safe Execution

Subagent results are written to individual files on disk — conversation context is never relied upon as a durable store. This design survives context compaction, session crashes, and manual interruptions.

**Per-agent file persistence:** Each subagent writes its findings to `docs/specs/_review_work/{spec_review_basename}/{short_name}.md` as its final action. The work directory and file naming convention are specified in the command definition (`.claude/commands/spec-review.md` Step 7).

**Resume via file presence:** On entry, the command checks the work directory for existing per-agent files. Agents whose files already exist are skipped. This enables seamless resume across sessions — if a review is interrupted for any reason, re-running the same command picks up where it left off. Resume works across batch boundaries: the command determines which batch to start from based on which agents have completed files.

**Adaptive back-off:** A `_status.md` file in the work directory tracks the parallelism level. The back-off sequence:

1. **First run:** Launch agents within each batch in parallel. Default `batch_size` = agents in the batch.
2. **Interruption occurs** (compaction, crash, timeout). Some agents wrote files before the interruption; others didn't.
3. **Re-run (same or new session):** Detect existing files (skip completed agents). Compare `_status.md`'s `last_launched` list against files on disk — agents that were launched but didn't write files are casualties. Set `batch_size = max(floor(previous_batch_size / 2), 1)`. Launch remaining agents at reduced parallelism.
4. **If interrupted again:** Halve again. Floor of 1 = serial execution, which is the guaranteed-safe fallback.
5. **Stay at reduced level:** Once a batch_size is set, don't re-escalate for the remainder of the review. The context pressure from accumulated results only grows as more agents complete.

**Work directory cleanup:** The work directory is deleted only after the final aggregated `{Name}_V{n}_review.md` is written AND verified to contain results from every expected agent (both re-run and carried). If any agent is missing from the aggregated report, cleanup is blocked and the discrepancy is reported. If the review is interrupted, the work directory persists as a checkpoint.

This pattern was adopted after the DOC-019 V7 review lost 9 of 12 agent results to context compaction when all results were held only in conversation context (2026-03-19).
---

## 6. CD Assessment Workflow

After CC produces the review findings file, CD assesses each finding:

### 6.1 Disposition values

| Disposition | Meaning |
|-------------|---------|
| **Accept** | Will be addressed in the next spec version |
| **Defer** | Valid finding, will address later (add target milestone if known) |
| **Reject** | Not applicable or disagree (add brief reason) |
| *(blank)* | Not yet triaged |

### 6.2 Assessment process

1. Read the agent assessment table first — grades sorted worst-to-best immediately show which areas need attention
2. For CRITICAL/HIGH findings, read the full detail in Part 1
3. For each finding, determine disposition — Accept, Defer, or Reject
4. Fill in the Source column if the finding relates to an external document or issue
5. Tally remaining CRITICAL/HIGH items after disposition
6. If any findings are Accepted, write the next spec version incorporating them
7. Deferred CRITICAL/HIGH items flow to `docs/todos/issue_index.md` with a Deferred status and finding ID reference

### 6.3 Version bump decision

A new spec version is written only when at least one finding is Accepted. If all findings are Rejected or Deferred, the current version stands and can be declared implementation-ready (provided exit criteria are met).

### 6.4 Grade progression tracking

Across review rounds, the agent assessment table provides a natural progress indicator. CD can compare grades across versions:

```
                        V1 review   V2 review   V3 review
API Contract:              D           B           A
Integration:               C           B           A
Error Recovery:            F           C           B
...
```

When all agent grades are B or above, the spec is converging on implementation-ready — B or above means no CRITICAL or HIGH findings per the grade rubric in §4.6, which is equivalent to the §7 exit criteria (zero CRITICAL/HIGH after disposition).

---

## 7. Exit Criteria

A spec is **implementation-ready** when either:

**(a)** The most recent review has **zero CRITICAL and zero HIGH gaps** remaining after disposition, OR

**(b)** All remaining CRITICAL/HIGH items are explicitly **Deferred with rationale**

The exit condition is recorded in `Spec_Tracker.md` for each spec.

---

## 8. Document and Spec Conventions

### 8.1 Document self-identification

Every spec and workflow document includes a self-identification header:

```markdown
# Document Title

**Location:** `docs/specs/{filename}.md`
**Maintained by:** [CD or CC or both]
```

This simplifies copying the document name into prompts, task references, and other files.

### 8.2 Spec dependency declaration

Specs that depend on other specs include a `depends_on` list in the header:

```markdown
**Depends on:**
- `docs/specs/Paper_Profile_Management_Spec_V4.md` (v3.12 migration)
- `docs/specs/Selection_Search_API_Spec_V4.md` (search_utils.py)
```

The integration reviewer and the pre-implementation readiness check (§9.2) both use this declaration to verify that dependencies are met before implementation proceeds.

### 8.3 File naming conventions

| Document | Pattern | Example |
|----------|---------|---------|
| Spec (first draft) | `{Name}_V1.md` | `Multi_Photo_Project_Spec_V1.md` |
| Spec (after nth review) | `{Name}_V{n}.md` | `Multi_Photo_Project_Spec_V3.md` |
| Review findings | `{Name}_V{n}_review.md` | `Multi_Photo_Project_Spec_V2_review.md` |
| CC task prompt | `{name}_prompt.md` | `paper_profile_impl_prompt.md` |
| Pre-flight deviation | `{name}_prompt_deviation.md` | `paper_profile_impl_prompt_deviation.md` |
| Completion report | `{name}_completion.md` | `paper_profile_impl_completion.md` |
| Compliance prompt | `{name}_compliance_prompt.md` | `paper_profile_impl_compliance_prompt.md` |
| Compliance report | `{name}_compliance.md` | `paper_profile_impl_compliance.md` |

All specs and review findings live in `docs/specs/`. Findings files are permanent audit records — they never move to `completed/` or get deleted.

Task-related files live in `docs/tasks/` during active work, then move to `docs/tasks/completed/` after compliance verification passes.

Only the latest spec version is the authoritative design. Prior versions are retained for traceability but are not referenced during implementation.

---

## 9. Integration with CC Task Prompts

### 9.1 Prompt creation workflow

Once a spec is implementation-ready:

1. CD reads `Spec_Tracker.md` and `issue_index.md` to verify readiness (soft pre-flight — see §9.2)
2. CD writes a CC task prompt at `docs/tasks/{name}_prompt.md` starting from the CC task prompt template (`docs/templates/CC_Task_Prompt_Template.md`)
3. The prompt references the spec by its current version filename and full path
4. The prompt includes integration context (runtime environment, URL patterns, file serving context, schema version chain) because CC follows specs literally and does not infer environmental constraints
5. The prompt includes a mandatory pre-flight verification section (hard pre-flight — see §9.2)
6. CC implements, writes `{name}_completion.md`
7. CD runs the two-phase check completions protocol (see §9.4)

### 9.2 Pre-implementation readiness check

The readiness check operates at two levels to prevent the chicken-and-egg problem where a check that depends on CD remembering to run it is no more reliable than CD remembering the things it was supposed to check.

**CD soft check (at prompt-writing time):**

When CD is about to write a CC task prompt, CD reads these files to verify the spec is ready:

- `Spec_Tracker.md` — confirms spec status is implementation-ready
- `issue_index.md` — confirms no unresolved CRITICAL/HIGH items affect this spec
- The spec's `depends_on` list — confirms dependency specs are implemented
- `CC_Task_Prompts_Status.md` — confirms no conflicting tasks are in progress

This is analytical work CD should do as part of writing a good prompt. It is not a separate command that could be forgotten — it is the first step of the prompt-writing process.

**CC hard check (mandatory, built into every prompt):**

Every CC task prompt includes a "Pre-flight verification" section as the first thing CC executes. Before touching any code, CC reads actual files and verifies:

1. Spec file exists at the version declared in the prompt
2. Schema version in `index.db` matches the prompt's stated starting version
3. All dependency specs listed in the prompt are implemented (verify concretely: migration function exists in `system.py`, route file exists in `src/routes/`, test count from the dependency's completion report is present in the test suite)
4. No unresolved CRITICAL/HIGH items in `issue_index.md` that reference this spec
5. Test suite passes at baseline (`python -m pytest tests/ -n 12 --maxfail=3 -q`)

If any check fails, CC writes a deviation report to `docs/tasks/{name}_prompt_deviation.md` documenting what was expected vs. what was found, the impact on the task, and a recommendation (PROCEED WITH MODIFICATIONS or BLOCKED). CC commits the deviation report, then stops — it does not proceed with implementation until CD reviews the deviation report. This avoids copy-paste errors that would occur if CC reported deviations only in the console.

The deviation file naming convention (`{name}_prompt_deviation.md`) parallels the existing file lifecycle: `{name}_prompt.md` → `{name}_prompt_deviation.md` (if needed) → `{name}_completion.md` → `{name}_compliance.md`.

This pre-flight check is un-forgettable because it is embedded in the prompt template — CC cannot skip it.

### 9.3 Relationship to compliance verification

The spec review workflow feeds into the compliance verification workflow but they are distinct processes:

- **Spec review** happens *before* implementation — ensures the design is correct
- **Compliance verification** happens *after* implementation — ensures CC built what the spec described

Both are documented separately. The compliance verification workflow is defined in `docs/templates/Compliance_Verification_Guide.md`.

### 9.4 Cognitive separation in check-completions

The check-completions workflow separates analytical and mechanical work between CD and CC:

**CD does analysis and judgment:**
- Reads prompt + completion report, cross-references requirements (Phase 1)
- Writes the compliance prompt
- Reviews compliance report, confirms PASS/FAIL verdicts (Phase 2)
- Creates bug-fix tasks if needed

**CC does mechanical operations:**
- Executes the compliance verification against source code
- If all items PASS: moves the four files (`{name}_prompt.md`, `{name}_completion.md`, `{name}_compliance_prompt.md`, `{name}_compliance.md`) to `docs/tasks/completed/` and updates `CC_Task_Prompts_Status.md` with status=Complete and date
- These mechanical tasks are included as a final section in the compliance prompt itself

This ensures CD's context is used for thinking, not for file shuffling.

---

## 10. Agent Roster Summary

Tier column: Q = Quick, S = Standard, F = Full. An agent's tier column shows which tiers it is eligible in. Batch column shows execution order within a tier.

**Total: 12 agents (9 default + 3 conditional).**

### Default Agents (always run within their tier)

| # | Agent | Focus | Batch | Tiers | Agent file |
|---|-------|-------|-------|-------|------------|
| 1 | Implementation | Code path tracing, data structures, performance, concurrency | 1 | Q/S/F | `spec-implementation-reviewer.md` |
| 2 | Test Coverage | Requirement-to-test mapping, mock fidelity, edge case coverage | 1 | Q/S/F | `spec-test-reviewer.md` |
| 3 | Integration | Cross-system consistency, migrations, startup, degradation | 1 | Q/S/F | `spec-integration-reviewer.md` |
| 4 | API Contract | Endpoint parameters, response shapes, error cases, pagination | 2 | Q/S/F | `spec-api-reviewer.md` |
| 5 | Assistant Parity | Dual-path execution, tool/UI equivalence, SSE event coverage | 2 | Q/S/F | `spec-assistant-parity-reviewer.md` |
| 6 | Security/Data Integrity | Source immutability, data isolation, audit trail, rollback safety | 3 | S/F | `spec-security-data-integrity-reviewer.md` |
| 7 | Enhancement | Missing capabilities, improvement opportunities | 3 | S/F | `spec-enhancement-reviewer.md` |
| 8 | Complexity | Accidental complexity, unnecessary mechanisms, simplification | 4 | F | `spec-complexity-reviewer.md` |
| 9 | Editorial/Convention | Convention compliance + language precision (dual-lens merged agent) | 4 | F | `spec-editorial-convention-reviewer.md` |

### Conditional Agents (auto-selected or manually invoked, within their tier)

| # | Agent | Short name | Batch | Tiers | Trigger condition |
|---|-------|------------|-------|-------|-------------------|
| 10 | Error Recovery | `error-recovery` | 3 | S/F | Spec has multi-step workflows, batch ops, or physical output |
| 11 | UX Engineer | `ux` | 4 | F | Spec has UI sections, screen descriptions, JSX references |
| 12 | Performance/Query | `perf` | 4 | F | Spec has SQL, search operations, or large-scale batch processing |

---

## 11. CD Status Commands

CD has several standing commands for process monitoring and self-improvement. List them with `status list`.

| Command | Purpose |
|---------|---------|
| `status checkpoint` | Generate full project status checkpoint (existing) |
| `status retro` | Engineering retrospective — analyze recent sessions for process metrics and actionable improvements |
| `status prompts` | Prompt effectiveness assessment — evaluate Steve's prompting patterns and recommend improvements |
| `status list` | List all available status commands with brief descriptions |
| `pulse` | Quick status capture (existing) |
| `check updates` | Update working status documents (existing) |
| `check completions` | Run check-completions protocol for completed CC tasks (existing) |
| `check compliance` | Review compliance report after CC verification (existing) |

### 11.1 `status retro`

Analyzes the last N sessions (or since the last retro) and reports:

- Findings per review round (trending up/down?)
- Accept vs. Reject ratio (are reviews generating signal or noise?)
- Most common finding categories (which agents are finding the most issues?)
- Average review rounds to implementation-ready
- Test count growth per spec implementation
- Compliance pass rate on first attempt
- Time-per-spec-cycle estimates

Produces a brief report with 2–3 actionable observations about what's working and what could be improved in the development process.

### 11.2 `status prompts`

Reviews recent conversation history and evaluates prompt effectiveness:

- Clarity of intent — are prompts specific enough for CD to act without clarification?
- Appropriate level of detail — too terse? too verbose?
- Effective use of references to existing docs
- Patterns that led to good outcomes vs. patterns that caused rework or misunderstanding
- Whether prompts leverage CD's known strengths (analysis, spec writing) vs. asking CD to do things better suited to CC

Produces specific recommendations for prompt improvement.

---

## 12. Future Considerations

### 12.1 Playwright test harness

When the frontend build-out (DOC-019) reaches Phase 2, consider adding a lightweight Playwright test harness for critical-path smoke tests: server launches, CUI renders, login works, selection screen displays, basic navigation functions. This would close the frontend verification gap without the overhead of a comprehensive visual QA system. See the GStack `/browse` and `/qa` skills for architectural patterns (persistent browser daemon, ref-based element interaction, health scoring).

### 12.2 Document drift detection

A CC task that reads current working documents (`CLAUDE.md`, `Spec_Tracker.md`, `CC_Task_Prompts_Status.md`, `priority_task_list.md`, `issue_index.md`), compares against actual codebase and task state, and produces a diff of what's stale. Could run as part of the file-movement tasks after compliance or as a periodic maintenance step. CD retains judgment on prioritization and planning; CC handles the mechanical comparison.

---

## 13. Lessons Learned

These observations emerged from the first five-spec suite (~15 review rounds, ~500 findings total) using the original five-agent roster. The expanded roster (9 default + 6 conditional) is expected to amplify these effects.

1. **Parallel agents find more than sequential passes.** Running focused agents independently produced more findings than a single agent asked to review from multiple perspectives. The analytical lenses genuinely interfere with each other in a single forward pass.

2. **First review round catches structural issues; second catches precision issues.** The V1→V2 cycle typically fixes missing sections, wrong defaults, and incomplete DDL. The V2→V3 cycle fixes parameter types, boundary values, and error response shapes. A third round is only needed when V3 introduced substantial new material.

3. **Integration reviewer catches the most CRITICAL bugs.** Schema migration ordering, startup failures, and cross-feature consistency issues are invisible when reading a spec in isolation. The integration reviewer's mandate to check existing code (routes, serve_db.py, config) surfaces problems the other agents miss.

4. **Enhancement reviewer's value compounds across specs.** Opportunities identified in one spec's review often improved companion specs too (e.g., a "score explanation" opportunity identified in search API review led to improvements in the assistant parity spec).

5. **Test reviewer catches mock fidelity issues that would ship silently.** The most valuable test reviewer findings are not "missing test" but "test exists but mock masks real behavior" — these are bugs that pass CI but fail in production.

6. **Deduplication matters.** Without the aggregation step, the same issue found by multiple agents would appear multiple times in the findings, inflating counts and making triage tedious. The deduplication step with "Flagged by" attribution preserves the signal that multiple agents noticed the same problem (which is a severity amplifier) while eliminating noise.

7. **Stable finding IDs (G-n, O-n) are essential for discussion.** Being able to say "Accept G-4, Defer G-7, Reject O-3" makes the assessment phase dramatically faster than re-describing each finding.

8. **Per-agent files survive compaction; conversation context does not.** Launching 9+ agents with results held only in conversation context is fragile — compaction can discard completed results before aggregation runs. The fix: each agent writes its own findings file to disk. Aggregation reads files. Resume is automatic (check which files exist, launch only missing agents). Adaptive back-off halves parallelism when agents fail to write files, bottoming out at serial execution. Discovered during the DOC-019 V7 review (2026-03-19) when 9 of 12 completed agent results were lost to compaction.

9. **Tiered execution reduces token burn without losing critical findings.** Analysis of PPF review rounds V2–V7 showed that the 5 Quick-tier agents (Implementation, Test Coverage, Integration, API Contract, Assistant Parity) account for all CRITICALs and ~75% of unique HIGH findings. Standard tier (8 agents, Batches 1–3) adds security, error recovery, and enhancement coverage. Full tier (13 agents) adds quality and polish. Quick saves ~60% tokens vs. Full; Standard saves ~33% while retaining the highest-value agents. Use `--tier quick` for rapid iteration on early drafts; `--tier standard` (default) for pre-implementation reviews; `--tier full` when excellence matters or before a major implementation phase.

---

## 14. Spec Tracker

The `docs/specs/Spec_Tracker.md` file records the lifecycle of every spec: current version, review history, open CRITICAL/HIGH counts, exit condition, and CC task links. It is maintained exclusively by CD and serves as the single source of truth for spec status across sessions.
