---
Created: 2026-04-21T00:00:00-04:00
Source: docs/tasks/c2_1_outline_prompt.md
---

# GNC 355 Functional Spec V1 — Detailed Outline

**Purpose:** Structural blueprint for C2.2 spec body authoring. See D-11 for the outline-first approach rationale.
**Source content:** `assets/gnc355_pdf_extracted/text_by_page.json` (310 pages)
**Estimated total spec length:** ~2,800 lines
**Format recommendation for C2.2:** Piecewise + manifest (one task per logical section group)

The spec is estimated at ~2,800 lines — well beyond what a single context-window task can produce reliably. The piecewise approach assigns each major section group to a separate C2.2 sub-task (each ~400–600 lines), assembled by a manifest into the final document. Recommended grouping:
- Task C2.2-A: Sections 1–3 + Appendices B, C (~350 lines)
- Task C2.2-B: Section 4 (Map + Hazard Awareness pages, ~500 lines)
- Task C2.2-C: Section 4 continued (FPL, Direct-to, Waypoint, Nearest, Procedures pages, ~500 lines)
- Task C2.2-D: Sections 5–7 (Flight plan editing, Direct-to, Procedures workflows, ~550 lines)
- Task C2.2-E: Sections 8–11 (Nearest, Waypoints, Settings, COM, ~500 lines)
- Task C2.2-F: Sections 12–15 + Appendix A (Alerts, Messages, Persistence, I/O, Family delta, ~400 lines)

Each task reads only the sections it owns, pulling from this outline as the authoritative structural blueprint. CD reviews all tasks before C2.2 authoring begins.

---

## Outline navigation aids

- **Section count:** 15 top-level sections + 3 appendices = 18 total
- **Largest sections (by estimate):** Section 4 (Display pages, ~800 lines), Section 7 (Procedures, ~300 lines), Section 5 (Flight plan editing, ~200 lines)
- **Sections with significant coverage gaps:** Section 4.2 (Map — no canvas drawing pattern precedent), Section 15 (External I/O — dataref names not in Pilot's Guide)

---

## 1. Overview

**Scope.** Defines what the GNC 355 is, what this functional spec covers, and its scope boundaries. Establishes the GNC 355 as a 2" × 6.25" panel-mount GPS/COM navigator with full-color capacitive touchscreen; describes its relationship to sibling units (GPS 175, GNC 375/GNX 375) and the role of this spec in the Air Manager instrument build. Scope excludes pilot technique, aeronautical guidance, and MSFS-specific behaviors (which are secondary per D-01).

**Source pages.** [pp. 18–20]

**Estimated length.** ~50 lines

**Sub-structure:**
- 1.1 Product description and family placement [p. 18]
  - GNC 355: GPS/MFD + VHF COM (TSO-C169a), 25 kHz channel spacing
  - GNC 355A: same + 8.33 kHz channel spacing (European operations)
  - Sibling units: GPS 175 (GPS/MFD only), GNX 375 (GPS/MFD + Mode S XPDR + ADS-B Out)
  - Form factor: 2" × 6.25", panel-mount, Bluetooth
- 1.2 Unit feature comparison table [p. 19]
  - GPS 175: GPS/MFD only, no COM, no XPDR
  - GNC 355/355A: adds VHF COM radio
  - GNX 375: adds Mode S transponder + dual-link ADS-B In/Out
- 1.3 Scope of this spec [D-01, D-02]
  - Covers: operational behavior — screen pages, button/knob/touch behaviors, mode transitions, state persistence, COM functions, alerts
  - Excludes: pilot technique, aeronautical guidance, MSFS-specific implementation (v2)
  - Simulator scope: X-Plane 12 primary; MSFS noted as secondary; AMAPI dual-sim patterns apply
- 1.4 How to read this spec
  - GNC 355-specific features marked "GNC 355/355A only"
  - GNX 375-only features noted but not specified in detail
  - GPS 175 differences called out where material

**AMAPI knowledge cross-refs.**
- N/A for overview section

**Open questions / flags.**
- D-02 §9 references "GNC 375" as a fourth sibling unit, but the Pilot's Guide (190-02488-01_c) covers only GPS 175, GNC 355/355A, and GNX 375. Verify whether GNC 375 is a separate product or an alternate name for GNX 375. Appendix A addresses this gap.

---

## 2. Physical Layout & Controls

**Scope.** Documents the GNC 355 hardware interface: bezel components, touchscreen gestures, key/knob functions, and color conventions. This section is the reference for how every pilot action in the spec is physically performed. The GNC 355/355A has distinct knob behavior from GPS 175/GNX 375 (knob double-duty as COM tuner and volume control).

**Source pages.** [pp. 21–32]

**Estimated length.** ~150 lines

**Sub-structure:**
- 2.1 Bezel components [p. 21]
  - Power/Home key: powers on/off; returns to Home page
  - Inner & outer concentric knobs: data entry, list scrolling, map zoom, page navigation, COM tuning (GNC 355 only)
  - Photocell: ambient light sensor for auto brightness
  - SD card slot: database loading, log export, software updates, screenshots
  - Ledges: hand stability for data entry
- 2.2 SD card slot operations [p. 22]
  - Requirements: FAT32, 8–32 GB
  - Uses: data log export, screenshots, software upgrade, database updates, Flight Stream 510 connectivity
  - Insert/eject procedure: power off required
  - macOS formatting caveat
- 2.3 Touchscreen gestures [p. 23]
  - Tap: open page/menu, activate control, select option, display map feature info
  - Tap and hold: continuous scroll/increment (directional keys)
  - Swipe: multi-pane navigation (left/right), list scroll, map pan
  - Flick: fast list scroll (upward/downward)
  - Pinch & stretch: map zoom (stretch = zoom in, pinch = zoom out)
- 2.4 Keys and UI primitives [pp. 24–26]
  - Common command keys: Messages, Back, Menu, Enter, Select
  - Function keys: toggle on/off; state shown below key label
  - App icons: Home page tile icons; subpage icons for Utilities, System
  - Menus: expandable pane, multi-pane (swipe or inner knob), pop-up menus, scrollable lists
  - Tabs: left/right side panes; content = scrolling lists, data fields, function keys
  - Keypads: numeric (single pane) and alphanumeric (multiple keysets, swipe to switch)
- 2.5 Control knob functions [pp. 27–30]
  - Outer knob: page shortcut navigation, cursor placement, COM major frequency digits (GNC 355), COM volume coarse (GNC 355)
  - Inner knob (turn): list scroll, data entry, zoom, COM minor frequency digits (GNC 355), COM volume fine (GNC 355)
  - Inner knob (push): toggle Map user fields, Direct-To access (GPS 175/GNX 375); standby frequency tuning mode activation (GNC 355); volume control access on second push (GNC 355)
  - GNC 355 knob mode sequence: page navigation → STBY frequency tuning → COM volume → page navigation (cyan border indicates focus)
- 2.6 Page navigation labels (locater bar) [pp. 28–29]
  - Slot 1: dedicated Map shortcut (fixed)
  - Slots 2–3: user-customizable page shortcuts
  - Outer knob cycles through slots
  - Knob function indicator icons (right of bar): context-sensitive; show available actions per active page
- 2.7 Knob shortcuts [pp. 29–30]
  - GPS 175/GNX 375: knob push from Home = Direct-to window; second push = activate
  - GNC 355/355A: knob push from most pages = standby frequency tuning mode; second push = COM volume focus; third push = close
- 2.8 Screenshots [p. 31]
  - Requires: SD card (FAT32, 8–32 GB)
  - Limitation: not available with Flight Stream 510
  - Capture: hold knob + press Home/Power key; saves to SD "print" folder
- 2.9 Color conventions [p. 32]
  - Red: warning conditions
  - Yellow: caution conditions
  - Green: safe operating conditions, engaged modes, active COM frequency
  - White: scales, markings, current values
  - Magenta: active flight plan elements, active leg
  - Cyan: active/selected items, knob focus indicator

**AMAPI knowledge cross-refs.**
- Touchscreen gestures → `docs/knowledge/amapi_by_use_case.md` §3 (touchscreen functions), Pattern 4 (long-press via timer)
- Knob inner/outer → `docs/knowledge/amapi_by_use_case.md` §4 (knobs), Patterns 11, 15, 20, 21
- `docs/knowledge/amapi_patterns.md` Pattern 15 (mouse_setting + touch_setting pair on dials)

**Open questions / flags.**
- Touchscreen gesture handling beyond `button_add` (scrollable lists, map pan/zoom) is a B4 Gap 2 area. Spec author should consult GTN 650 sample directly for patterns during C2.2.

---

## 3. Power-On, Self-Test, and Startup State

**Scope.** Documents the startup sequence from power-on through the self-test display to operational state, including database validation, fuel preset, and power-off behavior. Also covers the database management lifecycle (loading, updating, syncing) since these occur at startup. Implementation must replicate startup annunciations and page transitions.

**Source pages.** [pp. 38–52]

**Estimated length.** ~80 lines

**Sub-structure:**
- 3.1 Power-up sequence [p. 38]
  - Power-on: receives power from aircraft electrical system
  - Bezel key backlight momentarily illuminates
  - Startup page displays: system failure annunciations, database status
  - Database info access key on startup page
- 3.2 Instrument panel self-test [p. 38]
  - Failure annunciations clear as system passes checks
  - Database expiration/not-found notifications appear as system messages
- 3.3 Preset fuel quantities [p. 39]
  - Entry required at startup if configured
  - Caution: estimated values must be accurate
- 3.4 Power-off [p. 38]
  - Power/Home key press-and-hold
- 3.5 Database loading and management [pp. 40–52]
  - Database storage: internal memory; SD card for updates
  - FAT32 SD card required (8–32 GB)
  - Database types: navigation, terrain, obstacle, basemap (basemap/terrain don't expire)
  - Active vs. standby databases: active = in use; standby = preloaded pending effective date
  - Manual updates: from startup page via Database Updates page (ground only)
    - Select individual or all databases for transfer
    - Region selection for applicable databases
    - Error info access
  - Automatic updates: triggered when newer database detected; on-screen prompts guide process
  - Database Concierge (wireless transfer): requires Flight Stream 510 + Garmin Pilot app + ground only
    - Wi-Fi setup page: connection status, SSID, password
  - Database SYNC: synchronizes active and standby databases across all configured LRUs
    - Includes active and standby databases
    - Prompts unit restart if new database is effective

**AMAPI knowledge cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §11 (persistence) for session state that persists across power cycles
- `docs/knowledge/amapi_patterns.md` Pattern 6 (power-state group visibility)

**Open questions / flags.**
- None significant; all startup content is clean-extracted.

---

## 4. Display Pages

**Scope.** Enumerates every display page the GNC 355 presents to the pilot, with structural description of each page's layout, data fields, controls, and navigation model. This section provides the visual anatomy; operational workflows (editing flight plans, flying procedures, etc.) are covered in subsequent sections. Section 4 is the largest section group and the primary reference for UI layout decisions during Air Manager canvas design.

**Source pages.** [pp. 17–36, 86–115, 140–180, 209–270]

**Estimated length.** ~800 lines

**Sub-structure:**

### 4.1 Home Page and Page Navigation Model [pp. 17, 28–29, 86]

**Scope.** The Home page is the top-level navigation hub. All apps are launched from app icon tiles. The locater bar enables quick access to pinned pages via outer knob.

**Source pages.** [pp. 24, 28–30, 86]

**Estimated length.** ~50 lines

- Home page layout: app icon tile grid
- App icons present on Home page: Map, FPL, Direct-to, Waypoints, Nearest, Procedures, Weather, Traffic, Terrain, Utilities, System Setup
- Locater bar (3 slots): Slot 1 = Map (fixed), Slots 2–3 = user-configurable
- Page shortcut navigation via outer knob
- Back key: returns to previous page
- Power/Home key: returns to Home from any page

**AMAPI cross-refs:** `docs/knowledge/amapi_by_use_case.md` §6 (static content/backgrounds), §7 (dynamic 2D content)

**Open questions:** Home page exact icon layout and icon assets — not described textually in Pilot's Guide (image-based page); will need screen captures or physical device reference for pixel-accurate layout.

---

### 4.2 Map Page [pp. 113–139]

**Scope.** The primary situational awareness display; depicts aircraft position relative to terrain, airspace, weather, and traffic. The most visually complex page in the spec; combines a base map layer with multiple overlay types. Implementation decisions on canvas vs. video-streaming vs. Map_add API have significant architecture implications.

**Source pages.** [pp. 113–139]

**Estimated length.** ~200 lines

- Map page user fields (data corners) [pp. 114, 117–119]
  - 4 configurable corner fields (GNC 355 defaults: distance, ground speed, desired track, track)
  - GPS 175/GNX 375 have different default fields
  - Field options table: ~25 options (BRG, DIS, DIS/BRG, GS, GSL, DTK, TRK, ALT, VERT SPD, ETE, ETA, XTK, CDI, OAT, TAS, WIND, etc.)
  - "OFF" removes field; Restore User Fields = reset to defaults
- Land and water depictions [p. 115]
  - General reference only; not suitable as primary navigation source
- Map setup options (via Menu) [pp. 116–123]
  - Map orientation: North Up, Track Up, Heading Up [p. 120]
  - North Up Above: switches to North Up above specified altitude [p. 120]
  - Visual Approach orientation behavior [p. 120]
  - TOPO scale: topographical elevation scale, toggled on/off [p. 121]
  - Range ring: distance reference rings [p. 121]
  - Track vector: projected track line [p. 121]
  - Ahead View: repositions ownship near bottom to expand forward view (not available in North Up) [p. 122]
  - Map detail level: full/high/medium/low; controls which city sizes and features appear [p. 123]
- Aviation data symbols [p. 124]
  - Non-towered/non-serviced airport, non-towered/serviced airport
  - Towered/non-serviced, towered/serviced airport
  - Soft surface airports (non-serviced, serviced)
  - Heliport, intersection, NDB, VOR, VRP
- Land data symbols [p. 125 — sparse, see supplement]
  - Railroad, national highway, freeway, local highway, local road
  - River/lake, state/province border
  - Small/medium/large city symbols
  - NOTE: p. 125 is sparse; refer to `assets/gnc355_reference/land-data-symbols.png`
- Map interactions [pp. 126–132]
  - Basic: zoom (pinch/stretch, inner knob on Map), pan (swipe/drag)
  - Object selection: tap on map → map pointer + info banner
  - Info banner contents: identifier, type, bearing, distance
  - Stacked objects: "Next" key cycles through overlapping items
  - Graphical flight plan editing overlay [pp. 129–132]: tap/drag to add or remove waypoints from active flight plan (FPL editing shortcut)
- Map overlays [pp. 133–139]
  - Overlay controls: via Map Menu; changes immediate
  - Available overlays: TOPO, Terrain, Traffic (optional GPS 175/GNC 355), NEXRAD, TFRs, Airspaces, SafeTaxi
  - Overlay status icons: shown at current range; absence = not present at this zoom or data unavailable
  - Smart Airspace: de-emphasizes non-pertinent airspace relative to aircraft altitude [p. 137]
  - SafeTaxi: high-resolution airport diagrams at low zoom levels [pp. 138–139]
    - Features: runways, taxiways, landmarks
    - Hot spots: locations with history of positional confusion or runway incursions

**AMAPI cross-refs.**
- Map_add API → `docs/knowledge/amapi_by_use_case.md` §10 (Maps and navigation data)
- Map_add_nav_canvas_layer → `docs/knowledge/amapi_by_use_case.md` §10
- Canvas-drawn overlays (Smart Airspace shapes, SafeTaxi outlines) → B4 Gap 1: no canvas-drawing pattern precedent; consult `docs/reference/amapi/by_function/Canvas_add.md` directly
- Running_img_add_cir (compass rose equivalent) → B4 Gap 3; consult `docs/reference/amapi/by_function/Running_img_add_cir.md`

**Open questions / flags.**
- Implementation architecture choice (Map_add API vs. canvas vs. video streaming) is a major design decision deferred to C2.2. Outline cannot resolve this; spec body must commit.
- SafeTaxi data source in Air Manager: the Map_add API may not have SafeTaxi-specific tiles; alternative rendering approach TBD.
- NEXRAD and traffic overlays require ADS-B receiver (external GDL 88 or GTX 345 for GNC 355) — spec must document behavior when ADS-B is absent.

---

### 4.3 Active Flight Plan (FPL) Page [pp. 140–157]

**Scope.** Scrollable list display of the active flight plan waypoints and leg data. Primary interface for viewing and managing the currently active route during flight. Tightly coupled with Section 5 (flight plan editing workflows).

**Source pages.** [pp. 140–157]

**Estimated length.** ~150 lines

- FPL page feature requirements: active flight plan present
- Feature limitations: display order based on flight phase; only active flight plan shown
- Waypoint list layout [p. 140]
  - Scrolling list; each row: waypoint identifier, leg type, ETE/ETA/DTK data columns
  - Coloring: active leg = magenta; past/future = white; transition = gray [p. 141]
- Airport Info shortcut [p. 142]: tap procedure header → airport info directly accessible
- Active leg status indications [p. 143]
  - Magenta symbols: FAF, MAP, and other fix type symbols match chart labels
  - From/To/Next waypoint indications
- Data columns (1–3) [p. 149]: selectable; tap Edit Data Fields; restore to defaults option
- Collapse All Airways [p. 144]: collapses non-active airway legs for simplification
- OBS mode toggle [p. 145]: activates manual waypoint sequencing (see §5)
- Dead Reckoning display [p. 146]: limited position/navigation using last known data (warning required)
- Parallel Track display [pp. 147–148]: offset distance and direction shown on FPL page
- Flight Plan Catalog access [pp. 150–151]: open/activate/invert stored flight plans
- GPS NAV Status indicator key (GPS 175/GNX 375 only, NOT GNC 355) [p. 158]: from-to-next route info lower-right corner
- Flight Plan User Field (GNC 355/355A only) [p. 155]: if configured, shows active route identifiers in corner field
- User Airport Symbol [p. 156]: dedicated icon for user-created airports
- Fly-over Waypoint Symbol [p. 157]: symbol for fly-over coded waypoints (requires software v3.20+)

**AMAPI cross-refs.**
- Scrollable list with swipe/flick → B4 Gap 2; no pattern from corpus; consult GTN 650 sample or invent
- `docs/knowledge/amapi_by_use_case.md` §7 (dynamic 2D text via Txt_add/Txt_set for waypoint IDs and data fields)
- `docs/knowledge/amapi_by_use_case.md` §8 (running displays — may apply to scrolling list animation)

**Open questions / flags.**
- Scrollable list implementation mechanism (Layer_add with custom scroll vs. running display vs. canvas) is a B4 Gap 2 design decision. Spec must commit; patterns are not established.

---

### 4.4 Direct-to Page [pp. 159–164]

**Scope.** Point-to-point navigation to a selected waypoint. Provides waypoint search via three tabs; presents waypoint information and course/hold options. Accessed via dedicated Direct-to key or knob shortcut.

**Source pages.** [pp. 159–164]

**Estimated length.** ~60 lines

- Direct-to page layout: search tabs (Waypoint, Flight Plan, Nearest) [pp. 159–160]
- Waypoint tab: waypoint identifier + course option + hold option; shows distance/bearing from current position [p. 160]
- Direct-to activation: point-to-point from present position to waypoint [p. 161]
- Navigating direct-to: direct to new waypoint, direct to flight plan waypoint, direct to off-route course [p. 162–163]
- Remove direct-to course [p. 163]
- User holds [p. 164]: holding pattern at direct-to waypoint; suspend/expire/remove

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §3 (touchscreen for waypoint search interaction)
- Nav_get → `docs/knowledge/amapi_by_use_case.md` §10 (nav data queries for waypoint lookup)

**Open questions / flags.**
- None; content is well-extracted.

---

### 4.5 Waypoint Information Pages [pp. 165–178]

**Scope.** Information display for individual waypoints (airports, intersections, VORs, NDBs, user waypoints). Each waypoint type has a structured information page with selectable tabs and action keys.

**Source pages.** [pp. 165–178]

**Estimated length.** ~100 lines

- Waypoint types: Airport, Intersection, VOR, VRP, NDB, User Waypoint [p. 165]
- Common page layout for Intersection/VOR/VRP/NDB [p. 166]
  - Waypoint identifier key, location info, nearest NAVAID info, waypoint type info, action keys
- Airport-specific information tabs [p. 167]
  - Info tab: location, elevation, timezone, fuel availability
  - Procedures tab: available approaches/departures/arrivals
  - Weather tab: METAR/TAF data
  - Chart tab: SafeTaxi diagram if available
- VOR page features: frequency, class, elevation, ATIS
- NDB page features: frequency, class
- User Waypoint page [p. 168]: Edit, View List, Delete functions
- Waypoint identifier key search options [p. 169]: FastFind, search tabs
- FastFind Predictive Waypoint Entry [p. 169]: keyboard entry with predictive matching
- Search Tabs [pp. 170–171]
  - Airport, Intersection, VOR, NDB, User Waypoint, Search by Name, Search by Facility Name
  - USER tab: lists up to 1,000 user waypoints [p. 171]

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §10 (Nav_get, Nav_get_nearest for waypoint lookup)
- `docs/knowledge/amapi_by_use_case.md` §7 (Txt_add/Txt_set for text data fields on waypoint page)

**Open questions / flags.**
- Airport weather tab (METAR/TAF): requires FIS-B reception. Spec must document behavior when no weather data available.

---

### 4.6 Nearest Pages [pp. 179–180]

**Scope.** Lists the nearest waypoints and facilities within 200 nm. Provides quick access to nearby airports, navaids, frequencies, ATC centers, and flight service stations. Primarily a lookup tool; does not generate navigation commands directly.

**Source pages.** [pp. 179–180]

**Estimated length.** ~50 lines

- Access: Home > Nearest; select waypoint/frequency icon
- Nearest Airports: up to 25 airports within 200 nm; identifier, distance, bearing, runway info
- Nearest NDB, VOR, Intersection, VRP: identifier, distance, bearing, frequency
- Nearest Air Route Traffic Control Center (ARTCC): facility name, distance, bearing, frequency [p. 180]
- Nearest Flight Service Station (FSS): facility name, distance, bearing, frequency; "RX" = receive-only [p. 180]
- Runway criteria filter: applies airport runway criteria settings (surface, minimum length)

**AMAPI cross-refs.**
- Nav_get_nearest → `docs/knowledge/amapi_by_use_case.md` §10
- Nav_calc_distance, Nav_calc_bearing → `docs/knowledge/amapi_by_use_case.md` §10

**Open questions / flags.**
- None; content is clean.

---

### 4.7 Procedures Pages [pp. 181–207]

**Scope.** Display pages for loading and monitoring instrument procedures (departures, arrivals, approaches). Each procedure type has a dedicated selection and confirmation flow; approach monitoring pages show active phase annunciations and mode transitions. This is the most operationally complex page group.

**Source pages.** [pp. 181–207]

**Estimated length.** ~200 lines (page layout only; operational workflows in §7)

- Procedures app overview: accessed from Home or FPL menu [p. 181]
- GPS Flight Phase Annunciations (annunciator bar) [pp. 184–185]
  - OCEANS, ENRT, TERM, DPRT, LNAV+V, LNAV, LP+V, LP, LPV (precision)
  - Colors: green = normal; yellow = caution
  - LP/LPV/RNAV specific annunciation behaviors
- Departure selection page [pp. 186–187]
  - Load departure at departure airport
  - One departure per flight plan
  - Flight Plan Departure Options menu: Select Departure, Remove Departure
- Arrival (STAR) selection page [pp. 188–189]
  - Load STAR at any airport with published procedure
  - Flight Plan Arrival Options menu: Select Arrival, Remove Arrival
- Approach selection page [pp. 190–191, 199–206]
  - Load one approach per flight plan; loading alternate replaces existing
  - SBAS approach: Channel ID key selection method
  - Approach types displayed: LNAV, LNAV/VNAV, LNAV+V, LPV, LP, LP+V, ILS (monitoring only)
  - Flight Plan Approach Options menu: Remove Approach
- ILS Approach monitoring page [p. 198]: GPS provides monitoring only; not approved for GPS
- Missed Approach page [p. 193]: before/after missed approach point states
- Approach Hold page [p. 194–195]: hold options, non-required holding patterns
- DME Arc indicator [p. 196]
- RF Leg (radius-to-fix) indicator [p. 197]
- Vectors to Final indicator [p. 197]
- Visual Approach page [pp. 205–206]
  - Active within 10 nm of destination
  - Accessible from Map or FPL page
  - Provides lateral guidance and optional vertical guidance
- Autopilot Outputs display [p. 207]
  - Roll steering (GPSS) availability
  - Approach mode vs. heading mode note

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §1 (Xpl_dataref_subscribe for GPS flight phase datarefs)
- `docs/knowledge/amapi_by_use_case.md` §2 (command dispatch for approach activation)

**Open questions / flags.**
- Autopilot integration (roll steering output) is a dataref/command interaction — specific XPL dataref names not documented in Pilot's Guide; to be researched during design.

---

### 4.8 Planning Pages [pp. 209–221]

**Scope.** Utility calculation pages: vertical descent planning, fuel planning, density altitude/TAS/wind calculations, and RAIM prediction. Primarily display + data entry pages; no continuous flight data monitoring required (one-shot calculations).

**Source pages.** [pp. 209–221]

**Estimated length.** ~80 lines

- Planning apps overview [p. 210]: accessed from System Utilities; Target ALT, Fuel Planning, DALT/TAS/Wind, RAIM
- Vertical Calculator (VCALC) page [pp. 211–212]
  - Target ALT: specify final altitude for descent calculation
  - Altitude Type: MSL or Above WPT
  - VCALC setup: target waypoint, time to TOD, required VS
  - Warning: VCALC messages not sole means of terrain separation
- Fuel Planning page [pp. 213–216]
  - Modes: P.Position (uses current aircraft coordinates as departure), waypoint-to-waypoint
  - Inputs: fuel on board, fuel flow (from EIS or manual)
  - Statistics: fuel remaining, endurance
  - Active or programmed flight plan, or direct-to
- DALT/TAS/Wind Calculator page [pp. 217–219]
  - Requirements: pressure altitude source, valid sensor data
  - Inputs: indicated altitude, BARO, CAS
  - Outputs: density altitude, TAS, winds aloft (speed/direction)
- RAIM Prediction page [pp. 220–221]
  - Requirements: active satellite constellation data
  - Inputs: waypoint, date, time
  - Outputs: RAIM availability status
  - Waypoint search options available

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §1 (dataref subscriptions for sensor inputs to DALT calc)
- N/A for planning pages — primarily static data entry; no continuous sim variable subscriptions required

**Open questions / flags.**
- EIS integration for fuel flow: requires optional equipment. Spec should document manual vs. EIS-sourced fuel flow data distinction.

---

### 4.9 Hazard Awareness Pages [pp. 223–269]

**Scope.** Three dedicated display pages for weather (FIS-B), traffic (ADS-B), and terrain/obstacle awareness. Each page has its own overlay controls and can display data as map overlays. All require external data sources (GDL 88, GTX 345, or GNX 375 for GPS 175/GNC 355).

**Source pages.** [pp. 223–269]

**Estimated length.** ~120 lines

**FIS-B Weather page [pp. 225–244]:**
- Data transmission limitations: line-of-sight, 30-day NOTAM limitation [pp. 225–226]
- Weather page layout: dedicated page + map overlay
- FIS-B weather products: NEXRAD (CONUS + Regional), METARs/TAFs, graphical AIRMETs, SIGMETs, PIREPs, cloud tops, lightning, CWA, winds/temps aloft, icing, turbulence, TFRs [pp. 230–243]
- Product status page: unavailable/awaiting data/data available states [p. 231]
- Product age timestamp display [p. 232]
- WX Info Banner: tapping weather icon shows info banner [p. 228]
- FIS-B setup menu: orientation, G-AIRMET filters [pp. 229, 237]
- Raw text reports: METARs, winds/temps aloft [pp. 242–243]
- FIS-B ground reception status page [p. 244]

**Traffic Awareness page [pp. 245–256]:**
- Requirements: external ADS-B In (GDL 88, GTX 345) for GPS 175/GNC 355; built-in for GNX 375 [p. 245]
- Traffic applications: ADS-B + TSAA [pp. 245–246]
- Traffic display layout [pp. 247–250]
  - Ownship icon, traffic symbols (directional/non-directional)
  - Altitude separation value display
  - Traffic symbol types: ADS-B, off-scale alerts (half symbols on range ring)
- Traffic setup menu [pp. 251–252]
  - Motion vectors (absolute/relative/off)
  - Altitude filtering
  - ADS-B display, self-test
- Traffic interactions [p. 253]: select symbol → registration/callsign, altitude, speed
- Traffic annunciations [p. 254]: table of annunciation descriptions
- Traffic alerting [pp. 255–256]: TA/alert types; alerting parameters (altitude separation, closure rate, time to CPA)

**Terrain Awareness page [pp. 257–269]:**
- Requirements: terrain database (all units) [p. 257]
- GPS Altitude for Terrain: derived from satellite measurements; 3-D fix (4 satellites minimum) [p. 258]
- Database limitations: not all-inclusive, cross-validated per TSO-C151c [p. 259]
- Terrain page layout [pp. 260–264]
  - Ownship icon, terrain display with elevation colors
  - Obstacle depictions: tower (lighted/unlighted), power line
  - Automatic zoom: zooms during alert
  - Automatic data removal: removes in dense areas
- Terrain setup menu [p. 262]: GPS altitude for terrain option
- Terrain proximity: relative to aircraft altitude [p. 262]
- Terrain alerting [pp. 265–269]
  - FLTA (Forward-Looking Terrain Avoidance) and PDA (Premature Descent Alert)
  - Alert types: visual annunciations + pop-up
  - Thresholds: minimum clearance altitude by flight phase and level/descending [p. 266]
  - Inhibiting alerts: Terrain Inhibit control [p. 267]
  - FLTA/PDA alert conditions table [pp. 268–269]

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §10 (Map overlays for weather/traffic/terrain)
- Canvas-drawn terrain/obstacle overlays → B4 Gap 1 (no canvas-drawing pattern precedent)
- `docs/knowledge/amapi_by_use_case.md` §9 (Visible, Opacity for alert state management)
- `docs/knowledge/amapi_patterns.md` Pattern 17 (annunciator visible pattern for traffic/terrain annunciations)

**Open questions / flags.**
- FIS-B weather data source: Air Manager may not provide FIS-B uplink data; spec must decide whether to implement weather display as dataref-subscribed or defer as "requires external FIS-B data bridge."
- Traffic data source: ADS-B In data via XPL dataref namespace TBD during design.

---

### 4.10 Settings and System Pages [pp. 86–109]

**Scope.** System customization and status pages accessed from System Setup and System Status apps on the Home page. Includes pilot-configurable settings and diagnostic/status views. These pages configure persistent preferences that affect instrument behavior globally.

**Source pages.** [pp. 86–109]

**Estimated length.** ~80 lines (page layout only; operational content in §10)

- Pilot Settings page layout [p. 86]: CDI Scale, CDI On Screen (GPS 175/GNX 375 only), airport runway criteria, clocks/timers, page shortcuts, alerts settings, unit selections, display brightness, scheduled messages, crossfill
- CDI Scale setup page [p. 87]: options 0.30/1.00/2.00/5.00 nm; full-scale deflection
- System Status page [p. 102]: serial number, software version, database info keys
- GPS Status page [pp. 103–106]: satellite graph (up to 15 SVIDs), accuracy fields (EPU, HFOM/VFOM, HDOP), SBAS providers, GPS annunciations, GPS alert conditions
- ADS-B Status page [pp. 107–108]: last uplink time, GPS source, FIS-B WX status, traffic application status
- Logs page [p. 109]: WAAS diagnostic + ADS-B traffic (GNX 375 only); export to SD card

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §12 (User_prop_add_* for configurable settings exposed in instrument panel)

---

### 4.11 COM Standby Control Panel (GNC 355/355A Only) [pp. 57–74]

**Scope.** The COM Standby Control Panel is a persistent overlay accessible from any page via the standby frequency window (upper right corner). It provides direct access to all COM radio controls without navigating to a dedicated page. Unique to GNC 355/355A; not present on GPS 175 or GNX 375.

**Source pages.** [pp. 57–74]

**Estimated length.** ~60 lines (layout only; COM operations in §11)

- Control panel location: upper-right corner of display (persistent across all pages)
- Layout elements [p. 57]
  - Active frequency window (upper): current transmit/receive frequency
  - Standby frequency window (lower): frequency being set
  - Frequency entry field: direct digit entry
  - Monitor key (MON): toggles monitor mode
  - XFER key: flip-flop active/standby
  - COM volume access key (VOL): opens volume controls
  - Data entry keys: digit pads
- Status indications in active frequency window [p. 64]
  - "RX" indicator: receiving transmission
  - "TX" indicator: transmitting
  - "MON" indicator: monitor mode active
  - "SQ" indicator: squelch overridden (open squelch active)
  - Reverse frequency lookup result display
- Volume controls overlay [pp. 58–59]
  - Relative volume percentage indicator
  - Max volume indicator
  - Directional keys: increase/decrease volume
  - Knob control: inner/outer knob adjust volume
  - Open Squelch toggle (also accessible from volume page and slide-out menu)

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §3 (Button_add for XFER, MON, VOL keys)
- `docs/knowledge/amapi_by_use_case.md` §7 (Txt_add/Txt_set for frequency displays)
- B4 Gap 3: frequency display via running text — consult `docs/reference/amapi/by_function/Running_txt_add_hor.md`

---

## 5. Flight Plan Editing

**Scope.** Documents all workflows for creating, modifying, and managing flight plans. Covers the flight plan catalog, active flight plan manipulation, waypoint insertion/deletion, and the OBS and parallel track modes. Tightly coupled with the FPL page display (§4.3).

**Source pages.** [pp. 144–157]

**Estimated length.** ~200 lines

**Sub-structure:**
- 5.1 Flight Plan Catalog [pp. 150–151]
  - View list of all stored flight plans
  - Route Options menu: Activate, Invert & Activate, Copy to Active, Delete, Preview
  - Delete active flight plan: does not delete catalog entry
- 5.2 Create a Flight Plan [p. 152]
  - Three methods: from active route, from scratch (catalog), from wireless import
  - Note: unit cannot verify accuracy of cataloged flight plans with modified procedures
- 5.3 Waypoint Options [p. 153]
  - Insert Before, Insert After: add waypoint relative to selected position
  - Remove: delete waypoint from flight plan
  - Other options: Direct-to, Waypoint Info, Procedure selection from FPL
- 5.4 Graphical Flight Plan Editing [pp. 129–132]
  - Tap-and-drag on map to modify active flight plan
  - Add waypoint to existing leg
  - Remove waypoint from flight plan via drag
  - Create new legs
  - Limitation: parallel track offsets do not apply to temporary flight plan
- 5.5 OBS Mode (Omni Bearing Selector) [p. 145]
  - Toggle: manual vs. automatic waypoint sequencing
  - When active: set desired course To/From a waypoint
  - Suspends automatic sequencing
- 5.6 Parallel Track [pp. 147–148]
  - Create parallel course offset from active flight plan
  - Settings: offset distance, offset direction (left or right of track)
  - Activate from FPL Menu > Parallel Track
  - Deactivation removes offset
- 5.7 Dead Reckoning [p. 146]
  - Activates when GPS signal lost
  - Uses last known position + heading/speed
  - Warning: not sole means of navigation; limited accuracy
  - Display shows projected position with DR indication
- 5.8 Airway Handling [p. 144]
  - Airways display as individual flight plan legs
  - Collapse All Airways: collapses non-active legs for simplified view
  - Does not affect active routing
- 5.9 Flight Plan Data Fields [p. 149]
  - Up to 3 data columns per leg
  - Selectable column types (ETE, ETA, DTK, XTK, etc.)
  - Restore Defaults option

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §11 (Persist_add/get/put for flight plan storage across sessions)
- `docs/knowledge/amapi_patterns.md` Pattern 11 (persist across sessions)
- Flight plan data must survive power cycle (§14)

**Open questions / flags.**
- Flight plan storage format: Air Manager persist API supports scalar values; serializing a full flight plan requires JSON or similar encoding strategy. Spec must define the persistence schema.
- Wireless import (Bluetooth): requires Garmin Pilot app pairing; implementation may be out of scope for v1 instrument.

---

## 6. Direct-to Operation

**Scope.** Documents the Direct-to operational workflow: how the pilot initiates a point-to-point course to any waypoint, navigates to it, and removes the course. Includes User Holds which are attached to direct-to operations.

**Source pages.** [pp. 159–164]

**Estimated length.** ~80 lines

**Sub-structure:**
- 6.1 Direct-to Basics [p. 159]
  - Accessed via Direct-to key on Home page
  - Not all flight plan entries are selectable as direct-to destinations
- 6.2 Search Tabs [pp. 159–160]
  - Waypoint tab: identifier key, info controls, course option, hold option
  - Flight Plan tab: waypoints from active flight plan
  - Nearest tab: nearby waypoints by type
- 6.3 Direct-to Activation [p. 161]
  - Establishes point-to-point line from present position to destination
  - Unit provides guidance until: waypoint reached, course removed, or flight plan leg resumed
- 6.4 Direct-to a New Waypoint [pp. 162–163]
  - Step-by-step activation sequence
  - Off-route course: automatically deactivates current flight plan
  - In-route course: maintains flight plan sequencing
- 6.5 Removing a Direct-to Course [p. 163]
  - Via Menu > Remove; or activating a flight plan leg
- 6.6 User Holds [p. 164]
  - Define holding pattern at any direct-to waypoint
  - Hold options: direction (left/right), inbound course, leg time or distance
  - Suspend automatic sequencing until hold expires or is removed

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §2 (command dispatch for direct-to activation)
- Nav_get, Nav_calc_bearing → `docs/knowledge/amapi_by_use_case.md` §10

---

## 7. Procedures

**Scope.** Documents all instrument procedure operations: loading departures (SIDs), arrivals (STARs), and approaches into the flight plan; flying each procedure type; handling missed approaches; and autopilot coupling. This is one of the most specification-critical sections for IFR-capable GPS implementation.

**Source pages.** [pp. 181–207]

**Estimated length.** ~300 lines

**Sub-structure:**
- 7.1 Flight Procedure Basics [p. 182]
  - Loading rules: check runway, transition, waypoints before activation
  - Advisory climb altitudes for SIDs may not match charted — do not rely solely
  - Roll steering (GPSS) availability conditions [p. 183]
  - TO/FROM leg CDI behavior [p. 183]
- 7.2 GPS Flight Phase Annunciations [pp. 184–185]
  - OCEANS: oceanic operations
  - ENRT: en route
  - TERM: terminal
  - DPRT: departure
  - LNAV+V: non-precision with advisory vertical guidance
  - LNAV: lateral navigation only
  - LP+V: localizer performance with advisory vertical
  - LP: localizer performance (SBAS precision)
  - LPV: localizer performance with vertical guidance (CAT I equivalent)
  - Caution (yellow) conditions: integrity degraded, approach downgrade
- 7.3 Departures (SIDs) [pp. 186–187]
  - Load at departure airport; one departure per flight plan
  - Waypoints/transitions added to beginning of flight plan
  - Departure Options menu: Select Departure, Remove Departure
- 7.4 Arrivals (STARs) [pp. 188–189]
  - Load at any airport with published arrival
  - One arrival per flight plan
  - Arrival Options menu: Select Arrival, Remove Arrival
- 7.5 Approaches [pp. 190–206]
  - Load one approach per flight plan; replaces existing on re-load
  - SBAS approach loading via Channel ID key [p. 191]
  - Procedure turns: stored as approach legs; no special operations required [p. 192]
  - Non-Required Holding Patterns: pop-up on RNP approach init [p. 195]
  - ILS Approach [p. 198]: GPS for monitoring only; not approved for GPS navigation
  - RNAV Approaches [pp. 199–204]:
    - LNAV: lateral navigation non-precision
    - LNAV/VNAV: adds advisory vertical guidance from baro-VNAV
    - LNAV+V: LNAV with advisory vertical (GPS-derived)
    - LPV: localizer performance with vertical; requires SBAS
    - LP: localizer performance without vertical; requires SBAS; more precise than LNAV
    - LP+V: LP with advisory vertical guidance
    - Downgrade conditions: GPS integrity alarm limits exceeded → reverts to LNAV
  - Visual Approaches [pp. 205–206]
    - Available within 10 nm of destination
    - Lateral guidance always provided; vertical optional
    - Load from Map or FPL page
  - DME Arc [p. 196]: supported; manual DME Arc activation when within shaded arc area
  - RF Legs (Radius-to-Fix) [p. 197]: RNAV RNP 0.3 non-AR approaches
  - Vectors to Final [p. 197]
- 7.6 Missed Approach [p. 193]
  - Before Missed Approach Point: Select Activate Missed Approach
  - After Missed Approach Point: crossing MAP suspends sequencing; pop-up prompt
  - Pilot selects: remain suspended or activate missed approach
- 7.7 Approach Hold [pp. 194–195]
  - Hold Options menu: Activate Hold, Insert After
  - Hold options: direction, inbound course, leg time or distance
  - Non-required holding: pop-up decision on RNP approach init
- 7.8 Autopilot Outputs [p. 207]
  - Roll steering terminates when approach mode selected
  - Roll steering resumes after missed approach initiation
  - Caution: set heading bug appropriately for heading legs

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §1 (Xpl_dataref_subscribe for GPS flight phase, CDI source, deviation)
- `docs/knowledge/amapi_by_use_case.md` §2 (command dispatch for approach activation, missed approach)
- `docs/knowledge/amapi_patterns.md` Pattern 2 (multi-variable bus for flight phase + deviation data)
- `docs/knowledge/amapi_patterns.md` Pattern 17 (annunciator visible for flight phase annunciations)

**Open questions / flags.**
- XPL dataref names for GPS flight phase (ENRT, TERM, LNAV, LPV, etc.) not documented in Pilot's Guide; require research during design from XPL dataref reference.
- SBAS/WAAS dataref availability in XPL: verify whether X-Plane exposes per-approach-type status via datarefs.

---

## 8. Nearest Functions

**Scope.** Documents the Nearest page operational workflow: viewing and using nearest airports, navaids, and ATC facilities. Nearest results are distance-filtered and configurable via runway criteria settings.

**Source pages.** [pp. 179–180]

**Estimated length.** ~60 lines

**Sub-structure:**
- 8.1 Nearest Access [p. 179]: Home > Nearest > select icon
- 8.2 Nearest Airports [p. 179]
  - Up to 25 airports within 200 nm
  - Data per entry: identifier, distance, bearing, runway surface, runway length
  - Runway criteria filter applied (from Pilot Settings)
  - Tap entry: opens Airport Waypoint Information page
- 8.3 Nearest NDB, VOR, Intersection, VRP [p. 179]: identifier, type, frequency, distance, bearing
- 8.4 Nearest ARTCC [p. 180]: facility name, distance, bearing, frequency
- 8.5 Nearest FSS [p. 180]: facility name, distance, bearing, frequency; "RX" = receive-only stations

**AMAPI cross-refs.**
- Nav_get_nearest → `docs/knowledge/amapi_by_use_case.md` §10
- Nav_calc_distance, Nav_calc_bearing → `docs/knowledge/amapi_by_use_case.md` §10

---

## 9. Waypoint Information Pages

**Scope.** Documents the full waypoint information system: database waypoints (airports, intersections, VORs, NDBs), user-created waypoints, and the waypoint search and creation workflows.

**Source pages.** [pp. 165–178]

**Estimated length.** ~120 lines

**Sub-structure:**
- 9.1 Database Waypoint Types [p. 165]: Airport, Intersection, VOR, VRP, NDB
- 9.2 Airport Information Page [p. 167]
  - Tabs: Info (location, elevation, timezone, fuel), Procedures, Weather, Chart (SafeTaxi if available)
  - Info: airport location, elevation, time zone, fuel availability
  - Procedures: available approaches/departures/arrivals
  - Weather: METAR/TAF data
  - Chart: SafeTaxi diagram
- 9.3 Intersection/VOR/VRP/NDB Pages [p. 166]
  - Common layout: identifier, location info, nearest NAVAID, waypoint info, action keys
  - VOR-specific: frequency, class, elevation, ATIS
  - NDB-specific: frequency, class
- 9.4 User Waypoints [pp. 168, 172–178]
  - Storage: up to 1,000 user waypoints
  - Identifier format: "USRxxx" by default (up to 6 characters, uppercase)
  - Limitations: no duplicate identifiers; active FPL waypoints not editable
  - Create User Waypoint [pp. 172–175]: three reference methods
    - Lat/Lon: direct coordinate entry
    - Radial/Distance: relative to existing waypoint
    - Radial/Radial: intersection of two radials
    - Comment format: specific format per reference type [p. 175]
  - Edit User Waypoint [p. 176]: modify name, location, comment
  - Delete User Waypoint [p. 168]
  - Import User Waypoints [pp. 177–178]: from SD card CSV file
    - File format requirements: one waypoint per row, uppercase, max 25-char comments, max 8 GB
    - Imported waypoints added to user waypoint list
- 9.5 Waypoint Search and FastFind [pp. 169–171]
  - FastFind Predictive Waypoint Entry: keyboard entry → predictive matching by identifier
  - Search Tabs: Airport, Intersection, VOR, NDB, User, Search by Name, Search by Facility Name
  - User tab: lists all stored user waypoints (up to 1,000)

**AMAPI cross-refs.**
- Nav_get → `docs/knowledge/amapi_by_use_case.md` §10
- `docs/knowledge/amapi_by_use_case.md` §11 (Persist_add for user waypoint storage)

**Open questions / flags.**
- User waypoints must persist across power cycles (§14). Storage schema for 1,000 waypoints in Air Manager persist API requires design.

---

## 10. Settings / System Pages

**Scope.** Documents all user-configurable settings and system status pages: CDI scale, runway criteria, timers, unit displays, display brightness, alert configurations, crossfill, Bluetooth connectivity, and database management. These pages configure instrument-wide behavior.

**Source pages.** [pp. 86–109]

**Estimated length.** ~200 lines

**Sub-structure:**
- 10.1 CDI Scale [pp. 87–88]
  - Options: 0.30, 1.00, 2.00, 5.00 nm (full-scale deflection values)
  - Horizontal Alarm Limits: follow CDI scale; override by flight phase
  - CDI On Screen: GPS 175 and GNX 375 only (NOT GNC 355) [p. 89]
- 10.2 Airport Runway Criteria [pp. 90]
  - Runway Surface filter: hard/soft/water/any
  - Minimum Runway Length: user-specified in feet/meters
- 10.3 Clocks and Timers [p. 91]
  - Three timer types available; access via Utilities menu
  - Timer types: countup, countdown, flight timer
  - Clock: UTC or local time display
- 10.4 Page Shortcuts [p. 92]
  - Customize slots 2–3 of locater bar (slot 1 = Map, fixed)
  - Available pages dependent on configuration
- 10.5 Alerts Settings [p. 93]
  - Airspace alerts: generate messages using 3D data (altitude, lat, lon)
  - Alert altitude settings
  - Alert type selection by airspace type
- 10.6 Unit Selections [p. 94]
  - Distance/Speed: nm/kt, sm/mph, km/kph
  - Altitude: feet, meters
  - Vertical Speed: fpm, mpm
  - Nav Angle: magnetic, true
  - Wind: angle/speed format
  - Pressure: inHg, hPa
  - Temperature: Fahrenheit, Celsius
- 10.7 Display Brightness Control [p. 95]
  - Automatic: photocell + optional aircraft dimmer bus input
  - Manual: manual override with brightness slider
- 10.8 Scheduled Messages [pp. 96]
  - Types: one-time, periodic, event-based
  - Create/modify reminder messages
  - Active reminders appear at top of message list
- 10.9 Crossfill [pp. 97]
  - Requirements: dual Garmin GPS navigator configuration
  - Crossfill data: flight plans, user waypoints, pilot settings
  - Incompatibility: not compatible with GTN units with Search and Rescue enabled
  - Status indication: on/off toggle in System Setup
- 10.10 Connectivity — Bluetooth [pp. 53–56]
  - Connext: Bluetooth data link for flight plan, traffic, weather, position data
  - Bluetooth pairing: up to 13 paired devices
  - Enabling Bluetooth functionality
  - Managing paired devices: view list, enable auto-connect
  - Importing flight plans via Bluetooth
- 10.11 GPS Status [pp. 103–106]
  - Satellite signal graph: up to 15 SVIDs
  - Accuracy fields: EPU, HFOM, VFOM, HDOP
  - SBAS Providers page
  - GPS status annunciations: ACQUIRING, 3D NAV, 3D DIFF, LOI, GPS FAIL
  - GPS alert conditions: LOI (Loss of Integrity), GPS Fail
- 10.12 ADS-B Status [pp. 107–108]
  - Requirements: GDL 88 or GTX 345 (for GPS 175/GNC 355)
  - Status page: last uplink time, GPS source
  - FIS-B WX Status page
  - Traffic Application Status page
- 10.13 Logs [p. 109]
  - WAAS diagnostic data logging
  - ADS-B traffic data logging (GNX 375 only)
  - Export to SD card; FAT32, 8–32 GB

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §12 (User_prop_add_* for configurable unit settings, CDI scale, etc.)
- `docs/knowledge/amapi_by_use_case.md` §14 (Timer_start for clocks and flight timer)
- `docs/knowledge/amapi_patterns.md` Pattern 9 (user-prop boolean feature toggle for optional features)

---

## 11. COM Radio Operation (GNC 355/355A Only)

**Scope.** Documents the complete VHF COM transceiver operational model: frequency management (active/standby, tuning, flip-flop), monitoring, search, user frequencies, and failure modes. This entire section is exclusive to GNC 355/355A; GPS 175 and GNX 375 have no COM radio.

**Source pages.** [pp. 57–74]

**Estimated length.** ~200 lines

**Sub-structure:**
- 11.1 COM Frequency Model [p. 64]
  - Active frequency: current transmit/receive frequency
  - Standby frequency: queued frequency; not active until flip-flop
  - Status indicators: RX (receiving), TX (transmitting), MON (monitor), SQ (open squelch), reverse lookup result
- 11.2 COM Volume [pp. 58–59]
  - Volume adjustment via directional keys or inner/outer knob
  - Retained across power cycles
  - Open squelch: override automatic squelch; "SQ" annunciator; accessible from volume page and slide-out menu
- 11.3 COM Radio Setup [pp. 60–61]
  - Channel Spacing: GNC 355 = 25 kHz only; GNC 355A = 8.33 kHz or 25 kHz (user-selectable)
  - Reverse Frequency Look-up: shows facility identifier for current active/standby frequencies; updates ≥ once/min
  - Sidetone Volume Offset: ±10% of COM volume range; retains across power cycles
  - Link to COM Volume option
- 11.4 Direct Tuning [pp. 65–66]
  - Via data entry keypad on COM Standby Control Panel
  - Via inner/outer knob push-and-turn (no control panel needed)
  - Frequency autofill: first valid frequency filled per selected digit
  - Simplified entry: enter 3 digits (e.g., "215" → 121.50)
  - Invalid digit: pop-up message
  - Knob tuning: push once = STBY window cyan; 3-sec inactivity = inactive state; 10-sec = returns to inactive
- 11.5 Frequency Transfer (Flip-Flop) [pp. 67–68]
  - Via tap on active frequency window
  - Via XFER key on COM Standby Control Panel
  - Via knob press-and-hold (0.5 seconds)
  - Autofill + transfer: autofills incomplete entry, then flip-flops
- 11.6 Monitor Mode [p. 68]
  - Listens to standby frequency while monitoring active channel
  - Auto-switch back to active frequency when activity detected
  - Returns to standby channel after active channel idle
  - Use case: ATIS on standby + tower on active
- 11.7 Frequency Selection (Find) [pp. 69–71]
  - Find key opens search tabs:
    - Nearest Airports (up to 25 within 200 nm): identifier, bearing, distance, frequencies
    - Nearest FSS & ARTCC: facility name, distance, bearing, frequency
    - Recent: up to 20 recently tuned frequencies
    - Flight Plan: all frequencies in active flight plan
    - User: up to 15 user-defined frequencies
  - Multiple Frequencies key: when more than one frequency at an identifier
- 11.8 Remote Frequency Selection [p. 71]
  - Configuration-dependent: remote switch scrolls through user frequencies
  - One switch or two dedicated (up/down) variants
  - Emergency Frequency: remote quick-tune to 121.5 MHz (available any time unit is on)
  - COM Lock: press-hold remote transfer key 2 seconds = locks COM (configuration-dependent)
- 11.9 User Frequencies [pp. 72–73]
  - Create/edit/delete from Edit Frequency pop-up
  - Limitations: max 15 frequencies; names up to 7 characters
  - Add: Find > User tab > Add User Frequency > specify name/frequency > Save
  - Edit: tap Edit key on existing entry; modify name/frequency > Save
  - Delete: tap Delete in Edit pop-up; confirm
- 11.10 COM Alert [p. 74]
  - Radio failure: red "X" over COM key; advisory message; COM control page unavailable
  - Display auto-returns to previous page if failure occurs while control page is active
  - GNC 355/GNC 355A: different AFMS references for pilot response
  - Stuck Microphone [p. 74]: 30-second transmit timeout; "COM push-to-talk is stuck" advisory

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §1 (Xpl_dataref_subscribe for COM active/standby frequencies)
- `docs/knowledge/amapi_by_use_case.md` §2 (Xpl_dataref_write, Msfs_variable_write for frequency set; command dispatch for flip-flop)
- `docs/knowledge/amapi_patterns.md` Pattern 1 (triple-dispatch for flip-flop, volume, frequency actions)
- `docs/knowledge/amapi_patterns.md` Pattern 2 (multi-variable bus for active freq, standby freq, power state)
- `docs/knowledge/amapi_patterns.md` Pattern 14 (parallel XPL + MSFS for COM frequency: different variable names per sim)
- B4 Gap 3: frequency digit display via running text — consult `docs/reference/amapi/by_function/Running_txt_add_hor.md`
- `docs/knowledge/amapi_by_use_case.md` §11 (Persist_add for user frequencies, volume setting)

**Open questions / flags.**
- XPL dataref names for COM 1 active/standby frequency, COM volume: known standard datarefs; confirm exact names during design.
- MSFS variable names for COM active/standby frequency: standard SimConnect variables (COM ACTIVE FREQUENCY:1, COM STANDBY FREQUENCY:1); verify units (Hz vs. MHz).
- Remote frequency selection (remote switch): hardware-integration scope unclear; may be out of scope for v1 software-only instrument.

---

## 12. Audio, Alerts, and Annunciators

**Scope.** Documents the complete alert system: alert type hierarchy, visual annunciations (annunciator bar, pop-ups), aural alerts, and the system-wide color convention for alerting. This section is the reference for how the instrument communicates state changes to the pilot.

**Source pages.** [pp. 98–101]

**Estimated length.** ~100 lines

**Sub-structure:**
- 12.1 Alert Type Hierarchy [p. 98]
  - Warning (red): immediate action required
  - Caution (yellow): timely action required
  - Advisory (white/amber): awareness required, no immediate action
- 12.2 Alert Annunciations (Annunciator Bar) [p. 99]
  - Abbreviated messages at bottom of screen
  - Color matches alert level
  - Warnings in white text on red background
  - Cautions in black text on yellow background
  - Advisories in white text
- 12.3 Pop-up Alerts [p. 100]
  - Triggered by terrain/traffic warnings and cautions
  - Appears only if alerted function's page is not already active
  - Pop-up window with alert details; requires pilot acknowledgment
- 12.4 Aural Alerts [p. 101]
  - Traffic alerts (GNX 375 only, not GNC 355)
  - Mute function: active only for current alert; does not mute future alerts
- 12.5 GPS Status Annunciations [pp. 104–106]
  - Satellite signal strength bars (up to 15 SVIDs)
  - GPS annunciations: ACQUIRING, 3D NAV, 3D DIFF NAV, LOI (Loss of Integrity), GPS FAIL
  - SBAS/WAAS annunciations: LPV capability, provider selection
- 12.6 GPS Alerts [p. 106]
  - LOI: integrity not meeting requirements for flight phase → yellow "LOI"
  - GPS Fail conditions: receiver failure, WAAS board failure
- 12.7 Traffic Annunciations [p. 254]
  - See §4.9 Traffic Awareness for full traffic annunciation table
- 12.8 Terrain Annunciations [pp. 268–269]
  - See §4.9 Terrain Awareness for terrain alert conditions
- 12.9 COM Annunciations (GNC 355/355A) [pp. 64, 74]
  - RX/TX/MON/SQ indicators in COM frequency window
  - COM fail: red "X" over COM key

**AMAPI cross-refs.**
- `docs/knowledge/amapi_patterns.md` Pattern 17 (annunciator visible pattern for all alert states)
- `docs/knowledge/amapi_patterns.md` Pattern 6 (power-state group visibility for powered-off display state)
- `docs/knowledge/amapi_patterns.md` Pattern 16 (sound on state change — if alert tones implemented)
- `docs/knowledge/amapi_by_use_case.md` §9 (Visible, Opacity, Move for alert element management)

---

## 13. Messages

**Scope.** Documents the complete advisory message system by category. Messages indicate system conditions requiring pilot awareness; accessible via the MSG (Messages) key, which flashes when unread messages are present. This section maps message text to triggering conditions and corrective actions.

**Source pages.** [pp. 271–291]

**Estimated length.** ~150 lines

**Sub-structure:**
- 13.1 Message System Overview [p. 272]
  - Advisories appear in queue; most recent at top
  - View-once advisories remain until viewed
  - MSG key flashes for unread messages
  - Accessing: tap MSG key from any page
- 13.2 Airspace Advisories [p. 273]
  - Based on pilot Airspace Alerts settings
  - Informational only; no action required
  - Advisory conditions: Class B, C, D, E; TFR; MOA; restricted airspace
- 13.3 Database Advisories [p. 274]
  - Conditions: database unavailable, corrupt, expired, region not found
  - Corrective actions: re-download, re-install, contact dealer
- 13.4 Flight Plan Advisories [pp. 275–276]
  - FPL import failure, FPL content decode error
  - GDU disconnected (external flight plan crossfill)
  - Crossfill inoperative
- 13.5 GPS/WAAS Advisories [pp. 277–278]
  - GPS receiver fail, WAAS board failure
  - GPS searching sky (normal during acquisition)
  - Position accuracy degraded
- 13.6 Navigation Advisories [pp. 279–280]
  - Course CDI/HSI mismatch
  - Non-WGS84 waypoint detected
- 13.7 Pilot-Specified Advisories [p. 280]
  - Custom reminders from Scheduled Messages
- 13.8 System Hardware Advisories [pp. 281–285]
  - Knob stuck advisory: inner knob stuck
  - Transponder temperature warning (GTX 345)
  - SD card log error
  - Various LRU failure advisories
- 13.9 COM Radio Advisories (GNC 355 Specific) [p. 286]
  - COM radio needs service: cycle power; may continue operating
  - COM push-to-talk stuck: 30-second timeout, advisory message
- 13.10 Terrain Advisories [p. 287]
  - Terrain alerts inhibited advisory
  - Re-enable instruction
- 13.11 Traffic System Advisories [pp. 288–290]
  - GPS 175 & GNC 355: ADS-B LRU failure, 1090ES receiver fault, traffic function inoperative
  - GNX 375: transponder-specific traffic failures, TSAA application failures
- 13.12 VCALC Advisories [p. 291]
  - "Approaching top of descent" advisory: aircraft within 60 seconds of TOD
- 13.13 Waypoint Advisories [p. 291]
  - Non-WGS84 waypoints in flight plan

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §7 (Txt_add/Txt_set for message text display)
- `docs/knowledge/amapi_patterns.md` Pattern 17 (annunciator visible for MSG key flash state)

---

## 14. Persistent State

**Scope.** Documents what data the GNC 355 retains across power cycles. This defines the Air Manager persist API usage requirements for the instrument. Implementation must preserve all listed state; failure to do so will cause pilot-visible regression from expected avionics behavior.

**Source pages.** [pp. 58, 60, 63, 72, 97] (distributed; not a single section in Pilot's Guide)

**Estimated length.** ~50 lines

**Sub-structure:**
- 14.1 COM State (GNC 355/355A)
  - COM volume level: retained across power cycles [p. 58]
  - Sidetone volume offset: retained across power cycles [p. 63]
  - User frequencies (up to 15): retained [p. 72]
  - Standby frequency: retained (implicitly — COM radio tuning state)
- 14.2 Display and UI State
  - Display brightness manual setting: retained
  - Unit selections (distance, altitude, temperature, etc.): retained
  - Page shortcuts (locater bar slots 2–3): retained
  - CDI scale setting: retained
  - Runway criteria settings: retained
- 14.3 Flight Planning State
  - Flight plan catalog (all stored flight plans): retained
  - User waypoints (up to 1,000): retained
  - Active flight plan: retained
  - Active direct-to: may or may not persist (verify against device behavior)
- 14.4 Scheduled Messages
  - Message definitions retained; trigger states may reset
- 14.5 Bluetooth Pairing
  - Paired devices (up to 13): retained
  - Auto-connect preferences: retained
- 14.6 Crossfill Data
  - Crossfill on/off setting: retained

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §11 (Persist_add, Persist_get, Persist_put)
- `docs/knowledge/amapi_patterns.md` Pattern 11 (persist dial angle across sessions)
- Note: Air Manager persist API supports scalar values; flight plans and user waypoints require JSON serialization strategy

**Open questions / flags.**
- Flight plan catalog serialization: Air Manager persist API is scalar; spec must define encoding scheme (JSON string per persist key, or multiple keys per waypoint). This is a significant design decision for C2.2 authoring.

---

## 15. External I/O (Datarefs and Commands)

**Scope.** Documents the data exchanged between the GNC 355 instrument and X-Plane (primary) or MSFS (secondary). This section is the interface specification for instrument ↔ simulator communication. Dataref names are not documented in the Pilot's Guide; this section is populated from XPL/MSFS dataref reference knowledge, not from the PDF.

**Source pages.** N/A — dataref names not in Pilot's Guide

**Estimated length.** ~50 lines

**Sub-structure:**
- 15.1 XPL Datarefs — Reads (subscriptions)
  - GPS position: lat/lon/altitude (GPS source)
  - GPS state: fix type, SBAS availability, integrity
  - COM 1 active frequency (Hz integer)
  - COM 1 standby frequency (Hz integer)
  - COM 1 volume (0.0–1.0 float)
  - NAV 1 active frequency (if CDI source switching applicable)
  - Avionics master switch
  - Heading (magnetic)
  - Ground speed
  - Track (true + magnetic)
  - XTK (cross-track deviation)
  - CDI source (GPS vs. VLOC)
  - To/From flag
  - Flight phase (GPS phase annunciation)
  - Active waypoint identifier and coordinates
  - ETE, distance to waypoint
- 15.2 XPL Datarefs — Writes
  - COM 1 standby frequency (on pilot direct tune)
  - COM 1 volume
- 15.3 XPL Commands
  - COM 1 flip-flop (active ↔ standby)
  - Direct-to (activate)
  - Approach activation
  - Missed approach
- 15.4 MSFS Variables — Reads (subscriptions)
  - COM ACTIVE FREQUENCY:1 (Hz or MHz — verify unit)
  - COM STANDBY FREQUENCY:1
  - COM VOLUME:1 (Percent)
  - GPS POSITION (LAT, LON, ALT)
  - GPS GROUND SPEED
  - GPS TRACK TRUE TRACK
  - AVIONICS MASTER SWITCH
- 15.5 MSFS Events — Writes
  - COM1_RADIO_SWAP (flip-flop)
  - COM_RADIO_SET_HZ (set standby frequency)
  - FS2024 B: event equivalents (if applicable)

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §1 (Xpl_dataref_subscribe, Msfs_variable_subscribe)
- `docs/knowledge/amapi_by_use_case.md` §2 (Xpl_command, Msfs_event for write-back operations)
- `docs/knowledge/amapi_patterns.md` Pattern 1 (triple-dispatch button/dial — dual-sim for GNC 355: XPL + MSFS)
- `docs/knowledge/amapi_patterns.md` Pattern 14 (parallel XPL + MSFS subscriptions)

**Open questions / flags.**
- Exact XPL dataref names for GPS state (CDI source, flight phase, XTK, to/from flag): require verification against XPL DataRefTool or official Garmin avionics dataref documentation during design.
- MSFS specific GNC 355 / Working Title G5 LVAR names for avionics state: require research; not in Pilot's Guide.
- This section will be heavily supplemented during GNC 355 Design Spec (next phase); the Functional Spec may leave dataref names as placeholders with descriptions.

---

## Appendix A: Family Delta — GPS 175 / GNC 375 / GNX 375 vs. GNC 355

**Scope.** Compact comparison of the GNC 355's functional differences from sibling units documented in the Pilot's Guide. The GNC 355 is the baseline; this appendix notes what other units add, omit, or differ in. Required by D-02 §9. Note: the Pilot's Guide covers GPS 175, GNC 355/355A, and GNX 375; "GNC 375" referenced in D-02 may be equivalent to GNX 375 or represent a product not covered in this guide (flagged below).

**Source pages.** [pp. 18–20, distributed "AVAILABLE WITH" annotations throughout]

**Estimated length.** ~150 lines

**Sub-structure:**
- A.1 Unit identification and coverage note
  - PDF covers: GPS 175, GNC 355/355A, GNX 375
  - D-02 references "GNC 375" — may be GNX 375 alternate name or separate product; verify
- A.2 GPS 175 vs. GNC 355 differences
  - GPS 175 lacks: COM radio (entire §11), COM Standby Control Panel (§4.11), COM volume controls, flip-flop, monitor mode, user frequencies, COM alerts, COM radio advisories, 8.33/25 kHz channel spacing
  - GPS 175 adds: CDI On Screen display toggle [p. 89] (NOT available on GNC 355)
  - GPS 175 adds: GPS NAV Status Key in lower right corner [p. 158] (NOT available on GNC 355)
  - GPS 175 ADS-B In: requires external GDL 88 or GTX 345 (same as GNC 355)
  - All GPS navigation features: identical to GNC 355
- A.3 GNX 375 vs. GNC 355 differences
  - GNX 375 lacks: COM radio (entire §11)
  - GNX 375 adds: Mode S transponder (XPDR section, §2 pp 75–85)
    - XPDR Control Panel: squawk code entry, VFR, mode selection
    - XPDR modes: Standby, On, Altitude Reporting
    - Extended Squitter (ADS-B Out): 1090 MHz
    - Flight ID assignment
    - Remote control via G3X Touch
    - XPDR alerts and status indications
  - GNX 375 adds: Built-in dual-link ADS-B In/Out receiver (GPS 175/GNC 355 require external ADS-B receiver)
    - GNX 375 FIS-B weather: built-in receiver (not dependent on GDL 88 or GTX 345)
    - GNX 375 traffic: TSAA application with aural alerts (GPS 175/GNC 355: no aural alerts)
  - GNX 375 adds: ADS-B traffic data logging (GNC 355: WAAS diagnostic logging only)
  - GNX 375 adds: GPS NAV Status Key [p. 158] (NOT on GNC 355)
  - GNX 375 traffic advisories: different message set from GPS 175/GNC 355 [pp. 288–290]
- A.4 GNC 355A variant vs. GNC 355 (standard)
  - GNC 355A adds: 8.33 kHz channel spacing option (European operations)
  - GNC 355 standard: 25 kHz only
  - Sidetone volume offset and reverse frequency lookup: identical between 355 and 355A
- A.5 Feature matrix (all units)
  - GPS/WAAS navigation: all units identical
  - Moving map, FPL, Direct-to, Procedures, Nearest, Waypoints: all units identical
  - Planning pages (VCALC, Fuel, DALT/TAS, RAIM): all units identical
  - FIS-B weather: identical behavior (GPS 175/GNC 355 need external ADS-B; GNX 375 built-in)
  - Traffic: identical behavior (GPS 175/GNC 355 need external ADS-B; GNX 375 built-in; GNX 375 adds aural)
  - Terrain/TAWS: all units identical
  - Bluetooth: all units identical
  - Database Concierge: all units identical

**Open questions / flags.**
- "GNC 375" in D-02 §9: clarify whether this is the GNX 375 or a separate product. If separate, this appendix is incomplete.
- Specific XPDR dataref/event names for GNX 375 XPDR: not needed for GNC 355 spec but may inform future GNX 375 instrument work.

---

## Appendix B: Glossary and Abbreviations

**Scope.** Key abbreviations and terms used throughout the spec. Sourced from the Pilot's Guide Glossary (Section 8) plus AMAPI-specific terms introduced in this spec.

**Source pages.** [pp. 299–304]

**Estimated length.** ~50 lines

**Sub-structure:**
- B.1 Aviation abbreviations from Pilot's Guide Glossary [pp. 299–304]
  - Full list of ~80 abbreviations in Pilot's Guide (ACT, ADC, ADAHRS, ADS-B, CDI, CTK, DTK, ETE, FAF, FLTA, GPS, GPSS, HAL, LNAV, LPV, MAP, MFD, NDB, OBS, PDA, RAIM, SBAS, SVID, TSAA, VCALC, VOR, WAAS, XTK, etc.)
- B.2 AMAPI-specific terms used in this spec
  - Air Manager, AMAPI, dataref, persist store, canvas, dial, button_add, triple-dispatch, etc.
- B.3 Garmin-specific terms
  - FastFind: predictive waypoint entry
  - Connext: Garmin Bluetooth data service name
  - SafeTaxi: high-resolution airport diagram overlay
  - Smart Airspace: altitude-relative airspace de-emphasis feature

---

## Appendix C: Extraction Gaps and Manual-Review-Required Pages

**Scope.** Lists pages flagged by the C1 PDF extraction process as sparse or empty, and documents any content gaps identified during outline authoring. These are the sections where C2.2 spec authors should verify content against the PDF images directly.

**Source pages.** [extraction_report.md; pp. 1, 36, 110, 125, 208, 222, 270, 271, 292, 298, 308, 309, 310]

**Estimated length.** ~30 lines

**Sub-structure:**
- C.1 Sparse pages list (from extraction_report.md)
  - p. 1 (sparse): Cover page — text-only label extracted; image-only content
  - p. 36 (sparse): "INTENTIONALLY LEFT BLANK" — blank page after Section 1; no content gap
  - p. 110 (sparse): "INTENTIONALLY LEFT BLANK" — blank page after Section 2; no content gap
  - **p. 125 (sparse): Land data symbols page — symbols are image-only; text labels extracted but visual symbols absent**
    - Supplement: `assets/gnc355_reference/land-data-symbols.png` provides the visual; `README.md` in same directory
    - Impact on spec: §4.2 (Map page) land data symbols section should reference supplement
  - p. 208 (sparse): "INTENTIONALLY LEFT BLANK" — blank page after Section 3; no content gap
  - p. 222 (sparse): "INTENTIONALLY LEFT BLANK" — blank page after Section 4; no content gap
  - p. 270 (sparse): "INTENTIONALLY LEFT BLANK" — blank page after Section 5; no content gap
  - p. 271 (sparse): Section 6 (Messages) header page — section TOC only; content on subsequent pages
  - p. 292 (sparse): "INTENTIONALLY LEFT BLANK" — blank page after Section 6; no content gap
  - p. 298 (sparse): "INTENTIONALLY LEFT BLANK" — blank after Qualification; no content gap
  - p. 308 (sparse): "INTENTIONALLY LEFT BLANK" — blank after Regulatory; no content gap
  - p. 309 (empty): Truly empty page; no content
  - p. 310 (sparse): Page number only; no content
- C.2 Content gaps identified during outline authoring
  - External I/O (§15): dataref names not in Pilot's Guide — require external research
  - Map page implementation approach (§4.2): canvas vs. Map_add vs. video streaming — architectural decision required
  - Scrollable list implementation (§4.3, §4.5): no AMAPI pattern precedent for scrolling lists — B4 Gap 2
  - Home page icon layout: image-based page in Pilot's Guide; pixel layout requires device reference
  - GNC 375 / GNX 375 disambiguation: D-02 §9 references "GNC 375" but PDF covers GNX 375
- C.3 Summary
  - Significant content gaps: 1 (land data symbols — supplement available)
  - Design decision gaps: 3 (map rendering, scrollable lists, external I/O names)
  - Blank/filler pages with no content: 10 of 13 flagged pages are intentionally blank
  - OCR-applied pages: 0 (Tesseract was not available during extraction)
