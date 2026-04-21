# D-11: C2 delivery format deferred — outline-first approach with format decision after outline review

**Created:** 2026-04-21T07:02:13-04:00
**Source:** Purple Turn 10 — Steve asked whether equally-effective alternatives exist to the default piecewise + manifest approach for C2 (GNC 355 Functional Spec V1 draft); Turn 11 records the resulting decision to defer format selection until after an outline-first sub-task lands
**Decision type:** scope / approach (specific to C2 sub-tasking)

## Decision

C2 (GNC 355 Functional Spec V1 draft) will be authored in two sub-tasks rather than one:

1. **C2.1 — Detailed outline authoring** (small CC task; ~30 min wall-clock). Produces `docs/specs/GNC355_Functional_Spec_V1_outline.md` with full section structure, sub-section breakdown, source page references from C1's extracted PDF, and per-section length estimates.

2. **C2.2 — Spec body authoring** (large CC task; format TBD per this decision). Format selection deferred until after CD reviews the C2.1 outline. The size and structure of the outline drives the format choice.

**Format options under consideration for C2.2** (any of these, chosen post-outline):

| Option | Description | When it wins |
|---|---|---|
| **Monolithic via CRP-phased authoring** | Single file `docs/specs/GNC355_Functional_Spec_V1.md`; CC writes via 4–6 explicit phases per major section group; CRP gives compaction-resilience and resume-ability | Outline reveals tight cross-section coupling, a natural top-to-bottom narrative, and total expected length 1500–2500 lines; spec-review will run on the single file |
| **Piecewise + manifest** (the project default per `claude-conventions.md` §Spec Creation → Review Lifecycle) | CC produces part files + `_manifest.json` + aggregate; spec-review uses hybrid mode for per-section grades | Outline reveals 5–8 nearly-independent sub-domains where per-section spec-review grades would meaningfully aid triage; total expected length 2500+ lines |
| **One CC task per section** | CD authors 4–6 separate task prompts; each produces one section file; final consolidation step assembles | Outline reveals very independent sub-domains (e.g., map page vs. flight plan vs. COM may genuinely be standalone sub-specs); allows pause-and-assess between sections at the cost of multi-cycle wall-clock |

The format decision is made by CD after reading C2.1's output. The decision criteria above are guidelines; the outline itself is the final input.

## Rationale

The genuine risk in C2 is structural, not stylistic: missing a section the design phase needs, mis-comparing devices in the family-delta appendix, specifying COM radio behavior at the wrong abstraction level. These risks are visible in a detailed outline before any prose exists. Catching them at outline stage costs one CD review turn; catching them after a multi-thousand-line draft costs hours of CC work.

The format question (monolithic vs. piecewise vs. per-section) is downstream of the outline — answerable in a focused way once the structural picture exists, not before. Pre-committing to piecewise based on a length guess (current estimate: 1500–2500 lines, but unverified) would lock in machinery that may not be needed.

The outline itself is reusable: it informs C4 (V2 incorporating spec-review findings), it can become the implementation phase task breakdown, and it earns its keep beyond the decision it enables.

## Why this isn't a one-off — generalize the pattern

Outline-first is appropriate for any large spec where:
- Final length is uncertain enough that delivery format isn't obvious
- Structural correctness is a higher risk than prose quality
- The outline itself has long-term value (e.g., as an implementation task source)

Future large specs (GNC 355 Design Spec, any subsequent module specs) should consider the same pattern. This is not yet codified as a project-wide convention; if the C2.1 → C2.2 sequence proves out, a future decision can promote it to the default approach for specs above some size threshold.

## Consequences

- C2.1 task prompt drafted in Purple Turn 11 (this turn); CC-launchable
- C2.2 task prompt deferred until after CD reviews the C2.1 outline (CD's next turn after C2.1 archive)
- The implementation plan (`docs/specs/GNC355_Prep_Implementation_Plan_V1.md` §6.C2) becomes slightly out of date — it describes C2 as a single task with a fixed format. Plan update is a low-priority followup (ITM-06; can wait until C2.2 format is locked, since updating now then again post-format-decision is inefficient)
- C3 (`/spec-review`) and C4 (iteration) remain conceptually unchanged but will be invoked against whatever artifact form C2.2 produces (single file, manifest, or assembled-from-sections)
- The "options considered" record in this decision preserves the alternatives so future Purple sessions can revisit if the outline-first pattern proves problematic

## Trade-offs accepted

| Trade-off | Acceptance rationale |
|---|---|
| Two sub-tasks instead of one (more CD coordination) | The format decision after C2.1 is more informed than a pre-commit; coordination cost is one extra CD review turn |
| C2.1 is ~30 min "wasted" if outline confirms the obvious choice | Even in that case the outline accelerates C2.2 authoring; not actually wasted |
| Slight delay before C2.2 launches (one CD turn for outline review + format decision + C2.2 prompt drafting) | Acceptable given C2 is the largest single deliverable in the project; getting the format right is worth the delay |

## Related

- `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` §6.C2 (the original C2 spec — slightly out of date per Consequences above)
- `claude-conventions.md` §Spec Creation → Review Lifecycle (defines the piecewise-vs-monolithic project default and heuristic)
- `docs/tasks/c2_1_outline_prompt.md` (the C2.1 task prompt, drafted this turn)
- ITM-06 (deferred plan update; created if/when C2.2 format is selected)
- D-02 (GNC 355 prep scoping — defined the three-stream structure that C2 lives within)
