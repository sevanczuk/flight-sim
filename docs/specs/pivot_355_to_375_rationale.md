# Pivot Rationale: GNC 355 → GNX 375 as Primary Instrument

**Created:** 2026-04-21T08:57:03-04:00
**Source:** Purple Turns 14–16 — pivot discussion between CD and Steve
**Purpose:** Full context for the pivot decision (D-12), including all five options considered, pros and cons per option, the chosen approach (Option 5), and the watched-cons that carry forward as risks to monitor during 375 execution.
**Status:** Authoritative record. D-12 is the formal decision; this document is the reasoning.
**Companion decision:** `docs/decisions/D-12-pivot-gnc355-to-gnx375-primary-instrument.md`
**Amended decision:** `docs/decisions/D-02-gnc355-prep-scoping.md` (§9 nomenclature corrected; baseline instrument pivoted)

---

## Context

Up through Turn 13 of the current Purple session, the project had been executing a three-stream prep plan (A = AMAPI docs, B = instrument samples, C = GNC 355 functional spec) per D-02. Streams A and B completed successfully; Stream C produced a detailed 1,327-line outline (C2.1 — GNC355-SPEC-OUTLINE-01) and was in the compliance-verification phase when Steve surfaced a fundamental misalignment.

**The misalignment:** The project's real-world motivation is replicating the avionics in two C172 aircraft Steve flies. The aircraft he flies *more frequently* has a GNX 375 (GPS/MFD + Mode S transponder + built-in dual-link ADS-B In/Out; no COM). The other has a GNC 355 (GPS/MFD + VHF COM; no transponder/ADS-B). Somewhere between the motivation and the original scoping, the primary instrument got transcribed as "GNC 355" instead of "GNX 375." The "GNC 375" reference in D-02 §9 was the fingerprint of the error (there is no Garmin GNC 375 product; the "C" vs. "X" difference marks COM vs. transponder/ADS-B variants).

**What Steve wants:**
- GNX 375 as the primary deliverable (it's the aircraft he flies most often)
- Full UI fidelity + sim integration + procedural fidelity for instrument approaches
- GNC 355 preserved as a deferred second deliverable (355 implementation may be deferred further due to other projects)
- 375 work should leverage lessons learned and not duplicate effort

## Options considered

Five options were put on the table across Turn 14 (CD proposed 1–4) and Turn 15 (Steve proposed Option 5 as an intuition; CD re-analyzed and agreed).

### Option 1 — Restart C2 with 375 as primary, abandon current outline

Throw away the GNC 355-focused outline; re-run C2.1 with the spec scoped to GNX 375 only.

**Pros:**
- Clean slate; spec is single-unit-focused with no scope overhead
- No risk of 355-era structural assumptions leaking into 375 spec

**Cons:**
- Wastes ~1 hour of CC work and the comprehensive structural outline already produced
- ~75% of the existing outline is unit-agnostic and reusable
- Loses all the page-reference work already done for unit-agnostic sections

**Why rejected:** too much genuine work gets thrown away. The 355 outline's GPS navigation, flight plan, procedures, map page, and nearest pages content is functionally identical between 355 and 375 — they share the same GPS/MFD platform. Discarding that is a false economy.

---

### Option 2 — Rebadge the outline as 375-primary with 355 as a delta appendix

Treat the existing C2.1 outline as the GPS-functionality core. Re-author Section 11 (COM) as "Section 11: Transponder + ADS-B" (the 375-specific content). Move COM content to "Appendix D: GNC 355 Delta — COM Radio." Flip Appendix A baseline from 355 to 375.

**Pros:**
- Preserves most of the C2.1 work; structurally honest about what the units share
- The COM-as-appendix structure makes the 355 a "375 + COM addendum"
- Lowest upfront cost of any option
- Single-outline maintenance story

**Cons:**
- Requires a non-trivial outline revision (Section 11 swap, Appendix A flip, scope statement updates throughout)
- Scope grows by the XPDR/ADS-B content that wasn't in the original 355 scope
- Risk of 375 features getting shoehorned into a structure originally optimized for 355
- Appendix D (355 delta) couples the 355 to the 375; if 355 implementation resumes much later, the 355 content lives embedded rather than self-contained
- Clarity of scope per instrument is blurred — reader of the 375 spec has to understand the Appendix D delta to know what's NOT 375

**Why initially recommended by CD (Turn 14):** optimizes for minimum CC re-authoring cost. Preserves the most of the existing work. Single-outline maintenance.

**Why rejected after Steve's Q3c answer (Turn 15):** full procedural fidelity for instrument approaches is the key driver. The 375's approach-time behavior includes ADS-B-In traffic overlay, transponder altitude reporting, and GPS flight phase annunciations interacting with the transponder — these are 375-first concerns that deserve to be specified as primary behaviors, not adapted from a 355 structure where they're peripheral. Option 2's shoehorn risk is material for the procedural-fidelity target.

---

### Option 3 — Author a parallel 375 outline; keep 355 outline as a future deliverable

Treat C2.1 (the 355 outline) as done-and-shelved. New CC task produces a parallel outline scoped to the GNX 375. The 355 spec resumes someday after 375 completes.

**Pros:**
- Clean separation; each outline is single-unit-focused
- The 355 outline is preserved as a reference for the eventual 355 spec
- No risk of 355-era assumptions leaking into 375 spec

**Cons:**
- Duplicates structural work between outlines
- If both units are eventually built, the eventual specs will have ~75% identical content maintained in two places
- No mechanism to leverage the 355 outline work on the 375 side — CC would re-derive everything

**Why rejected:** misses the opportunity to leverage the 355 outline as reference material. Option 5 (below) is Option 3 with a harvest step that addresses this con.

---

### Option 4 — Shared core + variant addenda

Architectural restructure: produce three specs instead of one or two:
- **GPS_175_GNX_375_GNC_355_Core_Spec_V1** — all the GPS/MFD content shared by all three units
- **GNX_375_Variant_Spec_V1** — XPDR + ADS-B + GNX-only differences
- **GNC_355_Variant_Spec_V1** — COM + 355-only differences

The full GNX 375 instrument spec = core + 375 variant. The full GNC 355 instrument spec = core + 355 variant.

**Pros:**
- "DRY" approach; no duplicated content
- Supports both units cleanly; the GPS 175 unit comes for free if you ever want it
- Honest reflection of how Garmin actually built these (shared platform + variants)
- If Option 4 is ever the right answer, it's the *most* right answer structurally

**Cons:**
- More upfront structural work than any other option
- Spec-review pipeline is more complex (3 specs + variant-combination review)
- Cross-spec navigation overhead during implementation
- Premature abstraction — the right-time to factor out a shared core is after observing the actual duplication, not before
- Harder for readers who want "the 375 spec" — they now read two documents

**Why rejected:** over-engineering for a 1–2-instrument project. If a third unit (GPS 175) ever comes into scope, Option 4 can be retrofitted from Option 5 with manageable effort. Deferring Option 4 to a possible future restructure (triggered by spec-review feedback or a third-unit addition) is safer than committing to it up front.

---

### Option 5 — Harvest 355 outline, then author dedicated 375 outline

Steve's proposal (Turn 15), re-analyzed by CD and agreed:

1. Finish the 355 outline compliance (in-flight at decision time).
2. Walk the 355 outline categorizing each section/sub-section by reusability: fully reusable / partially reusable / 355-only / 375-needs-new-content.
3. Author a dedicated 375 outline using the harvest map as a reference (not a template). CC reads the 355 outline for unit-agnostic content patterns and the 375-specific PDF sections (XPDR pp. 75–85, ADS-B built-in treatment, GNX-specific features) to produce an independent outline.
4. When 355 implementation resumes (indeterminate future), the 355 outline is shelved and ready to resume; only 355-specific content needs re-work plus a back-port pass for any 375-era insights.

**Pros:**
- **375 spec fidelity is highest** — a dedicated 375 outline treats XPDR/ADS-B as first-class concerns from the start; no shoehorn effects
- **355 work preservation is explicit** — 355 outline stays as a whole document, ready to resume
- **Sharp scope clarity per instrument** — each outline is single-unit; scope boundaries are obvious
- **Lower risk of 375 spec being incomplete** — starting from scratch (with harvest map as reference) forces explicit coverage of every 375 feature
- **Procedural fidelity better positioned** — LPV approach work is GPS-navigation-centric and unit-agnostic, but the 375's integration (autopilot coupling, ADS-B-In traffic during approach, GPS-derived flight phase annunciations with transponder altitude reporting) benefits from being specified in the 375 context rather than "see Appendix D"
- **Harvest step is cheap CD work** — one turn, ~30 min, produces a useful artifact (the reusability map) that also guides the 375 outline CC task efficiently

**Cons (= watched cons; see next section):**
- Higher upfront cost than Option 2 (two outlines + harvest map vs. one revised outline)
- Maintenance cost doubles if both instruments eventually get built (two outlines drift independently)
- Risk of 355 outline becoming stale — insights gained during 375 work may not back-port
- Harvest step could balloon into multi-turn work if not time-boxed

**Why chosen:**
- Full procedural fidelity (Steve's Q3c answer) shifts the optimization target from minimum-re-authoring-cost (Option 2's strength) to maximum-375-fidelity (Option 5's strength)
- 355 deferral uncertainty favors self-contained preservation over coupling as an appendix
- The harvest step's CD-side cost is comparable to Option 2's outline-revision CD/CC cost
- Defers Option 4's premature structural commitment while leaving it available as a future restructure trigger

---

## The chosen approach (Option 5) — detailed execution plan

### Step 1: Finish the 355 outline compliance

Already in flight at decision time (CC executing `c2_1_outline_compliance_prompt.md`). Completes per normal protocol. CD Phase 2 review archives the 355 task quad (prompt + completion + compliance prompt + compliance) to `docs/tasks/completed/` with a "shelved pending 355 implementation" disposition note.

The 355 outline document itself (`docs/specs/GNC355_Functional_Spec_V1_outline.md`) stays in place — not moved, not deleted. It's the reference material for Step 2 and the seed for the eventual 355 spec resumption.

### Step 2: Harvest turn (CD, ~30 min)

CD walks the 355 outline producing `docs/knowledge/355_to_375_outline_harvest_map.md` — a section-by-section reusability categorization.

Categories:
- **Fully reusable** — sub-section is 100% unit-agnostic; 375 outline can reuse structure and page references verbatim (e.g., Map Page, Flight Plan page)
- **Partially reusable** — sub-section's core content is shared but has 355-specific or 375-specific embellishments to split out (e.g., Settings pages: CDI scale is shared, but "CDI On Screen toggle" is 375-only per page 89)
- **355-only** — sub-section has no 375 equivalent; skip entirely for 375 outline (e.g., §11 COM Radio, §4.11 COM Standby Control Panel, §13.9 COM radio advisories)
- **375-needs-new-content** — feature area that 355 outline omitted or underweighted; 375 outline needs fresh structure (e.g., XPDR section from pp. 75–85, ADS-B Out treatment, TSAA aural alerts)

Time-boxed explicitly: CD produces a sufficient map in one turn, not an exhaustive one. The harvest map is input to the CC outline task, not a standalone deliverable.

### Step 3: C2.1-375 task drafted (CD, one turn)

CD authors a CC task prompt for the 375 outline. The prompt:
- References the harvest map as the primary reusability guide
- Points at the 355 outline as reference material (CC can read it, but produces an independent new outline)
- Explicitly instructs XPDR (pp. 75–85) and ADS-B (In/Out, built-in) as primary concerns
- Calls out full procedural fidelity as an explicit target (approach operations spec'd with enough depth to support LPV approach flying)
- Specifies deliverable: `docs/specs/GNX375_Functional_Spec_V1_outline.md`
- Standard completion protocol (D-04 trailers, ntfy, etc.)

### Step 4: CC executes

Expected wall-clock similar to original C2.1 (~30–60 min) since CC works with similar source material (same PDF, same AMAPI knowledge base).

### Step 5: Check-completions + compliance on the 375 outline

Standard protocol. Produces the reviewed 375 outline.

### Step 6: C2.2 format decision (deferred per D-13)

After the 375 outline is in hand, CD makes the format decision (monolithic CRP / piecewise+manifest / one task per section) for C2.2. Logged as a separate D-NN entry when made.

### Step 7: C2.2 spec body authoring

Whatever format is chosen in Step 6 drives the CC sub-task(s) that produce the full 375 functional spec prose.

---

## Watched cons (carried forward as monitored risks)

These are the downsides of Option 5 that the decision accepts but continues to watch. If any turns into an actual problem during execution, it triggers re-evaluation.

### 1. Two-outline maintenance drift

If project scope changes and a section needs updating (e.g., AMAPI patterns we learn more about during 375 implementation that affect how we spec approaches), the same update applies to both the 355 outline (shelved) and the 375 outline (active). Drift between them is possible.

**Mitigation:** The 355 outline is shelved; it's not being actively maintained. Drift is only a concern at the moment 355 implementation resumes, at which point a "back-port insights from 375" CD task handles it. Acceptable.

**Tripwire:** if we find ourselves updating both outlines more than once during the 375 work, re-evaluate whether Option 4 (shared core + variants) would have been right.

### 2. Stale 355 outline

Insights gained during 375 work may not back-port unless explicitly checked when 355 resumes. Examples of insights that might matter: AMAPI pattern refinements observed during implementation, sim-integration gotchas that apply to both units, spec-review feedback that's structurally informative.

**Mitigation:** When 355 implementation resumes, CD's first turn in that workstream walks the 375 outline (and spec, if it exists by then) looking for back-portable content. Produces a short "355 outline update" turn. One-time cost.

**Tripwire:** none unless 355 implementation resumes.

### 3. Harvest-step scope creep

"Walk the 355 outline and categorize everything" could balloon into multi-turn work if CD tries to produce a perfect map instead of a sufficient one.

**Mitigation:** Time-box the harvest to one CD turn (~30 min). Produce a sufficient map, not a perfect one. The harvest map is a working tool for CC, not a published artifact.

**Tripwire:** if the harvest turn runs past 30 min and isn't obviously close to done, stop and produce whatever is in hand. Incomplete harvest map is still useful; perfect harvest map is not the goal.

### 4. Lost 75% content-sharing benefit (Option 4 deferred)

Option 5 accepts that ~75% of the content will be duplicated across the 355 and 375 outlines (and eventually the specs) rather than DRY-factored into a shared core per Option 4. If a third unit (GPS 175) ever comes into scope, the duplication grows.

**Mitigation:** Defer Option 4 as a possible future restructure. Spec-review on the 375 spec may surface "this spec has two clearly separable layers" — at which point Option 4 emerges as a structured refactor rather than a guess. If GPS 175 is ever in scope, that's a stronger Option 4 trigger.

**Tripwire:** spec-review on 375 spec flagging structural duplication concern, OR a third instrument unit being added to scope, OR 355 implementation resuming and the back-port effort being substantial enough to justify DRY refactor.

---

## Decisions this document supports

- D-12 (pivot from GNC 355 to GNX 375 primary instrument; Option 5 chosen)
- D-13 (C2.2 format decision still deferred; now applies to 375 outline)
- D-02 amendment (nomenclature correction + pivot reference)

## Decisions this document does NOT make

- The format decision for C2.2 — still deferred per D-13
- Whether to eventually adopt Option 4 — deferred; monitored via watched cons
- When 355 implementation resumes — indeterminate; driven by Steve's other project priorities

## Implementation plan update requirement

The original implementation plan (`docs/specs/GNC355_Prep_Implementation_Plan_V1.md`) now has a mis-named filename (references GNC 355) and §6.C2 content that targets the wrong unit. The plan update was already captured as ITM-06 at lower priority (wait-until-C2.2-format-is-locked); per the pivot, ITM-06's scope expands and priority rises. CD handles the plan update after C2.1 archive but before the harvest turn so the harvest operates against an up-to-date plan.
