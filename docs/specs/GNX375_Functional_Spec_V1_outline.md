---
Created: 2026-04-21T00:00:00-04:00
Source: docs/tasks/c2_1_375_outline_prompt.md
---

# GNX 375 Functional Spec V1 — Detailed Outline

**Purpose:** Structural blueprint for C2.2 spec body authoring. See D-11 for the outline-first approach rationale. Primary instrument pivot from GNC 355 per D-12; scope expanded for XPDR + ADS-B + full procedural fidelity per D-12 Q3c.
**Source content:** `assets/gnc355_pdf_extracted/text_by_page.json` (310 pages; Pilot's Guide 190-02488-01 Rev. C covers GPS 175, GNC 355/355A, and GNX 375)
**Harvest basis:** `docs/knowledge/355_to_375_outline_harvest_map.md` (Turn 18 categorization + Turn 20/21 research corrections)
**Research references:** `docs/knowledge/gnx375_ifr_navigation_role_research.md` (display architecture), `docs/knowledge/gnx375_xpdr_adsb_research.md` (XPDR + ADS-B scope)
**Estimated total spec length:** ~2,860 lines
**Format recommendation for C2.2:** Piecewise + manifest (one task per logical section group). The spec is estimated at ~2,860 lines — well beyond a single context-window task. The new §11 XPDR + ADS-B adds ~200 lines of net-new content; §7 gains ~50 lines of procedural-fidelity augmentations. Cross-section coupling between §11, §4.9, §12, §13, §14, and §15 is meaningful, so the C2.2-E and C2.2-F tasks must each receive a coupling summary in their task prompts. Recommended grouping:
- Task C2.2-A: §§1–3 + Appendices B, C (~350 lines)
- Task C2.2-B: §4 Part 1 — Map + Hazard Awareness pages (~500 lines)
- Task C2.2-C: §4 Part 2 — FPL, Direct-to, Waypoint, Nearest, Procedures, Planning pages (~500 lines)
- Task C2.2-D: §§5–7 — FPL editing, Direct-to op, Procedures workflows (~550 lines)
- Task C2.2-E: §§8–11 — Nearest, Waypoints, Settings, XPDR + ADS-B (~560 lines)
- Task C2.2-F: §§12–15 + Appendix A — Alerts, Messages, Persistence, I/O, Family delta (~400 lines)

---

## Outline navigation aids

- **Section count:** 15 top-level sections + 3 appendices = 18 total divisions
- **Largest sections (by estimate):** Section 4 (Display pages, ~800 lines), Section 7 (Procedures, ~350 lines), Section 11 (XPDR + ADS-B, ~200 lines)
- **Sections with significant coverage gaps:** §4.2 (Map — no canvas drawing pattern precedent; 375 default user field 4 differs from 355), §15 (External I/O — XPDR/ADS-B dataref names not in Pilot's Guide; design-phase research required), §11.10 (Remote G3X Touch — out of scope for v1); all 6 known open research questions flagged below and in their respective sections
- **Summary of pivot/research-driven changes from the 355 outline:** §11 COM Radio (~200 lines) is replaced wholesale by §11 Transponder + ADS-B (~200 lines); §4.11 COM Standby Control Panel (~60 lines) is dropped entirely; §7 gains substantial procedural-fidelity augmentations per D-12 Q3c and D-14. Per D-15, no internal VDI is specified anywhere — vertical deviation is an output contract to external CDI/VDI only. Per D-16, §11 includes only Standby/On/Altitude Reporting modes; Ground/Test/Anonymous modes do not exist on the GNX 375. All COM-related content in §§12–15 is replaced by XPDR/ADS-B equivalents. Appendix A flips to GNX 375 as baseline.

---

## 1. Overview

**Scope.** Defines what the GNX 375 is, what this functional spec covers, and its scope boundaries. Establishes the GNX 375 as a 2" × 6.25" panel-mount GPS/MFD with Mode S transponder and built-in dual-link ADS-B In/Out receiver; describes its relationship to sibling units (GPS 175, GNC 355/355A) and the role of this spec in the Air Manager instrument build. GNX 375 is the primary instrument per D-12 pivot. Scope excludes pilot technique, aeronautical guidance, and MSFS-specific behaviors (secondary per D-01).

**Source pages.** [pp. 18–20]

**Estimated length.** ~50 lines

**Sub-structure:**
- 1.1 Product description and family placement [p. 18]
  - GNX 375: GPS/MFD + Mode S transponder (TSO-C112e, Level 2els, Class 1) + built-in dual-link ADS-B In/Out
  - 1090 ES ADS-B Out via Extended Squitter; dual-link ADS-B In (1090 ES + 978 MHz UAT)
  - Sibling units: GPS 175 (GPS/MFD only, no XPDR, no ADS-B), GNC 355/355A (GPS/MFD + VHF COM, no XPDR)
  - Form factor: 2" × 6.25", panel-mount, Bluetooth, full-color capacitive touchscreen
- 1.2 Unit feature comparison table [p. 19]
  - GPS 175: GPS/MFD only — no COM, no XPDR, no ADS-B Out (external ADS-B In possible via GDL 88)
  - GNC 355/355A: adds VHF COM radio, no XPDR, no ADS-B Out
  - GNX 375 (baseline): adds Mode S transponder + built-in dual-link ADS-B In/Out
- 1.3 Scope of this spec [D-01, D-12]
  - Covers: operational behavior — screen pages, button/knob/touch behaviors, mode transitions, state persistence, XPDR + ADS-B functions, alerts
  - Excludes: pilot technique, aeronautical guidance, MSFS-specific implementation (v2); pilot technique for IFR operations deferred to design phase
  - Simulator scope: X-Plane 12 primary; MSFS noted as secondary; AMAPI dual-sim patterns apply
- 1.4 How to read this spec
  - GNX 375-specific features marked "GNX 375 only"
  - GPS 175 and GNC 355/355A differences called out in Appendix A; sibling features noted inline where material
  - "AVAILABLE WITH: GNX 375" markers from Pilot's Guide indicate 375-exclusive features

**AMAPI knowledge cross-refs.**
- N/A for overview section

**Open questions / flags.**
- None; GNC 375/GNX 375 disambiguation resolved per D-12 (GNX 375 is the correct product name).

---

## 2. Physical Layout & Controls

**Scope.** Documents the GNX 375 hardware interface: bezel components, touchscreen gestures, key/knob functions, and color conventions. This section is the reference for how every pilot action in the spec is physically performed. The GNX 375 knob behavior differs from GNC 355 (inner knob push = Direct-to access, not COM standby tuning).

**Source pages.** [pp. 21–32]

**Estimated length.** ~150 lines

**Sub-structure:**
- 2.1 Bezel components [p. 21]
  - Power/Home key: powers on/off; returns to Home page
  - Inner & outer concentric knobs: data entry, list scrolling, map zoom, page navigation, Direct-to access (GNX 375)
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
- 2.5 Control knob functions [pp. 27–30] — [PART vs. GNC 355]
  - Outer knob: page shortcut navigation, cursor placement, map range, data entry
  - Inner knob (turn): list scroll, data entry, zoom, cursor movement in keypad
  - Inner knob (push): Direct-to window access (GNX 375 / GPS 175 pattern — NOT COM standby tuning)
  - GNX 375 knob mode sequence: page navigation → Direct-to access (first push) → activate Direct-to (second push)
  - No COM volume phase; no standby frequency tuning mode (GNC 355-specific behaviors absent)
- 2.6 Page navigation labels (locater bar) [pp. 28–29]
  - Slot 1: dedicated Map shortcut (fixed)
  - Slots 2–3: user-customizable page shortcuts
  - Outer knob cycles through slots
  - Knob function indicator icons (right of bar): context-sensitive; show available actions per active page
- 2.7 Knob shortcuts [pp. 29–30] — [PART vs. GNC 355]
  - GNX 375 / GPS 175: knob push from Home = Direct-to window; second push = activate Direct-to
  - GNC 355 pattern (standby frequency tuning → COM volume) absent on GNX 375
- 2.8 Screenshots [p. 31]
  - Requires: SD card (FAT32, 8–32 GB)
  - Limitation: not available with Flight Stream 510
  - Capture: hold knob + press Home/Power key; saves to SD "print" folder
- 2.9 Color conventions [p. 32]
  - Red: warning conditions
  - Yellow: caution conditions
  - Green: safe operating conditions, engaged modes
  - White: scales, markings, current values
  - Magenta: active flight plan elements, active leg
  - Cyan: active/selected items, knob focus indicator

**AMAPI knowledge cross-refs.**
- Touchscreen gestures → `docs/knowledge/amapi_by_use_case.md` §3, Pattern 4 (long-press via timer)
- Knob inner/outer → `docs/knowledge/amapi_by_use_case.md` §4, Patterns 11, 15, 20, 21
- `docs/knowledge/amapi_patterns.md` Pattern 15 (mouse_setting + touch_setting pair on dials)

**Open questions / flags.**
- Touchscreen gesture handling beyond `button_add` (scrollable lists, map pan/zoom) is a B4 Gap 2 area. Consult GTN 650 sample directly for patterns during C2.2.

---

## 3. Power-On, Self-Test, and Startup State

**Scope.** Documents the startup sequence from power-on through the self-test display to operational state, including database validation, fuel preset, and power-off behavior. Also covers the database management lifecycle (loading, updating, syncing). Startup behavior is identical across GPS 175, GNC 355, and GNX 375.

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
- None significant; all startup content is clean-extracted and unit-agnostic.

---

## 4. Display Pages

**Scope.** Enumerates every display page the GNX 375 presents to the pilot, with structural description of each page's layout, data fields, controls, and navigation model. This section provides the visual anatomy; operational workflows are covered in subsequent sections. The GNX 375 adds an XPDR app icon on Home, a GPS NAV Status indicator key on the FPL page, a CDI On Screen toggle, and a built-in ADS-B receiver framing for Hazard Awareness pages. §4.11 (COM Standby Control Panel) is omitted — the 375 has no COM radio.

**Source pages.** [pp. 17–36, 75, 86–115, 140–180, 209–270]

**Estimated length.** ~740 lines

**Sub-structure:**

### 4.1 Home Page and Page Navigation Model [pp. 17, 28–29, 86] — [PART]

**Scope.** The Home page is the top-level navigation hub. All apps are launched from app icon tiles. The 375 adds an XPDR app icon not present on GPS 175 or GNC 355.

**Source pages.** [pp. 24, 28–30, 86]

**Estimated length.** ~50 lines

- Home page layout: app icon tile grid
- App icons present on Home page (GNX 375): Map, FPL, Direct-to, Waypoints, Nearest, Procedures, Weather, Traffic, Terrain, XPDR, Utilities, System Setup
  - XPDR icon: opens XPDR Control Panel (GNX 375 only — not on GPS 175 or GNC 355)
- Locater bar (3 slots): Slot 1 = Map (fixed), Slots 2–3 = user-configurable
- Page shortcut navigation via outer knob
- Back key: returns to previous page
- Power/Home key: returns to Home from any page

**AMAPI cross-refs:** `docs/knowledge/amapi_by_use_case.md` §6 (static content/backgrounds), §7 (dynamic 2D content)

**Open questions / flags.**
- Home page exact icon layout and icon assets: image-based page; pixel-accurate layout requires screen captures or physical device reference.

---

### 4.2 Map Page [pp. 113–139] — [FULL with note on default user fields]

**Scope.** Primary situational awareness display; depicts aircraft position relative to terrain, airspace, weather, and traffic. Most visually complex page; combines base map layer with multiple overlay types.

**Source pages.** [pp. 113–139]

**Estimated length.** ~200 lines

- Map page user fields (data corners) [pp. 114, 117–119]
  - 4 configurable corner fields
  - GNX 375 defaults (per p. 114): distance, ground speed, desired track and track, distance/bearing from destination airport
  - GPS 175 defaults: same as GNX 375
  - GNC 355/355A defaults (for comparison): distance, ground speed, desired track and track, from/to/next waypoints
  - Field options table: ~25 options (BRG, DIS, DIS/BRG, GS, GSL, DTK, TRK, ALT, VERT SPD, ETE, ETA, XTK, CDI, OAT, TAS, WIND, etc.)
  - "OFF" removes field; Restore User Fields = reset to defaults
- Land and water depictions [p. 115]
  - General reference only; not suitable as primary navigation source
  - Data drawing order priority table (traffic, ownship, FPL labels → basemap) [p. 115]
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
  - NOTE: p. 125 sparse; refer to `assets/gnc355_reference/land-data-symbols.png`
- Map interactions [pp. 126–132]
  - Basic: zoom (pinch/stretch, inner knob on Map), pan (swipe/drag)
  - Object selection: tap on map → map pointer + info banner
  - Info banner contents: identifier, type, bearing, distance
  - Stacked objects: "Next" key cycles through overlapping items
  - Graphical flight plan editing overlay [pp. 129–132]: tap/drag to add or remove waypoints from active flight plan
- Map overlays [pp. 133–139]
  - Overlay controls: via Map Menu; changes immediate
  - Available overlays: TOPO, Terrain, Traffic (built-in ADS-B In), NEXRAD, TFRs, Airspaces, SafeTaxi
  - Overlay status icons: shown at current range; absence = not present at this zoom or data unavailable
  - Smart Airspace: de-emphasizes non-pertinent airspace relative to aircraft altitude [p. 137]
  - SafeTaxi: high-resolution airport diagrams at low zoom levels [pp. 138–139]
    - Features: runways, taxiways, landmarks
    - Hot spots: locations with history of positional confusion or runway incursions

**AMAPI cross-refs.**
- Map_add API → `docs/knowledge/amapi_by_use_case.md` §10 (Maps and navigation data)
- Canvas-drawn overlays (Smart Airspace shapes, SafeTaxi outlines) → B4 Gap 1; consult `docs/reference/amapi/by_function/Canvas_add.md`
- Running_img_add_cir (compass rose equivalent) → B4 Gap 3

**Open questions / flags.**
- Implementation architecture choice (Map_add API vs. canvas vs. video streaming): major design decision deferred to C2.2.
- NEXRAD and traffic overlays: built-in ADS-B In provides data for GNX 375 (no external hardware required); spec must document behavior when ADS-B In data is unavailable or degraded.

---

### 4.3 Active Flight Plan (FPL) Page [pp. 140–157] — [PART]

**Scope.** Scrollable list display of the active flight plan waypoints and leg data. The GNX 375 adds the GPS NAV Status indicator key (lower right corner) and omits the GNC 355-only Flight Plan User Field.

**Source pages.** [pp. 140–157]

**Estimated length.** ~150 lines

- FPL page feature requirements: active flight plan present
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
- **GPS NAV Status indicator key (GNX 375 / GPS 175 only, NOT GNC 355) [p. 158]**
  - Located lower right corner of display
  - States: no flight plan (page access icon), active route display (from-to-next identifiers + leg types), CDI scale active (from-to waypoints only — space constrained)
  - Tap: direct access to active flight plan when no plan exists; display only when plan active
- User Airport Symbol [p. 156]: dedicated icon for user-created airports
- Fly-over Waypoint Symbol [p. 157]: symbol for fly-over coded waypoints (requires software v3.20+)
- ~~Flight Plan User Field (GNC 355/355A only) [p. 155]~~ — **NOT PRESENT on GNX 375**; omitted entirely

**AMAPI cross-refs.**
- Scrollable list → B4 Gap 2; consult GTN 650 sample or invent implementation
- `docs/knowledge/amapi_by_use_case.md` §7 (Txt_add/Txt_set for waypoint IDs and data fields)
- `docs/knowledge/amapi_by_use_case.md` §8 (running displays — may apply to scrolling list animation)

**Open questions / flags.**
- Scrollable list implementation mechanism: B4 Gap 2 design decision; spec must commit in C2.2.
- Altitude constraints on flight plan legs (OPEN QUESTION 1): Whether the 375 automatically displays published procedure altitude restrictions (cross at/above/below/between) is not documented in the extracted PDF. VCALC is a separate pilot-input planning tool, not automatic from procedure data. Behavior unknown; research needed during design phase.

---

### 4.4 Direct-to Page [pp. 159–164] — [FULL]

**Scope.** Point-to-point navigation to a selected waypoint. Provides waypoint search via three tabs; presents waypoint information and course/hold options.

**Source pages.** [pp. 159–164]

**Estimated length.** ~60 lines

- Direct-to page layout: search tabs (Waypoint, Flight Plan, Nearest) [pp. 159–160]
- Waypoint tab: waypoint identifier + course option + hold option; shows distance/bearing from current position [p. 160]
- Direct-to activation: point-to-point from present position to waypoint [p. 161]
- Navigating direct-to: direct to new waypoint, direct to flight plan waypoint, direct to off-route course [pp. 162–163]
- Remove direct-to course [p. 163]
- User holds [p. 164]: holding pattern at direct-to waypoint; suspend/expire/remove

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §3 (touchscreen for waypoint search interaction)
- Nav_get → `docs/knowledge/amapi_by_use_case.md` §10 (nav data queries for waypoint lookup)

**Open questions / flags.**
- None; content is well-extracted.

---

### 4.5 Waypoint Information Pages [pp. 165–178] — [FULL]

**Scope.** Information display for individual waypoints. Airport Weather tab benefits from built-in ADS-B In FIS-B reception (no external hardware required on GNX 375).

**Source pages.** [pp. 165–178]

**Estimated length.** ~100 lines

- Waypoint types: Airport, Intersection, VOR, VRP, NDB, User Waypoint [p. 165]
- Common page layout for Intersection/VOR/VRP/NDB [p. 166]
  - Waypoint identifier key, location info, nearest NAVAID info, waypoint type info, action keys
- Airport-specific information tabs [p. 167]
  - Info tab: location, elevation, timezone, fuel availability
  - Procedures tab: available approaches/departures/arrivals
  - Weather tab: METAR/TAF data (FIS-B; built-in receiver on GNX 375 — no external hardware required)
  - Chart tab: SafeTaxi diagram if available
- VOR page: frequency, class, elevation, ATIS
- NDB page: frequency, class
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
- Airport weather tab: requires FIS-B reception. For GNX 375 built-in receiver, spec must document behavior when no FIS-B ground station uplink available.

---

### 4.6 Nearest Pages [pp. 179–180] — [FULL]

**Scope.** Lists the nearest waypoints and facilities within 200 nm. Identical across all three units.

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

### 4.7 Procedures Pages [pp. 181–207] — [FULL structure; XPDR-interaction notes added]

**Scope.** Display pages for loading and monitoring instrument procedures. Structurally identical to GNC 355. XPDR-interaction context noted in open questions (operational interaction content in §7 and §11).

**Source pages.** [pp. 181–207]

**Estimated length.** ~200 lines

- Procedures app overview: accessed from Home or FPL menu [p. 181]
- GPS Flight Phase Annunciations (annunciator bar) [pp. 184–185]
  - OCEANS, ENRT, TERM, DPRT, LNAV+V, LNAV, LP+V, LP, LPV (precision)
  - Colors: green = normal; yellow = caution/integrity degraded
  - LP/LPV/RNAV specific annunciation behaviors
- Departure selection page [pp. 186–187]
  - Load departure at departure airport; one departure per flight plan
  - Flight Plan Departure Options menu: Select Departure, Remove Departure
- Arrival (STAR) selection page [pp. 188–189]
  - Load STAR at any airport with published procedure
  - Flight Plan Arrival Options menu: Select Arrival, Remove Arrival
- Approach selection page [pp. 190–191, 199–206]
  - Load one approach per flight plan; loading alternate replaces existing
  - SBAS approach: Channel ID key selection method
  - Approach types displayed: LNAV, LNAV/VNAV, LNAV+V, LPV, LP, LP+V, ILS (monitoring only)
  - Flight Plan Approach Options menu: Remove Approach
- ILS Approach display page [p. 198]: GPS provides monitoring only; not approved for GPS nav; pop-up on ILS load
- Missed Approach page [p. 193]: before/after missed approach point states
- Approach Hold page [pp. 194–195]: hold options, non-required holding patterns
- DME Arc indicator [p. 196]
- RF Leg (radius-to-fix) indicator [p. 197]
- Vectors to Final indicator [p. 197]
- Visual Approach page [pp. 205–206]
  - Active within 10 nm of destination
  - Accessible from Map or FPL page
  - Provides lateral guidance and optional vertical guidance
  - External CDI/VDI only for vertical deviation indications (per p. 205 and D-15)
- Autopilot Outputs display [p. 207]
  - Roll steering (GPSS) availability and activation
  - LPV glidepath capture output to compatible autopilots (KAP 140, KFC 225)

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §1 (Xpl_dataref_subscribe for GPS flight phase datarefs)
- `docs/knowledge/amapi_by_use_case.md` §2 (command dispatch for approach activation)

**Open questions / flags.**
- XPDR altitude reporting during approach: GNX 375 in ALT mode during approach phase; interaction with WOW state handling — see §7.9 and §11.4 for operational detail.
- ADS-B traffic display during approach: TSAA behavior during approach flight phases — see §7.9 for operational detail.
- Autopilot integration (roll steering output): specific XPL dataref names not documented in Pilot's Guide; research during design.

---

### 4.8 Planning Pages [pp. 209–221] — [FULL]

**Scope.** Utility calculation pages: vertical descent planning, fuel planning, density altitude/TAS/wind calculations, RAIM prediction. Identical across all three units.

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

### 4.9 Hazard Awareness Pages [pp. 223–269] — [PART: substantial framing flip]

**Scope.** Three dedicated display pages for weather (FIS-B), traffic (ADS-B), and terrain/obstacle awareness. GNX 375 framing: built-in dual-link ADS-B receiver (no external GDL 88 or GTX 345 required). TSAA aural traffic alerts present on GNX 375.

**Source pages.** [pp. 223–269]

**Estimated length.** ~120 lines

**FIS-B Weather page [pp. 225–244]:**
- GNX 375 framing: built-in 978 MHz UAT receiver; no external hardware required [p. 225]
- Data transmission limitations: line-of-sight, 30-day NOTAM limitation [pp. 225–226]
- Weather page layout: dedicated page + map overlay
- FIS-B weather products: NEXRAD (CONUS + Regional), METARs/TAFs, graphical AIRMETs, SIGMETs, PIREPs, cloud tops, lightning, CWA, winds/temps aloft, icing, turbulence, TFRs [pp. 230–243]
- Product status page: unavailable/awaiting data/data available states [p. 231]
- Product age timestamp display [p. 232]
- WX Info Banner: tapping weather icon shows info banner [p. 228]
- FIS-B setup menu: orientation, G-AIRMET filters [pp. 229, 237]
- Raw text reports: METARs, winds/temps aloft [pp. 242–243]
- FIS-B reception status page [p. 244]

**Traffic Awareness page [pp. 245–256]:**
- GNX 375 framing: built-in dual-link ADS-B In (1090 ES + UAT); no external hardware required [p. 245]
- Traffic applications: ADS-B + TSAA [pp. 245–246]
  - TSAA: Traffic Situational Awareness with Alerts (GNX 375 only; aural alerts present)
- Traffic display layout [pp. 247–250]
  - Ownship icon, traffic symbols (directional/non-directional)
  - Altitude separation value display; vertical trend arrows [p. 248]
  - Traffic symbol types: ADS-B, off-scale alerts (half symbols on range ring)
- Traffic setup menu [pp. 251–252]
  - Motion vectors (absolute/relative/off); altitude filtering; ADS-B display; self-test
- Traffic interactions [p. 253]: select symbol → registration/callsign, altitude, speed
- Traffic annunciations [p. 254]: table of annunciation descriptions
- Traffic alerting [pp. 255–256]: TA/alert types; alerting parameters (altitude separation, closure rate, time to CPA)
- TSAA aural alerts (GNX 375 only): aural advisory when traffic threat detected; mute function for current alert only; cross-ref §12.4

**Terrain Awareness page [pp. 257–269]:**
- Requirements: terrain database (all units) [p. 257]
- GPS Altitude for Terrain: derived from satellite measurements; 3-D fix (4 satellites minimum) [p. 258]
- Database limitations: not all-inclusive, cross-validated per TSO-C151c [p. 259]
- Terrain page layout [pp. 260–264]: ownship icon, terrain display with elevation colors, obstacle depictions
- Terrain alerting [pp. 265–269]: FLTA and PDA; alert types, thresholds, inhibit control

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §10 (Map overlays for weather/traffic/terrain)
- Canvas-drawn terrain/obstacle overlays → B4 Gap 1
- `docs/knowledge/amapi_patterns.md` Pattern 17 (annunciator visible for traffic/terrain annunciations)

**Open questions / flags.**
- FIS-B weather data source in Air Manager: spec must decide whether to implement weather display as dataref-subscribed or defer as "requires external FIS-B data bridge."
- TSAA aural alert delivery mechanism (OPEN QUESTION 6): whether the 375 instrument emits aural alerts via `sound_play` directly or depends on an external audio panel integration is a spec-body design decision. Behavior TBD.
- ADS-B In data availability in simulators: XPL has partial ADS-B dataref exposure; MSFS has limited ADS-B traffic data. Spec must define behavior when data is absent vs. degraded.

---

### 4.10 Settings and System Pages [pp. 86–109] — [PART]

**Scope.** System customization and status pages. GNX 375 adds CDI On Screen setting; ADS-B Status page reframed for built-in receiver; Logs updated for 375 traffic logging capability.

**Source pages.** [pp. 86–109]

**Estimated length.** ~80 lines

- Pilot Settings page layout [p. 86]: CDI Scale, CDI On Screen (GNX 375 / GPS 175 only), airport runway criteria, clocks/timers, page shortcuts, alerts settings, unit selections, display brightness, scheduled messages, crossfill
- CDI Scale setup page [p. 87]: options 0.30/1.00/2.00/5.00 nm; full-scale deflection
- **CDI On Screen (GNX 375 / GPS 175 only) [p. 89]**
  - Toggle: displays CDI scale on screen when active
  - When active: lateral deviation indicator below GPS NAV Status Indicator key
  - Lateral only — no vertical deviation indicator on 375 (per D-15)
  - Requires active flight plan for indications
  - Visual Approach lateral advisory guidance annunciations when visual approach active
- System Status page [p. 102]: serial number, software version, database info; transponder software version (GNX 375 only)
- GPS Status page [pp. 103–106]: satellite graph (up to 15 SVIDs), accuracy fields (EPU, HFOM/VFOM, HDOP), SBAS providers, GPS annunciations, GPS alert conditions
- **ADS-B Status page [pp. 107–108] — GNX 375 framing: built-in receiver**
  - Built-in receiver status (no external LRU required)
  - Last uplink time; GPS source
  - FIS-B WX Status page: reception quality, ground station coverage
  - Traffic Application Status page: TSAA application state
- **Logs page [p. 109] — GNX 375: ADS-B traffic logging present**
  - WAAS diagnostic data logging
  - ADS-B traffic data logging (GNX 375; not on GPS 175 or GNC 355)
  - Export to SD card; FAT32, 8–32 GB

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §12 (User_prop_add_* for configurable settings)

---

## 5. Flight Plan Editing

**Scope.** Documents all workflows for creating, modifying, and managing flight plans. Covers the flight plan catalog, active flight plan manipulation, waypoint insertion/deletion, and the OBS and parallel track modes. Identical across GPS 175, GNC 355, and GNX 375.

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
  - Add waypoint to existing leg; remove waypoint via drag; create new legs
  - Limitation: parallel track offsets do not apply to temporary flight plan
- 5.5 OBS Mode [p. 145]
  - Toggle: manual vs. automatic waypoint sequencing
  - When active: set desired course To/From a waypoint via external OBS selector on HSI or CDI
  - Suspends automatic sequencing
- 5.6 Parallel Track [pp. 147–148]
  - Create parallel course offset from active flight plan
  - Settings: offset distance, offset direction (left or right of track)
  - External CDI/HSI guidance driven from parallel track [p. 147]
  - Activate from FPL Menu > Parallel Track; deactivation removes offset
- 5.7 Dead Reckoning [p. 146]
  - Activates when GPS signal lost
  - Uses last known position + heading/speed
  - Warning: not sole means of navigation; limited accuracy
  - Display shows projected position with DR indication
- 5.8 Airway Handling [p. 144]
  - Airways display as individual flight plan legs
  - Collapse All Airways: collapses non-active legs for simplified view
- 5.9 Flight Plan Data Fields [p. 149]
  - Up to 3 data columns per leg; selectable column types (ETE, ETA, DTK, XTK, etc.)
  - Restore Defaults option

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §11 (Persist_add/get/put for flight plan storage across sessions)
- `docs/knowledge/amapi_patterns.md` Pattern 11 (persist across sessions)

**Open questions / flags.**
- Flight plan storage: Air Manager persist API supports scalar values; serializing a full flight plan requires JSON or similar encoding strategy. Spec must define the persistence schema.
- Wireless import (Bluetooth): requires Garmin Pilot app pairing; may be out of scope for v1 instrument.

---

## 6. Direct-to Operation

**Scope.** Documents the Direct-to operational workflow. Identical across GPS 175, GNC 355, and GNX 375.

**Source pages.** [pp. 159–164]

**Estimated length.** ~80 lines

**Sub-structure:**
- 6.1 Direct-to Basics [p. 159]: accessed via Direct-to key on Home page or inner knob push
- 6.2 Search Tabs [pp. 159–160]: Waypoint tab, Flight Plan tab, Nearest tab
- 6.3 Direct-to Activation [p. 161]: point-to-point from present position to destination; guidance until waypoint reached/course removed/FPL leg resumed
- 6.4 Direct-to a New Waypoint [pp. 162–163]: step-by-step activation; off-route vs. in-route course behavior
- 6.5 Removing a Direct-to Course [p. 163]: via Menu > Remove or activating a flight plan leg
- 6.6 User Holds [p. 164]: holding pattern at direct-to waypoint; direction/course/leg-time/distance options; suspend until hold expires or removed

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §2 (command dispatch for direct-to activation)
- Nav_get, Nav_calc_bearing → `docs/knowledge/amapi_by_use_case.md` §10

---

## 7. Procedures

**Scope.** Documents all instrument procedure operations: loading departures (SIDs), arrivals (STARs), and approaches; flying each procedure type; handling missed approaches; and autopilot coupling. Full procedural fidelity target per D-12 Q3c and D-14. Key 375 distinction: no internal VDI — vertical deviation is output only to external CDI/VDI (per D-15). XPDR/ADS-B interactions added per D-14(A).

**Source pages.** [pp. 181–207]

**Estimated length.** ~350 lines

**Sub-structure:**
- 7.1 Flight Procedure Basics [p. 182]
  - Loading rules: check runway, transition, waypoints before activation
  - Advisory climb altitudes for SIDs may not match charted — do not rely solely
  - Roll steering (GPSS) availability: output to compatible autopilots [p. 183]
  - TO/FROM leg CDI behavior [p. 183]: composite CDI flag shows TO only; annunciator bar FROM/TO field authoritative
- 7.2 GPS Flight Phase Annunciations [pp. 184–185]
  - OCEANS: oceanic operations
  - ENRT: en route
  - TERM: terminal (within 31 nm of destination)
  - DPRT: departure
  - LNAV+V: non-precision with advisory vertical (GPS-derived; +V = advisory only, fly to MDA)
  - LNAV: lateral navigation only
  - LP+V: localizer performance with advisory vertical
  - LP: localizer performance (SBAS precision)
  - LPV: localizer performance with vertical guidance (primary vertical to DA; CAT I equivalent)
  - LNAV/VNAV: baro-VNAV advisory vertical (different source from LNAV+V)
  - Caution (yellow): integrity degraded, approach downgrade
- 7.3 Departures (SIDs) [pp. 186–187]
  - Load at departure airport; one departure per flight plan
  - Waypoints/transitions added to beginning of flight plan
  - Departure Options menu: Select Departure, Remove Departure
- 7.4 Arrivals (STARs) [pp. 188–189]
  - Load at any airport with published arrival; one arrival per flight plan
  - Arrival Options menu: Select Arrival, Remove Arrival
- 7.5 Approaches [pp. 190–206]
  - Load one approach per flight plan; replaces existing on re-load
  - SBAS approach loading via Channel ID key [p. 191]
  - Procedure turns: stored as approach legs [p. 192]
  - Non-Required Holding Patterns: pop-up on RNP approach init [p. 195]
  - ILS Approach [p. 198]: GPS for monitoring only; not approved for GPS nav; pop-up on ILS load; annunciator bar stays at TERM
  - RNAV Approaches [pp. 199–204]:
    - LNAV: lateral navigation non-precision
    - LNAV/VNAV: adds advisory vertical guidance from baro-VNAV
    - LNAV+V: LNAV with advisory vertical (GPS-derived; pilot flies to MDA)
    - LPV: localizer performance with vertical; requires SBAS; primary vertical to DA
    - LP: localizer performance without vertical; requires SBAS
    - LP+V: LP with advisory vertical guidance
  - Downgrade conditions: GPS integrity alarm limits exceeded → reverts to LNAV; "GPS approach downgraded. Use LNAV minima." [p. 201]
  - Visual Approaches [pp. 205–206]: lateral guidance always; vertical optional; external CDI/VDI for deviation (per D-15)
  - DME Arc [p. 196]: supported; manual activation
  - RF Legs [p. 197]: RNAV RNP 0.3 non-AR approaches
  - Vectors to Final [p. 197]
  - ARINC 424 leg type handling (OPEN QUESTION 2): Pilot's Guide mentions TF, CF, DF, RF legs among examples but does not enumerate the full supported set. Spec should flag as limited-source feature; research needed.
- 7.6 Missed Approach [p. 193]
  - Before Missed Approach Point: Select Activate Missed Approach
  - After Missed Approach Point: crossing MAP suspends sequencing; pop-up prompt
  - Pilot selects: remain suspended or activate missed approach
- 7.7 Approach Hold [pp. 194–195]
  - Hold Options menu: Activate Hold, Insert After
  - Hold options: direction, inbound course, leg time or distance
  - Non-required holding: pop-up decision on RNP approach init
- 7.8 Autopilot Outputs [p. 207]
  - Roll steering (GPSS) terminates when approach mode selected on autopilot
  - Roll steering resumes after missed approach initiation
  - Caution: set heading bug for heading legs
  - LPV glidepath capture: output to compatible autopilots (KAP 140, KFC 225) [p. 207]
  - "Enable APR Output" advisory for compatible autopilots; manual activation required
  - Autopilot coupling during approach (OPEN QUESTION): exact XPL dataref names for GPSS/APR output require design-phase research

**Procedural fidelity augmentations per D-12 Q3c and D-14 (items 11–25 as corrected by Turn 20 research):**

- 7.A Glidepath vs. glideslope nomenclature [pp. 184–185, 200–203]
  - Garmin distinction: *glidepath* = GPS-derived vertical (LPV/LP+V/LNAV+V/LNAV-VNAV); *glideslope* = ILS radio vertical (375 cannot receive)
  - Spec uses Garmin terminology consistently; "+V suffix" = advisory vertical guidance only
- 7.B Advisory vs. primary vertical distinction [pp. 184–185, 199–204]
  - +V suffix modes (LNAV+V, LP+V): advisory vertical only — pilot flies to published MDA; annunciation indicates advisory status
  - LPV: primary vertical guidance to DA; precision-equivalent
  - LNAV/VNAV: baro-VNAV advisory vertical — different source, same advisory-only status as +V suffix modes
  - Display: flight phase annunciation color communicates advisory vs. primary
- 7.C ILS approach display behavior (GPS monitoring only) [p. 198]
  - "ILS and LOC approaches are not approved for GPS" pop-up on ILS load
  - 375 continues GPS lateral monitoring; annunciator bar stays at TERM (no LPV/LNAV annunciation for ILS)
  - No VDI on the 375; external CDI/HSI follows the NAV receiver — 375 not connected to NAV receiver
  - Any "VLOC" source indication if 375 communicates with external CDI source switch: spec-body design decision
- 7.D CDI scale auto-switching by flight phase [pp. 87–88]
  - Auto (default): 2.0 nm en route → linear ramp to 1.0 nm within 31 nm terminal → approach angular (2.0° typical, tightens from 1.0 nm to angular from 2.0 nm before FAF) [p. 87]
  - HAL table per flight phase: Approach 0.30 nm, Terminal 1.00 nm, En Route 2.00 nm [p. 88]
  - Output: scale transmitted to external CDI/HSI; also displayed on annunciator bar and optional on-screen CDI
  - Manual settings (0.30/1.00/2.00 nm) cap the upper end per flight phase
- 7.E Approach arming vs. active states [p. 200]
  - Armed: approach loaded, terminal CDI scale, GPS lateral only
  - Active: FAF crossed → approach-mode CDI scale, vertical guidance engaged (if applicable)
  - State machine: TERM → LPV at FAF; CDI scale tightens from 1.0 nm to angular 2.0 nm before FAF
  - Pilot-visible: annunciator bar mode change + scale change + autopilot mode change (if configured)
  - Integrity check: 60 seconds before FAF; failure → downgrade + advisory message [p. 200]
- 7.F Approach mode transitions [pp. 200–203]
  - LPV → LNAV downgrade on integrity loss (HAL/VAL exceedance): "GPS approach downgraded" advisory
  - LP → LNAV+V downgrade; LNAV/VNAV → LNAV on baro-VNAV loss
  - Each transition: annunciator bar mode change + message queue entry + external CDI behavior change
- 7.G CDI deviation display — on-screen vs. external [pp. 87–89]
  - Optional on-screen lateral CDI (CDI On Screen toggle, GNX 375 only) [p. 89]: small lateral indicator below GPS NAV Status key; lateral only; no vertical; requires active flight plan
  - Primary external CDI/HSI driven by 375 lateral-deviation output: pilot's primary tactical reference during approach
  - No on-375 VDI of any kind (per D-15; Pilot's Guide p. 205 explicit)
  - Output contract for external CDI: lateral deviation, CDI scale, course angle — see §15
- 7.H TO/FROM flag rendering [p. 183]
  - FROM/TO field displayed on annunciator bar (authoritative source for pilot)
  - External CDI TO/FROM output also driven by 375
  - Composite CDI caveat: composite-type CDIs show TO indications only [p. 183]
  - Both sides (annunciator bar + external output) require spec coverage
- 7.I Turn anticipation / "Time to Turn" advisory [pp. 200, 202]
  - As aircraft approaches turn waypoint: "Time to Turn" advisory annunciates + 10-second countdown timer
  - Confirmed at LPV approach walkthrough (p. 200) and LP approach walkthrough (p. 202)
  - Related: "Arriving at Waypoint" advisory at MAP crossing; "Missed Approach Waypoint Reached" pop-up [pp. 201, 203]
- 7.J Fly-by vs. fly-over waypoint turn behavior [p. 157]
  - Fly-over Waypoint Symbol: distinct symbol (software v3.20+) [p. 157]
  - Behavioral distinction: fly-by = anticipate turn, cut corner to capture outbound course; fly-over = overfly waypoint then turn
  - Spec needs behavioral distinction noted; detailed turn-geometry is limited-source (OPEN QUESTION 3)
- 7.K Active leg transition visual feedback [pp. 141, 201]
  - Magenta active-leg indicator advances on Map and FPL pages when aircraft crosses waypoint
  - Timing, visual transition, CDI scale behavior during transition: spec needs UX detail
- 7.L Altitude constraints on flight plan legs (OPEN QUESTION 1)
  - Whether the 375 displays published procedure altitude restrictions (cross at/above/below/between) is not documented in the extracted PDF
  - VCALC is a separate pilot-input planning tool — NOT automatic from procedure data [pp. 211–212]
  - Do not specify; flag as "behavior unknown from available documentation; research needed during design phase"
- 7.M ARINC 424 leg type handling (OPEN QUESTION 2)
  - TF, CF, DF, RF legs mentioned in Pilot's Guide examples; full supported set not enumerated
  - Spec should list confirmed types from PDF examples; flag enumeration as research-needed

**7.9 Approach-phase XPDR + ADS-B interactions [pp. 75–82, 245–256]**
- XPDR ALT mode during approach: Altitude Reporting mode typically active; air/ground state handled automatically (no pilot mode change required) [p. 78]
- ADS-B Out transmission during approach: 1090 ES Extended Squitter active when in ALT mode; transmits position + altitude during approach
- TSAA traffic display during approach: TSAA application runs when ADS-B In data available; traffic alerts during approach flight phases
- Flight phase annunciation + XPDR state correlation: annunciator bar flight phase (LPV, LNAV, etc.) concurrent with XPDR mode indicator
- See §11 for XPDR control detail; §4.9 for traffic display detail

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §1 (Xpl_dataref_subscribe for GPS flight phase, CDI source, deviation)
- `docs/knowledge/amapi_by_use_case.md` §2 (command dispatch for approach activation, missed approach)
- `docs/knowledge/amapi_patterns.md` Pattern 2 (multi-variable bus for flight phase + deviation data)
- `docs/knowledge/amapi_patterns.md` Pattern 17 (annunciator visible for flight phase annunciations)

**Open questions / flags.**
- XPL dataref names for GPS flight phase (ENRT, TERM, LNAV, LPV, etc.): require research from XPL dataref reference during design.
- SBAS/WAAS dataref availability in XPL: verify per-approach-type status via datarefs.
- Fly-by vs. fly-over turn geometry details (OPEN QUESTION 3): Pilot's Guide p. 157 references the symbol; behavioral turn-geometry (anticipation distance, corner-cutting algorithm) not prominently documented. Research needed.

---

## 8. Nearest Functions

**Scope.** Documents the Nearest page operational workflow. Identical across GPS 175, GNC 355, and GNX 375.

**Source pages.** [pp. 179–180]

**Estimated length.** ~60 lines

**Sub-structure:**
- 8.1 Nearest Access [p. 179]: Home > Nearest > select icon
- 8.2 Nearest Airports [p. 179]: up to 25 airports within 200 nm; identifier, distance, bearing, runway surface, runway length; runway criteria filter applied; tap → Airport Waypoint Information page
- 8.3 Nearest NDB, VOR, Intersection, VRP [p. 179]: identifier, type, frequency, distance, bearing
- 8.4 Nearest ARTCC [p. 180]: facility name, distance, bearing, frequency
- 8.5 Nearest FSS [p. 180]: facility name, distance, bearing, frequency; "RX" = receive-only stations

**AMAPI cross-refs.**
- Nav_get_nearest → `docs/knowledge/amapi_by_use_case.md` §10
- Nav_calc_distance, Nav_calc_bearing → `docs/knowledge/amapi_by_use_case.md` §10

---

## 9. Waypoint Information Pages

**Scope.** Documents the full waypoint information system: database waypoints, user-created waypoints, and the waypoint search and creation workflows. Identical across GPS 175, GNC 355, and GNX 375.

**Source pages.** [pp. 165–178]

**Estimated length.** ~120 lines

**Sub-structure:**
- 9.1 Database Waypoint Types [p. 165]: Airport, Intersection, VOR, VRP, NDB
- 9.2 Airport Information Page [p. 167]: Tabs: Info, Procedures, Weather (FIS-B; built-in on GNX 375), Chart (SafeTaxi if available)
- 9.3 Intersection/VOR/VRP/NDB Pages [p. 166]: common layout; VOR-specific: frequency, class, elevation, ATIS; NDB-specific: frequency, class
- 9.4 User Waypoints [pp. 168, 172–178]
  - Storage: up to 1,000 user waypoints
  - Identifier format: "USRxxx" by default (up to 6 characters, uppercase)
  - Limitations: no duplicate identifiers; active FPL waypoints not editable
  - Create: three reference methods — Lat/Lon, Radial/Distance, Radial/Radial [pp. 172–175]
  - Edit: modify name, location, comment [p. 176]
  - Delete [p. 168]
  - Import: from SD card CSV file [pp. 177–178]
- 9.5 Waypoint Search and FastFind [pp. 169–171]
  - FastFind Predictive Waypoint Entry: predictive matching by identifier
  - Search Tabs: Airport, Intersection, VOR, NDB, User, Search by Name, Search by Facility Name
  - User tab: lists all stored user waypoints (up to 1,000)

**AMAPI cross-refs.**
- Nav_get → `docs/knowledge/amapi_by_use_case.md` §10
- `docs/knowledge/amapi_by_use_case.md` §11 (Persist_add for user waypoint storage)

**Open questions / flags.**
- User waypoints must persist across power cycles (§14). Storage schema for 1,000 waypoints in Air Manager persist API requires design.

---

## 10. Settings / System Pages

**Scope.** Documents all user-configurable settings and system status pages. GNX 375 adds CDI On Screen to §10.1; §10.12 ADS-B Status reframed for built-in receiver; §10.13 Logs updated for 375 traffic logging.

**Source pages.** [pp. 86–109]

**Estimated length.** ~200 lines

**Sub-structure:**
- 10.1 CDI Scale [pp. 87–88]
  - Options: 0.30, 1.00, 2.00, 5.00 nm (full-scale deflection values)
  - Horizontal Alarm Limits: follow CDI scale; override by flight phase
  - **CDI On Screen (GNX 375 / GPS 175 only) [p. 89]**: lateral-only on-screen CDI; toggle in Pilot Settings; affects GPS NAV Status key layout
- 10.2 Airport Runway Criteria [p. 90]: runway surface filter; minimum runway length; include user airports
- 10.3 Clocks and Timers [p. 91]: countup, countdown, flight timer; UTC or local time display
- 10.4 Page Shortcuts [p. 92]: customize locater bar slots 2–3 (slot 1 = Map, fixed)
- 10.5 Alerts Settings [p. 93]: airspace alerts using 3D data; alert altitude settings; alert type by airspace type
- 10.6 Unit Selections [p. 94]: distance/speed, altitude, vertical speed, nav angle, wind, pressure, temperature
- 10.7 Display Brightness Control [p. 95]: automatic (photocell + optional dimmer bus); manual override
- 10.8 Scheduled Messages [p. 96]: one-time, periodic, event-based reminders; create/modify
- 10.9 Crossfill [p. 97]: dual Garmin GPS config; crossfill data: flight plans, user waypoints, pilot settings
- 10.10 Connectivity — Bluetooth [pp. 53–56]: Connext data link; pairing (up to 13 devices); flight plan import
- 10.11 GPS Status [pp. 103–106]: satellite graph; EPU, HFOM, VFOM, HDOP; SBAS Providers; GPS status annunciations
- **10.12 ADS-B Status [pp. 107–108] — GNX 375 framing: built-in receiver**
  - Built-in dual-link receiver status (no external LRU required)
  - Last uplink time; GPS source; FIS-B WX Status; Traffic Application Status (TSAA)
- **10.13 Logs [p. 109] — GNX 375: ADS-B traffic logging**
  - WAAS diagnostic data logging
  - ADS-B traffic data logging (GNX 375 only; not on GPS 175 or GNC 355)
  - Export to SD card

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §12 (User_prop_add_* for configurable unit settings, CDI scale, etc.)
- `docs/knowledge/amapi_by_use_case.md` §14 (Timer_start for clocks and flight timer)
- `docs/knowledge/amapi_patterns.md` Pattern 9 (user-prop boolean feature toggle)

---

## 11. Transponder + ADS-B Operation (GNX 375 Only)

**Scope.** The GNX 375's Mode S transponder (TSO-C112e, Level 2els, Class 1) with 1090 ES Extended Squitter ADS-B Out and built-in dual-link ADS-B In receiver. Includes XPDR Control Panel, squawk code entry, mode selection, IDENT function, ADS-B Out transmission, Flight ID management, built-in ADS-B In, remote control via G3X Touch (out of scope for v1), and failure modes. Replaces §11 COM Radio Operation from GNC 355. GPS 175 and GNC 355/355A have no transponder and no ADS-B Out.

**Source pages.** [pp. 18–20, 75–82, 102, 225, 244, 282–284, 290]

**Estimated length.** ~200 lines

**Sub-structure:**

### 11.1 XPDR Overview and Capabilities [pp. 18–19, 75]

- TSO-C112e (Level 2els, Class 1) compliant Mode S transponder
- 1090 MHz Extended Squitter ADS-B Out (integrated — not a separate transmitter)
- Dual-link ADS-B In receiver: 1090 ES for traffic + 978 MHz UAT for FIS-B weather and UAT traffic
- Integrated with GNX 375's GPS/MFD for position reporting
- Altitude source: external (from ADC/ADAHRS via altitude encoder input per p. 34; not computed on-unit)
- XPDR Control Panel accessed via XPDR key (app icon on Home page)

**AMAPI cross-refs:**
- `docs/knowledge/amapi_by_use_case.md` §1 (dataref subscriptions for XPDR state, ADS-B status)

---

### 11.2 XPDR Control Panel [p. 75]

- Access: tap XPDR key on Home page (context-dependent icon placement)
- Five labeled UI regions:
  1. Squawk Code Entry Field: active code display; unentered digits show as underscores
  2. VFR Key: one-tap to preprogrammed VFR code
  3. XPDR Mode Key: opens mode selection menu
  4. Squawk Code Entry Keys (0–7): ATCRBS-compatible range
  5. Data Field: displays pressure altitude OR Flight ID (toggle via menu)
- XPDR key visibility rules: key available when code entered / menu open / message viewed / Mode selected / leaving control panel; disappears while control panel is active

**AMAPI cross-refs:**
- `docs/knowledge/amapi_by_use_case.md` §3 (Button_add for XPDR keypad digits, VFR, Mode keys)
- `docs/knowledge/amapi_by_use_case.md` §7 (Txt_add/Txt_set for squawk code display, data field)
- B4 Gap 3: squawk code digit display via running text — consult `docs/reference/amapi/by_function/Running_txt_add_hor.md`

---

### 11.3 XPDR Setup Menu [p. 76]

- Access: Menu key from XPDR Control Panel
- Three menu items:
  1. Data Field toggle: switches data field display between pressure altitude and Flight ID
  2. 1090 ES ADS-B Out enable: toggle ON/OFF (only if configured pilot-controllable)
  3. Flight ID assignment: if editable (configuration-dependent availability)
- Data field display modes: Pressure Altitude (from external ADC/ADAHRS source) OR Flight ID (active value)

**AMAPI cross-refs:**
- `docs/knowledge/amapi_by_use_case.md` §2 (command dispatch for menu item selection)

---

### 11.4 XPDR Modes [p. 78]

- Three modes only (no Ground mode, no Test mode in pilot UI — per D-16 and p. 78):
  1. **Standby**: no interrogation replies; Bluetooth operational; ADS-B In active (not TIS-B participant)
  2. **On**: replies to interrogations (identification only, no altitude); ADS-B In active
  3. **Altitude Reporting**: replies with identification + pressure altitude; ADS-B Out includes altitude; ADS-B In active
- Mode characteristics table (reply behavior, altitude inclusion, Bluetooth, ADS-B In state)
- Altitude Reporting note (p. 78): air/ground state transmissions handled automatically — no pilot mode change required on landing/takeoff; no separate "Ground" mode
- Reply (R) symbol: indicates transponder responding to interrogations (visible in On + Altitude Reporting modes)

**AMAPI cross-refs:**
- `docs/knowledge/amapi_by_use_case.md` §1 (dataref for transponder_mode integer)
- `docs/knowledge/amapi_patterns.md` Pattern 17 (annunciator visible for mode indicator, Reply R symbol)

---

### 11.5 Squawk Code Entry [p. 79]

- Eight entry keys: 0–7 (ATCRBS range 0000–7777 octal)
- Backspace key or outer control knob to move cursor
- Unentered digits display as underscores
- Enter key confirms new code; Cancel key exits without changing
- Special squawk codes (informational only — no preset buttons):
  - 1200: VFR default (USA)
  - 7500: hijacking
  - 7600: loss of communications
  - 7700: emergency
- Active squawk code remains until new code entered

**AMAPI cross-refs:**
- `docs/knowledge/amapi_by_use_case.md` §3 (Button_add for keypad digit entry)
- `docs/knowledge/amapi_by_use_case.md` §2 (Xpl_dataref_write for transponder_code on Enter)

---

### 11.6 VFR Key and IDENT [p. 80]

- VFR key: one-tap sets squawk to preprogrammed VFR code (factory default 1200; configurable at installation)
- IDENT function: tapping XPDR key while control panel is active → IDENT for **18 seconds**
  - Causes transponder to send distinguishing signal to ATC radar display
  - Tapping XPDR key from another page opens the control panel first (not IDENT)
- IDENT state: visible on annunciator and Data Field during 18-second active period

**AMAPI cross-refs:**
- `docs/knowledge/amapi_by_use_case.md` §2 (command dispatch for IDENT activation, VFR code set)
- `docs/knowledge/amapi_patterns.md` Pattern 1 (triple-dispatch for XPDR actions: XPL + MSFS)

---

### 11.7 Transponder Status Indications [p. 81]

- Four distinct visual states on the control panel:
  1. **IDENT active (unmodified code)**: Reply active + IDENT function active + no code change
  2. **IDENT with new squawk code**: Reply active + modified transponder code + IDENT active (entering new code + Enter initiates IDENT automatically)
  3. **Standby mode**: Standby indicator + current squawk code (transponder not replying)
  4. **Altitude Reporting mode**: ALT indicator + Reply active + IDENT function accessible + active squawk code
- Tap behaviors per state:
  - Altitude Reporting: tap XPDR key → IDENT (unmodified code)
  - Standby: tap XPDR key → accepts modified code AND initiates IDENT

**AMAPI cross-refs:**
- `docs/knowledge/amapi_patterns.md` Pattern 17 (annunciator visible for each XPDR state)

---

### 11.8 Extended Squitter (ADS-B Out) [p. 77]

- 1090 MHz Extended Squitter transmission
- Toggle: XPDR Setup Menu → 1090 ES ADS-B Out ON/OFF (only if configured pilot-controllable)
- ON state: ADS-B Out messages + position information actively transmitted
- Transmitted content: GPS position (from GNX 375's internal GPS receiver) + pressure altitude (when in Altitude Reporting mode) + mode S squitter
- Integrated with XPDR hardware: ADS-B Out is not a separate transmitter — it is the Mode S 1090 MHz extended squitter

**AMAPI cross-refs:**
- `docs/knowledge/amapi_by_use_case.md` §2 (command dispatch for ADS-B Out toggle)

---

### 11.9 Flight ID [pp. 76, 77, 82]

- Usually configured at installation — not editable by default
- If editable (configuration-dependent): alphanumeric uppercase, 8-character max
- Default Flight ID: displays automatically in data field when data field = Flight ID mode
- Remote editability via G3X Touch (see §11.10)
- Configuration-dependent editability must be documented; spec should not assume editability

**AMAPI cross-refs:**
- `docs/knowledge/amapi_by_use_case.md` §11 (Persist_add for Flight ID if configurable)

---

### 11.10 Remote Control via G3X Touch [p. 82]

- G3X Touch can control: squawk code, transponder mode, IDENT, ADS-B transmission, Flight ID
- Pilot's Guide defers to G3X Touch Pilot's Guide for detailed operation
- **Out of scope for v1 instrument** — document as "available on real GNX 375; not implemented in v1 Air Manager instrument"

**Open questions / flags:**
- G3X Touch integration: confirm v1 exclusion remains appropriate at design phase.

---

### 11.11 ADS-B In (Built-in Dual-link Receiver) [pp. 18, 225; cross-ref §4.9]

- Dual-link receiver: 1090 ES (for traffic) + 978 MHz UAT (for FIS-B weather and UAT traffic)
- No external receiver required (unlike GPS 175 / GNC 355 which need GDL 88 or GTX 345)
- Drives FIS-B Weather page (§4.9)
- Drives Traffic Awareness page (§4.9)
- Enables TSAA traffic alerting application (§4.9)
- ADS-B In operates in all three XPDR modes (Standby, On, Altitude Reporting)
- TIS-B participant status: active only when in On or Altitude Reporting mode (not Standby)
- Cross-reference to §4.9 for display pages and interactions

**AMAPI cross-refs:**
- `docs/knowledge/amapi_by_use_case.md` §1 (dataref subscriptions for ADS-B In status)
- `docs/knowledge/amapi_patterns.md` Pattern 2 (multi-variable bus for XPDR + ADS-B state)

**Open questions / flags:**
- ADS-B In data availability in simulators: XPL has partial ADS-B dataref exposure; MSFS has limited ADS-B traffic data. Spec must define behavior when data is absent or degraded.

---

### 11.12 XPDR Failure / Alert [p. 82]

- Red "X" displayed over IDENT key on failure
- Advisory message alerts (cross-ref §11.13 and §13)
- XPDR control page unavailable during failure
- Display auto-returns to previous page if failure occurs while control panel is active
- Specific failure: "GNX 375 ADS-B interboard communication failure" advisory [p. 82]

**AMAPI cross-refs:**
- `docs/knowledge/amapi_patterns.md` Pattern 17 (annunciator visible for failure "X" indicator)

---

### 11.13 XPDR Advisory Messages [pp. 283–284, 290]

Nine distinct advisory conditions applicable to GNX 375:

From pp. 283–284 (XPDR/ADS-B Out):
1. "ADS-B Out fault. Pressure altitude source inoperative or connection lost." — altitude source loss
2. "Transponder has failed." — internal failure (1090 ES Out fail / XPDR fail / comm loss)
3. "Transponder is operating in ground test mode." — ground test indicator; cycle power after completion
4. "ADS-B is not transmitting position." — transponder not receiving valid GPS position

From p. 290 (GNX 375 traffic/ADS-B In):
5. "1090ES traffic receiver fault." — unable to receive 1090 ES traffic
6. "ADS-B traffic alerting function inoperative." — TSAA application unavailable
7. "ADS-B traffic function inoperative." — ADS-B Traffic input failure; electrical fault; all applications unavailable
8. "Traffic/FIS-B functions inoperative." — configuration data fault
9. "UAT traffic/FIS-B receiver fault." — unable to receive UAT data

Cross-reference to §13 Messages for full advisory formatting and message system context.

**AMAPI cross-refs:**
- `docs/knowledge/amapi_by_use_case.md` §7 (Txt_add/Txt_set for advisory message text)
- `docs/knowledge/amapi_patterns.md` Pattern 17 (MSG key flash state)

---

### 11.14 XPDR Persistent State [§14 cross-ref]

- Squawk code: retained across power cycles
- Mode setting: retained (Standby / On / Altitude Reporting)
- Flight ID: retained if configurable; factory-set value if not
- ADS-B Out enable state: retained
- Data field preference (altitude vs. Flight ID): retained

**AMAPI cross-refs:**
- `docs/knowledge/amapi_by_use_case.md` §11 (Persist_add for squawk code, mode, Flight ID, ADS-B Out state)
- `docs/knowledge/amapi_patterns.md` Pattern 11 (persist across sessions)

**Open questions / flags (§11 overall):**
- Exact XPL XPDR dataref names (OPEN QUESTION 4): `sim/cockpit2/radios/actuators/transponder_code`, `transponder_mode` and ADS-B-related datarefs require verification against current XPL datareftool output during design phase.
- MSFS XPDR SimConnect variables (OPEN QUESTION 5): `TRANSPONDER CODE:1`, `TRANSPONDER IDENT`, `TRANSPONDER STATE` differ between FS2020 and FS2024; Pattern 23 (FS2024 B: event dispatch) may apply. Exact variable names and behavior require design-phase research.
- IDENT command: XPL likely `sim/transponder/transponder_ident` or similar; MSFS `XPNDR_IDENT_ON`. Verify during design.
- Mode selection dataref: XPL exposes `transponder_mode` integer (0/1/2/3 — exact scheme requires verification).
- Anonymous mode: **does NOT apply** to GNX 375 (GPS 175 / GNC 355 + GDL 88 only; confirmed p. 84).
- TSAA aural alert delivery mechanism (OPEN QUESTION 6): direct `sound_play` vs. external audio panel dependency is a spec-body design decision.

---

## 12. Audio, Alerts, and Annunciators

**Scope.** Documents the complete alert system: alert type hierarchy, visual annunciations, aural alerts (present on GNX 375 via TSAA), and system-wide color convention. §12.4 aural alerts reframed: present on GNX 375 (not "GNX 375 only, not GNC 355" as in the 355 spec). §12.9 replaces COM Annunciations with XPDR Annunciations.

**Source pages.** [pp. 98–101]

**Estimated length.** ~100 lines

**Sub-structure:**
- 12.1 Alert Type Hierarchy [p. 98]
  - Warning (red): immediate action required
  - Caution (yellow): timely action required
  - Advisory (white/amber): awareness required, no immediate action
- 12.2 Alert Annunciations (Annunciator Bar) [p. 99]
  - Abbreviated messages at bottom of screen
  - Color matches alert level; warnings = white on red; cautions = black on yellow; advisories = white
  - FROM/TO field (p. 183): displayed on annunciator bar; pilot's authoritative TO/FROM reference
  - Flight phase annunciation slot: OCEANS/ENRT/TERM/DPRT/LNAV+V/LPV/etc.
  - CDI scale indicator slot: shows current scale mode
- 12.3 Pop-up Alerts [p. 100]
  - Triggered by terrain/traffic warnings and cautions
  - Appears only if alerted function's page is not already active
  - Pop-up window with alert details; requires pilot acknowledgment
- 12.4 Aural Alerts [p. 101]
  - **Aural traffic alerts present on GNX 375 via TSAA application**
  - Mute function: active only for current alert; does not mute future alerts
  - Aural alert delivery mechanism: see OPEN QUESTION 6 under §11
- 12.5 GPS Status Annunciations [pp. 104–106]
  - Satellite signal strength bars (up to 15 SVIDs)
  - GPS annunciations: ACQUIRING, 3D NAV, 3D DIFF NAV, LOI, GPS FAIL
  - SBAS/WAAS annunciations: LPV capability, provider selection
- 12.6 GPS Alerts [p. 106]
  - LOI: integrity not meeting requirements for flight phase → yellow "LOI"
  - GPS Fail: receiver failure, WAAS board failure
- 12.7 Traffic Annunciations [p. 254]: see §4.9 Traffic Awareness for full table
- 12.8 Terrain Annunciations [pp. 268–269]: see §4.9 Terrain Awareness for alert conditions
- **12.9 XPDR Annunciations (GNX 375 — replaces COM Annunciations)**
  - Squawk code display on XPDR Control Panel
  - Mode indicator: SBY / ON / ALT (three modes only per D-16)
  - Reply (R) indicator: transponder responding to interrogations
  - IDENT active indicator: 18-second IDENT state
  - Failure indicator: red "X" over IDENT key
  - Cross-reference to §11.7 for full status indication states

**AMAPI cross-refs.**
- `docs/knowledge/amapi_patterns.md` Pattern 17 (annunciator visible for all alert states + XPDR mode/reply/IDENT indicators)
- `docs/knowledge/amapi_patterns.md` Pattern 6 (power-state group visibility)
- `docs/knowledge/amapi_patterns.md` Pattern 16 (sound on state change — TSAA aural alerts)
- `docs/knowledge/amapi_by_use_case.md` §9 (Visible, Opacity, Move for alert element management)

---

## 13. Messages

**Scope.** Documents the complete advisory message system by category. §13.9 replaces COM Radio Advisories with XPDR Advisories. §13.11 Traffic System Advisories reframed for GNX 375's built-in receiver (no external LRU failure messages).

**Source pages.** [pp. 271–291]

**Estimated length.** ~150 lines

**Sub-structure:**
- 13.1 Message System Overview [p. 272]: queue; view-once advisories; MSG key flashes for unread messages
- 13.2 Airspace Advisories [p. 273]: Class B/C/D/E, TFR, MOA, restricted; informational only
- 13.3 Database Advisories [p. 274]: unavailable, corrupt, expired, region not found
- 13.4 Flight Plan Advisories [pp. 275–276]: FPL import failure, GDU disconnected, crossfill inoperative
- 13.5 GPS/WAAS Advisories [pp. 277–278]: GPS receiver fail, WAAS board failure, position accuracy degraded
- 13.6 Navigation Advisories [pp. 279–280]: course CDI/HSI mismatch; non-WGS84 waypoint
- 13.7 Pilot-Specified Advisories [p. 280]: custom reminders from Scheduled Messages
- 13.8 System Hardware Advisories [pp. 281–285]: knob stuck; SD card log error; various LRU failure advisories; transponder software version note (GNX 375 only)
- **13.9 XPDR Advisories (GNX 375 — replaces §13.9 COM Radio Advisories)**
  - Sourced from pp. 283–284 and 290 (nine advisory conditions per §11.13)
  - ADS-B Out fault / altitude source loss; transponder failure; ground test mode; position not transmitting
  - 1090 ES receiver fault; TSAA inoperative; ADS-B traffic inoperative; Traffic/FIS-B functions inoperative; UAT receiver fault
  - Cross-reference to §11.13 for full condition descriptions
- 13.10 Terrain Advisories [p. 287]: terrain alerts inhibited; re-enable instruction
- **13.11 Traffic System Advisories [p. 290] — GNX 375 framing: built-in receiver message set**
  - GNX 375 advisories reference the built-in 1090 ES + UAT receivers (no external LRU failure messages)
  - Distinct from GPS 175/GNC 355 traffic advisories (pp. 288–289) which reference GDL 88 LRU failures
  - See §11.13 items 5–9 for the nine applicable conditions
- 13.12 VCALC Advisories [p. 291]: "Approaching top of descent" advisory (60 seconds before TOD)
- 13.13 Waypoint Advisories [p. 291]: non-WGS84 waypoints in flight plan

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §7 (Txt_add/Txt_set for message text display)
- `docs/knowledge/amapi_patterns.md` Pattern 17 (annunciator visible for MSG key flash state)

---

## 14. Persistent State

**Scope.** Documents what data the GNX 375 retains across power cycles. §14.1 replaces COM State with XPDR State. All other persistent state categories carry over from GPS-navigation functions (unit-agnostic).

**Source pages.** [pp. 58, 60, 63, 72, 97] (distributed; plus §11 XPDR state pages)

**Estimated length.** ~50 lines

**Sub-structure:**
- **14.1 XPDR State (GNX 375 — replaces §14.1 COM State)**
  - Squawk code retained across power cycles
  - Mode setting retained (Standby / On / Altitude Reporting)
  - Flight ID retained (if configurable, user-set value; otherwise factory-set)
  - ADS-B Out enable state retained
  - Data field preference (altitude vs. Flight ID) retained
  - Page refs: §11 XPDR pages (pp. 75–82)
- 14.2 Display and UI State
  - Display brightness manual setting: retained
  - Unit selections (distance, altitude, temperature, etc.): retained
  - Page shortcuts (locater bar slots 2–3): retained
  - CDI scale setting: retained
  - CDI On Screen toggle: retained (GNX 375 only)
  - Runway criteria settings: retained
- 14.3 Flight Planning State
  - Flight plan catalog (all stored flight plans): retained
  - User waypoints (up to 1,000): retained
  - Active flight plan: retained
  - Active direct-to: may or may not persist (verify against device behavior)
- 14.4 Scheduled Messages: message definitions retained; trigger states may reset
- 14.5 Bluetooth Pairing: paired devices (up to 13) + auto-connect preferences retained
- 14.6 Crossfill Data: crossfill on/off setting retained

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §11 (Persist_add, Persist_get, Persist_put)
- `docs/knowledge/amapi_patterns.md` Pattern 11 (persist dial angle / state across sessions)

**Open questions / flags.**
- Flight plan catalog serialization: Air Manager persist API is scalar; spec must define encoding scheme (JSON string or multiple keys per waypoint).

---

## 15. External I/O (Datarefs and Commands)

**Scope.** Documents the data exchanged between the GNX 375 instrument and X-Plane (primary) or MSFS (secondary). COM-specific datarefs/events from GNC 355 §15 are dropped; XPDR + ADS-B datarefs/events added. Altitude source dependency for XPDR added. External CDI/VDI output contract specified per D-15.

**Source pages.** N/A — dataref names not in Pilot's Guide

**Estimated length.** ~50 lines

**Sub-structure:**
- 15.1 XPL Datarefs — Reads (subscriptions)
  - GPS position: lat/lon/altitude
  - GPS state: fix type, SBAS availability, integrity
  - **XPDR code: `sim/cockpit2/radios/actuators/transponder_code` (verify exact name)**
  - **XPDR mode: `sim/cockpit2/radios/actuators/transponder_mode` (verify exact name; int 0–3 scheme)**
  - **XPDR reply state: dataref TBD (verify in XPL datareftool)**
  - **ADS-B Out state: dataref TBD**
  - **Pressure altitude (from external ADC source): dataref TBD (altitude encoder input)**
  - Avionics master switch
  - Heading (magnetic); ground speed; track (true + magnetic)
  - XTK (cross-track deviation)
  - CDI source (GPS vs. VLOC); To/From flag; flight phase (GPS annunciation)
  - Active waypoint identifier and coordinates; ETE, distance to waypoint
  - CDI lateral deviation (for on-screen CDI rendering and external CDI output)
- 15.2 XPL Datarefs — Writes
  - **XPDR code write: on pilot squawk code entry via keypad (Enter)**
  - **XPDR mode write: on pilot mode selection (Standby / On / Altitude Reporting)**
  - **ADS-B Out enable write: on pilot toggle via XPDR Setup Menu**
- 15.3 XPL Commands
  - **XPDR IDENT: on pilot tap of XPDR key while control panel active**
  - **XPDR mode-select commands: mode cycle or discrete mode set**
  - Direct-to (activate); approach activation; missed approach
- 15.4 MSFS Variables — Reads (subscriptions)
  - **`TRANSPONDER CODE:1` (octal squawk code)**
  - **`TRANSPONDER STATE` (mode integer)**
  - **`TRANSPONDER IDENT` (boolean)**
  - GPS POSITION (LAT, LON, ALT); GPS GROUND SPEED; GPS TRACK TRUE TRACK
  - AVIONICS MASTER SWITCH
- 15.5 MSFS Events — Writes
  - **`XPNDR_SET` (set squawk code)**
  - **`XPNDR_IDENT_ON` (activate IDENT)**
  - **`XPNDR_STATE_SET` or equivalent (set mode)**
  - FS2024 B: event equivalents if applicable (Pattern 23)
- 15.6 External CDI/VDI Output Contract (per D-15)
  - Lateral deviation output to external CDI/HSI: scale, deviation value
  - Course angle output: desired track to external CDI OBS setting
  - CDI scale mode output: en route / terminal / approach angular
  - TO/FROM flag output: drives external CDI flag indicator
  - Roll steering (GPSS) output to compatible autopilots
  - **Vertical deviation output to external VDI (for LPV/LP+V/LNAV+V approaches): deviation value, scale semantics**
  - Glidepath capture output to autopilots (LPV): angular glidepath deviation
  - No on-screen VDI specified for GNX 375; all vertical deviation is output-only to external instruments
- 15.7 Altitude Source Dependency
  - XPDR pressure altitude comes from external ADC/ADAHRS (altitude encoder, GDC 74, GAE 12, or equivalent) [p. 34]
  - Spec must document: 375 XPDR data field shows altitude only when external source available; "ADS-B Out fault. Pressure altitude source inoperative..." advisory when source lost

**AMAPI cross-refs.**
- `docs/knowledge/amapi_by_use_case.md` §1 (Xpl_dataref_subscribe, Msfs_variable_subscribe)
- `docs/knowledge/amapi_by_use_case.md` §2 (Xpl_command, Msfs_event for write-back operations)
- `docs/knowledge/amapi_patterns.md` Pattern 1 (triple-dispatch button/dial for XPDR actions)
- `docs/knowledge/amapi_patterns.md` Pattern 14 (parallel XPL + MSFS subscriptions — XPDR datarefs differ substantially between sims)

**Open questions / flags.**
- Exact XPL dataref names for XPDR code, mode, reply, ADS-B Out state (OPEN QUESTION 4): require verification against XPL datareftool during design.
- MSFS XPDR SimConnect variable names and behavior (OPEN QUESTION 5): verify units (TRANSPONDER CODE is octal), state integer meanings, FS2020 vs. FS2024 differences.
- External CDI/VDI output: XPL dataref names for lateral deviation output to external CDI (`sim/cockpit/radios/nav1_hdef_dots`? or GPS-specific dataref?) require design-phase research.
- Vertical deviation output dataref to external VDI: XPL likely exposes GPS glidepath deviation; exact name requires verification.

---

## Appendix A: Family Delta — GNX 375 as Baseline

**Scope.** Compact comparison of GNX 375's functional differences from sibling units. GNX 375 is the baseline; GPS 175 and GNC 355/355A are the comparison units. GNX 375 as primary instrument per D-12 pivot. The shelved GNC 355 outline preserves the 355-baseline version of this appendix for eventual 355 resumption.

**Source pages.** [pp. 18–20, distributed "AVAILABLE WITH" annotations throughout]

**Estimated length.** ~150 lines

**Sub-structure:**
- A.1 Unit identification and coverage note
  - Pilot's Guide 190-02488-01 Rev. C covers: GPS 175, GNC 355/355A, and GNX 375
  - GNX 375 = primary instrument per D-12 pivot
  - D-02 "GNC 375" reference resolved per D-12: GNX 375 is the correct product designation
  - Note pointing to D-12 for pivot rationale; 355 implementation deferred
- A.2 GPS 175 vs. GNX 375 differences (GPS 175 is minimal unit)
  - GPS 175 lacks (vs. GNX 375 baseline):
    - Mode S transponder (entire §11)
    - ADS-B Out (no Extended Squitter)
    - Built-in ADS-B In (requires external GDL 88 or GTX 345)
    - TSAA traffic application with aural alerts
    - ADS-B traffic logging
  - GPS 175 identical to GNX 375:
    - All GPS/MFD navigation features
    - CDI On Screen [p. 89] (GPS 175 + GNX 375 only)
    - GPS NAV Status indicator key [p. 158] (GPS 175 + GNX 375 only)
    - Knob push = Direct-to (GPS 175 + GNX 375 pattern)
    - FIS-B weather (GPS 175 requires external GDL 88; behavior otherwise identical)
- A.3 GNC 355/355A vs. GNX 375 differences
  - GNC 355/355A lacks (vs. GNX 375 baseline):
    - Mode S transponder (entire §11)
    - ADS-B Out
    - Built-in ADS-B In (requires external GDL 88 or GTX 345)
    - TSAA with aural alerts
    - ADS-B traffic logging
    - CDI On Screen [p. 89]
    - GPS NAV Status indicator key [p. 158]
  - GNC 355/355A adds (features NOT on GNX 375):
    - VHF COM radio (GNC 355 §11 COM Radio Operation)
    - COM Standby Control Panel (GNC 355 §4.11)
    - 25 kHz channel spacing (355 standard); 8.33 kHz also on 355A (European operations)
    - COM volume, sidetone offset, monitor mode, reverse frequency lookup, user frequencies, COM alerts
    - Flight Plan User Field on FPL page [p. 155]
    - Knob push = standby frequency tuning (GNC 355 pattern)
  - GNC 355/355A identical to GNX 375:
    - All GPS/MFD navigation features; FIS-B weather (355: external hardware; framing differs)
    - Traffic (355: external hardware, no aural alerts; framing differs)
- A.4 GNX 375 variants
  - No GNX 375A equivalent documented in current Pilot's Guide
  - Placeholder: if Garmin releases a variant, this appendix section will enumerate differences
- A.5 Feature matrix (all units)
  - GPS/WAAS navigation, map, FPL, Direct-to, Procedures, Nearest, Waypoints: all units identical
  - Planning pages (VCALC, Fuel, DALT/TAS, RAIM): all units identical
  - FIS-B weather: identical behavior (GPS 175/GNC 355 need external receiver; GNX 375 built-in)
  - Traffic: identical display behavior (GPS 175/GNC 355 need external receiver, no aural; GNX 375 built-in + TSAA aural)
  - Terrain/TAWS: all units identical
  - Bluetooth: all units identical
  - Database Concierge: all units identical
  - XPDR + ADS-B Out: GNX 375 only
  - CDI On Screen: GPS 175 + GNX 375 only
  - GPS NAV Status indicator key: GPS 175 + GNX 375 only
  - COM radio: GNC 355/355A only
  - ADS-B traffic logging: GNX 375 only

---

## Appendix B: Glossary and Abbreviations

**Scope.** Key abbreviations and terms used throughout the spec. Sourced from the Pilot's Guide Glossary (Section 8) plus AMAPI-specific terms and 375-specific XPDR/ADS-B terms.

**Source pages.** [pp. 299–304]

**Estimated length.** ~65 lines

**Sub-structure:**
- B.1 Aviation abbreviations from Pilot's Guide Glossary [pp. 299–304]
  - Full list (~80 abbreviations): ACT, ADC, ADAHRS, ADS-B, CDI, CTK, DTK, ETE, FAF, FLTA, GPS, GPSS, HAL, LNAV, LPV, MAP, MFD, NDB, OBS, PDA, RAIM, SBAS, SVID, TSAA, VCALC, VOR, WAAS, XTK, etc.
- **B.1 additions for GNX 375 XPDR/ADS-B terms:**
  - Mode S: selective addressing transponder protocol (ICAO Annex 10)
  - Mode C: altitude-encoding transponder reply (older standard; Mode S is superset)
  - 1090 ES: 1090 MHz Extended Squitter — ADS-B Out transmission format
  - UAT: Universal Access Transceiver — 978 MHz ADS-B/FIS-B reception band
  - Extended Squitter: continuous 1090 MHz ADS-B Out broadcast from Mode S transponder
  - TSAA: Traffic Situational Awareness with Alerts — ADS-B-based traffic alerting application
  - FIS-B: Flight Information Services – Broadcast — UAT weather/NOTAM datalink
  - TIS-B: Traffic Information Service – Broadcast — ADS-B re-broadcast of radar targets
  - Flight ID: transponder-broadcast aircraft identification (callsign or registration)
  - Squawk code: 4-octal-digit ATCRBS identity code (0000–7777)
  - IDENT: transponder special position identification pulse (SPI); 18-second duration on GNX 375
  - WOW: Weight On Wheels — sensor indicating air vs. ground state (referenced in §7.9; GNX 375 handles internally)
  - Target State and Status: ADS-B Out message field reporting aircraft state (speed, altitude, heading intent)
  - TSO-C112e: FAA Technical Standard Order for Mode S transponder compliance; Level 2els, Class 1
  - TSO-C166b: ADS-B Out compliance standard (referenced in overview; GNX 375 compliant)
- B.2 AMAPI-specific terms used in this spec
  - Air Manager, AMAPI, dataref, persist store, canvas, dial, button_add, triple-dispatch, etc.
- B.3 Garmin-specific terms
  - FastFind: predictive waypoint entry
  - Connext: Garmin Bluetooth data service name
  - SafeTaxi: high-resolution airport diagram overlay
  - Smart Airspace: altitude-relative airspace de-emphasis feature
  - CDI On Screen: optional on-screen lateral CDI indicator (GPS 175 + GNX 375 only)
  - GPS NAV Status indicator key: from-to-next route info display (GPS 175 + GNX 375 only)

---

## Appendix C: Extraction Gaps and Manual-Review-Required Pages

**Scope.** Lists pages flagged by the C1 extraction process as sparse or empty, and documents content gaps identified during outline authoring. GNC 375/GNX 375 disambiguation gap resolved per D-12 — dropped. XPDR pages (pp. 75–82) verified as clean (not in sparse list).

**Source pages.** [extraction_report.md; pp. 1, 36, 110, 125, 208, 222, 270, 271, 292, 298, 308, 309, 310]

**Estimated length.** ~35 lines

**Sub-structure:**
- C.1 Sparse pages list (from extraction_report.md)
  - p. 1 (sparse): Cover page — text-only label extracted; image-only content
  - p. 36 (sparse): "INTENTIONALLY LEFT BLANK" — no content gap
  - p. 110 (sparse): "INTENTIONALLY LEFT BLANK" — no content gap
  - **p. 125 (sparse): Land data symbols page — symbols are image-only; text labels extracted but visual symbols absent**
    - Supplement: `assets/gnc355_reference/land-data-symbols.png`
    - Impact: §4.2 land data symbols should reference supplement
  - p. 208 (sparse): "INTENTIONALLY LEFT BLANK" — no content gap
  - p. 222 (sparse): "INTENTIONALLY LEFT BLANK" — no content gap
  - p. 270 (sparse): "INTENTIONALLY LEFT BLANK" — no content gap
  - p. 271 (sparse): Section 6 (Messages) header page — TOC only; content on subsequent pages
  - p. 292 (sparse): "INTENTIONALLY LEFT BLANK" — no content gap
  - p. 298 (sparse): "INTENTIONALLY LEFT BLANK" — no content gap
  - p. 308 (sparse): "INTENTIONALLY LEFT BLANK" — no content gap
  - p. 309 (empty): Truly empty page; no content
  - p. 310 (sparse): Page number only; no content
  - **XPDR pages pp. 75–82: verified CLEAN (not in sparse list)** — full XPDR content available for §11 authoring
  - pp. 83–85: clean pages; contain GPS 175/GNC 355 + GDL 88 content only — NOT applicable to GNX 375 §11
- C.2 Content gaps identified during outline authoring
  - External I/O (§15): XPDR/ADS-B dataref names not in Pilot's Guide — require XPL datareftool + MSFS SimConnect research during design (OPEN QUESTION 4 + 5)
  - External CDI/VDI output datarefs (§15.6): lateral + vertical deviation output names require design-phase research
  - Map page implementation approach (§4.2): canvas vs. Map_add vs. video streaming — architectural decision required during C2.2
  - Scrollable list implementation (§4.3, §4.5): no AMAPI pattern precedent — B4 Gap 2
  - Home page icon layout: image-based; pixel layout requires device reference
  - Altitude constraints on flight plan legs (§4.3, §7.L): not documented in extracted PDF — OPEN QUESTION 1
  - ARINC 424 leg type enumeration (§7.5, §7.M): incomplete in Pilot's Guide — OPEN QUESTION 2
  - Fly-by vs. fly-over turn geometry (§7.J): behavioral details sparse in Pilot's Guide — OPEN QUESTION 3
  - TSAA aural alert delivery mechanism (§4.9, §11): `sound_play` vs. external audio panel — OPEN QUESTION 6
  - ~~GNC 375/GNX 375 disambiguation~~ — resolved per D-12; dropped
- C.3 Summary
  - Significant content gaps: 1 (land data symbols — supplement available)
  - Design decision gaps: 4 (map rendering, scrollable lists, external I/O names, CDI/VDI output datarefs)
  - Open research questions: 6 (see items 1–6 above and flagged in respective sections)
  - Blank/filler pages with no content: 10 of 13 flagged pages are intentionally blank
  - OCR-applied pages: 0 (Tesseract was not available during extraction)
