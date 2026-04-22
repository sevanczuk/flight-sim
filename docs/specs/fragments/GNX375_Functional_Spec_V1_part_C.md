---
Created: 2026-04-22T17:20:00-04:00
Source: docs/tasks/c22_c_prompt.md
Fragment: C
Covers: §§4.7–4.10 (Procedures, Planning, Hazard Awareness, Settings/System display pages)
---

# GNX 375 Functional Spec V1 — Fragment C

Fragment C of 7 per D-18. Covers §§4.7–4.10 (Procedures, Planning, Hazard Awareness,
and Settings/System display pages). The §4 parent scope paragraph was authored in Fragment B
under `## 4. Display Pages`; this fragment opens directly with §4.7 and appends sub-sections
to §4 without duplicating the parent header. On assembly, Fragments B and C concatenate to
form a single continuous §4 section.

---

### 4.7 Procedures Pages [pp. 181–207]

**Scope.** The Procedures pages provide display structure for loading and monitoring instrument
procedures — departures (SIDs), arrivals (STARs), and approaches. The page set is structurally
identical to the GNC 355/355A. This sub-section documents page layout, fields, controls, and
annunciations; operational workflows for loading and flying procedures are in §7 (Fragment D).
XPDR altitude reporting during approach and ADS-B traffic behavior during approach phases are
forward-references to §7.9 and §11 — those interaction details are not authored here.

#### Procedures app overview [p. 181]

The Procedures app is launched from the **Procedures** app icon on the Home page (§4.1,
Fragment B) or via the FPL menu from the Active Flight Plan page (§4.3, Fragment B). The
app provides access to departure, arrival, and approach procedures associated with airports
in the navigation database. Feature requirements: a baro-corrected altitude source is needed
for automatic sequencing of altitude leg types; without one, altitude legs require manual
sequencing.

Lateral and vertical guidance is available for visual and GPS/RNAV approaches. The published
instrument approach procedures support both precision (LPV) and non-precision (LNAV, LP)
approaches. Feature limitation: the flight plan allows only one departure, one arrival, and
one approach procedure at a time; loading a new procedure replaces the existing one.

#### GPS Flight Phase Annunciations [pp. 184–185]

The annunciator bar displays the current GPS flight phase as a colored mode label. Under
normal conditions, annunciations are **green**. They turn **yellow** when cautionary conditions
exist (for example, GPS integrity degraded or approach downgraded to lower minimums). The
flight phase annunciation is a direct indication of current CDI scale behavior for the active
navigation source.

| Annunciation | Phase | CDI Scale | Notes |
|---|---|---|---|
| OCEANS | Oceanic | 2.0 nm | Oceanic en route operations |
| ENRT | En Route | 2.0 nm | Standard en route phase |
| TERM | Terminal | 2.0 nm (or CDI scale) | Within 31 nm of destination |
| DPRT | Departure | 2.0 nm | Departure airport proximity |
| LNAV | LNAV Approach | Angular (~0.30 nm) | Lateral navigation; non-precision; fly to published MDA |
| LNAV/VNAV | LNAV/VNAV Approach | Angular (~0.30 nm) | Baro-VNAV advisory vertical; fly to MDA |
| LNAV+V | LNAV+V Approach | Angular (~0.30 nm) | GPS-derived advisory vertical; +V = advisory only; fly to MDA |
| LP | LP Approach | Angular (~0.30 nm) | SBAS localizer performance; lateral only; fly to LP minimums |
| LP+V | LP+V Approach | Angular (~0.30 nm) | LP + GPS-derived advisory vertical; fly to LP minimums |
| LPV | LPV Approach | Angular (~0.30 nm) | SBAS precision to DA; primary vertical guidance; CAT I equivalent |
| MAPR | Missed Approach | ±0.30 nm | System using missed approach integrity |

Color semantics: **Green** = normal operating conditions. **Yellow** = caution; integrity degraded
or approach downgraded (e.g., LPV downgraded to LNAV on HAL/VAL exceedance). Approach
downgrade triggers a pilot advisory in the message queue ("GPS approach downgraded. Use LNAV
minima.") and a CDI scale behavior change. See §7 (Fragment D) for approach-mode transitions.

#### Departure selection page [pp. 186–187]

A departure (SID) is loaded at the departure airport. The flight plan allows only one departure
procedure at a time; loading a new departure replaces the existing entry. Selecting a departure,
transition waypoint, and runway defines the SID route geometry, which is inserted at the
beginning of the flight plan.

Feature limitation: vector-only departures are not supported for GPS course guidance on departure
legs. The FPL page displays loaded departure waypoints in sequence with type icons.

**Flight Plan Departure Options menu** (accessed via FPL or Procedures page):
- **Select Departure** — opens departure procedure selection page
- **Remove Departure** — removes the loaded departure from the flight plan

#### Arrival (STAR) selection page [pp. 188–189]

A Standard Terminal Arrival (STAR) can be loaded at any airport with a published arrival
procedure. One arrival per flight plan; loading a new arrival replaces the existing entry.
Selecting an arrival, transition waypoint, and runway defines the STAR route and inserts it
before the destination airport entry in the flight plan.

**Flight Plan Arrival Options menu:**
- **Select Arrival** — opens arrival procedure selection page
- **Remove Arrival** — removes the loaded arrival from the flight plan

#### Approach selection page [pp. 190–191, 199–206]

One approach is allowed per flight plan. Loading an alternate approach during a missed approach
retains all missed approach legs; otherwise, a new approach replaces the existing entry. Approach
types are listed per the table below. SBAS approaches can be loaded via a Channel ID key
selection method: tapping the Channel ID key on the approach selection page allows entry of the
published SBAS Channel ID for rapid approach identification.

**Approach types supported [pp. 199–206]:**

| Approach Type | Vertical Guidance | SBAS Required | GPS Nav Approval | Notes |
|---|---|---|---|---|
| LNAV | None | No | Yes | Lateral only; non-precision; fly to published MDA |
| LNAV/VNAV | Baro-VNAV (advisory) | No | Yes | Baro-VNAV advisory vertical; fly to MDA |
| LNAV+V | GPS-derived (advisory) | No | Yes | +V suffix = advisory only; fly to MDA |
| LPV | SBAS/GPS (primary) | Yes | Yes | Primary vertical guidance to DA; precision-equivalent |
| LP | None | Yes | Yes | SBAS localizer performance; lateral only; fly to LP minimums |
| LP+V | GPS-derived (advisory) | Yes | Yes | LP + advisory vertical; fly to LP minimums |
| ILS | Not applicable | No | No | GPS monitoring only; not approved for GPS navigation; see ILS display page |

**Flight Plan Approach Options menu:**
- **Remove Approach** — removes the loaded approach from the flight plan

#### ILS Approach display page [p. 198]

When an ILS approach is loaded, the unit displays a pop-up advisory: "ILS and LOC approaches
are not approved for GPS." The GNX 375 provides GPS-based monitoring during an ILS approach
but is not the primary navigation source. The annunciator bar remains at TERM (no LPV or LNAV
annunciation is displayed for ILS). The pilot flies the ILS using the aircraft's NAV receiver;
the 375 provides a position reference only.

#### Missed Approach page [p. 193]

The method for activating a missed approach depends on aircraft position relative to the missed
approach point (MAP):

- **Before MAP:** Tap **Activate Missed Approach**. Available from the Active FPL page (Home >
  Flight Plan > select approach > Activate Missed Approach) or from the Procedures app (Home >
  Procedures > Activate Missed Approach). Once selected, the CDI switches to missed approach
  guidance immediately.
- **After MAP:** Crossing the MAP automatically suspends waypoint sequencing. A pop-up prompt
  appears; the pilot selects either remain suspended or activate missed approach to continue
  guidance. See §7.6 (Fragment D) for the full missed approach operational workflow.

#### Approach Hold page [pp. 194–195]

Selecting an approach hold in the flight plan opens the **Hold Options** menu. Changes take
effect in the active flight plan immediately. Menu options:

- **Activate Hold** — activates the selected holding pattern
- **Insert After** — inserts a waypoint after the hold
- **Edit Hold** — modify hold direction, inbound course, leg type (time or distance), and timing
- **Exit Hold** — exit the holding pattern before the timer expires
- **Remove** — removes the selected hold from the flight plan

Non-required holding patterns: on RNP approach initialization, a pop-up appears prompting the
pilot to enter or skip the non-required hold. The pilot's selection determines whether the
approach hold leg is included in the active route. See §7.7 (Fragment D) for hold operational
detail.

#### DME Arc indicator [p. 196]

The unit supports approaches containing DME arcs. The DME Arc page displays left/right lateral
guidance relative to the arc. Manual DME Arc leg activation is required when the aircraft is
within the arc activation shaded area depicted on the approach display. The DME Arc
intermediate fix and the arcing fix (VOR) are labeled on the arc display.

#### RF Leg indicator [p. 197]

The unit supports radius-to-fix (RF) legs associated with RNAV RNP 0.3 non-AR approaches
when approved by the aircraft installation. An RF leg is a constant-radius circular path around
a defined turn center, starting and terminating at a fix. Flying an RF leg is operationally
similar to a DME arc approach. See AC 90-101A for regulatory context.

#### Vectors to Final indicator [p. 197]

Vectors to Final (VTF) mode allows loading an approach with ATC radar vectors directly to the
final approach course, bypassing published approach transition fixes. When active, the unit
provides guidance from the current position to the final approach fix (FAF) on an intercept
course. The VTF indicator appears on the FPL page alongside the approach leg sequence.

#### Visual Approach page [pp. 205–206]

The Visual Approach page provides advisory horizontal and optional vertical guidance for a
selected runway at the destination airport. The Visual Approach selector key becomes active
when the aircraft is **within 10 nm of the destination airport**. The key may appear on the Map
page or at the left of the screen when the supporting airport is selected.

**Loading (from Map):** Select the airport icon on the Map → tap **Visual** → select from
the list of available visual approaches.

**Feature requirements:** valid terrain database.

**Guidance provided:**
- Lateral guidance is always provided for visual approaches; the CDI indicates deviation from
  the runway final approach track.
- Optional vertical guidance: the unit can provide advisory vertical information for the selected
  runway. However, **vertical deviation indications are not displayed on the GNX 375 screen**.
  Per D-15 and Pilot's Guide p. 205: "Only external CDI/VDI displays provide vertical deviation
  indications." The GNX 375 has no internal VDI. All vertical deviation output goes exclusively
  to external CDI/VDI instruments. The annunciator bar continues to show flight phase; no
  glidepath needle appears on any GNX 375 internal display. See §15.6 (Fragment G) for the
  external CDI/VDI output contract.

Feature limitation: not all airports in the database support visual approaches. Advisory
horizontal guidance annunciations appear in the CDI On Screen indicator when active (see §4.10).

#### Autopilot Outputs display [p. 207]

The GNX 375 outputs roll steering (GPSS) guidance and LPV glidepath capture guidance to
compatible autopilots.

**Roll steering (GPSS):** Output to autopilots configured to receive GPSS (GPS Steering). Roll
steering terminates when the autopilot approach mode is selected; it resumes after missed
approach initiation. When using autopilot heading mode on heading legs, the pilot must engage
heading mode and set the heading bug appropriately. The unit displays an advisory when GPSS
output begins.

**LPV glidepath capture:** Applicable to King autopilots KAP 140 and KFC 225. When an LPV
approach is loaded and the aircraft is configured for APR output, the unit sends glidepath
capture guidance to the autopilot. "Enable APR Output" advisory alerts the pilot when the
autopilot is compatible and the APR output can be activated; manual activation is required.
Feature requirement: availability is configuration-dependent. See §15.6 (Fragment G) for the
external I/O output contract for roll steering and APR coupling.

> **AMAPI notes:**
> - `docs/knowledge/amapi_by_use_case.md` §1 (`Xpl_dataref_subscribe` for GPS flight phase
>   datarefs; flight phase annunciation reads from simulator GPS state)
> - `docs/knowledge/amapi_by_use_case.md` §2 (command dispatch for approach activation,
>   missed approach activation)

**Open questions:**

1. **XPDR altitude reporting during approach:** The GNX 375 operates in Altitude Reporting
   (ALT) mode during the approach phase; altitude reporting to ATC continues automatically.
   The interaction between WOW (weight-on-wheels) state, approach phase annunciation, and
   XPDR ALT mode behavior is documented in §7.9 (Fragment D) and §11.4 (Fragment F).
   Not authored here — §4.7 is a display-page reference only.

2. **ADS-B traffic display during approach / TSAA behavior:** TSAA application runs when
   ADS-B In data is available; traffic alerting continues during approach flight phases.
   Interaction detail between TSAA state and GPS flight phase annunciations is in §7.9
   (Fragment D).

3. **Autopilot roll steering dataref names:** The Pilot's Guide (p. 207) documents the GPSS
   and APR output features but does not enumerate the specific XPL dataref names for roll
   steering or APR coupling. Research required during the design phase. See §15.6
   (Fragment G) for the external I/O contract where these datarefs will be specified.

---

### 4.8 Planning Pages [pp. 209–221]

**Scope.** The Planning pages provide utility calculation tools for vertical descent planning,
fuel planning, density altitude/TAS/wind calculations, and RAIM prediction. This page set is
**identical across GPS 175, GNC 355/355A, and GNX 375** — no GNX 375-specific framing
applies here. The pages are utility aids only; they do not drive navigation guidance or alter
flight plan behavior.

#### Planning pages overview [p. 210]

Planning pages are accessed from Home > Utilities. Four planning tools are available:

| Page | Purpose | Key Inputs | Key Outputs |
|---|---|---|---|
| Vertical Calculator (VCALC) | Descent planning to a target altitude | Target ALT, altitude type, target waypoint | Time to TOD, required VS |
| Fuel Planning | Fuel condition analysis along a route | Fuel on board, fuel flow, route | Fuel remaining, endurance |
| DALT/TAS/Wind Calculator | Density altitude, TAS, and wind computation | Indicated altitude, BARO, CAS | Density altitude, TAS, winds aloft |
| RAIM Prediction | GPS RAIM availability for a future fix/time | Waypoint, date, time | RAIM availability status |

#### Vertical Calculator (VCALC) page [pp. 211–212]

The VCALC page calculates descent profile advisory information to reach a specified target
altitude at a specified waypoint.

**Setup fields:**
- **Target ALT** — final target altitude for the descent
- **Altitude Type** — MSL (above mean sea level) or Above WPT (altitude above the target waypoint)
- **Target Waypoint** — the waypoint at which the target altitude should be reached
- **Time to TOD** — time remaining until the calculated top of descent point
- **Required VS** — the vertical speed required to meet the target altitude at the target waypoint

Feature limitation: **VCALC messages are advisory only.** Do not rely on VCALC messages as
the sole means of avoiding terrain and obstacles or following ATC guidance. VCALC provides
a planning reference; the pilot must cross-validate against other navigation data sources.
VCALC is a pilot-input planning tool — it is NOT an automatic display of published procedure
altitude constraints. See OPEN QUESTION 1 in §4.3 (Fragment B) regarding altitude constraint
display behavior.

#### Fuel Planning page [pp. 213–216]

The Fuel Planning page computes fuel conditions based on route, ground speed, fuel on board,
and fuel flow. Two planning modes are available:

- **P.Position mode** — uses the aircraft's current GPS position as the departure point; analyzes
  remaining fuel along the active or programmed flight plan from present position forward
- **Waypoint-to-waypoint mode** — analyzes fuel conditions for a segment between two specified
  waypoints, independent of the active flight plan

**Input fields:** fuel on board, fuel flow. Fuel flow may be entered manually or supplied
automatically from an Engine Indication System (EIS) if connected. Active or programmed
flight plan waypoints, or a direct-to fix, may be used as the route reference.

**Output fields:** fuel remaining at each waypoint, total endurance based on current fuel
and fuel flow.

#### DALT/TAS/Wind Calculator page [pp. 217–219]

Computes density altitude, true airspeed, and winds aloft from pilot-entered sensor data.

**Requirements:** a pressure altitude source must be available. Without a pressure altitude
source, density altitude calculations cannot be completed.

**Inputs:**
- Indicated altitude
- BARO (barometric altimeter setting)
- CAS (calibrated airspeed)

**Outputs:**
- Density altitude
- TAS (true airspeed)
- Winds aloft (speed and direction, computed from TAS and GPS ground speed/track)

#### RAIM Prediction page [pp. 220–221]

Determines GPS RAIM (Receiver Autonomous Integrity Monitoring) availability for a specified
waypoint, date, and time combination. RAIM checks verify that adequate satellite geometry
exists at the planned fix and time.

> **Note:** RAIM availability prediction is intended for use in areas where WAAS coverage is
> not available. RAIM prediction is not required in areas of WAAS coverage.

**Requirements:** active satellite constellation data must be available.

**Inputs:** waypoint identifier (with waypoint search options), date, time.

**Output:** RAIM availability status (available / not available) for the entered parameters.

> **AMAPI notes:**
> - `docs/knowledge/amapi_by_use_case.md` §1 (dataref subscriptions for sensor inputs to DALT
>   calc — altitude, airspeed, barometric pressure, GPS ground speed and track)
> - Planning pages are primarily static data entry; no continuous sim-variable subscriptions
>   are required beyond the DALT inputs

**Open question:**

- **EIS fuel flow integration:** Fuel flow may be sourced from a connected Engine Indication
  System (EIS, optional equipment). The spec must distinguish manual fuel flow entry from
  EIS-sourced fuel flow and document the fallback behavior when EIS data is absent or
  invalid. Research during design phase.

---

### 4.9 Hazard Awareness Pages [pp. 223–269]

**Scope.** The Hazard Awareness pages provide three dedicated display pages for weather
(FIS-B), traffic (ADS-B In), and terrain/obstacle awareness. **Key GNX 375 framing:**
the GNX 375 incorporates a built-in dual-link ADS-B In receiver (978 MHz UAT + 1090 ES),
providing FIS-B weather and ADS-B traffic data without any external hardware. GPS 175 and
GNC 355/355A do not have built-in ADS-B In; they require an external GDL 88 or GTX 345
for these features. Additionally, the GNX 375 adds TSAA (Traffic Situational Awareness with
Alerting), including aural traffic alerts, which are not available on GPS 175 or GNC 355/355A.

#### FIS-B Weather page [pp. 225–244]

**GNX 375 framing:** the GNX 375 incorporates a built-in 978 MHz UAT receiver that receives
FIS-B (Flight Information Services – Broadcast) data directly, with no external hardware
required [p. 225]. GPS 175 requires an external ADS-B device (GDL 88 or GTX 345) for
FIS-B reception; GNC 355/355A similarly requires external hardware. This is the primary
differentiator for this sub-section.

**Data transmission limitations [pp. 225–226]:** FIS-B is line-of-sight; NOTAM coverage is
limited to NOTAMs within 30 days of current date; datalink weather is a snapshot — not a
real-time feed. Do not rely solely on datalink weather; supplement with AFSS or ATC reports.

**Weather page layout:** Dedicated FIS-B Weather page plus Map overlay (§4.2, Fragment B).

**FIS-B weather products [pp. 230–243]:**

| Product | Type | Notes |
|---|---|---|
| NEXRAD | Graphical precipitation | CONUS and Regional coverage; mutually exclusive with Lightning and Terrain on Map |
| METARs | Text weather reports | Aviation routine weather observations |
| TAFs | Text forecasts | Terminal aerodrome forecasts |
| Graphical AIRMETs | Graphical weather advisory | G-AIRMET; filter available via setup menu |
| SIGMETs | Text/graphical advisories | Significant meteorological information |
| PIREPs | Text pilot reports | Pilot weather reports |
| Cloud Tops | Graphical | Cloud top altitude product |
| Lightning | Graphical | Lightning strike data; mutually exclusive with NEXRAD and Terrain on Map |
| CWA | Text advisories | Center Weather Advisories |
| Winds/Temps Aloft | Graphical/text | Wind speed, direction, and temperature at altitude |
| Icing | Graphical | Icing potential and severity |
| Turbulence | Graphical | Turbulence forecast |
| TFRs | Graphical | Temporary Flight Restriction boundaries |

**Product status page states [p. 231]:**

| State | Description |
|---|---|
| Unavailable | Product cannot be received or displayed; source data absent |
| Awaiting Data | Product is awaiting first uplink from ground station |
| Data Available | Product data has been received and is current |

**Product age timestamp [p. 232]:** Each product displays a timestamp of last receipt; stale
data remains displayed with a stale indicator. Pilots must monitor product age.

**WX Info Banner [p. 228]:** Tapping a weather icon shows a banner with product ID, type,
and age for the selected element.

**FIS-B setup menu [pp. 229, 237]:** Orientation setting; G-AIRMET category filters (IFR,
mountain obscuration, turbulence, icing, freezing level, surface winds, low-level wind shear).

**Raw text reports [pp. 242–243]:** METARs and winds/temps aloft available as plain-text
reports; accessible by tapping the text report key.

**FIS-B reception status page [p. 244]:** Receiver operational state, last uplink time, and
ground station coverage. Also accessible from the FIS-B weather setup menu; see §4.10
ADS-B Status page for the FIS-B WX Status sub-page.

#### Traffic Awareness page [pp. 245–256]

**GNX 375 framing:** the GNX 375 incorporates a built-in dual-link ADS-B In receiver
covering both 1090 ES (Extended Squitter) and 978 MHz UAT, with no external hardware
required [p. 245]. GPS 175 requires an external ADS-B In product (GDL 88 or GTX 345);
GNC 355/355A similarly requires external hardware. This built-in capability enables both
standard ADS-B traffic display and TSAA alerting on the GNX 375 without any additional
avionics installation.

**Traffic applications [pp. 245–246]:**
- **ADS-B traffic display** — available on all three units (GPS 175 and GNC 355/355A via
  external hardware; GNX 375 via built-in receiver). Shows ADS-B In targets on the Traffic
  page and as a Map overlay.
- **TSAA (Traffic Situational Awareness with Alerting) — GNX 375 only.** TSAA is a traffic
  alerting application available exclusively on the GNX 375. GPS 175 and GNC 355/355A do
  not have TSAA; they have ADS-B traffic display only (via external hardware). TSAA adds:
  - Advisory traffic alerts with textual annunciations, color-coded target icons on the Traffic
    page, and pop-up windows on other pages when a traffic alert is active
  - **Aural traffic alerts (GNX 375 only)** — see OPEN QUESTION 6 below; cross-ref §12.4
    (Fragment F) for aural alert hierarchy

**Traffic display layout [pp. 247–250]:**

| Display Element | Description |
|---|---|
| Ownship icon | Depicts current aircraft position with nose direction at top of display |
| Directional traffic symbol | Triangular or arrowhead icon showing intruder heading; tip = actual intruder location |
| Non-directional traffic symbol | Circular icon; center = actual intruder location; used when intruder heading unknown |
| Off-scale alert | Half-symbol at the edge of the range ring; indicates traffic beyond the current display range |
| Altitude separation value | Displayed above or below the traffic symbol; plus sign = traffic above ownship; minus = below; in hundreds of feet |
| Vertical trend arrow | Up or down arrow alongside altitude separation value; indicates intruder climbing or descending |

**Traffic setup menu [pp. 251–252]:**

| Setting | Options |
|---|---|
| Motion vectors | Absolute, Relative, Off — shows predicted intruder motion vectors |
| Altitude filtering | All, Above, Below, Normal — filters the altitude range of traffic displayed |
| ADS-B display | Enable/disable ADS-B target display |
| Self-test | Initiates a traffic system self-test |

**Traffic interactions [p. 253]:** Tapping a traffic symbol opens a detail pop-up showing the
intruder's registration/callsign, altitude, and speed (when available from the ADS-B message).

**Traffic annunciations [p. 254]:** Textual traffic annunciations appear at the bottom of the
Traffic page screen area. Multiple annunciation types correspond to traffic alert severity and
traffic application state.

**Traffic alerting [pp. 255–256]:**
- **Alert types:** TA (Traffic Advisory) — increased situational awareness; alert remains active
  until the area is clear of all TAs
- **Alerting parameters:** altitude separation threshold; closure rate between ownship and
  intruder; time to closest point of approach (CPA)
- **Alert presentation:** textual annunciations on Traffic page; color-coded target icons; pop-up
  window when Traffic page is not the active page

**TSAA aural alerts (GNX 375 only) [p. 255]:** When a traffic threat is detected, TSAA emits
an aural advisory. The **mute function** silences only the currently active aural alert; it
does not mute future alerts. Aural alerts are a GNX 375-only feature — not available on
GPS 175 or GNC 355/355A. Cross-ref §12.4 (Fragment F) for the full aural alert hierarchy and
delivery mechanism. **OPEN QUESTION 6 — TSAA aural alert delivery mechanism:** whether the
375 instrument emits aural alerts via `sound_play` directly or depends on an external audio
panel integration is a spec-body design decision. Behavior TBD.

#### Terrain Awareness page [pp. 257–269]

**Scope.** The Terrain Awareness page provides forward-looking terrain alerting (FLTA) and
premature descent alerting (PDA), displaying terrain and obstacle data relative to the
aircraft's position. This page is functionally identical across GPS 175, GNC 355/355A, and
GNX 375; no GNX 375-specific framing applies.

**Feature requirements [p. 257]:**
- Valid terrain/obstacle database (loaded in unit memory; see §3.5, Fragment A)
- Valid 3-D GPS position (4 satellites minimum for GPS altitude used by terrain functions)

**GPS Altitude for Terrain [p. 258]:** Terrain functions use GPS altitude derived from
satellite measurements; 3-D fix with 4 satellites minimum required. GPS altitude differs
from barometric altitude.

**Database limitations [p. 259]:** Not all-inclusive; not TSO-C151c certified. For
situational awareness only — cross-validate with official charts.

**Terrain page layout [pp. 260–264]:** Ownship icon; terrain elevation color coding (red =
above aircraft altitude; yellow = within alerting threshold; muted = well below); obstacle
depictions (towers, power lines, wires) with altitude labels.

**Terrain alerting [pp. 265–269]:**

| Alert Type | Description |
|---|---|
| FLTA — RTC | Reduced Terrain Clearance — terrain ahead within alerting threshold |
| FLTA — RLC | Reduced Level-off Clearance |
| FLTA — ROC | Required Obstacle Clearance |
| FLTA — ITI | Imminent Terrain Impact |
| FLTA — ILI | Imminent Level-off Impact |
| FLTA — IOI | Imminent Obstacle Impact |
| PDA | Premature Descent Alert — descent below the safe altitude before the destination runway |

Alert severity: cautions (yellow) and warnings (red) indicate severity and threat type. Textual
annunciations and pop-up alerts appear. Threat location is depicted on the Terrain page. An
**inhibit control** allows the pilot to temporarily suppress terrain alerting in specific
conditions; re-enabling returns alerting to normal operation.

> **AMAPI notes:**
> - `docs/knowledge/amapi_by_use_case.md` §10 (Map overlays for weather, traffic, and terrain;
>   `Map_add` API for overlay base)
> - Canvas-drawn terrain and obstacle overlays (elevation color shading, obstacle depictions) →
>   **B4 Gap 1:** same design-decision gap as §4.2 Map Page (Fragment B). Canvas-drawn terrain
>   overlay implementation is a design-phase decision deferred to the design phase; the spec
>   body documents the behavior contract only. Do not resolve here.
> - `docs/knowledge/amapi_patterns.md` Pattern 17 (annunciator visible for traffic and terrain
>   annunciations — traffic alert state, terrain alert state)

**Open questions:**

1. **FIS-B weather data source in Air Manager:** Spec must decide whether weather display is
   dataref-subscribed FIS-B data from the simulator, a static dataset, or deferred as
   "requires external FIS-B data bridge." Spec must also define behavior when no FIS-B uplink
   is available (no-data message, stale-data indicator, or suppressed display). Design-phase
   decision.

2. **OPEN QUESTION 6 — TSAA aural alert delivery mechanism:** whether the 375 instrument
   emits aural alerts via `sound_play` directly or depends on an external audio panel
   integration is a spec-body design decision. Behavior TBD. Cross-ref §12.4 (Fragment F).

3. **ADS-B In data availability in simulators:** X-Plane 12 has partial ADS-B dataref
   exposure; MSFS has limited ADS-B traffic data access. Spec must define behavior when
   ADS-B In data is absent vs. degraded, and when TSAA cannot access traffic data.
   Design-phase research required.

4. **Terrain/obstacle canvas overlays (B4 Gap 1):** Same design-decision gap as §4.2 Map
   Page (Fragment B). Design decision deferred to design phase. Do not resolve in spec body.

---

### 4.10 Settings and System Pages [pp. 86–109]

**Scope.** The Settings and System pages provide pilot-configurable settings and system status
readouts. The GNX 375 adds the CDI On Screen setting (shared with GPS 175; not available on
GNC 355/355A), reframes the ADS-B Status page for the built-in receiver (no external LRU),
and adds ADS-B traffic data logging to the Logs page. Operational configuration workflows
for all settings are in §10 (Fragment E); this sub-section documents the display page layouts.

#### Pilot Settings page [p. 86]

The Pilot Settings page provides access to all user-configurable instrument settings. A
summary of available settings:

| Setting | GNX 375 | GPS 175 | GNC 355/355A | Notes |
|---|---|---|---|---|
| CDI Scale | ✓ | ✓ | ✓ | 0.30 / 1.00 / 2.00 / 5.00 nm |
| CDI On Screen | ✓ | ✓ | — | GNX 375 / GPS 175 only — NOT GNC 355/355A |
| Airport Runway Criteria | ✓ | ✓ | ✓ | Surface type and minimum length filters |
| Clocks and Timers | ✓ | ✓ | ✓ | Countup, countdown, flight timer; UTC or local |
| Page Shortcuts | ✓ | ✓ | ✓ | Customize locater bar slots 2–3 |
| Alerts Settings | ✓ | ✓ | ✓ | Airspace alerts, alert altitude, airspace type filters |
| Unit Selections | ✓ | ✓ | ✓ | Distance, speed, altitude, VSI, nav angle, wind, pressure, temperature |
| Display Brightness | ✓ | ✓ | ✓ | Automatic (photocell) or manual override |
| Scheduled Messages | ✓ | ✓ | ✓ | One-time, periodic, event-based reminders |
| Crossfill | ✓ | ✓ | ✓ | Dual Garmin GPS configuration (FPL, user waypoints, pilot settings) |

#### CDI Scale setup page [p. 87]

The CDI Scale page sets the full-scale deflection value for CDI output. Available settings:

| Setting | Full-Scale Deflection |
|---|---|
| 0.30 nm | 0.30 nm (approach scale) |
| 1.00 nm | 1.00 nm (terminal scale) |
| 2.00 nm | 2.00 nm (en route scale) |
| 5.00 nm | 5.00 nm (wide-area scale) |

The selected CDI scale applies when the unit is in a flight phase where the pilot-selected
scale is active. Automatic CDI scale switching (ENRT to TERM to Approach) overrides the
manual setting during applicable flight phases; the manual setting caps the upper scale bound.
Horizontal Alarm Limits (HAL) follow the active CDI scale by flight phase. See §10.1 and §7.D
(Fragment D) for the full CDI scale auto-switching behavior.

#### CDI On Screen [p. 89] — GNX 375 / GPS 175 only (NOT GNC 355/355A)

The CDI On Screen setting is **available on GNX 375 and GPS 175 only**. It is **not present on
GNC 355/355A**. Toggling this setting displays a lateral CDI scale indicator on screen when active.

**When active:**
- A **lateral deviation indicator** appears below the GPS NAV Status indicator key (see §4.3,
  Fragment B) in the lower-right area of the FPL page
- The CDI provides **lateral deviation indications only** — no vertical deviation indicator is
  present. The GNX 375 has no internal VDI per D-15; vertical deviation is output only to
  external CDI/VDI instruments (see §15.6, Fragment G)
- The CDI provides no indications without an active flight plan; an active flight plan is
  required for lateral deviation indications to appear

**Visual Approach lateral advisory:** when a visual approach is active, the on-screen CDI
also displays visual approach lateral advisory guidance annunciations. See §4.7 Visual
Approach above; see §15.6 (Fragment G) for the external output contract.

#### System Status page [p. 102]

The System Status page displays unit identification and database information:
- Serial number
- Software version (including database compatibility level)
- Database information (navigation, obstacles, SafeTaxi, terrain — name, cycle, expiration)
- **Transponder software version (GNX 375 only)** — displays the XPDR firmware version;
  this field is absent on GPS 175 and GNC 355/355A, which have no integrated transponder

#### GPS Status page [pp. 103–106]

The GPS Status page displays: satellite graph (signal strength bars for up to 15 SVIDs);
accuracy fields (EPU, HFOM, VFOM, HDOP); active SBAS providers (WAAS, EGNOS, etc.);
GPS annunciations and GPS alert conditions (low satellite count, RAIM unavailable, etc.).

#### ADS-B Status page [pp. 107–108] — GNX 375 built-in receiver framing

**GNX 375 framing:** the ADS-B Status page on the GNX 375 reports the status of the
**built-in dual-link ADS-B In/Out receiver — no external LRU is required**. The key label
reads "ADS-B Status" on the GNX 375. On GPS 175 and GNC 355/355A, the equivalent page
requires an external GDL 88 or GTX 345, and the key label reflects the configured external
ADS-B source. This framing distinction is the primary 375-specific aspect of this page.

**Page content:** Status access key (tap for last uplink time and GPS source); uplink time
in minutes since last FIS-B uplink with color-coded age; GPS position source reported.

**Sub-pages:**
- **FIS-B WX Status** — reception quality and ground station coverage; also accessible from
  FIS-B Weather setup menu (§4.9 above)
- **Traffic Application Status** — status of three traffic applications: AIRB (Airborne),
  SURF (Surface), ATAS (Airborne Traffic Alerting, includes TSAA). States: **On** (running;
  ownship data available) and **Available to Run** (configured; criteria not yet met)

See §11 (Fragment F) for built-in ADS-B receiver source detail; §11.11 for receiver operational
detail.

#### Logs page [p. 109]

The Logs page provides access to diagnostic and data logging functions:

- **WAAS diagnostic data logging** — available on all units (GPS 175, GNC 355/355A, GNX 375);
  stores WAAS diagnostic data in unit internal memory
- **ADS-B traffic data logging — GNX 375 only.** Stores ADS-B In traffic data received by the
  built-in dual-link receiver. This logging capability is **not available on GPS 175 or
  GNC 355/355A**. ADS-B traffic log data can be exported for post-flight analysis.

**Log export:** Home > Utilities > Logs > select **WAAS Diagnostic Log** or **ADS-B Log**;
requires SD card (FAT32, 8–32 GB — see §3.5, Fragment A). See §14 (Fragment G) for the
log storage mechanism.

> **AMAPI notes:**
> - `docs/knowledge/amapi_by_use_case.md` §12 (`User_prop_add_*` for configurable settings
>   including CDI Scale value, CDI On Screen toggle, unit selections, runway criteria,
>   brightness mode, scheduled messages)

---

## Coupling Summary

This section is authored per D-18 for CD/CC coordination across the 7-fragment spec. It is not
part of the spec body and is stripped on assembly.

### Backward cross-references (sections this fragment references authored in prior fragments)

- Fragment A §1 (Overview): GNX 375 baseline framing, no-internal-VDI constraint (D-15) —
  referenced in §4.7 Visual Approach and §4.10 CDI On Screen; ADS-B built-in framing /
  TSO-C166b — referenced in §4.9 Weather and Traffic pages.
- Fragment A §2 (Physical Layout & Controls): knob and touchscreen behaviors — implicit
  throughout §§4.7–4.10 for page navigation interactions.
- Fragment A §3 (Power-On / Startup / Database): SD card format (FAT32, 8–32 GB) —
  referenced by §4.10 Logs page without re-documentation.
- Fragment A Appendix B (Glossary): FIS-B, TIS-B, UAT, 1090 ES, TSAA, TSO-C112e,
  TSO-C166b, TSO-C151c (terrain), EPU, HFOM/VFOM, HDOP, SBAS, WOW, IDENT, Flight ID —
  all referenced without redefinition.
- Fragment B §4.1 (Home Page): Weather, Traffic, Terrain, Utilities, System Setup app icons
  already enumerated; §§4.7/4.9/4.10 scope paragraphs do NOT re-enumerate; cross-ref §4.1.
- Fragment B §4.2 (Map Page): overlay inventory (NEXRAD, Traffic, TFRs, Airspaces, SafeTaxi,
  Terrain) defined there; §4.9 deepens page-level treatment but does not redefine the overlay set.
- Fragment B §4.3 (FPL Page): procedure loading is via FPL Menu → Procedures; GPS NAV Status
  indicator key layout — cross-ref §4.3 for the FPL-side access point and CDI On Screen
  relationship.

### Forward cross-references (sections this fragment writes that later fragments will reference)

- §4.7 Procedures display pages → §7 Procedures (Fragment D) for full operational workflow
  detail (procedure loading, activation, monitoring, missed-approach sequences).
- §4.7 XPDR altitude reporting during approach → §7.9 XPDR-interaction during approach
  (Fragment D) + §11.4 XPDR modes (Fragment F).
- §4.7 ADS-B traffic during approach / TSAA behavior → §7.9 (Fragment D) + §11.11 (Fragment F).
- §4.7 Autopilot Outputs (GPSS roll steering, LPV glidepath) → §15 External I/O / datarefs
  (Fragment G).
- §4.7 Visual Approach external CDI/VDI output → §15.6 External CDI/VDI output contract
  (Fragment G).
- §4.9 FIS-B weather data source / reception → §11.11 ADS-B In receiver source detail
  (Fragment F).
- §4.9 TSAA aural alert delivery → §12.4 Aural alert hierarchy (Fragment F).
- §4.9 Terrain/obstacle canvas overlays (B4 Gap 1) → design phase resolution (no fragment).
- §4.10 Pilot Settings page → §10 Settings/System full operational detail (Fragment E) —
  §4.10 documents the display page; §10 documents configuration workflows.
- §4.10 CDI On Screen → §15.6 External CDI/VDI output contract (Fragment G) for the external
  output side.
- §4.10 ADS-B Status page → §11 Transponder + ADS-B (Fragment F) for status source detail;
  §11.11 specifically for the built-in receiver.
- §4.10 Logs (ADS-B traffic logging) → §14 Persistent State (Fragment G) for log storage
  mechanism.

### §4 parent-scope inheritance note

Fragment C does NOT author the §4 parent scope paragraph. That scope is authored by Fragment B
under `## 4. Display Pages`. Fragment C opens with `### 4.7 Procedures Pages` directly. On
assembly, the concatenation produces a single continuous §4 section: Fragment B's
`## 4. Display Pages` + parent scope + §§4.1–4.6, immediately followed by Fragment C's
§§4.7–4.10.

### Outline coupling footprint

This fragment draws from outline §§4.7–4.10 only. No content from §§1–3, §§4.1–4.6,
§§5–15, or Appendices A/B/C is authored here.
