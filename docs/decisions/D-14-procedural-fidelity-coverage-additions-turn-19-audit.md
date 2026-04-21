# D-14: Procedural fidelity coverage additions for GNX 375 outline (Turn 19 audit)

**Created:** 2026-04-21T10:46:54-04:00
**Source:** Purple Turn 19 — audit of harvest map against D-12 Q3c "full procedural fidelity" target
**Decision type:** scope (expands D-12 Q3c coverage with specific feature enumerations)
**Refines:** D-12 (which specified "full procedural fidelity" abstractly); this decision enumerates what that means for the 375 outline

## Context

D-12's Q3c scope commitment stated "full procedural fidelity including LPV approach flying." The harvest map from Turn 18 surfaced the XPDR + ADS-B interaction items (items 8–10) but did not enumerate the broader procedural-fidelity feature set. Steve's Turn 19 question ("does the outline cover glideslope + glidepath guidance? track, time-to-turn, turn alert, etc.") surfaced two gap clusters:

1. **Vertical guidance coverage** — the 355 outline lists LNAV+V/LP+V/LPV/LNAV-VNAV as flight phases but does not detail the pilot-facing vertical guidance experience (VDI display, advisory vs. primary vertical distinction, ILS monitoring display behavior, mode transitions, CDI/VDI scale changes).
2. **Full procedural features** — turn anticipation / waypoint sequencing alerts, fly-by vs. fly-over turn behavior, active leg transition feedback, ARINC 424 leg type handling, altitude constraints on legs, approach arming/activation state machine, explicit CDI deviation display, To/From flag rendering, autopilot coupling during approach.

## Decision

The harvest map's §7 procedural fidelity augmentations list expands from 3 items (XPDR/ADS-B interactions only) to 18 items organized in 3 sub-clusters:

- **(A) XPDR + ADS-B interactions during approach** (3 items, unchanged from Turn 18): altitude reporting, ADS-B traffic during approach, ADS-B Out transmission during approach.
- **(B) Vertical guidance fidelity** (6 items, new in Turn 19): VDI display specification; glidepath vs. glideslope terminology framing; advisory vs. primary vertical distinction; ILS approach display behavior for GPS monitoring; approach mode transitions (LPV→LNAV downgrade etc.); CDI scale auto-switching by flight phase.
- **(C) Full procedural features** (9 items, new in Turn 19): turn anticipation / waypoint sequencing alerts; fly-by vs. fly-over turn behavior; active leg transition visual feedback; ARINC 424 leg type handling; altitude constraints on flight plan legs; approach arming vs. active states; CDI deviation display rendering; To/From flag rendering; autopilot coupling during approach.

These items are authoritative additions to the 375 outline scope and must be covered by the C2.1-375 task prompt.

## Estimated spec impact

Adds ~160 lines to the 375 outline (items 11–25, averaging ~10 outline lines each). Revised 375 outline length estimate: 2,900–3,000 lines (up from 2,750–2,850 per Turn 18). Spec body impact is larger — each outline line typically expands to 1–3 spec body lines, so the C2.2 target grows proportionally.

## What this decision does NOT do

- Does not re-open the format decision (D-13 still defers C2.2 format pending 375 outline review).
- Does not add new sections to the 375 outline structure beyond §7 augmentations (and possibly a new §4.x sub-section for a dedicated VDI display area if the GNX 375 hardware uses one — determined during C2.1-375 authoring).
- Does not expand the Pilot's Guide page scope beyond what was already in the 355 outline and the Turn 18 harvest map addition of pp. 75–85 for XPDR. Items 11–25 draw from pages already in scope.

## Research needs flagged

Several items 11–25 reference behaviors where the Pilot's Guide may not provide complete coverage. C2.1-375 will flag these as open questions:

- VDI display location on the 375 screen (pp. 89 "CDI On Screen" gives the CDI location; the VDI may be co-located or separate — PDF review required)
- Full-scale VDI deflection values (typical published values: ±150 ft at FAF for LPV; may or may not be in the Pilot's Guide)
- ARINC 424 leg type enumeration (the Pilot's Guide may not list all supported leg types explicitly; may need to infer from procedure examples)
- Turn anticipation timing (typical 10-second advance; Pilot's Guide may or may not specify exact timing)
- Approach arming vs. active state transition details (Pilot's Guide likely covers this in the approach operation section; needs verification)

## Consequences

- `docs/knowledge/355_to_375_outline_harvest_map.md` updated this turn with items 11–25 in the Procedural fidelity augmentations cluster.
- C2.1-375 task prompt (still to be drafted) must include explicit instructions to cover items 11–25, with authorization to flag items as open questions where Pilot's Guide coverage is incomplete.
- Pivot rationale document's watched-cons list gains an implicit addition: "full procedural fidelity scope may expand further during C2.1-375 authoring if items 11–25 surface additional sub-items." Not formally added to watched cons but worth monitoring.

## Related

- D-12 (pivot decision; Q3c full-procedural-fidelity target that D-14 operationalizes)
- `docs/knowledge/355_to_375_outline_harvest_map.md` §"Procedural fidelity augmentations" (the authoritative item list)
- `docs/specs/GNX375_Prep_Implementation_Plan_V2.md` (plan remains valid; D-14 is a scope refinement within Stream C)
