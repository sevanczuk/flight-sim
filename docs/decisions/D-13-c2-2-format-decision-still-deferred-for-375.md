# D-13: C2.2 format decision still deferred — now applies to GNX 375 outline

**Created:** 2026-04-21T08:57:03-04:00
**Source:** Purple Turn 16 — logging the C2.2 format-decision deferral under its own ID given the pivot in D-12 materially changes what C2.2 will produce
**Decision type:** scope / approach (updates D-11's deferral context)
**Supersedes (context only):** The original C2.2 format deferral under D-11 was scoped to the 355 outline. Per D-12, the C2.2 work now targets the 375 outline.

## Decision

The C2.2 spec body format decision remains **deferred**, per the same deferral reasoning as D-11, now re-scoped to the GNX 375 outline rather than the GNC 355 outline.

Three format options remain on the table:

1. **Monolithic via CRP-phased authoring** — single file `docs/specs/GNX375_Functional_Spec_V1.md`; CC writes via 4–6 explicit phases per major section group; CRP gives compaction-resilience and resume-ability. Wins if 375 outline reveals tight cross-section coupling, natural top-to-bottom narrative, and total expected length ≤2,500 lines.

2. **Piecewise + manifest** (the project default per `claude-conventions.md` §Spec Creation → Review Lifecycle) — CC produces part files + `_manifest.json` + aggregate; spec-review uses hybrid mode for per-section grades. Wins if 375 outline reveals 5–8 nearly-independent sub-domains OR total expected length >2,500 lines.

3. **One CC task per section** — CD authors 4–6 separate task prompts; each produces one section file; final consolidation step assembles. Wins if 375 outline reveals very independent sub-domains (e.g., XPDR operation + ADS-B + GPS nav may genuinely be standalone sub-specs); allows pause-and-assess between sections at the cost of multi-cycle wall-clock.

The decision is made by CD after reading the 375 outline. The decision criteria above are guidelines; the outline itself is the final input.

## What changed from D-11

D-11 deferred the format decision for the 355 outline's C2.2 sub-tasking. That decision was never formalized because the 355 work was paused per D-12.

This decision (D-13) re-establishes the deferral for the 375 outline's C2.2 equivalent. The options and heuristics are unchanged; only the target outline has shifted.

## Implementation note

D-13 applies when the 375 outline (to be produced by the CC task succeeding C2.1, after the harvest turn per D-12) is in hand. The format decision itself will be logged as a separate D-NN entry (likely D-15 or later, depending on what intervenes) once CD reviews the 375 outline.

## Related

- D-11 (original format deferral; scoped to 355 outline)
- D-12 (pivot to 375; triggered this re-scoping of the format deferral)
- `claude-conventions.md` §Spec Creation → Review Lifecycle (format heuristics)
