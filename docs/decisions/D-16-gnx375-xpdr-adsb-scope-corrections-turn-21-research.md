# D-16: GNX 375 XPDR + ADS-B scope corrections (Turn 21 research)

**Created:** 2026-04-21T11:33:00-04:00
**Source:** Purple Turn 21 — XPDR + ADS-B deep-dive research executing Turn 20 option (a) (research-before-task-prompt)
**Decision type:** scope (corrects Turn 18's preliminary §11 structure with Pilot's Guide evidence)
**Refines:** Turn 18 harvest map §11 anticipated structure
**Research document:** `docs/knowledge/gnx375_xpdr_adsb_research.md`

## Background

Turn 18 harvest map anticipated a 13-sub-section §11 for the GNX 375 XPDR + ADS-B coverage, extrapolating from general knowledge of Garmin transponders. Several sub-sections were speculative. Turn 20 deferred XPDR deep-dive to keep focus on the navigation-role corrections. Turn 21 executes the XPDR research per Steve's "proceed with (a)" go-ahead.

## Decision

The GNX 375 §11 (Transponder + ADS-B Operation) is authored against pp. 75–82 of the Pilot's Guide plus cross-cutting ADS-B content from pp. 18, 225, 244, 282–284, 290. Pp. 83–85 are EXCLUDED from §11 scope — those pages cover GPS 175 / GNC 355 + GDL 88 ADS-B Altitude Reporting, which does not apply to the GNX 375.

Corrections from Turn 18 preliminary structure:

### Feature corrections
- **Ground and Test modes dropped** — do not exist in the GNX 375 UI. The 375 has three modes only: Standby, On, Altitude Reporting (p. 78). Altitude Reporting handles air/ground state automatically with no pilot action required.
- **Anonymous mode dropped** — applies only to GPS 175 / GNC 355 + GDL 88 (p. 84). Not available on GNX 375.
- **TSAA handling relocated** — TSAA is not a separate XPDR sub-section; it's part of the Traffic Awareness page (§4.9). The §11 sub-section reference is a cross-reference, not original content.
- **Flight ID editability clarified** — typically NOT editable by pilot; only if configured to be so at installation (pp. 77, 85).

### Fact corrections
- **TSO: C112e (Level 2els, Class 1)** — not C112d as written in Turn 18. Per Pilot's Guide p. 18.
- **IDENT duration: 18 seconds** — per p. 80. Turn 18 had this unspecified.
- **Altitude source: external dependency** — pressure altitude comes from external ADC/ADAHRS (p. 34); 375 itself does not measure pressure altitude. Turn 18 did not flag this. Must be documented in §15 External I/O.

### Structural corrections
- **14 sub-sections (not 13)** — added a dedicated XPDR Control Panel sub-section (11.2) covering the 5 UI regions and key visibility rules. Merged VFR key with IDENT (both live on p. 80). Split XPDR Alerts into Failure/Alert (11.12) and Advisory Messages (11.13) for cleaner coverage.
- **Estimated outline length: ~180 lines** — down from Turn 18's ~200 after the corrections.

### Out-of-scope directives
- **Remote XPDR control via G3X Touch: out of scope for v1 instrument.** The real unit supports it; the spec should document its existence but flag as not-in-v1. Prevents scope creep during implementation.

## Remaining open questions (carried to C2.1-375)

1. Exact XPL XPDR dataref names (design-phase verification)
2. MSFS XPDR SimConnect variable behavior differences between FS2020 and FS2024 (design-phase research)
3. TSAA aural alert delivery mechanism in Air Manager (spec-body design decision)
4. ADS-B In simulator data availability (XPL partial exposure; MSFS limited; spec must handle absent/degraded cases)

## Consequences

- `docs/knowledge/355_to_375_outline_harvest_map.md` updated in same turn with finalized §11 structure.
- `docs/knowledge/gnx375_xpdr_adsb_research.md` created as authoritative research reference.
- C2.1-375 task prompt (upcoming CD work) will reference D-16 and this research document for the §11 authoring.
- Research layer for 375 outline is now COMPLETE — Turn 20 (navigation role) + Turn 21 (XPDR/ADS-B) together give comprehensive Pilot's Guide coverage for the 375 outline authoring.

## What this decision does NOT change

- §11 sub-section count (14) is for the outline; spec body (C2.2) may further decompose.
- Overall harvest categorization (8 [FULL], 7 [PART], 2 [355], 1 major [NEW]) unchanged.
- D-13 format deferral still applies.
- Scope expansion from D-12 (XPDR + ADS-B + full procedural fidelity) unchanged — D-16 refines the XPDR sub-scope within that commitment.

## Related

- D-12 (pivot decision; Q2 scope expansion for XPDR + ADS-B)
- D-14 (Turn 19 audit of procedural fidelity items)
- D-15 (Turn 20 navigation-role corrections)
- `docs/knowledge/gnx375_xpdr_adsb_research.md` (authoritative research)
- `docs/knowledge/gnx375_ifr_navigation_role_research.md` (Turn 20 companion research)
- `docs/knowledge/355_to_375_outline_harvest_map.md` (updated per D-16)
