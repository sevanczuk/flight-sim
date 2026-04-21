# D-12: Pivot primary instrument from GNC 355 to GNX 375; scope expansion; Option 5 approach

**Created:** 2026-04-21T08:57:03-04:00
**Source:** Purple Turn 14–16 — Steve clarified the real-world motivation: the two C172s he flies have a GNX 375 (flown more often) and a GNC 355 (flown less often); prior "GNC 355" focus was a scoping error rooted in a nomenclature mix-up ("GNC" instead of "GNX")
**Decision type:** scope / approach (pivots D-02; amends C2 sub-task structure from D-11)
**Amends:** D-02 (§9 family-delta reference to "GNC 375" corrected; baseline instrument changed)
**Companion document:** `docs/specs/pivot_355_to_375_rationale.md` (full option analysis and pros/cons)

## Decision

Three coupled changes:

**1. Primary instrument pivots from GNC 355 to GNX 375.**

The project's goal is to replicate the real-world avionics in the two C172s Steve flies. The more-frequently-flown aircraft has a GNX 375 (GPS/MFD + Mode S transponder + built-in dual-link ADS-B In/Out; no COM). The GNC 355 (GPS/MFD + VHF COM; no transponder or ADS-B) is in the second aircraft.

**2. Scope expansion beyond original D-02.**

- **XPDR section added:** Transponder operation (pp. 75–85 of the Pilot's Guide), including squawk code entry, mode selection (Standby/On/Altitude Reporting), Flight ID, Extended Squitter ADS-B Out at 1090 MHz.
- **ADS-B treatment upgraded:** ADS-B In/Out is built-in on the GNX 375 (no external GDL 88 or GTX 345 required). Weather (FIS-B) and traffic (TSAA with aural alerts) are primary concerns, not external-dependent secondary features as they would be for the GNC 355.
- **Full procedural fidelity target confirmed (per Turn 15 Q3c):** the spec supports flying instrument approaches in the sim — LPV/LNAV/LPV+V mode transitions, GPS flight phase annunciations, autopilot coupling via roll steering, ADS-B traffic during approach, transponder altitude reporting.

**3. Execution approach: Option 5 (harvest 355 outline + author dedicated 375 outline).**

Five options were considered in Turn 14–15 (Option 1 restart, Option 2 rebadge, Option 3 parallel outlines, Option 4 shared-core-plus-variants, Option 5 harvest+new). Full analysis with pros/cons per option is in the companion rationale document (`docs/specs/pivot_355_to_375_rationale.md`).

Option 5 chosen because:
- Full procedural fidelity (Q3c) benefits from 375 as first-class primary rather than 355-adapted
- 355 deferral uncertainty favors self-contained preservation of the 355 outline rather than coupling it as an appendix
- The harvest step is cheap CD work (one turn), not expensive CC re-authoring
- Starting the 375 outline from scratch (with harvest map as reference) forces explicit coverage of every 375 feature rather than risking shoehorn effects

Option 2 (rebadge with 355 as delta appendix) was the original CD recommendation (Turn 14) based on minimum-re-authoring-cost optimization; re-evaluated in Turn 15 as optimizing the wrong target given Steve's stated priorities.

## What this means in practice

### For the in-flight C2.1 (355 outline) work:

- C2.1 compliance check completes normally (already in-flight at decision time).
- Outline task pair + compliance pair archive to `docs/tasks/completed/` with a "shelved pending 355 implementation" disposition.
- The outline document itself (`docs/specs/GNC355_Functional_Spec_V1_outline.md`) stays in place as a future reference for the eventual 355 spec work.

### For the 375 primary work:

- New harvest CD task: CD walks the 355 outline producing a section-by-section reusability map saved at `docs/knowledge/355_to_375_outline_harvest_map.md`. Categories: fully-reusable / partially-reusable / 355-only / 375-needs-new-content. Time-boxed to ~30 min; produces a "sufficient" map, not an exhaustive one.
- New CC task `GNC355-SPEC-OUTLINE-01`'s successor: `GNX375-SPEC-OUTLINE-01` (or similar naming — to be finalized when prompt is drafted). CC authors a dedicated 375 outline using the harvest map as reference material plus the XPDR/ADS-B PDF sections that were out of scope for the 355 outline. Full procedural fidelity target gets explicit prompt-level instructions.
- D-13 (format decision for C2.2) deferred from D-11 applies to the 375 outline's size and structure, not the 355 outline's.

### For the eventual 355 deferred work:

- 355 outline preserved as-is in `docs/specs/GNC355_Functional_Spec_V1_outline.md`.
- When 355 implementation resumes (indeterminate future), CD walks the 375 outline looking for back-portable insights (patterns learned during 375 work that should update the 355 outline).
- The 355 spec body authoring (equivalent of the original C2.2 for the 355) happens as a separate workstream after 375 is fully productive.

## Watched cons (from Option 5 analysis)

Carried forward as risks to monitor during 375 execution. Full details in companion rationale document §"Watched cons." Summary:

1. **Two-outline maintenance drift** — if scope changes require updating both outlines, we do it twice. Rare event; acceptable cost.
2. **Stale 355 outline** — insights gained during 375 work may not back-port unless explicitly checked. Mitigated by a one-turn back-port CD task when 355 resumes.
3. **Harvest-step scope creep** — "walk the 355 outline" could balloon into multi-turn work if not time-boxed. Mitigated by explicit 30-min cap.
4. **Lost 75% content-sharing benefit** — Option 4 would DRY-factor shared content; Option 5 duplicates. Mitigated by deferring Option 4 as a possible future restructure if spec-review surfaces it.

## Nomenclature correction

D-02 §9 referenced "GNC 375" as a sibling unit. This was a typo/transcription error. The correct designation is **GNX 375** (no "C"; "X" for the transponder/ADS-B extensions). The correct nomenclature for this project going forward is:

- **GPS 175** — GPS/MFD only (no COM, no XPDR)
- **GNC 355 / GNC 355A** — GPS/MFD + VHF COM (no XPDR). "GNC" = Garmin Navigator Communicator. 355A variant adds 8.33 kHz channel spacing.
- **GNX 375** — GPS/MFD + Mode S transponder + built-in dual-link ADS-B In/Out (no COM). "GNX" = Garmin Navigator eXtended (with transponder/ADS-B).

D-02 is amended via a small addendum per Steve's Turn 16 request.

## Consequences

- `docs/decisions/D-02-gnc355-prep-scoping.md` gets a small addendum at the top acknowledging the nomenclature error and the pivot (Steve's Turn 16 direction: amend D-02 in-place rather than superseding, since D-02's stream structure still holds). Reference to D-12 added.
- `docs/specs/pivot_355_to_375_rationale.md` created this turn as the companion document holding full option analysis.
- `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` §6.C2 becomes more stale. Plan update is now higher-priority than ITM-06's earlier "wait until C2.2 format is locked" rationale anticipated — the entire C stream's target unit has shifted. Plan update is logged as ITM-06 (amended scope) or a new ITM.
- Claude.ai memory may benefit from a slot noting the 375 pivot, so future CD sessions don't regress to 355-primary language. Add via `memory_user_edits` same turn as this decision lands if a slot is available.
- Status documents (`Spec_Tracker.md`, `CC_Task_Prompts_Status.md`, `priority_task_list.md`) become stale after the pivot takes effect. `check updates` command should be run at a natural seam.

## Related

- D-01 (project scope — X-Plane primary, MSFS secondary; still valid; unit pivot is orthogonal)
- D-02 (GNC 355 prep scoping — amended in-place per this decision)
- D-11 (C2 delivery format deferred — still valid; now applies to 375 outline's size/structure)
- `docs/specs/pivot_355_to_375_rationale.md` (companion: full option analysis + pros/cons + watched cons)
- `docs/specs/GNC355_Functional_Spec_V1_outline.md` (the 355 outline — shelved pending 355 implementation; not deleted)
- ITM-06 (implementation plan update — scope amended by this pivot)
