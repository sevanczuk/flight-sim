---
Created: 2026-04-22T17:19:38-04:00
Source: Purple Turn 11 (post-resumption 2026-04-22) — Steve selected "Wait for C2.2-C to complete before drafting anything else" in response to a parallelism analysis (Turn 10)
---

# D-21: Multi-Fragment Task Prompts — Draft Sequentially, After Predecessor Archives

**Date:** 2026-04-22
**Status:** Active
**Refs:** D-18 (piecewise + manifest format; sequential execution rationale), D-20 (LLM-calibrated duration estimates), D-07 (ITM-based compliance triage), `docs/tasks/completed/c22_b_*.md` (S13 outline-vs-PDF discovery that informed this decision)
**Affects:** All future multi-fragment or multi-task sequences where each task builds on the previous task's archived output, OR where compliance reviews of earlier tasks may surface lessons applicable to later tasks

---

## Context

On 2026-04-22 (Purple Turn 10 post-resumption), Steve asked whether CD could draft the remaining C2.2 prompts (D, E, F, G) in parallel while C2.2-C was executing. The question separated naturally into two parts:

1. **CD prompt drafting in parallel:** technically feasible; CD context is fresh; minor rework risk if structural lessons surface mid-stream
2. **CC execution in parallel:** would require per-task isolation tweaks (unique commit temp filenames, `git add <paths>` instead of `-A`) and would sacrifice D-18's sequential quality rationale; net ~70 min wall-clock savings

Steve selected the most conservative option: **wait for C2.2-C to complete before drafting anything else.** This decision codifies the rationale.

The underlying concern: C2.2-B's compliance cycle surfaced a content-level discrepancy (S13: outline said "Search by Facility Name" but the PDF uses "SEARCH BY CITY"). That was a cheap fix to apply downstream (the C2.2-C prompt references PDF pages for source-fidelity spot checks, which would catch similar term discrepancies). But a more structural lesson — say, "the §4 parent-scope inheritance convention needed to be clearer" — would have required revising pre-drafted D/E/F/G prompts to match. Pre-drafting ahead of predecessor archives amortizes risk across all pre-drafted prompts.

---

## Decision

**Rule:** For multi-fragment or multi-task sequences where downstream tasks build on upstream tasks' archived outputs, CD drafts the next task prompt only **after** its immediate predecessor has been fully archived (i.e., after Phase 2 compliance review lands a PASS or PASS WITH NOTES verdict and the four task files have moved to `docs/tasks/completed/`).

### Scope — where this rule applies

- Piecewise spec-fragment sequences (e.g., C2.2-A through C2.2-G currently in flight)
- Future piecewise spec sequences (e.g., the eventual GNX 375 design spec if it's also piecewise)
- Multi-phase implementation sequences where each phase's compliance may surface lessons for subsequent phases
- Any task chain where forward-references or content coherence across tasks matters

### Scope — where this rule does NOT apply

- Independent tasks with no cross-coupling (drafting them in parallel is fine)
- Rapid-turnaround bug-fix tasks that are not part of a structured sequence
- Sequences where every task is strictly mechanical (e.g., "run the same compliance template against 5 different files") — no risk of upstream lessons requiring downstream revision

### Mechanics

1. After the predecessor task archives (its four files live in `docs/tasks/completed/`), CD begins drafting the successor task prompt in the next CD turn.
2. CD may begin **planning** the successor prompt (scope summary, target line count, known framing commitments) at any earlier point — this is cheap mental preparation, not file authoring.
3. Writing the actual successor prompt file is gated on predecessor archive. This produces the "one prompt drafted per predecessor archived" cadence.

### Relationship to D-18

D-18 established sequential **execution** for C2.2 (one CC task running at a time, later tasks reading earlier archived fragments). This decision extends the sequential discipline to **drafting** — CD drafts one prompt at a time, after each predecessor archive. Together, D-18 + D-21 define a fully-sequential lifecycle for multi-fragment work.

---

## Rationale

### Why this is the right default

**Lesson preservation is high-value and cheap to preserve.** S13 (outline term "Search by Facility Name" vs. PDF "SEARCH BY CITY") was surfaced by C2.2-B's compliance process. That lesson informed the C2.2-C prompt, which now explicitly warns CC: "the outline may contain PDF-term discrepancies; CC's PDF-direct reading catches these during authoring — trust the PDF as authoritative." Had C2.2-C been pre-drafted before C2.2-B's compliance landed, that warning wouldn't have been present, and CC might have replicated a similar outline-dependence error.

Every fragment's compliance cycle is a potential source of similar lessons. Drafting the next prompt **after** the predecessor's compliance cycle means every lesson is available before the next prompt is written.

**Rework of pre-drafted prompts is real but unpredictable work.** The cheap case is a one-line addition to an existing framing commitment. The expensive case is restructuring implementation phases or adding a new source-of-truth tier. Writing "draft later" lets the cheap case apply naturally during composition and avoids the expensive case entirely.

**Wall-clock savings from pre-drafting are small relative to risk.** Per D-20 LLM-calibrated estimates, drafting a CD prompt takes maybe 5–15 CD minutes (depending on scope complexity). The compliance cycle for the predecessor takes ~15–30 min wall-clock (CC compliance + CD triage). So pre-drafting saves roughly one CD turn of overlap with compliance review — not nothing, but not dramatic either.

**Execution parallelism is a separate, larger wall-clock lever.** If significant wall-clock savings become important later in the C2.2 series (e.g., because Steve wants to wrap up the prep phase faster), the parallel-execution lever is available — D/E/F have disjoint fragment files and can run in parallel with isolation tweaks (per the Turn 10 analysis). D-21 doesn't preclude that conversation; it just keeps prompt-drafting sequential.

### What this rule is NOT saying

- **Not saying all work must be sequential.** Independent tasks can still parallelize. This rule is about sequences where downstream depends on upstream.
- **Not saying CD must wait until compliance to START thinking about the next prompt.** Planning and context-loading can happen mentally at any time. The rule is about writing the prompt file.
- **Not saying this applies to bug-fix or housekeeping tasks.** Those are typically not structured sequences.

### Why prior evidence supports this rule

Looking at the C2.2 series so far:

- **C2.2-A → C2.2-B:** C2.2-A was first-of-pattern; authoring conventions (fragment file format, Coupling Summary structure, hard constraint phrasing) stabilized during its compliance cycle. The C2.2-B prompt inherited these conventions as "reuse the template" — pre-drafting would have required guessing at conventions that C2.2-A was still settling.
- **C2.2-B → C2.2-C:** C2.2-B's S13 finding (outline-PDF term discrepancy) informed C2.2-C's prompt (added "trust PDF as authoritative" watchpoint). Pre-drafting C2.2-C would have missed this. D-20 (LLM-calibrated durations) also landed during C2.2-B review and updated the estimated-duration field in C2.2-C; pre-drafting would have had the old inflated estimate.
- **C2.2-C → C2.2-D (upcoming):** C2.2-C's compliance may surface the structural-header-inheritance check (did CC successfully omit `## 4. Display Pages`?). Whatever the outcome, that lesson should land in the C2.2-D prompt before it's written.

Three consecutive data points of compliance cycles producing actionable feedback for the next prompt is compelling evidence that the sequential-drafting discipline pays off.

---

## Application

**Immediate:** C2.2-D prompt drafting is gated on C2.2-C archive. CD will wait for:
1. C2.2-C CC execution → completion report
2. CD Phase 1 check-completions → compliance prompt
3. CC compliance execution → compliance report
4. CD Phase 2 check-compliance → archive verdict
5. If PASS: archive 4 files + update manifest + flag C2.2-D ready to draft

Estimated gate duration: ~45–75 min wall-clock (depending on whether any FAILs surface) from C2.2-C completion.

**Future C2.2 fragments:** C2.2-E drafting waits for C2.2-D archive; F waits for E; G waits for F. Full critical path: 4 more archive gates × ~45–75 min each = ~3–5 hours wall-clock for the prompt-drafting portion of the critical path (not counting CC execution time, which is concurrent).

**Future applicability:** When a future multi-fragment sequence is proposed (e.g., the GNX 375 design spec may be piecewise), this rule applies by default. Exceptions can be logged as amendments if evidence supports relaxation.

---

## Non-decisions (intentionally not changed)

- **D-18's sequential execution stays default.** D-21 extends the sequential discipline to drafting but doesn't strengthen the execution constraint.
- **Parallel execution (not drafting) remains an option.** If wall-clock becomes binding, D/E/F can potentially run in parallel after C archives, with isolation tweaks. That would be a separate decision to amend D-18; D-21 doesn't preclude it.
- **Emergency/override protocol.** If a specific situation warrants pre-drafting (e.g., Steve explicitly requests "draft D and E together"), D-21 can be overridden case-by-case without amending the decision. The default is sequential; specific overrides are fine.

---

## Related

- D-07 (ITM-based compliance triage — the mechanism that surfaces lessons for downstream application)
- D-18 (piecewise + manifest format; sequential execution rationale)
- D-20 (LLM-calibrated duration estimates; landed during C2.2-B → C2.2-C cycle as an example lesson)
- `docs/tasks/completed/c22_b_compliance.md` (S13 finding that informed the C2.2-C prompt)
- `docs/tasks/Task_flow_plan_with_current_status.md` (critical-path tracking)
