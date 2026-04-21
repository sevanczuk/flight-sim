# D-15: GNX 375 display-output architecture \u2014 internal vs. external instrument boundaries (Turn 20 research)

**Created:** 2026-04-21T11:21:43-04:00
**Source:** Purple Turn 20 \u2014 Steve challenged Turn 19 audit's assumption that the 375 has a primary CDI/VDI display; research into Pilot's Guide confirmed the 375's display is narrower than Turn 19 implied
**Decision type:** scope (refines D-14's procedural-fidelity item list with corrected display-architecture mental model)
**Refines:** D-14 (Turn 19 audit items 11\u201325); amends 4 items, drops 1 item, reframes 1 item as open question
**Research document:** `docs/knowledge/gnx375_ifr_navigation_role_research.md`

## Background

Turn 19's audit added 15 procedural-fidelity items (11\u201325) under \u00a77 of the harvest map, assuming the GNX 375 has primary CDI and VDI displays of its own that need on-screen specification. In Turn 20, Steve corrected this: in his real-world setup, lateral and vertical guidance is displayed on a separate external CDI instrument, and the 375's role is primarily flight plan management + track to next point + turn timing.

Steve's direction: "don't guess. perform research necessary to determining this." Research executed in-turn (CD Python reads against the extracted PDF JSON, 24 pages read in full, 30+ keyword searches).

## Findings (authoritative per research document)

The GNX 375's display architecture has three categories of pilot-visible output:

1. **On-375 display (always present):** Map, FPL list, Direct-to, Waypoint info, Nearest, Procedures, Planning, Hazard Awareness (Weather/Traffic/Terrain), Settings/System, Home, XPDR page. Annunciator bar (flight phase, CDI scale mode, FROM/TO field). Message queue. Pop-ups ("Arriving at Waypoint," "Missed Approach Waypoint Reached," Time to Turn advisory with 10-second countdown). GPS NAV Status indicator key (lower right corner, from-to-next route info \u2014 GPS 175 + GNX 375 only).

2. **On-375 display (optional, user-toggled):** "CDI On Screen" (GPS 175 + GNX 375 only, p. 89). Small lateral-only CDI with deviation indicator, below the GPS NAV Status key. Requires active flight plan. Uses the CDI Scale setting from Pilot Settings. No vertical component.

3. **External instrument output:** Lateral deviation (to external CDI/HSI), vertical deviation (to external CDI/VDI \u2014 Pilot's Guide p. 205 confirms "Only external CDI/VDI displays provide vertical deviation indications"), course/DTK, TO/FROM flag, roll steering (to compatible autopilots KAP 140 / KFC 225 only, pp. 183 + 207), LPV glidepath capture guidance (to autopilot when APR Output enabled).

**Key implication:** the GNX 375 does NOT display a VDI / glidepath needle / glideslope needle of any kind internally. Vertical guidance is exclusively output to external instruments. The 375's internal vertical-related display is limited to:
- Flight phase annunciations (LNAV+V / LP+V / LPV / LNAV/VNAV) on the annunciator bar
- Downgrade messages in the message queue ("GPS approach downgraded. Use LNAV minima.")
- Mode transition annunciations (e.g., Terminal \u2192 LPV at FAF)

## Decision

Amend the harvest map's procedural-fidelity items (11\u201325) per the following re-classification, with the corrections already applied to `docs/knowledge/355_to_375_outline_harvest_map.md` this turn:

### Item 11 \u2014 DROP as on-screen feature; relocate to \u00a715 External I/O

Original Turn 19 scoping: "Vertical Deviation Indicator (VDI) display \u2014 where on the 375's screen the VDI needle appears..."

**Corrected:** the 375 has no on-screen VDI. Replaced by a \u00a715 External I/O entry specifying the output contract (dataref/event names for vertical deviation, update rate, scale semantics in feet). No on-375 rendering is to be specified.

### Items 14, 16, 23, 24 \u2014 REFRAMED

Each originally assumed on-375 rendering; each is now scoped correctly:

- **14 (ILS approach display):** pop-up behavior + annunciator-bar message; external CDI follows NAV receiver; no on-375 VDI concerns (item 11 dropped).
- **16 (CDI scale auto-switching):** documents both the output contract to external CDI AND the on-annunciator-bar + optional-on-screen-CDI display sides.
- **23 (CDI deviation display):** distinguishes the optional on-screen lateral CDI (small, below GPS NAV Status key, lateral-only, toggle-able) from the primary external CDI/HSI.
- **24 (TO/FROM flag):** annunciator-bar FROM/TO field (p. 183) as authoritative for the pilot; external CDI TO/FROM output is secondary; composite-CDI caveat documented.

### Item 21 \u2014 REFRAMED AS OPEN QUESTION

Original: "altitude constraints on flight plan legs... Spec needs this coverage."

**Corrected:** Pilot's Guide does not prominently document automatic display of published procedure altitude restrictions. VCALC (pp. 211\u2013212) is pilot-input, not automatic. Spec flags this as "behavior not documented in extracted PDF; research needed or flag as unknown." The 375 outline will include this as an explicit open question rather than asserting a feature specification.

### Items 12, 13, 15, 17, 18, 19, 20, 22, 25 \u2014 KEEP AS-IS

These items are correctly scoped as the 375's responsibility (annunciations, advisories, mode transitions, turn countdowns, waypoint sequencing, autopilot coupling per p. 207). No changes needed.

## What this decision confirms

- **Steve's hypothesis was correct.** The 375's primary pilot-facing role is flight plan management + track guidance + turn timing + approach phase annunciation. Tactical needle-watching is the external CDI's job.
- **The \"Time to Turn\" feature is real** (pp. 200, 202): 10-second countdown timer annunciates as the aircraft approaches a turn waypoint during approach. This is exactly the "timing for turn to new heading" Steve described.
- **The GPS NAV Status indicator key is the 375's primary strategic display** for from-to-next routing info.

## What this decision does NOT change

- The XPDR + ADS-B new \u00a711 scope (Turn 18 harvest items 1\u201310 + the major new section) remains fully valid. XPDR IS displayed on the 375 natively (dedicated XPDR page, pp. 75\u201385); this is different from the CDI/VDI situation.
- The overall 5 categories of harvest categorization: 8 [FULL], 7 [PART], 2 [355], 1 major [NEW] \u2014 unchanged.
- The format decision (D-13) still deferred pending 375 outline review.
- Approach procedural semantics \u2014 the 375 handles LPV/LP/LNAV/etc. just as the 355 outline implied; the correction is about WHERE the pilot sees the results, not WHAT the unit computes.

## Estimated impact on 375 outline

- Item 11 removed as on-screen spec \u2014 saves ~15 outline lines
- Items 14, 16, 23, 24 reframed \u2014 slightly more content per item (dual-side coverage) but clearer scoping
- Item 21 becomes open question \u2014 saves ~10 lines of speculative spec
- Net: outline length estimate revised DOWN from 2,900\u20133,000 (Turn 19) to 2,800\u20132,900 (Turn 20), roughly comparable to the 355 outline

## Open research items carried forward to C2.1-375

Per the research document \u00a7"Open Research Items for C2.1-375 Authoring":

1. Altitude constraints on flight plan legs (item 21 \u2014 unknown from PDF)
2. ARINC 424 leg type enumeration (item 20 \u2014 Pilot's Guide examples don't enumerate)
3. Fly-by vs. fly-over turn geometry details (item 18 \u2014 thin PDF coverage)
4. Full XPDR section coverage (pp. 75\u201385 not researched in Turn 20's deep-dive; recommended for a separate research turn before C2.1-375 drafting OR embedded in the CC task prompt as a research directive)
5. ADS-B In/Out sim-API integration specifics (beyond PDF scope; design-phase research)

## Consequences

- `docs/knowledge/355_to_375_outline_harvest_map.md` updated in the same turn (items 11, 14, 16, 21, 23, 24 reworded; Turn 20 correction note added to summary)
- `docs/knowledge/gnx375_ifr_navigation_role_research.md` created as authoritative research reference
- C2.1-375 task prompt (upcoming CD work) must reference D-15 and the research document, explicitly instructing CC to NOT specify on-375 VDI and to scope CDI coverage per the two-mode (optional on-screen + external output) architecture

## Related

- D-12 (the pivot decision to GNX 375 primary)
- D-14 (Turn 19 audit that introduced items 11\u201325; D-15 refines that audit)
- `docs/knowledge/gnx375_ifr_navigation_role_research.md` (authoritative research)
- `docs/knowledge/355_to_375_outline_harvest_map.md` (updated per D-15)
- Pilot's Guide page references: 87 (CDI Scale), 88 (HAL), 89 (CDI On Screen), 145 (OBS), 147 (Parallel Track external CDI), 158 (GPS NAV Status key), 183 (Roll Steering external CDI TO/FROM), 198 (ILS monitoring only), 200 (LPV walkthrough + Time to Turn), 202 (LP walkthrough + Time to Turn), 205 (VDI external only), 207 (Autopilot Outputs)
