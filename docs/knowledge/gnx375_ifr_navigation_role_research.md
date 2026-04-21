# GNX 375 IFR Navigation Role — Research Findings

**Created:** 2026-04-21T11:21:43-04:00
**Source:** Purple Turn 20 — research task in response to Steve's correction that the GNX 375 does not have its own CDI capability beyond limited on-screen rendering
**Method:** Direct read of `assets/gnc355_pdf_extracted/text_by_page.json` — pages systematically searched for CDI, HSI, VDI, glidepath, glideslope, roll steering, external navigator, course/vertical deviation, autopilot, and specific approach-phase terms. Key pages read in full.
**Purpose:** Authoritative reference for what the GNX 375 itself does vs. what external instruments do during IFR operations. Input to correcting the Turn 19 harvest map procedural-fidelity items 11–25.

---

## Executive Summary

**Steve's hypothesis is correct.** The GNX 375's primary pilot-facing role in IFR navigation is:

1. **Build and manage flight plans** (direct-to, departures, arrivals, approaches, waypoint sequencing)
2. **Present track guidance** to the next waypoint via the GPS NAV Status indicator key (lower right of display) and Map page data fields (DTK, ETE, ETA, DIS, etc.)
3. **Provide waypoint sequencing and turn advisories** — including the explicit "Time to Turn" advisory with a 10-second countdown timer as the aircraft approaches a turn waypoint
4. **Annunciate flight phase and mode transitions** (ENR, TERM, LNAV, LNAV+V, LPV, LP, LP+V) on the annunciator bar
5. **Display messages** for waypoint arrival, approach downgrades, and GPS integrity events
6. **Output navigation guidance** (lateral deviation, vertical deviation, course, roll steering) to **external CDI/HSI/VDI/autopilot** instruments — NOT rendered as primary on-screen needles on the 375 itself

**The 375 does NOT natively display:**
- A primary CDI deviation needle (external CDI/HSI is the pilot's primary lateral reference)
- A VDI / glidepath / glideslope needle of any kind ("Only external CDI/VDI displays provide vertical deviation indications" — page 205)

**The 375 DOES natively display (optional or always-on):**
- An optional small on-screen lateral CDI with scale, below the GPS NAV Status indicator key ("CDI On Screen" toggle, GPS 175 + GNX 375 only) — **lateral only, no vertical**
- The GPS NAV Status indicator key showing from-to-next route info
- The annunciator bar (flight phase, CDI scale mode, FROM/TO field)
- Map, FPL list, and other pages with active-leg highlighting

---

## Definitive Findings by Topic

### 1. CDI (Course Deviation Indicator)

**Primary CDI is external.** Multiple Pilot's Guide passages confirm the 375 interfaces with an external CDI or HSI as the primary lateral deviation display:

- Page 145 (OBS): "set the desired course To/From a waypoint using the provided controls or with an **external OBS selector on HSI or CDI**."
- Page 147 (Parallel Track): "The aircraft navigates to the offset track with **external CDI/HSI guidance** now driven from the parallel track."
- Pages 201 and 203 (LPV and LP approach walkthroughs): "Pilot flies toward missed approach point, **keeping the needle on the external CDI (or HSI) at center**"
- Page 183 (Roll Steering Autopilots): discusses how the 375 interfaces with composite CDIs — "When interfaced to a composite type CDI, the composite CDI flag shows only 'TO' indications."

**Optional on-screen CDI is limited to lateral deviation.** Page 89 defines "CDI On Screen" (available only on GPS 175 and GNX 375, not GNC 355):

> "Toggling this setting displays the CDI scale on screen. When active, a CDI with **lateral deviation indicator** displays below the GPS NAV Status Indicator key."

Critically: "The CDI provides no indications without an active flight plan." So the on-screen CDI is:
- Optional (user-toggled)
- Lateral only
- Requires an active flight plan
- Shown below the GPS NAV Status indicator key in the lower portion of the display
- Uses the CDI Scale setting from p. 87 (0.30 / 1.00 / 2.00 nm or Auto)

**CDI scale is pilot-configurable AND auto-ranges by flight phase.** Page 87 establishes the scale semantics:
- Auto (default) sets 2.0 nm en route, linearly ramps down to 1.0 nm over the last 1 nm before entering the 31 nm terminal area
- Departure: 1.0 nm once aircraft is 30+ nm from departure, ramps up to 2 nm as phase changes from terminal to en route
- 2.0 nm before FAF: scaling tightens from 1.0 nm to the approach-defined **angular full-scale deflection** (typically 2.0°)
- Selecting 0.3 or 1.0 nm manually prevents higher scales during any phase
- Page 88 (HAL): Horizontal Alarm Limits follow CDI scale; different per flight phase (Approach 0.30 nm, Terminal 1.00 nm, En Route 2.00 nm, Oceanic 2.00 nm)

The 375 applies these scales when **outputting deviation to the external CDI**. The on-screen CDI (if enabled) also uses these scales.

---

### 2. VDI / Glidepath / Glideslope — NOT DISPLAYED ON THE 375

**This is the key clarification.** Page 205 (Visual Approach, under FEATURE LIMITATIONS) states unambiguously:

> "**Only external CDI/VDI displays provide vertical deviation indications**"

This applies to visual approaches and — by the pattern of the Pilot's Guide — to all GPS vertical guidance (LPV, LP+V, LNAV+V, LNAV/VNAV).

**Vertical guidance semantics:**
- **Glideslope** (Garmin usage per glossary p. 301): ILS-related, radio-beam vertical guidance from a ground station. The 375 cannot receive or display this — it does not have a NAV receiver. (Page 198: "ILS and LOC approaches are not approved for GPS. GPS guidance is for monitoring purposes only.")
- **Glidepath** (Garmin usage per glossary p. 301): GPS-derived vertical guidance for LPV/LP+V/LNAV+V approaches. The 375 CAN compute glidepath — but **outputs the glidepath deviation to external instruments, not to its own screen**.

**What the 375 DOES display regarding vertical approaches:**
- Flight phase annunciations (LNAV+V, LPV, LP+V, LNAV/VNAV) on the annunciator bar (p. 184)
- Mode transitions as annunciations (e.g., "Mode switches from Terminal to LPV" at the FAF, p. 200)
- Downgrade messages: "GPS approach downgraded. Use LNAV minima." (p. 201); "Glideslope indication disappears" (p. 201 — this describes what the pilot sees on the external glideslope/glidepath display, not on the 375)
- Vertical calculation on the VCALC Planning page (pp. 211–212) — but this is TOD/VS-required calculation, NOT real-time vertical guidance
- The "Enable APR Output" advisory (p. 207) for compatible autopilots (KAP 140, KFC 225) — confirming the 375 outputs approach guidance including glidepath to the autopilot

---

### 3. Autopilot Coupling / Roll Steering

Page 207 (Autopilot Outputs) clarifies the autopilot interface:

> "Outputs for the King KAP 140/KFC 225 autopilot units require manual activation. If configured, this function prompts you to enable autopilot outputs during the approach procedure."
>
> "Once enabled, the unit provides guidance information consistent with what the autopilot expects (i.e., **angular CDI scaling and glideslope capture for LPV or other vertically guided GPS approaches**)."

- Roll steering (GPSS) is OUTPUT to compatible autopilots
- LPV glidepath capture is ALSO OUTPUT to compatible autopilots
- Page 183: "Roll steering terminates when approach mode is selected on the autopilot. It becomes available once you initiate the missed approach."
- This is configuration-dependent; not all installations have autopilot coupling enabled.

---

### 4. Turn Advisories — CONFIRMED FEATURE

**The 375 explicitly provides "Time to Turn" advisories with a 10-second countdown.** Found at pages 200 and 202 within the LPV and LP approach walkthroughs:

> Approaching initial approach fix:
> - Waypoint message annunciates
> - **Time to Turn advisory annunciates and 10 second timer counts down as the distance approaches zero**

Similar pattern for LP approach (p. 202): "Turn direction message annunciates / Time to Turn advisory annunciates and 10 second timer counts down as the distance approaches zero"

This directly confirms Steve's description: the 375 provides "timing for turn to new heading." The advisory is a message annunciation on the 375's screen with a countdown timer.

**Related waypoint advisories** (pp. 201, 203):
- "Arriving at Waypoint" advisory message as the aircraft approaches the missed approach point
- "Missed Approach Waypoint Reached" pop-up at MAP crossing, with options to Remain Suspended or Activate GPS Missed Approach

---

### 5. Track Guidance — CONFIRMED

**The 375 presents track to next point via the GPS NAV Status indicator key** (GPS 175 + GNX 375 only, per p. 158):

> "Located in the lower right corner of the display, the GPS NAV Status indicator key displays **from-to-next route information** when an active flight plan exists."
>
> States:
> - No flight plan: acts as direct access to flight plan page
> - Active flight plan, no CDI on screen: full from-to-next display with active leg status
> - Active flight plan, CDI on screen: **from-to waypoints only** (space constrained by CDI)

Track info is also available in **Map page data corner fields** (DTK, TRK, DIS, ETE, ETA, BRG, etc., per 355 outline §4.2) and in **FPL page leg data columns** (ETE, ETA, DTK per leg, 355 outline §4.3).

---

### 6. Approach Mode Transitions — CONFIRMED AS 375 ANNUNCIATIONS

Page 200 (LPV approach walkthrough) walks through the full transition sequence:

1. Within 31 nm of destination: Mode switches from En Route to Terminal; CDI scale transitions from 2.0 nm to 1.0 nm
2. Approaching IAF: Waypoint message + Time to Turn advisory
3. Approaching FAF: Mode switches from Terminal to LPV
4. 2.0 nm from FAF: CDI scaling tightens from 1 nm to approach-defined angular full-scale deflection
5. 60 seconds before FAF: System verifies GPS position integrity within approach limits
6. Integrity exceeds limits: Approach downgrades to non-precision; "LNAV" annunciates; advisory message

All of these are **annunciations on the 375's screen** (annunciator bar + message queue). The actual deviation indications during the approach are on the external CDI/HSI/VDI.

---

### 7. ILS Approaches — GPS MONITORING ONLY

Page 198 (ILS Approach):

> "ILS and LOC approaches are not approved for GPS. GPS guidance is for monitoring purposes only."
>
> "Selecting an ILS or LOC approach results in a pop-up message. Activate the approach or select a different one."
>
> "Do not attempt to use the unit as the primary navigation source during ILS approach."

For ILS approaches loaded into the flight plan, the 375 provides lateral GPS guidance as a monitor; the actual lateral and vertical guidance comes from the ILS receiver (separate NAV radio) and is displayed on the external CDI.

---

### 8. Fly-by vs. Fly-over Waypoints

Page 157 ("Fly-over Waypoint Symbol") is referenced in the 355 outline §4.3. The Pilot's Guide has a distinct symbol for fly-over waypoints. The behavioral distinction (anticipate-and-cut-corner vs. overfly-then-turn) is standard Garmin nav behavior but not deeply elaborated in the extracted PDF text — likely in figure captions.

---

### 9. Parallel Track, OBS, Direct-to, Procedures

All shared across all three units (GPS 175, GNC 355, GNX 375) per the Pilot's Guide structure. No 375-specific differences identified beyond the CDI-On-Screen and GPS-NAV-Status-Key differences already covered.

---

### 10. Altitude Constraints

Altitude constraints on flight plan legs (published procedure altitudes) are **not prominently featured** in the extracted text. VCALC is a separate planning tool on Planning pages (pp. 211–212) for TOD-to-target-altitude calculations — but this is user-input, not automatic from the published procedure.

The Pilot's Guide does not appear to describe automatic display of published altitude restrictions in the flight plan. If the 375 has this capability, it's not documented in the extracted content. **Spec should flag as an open research question** rather than assume the feature exists.

---

## Summary Table — What the 375 Does vs. What External Instruments Do

| Navigation function | 375 internal display | External instrument | Driven by 375? |
|---|---|---|---|
| Track/DTK to next waypoint | YES — GPS NAV Status key, Map data fields, FPL page | N/A | Yes |
| Distance/ETE/ETA to next waypoint | YES — same as above | N/A | Yes |
| Cross-track error (XTK) — numeric | YES — optional Map data field | N/A | Yes |
| Lateral deviation needle (CDI) | OPTIONAL only — "CDI On Screen" toggle, small display below GPS NAV Status key, lateral only | PRIMARY — external CDI/HSI | Yes (drives external) |
| Vertical deviation (VDI/glidepath) | NO — confirmed p. 205 | PRIMARY — external CDI/VDI | Yes (drives external) |
| Glideslope (ILS radio vertical) | NO — 375 cannot receive ILS | PRIMARY — external CDI/HSI via NAV receiver | No (not connected) |
| Flight phase annunciations | YES — annunciator bar | (annunciator bar only) | N/A |
| CDI scale annunciation | YES — annunciator bar and GPS NAV Status key | N/A | Yes (drives external CDI scale) |
| FROM/TO flag (numeric) | YES — annunciator bar FROM/TO field | PRIMARY — external CDI | Yes |
| Waypoint "Arriving at Waypoint" advisory | YES — message queue | N/A | N/A |
| Turn advisory ("Time to Turn" with countdown) | YES — message annunciation + 10-sec countdown | N/A | N/A |
| Approach mode transitions (LPV→LNAV etc.) | YES — annunciator bar + advisory messages | (external CDI needle behavior changes accordingly) | Yes |
| Roll steering (GPSS) | N/A (not displayed; output only) | Compatible autopilot (KAP 140, KFC 225) | Yes |
| Map page with active leg | YES — primary display feature | N/A | N/A |
| Flight plan page (list view) | YES — primary display feature | N/A | N/A |
| Procedures pages (approach loading) | YES | N/A | N/A |

---

## Corrections to Turn 19 Harvest Map (Items 11–25)

Turn 19's audit added items 11–25 under §7 procedural-fidelity augmentations. Several over-reached by conflating "the 375 handles this" with "the 375 displays this natively." This section re-classifies each item per the Pilot's Guide evidence.

**Legend:**
- **KEEP-AS-IS** — item is correctly scoped as a 375 concern
- **REFRAME** — item is valid but needs rewording to distinguish on-375 display from external-output behavior
- **DROP** — item does not apply to the 375 (is an external-instrument concern)

| Item | Turn 19 description | Reclassification | Notes |
|------|---------------------|------------------|-------|
| 11 | VDI display on 375 | **DROP** (as on-screen feature) / **REFRAME** as external-output spec | The 375 has no internal VDI; vertical deviation is always output to external CDI/VDI. Spec should document the output dataref/event contract, NOT an on-screen VDI rendering. |
| 12 | Glidepath vs. glideslope terminology | KEEP-AS-IS | Still needed in the spec as a terminology-framing note, especially since the on-375 annunciations use these terms. |
| 13 | Advisory vs. primary vertical distinction | KEEP-AS-IS | The 375 annunciates LNAV+V vs. LPV etc.; distinction must be in the spec for annunciator behavior. |
| 14 | ILS approach display behavior | REFRAME | The 375 DOES show a pop-up and flight phase annunciations during ILS; but the deviation needle is on the external CDI/HSI tied to the NAV receiver. Reframe to "annunciation-only on 375; external CDI follows NAV source." |
| 15 | Approach mode transitions | KEEP-AS-IS | Confirmed at pp. 200–203; the 375 annunciates these. |
| 16 | CDI scale auto-switching by flight phase | KEEP-AS-IS (with clarification) | The 375 controls CDI scale; scale is output to external CDI and also displayed on annunciator bar + optional on-screen CDI. Spec should document both output and display sides. |
| 17 | Turn anticipation / "Time to Turn" advisory | KEEP-AS-IS | Confirmed at pp. 200, 202. Explicitly a 10-second countdown advisory. |
| 18 | Fly-by vs. fly-over waypoint turn behavior | KEEP-AS-IS (thin coverage) | Pilot's Guide mentions the symbol (p. 157) but behavioral details are sparse; spec should flag as limited-source feature. |
| 19 | Active leg transition visual feedback | KEEP-AS-IS | On Map and FPL page (magenta indicator advancing). |
| 20 | ARINC 424 leg type handling | KEEP-AS-IS (as output contract) | The 375 processes these legs and outputs guidance; specific leg types supported likely require research beyond the extracted PDF. |
| 21 | Altitude constraints on flight plan legs | REFRAME as OPEN QUESTION | Pilot's Guide does not prominently document this. Spec should flag as "unknown whether the 375 displays published altitude constraints; research needed." VCALC is a separate planning tool, not automatic. |
| 22 | Approach arming vs. active states | KEEP-AS-IS | Confirmed at p. 200 (LPV walkthrough): mode switches Terminal→LPV at FAF. |
| 23 | CDI deviation display rendering | REFRAME | Specifically: the 375 has an OPTIONAL on-screen lateral CDI (below GPS NAV Status key); the primary CDI is external. Spec must make this distinction clear. |
| 24 | To/From flag rendering | REFRAME | The FROM/TO field annunciates on the 375's annunciator bar (p. 183). The TO/FROM flag on an external CDI is ALSO driven by the 375. Both sides need spec coverage. |
| 25 | Autopilot coupling during approach | KEEP-AS-IS | Confirmed at p. 207 (KAP 140, KFC 225 specifically supported; APR Output toggle). |

**Net effect on the 375 outline:**
- Item 11 drops or moves to §15 External I/O as an output contract
- Item 21 becomes an explicit open question rather than a feature to spec
- Items 14, 16, 23, 24 gain "on-screen vs. external output" framing
- Net outline length estimate: roughly unchanged from Turn 19's 2,900–3,000 (some additions for output-contract clarity, some reductions for VDI drop).

---

## Impact on the 375 Outline Structure

This research resolves an ambiguity that would have caused the 375 outline to over-specify internal display features. The corrected mental model for the outline:

**The 375 is a Flight Management Unit (FMU) + optional auxiliary CDI.** Its primary pilot-visible outputs are:
- Strategic (flight plan, procedures, next waypoint)
- Situational (Map with active leg, annunciator bar, GPS NAV Status key)
- Advisory (messages, "Time to Turn," mode transitions, downgrades)

**The primary tactical navigation instrument (CDI/HSI/VDI) is external** and is driven by the 375's output datarefs/events. The 375's spec must cover the output contract for these externals but must NOT over-specify an on-375 CDI/VDI rendering beyond the documented optional on-screen lateral CDI.

**The XPDR + ADS-B work (Turn 18 harvest map items 1–10) remains fully valid** — XPDR is displayed on the 375 natively (dedicated XPDR page, see pp. 75–85 which weren't researched this turn). Procedural-fidelity items 11–25 are the ones needing recalibration per this document.

---

## Open Research Items for C2.1-375 Authoring

The following remain unresolved or thinly covered by the Pilot's Guide and should be flagged as open questions during C2.1-375 outline authoring:

1. **Altitude constraints on flight plan legs** — does the 375 display published procedure altitudes? Need to research the Procedures sub-sections more thoroughly or flag as "behavior unknown from available documentation."
2. **ARINC 424 leg type enumeration** — which of CF, DF, FA, FC, FD, FM, HA, HF, HM, IF, PI, RF, TF, VA, VD, VI, VM, VR are supported? Pilot's Guide examples don't enumerate; may need to infer from procedure examples or flag as research-needed.
3. **Fly-by vs. fly-over turn geometry details** — exact turn-initiation distance, anticipation algorithm. Pilot's Guide lists the symbol but not the math.
4. **Full XPDR section coverage** — pp. 75–85 not researched in this turn's deep-dive; the XPDR spec scope (item 1, Turn 18 harvest) still needs its own research pass before C2.1-375 authoring. (Recommended: a second research turn focused on pp. 75–85 before drafting the 375 outline task prompt, OR embed the research into the C2.1-375 task prompt itself as a "CC, read pp. 75–85 and enumerate XPDR features" directive.)
5. **ADS-B In/Out specifics** — exact dataref/variable integration with simulators; beyond the PDF scope.

---

## Methodology Note

This research was performed within a single Purple CD turn using direct Python reads of the extracted PDF JSON. Pages searched: all 310 pages scanned for 30+ keyword variants. Pages read in full: 12, 20, 86, 87, 88, 89, 131, 144, 145, 146, 147, 158, 161, 183, 192, 197, 198, 199, 200, 201, 202, 203, 205, 207. No CC task spawned; the research scope fit within CD capabilities and the coordination overhead of a CC round-trip would not have improved quality.

Findings are authoritative as of the extracted PDF content (Pilot's Guide 190-02488-01 Rev. C). Any aspects requiring real-device verification or XPL/MSFS simulator API knowledge remain flagged as open questions.
