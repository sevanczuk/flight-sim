---
Created: 2026-04-23T08:45:00-04:00
Source: docs/tasks/c22_d_prompt.md
Fragment: D
Covers: §§5–7 (Flight Plan Editing, Direct-to Operation, Procedures)
---

# GNX 375 Functional Spec V1 — Fragment D

---

## 5. Flight Plan Editing

**Scope.** Documents all workflows for creating, modifying, and managing flight plans on
the GNX 375. Covers the flight plan catalog, active flight plan manipulation (waypoint
insertion, deletion, graphical editing), and the OBS and parallel track modes. §5 workflows
act on the Active FPL page display structure described in §4.3 (Fragment B). Flight plan
editing behavior is **identical across GPS 175, GNC 355/355A, and GNX 375**.

**Source pages.** [pp. 129–132, 144–157]

---

### 5.1 Flight Plan Catalog [pp. 150–151]

The catalog stores user-created flight plans independent of the active route. Access:
Home > FPL > Catalog (or via the FPL menu). Selecting a stored flight plan opens the
Route Options menu; changes to the active flight plan take effect immediately.

**Route Options menu:**

| Option | Action |
|--------|--------|
| **Activate** | Overwrites the active flight plan with the selected catalog entry |
| **Invert & Activate** | Reverses waypoint order, then activates |
| **Preview** | Displays the selected flight plan on the map without activating |
| **Edit** | Opens the flight plan for waypoint addition, removal, or modification |
| **Copy** | Copies the flight plan so the copy can be modified separately |
| **Delete** | Removes the selected flight plan from the catalog |

**Delete behavior:** deleting the active flight plan from the FPL menu (Menu > Delete)
clears the active route but does **not** delete the corresponding catalog entry. Catalog
entries are managed only from within the catalog.

**Delete All:** from within the catalog, Menu > Delete All removes all stored flight plans.
Two-step confirmation ("Delete All" → "Delete Pending") is required.

---

### 5.2 Create a Flight Plan [p. 152]

Three methods for creating a new flight plan:

1. **From the Active FPL page:** Home > FPL → delete existing if necessary (Menu > Delete)
   → tap Add Waypoint → search and select identifiers; repeat per waypoint.
2. **From the Map (graphical):** use Graphical Edit mode (§5.4) to build a route by
   tapping waypoints on the Map without leaving the Map page.
3. **Wireless import (Bluetooth):** requires Garmin Pilot app pairing and Connext / Flight
   Stream 510; see §10.10 (Fragment E) for Bluetooth setup. See open question in §5
   AMAPI notes below.

> **Note:** the unit cannot verify the accuracy of cataloged flight plans with modified
> procedures. Always review loaded procedures before activating.

---

### 5.3 Waypoint Options [p. 153]

Selecting a waypoint identifier in the active flight plan opens the Waypoint Options menu.
Changes to the active flight plan take effect immediately.

| Option | Action |
|--------|--------|
| **Insert Before** | Inserts a new waypoint before the selected waypoint |
| **Insert After** | Inserts a new waypoint after the selected waypoint |
| **Load PROC** | Opens procedure selection (SID/STAR/approach) from the FPL page |
| **Load Airway** | Inserts an airway beginning at the selected waypoint |
| **Activate Leg** | Changes the active leg to begin at the selected waypoint |
| **Hold at WPT** | Adds a holding pattern at the selected waypoint |
| **WPT Info** | Opens the Waypoint Information page for the selected fix |
| **Remove** | Deletes the selected waypoint from the flight plan |

---

### 5.4 Graphical Flight Plan Editing [pp. 129–132]

Graphical editing allows quick changes to the active flight plan directly from the Map
page (§4.2, Fragment B). Editing creates a **temporary flight plan**; changes become
permanent only when the pilot taps **Done**. An information banner lists up to four
selected waypoint identifiers during editing.

**Operations:**

- **Add waypoint to an existing leg:** tap any map location → tap Graphical Edit →
  tap and drag the leg to a new waypoint or airway, then release.
- **Remove a waypoint:** tap and drag a leg, then release away from any waypoint.
- **Create a new flight plan (no existing FPL):** tap any map location → Graphical
  Edit → tap waypoints sequentially → tap Done.

**GNX 375 / GPS 175 [p. 131]:** new route identifiers appear on the GPS NAV Status
indicator key (lower right) after editing. GNC 355/355A uses a map user field instead.

**Feature limitations [p. 129]:**
- Parallel track offsets do not apply to the temporary flight plan during graphical editing.
- An intermediate waypoint cannot be inserted between the current position and a direct-to
  fix unless the waypoint is already in the flight plan. Delete the direct-to first.

---

### 5.5 OBS Mode [p. 145]

OBS (Omni Bearing Selector) mode switches between manual and automatic waypoint sequencing.
When OBS is active, the unit retains the active TO waypoint as a navigation reference even
after passing it — automatic sequencing to the next waypoint is suppressed.

**Activation:** tap OBS on the FPL page; the mode annunciates in the annunciator bar.

**Course setting:** with OBS active, the pilot specifies a desired course To or From the
active waypoint using on-screen controls or an **external OBS selector** on the HSI or
CDI. The CDI indicates deviation from the selected OBS course.

**Deactivation:** tap OBS again to resume automatic sequencing.

---

### 5.6 Parallel Track [pp. 147–148]

Parallel Track creates a course offset from the active flight plan. The offset course drives
the external CDI/HSI output while original flight plan waypoints remain unchanged. Access:
FPL Menu > Parallel Track.

**Settings:** offset distance 1–99 nm; direction left or right of track.

**Activation procedure:**
1. Menu > Parallel Track.
2. Tap Offset → specify distance (1–99 nm).
3. Tap Direction → select left or right of track.
4. Tap Activate.

**Deactivation:** Menu > Deactivate PTK returns CDI guidance to the original flight plan.

**Feature limitations [pp. 147–148]:** requires an active flight plan; not available with
Direct-to active; graphical editing of the active leg cancels parallel track; large offset
values with approach legs or track changes >120° are not supported.

---

### 5.7 Dead Reckoning [p. 146]

Dead Reckoning (DR) provides limited navigation using the last known GPS position and speed
following GPS signal loss. Active only during **en route and oceanic phases** on an active
flight plan.

**Activation:** DR engages automatically after GPS position loss in en route or oceanic phase.

**Display behavior:** Map reports "No GPS Position"; overlays are not available. DR mode
annunciation replaces the en route annunciation in the annunciator bar. Projected position
degrades in accuracy over time.

> **Warning:** do not use projected DR position data as the only means of navigation.

---

### 5.8 Airway Handling [p. 144]

Airways are inserted into the active flight plan as individual waypoint legs. A single
airway may contain many legs; the airway name appears as an indicator field, and the exit
waypoint marks the end of the airway sequence.

**Collapse All Airways:** tap Collapse All Airways to hide all waypoints along each airway
except the exit waypoint. Non-active airway legs collapse automatically. Collapsing does
not affect airway legs displayed on connected external navigators.

---

### 5.9 Flight Plan Data Fields [p. 149]

Up to three data columns appear per flight plan leg. Access: tap Edit Data Fields from
the FPL page.

| Code | Field |
|------|-------|
| CUM | Cumulative distance to destination |
| DIS | Leg distance |
| DTK | Desired track |
| ESA | En route safe altitude |
| ETA | Estimated time of arrival |
| ETE | Estimated time en route |
| XTK | Cross-track deviation |

**Default columns:** Column 1 = DTK, Column 2 = DIS, Column 3 = CUM.

**Restore Defaults:** resets all columns to defaults.

> **AMAPI notes:**
> - `docs/knowledge/amapi_by_use_case.md` §11 (Persist_add/get/put for flight plan storage;
>   note: scalar API — see open question below)
> - `docs/knowledge/amapi_patterns.md` Pattern 11 (persist across sessions)
> - `docs/knowledge/amapi_by_use_case.md` §10 (Nav_get / Nav_calc_distance for leg data)

**Open questions / flags:**

1. **Flight plan persistence schema:** the Air Manager Persist API supports scalar values.
   Serializing a full flight plan (waypoint list, leg types, procedure attachments) requires
   JSON encoding. Persistence schema (key names, encoding format, versioning) is a
   design-phase decision.

2. **Wireless import:** requires Garmin Pilot app pairing via Connext / Flight Stream 510.
   May be out of scope for the v1 Air Manager instrument. Design-phase scope decision.

---

## 6. Direct-to Operation

**Scope.** Documents the Direct-to operational workflow — setting a point-to-point course
to any waypoint. Accessed via the Home page Direct-to icon or inner knob push (GNX 375 /
GPS 175 pattern; see §2.7, Fragment A). §6 workflows act on the Direct-to page display
described in §4.4 (Fragment B). **Identical across GPS 175, GNC 355/355A, and GNX 375.**

**Source pages.** [pp. 159–164]

---

### 6.1 Direct-to Basics [p. 159]

Direct-to sets a point-to-point course from present position to any selected waypoint.
**Access:** tap the Direct-to icon on the Home page, or push the inner control knob
(GNX 375 / GPS 175 — see §2.7, Fragment A).

**Feature limitation [p. 159]:** not all flight plan entries are selectable via Direct-to.
Holds and course reversals cannot be selected.

Upon selecting a destination, the Direct-to window shows waypoint information automatically.

---

### 6.2 Search Tabs [pp. 159–160]

Three tabs provide methods for locating the destination:

| Tab | Content |
|-----|---------|
| **Waypoint** | Identifier entry with distance/bearing; course and hold options; active by default |
| **FPL** | List of selectable identifiers from the active flight plan |
| **NRST APT** | Nearest airports by proximity to current position |

The FPL tab is unavailable if no active flight plan exists. Waypoint sequencing resumes
once the aircraft reaches an FPL tab–selected waypoint (absent a subsequent Direct-to).

---

### 6.3 Direct-to Activation [p. 161]

Activating a Direct-to course establishes a point-to-point line from present position to
the destination. The unit provides guidance until:
- The direct-to waypoint is reached.
- The direct-to course is removed (§6.5).
- A new direct-to course is activated.
- A flight plan leg is activated, resuming FPL guidance.

**Activation:** select destination → tap Activate (or push inner knob second time). Map
opens automatically showing the active direct-to leg.

**GNX 375 / GPS 175:** GPS NAV Status indicator key changes to show active leg status.
**GNC 355/355A:** Direct-to key changes to show the active fix identifier and symbol.

---

### 6.4 Direct-to a New Waypoint [pp. 162–163]

**New waypoint (off-route or no FPL):**
1. Tap Direct-to.
2. Select identifier via FastFind or search tabs.
3. Optionally tap Course to specify the navigation course angle.
4. Tap Activate.

**FPL waypoint:** select from the FPL tab; sequencing resumes at the selected waypoint.

**Off-route course [p. 163]:** activating Direct-to a waypoint not in the active FPL
deactivates the current FPL leg; the original flight plan remains in memory.

**Approach guidance restriction [p. 163]:** approach guidance is not active for procedure
fixes selected via Direct-to. Activating Direct-to a fix between the FAF and MAP does
not make approach guidance available at that fix.

---

### 6.5 Removing a Direct-to Course [p. 163]

Tap **Remove** from the Direct-to page or FPL menu to cancel the direct-to course.
Guidance reverts to the active flight plan if one exists, or the unit has no active guidance.

Activating a flight plan leg via the Waypoint Options menu (§5.3 Activate Leg) also
replaces the direct-to course with FPL leg guidance.

---

### 6.6 User Holds [p. 164]

A holding pattern may be defined at any Direct-to waypoint. User holds suspend automatic
waypoint sequencing until the hold expires or is removed.

**Access:** with Direct-to active, tap **Hold** from the Direct-to page.

| Option | Function |
|--------|----------|
| **Load Hold** | Accepts parameters and returns to the Direct-to window |
| **Hold Activate** | Activates the loaded holding pattern immediately |
| **Course** | Specifies the inbound or outbound course angle |
| **Direction** | Inbound or Outbound |
| **Turn** | Left Turn or Right Turn |
| **Leg Type** | Time or Distance |
| **Leg Time** | Leg time in MM:SS |
| **Leg Dist** | Leg distance |

Automatic sequencing suspends for the hold duration; the hold remains active until removed
or the configured leg time or distance expires.

> **AMAPI notes:**
> - `docs/knowledge/amapi_by_use_case.md` §2 (command dispatch for direct-to activation,
>   course removal, hold activation)
> - `docs/knowledge/amapi_by_use_case.md` §10 (Nav_get / Nav_calc_distance / Nav_calc_bearing
>   for waypoint queries in search tabs)

---

## 7. Procedures

**Scope.** Documents all instrument procedure operations: loading and activating departures
(SIDs), arrivals (STARs), and approaches; flying each procedure type; missed approaches;
and autopilot coupling. Full procedural fidelity per D-12 Q3c and D-14 (items 11–25 mapped
to §§7.A–7.M). Key GNX 375 distinctions: **no internal VDI** — vertical deviation is output
exclusively to external CDI/VDI instruments (D-15); XPDR + ADS-B approach interactions in
§7.9 (D-16). §7 workflows act on the Procedures display pages documented in §4.7 (Fragment C).

**Source pages.** [pp. 181–207]

---

### 7.1 Flight Procedure Basics [p. 182]

- **Pre-activation checklist:** always check runway, transition, and waypoints for all
  procedures before activation.
- **Advisory climb altitudes for SIDs** may not match charted altitudes; do not rely
  solely on advisory values.
- **Heading legs** display as "HDG XXX°" in white on the flight plan.
- **Lateral and vertical guidance** is provided for visual and GPS/RNAV approaches.
  The Map provides situational awareness during ILS, VOR, NDB, and non-precision localizer
  approaches; always use the appropriate radio navigation aid as primary guidance during
  non-GPS approaches.
- **Roll steering (GPSS):** output to compatible autopilots (§7.8 and §2.5, Fragment A).
  A magenta line depicts the active leg on the Map.
- **TO/FROM legs on CDI [p. 183]:** on TO legs, the CDI shows TO and Distance decreases.
  On FROM legs (e.g., procedure turns, some missed approach segments), the CDI shows FROM
  and Distance increases. Detailed treatment in §7.H.

---

### 7.2 GPS Flight Phase Annunciations [pp. 184–185]

The annunciator bar shows the current GPS flight phase as a colored label. **Green** =
normal; **yellow** = caution (integrity degraded or approach downgraded). Flight phase
annunciations are a direct indication of current CDI scale behavior.

| Annunciation | Flight Phase | CDI Scale | Notes |
|---|---|---|---|
| OCEANS | Oceanic | 2.0 nm | Oceanic en route |
| ENRT | En Route | 2.0 nm | Standard en route |
| TERM | Terminal | 2.0 nm (or CDI setting) | Within ~31 nm of destination |
| DPRT | Departure | 2.0 nm | Departure procedure active |
| LNAV | LNAV Approach | Angular (~0.30 nm) | Non-precision lateral; fly to MDA |
| LNAV/VNAV | LNAV/VNAV Approach | Angular (~0.30 nm) | Baro-VNAV advisory vertical; fly to MDA |
| LNAV+V | LNAV+V Approach | Angular (~0.30 nm) | GPS-derived advisory vertical; fly to MDA |
| LP | LP Approach | Angular (~0.30 nm) | SBAS lateral; fly to LP minimums |
| LP+V | LP+V Approach | Angular (~0.30 nm) | LP + advisory vertical; fly to LP minimums |
| LPV | LPV Approach | Angular (~0.30 nm) | SBAS precision to DA; primary vertical guidance |
| MAPR | Missed Approach | ±0.30 nm | Missed approach integrity active |

Color semantics: **Green** = normal. **Yellow** = caution; integrity degraded or approach
downgraded. Downgrade triggers "GPS approach downgraded. Use LNAV minima." advisory and
a CDI behavior change. See §7.F for transition state machine. Annunciation rendering:
§12.2 (Fragment F).

---

### 7.3 Departures (SIDs) [pp. 186–187]

A SID is loaded at the departure airport. One departure per flight plan; a new departure
replaces any existing entry. Waypoints and transitions are inserted at the **beginning**
of the active flight plan.

**Access:** Home > Procedures → select departure, transition, and runway. Or FPL menu.

**Flight Plan Departure Options menu:**

| Option | Action |
|--------|--------|
| **Select Departure** | Opens departure procedure selection |
| **Remove Departure** | Removes the loaded departure from the flight plan |

**Feature limitation:** vector-only departures are not supported for GPS course guidance;
heading legs display as "HDG XXX°."

---

### 7.4 Arrivals (STARs) [pp. 188–189]

A STAR can be loaded at any airport with a published arrival. One arrival per flight plan;
a new arrival replaces any existing entry. The STAR route is inserted before the destination
airport entry in the flight plan.

**Flight Plan Arrival Options menu:**

| Option | Action |
|--------|--------|
| **Select Arrival** | Opens arrival procedure selection |
| **Remove Arrival** | Removes the loaded arrival from the flight plan |

---

### 7.5 Approaches [pp. 190–206]

One approach per flight plan. Loading a new approach replaces the existing entry, except
during a missed approach (flight plan retains all missed approach legs). Selecting approach,
transition, and runway defines the route.

**SBAS approach via Channel ID [p. 191]:** tap Channel/ID on the approach selection page →
enter the SBAS Channel ID from the published chart. Unit loads the approach automatically;
if duplicate IDs exist, select from the list.

**Procedure turns [p. 192]:** stored as regular approach legs; no special pilot action
required. Roll steering available for procedure turns; steering does not guarantee the
aircraft stays within charted turn boundaries.

**Suspended approach annunciation [p. 191]:** "SUSP" indicates automatic approach waypoint
sequencing is suspended on the active leg.

**Approach types [pp. 199–206]:**

| Approach Type | Vertical Guidance | SBAS Required | GPS Nav Approval | Notes |
|---|---|---|---|---|
| LNAV | None | No | Yes | Lateral only; non-precision; fly to MDA |
| LNAV/VNAV | Baro-VNAV (advisory) | No | Yes | Baro-VNAV advisory vertical; fly to MDA |
| LNAV+V | GPS-derived (advisory) | No | Yes | +V = advisory only; fly to MDA |
| LPV | SBAS/GPS (primary) | Yes | Yes | Primary vertical to DA; precision-equivalent |
| LP | None | Yes | Yes | SBAS lateral; fly to LP minimums |
| LP+V | GPS-derived (advisory) | Yes | Yes | LP + advisory vertical; fly to LP minimums |
| ILS | N/A | No | No | GPS monitoring only; not approved for GPS nav |

This table is consistent with §4.7 (Fragment C) approach types table (same 7 types, same
type labels). §7.5 adds operational columns; §4.7 is the display-page reference.
See §7.C for ILS monitoring; §7.A and §7.B for glidepath/glideslope framing.

**Downgrade [p. 201]:** if GPS integrity exceeds HAL/VAL during an LPV approach:
annunciator → LNAV (yellow); advisory: "GPS approach downgraded. Use LNAV minima." If
integrity also fails LNAV HAL: "Abort Approach. GPS approach is no longer available."
Unit reverts to terminal 1.0 nm scale. See §7.F for transition table.

**Visual Approaches [pp. 205–206]:** selector key active within 10 nm of destination.
Load from Map (airport icon → Visual → select) or Home > Procedures > Approach. Lateral
guidance always provided. **Vertical deviation is not displayed on the GNX 375 screen**
(D-15; Pilot's Guide p. 205: "Only external CDI/VDI displays provide vertical deviation
indications.") See §15.6 (Fragment G) for the external output contract.

**DME Arc [p. 196]:** supported. Left/right lateral guidance relative to arc. Manual
arc leg activation required when aircraft is within the shaded activation area.

**RF Legs [p. 197]:** radius-to-fix legs (RNAV RNP 0.3 non-AR) supported when approved
by installation. Constant-radius circular path around a defined turn center. See AC 90-101A.

**Vectors to Final (VTF) [p. 197]:** loads approach with vectors bypassing transition
fixes. Guidance from present position to FAF on an intercept course.

**Flight Plan Approach Options menu:**

| Option | Action |
|--------|--------|
| **Activate Approach** | Activates the loaded approach |
| **Activate Vectors to Final** | Activates VTF mode |
| **Remove Approach** | Removes the approach from the flight plan |

**OPEN QUESTION 2 — ARINC 424 leg handling:** see §7.M.

---

### 7.6 Missed Approach [p. 193]

**Before MAP:**
Tap **Activate Missed Approach** from either:
- Active FPL page: Home > Flight Plan > select approach > Activate Missed Approach
- Procedures app: Home > Procedures > Activate Missed Approach

Guidance continues along the final approach course extension; the unit sequences
automatically to the first missed approach leg, allowing early execution.

**After MAP:**
Crossing the MAP suspends waypoint sequencing; "SUSP" annunciates. A pop-up appears:
- **Remain Suspended** — sequencing stays paused; tap UNSUSP to resume manually.
- **Activate GPS Missed Approach** — resumes guidance to the missed approach hold point.

**Heading legs in missed approach:** fly manually until reaching the first active course
leg (UNSUSP → follow unit guidance).

---

### 7.7 Approach Hold [pp. 194–195]

Selecting an approach hold in the flight plan opens the **Hold Options** menu. Changes
take effect immediately.

| Option | Action |
|--------|--------|
| **Activate Hold** | Activates the selected holding pattern |
| **Insert After** | Inserts a waypoint after the hold |
| **Edit Hold** | Modifies direction, inbound course, leg type (time or distance), and timing |
| **Exit Hold** | Exits the hold before the timer expires |
| **Remove** | Removes the hold from the flight plan |

**Activation:** select hold → Activate Hold → confirm.

**Non-required holding patterns [p. 195]:** on RNP GPS approach initialization, a pop-up
asks whether to add the non-required hold. Yes: hold added (preview in white). No: hold
omitted (preview in gray). Timer/distance field appears on the active FPL page during the
outbound leg. Pattern appears on Map.

---

### 7.8 Autopilot Outputs [p. 207]

The GNX 375 outputs roll steering (GPSS) and LPV glidepath capture guidance to compatible
autopilots. Availability is configuration-dependent.

**Roll steering (GPSS) [p. 183, 207]:**
- GPSS output **terminates** when the pilot selects approach mode on the autopilot.
- GPSS output **resumes** after missed approach initiation.
- An advisory displays when GPSS output begins.
- **Caution:** on heading legs, engage autopilot heading mode and set the heading bug
  appropriately. Not all autopilots follow guidance on heading legs; some revert to
  roll-only or wings-level.

**LPV glidepath capture (KAP 140 / KFC 225 only) [p. 207]:**
- Applicable only to King autopilots KAP 140 and KFC 225.
- When an LPV approach is loaded and APR output is configured, the unit sends glidepath
  capture guidance to the autopilot.
- **"Enable APR Output" advisory** prompts the pilot when the autopilot is compatible and
  APR output can be activated.
- **Manual activation required** — APR output is not enabled automatically.

**Open question — autopilot dataref names:** XPL dataref names for GPSS output and APR
coupling require design-phase research. MSFS SimConnect event names similarly need
verification. See §15 / §15.6 (Fragment G) for the external output contract where these
names will be specified.

---

### 7.9 XPDR + ADS-B Approach Interactions [pp. 75–82, 245–256]

**Scope.** Documents the interaction between the GNX 375's Mode S transponder, ADS-B
functions, and GPS approach flight phases. Authored per ITM-09 to resolve Fragment C
§4.7 forward-references (XPDR altitude reporting during approach; TSAA behavior during
approach). XPDR control panel and mode detail in §11.4 (Fragment F); TSAA display detail
in §4.9 (Fragment C).

**XPDR ALT mode during approach [p. 78]:**
The GNX 375 XPDR operates in three modes only: **Standby, On, and Altitude Reporting**
(ALT mode). **No Ground mode, no Test mode, and no Anonymous mode** exist on the GNX 375
(D-16; p. 78). During approach phases (TERM, LNAV, LPV, LP+V, etc.), the XPDR remains
in ALT mode. Air/ground state transitions (including WOW — weight-on-wheels) are handled
**automatically** by the unit [p. 78]; no pilot mode change is required when transitioning
through approach flight phases or on landing.

**ADS-B Out during approach:**
When in ALT mode, 1090 MHz Extended Squitter (1090 ES) ADS-B Out transmissions are
continuously active. During all approach phases, the GNX 375 transmits position and
altitude data. No pilot action is required to maintain ADS-B Out during approach operations.

**TSAA traffic display during approach [pp. 245–256]:**
The TSAA (Traffic Situational Awareness with Alerting) application runs whenever ADS-B In
data is available. **TSAA is GNX 375 only** — GPS 175 and GNC 355/355A have ADS-B traffic
display only (via external hardware if equipped); they do not have TSAA. Traffic alerting
continues during all approach flight phases; the approach flight phase does not inhibit or
alter traffic alerting parameters. TSAA aural alert delivery during approach: see §4.9
(Fragment C) OPEN QUESTION 6 for the delivery mechanism; see §12.4 (Fragment F) for the
aural alert hierarchy.

**Flight phase annunciation and XPDR state correlation:**
The annunciator bar displays GPS flight phase (§7.2) and the XPDR mode indicator
concurrently in independent display slots. Both are visible simultaneously during approach;
the approach annunciation (e.g., LPV) and the ALT indicator appear at the same time.

**Forward references:**
- XPDR control and mode detail → §11.4 (Fragment F)
- ADS-B In receiver → §11.11 (Fragment F)
- Aural alert hierarchy → §12.4 (Fragment F)
- TSAA display detail → §4.9 (Fragment C)
- XPDR + ADS-B datarefs → §15 (Fragment G)

---

### 7.A Glidepath vs. Glideslope Nomenclature [pp. 184–185, 200–203]

Garmin documentation uses distinct terms for GPS-derived and ILS radio-derived vertical
guidance:

- **Glidepath** — GPS-computed vertical profile for SBAS/RNAV approaches (LPV, LP+V,
  LNAV+V, LNAV/VNAV). The GNX 375 outputs glidepath deviation to external CDI/VDI
  only (D-15).
- **Glideslope** — ILS radio-frequency vertical beam from a ground station. The GNX 375
  **cannot receive an ILS glideslope** — it has no VOR/LOC/ILS receiver.

The **"+V suffix"** (LNAV+V, LP+V) denotes advisory-only GPS-derived vertical guidance.
This spec follows Garmin terminology consistently: "glidepath" for GPS-derived vertical
outputs; "glideslope" only in the context of external ILS equipment.

---

### 7.B Advisory vs. Primary Vertical Distinction [pp. 184–185, 199–204]

GPS/RNAV approach vertical guidance falls into two categories:

- **Primary vertical (LPV):** SBAS-based; fly to Decision Altitude (DA); precision-approach
  equivalent. Annunciation: LPV (green normal, yellow if degraded). Glidepath deviation
  output to external CDI/VDI.
- **Advisory vertical — +V suffix (LNAV+V, LP+V):** GPS-derived; fly to published MDA,
  not DA. Advisory-only status; annunciation: LNAV+V or LP+V.
- **Baro-VNAV advisory (LNAV/VNAV):** barometric altitude source for vertical profile;
  advisory-only; fly to MDA. Different source than +V GPS-derived; same advisory status.
  Annunciation: LNAV/VNAV.

Color semantics communicate guidance category: green annunciation = normal; yellow =
caution or advisory-only engagement.

---

### 7.C ILS Approach Display Behavior [p. 198]

When an ILS or LOC approach is loaded, a pop-up appears: **"ILS and LOC approaches are
not approved for GPS."** The pilot acknowledges by tapping Activate Approach or selecting
a different approach.

**GNX 375 role during ILS [p. 198]:**
- GPS provides lateral position **monitoring only**; the GNX 375 is not the primary
  navigation source for an ILS approach.
- Annunciator bar remains at **TERM** (no LPV or LNAV annunciation is shown for ILS).
- **No internal VDI** (D-15): no on-screen glideslope or glidepath needle of any kind.
  The pilot's primary glideslope reference is the aircraft's external NAV receiver–driven
  CDI/HSI glideslope indicator.
- The GNX 375 is **not connected to the aircraft's NAV receiver**; the external CDI/HSI
  follows the NAV receiver for ILS, not the GNX 375.

Map continues to show a magenta line on the active approach leg for situational awareness.

---

### 7.D CDI Scale Auto-Switching [pp. 87–88]

The CDI scale switches automatically by flight phase when set to Auto (default). The scale
setting drives the external CDI/HSI full-scale deflection and the optional on-screen CDI
(§4.10, Fragment C; §7.G below).

**Auto setting behavior [p. 87]:**
- En route: 2.0 nm full-scale deflection.
- Within 31 nm of destination (terminal): scale linearly ramps 2.0 nm → 1.0 nm over 1 nm.
- From 2.0 nm before FAF to FAF: scale transitions 1.0 nm → angular approach scale.

**Horizontal Alarm Limits (HAL) by flight phase [p. 88]:**

| Flight Phase | CDI Scale | HAL |
|---|---|---|
| Approach | 0.30 nm or Auto | 0.30 nm |
| Terminal | 1.00 nm or Auto | 1.00 nm |
| En Route | 2.00 nm or Auto | 2.00 nm |
| Oceanic | Auto | 2.00 nm |

HAL compares against GPS position integrity. A manual scale setting of 1.0 nm does not
raise the approach HAL — approach HAL remains 0.30 nm regardless of manual setting.

**Output destinations:** CDI scale drives (1) external CDI/HSI full-scale deflection,
(2) annunciator bar CDI scale slot, (3) optional on-screen CDI when CDI On Screen is
enabled (GNX 375 / GPS 175 only — §4.10, Fragment C).

**Manual settings** (0.30, 1.00, 2.00 nm) cap the upper scale bound per phase but do
not override the approach scale during an active approach. See §10.1 (Fragment E) for
settings page detail; §15.6 (Fragment G) for the external output contract.

---

### 7.E Approach Arming vs. Active States [p. 200]

GPS approaches transition through two observable states:

**Armed state:**
- Approach loaded in the flight plan; annunciator shows TERM; CDI scale = 1.0 nm.
- GPS provides lateral guidance only; no vertical engagement.
- XPDR remains in ALT mode (§7.9).

**Active state (FAF crossed):**
- Annunciator transitions TERM → approach annunciation (e.g., LPV).
- CDI scale tightens: 2.0 nm before FAF → angular approach scale at FAF.
- Vertical guidance engages: primary glidepath (LPV) or advisory glidepath (+V types).
- GPSS output terminates when autopilot approach mode is selected (§7.8).

**60-second integrity check [p. 200]:** 60 seconds before the FAF, the unit evaluates
GPS integrity. Failure → approach downgrade + advisory message (see §7.F).

**Pilot-visible transition:** simultaneous annunciator bar mode change + CDI scale change
+ autopilot mode engagement (if GPSS/APR configured) at FAF crossing.

---

### 7.F Approach Mode Transitions [pp. 200–203]

When GPS integrity exceeds alarm limits, the approach downgrades automatically. Each
transition produces an annunciator change, a message queue advisory, and a CDI behavior
change.

| Transition | Trigger | Annunciator | Advisory Message | CDI Effect |
|---|---|---|---|---|
| LPV → LNAV | HAL or VAL exceeded | LPV → LNAV (yellow) | "GPS approach downgraded. Use LNAV minima." | Vertical guidance removed; lateral angular scale maintained |
| LP → LNAV+V | HAL exceeded | LP → LNAV+V | "GPS approach downgraded. Use LNAV minima." | Advisory vertical may continue; lateral scale maintained |
| LNAV/VNAV → LNAV | Baro-VNAV source loss | LNAV/VNAV → LNAV | Advisory (§13, Fragment F for text) | Vertical guidance removed; lateral scale maintained |

If integrity also fails LNAV HAL after downgrade: "Abort Approach. GPS approach is no
longer available." Unit reverts to terminal 1.0 nm scale. Advisory message text: §13
(Fragment F). LP+V advisory vertical may be removed without annunciation if vertical
guidance criteria are not met [p. 203]; this is not a full approach downgrade.

---

### 7.G CDI Deviation Display — On-Screen vs. External [pp. 87–89]

The GNX 375 provides lateral deviation output to two destinations:

1. **External CDI/HSI** — the pilot's primary tactical reference during approach and
   en route navigation. Driven by the GNX 375 lateral-deviation output at the active
   CDI Scale setting. See §15.6 (Fragment G) for the output contract.

2. **On-screen CDI (GNX 375 / GPS 175 only) [p. 89]:** optional lateral indicator
   below the GPS NAV Status indicator key on the FPL page.
   - Requires CDI On Screen enabled in Pilot Settings (§4.10, Fragment C).
   - **Lateral deviation only** — no vertical deviation indicator on the GNX 375 screen.
   - Requires an active flight plan; no indications without one.
   - Visual approach lateral advisory annunciations appear when a visual approach is active.

**No on-375 VDI of any kind (D-15; Pilot's Guide p. 205):** the GNX 375 does not
display a glidepath needle, glideslope needle, or vertical deviation indicator internally.
All vertical deviation output goes exclusively to external CDI/VDI instruments. See
§15.6 (Fragment G) for the full external output contract (lateral deviation, CDI scale,
course, and vertical deviation).

---

### 7.H TO/FROM Flag Rendering [p. 183]

- **Annunciator bar FROM/TO field:** the authoritative pilot-facing display of the current
  TO/FROM state.
- **External CDI TO/FROM flag:** also driven by the GNX 375 output to the connected
  external CDI/HSI.

**TO legs** (most approach and en route legs): CDI shows TO; Distance field decreases.

**FROM legs** (procedure turns, some missed approach segments): CDI shows FROM; Distance
field increases.

**Composite CDI caveat [p. 183]:** when interfaced with a composite-type CDI, the composite
CDI flag shows **TO indications only** — FROM indications are not available. The
annunciator bar FROM/TO field is the authoritative source for FROM-leg identification in
composite-CDI installations.

---

### 7.I Turn Anticipation / "Time to Turn" Advisory [pp. 200, 202]

As the aircraft approaches a turn waypoint during an approach procedure:

- A **"Time to Turn" advisory** annunciates in the message queue.
- A **10-second countdown timer** begins as distance to the turn waypoint approaches zero.
- Confirmed in both the LPV approach walkthrough [p. 200] and the LP approach walkthrough
  [p. 202].

**Related advisories:**
- **"Arriving at Waypoint"** — annunciates as the aircraft approaches the active waypoint
  (e.g., IAF, MAP) [p. 201].
- **"Missed Approach Waypoint Reached"** — pop-up at MAP crossing; pilot selects remain
  suspended or activate missed approach [p. 204].

These advisories appear in the on-375 message queue; see §12.2 (Fragment F) for the
annunciator bar rendering.

---

### 7.J Fly-by vs. Fly-over Waypoint Turn Behavior [p. 157]

The GNX 375 (software v3.20 or later) distinguishes two coded waypoint types:

- **Fly-by waypoint:** the unit anticipates the turn, beginning the bank before the
  waypoint to capture the outbound course (standard behavior for most waypoints).
- **Fly-over waypoint:** the unit overflies the waypoint before beginning the bank.
  A distinct fly-over waypoint symbol appears on the Map for database-coded fly-over
  waypoints [p. 157; requires v3.20+]. The unit automatically applies the correct
  course based on the coded waypoint type. Consult the AIM for the operational
  definitions.

**OPEN QUESTION 3 — fly-by/fly-over turn geometry details:** the Pilot's Guide p. 157
documents the symbol and behavioral distinction; detailed turn-geometry parameters
(anticipation distance computation, corner-cutting algorithm, bank angle limits) are
not prominently documented in the available PDF. Research needed during design phase.

---

### 7.K Active Leg Transition Visual Feedback [pp. 141, 201]

When the aircraft crosses a waypoint and the unit sequences to the next leg:

- The **magenta active-leg indicator** advances on both Map and FPL pages [p. 141].
- On Map: the magenta line shifts to the new leg from the sequenced waypoint forward.
- On FPL: the active row (magenta highlight) advances to the next waypoint entry.
- CDI scale behavior during the transition follows the flight phase auto-switching rules
  in §7.D for the new leg type.

Exact visual transition timing (instantaneous vs. animated) is implementation-defined.

---

### 7.L Altitude Constraints on Flight Plan Legs

**OPEN QUESTION 1 — altitude constraint display behavior:** whether the GNX 375
automatically displays published procedure altitude restrictions (cross at/above/below/
between) on FPL legs is not documented in the extracted Pilot's Guide PDF.

**VCALC is not automatic:** the Vertical Calculator (§4.8, Fragment C; §10, Fragment E)
is a pilot-input planning tool for advisory descent profile information only. VCALC is
not an automatic display of published procedure altitude constraints.

Flag: **behavior unknown from available documentation; research needed during design
phase.** Spec body does not assert a feature specification for altitude constraint display.

---

### 7.M ARINC 424 Leg Type Handling

**OPEN QUESTION 2 — ARINC 424 leg type enumeration:** the GNX 375 Pilot's Guide cites
ARINC 424 leg types in procedure examples but does not enumerate the full supported set.

**Confirmed types from Pilot's Guide examples:**
- **TF** — Track to Fix (standard approach and en route legs)
- **CF** — Course to Fix (common in approaches; defined course to a specific fix)
- **DF** — Direct to Fix (used in missed approach procedures)
- **RF** — Radius to Fix (constant-radius circular path; see §7.5 RF Legs)

Flag: **full enumeration is research-needed during design phase.** The complete set of
supported ARINC 424 leg types (CI, CA, FA, FC, FM, VA, VI, VM, etc.) is not confirmed
in available documentation. Implementation must be validated against actual navigation
database procedure decoding.

> **AMAPI notes (§7 overall):**
> - `docs/knowledge/amapi_by_use_case.md` §1 (Xpl_dataref_subscribe for GPS flight phase,
>   CDI source, lateral deviation)
> - `docs/knowledge/amapi_by_use_case.md` §2 (command dispatch for approach activation,
>   missed approach, direct-to, OBS toggle)
> - `docs/knowledge/amapi_patterns.md` Pattern 2 (multi-variable bus for flight phase +
>   deviation data)
> - `docs/knowledge/amapi_patterns.md` Pattern 17 (annunciator visible for flight phase
>   annunciations and mode transitions)
> - `docs/knowledge/amapi_by_use_case.md` §10 (Nav_get / Nav_calc_distance for §7.9
>   TSAA waypoint queries)
> - `docs/knowledge/amapi_by_use_case.md` §11 (Persist_add for approach + OBS state)

**Open questions / flags (§7 overall):**
- XPL dataref names for GPS flight phase (ENRT, TERM, LNAV, LPV, etc.): require
  design-phase research from XPL dataref reference.
- SBAS/WAAS dataref availability in XPL: per-approach-type status requires design-phase
  verification.

---

## Coupling Summary

This section is authored per D-18 for CD/CC coordination across the 7-fragment spec. It is not part of the spec body and is stripped on assembly.

### Backward cross-references (sections this fragment references authored in prior fragments)

- Fragment A §1 (Overview): GNX 375 baseline framing, no-internal-VDI constraint (D-15) — referenced throughout §7 RNAV/Visual/Autopilot and §7.C/§7.G content.
- Fragment A §2 (Physical Layout & Controls): inner knob push = Direct-to (GNX 375 pattern) — referenced in §6.1.
- Fragment A §3 (Power-On / Startup / Database): no direct Fragment D dependency.
- Fragment A Appendix B (Glossary): terms verified-present via grep before writing this Coupling Summary. **Confirmed present as formal glossary entries:** FAF, MAP, LPV, LNAV, SBAS, WAAS, TSAA, FIS-B, UAT, 1090 ES, Extended Squitter, TSO-C112e, TSO-C166b, WOW, IDENT, Flight ID, GPSS, VDI, CDI, OBS, RAIM, VCALC, DTK, ETE, XTK, XPDR. **NOT claimed (absent from Appendix B per ITM-08/X17 finding):** EPU, HFOM/VFOM, HDOP, TSO-C151c.
- Fragment B §4.2 (Map Page): §5.4 Graphical FPL Editing acts on the Map page display — cross-ref.
- Fragment B §4.3 (FPL Page): §5.1–5.9 act on this display; GPS NAV Status indicator key cross-ref for CDI On Screen and graphical edit feedback.
- Fragment B §4.4 (Direct-to Page): §6.1–6.6 act on this display.
- Fragment C §4.7 (Procedures Display Pages): §7.1–7.9 + §7.A–7.M operational workflows act on these displays; §7.5 approach types table consistent with §4.7 (same 7 types); §7.2 GPS Flight Phase annunciations table matches §4.7 (11 rows, same color semantics).
- Fragment C §4.9 (Hazard Awareness): §7.9 TSAA-during-approach cross-refs §4.9; TSAA GNX 375-only framing consistent; OPEN QUESTION 6 for aural delivery preserved in §4.9.
- Fragment C §4.10 (Settings/System): §7.D CDI scale auto-switching cross-refs §4.10 CDI Scale + CDI On Screen; §7.G CDI deviation display cross-refs §4.10 CDI On Screen.

### Forward cross-references (sections this fragment writes that later fragments will reference)

- §5 FPL editing → §10 Settings (Fragment E) for pilot-settings-side behaviors (CDI scale, CDI On Screen).
- §5.4 Graphical FPL Editing → §15 External I/O (Fragment G) for flight-plan-change datarefs.
- §5.5 OBS Mode → §10.1 (Fragment E) for OBS settings page detail.
- §6 Direct-to → §15 External I/O (Fragment G) for direct-to command dispatch.
- §7 Procedures → §10 Settings (Fragment E) for CDI Scale + CDI On Screen settings workflows.
- §7.5 / §7.C / §7.G / §7.8 → §15.6 External CDI/VDI Output Contract (Fragment G) for the external-output side of all vertical-deviation behavior.
- §7.8 Autopilot Outputs → §15 External I/O (Fragment G) for GPSS + APR output datarefs; open question for dataref names preserved.
- §7.9 XPDR + ADS-B approach interactions → §11 Transponder + ADS-B (Fragment F) for XPDR control detail; §11.4 XPDR modes; §11.11 ADS-B In receiver; §12.4 aural alert hierarchy (Fragment F); §15 External I/O (Fragment G) for XPDR + ADS-B datarefs.
- §7.2 GPS Flight Phase Annunciations → §12.2 Alert Annunciations (Fragment F) for annunciator-bar rendering.
- §7.F Approach mode transitions → §13 Messages (Fragment F) for advisory message text ("GPS approach downgraded. Use LNAV minima.").

### §7.9 authorship note

Fragment D introduces §7.9 as a new numeric sub-section under §7 to resolve Fragment C's two forward-refs (per ITM-09). The outline did not have a §7.9 heading; Fragment D creates it. On assembly, §7 presents §§7.1–7.9 numeric (in order) followed by §§7.A–7.M lettered augmentations. Fragment C §4.7 Open Questions 1 and 2 both forward-reference §7.9; those references resolve to this new sub-section.

### Outline coupling footprint

This fragment draws from outline §§5–7 only. No content from §§1–4 (Fragments A + B + C), §§8–15, or Appendices A/B/C is authored here.
