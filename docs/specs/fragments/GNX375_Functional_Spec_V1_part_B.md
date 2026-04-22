---
Created: 2026-04-22T14:30:00-04:00
Source: docs/tasks/c22_b_prompt.md
Fragment: B
Covers: §§4.1–4.6 (Home, Map, FPL, Direct-to, Waypoint Info, Nearest pages)
---

# GNX 375 Functional Spec V1 — Fragment B

Fragment B of 7 per D-18. Covers §§4.1–4.6 (Home, Map, FPL, Direct-to, Waypoint Info,
Nearest). §§4.7–4.10 are authored in Fragment C (C2.2-C).

---

## 4. Display Pages

**Scope.** Section 4 enumerates every display page the GNX 375 presents to the pilot. For
each page, it documents the structural layout, data fields, input controls, and navigation
model. Operational workflows (creating and editing flight plans, activating direct-to courses,
loading procedures) are covered in subsequent sections (§§5–7) and cross-referenced here.
The GNX 375 adds four features relative to sibling units: an XPDR app icon on the Home page
(§4.1), a GPS NAV Status indicator key on the FPL page (§4.3), a CDI On Screen toggle
(§4.10, Fragment C), and built-in ADS-B In framing for Hazard Awareness pages (§4.9,
Fragment C). §4.11 (COM Standby Control Panel, GNC 355/355A only) is omitted entirely;
the GNX 375 has no VHF COM radio.

This fragment covers §§4.1–4.6 (Home, Map, FPL, Direct-to, Waypoint Information, and
Nearest pages). Sections §§4.7–4.10 (Procedures, Planning, Hazard Awareness, and
Settings display pages) are authored in Fragment C.

---

### 4.1 Home Page and Page Navigation Model [pp. 17, 28–29, 86]

**Scope.** The Home page is the top-level navigation hub. All applications are launched from
app icon tiles. The GNX 375 adds an XPDR app icon not present on GPS 175 or GNC 355/355A.
This sub-section documents the page layout, app icon inventory, locater bar configuration,
and key navigation primitives.

**Home page layout.** A grid of app icon tiles; tapping any icon opens the corresponding
application. Icons for apps with sub-pages (Utilities, System Setup) provide additional icon
sets on their sub-pages. The icon grid is image-based; exact tile positions require physical
device reference or screen captures (see Open questions).

**App icon inventory.** The following icons appear on the GNX 375 Home page. All icons
except XPDR are shared with GPS 175 and GNC 355/355A.

| Icon | Application | Target | GNX 375 | GPS 175 | GNC 355/355A |
|------|-------------|--------|---------|---------|--------------|
| Map | Moving Map | §4.2 | ✓ | ✓ | ✓ |
| FPL | Active Flight Plan | §4.3 | ✓ | ✓ | ✓ |
| Direct-to | Direct-to Page | §4.4 | ✓ | ✓ | ✓ |
| Waypoints | Waypoint Information | §4.5 | ✓ | ✓ | ✓ |
| Nearest | Nearest Pages | §4.6 | ✓ | ✓ | ✓ |
| Procedures | Procedures Pages | §4.7 | ✓ | ✓ | ✓ |
| Weather | FIS-B Weather | §4.9 | ✓ | ✓ | ✓ |
| Traffic | Traffic Awareness | §4.9 | ✓ | ✓ | ✓ |
| Terrain | Terrain Awareness | §4.9 | ✓ | ✓ | ✓ |
| **XPDR** | **XPDR Control Panel** | **§11** | **✓ (GNX 375 only)** | — | — |
| Utilities | Utilities Subpages | §10 | ✓ | ✓ | ✓ |
| System Setup | System Setup Pages | §10 | ✓ | ✓ | ✓ |

The XPDR icon is **GNX 375-only** and opens the XPDR Control Panel. It is not present on
GPS 175 or GNC 355/355A. For XPDR Control Panel internals, see §11 (Fragment F).

**Locater bar.** Slot 1 is a dedicated Map shortcut (fixed). Slots 2 and 3 are
user-configurable page shortcuts. An active slot is indicated by cyan background and border.
Turning the outer knob moves through available shortcuts. See §2.6 (Fragment A) for the
knob function indicator table.

**Back key.** Returns to the previous page; cancels data entry. See §2.4 (Fragment A).

**Power/Home key.** Returns to Home from any page. See §2.1 (Fragment A) for the full
key behavior including power-off sequence.

**Inner knob shortcut.** From the Home page, pushing the inner knob once opens the
Direct-to window; pushing again after selecting a waypoint activates the direct-to course.
Specific to GPS 175 and GNX 375; the GNC 355/355A inner knob push activates standby
frequency tuning (not present on GNX 375). See §2.7 (Fragment A).

> **AMAPI notes:** Home page static icon grid → `docs/knowledge/amapi_by_use_case.md` §6
> (Drawing — static content). App icon tap handlers → `button_add` per §3 (Pilot input —
> touchscreen). Dynamic locater bar highlighting (cyan background on active slot) →
> `docs/knowledge/amapi_by_use_case.md` §7 (Drawing — dynamic 2D content).

**Open questions.**
- Home page exact icon layout and icon assets: the Home page is image-based; pixel-accurate
  tile positions, icon asset filenames, and icon dimensions require screen captures from a
  physical GNX 375 device or Garmin-supplied UI asset reference. This gap is noted in
  Fragment A Appendix C and remains open.

---

### 4.2 Map Page [pp. 113–139]

**Scope.** The Map page is the primary situational awareness display, depicting the aircraft's
current position relative to terrain, airspace, weather, and traffic. It is the most visually
complex page, combining a basemap layer with multiple configurable overlays. Feature
requirements: active GPS source for the aircraft position symbol; ADS-B In (built-in on
GNX 375) for FIS-B weather and traffic overlays.

**Feature limitations.** NEXRAD, Lightning, and Terrain overlays are mutually exclusive.
Enabling one automatically disables the other two.

#### Map page user fields (data corners) [pp. 114, 117–119]

Four configurable data fields appear in the corners of the Map page. Default user fields
differ by unit:

| Unit | Field 1 | Field 2 | Field 3 | Field 4 |
|------|---------|---------|---------|---------|
| GNX 375 | Distance to waypoint | Ground speed | Desired track and track | Distance/bearing from destination airport |
| GPS 175 | Distance to waypoint | Ground speed | Desired track and track | Distance/bearing from destination airport |
| GNC 355/355A | Distance to waypoint | Ground speed | Desired track and track | From, to, and next waypoints |

The GNX 375 and GPS 175 share the same default set; GNC 355/355A has a different default
for the fourth field. This distinction is documented here because the spec covers all three
sibling units for cross-reference; implementation targets GNX 375 defaults.

To configure user fields, tap **Menu > Configure User Fields**. All four corner fields
change to selectable keys; all other map elements become inactive. Tapping any field key
opens the option list. Displayed units change based on selection. Tapping **Restore User
Fields** returns all four fields to their unit defaults and removes the TOPO scale if present.
On GPS 175 and GNX 375, user fields may also be toggled on and off by pushing the control
knob; this knob-toggle function is not available on GNC 355/355A [p. 118].

**User field options.** Available options for each configurable corner field [p. 119]:

| Option Code | Field Type |
|-------------|-----------|
| ALT | Altitude |
| BRG | Bearing to active waypoint |
| CDI | Course deviation indicator scale indicator |
| DIS | Distance to active waypoint |
| DIS/BRG APT | Distance and bearing from destination airport |
| DIS to Dest | Distance to destination along the flight plan |
| DTK | Desired track |
| DTK, TRK | Desired track and track (combined field) |
| ESA | En route safe altitude |
| ETA | Estimated time of arrival at active waypoint |
| ETA at Dest | Estimated time of arrival at destination |
| ETE | Estimated time en route to active waypoint |
| GS | GPS ground speed |
| GSL | GPS geometric sea level altitude |
| MSA | Minimum safe altitude |
| OAT (static) | Outside static air temperature |
| OAT (total) | Outside total air temperature |
| TAS | True airspeed |
| Time | Current time |
| Time to TOD | Time to top of descent |
| TKE | Track angle error |
| TRK | GPS ground track |
| VERT SPD | Vertical speed |
| WIND | Wind speed and direction |
| XTK | Cross-track error |
| OFF | Remove field (corner blank) |

Selecting **OFF** removes the corresponding corner field from the display. Selecting
**Restore User Fields** resets all four corners to the unit-specific defaults listed above.

#### Land and water depictions [p. 115]

Land and water data are for general reference only. Data accuracy is not suitable for use
as a primary navigation source; the information supplements, but does not replace, official
government charts and notices. The map draws features in priority order (highest to lowest),
ensuring safety-critical information (traffic, ownship) renders atop basemap imagery.

The map draws data in priority order from highest (1) to lowest (25). Safety-critical
overlays render atop navigation data: Traffic (1), Ownship (2), Flight Plan Labels (3),
Flight Plan (5), TAWS Alerts (6), and so on through Airspace (19), Waypoints (21),
Airways (22), and the Basemap layer (25). See Pilot's Guide p. 115 for the full
priority table.

#### Map setup options (via Menu) [pp. 116–123]

Map setup options allow customization of aeronautical information display. Access via
**Menu** from the Map page. Changes to most settings take effect immediately. Tapping
**Restore Map Settings** resets all options except user fields.

**Map orientation [p. 120].** Sets the directional reference for map rendering. Options:

| Orientation Mode | Description |
|-----------------|-------------|
| North Up | Map is oriented to true north; aircraft symbol rotates to show current heading relative to fixed map. Useful when zoomed out to view an entire route or NEXRAD display. |
| Track Up | Map rotates so current ground track always points to the top of the display; aircraft symbol remains stationary. Default for most navigation phases. |
| Heading Up | Map rotates to place current heading at the top; requires external heading source. |
| North Up Above | Automatically switches to North Up when map range exceeds the specified altitude threshold. Useful as a shortcut for quickly increasing situational awareness at high zoom levels. |

**Visual Approach orientation [p. 120].** Sets the distance from the destination airport at
which the Visual Approach selector key becomes active. Orientation behavior changes at
that distance threshold.

**TOPO scale [p. 121].** Displays a topographical elevation color scale on the map. Toggle
TOPO on or off via Map Menu. The TOPO scale is also removed when Restore User Fields
is tapped.

**Range ring [p. 121].** Displays concentric distance reference rings providing a more
precise indication of distance between the aircraft and map objects.

**Track vector [p. 121].** Displays a dashed line and arrow extending from the aircraft
icon, indicating current ground track and the projected position after a specified time
interval (if the aircraft maintains current ground track). Feature limitation: indication is
absent when aircraft velocity is less than 30 kt.

**Ahead View [p. 122].** Repositions the ownship symbol near the bottom of the display
to expand the forward view. Feature limitation: not available when page orientation is
North Up.

**Map detail level [p. 123].** Controls which city sizes and map features are rendered.
Options are full, high, medium, and low. Changes take effect immediately. At Full detail,
all features are shown (cities of all sizes, freeways, highways, roads, railroads, basemap
labels, VORs, NDBs, obstacles, airspaces, waypoints, SafeTaxi, restricted and prohibited
airspaces). At High, city data and road/railroad features drop out; VORs, NDBs, obstacles,
and non-prohibited airspaces remain. At Medium, only waypoints, SafeTaxi, and restricted/
prohibited airspaces are shown. At Low, only prohibited airspaces are drawn. Prohibited
airspaces are present at all four detail levels.

#### Aviation data symbols [p. 124]

Aviation waypoint and facility symbols displayed on the map:

| Symbol | Represents |
|--------|-----------|
| Non-towered, non-serviced airport | Open circle; symbol depicts orientation of longest runway |
| Non-towered, serviced airport | Open circle with fuel symbol; longest runway orientation |
| Towered, non-serviced airport | Filled circle; longest runway orientation |
| Towered, serviced airport | Filled circle with fuel symbol; longest runway orientation |
| Soft surface, non-serviced airport | Distinctive soft-field symbol |
| Soft surface, serviced airport | Distinctive soft-field symbol with fuel indicator |
| Restricted (private) airport | Restricted airport symbol |
| Unknown airport | Generic airport symbol |
| Heliport | Heliport symbol |
| ILS/DME or DME only | ILS/DME symbol |
| Intersection | Open triangle |
| LOM | LOM compass locator symbol |
| NDB | NDB symbol |
| TACAN | TACAN symbol |
| VOR | VOR symbol |
| VOR/DME | VOR/DME symbol |
| VORTAC | VORTAC symbol |
| VRP | VRP symbol |
| Runway extension | Dashed runway extension line |
| User Airport | Dedicated user-airport icon |
| Fly-over Waypoint | Fly-over waypoint symbol (system software v3.20 and later) |
| User Waypoint | User-created point symbol |

#### Land data symbols [p. 125 — sparse; see supplement]

Land data symbols are depicted on the map basemap at appropriate map detail levels.
Pilot's Guide p. 125 is sparse (image-only; text labels extracted but symbol graphics absent).
The authoritative source for the enumerated land symbol list is the supplement at
`assets/gnc355_reference/land-data-symbols.png`. Symbols include:

- Railroad
- National highway
- Freeway
- Local highway
- Local road
- River and lake boundaries
- State and province borders
- Small, medium, and large city symbols

Implementation must reference the supplement image for accurate symbol representation.

#### Map interactions [pp. 126–132]

**Basic interactions — zoom and pan.** Map zoom is controlled by pinch-and-stretch or
by the inner knob when Map is active. Map pan is achieved by swipe or drag. See §2.3
(Fragment A) for the full touchscreen gesture reference.

**Object selection.** Tapping any object or location displays a map pointer and an
information banner showing identifier, type icon, bearing, and distance. An information
page access key appears for waypoints, airspaces, airport surface hot spots, and TFRs.

**Stacked objects.** Tapping **Next** cycles through overlapping objects at the current zoom
level, updating the information banner for each selected object.

**Graphical flight plan editing [pp. 129–132].** Tap a map location > **Graphical Edit**,
then drag a leg to a new waypoint or airway to add a waypoint; release away from a
waypoint to remove it. To create a plan from scratch, tap locations in sequence and tap
**Done**. A temporary flight plan banner shows edits in progress. Feature limitations:
parallel track offsets do not apply to the temporary flight plan; an intermediate waypoint
cannot be inserted between the current position and a direct-to fix unless the waypoint
is in the flight plan. For full flight plan editing workflows, see §5 (Fragment D).

#### Map overlays [pp. 133–139]

**Overlay controls.** Overlay data controls reside in the Map menu. Changes to an overlay
setting take effect immediately. Control keys enable the specified overlay function only and
do not activate interfaced equipment. Control keys remain active even in the absence of
required data.

**Available overlays:**

| Overlay | Source / Notes |
|---------|---------------|
| TOPO | Topographical elevation color rendering |
| Terrain | Terrain FLTA proximity coloring (mutually exclusive with NEXRAD and Lightning) |
| Traffic | ADS-B In traffic data; built-in dual-link receiver on GNX 375 (no external hardware required); optional on GPS 175 and GNC 355 (requires external ADS-B In equipment) |
| NEXRAD | Datalink precipitation weather; options: CONUS, Regional, or off (mutually exclusive with Terrain and Lightning) |
| Lightning | Lightning strike overlay (mutually exclusive with Terrain and NEXRAD) |
| METAR | Graphical METAR flags; tapping flag icon displays current and forecast conditions |
| TFRs | Graphical Temporary Flight Restriction boundaries; tapping symbol shows TFR details |
| Airspaces | Airspace boundaries with altitude labels; filter determines altitude range |
| Airways | Low, high, all, or off; high altitude airways = green, low altitude = gray |
| Obstacles and Wires | Obstacle and wire data; color shading depicts elevation relative to aircraft altitude |
| SafeTaxi | High-resolution airport surface diagrams (see SafeTaxi below) |

**Overlay status icons [p. 136].** Icon indicators show which overlays are active at the
current map range. Absence of an icon means either (a) the overlay is not present at the
current detail level or zoom setting, or (b) the overlay control is off. A "Data Not Available"
icon indicates the overlay is active but data is unavailable due to a failure, test, or standby
condition. A "Stale Data" icon indicates data is not current but remains displayed.

**Smart Airspace [p. 137].** Garmin's Smart Airspace feature automatically de-emphasizes
airspace boundaries that are not pertinent to the aircraft's current altitude. When an
airspace's vertical proximity to the aircraft exceeds the threshold, its boundary becomes
transparent and altitude labels turn gray. At sea level, the threshold is >1,000 ft above
or below aircraft altitude; at >10,000 ft, the threshold is 2,000 ft. The threshold
interpolates linearly between these values as the aircraft ascends.

**SafeTaxi [pp. 138–139].** SafeTaxi provides greater map detail and higher image
resolution at lower zoom levels when the aircraft is in proximity to an airport. Features
labeled in the SafeTaxi diagram: runways, taxiways, airport landmarks. SafeTaxi also
identifies hot spots — locations on the airport surface where positional confusion or
runway incursions are historically likely. Selecting a hot spot border displays a brief
hazard summary and an information key; tapping the key provides additional location
detail. Hot spot numbering corresponds to the airport diagram. SafeTaxi data symbols
include: runway, taxiway, helipad, construction area, airport beacon, unpaved parking.

> **AMAPI notes:** Moving map base layer → `docs/knowledge/amapi_by_use_case.md` §10
> (Maps and navigation data; `Map_add` API). Canvas-drawn overlays (Smart Airspace
> airspace boundary shapes, SafeTaxi runway outlines, NEXRAD precipitation cells,
> aviation and land symbol rendering at non-standard map scales) → **B4 Gap 1** (see Open
> questions below); consult `docs/reference/amapi/by_function/Canvas_add.md` for the
> canvas drawing API. Compass rose equivalent (rotating NAV range ring) →
> `Running_img_add_cir` (B4 Gap 3 area). Overlay status icon visibility management →
> `docs/knowledge/amapi_by_use_case.md` §9 (Visual state management).

**Open questions.**
- **Implementation architecture choice (Map_add API vs. canvas vs. video streaming): major
  design decision deferred to design phase.** The spec body documents the Map page's
  structure, data fields, overlays, and behavior contract. It does NOT commit to a rendering
  technology. Candidate approaches — Map_add API (native AMAPI map tile rendering),
  canvas drawing (Lua-coded overlay geometry), and video streaming (XPL12 pop-out
  window capture) — each have different fidelity, performance, and dual-sim portability
  tradeoffs. This choice (B4 Gap 1) must be resolved during the design phase before
  implementation.
- NEXRAD and Traffic overlay behavior when ADS-B In data is unavailable or degraded:
  the spec must document the degraded-data presentation (no-data icon, stale-data icon,
  partial coverage indication) for these overlays. Source detail for ADS-B In data availability
  is in §11.11 (Fragment F). This behavior is partially documented by the overlay status icon
  conventions above; the full degraded-state specification requires design-phase research.

---

### 4.3 Active Flight Plan (FPL) Page [pp. 140–157]

**Scope.** The Active Flight Plan (FPL) page displays the current active flight plan as a
scrolling list of waypoints with configurable data columns. The GNX 375 adds the GPS NAV
Status indicator key in the lower right corner of the display. The GNC 355/355A-only Flight
Plan User Field is omitted from the GNX 375. Operational workflows for creating, editing,
and managing flight plans are in §5 (Fragment D); this section documents page layout and
display behavior.

**Feature requirements.** An active flight plan must be present for the waypoint list and
GPS NAV Status indicator key route display to populate. Feature limitation: the FPL page
displays up to 100 waypoints for an active flight plan.

#### Waypoint list layout [p. 140]

The FPL page displays the active flight plan as a scrolling list. Each row contains:
- Waypoint identifier
- Leg type icon (if applicable)
- Active leg indicator
- Selectable data field columns (columns 1–3)
- Waypoint type icon

An **Add Waypoint** key is always visible at the bottom of the list.

**Waypoint color [p. 141].** A waypoint's row color indicates its status in the flight plan:

| Status | Color |
|--------|-------|
| Active (current leg) | Magenta |
| Past and future waypoints | White |
| Transition waypoint | Gray |

Transition waypoints are required by certain procedures to complete the procedure geometry
but may not be navigable. Gray color indicates no pilot action is required.

#### Airport Info shortcut [p. 142]

Procedure headers on the FPL page (for approaches, arrivals, and departures) include an
**Airport Info** key. Tapping this key opens the airport information page for the
corresponding procedure airport directly, without leaving the flight plan context. This
shortcut is available for all airports specified in active approaches, arrivals, and departures.

#### Active leg status indications [p. 143]

Magenta symbols alongside waypoint identifiers indicate active leg status and fix types.
Fix type labels match approach chart labels: `iaf` (Initial Approach Fix), `faf` (Final
Approach Fix), `map` (Missed Approach Point), `mahp` (Missed Approach Hold Point), `-p`
(Parallel Track, no fix). Additional magenta symbols denote IAF arc, holding patterns (left
and right turns), active leg arrow, parallel track indicator, and direct-to symbol.

#### Data columns [p. 149]

The FPL page displays up to three configurable data columns to the right of the waypoint
identifier. To configure columns, tap **Edit Data Fields**; columns are numbered 1–3.
Tap **Restore Defaults** to return all columns to default settings.

**Available data field selections:**

| Code | Description |
|------|-------------|
| CUM | Cumulative distance |
| DIS | Distance (to next waypoint) |
| DTK | Desired track |
| ESA | En route safe altitude |
| ETA | Estimated time of arrival |
| ETE | Estimated time en route |

**Default column assignments:** Column 1 = DTK, Column 2 = DIS, Column 3 = CUM.

#### Collapse All Airways [p. 144]

Airways automatically display as individual flight plan legs; a single airway may contain
many legs. Airways without an active leg are candidates for collapsing. Tapping
**Collapse All Airways** hides all waypoints along airways except the exit waypoint for
each airway. The airway indicator field and exit identifier remain visible. This
simplification does not affect airway legs shown on any connected external navigators.

#### OBS mode toggle [p. 145]

Tapping **OBS** activates the Omni Bearing Selector, enabling manual waypoint sequencing.
When active, the pilot specifies a desired course to or from the active waypoint. The CDI
indicates the selected OBS heading. OBS mode is annunciated in the annunciator bar. The
unit retains the active "To" waypoint as a navigation reference even after the waypoint is
passed, preventing automatic sequencing to the next waypoint. Tapping OBS again resumes
automatic waypoint sequencing. For full OBS operational detail, see §5 (Fragment D).

#### Dead Reckoning display [p. 146]

**Warning: do not use projected position data as the only means of navigation.**

Dead Reckoning activates after GPS position loss during en route or oceanic flight phases
while an active flight plan exists. When active: Map reports "No GPS Position" and overlays
are unavailable; DR mode replaces the ENR or OCN annunciation; terrain is unavailable;
traffic displays on its dedicated page only. The FPL list remains visible using the last known
position. For persistent state implications, see §14 (Fragment G).

#### Parallel Track display [pp. 147–148]

Creates an offset course parallel to the active flight plan. Offset distance: 1–99 nm;
direction: left or right of track. Feature limitations: not available when Direct-to is active;
graphical leg editing cancels the parallel track; large offsets with leg geometries >120°
track change are not supported. Activate: **Menu > Parallel Track** > specify offset and
direction > **Activate**. Deactivate: **Menu > Deactivate PTK**.

#### Flight Plan Catalog access [pp. 150–151]

The FPL page menu provides access to the Flight Plan Catalog. The catalog stores up to
99 flight plans (maximum 100 waypoints each). Selecting a stored flight plan opens a
Route Options menu with actions: Activate (overwrites active flight plan), Invert and
Activate (reverses and activates for return flight), Preview (view without activating),
Edit, Copy, and Delete. Deleting the active flight plan does not delete the stored catalog
copy. For full flight plan catalog operational workflows, see §5 (Fragment D).

#### GPS NAV Status indicator key (GNX 375 / GPS 175 only — NOT GNC 355) [p. 158]

The GPS NAV Status indicator key is located in the lower right corner of the display.
It is present on GNX 375 and GPS 175; it is **not present on GNC 355/355A**. The key
displays from-to-next route information when an active flight plan exists. Indications
change based on active leg status:

| State | Trigger Condition | Display Contents |
|-------|-------------------|-----------------|
| No flight plan | No active flight plan exists | Page icon; underscores where identifiers would appear. Tap to open the Active Flight Plan page directly. |
| Active route display | Active flight plan present, CDI scale not active | Active route identifiers (from, to, next waypoints) and leg types displayed. Key is display-only when plan is active. |
| CDI scale active | Active flight plan present and CDI scale is active | Only from and to waypoints display (space-constrained). |

When an active direct-to course is established, the GPS NAV Status key changes to show
the active leg status (p. 161). This is consistent with the key's from-to-next function; the
direct-to destination becomes the active "to" waypoint.

#### User Airport Symbol [p. 156]

A dedicated icon distinguishes user-created airports from database airports on the FPL
waypoint list and on the Map page. This icon applies to airports the pilot has created as
user waypoints with airport characteristics.

#### Fly-over Waypoint Symbol [p. 157]

A distinct symbol marks waypoints coded as "fly-over" in the navigation database. The
fly-over symbol requires system software v3.20 or later.

#### Flight Plan User Field — NOT present on GNX 375

The Flight Plan User Field (available on GNC 355/355A, documented at p. 155) is **not
present on the GNX 375**. Route display customization on the GNX 375 is provided by the
Map page data corner fields (§4.2) and the FPL page's three data columns above.

> **AMAPI notes:** Scrollable waypoint list → **B4 Gap 2** (see Open questions below);
> consult GTN 650 sample for implementation patterns. Waypoint identifier and data field
> text display → `docs/knowledge/amapi_by_use_case.md` §7 (Txt_add/Txt_set for dynamic
> text). FPL list scroll animation (if animated) → §8 (Running displays). GPS NAV Status
> key dynamic content updates (route identifiers, leg type icons) → §7 (dynamic 2D content).

**Open questions.**
- **Scrollable list implementation mechanism: B4 Gap 2 design decision; spec must commit
  in design phase.** The FPL page is a scrollable list. The spec documents the list's behavior
  (row content, scrolling interaction, coloring, active-leg highlighting) without committing
  to an implementation mechanism. The AMAPI pattern catalog does not document a scrollable
  list pattern from the corpus (B4 Gap 2); the design phase must resolve this, referencing
  the GTN 650 sample or developing a new AMAPI pattern.
- **OPEN QUESTION 1: Altitude constraints on flight plan legs.** Whether the GNX 375
  automatically displays published procedure altitude restrictions (cross at, above, below, or
  between constraints) on flight plan legs is not documented in the extracted Pilot's Guide
  PDF. VCALC is a separate pilot-input planning tool for computing vertical profiles; it is
  not an automatic display of procedure-coded altitude constraints. The behavior of the FPL
  page when loaded with procedure legs that carry altitude restrictions is unknown. Research
  needed during the design phase.

---

### 4.4 Direct-to Page [pp. 159–164]

**Scope.** The Direct-to page initiates point-to-point navigation from the aircraft's present
position to a selected waypoint. Three search tabs provide alternative waypoint selection
methods. The Direct-to function is also accessible via the inner knob push shortcut from
the Home page (see §2.7, Fragment A). For full Direct-to operational workflows, see §6
(Fragment D).

**Feature limitations.** Not all flight plan entries are selectable via Direct-to (for example,
holds and course reversals are not selectable).

#### Direct-to page layout and search tabs [pp. 159–160]

The Direct-to page opens with three search tabs:

- **Waypoint** — default active tab; supports identifier entry with course and hold options;
  displays distance and bearing from current aircraft position to the selected waypoint.
- **FPL** — lists all waypoints in the active flight plan; selecting a waypoint from the flight
  plan initiates a direct-to that flight plan waypoint; waypoint sequencing resumes once the
  aircraft reaches that waypoint.
- **NRST APT** — lists up to 25 airports within 200 nm; selecting initiates a direct-to the
  nearest airport.

The Waypoint tab shows: identifier and type icon, applicable city/state/country, distance
and bearing from current position. A **Course To** key allows specifying the course angle
for the navigation path. A **Hold** key opens hold parameter options.

#### Direct-to activation [p. 161]

Activating a direct-to course establishes a point-to-point navigation line from the aircraft's
present position to the selected destination. The unit provides course guidance until the
direct-to waypoint is removed or replaced by a new direct-to course or active flight plan.
Upon activation, the Map page automatically opens to display a graphical representation
of the active direct-to leg. On GNX 375 and GPS 175, the GPS NAV Status key changes
to show active leg status; on GNC 355/355A, the Direct-to key changes to show the active
direct-to fix.

#### Navigation modes [pp. 162–163]

- **Direct-to a new waypoint** — tap Direct-to; enter or select a waypoint identifier;
  optionally set a specific course angle; activate the selection.
- **Direct-to a flight plan waypoint** — tap Direct-to; select from the FPL tab; sequencing
  resumes on reaching the waypoint if it is in the active flight plan; if not in the flight plan,
  the flight plan is not affected.
- **Direct-to an off-route course** — activate any direct-to with a course angle that differs
  from the great-circle bearing; activating an off-route direct-to course automatically
  deactivates the current leg of the active flight plan. Note: approach guidance is not
  available for procedure fixes reached via a direct-to off-route course.

#### Removing a direct-to course [p. 163]

To cancel the current direct-to course, tap **Remove**. Removing the direct-to course
reactivates the original active flight plan and assigns the leg nearest to the aircraft's
current position.

#### User holds [p. 164]

A holding pattern may be defined for any direct-to waypoint. Tapping **Hold** from the
Waypoint tab opens hold option controls for: Course (inbound or outbound angle), Direction
(Inbound or Outbound), Turn (Left or Right), Leg Type (Time or Distance), Leg Time
(MM:SS), Leg Distance (nm), and EFC (Expect Further Clearance time). Tapping **Load
Hold** returns to the Direct-to window without activating; **Hold Activate** activates
immediately. User holds suspend automatic waypoint sequencing until they expire or are
removed. For full direct-to and hold operational workflows, see §6 (Fragment D).

> **AMAPI notes:** Waypoint search input (FastFind, identifier entry) → `button_add` per
> `docs/knowledge/amapi_by_use_case.md` §3 (Pilot input — touchscreen). Waypoint
> database lookup and distance/bearing calculation → `Nav_get`, `Nav_calc_distance`,
> `Nav_calc_bearing` per §10 (Maps and navigation data). No open questions; content is
> well-extracted from the Pilot's Guide.

---

### 4.5 Waypoint Information Pages [pp. 165–178]

**Scope.** Waypoint Information pages provide detailed information for individual waypoints
from the navigation database and for user-created waypoints. The Airport page is a primary
reference for approach briefings, weather checking, and diversion planning. The Airport
Weather tab on the GNX 375 is served by the built-in dual-link ADS-B In receiver
(FIS-B), providing METAR and TAF data without external hardware. The GPS 175 has no
built-in ADS-B In receiver; FIS-B is not available on GPS 175 unless an external ADS-B In
device is installed. The GNC 355/355A similarly requires external ADS-B In for FIS-B.

**Waypoint types [p. 165].** The navigation database organizes waypoints into groups:

| Type | Code | Description |
|------|------|-------------|
| Airport | APT | Airport locations and associated procedures, frequencies, and services |
| Intersection | INT | Named intersection fixes |
| VHF Omnidirectional Range | VOR | VOR stations with frequency, class, elevation, and ATIS |
| Visual Reporting Point | VRP | VFR visual reference points |
| Non-Directional Beacon | NDB | NDB stations with frequency and class |
| User Waypoint | — | Pilot-created points; editable; stored in unit database |

#### Common page layout for INT, VOR, VRP, and NDB [p. 166]

Non-airport database waypoint pages share a uniform layout with the following elements:
1. Waypoint Identifier key (opens search options; see FastFind and Search Tabs below)
2. Location information (applicable city, state, country, and region)
3. Nearest NAVAID information
4. Waypoint-specific information (class, station declination, frequency as applicable)
5. Waypoint coordinates (latitude and longitude)
6. Distance and bearing from current aircraft position
7. Preview key — opens a 2D map of the surrounding area

#### Airport-specific information tabs [p. 167]

Airport waypoint pages include multiple selectable tabs:

| Tab | Contents |
|-----|---------|
| Info | Airport location, elevation, time zone, and fuel availability |
| Procedures | Available approach, departure, and arrival procedures. Forward-ref: see §7 for procedure loading and execution workflows. |
| Runways | Runway identifiers, length, surface type, and traffic pattern direction |
| Frequencies | Available communication and localizer frequencies; "c" symbol denotes CTAF frequencies |
| WX Data (Weather) | METAR, city forecast, and TAF weather data sourced from FIS-B |
| NOTAMs | Applicable distant and FDC NOTAMs |
| VRPs | Nearest visual reporting points |
| Chart | SafeTaxi airport surface diagram (if available) |

**Airport Weather tab — FIS-B framing.** The WX Data (Weather) tab displays METAR
and TAF data received via FIS-B (Flight Information Services — Broadcast, 978 MHz UAT).
On the GNX 375, FIS-B weather is available from the **built-in dual-link ADS-B In
receiver** without any external hardware. This is a GNX 375 advantage: the GPS 175 has
no built-in ADS-B In receiver (FIS-B requires an external device on GPS 175), and the
GNC 355/355A similarly requires external ADS-B In for FIS-B reception. For FIS-B
receiver status and uplink source detail, see §11.11 (Fragment F).

**VOR page [p. 166].** VOR-specific fields: frequency, station class (L/H/T), elevation,
and ATIS availability. Distance and bearing from current position per common layout.

**NDB page [p. 166].** NDB-specific fields: frequency and class. Distance and bearing per
common layout.

#### User Waypoint page [p. 168]

User waypoints are pilot-created points stored in the unit database. The page provides:
Edit (opens Create User Waypoint for editing), View List (shows all user waypoints — the
only page listing all 1,000), Delete (requires confirmation), and Delete All (requires
confirmation). Data fields show reference position or nearest waypoint (identifier, radial,
distance) and the count used of the 1,000-waypoint limit. User waypoints in the active
flight plan cannot be edited or deleted. For full management workflows, see §9 (Fragment E).

#### FastFind Predictive Waypoint Entry [p. 169]

FastFind predicts a waypoint based on partial identifier input. As the pilot types characters,
the Waypoint Identifier key label updates to reflect the identifier of the nearest matching
database entry. Autofill characters (shown in cyan) complete the predicted identifier from
the cursor position rightward. Tapping the key with autofill active selects the predicted
waypoint and opens the corresponding information page. Because FastFind uses the
aircraft's current GPS position, a single character press may yield a high-confidence
prediction for nearby waypoints. FastFind is a Garmin-specific term; see Appendix B.3
(Fragment A) for the glossary definition.

#### Search tabs [pp. 170–171]

The Waypoint Identifier key opens a Find interface with multiple search tabs:

| Tab | Contents |
|-----|---------|
| Recent | Up to 20 most recently viewed waypoints |
| Nearest | Up to 25 waypoints within a 200 nm radius; filterable by class (Airport, INT, VOR, NDB, VRP, or All) |
| Flight Plan | All waypoints in the active flight plan |
| User | Up to 1,000 user-defined waypoints |
| Search by Name | All airports, NDBs, and VORs associated with the specified facility name |
| Search by City | All airports, NDBs, and VORs in proximity to the specified city |

Each entry in the search tab list shows waypoint identifier, type icon, bearing, and distance
from current aircraft position.

> **AMAPI notes:** Waypoint database lookup → `docs/knowledge/amapi_by_use_case.md`
> §10 (`Nav_get`, `Nav_get_nearest` for waypoint lookup and nearest-list population).
> Distance and bearing computation → §10 (`Nav_calc_distance`, `Nav_calc_bearing`).
> Waypoint information text fields → §7 (`Txt_add`/`Txt_set` for dynamic text display).
> FIS-B weather data subscription → §1 (Reading simulator state; FIS-B dataref, if
> available in XPL; design-phase determination required).

**Open questions.**
- **Airport Weather tab behavior when no FIS-B uplink is available.** The GNX 375
  built-in ADS-B In receiver requires FIS-B ground station uplink coverage for METAR
  and TAF data. The spec must document the degraded-data presentation when no FIS-B
  ground station uplink is available: whether the Weather tab shows a "no data" message,
  a stale-data indicator with age, or suppresses the tab contents entirely. This behavior
  requires design-phase research or device testing.

---

### 4.6 Nearest Pages [pp. 179–180]

**Scope.** The Nearest Pages display lists of the nearest waypoints and ATC/FSS facilities
within 200 nm of the aircraft's current position. Content and behavior are identical across
all three units (GPS 175, GNC 355/355A, and GNX 375). The Nearest function is accessible
directly from the Home page Nearest icon (§4.1) or from the Nearest app.

**Access.** Home > Nearest > select a waypoint or frequency icon. Lists are ordered
closest to farthest and update every 30 seconds (Airspace updates once per second).

Entry field content by type:
- **Airports (up to 25):** identifier, type icon, distance, bearing, approach type, longest
  runway length
- **Intersection, VRP (up to 25):** identifier, type icon, distance, bearing
- **VOR, NDB (up to 25):** identifier, type icon, distance, bearing, frequency
- **User Waypoints (up to 25):** identifier, distance, bearing
- **Airspace (up to 20):** airspace name, floor/ceiling; identifier key to information page
- **ARTCC, FSS (up to 5 each) [p. 180]:** facility name, distance, bearing, frequency;
  FSS frequencies marked **RX** are receive-only
- **Weather Frequency (up to 25):** facility name, distance, bearing; nearest ATIS/ASOS/AWOS

**Runway criteria filter.** The Nearest Airports list applies the airport runway criteria
settings (minimum runway surface type and minimum runway length) configured in the
system settings. This filter restricts the Nearest Airport list to airports meeting the
pilot-specified criteria. For filter configuration, see §10 (Fragment E).

> **AMAPI notes:** Nearest list population → `docs/knowledge/amapi_by_use_case.md`
> §10 (`Nav_get_nearest` for nearest waypoint queries). Distance and bearing computation
> → §10 (`Nav_calc_distance`, `Nav_calc_bearing`). List text display → §7 (`Txt_add`/
> `Txt_set`). No open questions; content is clean and well-extracted from the Pilot's Guide.

---

## Coupling Summary

This section is authored per D-18 for CD/CC coordination across the 7-fragment spec. It
is not part of the spec body and is stripped on assembly.

### Backward cross-references (sections this fragment references authored in prior fragments)

- Fragment A §1 (Overview): GNX 375 baseline framing, TSO-C112e, no-internal-VDI, and
  sibling-unit distinctions (GPS 175, GNC 355/355A) — referenced throughout §§4.1–4.6 for
  unit comparison framing and FIS-B built-in receiver framing in §4.5.
- Fragment A §2 (Physical Layout & Controls): inner knob push = Direct-to (§2.7);
  touchscreen gestures — pinch/stretch zoom, swipe/drag pan, tap selection (§2.3);
  outer knob page navigation and locater bar (§2.5–2.6); Power/Home key (§2.1); Back key
  (§2.4) — all referenced in §4.1 and §4.2 map interactions.
- Fragment A Appendix B (Glossary): FastFind (B.3), FIS-B (B.1 additions), METAR, TAF,
  CDI, OBS, NDB, VOR, VRP, ARTCC, FSS, Smart Airspace (B.3), SafeTaxi (B.3), TSAA
  (B.1 additions), 1090 ES, UAT — all referenced in §§4.2–4.6 without redefinition.
- Fragment A §3 (Power-On/Startup): not directly referenced; Fragment B assumes the unit
  is in post-startup operational state.

### Forward cross-references (sections this fragment authors that later fragments reference)

- §4.1 Home page app icon grid → §11 (Fragment F) for XPDR icon target; §7 (Fragment D)
  for Procedures icon; §4.6 and §8 (Fragment E) for Nearest icon; §4.5 and §9 (Fragment E)
  for Waypoints icon; §10 (Fragment E) for System Setup and Utilities icons.
- §4.2 Map overlays (Traffic, NEXRAD) → §11.11 (Fragment F) for ADS-B In source data;
  §4.9 (Fragment C) for Hazard Awareness display consumer framing.
- §4.2 Graphical flight plan editing → §5 (Fragment D) for full edit workflow detail.
- §4.2 B4 Gap 1 (Map rendering architecture) → design phase resolution (no fragment).
- §4.3 OBS mode toggle → §5 (Fragment D) for manual waypoint sequencing behavior.
- §4.3 Flight Plan Catalog access → §5 (Fragment D) for stored-plan operational detail.
- §4.3 GPS NAV Status indicator key → §10 (Fragment E) for related configuration; §11.7
  (Fragment F) for relationship to XPDR status indications.
- §4.3 Dead Reckoning display → §14 (Fragment G) for persistent state implications.
- §4.4 Direct-to and user holds → §6 (Fragment D) for full operational workflow detail.
- §4.5 Airport Weather tab → §11.11 (Fragment F) for FIS-B source; §10 (Fragment E) for
  weather display configuration.
- §4.5 User Waypoint functions → §9 (Fragment E) for full management workflows.
- §4.5 FastFind and Search Tabs → §9 (Fragment E) for search-pattern operational detail.
- §4.6 Runway criteria filter → §10 (Fragment E) for filter configuration detail.

### §4 parent-scope authoring note

This fragment authors the §4 parent scope paragraph (introductory content under
`## 4. Display Pages`). Fragment C (C2.2-C, covering §§4.7–4.10) must NOT re-author
this parent scope. Fragment C opens with `### 4.7 Procedures Pages` directly. The
assembly script treats Fragments B and C as contiguous sub-sections under §4.

### Outline coupling footprint

This fragment draws from outline §4 parent scope + §§4.1–4.6. No content from §§4.7–4.10,
§§1–3, §§5–15, or Appendices A/B/C is authored here.
