---
Created: 2026-04-22T15:57:17-04:00
Source: Purple Turn 4 (post-resumption 2026-04-22) — C2.2-B completion at ~15 min vs. 90–120 min estimate
---

# D-20: CC Task Duration Estimates — LLM-Calibrated, Not Human-Calibrated

**Date:** 2026-04-22
**Status:** Active
**Refs:** C2.2-B completion (`docs/tasks/c22_b_completion.md`), C2.2-A (for comparison baseline — longer first-of-pattern), D-19 (fragment line-count expansion ratio — pattern of similarly over-estimating before evidence landed)
**Affects:** All future CC task prompt duration estimates authored by CD

---

## Context

The C2.2-B task prompt set an "Estimated duration" of "~90–120 min" for CC wall-clock. CC completed in ~15 minutes. The disparity prompted Steve to ask whether CC skipped steps. Completion review confirmed CC did not skip steps — all phases ran, all 17 self-checks produced real evidence, and the fragment quality was high (with CC proactively trimming from 917 → 798 lines to meet the ceiling).

The root cause of the bad estimate: I calibrated "~90–120 min" as if it were human work (reading ~700 lines of outline + 545 lines of Fragment A + 6 PDF pages + authoring ~800 lines of structured prose + running grep-based self-checks). For a capable LLM on a well-scoped, fully self-contained prompt, each of those phases is dramatically faster:

| Phase | Human-calibrated estimate | LLM actual |
|------|---------------------------|------------|
| Read outline + Fragment A + PDF pages + decisions | 15–25 min | sub-second tool calls |
| Author ~800 lines of markdown + 10 tables | 60–90 min | one generation (~3–5 min wall-clock) |
| 17-item self-review (grep + wc commands) | 10–15 min | parallel shell calls, seconds |
| Commit + ntfy | 2–5 min | ~1 min |
| **Total** | **~90–135 min** | **~5–10 min** |

The C2.2-A case took longer than C2.2-B (~60–90 min vs. ~15 min) because it was first-of-pattern: CC had to create the `docs/specs/fragments/` directory, establish fragment file conventions, and author the Coupling Summary format for the first time. Those one-time costs do not recur for B through G.

This pattern — over-estimating CC time based on human-work calibration — is not new. D-19 was a similar lesson at a different layer (line-count targets). Both decisions reflect the same underlying miscalibration: treating LLM output generation like human writing.

---

## Decision

**For future CC task prompt duration estimates, use LLM-calibrated numbers, not human-calibrated numbers.** Baseline heuristics:

### Docs-only tasks (spec authoring, outline authoring, checklist/report generation)

| Task class | CC wall-clock estimate |
|------------|------------------------|
| ~300-line fragment, well-scoped, no novel conventions | 5–15 min |
| ~500-line fragment, well-scoped, no novel conventions | 10–20 min |
| ~800-line fragment, well-scoped, no novel conventions | 10–25 min |
| First-of-pattern fragment (establishing conventions) | 30–60 min |
| ~1,500+ line outline or spec, substantial research, multi-source | 45–90 min |
| Compliance verification (read + shell checks + report) | 5–15 min |
| Bug-fix on known scope (single file, <200 lines change) | 5–15 min |

### Code tasks (implementation, test authoring)

Code tasks take longer than docs tasks primarily because of:
- Iterative test-debug cycles (each failure adds minutes)
- Linter/type-check passes triggering fixes
- Real external calls (API, DB) adding wall-clock independent of LLM speed

| Task class | CC wall-clock estimate |
|------------|------------------------|
| Single-file utility script, no tests | 5–15 min |
| Feature implementation with unit tests, single subsystem | 20–45 min |
| Multi-file feature, integration tests, debug cycles | 45–120 min |
| Spec review via `/spec-review` (8-agent standard tier) | 30–60 min |
| Complex refactor touching 5+ files | 60–180 min |

### Adjustment factors

Multiply baseline by:
- **×1.5** if prompt requires CC to read 5+ source files totaling >2,000 lines (reading is fast but large-context generation slows down)
- **×2** if task is first-of-pattern (establishing conventions CC will reuse)
- **×0.7** if task reuses an established pattern with no novel framing (C2.2-B, C2.2-C, etc. after C2.2-A)
- **×2–3** if code task has a non-trivial iterative test-debug cycle possibility (e.g., integration with new external service)

### How to state estimates in prompts

Give a range tied to the LLM-calibrated baseline, and name it explicitly. Example format:

```
## Estimated duration

- CC wall-clock: ~10–20 min (LLM-calibrated baseline for ~800-line docs-only fragment reusing established C2.2-A conventions; ×0.7 reuse adjustment applied)
- CD coordination cost after this: ~1 check-completions turn + ~1 check-compliance turn + ~0.5 turn to update manifest and start next prompt
```

Naming the baseline + adjustments makes the estimate auditable and lets future CD recalibrate as evidence accumulates.

---

## Rationale

### Why this matters

A 5–10× miscalibration in either direction has real operational impact:

- **Over-estimating (the current pattern):** Steve waits longer than necessary before coming back to check progress. Batching other work around an inflated estimate wastes time. More importantly, when CC finishes dramatically early, it looks suspicious — Steve reasonably asks "did CC skip steps?" That's a false signal caused by bad estimation, not a real problem.
- **Under-estimating:** Steve gets frustrated when CC runs long. Process flow planning (check-completions scheduling, next-prompt drafting) is disrupted.

Calibrated estimates are a light-touch intervention with high reliability payoff.

### Why the C2.2-A experience did not prevent this miscalibration for C2.2-B

C2.2-A completion timing was not flagged as anomalous in the previous checkpoint or in Turn 35 archiving — it was a "first-of-pattern" case that legitimately took longer. I carried forward its duration experience as a direct estimate for C2.2-B without adjusting for the one-time-cost difference. The ×0.7 reuse adjustment would have caught this.

### Why this is LLM-calibrated now (and not platform/model-version-specific)

Current LLM generation speeds (Claude Opus 4.x family, 2026 model era) sustain ~3,000–5,000 tokens/min of structured prose output. A ~800-line markdown file is ~6,000–10,000 tokens. That's 2–4 minutes of pure generation. File-reading tool calls are sub-second. Shell-exec tool calls (grep, wc) are sub-second. Commit mechanics are ~1 min.

If LLM generation speeds change substantially (slower or faster) in the future, the baselines above will need recalibration. But the general principle — LLMs are dramatically faster at generation than humans are at writing — will hold across model generations.

---

## Non-decisions (intentionally not changed)

- **CD turn cost estimates remain subjective.** CD work is interleaved reasoning + reading + file writes across a turn. Estimating individual CD turns by wall-clock isn't the right model; CD turns are counted by action units, not minutes.
- **Critical-path estimates can use the LLM-calibrated CC times plus nominal CD turn counts.** The C2.2 remaining path is ~5 fragments × (~1 CD drafting turn + ~10–25 min CC + ~1 CD completion turn + ~5–15 min CC compliance + ~1 CD archive turn) plus aggregate + C3 + C4. The CC times are now calibrated per this decision; CD turn counts are separate.
- **Prompt length estimates (~720 line target for C2.2-B etc.) are not affected.** D-19's fragment expansion ratio is about content volume, not authoring duration. Orthogonal concern.

---

## Application

**This turn:** Update C2.2-B completion review to reflect the timing lesson (this decision).

**Next drafting (C2.2-C prompt, after B archives):** Use LLM-calibrated estimates from the table above, with ×0.7 reuse adjustment. Draft should read approximately:

```
## Estimated duration

- CC wall-clock: ~10–20 min (LLM-calibrated; ~575-line docs-only fragment reusing C2.2-A and C2.2-B conventions; ×0.7 reuse adjustment applied)
- CD coordination cost: ~1 check-completions turn + ~1 check-compliance turn + ~0.5 turn to update manifest and start C2.2-D prompt
```

**Future maintenance:** If CC wall-clock times consistently diverge from LLM-calibrated estimates by >50% in either direction across 3+ tasks, log a refinement to this decision. The baseline numbers above are starting points, not permanent values.

---

## Related

- D-19 (fragment prompt line-count expansion ratio — sibling miscalibration of a different metric)
- `docs/tasks/completed/c22_a_completion.md` (C2.2-A timing baseline — first-of-pattern)
- `docs/tasks/c22_b_completion.md` (C2.2-B timing — the actual data point that surfaced this decision)
- `claude-conventions.md` §"CC Task Prompts" (this decision refines the "Estimated duration" field conventions)

