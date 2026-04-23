---
Created: 2026-04-23T16:30:00-04:00
Source: docs/tasks/c22_e_prompt.md
Fragment: E
Covers: §§8–10 (Nearest Functions, Waypoint Information Pages, Settings/System Pages)
---

# GNX 375 Functional Spec V1 — Fragment E

---

## 8. Nearest Functions

**Scope.** The Nearest Functions provide rapid access to lists of nearby waypoints, ATC
frequencies, and weather frequencies within 200 nm of the aircraft's current GPS position.
Content and behavior are identical across GPS 175, GNC 355/355A, and GNX 375 — no
unit-specific framing applies to §8. Operational workflows in this section act on the
Nearest display pages documented in §4.6 (Fragment B). Entry limits and update intervals
apply uniformly; see §10.2 for runway criteria filter configuration (applies to §8.2 Nearest
Airports and Direct-to airport searches).

---

### 8.1 Nearest Access [p. 179]

The Nearest function is accessed from the Home page. Tap the **Nearest** icon to open
the Nearest page; then tap the desired waypoint or frequency type icon to view the
corresponding nearest list. The available type icons are: Airport, Intersection, VOR, VRP,
NDB, User Waypoint, Airspace, ARTCC, FSS, and Weather Frequency. Each list is ordered
closest to farthest. Lists update every 30 seconds (exception: Nearest Airspace updates once
per second). Entry limits vary by type (see §8.2–8.5 and §4.6, Fragment B).

---

### 8.2 Nearest Airports [p. 179]

Nearest Airports lists up to **25 airports** within 200 nm of the aircraft's position.
The runway criteria filter (minimum surface type and minimum runway length, configured in
§10.2) is applied to this list; only airports meeting the specified criteria appear.

Each entry displays the following columns:

| Column | Description |
|--------|-------------|
| Identifier | Airport ICAO identifier with type symbol |
| Distance | Distance from aircraft position (nm) |
| Bearing | Bearing from aircraft position (°) |
| Approach type | Highest available approach type (ILS, GPS, VOR, NDB, visual) |
| Runway length | Length of the longest runway |

Tapping a Nearest Airport entry opens the **Airport Waypoint Information page** for that
airport (§4.5, Fragment B), providing full detail including Procedures, Runways, Frequencies,
WX Data, NOTAMs, and Chart tabs.

---

### 8.3 Nearest NDB, VOR, Intersection, VRP [p. 179]

Nearest Intersection, VOR, VRP, and NDB lists each hold up to **25 entries** within 200 nm.

| Type | Columns displayed |
|------|------------------|
| Intersection | Identifier, symbol, distance, bearing |
| VOR | Identifier, symbol, distance, bearing, frequency |
| VRP | Identifier, symbol, distance, bearing |
| NDB | Identifier, symbol, distance, bearing, frequency |

Tapping any entry opens the corresponding Waypoint Information page (§4.5, Fragment B) for
that waypoint. VOR and NDB entries include frequency to support manual tuning of a NAV
radio in paired avionics, though the GNX 375 itself does not have a VHF COM radio or NAV
radio; frequency data is informational.

---

### 8.4 Nearest ARTCC [p. 180]

Nearest ARTCC (Air Route Traffic Control Center) lists up to **5 entries** within 200 nm.

| Column | Description |
|--------|-------------|
| Facility name | Full ARTCC facility name |
| Distance | Distance from aircraft position (nm) |
| Bearing | Bearing from aircraft position (°) |
| Frequency | Primary ARTCC contact frequency (MHz) |

When more than one frequency is available for an ARTCC entry at the listed range, a
**multiple-frequency key** appears; tap to view the additional frequencies. Frequency data
is informational; the GNX 375 does not have a VHF COM radio and cannot tune these frequencies.

---

### 8.5 Nearest FSS [p. 180]

Nearest FSS (Flight Service Station) lists up to **5 entries** within 200 nm.

| Column | Description |
|--------|-------------|
| Facility name | Full FSS facility name |
| Distance | Distance from aircraft position (nm) |
| Bearing | Bearing from aircraft position (°) |
| Frequency | FSS contact frequency; **"RX"** suffix denotes receive-only frequencies |

Frequencies marked **RX** are receive-only at the listed FSS. As with ARTCC, frequency data
is informational reference; the GNX 375 does not have a VHF COM radio. A multiple-frequency
key appears when more than one frequency is available.

> **AMAPI notes:** Nearest list population uses `Nav_get_nearest` (use-case §10 in
> `docs/knowledge/amapi_by_use_case.md`). Distance and bearing computation uses
> `Nav_calc_distance` and `Nav_calc_bearing` (§10). List text display uses `Txt_add`/`Txt_set`
> (§7). No GNX 375-specific AMAPI framing; all nearest-function patterns are unit-agnostic.

---

## 9. Waypoint Information Pages

**Scope.** The Waypoint Information pages provide detailed information for individual
navigation database waypoints and for pilot-created user waypoints. All workflows in §9
act on the Waypoint Information display pages documented in §4.5 (Fragment B); §9 authors
the operational workflows only — display page layouts are not re-authored here. Content and
behavior are unit-agnostic except where noted (§9.2 Airport Weather tab: FIS-B framing;
built-in on GNX 375, external hardware required on GPS 175 and GNC 355/355A per §4.5,
Fragment B).

---

### 9.1 Database Waypoint Types [p. 165]

The navigation database organizes database waypoints into five types:

| Type | Code | Description |
|------|------|-------------|
| Airport | APT | Airport with associated procedures, runways, frequencies, and services |
| Intersection | INT | Named fix at an intersection of navigational courses |
| VHF Omnidirectional Range | VOR | VOR station (frequency, class, elevation, ATIS) |
| Visual Reporting Point | VRP | VFR visual reference point; requires VRP-capable database |
| Non-Directional Beacon | NDB | NDB station (frequency, class, marker description) |

User waypoints (pilot-created) are a separate category; see §9.4.

---

### 9.2 Airport Information Page [p. 167]

The Airport Information page is the primary pre-approach briefing tool. It includes the
following selectable tabs:

| Tab | Contents |
|-----|---------|
| Info | Airport location, elevation, time zone, fuel availability |
| Procedures | Available approach, departure, and arrival procedures (see §7, Fragment D, for procedure loading) |
| Runways | Runway identifiers, length, surface type, and traffic pattern direction |
| Frequencies | Communication and localizer frequencies; "c" symbol = CTAF frequency |
| WX Data | METAR, city forecast, and TAF weather data sourced from FIS-B |
| NOTAMs | Distant and FDC NOTAMs within 100 nm of the FIS-B radio station position |
| VRPs | Nearest visual reporting points |
| Chart | SafeTaxi airport surface diagram (if available in the loaded database) |

**Weather tab — FIS-B framing.** The WX Data tab displays weather sourced from FIS-B
(Flight Information Services – Broadcast, 978 MHz UAT; see §4.9, Fragment C, for FIS-B
data types and reception behavior). On the GNX 375, FIS-B reception is via the **built-in
dual-link ADS-B In receiver** — no external hardware required. GPS 175 and GNC 355/355A
require external ADS-B hardware for FIS-B. For FIS-B WX Status and uplink health detail,
cross-ref §4.9 (Fragment C) and the ADS-B Status operational workflow at §10.12.

**Frequencies tab.** Available communication and localizer frequencies are listed for
reference. The "c" symbol identifies frequencies that function as the CTAF. The GNX 375
does not have a VHF COM radio; frequency entries are informational. Tap **More Information**
if available to view additional frequency details.

---

### 9.3 Intersection / VOR / VRP / NDB Pages [p. 166]

Intersection, VOR, VRP, and NDB information pages share a uniform layout (see §4.5,
Fragment B, for the common page elements: identifier key, location information, nearest
NAVAID information, waypoint coordinates, distance and bearing, Preview key).

Waypoint-type-specific fields:

**VOR [p. 167]:** frequency, station class (L/H/T), station declination, ATIS availability,
nearest airport (identifier, type icon, bearing, distance).

**NDB [p. 167]:** frequency, station class, marker description, nearest airport (identifier,
type icon, bearing, distance).

**Intersection [p. 167]:** nearest VOR (identifier, type icon, bearing, distance). No
frequency field.

**VRP [p. 167]:** nearest VRP (identifier, type icon, bearing, distance). No frequency
field. VRP data requires a VRP-capable navigation database.

---

### 9.4 User Waypoints [pp. 168, 172–178]

User waypoints are pilot-created points stored in the unit database. Unlike database
waypoints, user waypoints are fully editable. The GNX 375 (and GPS 175, GNC 355/355A)
stores up to **1,000 user waypoints**. For persistence encoding across power cycles, see
§14 (Fragment G); the 1,000-waypoint persist schema is Fragment G scope and is not
specified here.

**Identifier format [p. 173].** The default identifier is "USR" followed by a sequential
three-digit number (e.g., USR001, USR002). Identifiers may be up to **6 characters**
(uppercase only; custom). User airports (flagged with the Airport key) use "A" followed by
a sequential three-digit number (e.g., A001). Comments may be up to **25 characters**.

**Feature limitations [pp. 172, 174].** Duplicate user waypoint identifiers are not allowed.
Active FPL waypoints cannot be edited or deleted while in the active flight plan.

#### Create user waypoint [pp. 172–175]

Access: Home > Waypoint Info > Create WPT, or by tapping a non-waypoint location on the Map page.

Three position reference methods are available (mutually exclusive — enabling one disables
the others) [p. 174]:

| Method | Required inputs | Default comment format |
|--------|----------------|----------------------|
| LAT/LON [p. 175] | Latitude, longitude (decimal degrees) | `<LAT> <LON>` |
| Radial/Distance [p. 175] | Reference waypoint, radial, distance | `<Waypoint><Radial> / <Distance>` |
| Radial/Radial [p. 175] | Two reference waypoints + radials each | `<WPT1><Radial1> / <WPT2><Radial2>` |

Additional create options: assign a unique identifier; flag as a user airport (inhibits terrain
alerting in its vicinity); enter a comment; enable Temporary status (identifier expires at
next power cycle); edit graphically (hold/drag basemap to position icon); specify elevation
(user airports only). Tap **Create** to save; the associated information page opens for
confirmation and editing.

#### Edit user waypoint [p. 176]

Access from the User WPT information page (tap Edit), from the Nearest User Waypoint list
(tap identifier > Edit), or from the Active FPL page (tap identifier > WPT Info > Edit).
Limitations: user waypoints in the active flight plan are not editable.

From the Edit WPT page, position can be modified via Lat/Lon coordinate entry or graphically
(hold/drag basemap until icon appears over desired location; tap Enter > Save).

#### Delete user waypoint [p. 168]

From the User WPT information page: tap **Delete** (single waypoint, requires confirmation)
or **Delete All** (removes all user waypoints, requires confirmation). Waypoints in the
active flight plan cannot be deleted.

#### Import user waypoints from SD card [pp. 177–178]

User waypoints can be bulk-imported from a CSV file on an SD card.

**File format [p. 177].** Columns: A = Waypoint Name (up to 6 characters, uppercase),
B = Comment (up to 25 characters), C = Latitude, D = Longitude. One waypoint per row.
Latitude and longitude in decimal degrees; "−" for southern latitude or western longitude.

**File preparation [p. 178].** Save as `user.csv`; rename extension to `.wpt`; copy to a
blank SD card (FAT32, up to 8 GB). If an imported waypoint is within 0.0001° of an existing
user waypoint (lat and lon), the existing waypoint and name are retained.

**Import procedure [p. 178]:**
1. Power the unit off.
2. Insert the SD card containing the `.wpt` file.
3. Power on. The **Import Waypoints** key appears on the Waypoint Info page.
4. Home > Waypoint Info > Import Waypoints > Acknowledge pop-up.

Import runs in the background. An advisory message confirms successful import. If a same-name
waypoint conflict exists, the import function overwrites it (except the 0.0001° proximity
rule above).

> **Open question (§9.4 persistence).** User waypoints persist across power cycles. The
> 1,000-waypoint persist encoding schema (Air Manager persist API serialization of up to 1,000
> lat/lon + identifier records) is Fragment G scope — see §14 Persistent State (Fragment G).
> Fragment E does not specify the encoding contract.

---

### 9.5 Waypoint Search and FastFind [pp. 169–171]

#### FastFind Predictive Waypoint Entry [p. 169]

FastFind is accessed via the Waypoint Identifier key from any waypoint information page. As
the pilot enters characters, the Waypoint Identifier key label updates to show the identifier
of the nearest matching database entry. Autofill characters (shown in **cyan**) complete the
predicted identifier from the cursor position rightward. Tapping the key with autofill active
selects the predicted waypoint and opens its information page.

FastFind uses the aircraft's current GPS position; a single character press may yield a
confident match for nearby waypoints. FastFind is also available within flight plan editing
(§5, Fragment D) — searches relative to the insertion point in the flight plan. The term
"FastFind" is a Garmin-specific term; see Appendix B.3 (Fragment A) for definition.

"No matches found" and "Duplicate found" annunciate when applicable. If no match can be
predicted, "No suggestion" annunciates and the key is not selectable.

#### Search tabs [pp. 170–171]

The Find key opens a tabbed search interface. Available tabs and their contents:

| Tab | Contents |
|-----|---------|
| RECENT | Up to 20 most recently viewed waypoints |
| NEAREST | Up to 25 waypoints within a 200 nm radius; filterable by class (Airport, INT, VOR, NDB, VRP, or All) |
| FLIGHT PLAN | All waypoints in the active flight plan |
| USER | Up to 1,000 user-defined waypoints |
| SEARCH BY NAME [p. 171] | All airports, NDBs, and VORs associated with a specified facility name; tap "Search Facility Name" to begin |
| SEARCH BY CITY [p. 171] | All airports, NDBs, and VORs in proximity to a specified city; tap "Search City Name" to begin |

> **S13 note:** The outline labels the last tab "Search by Facility Name." Per PDF p. 171,
> there are two distinct tabs: "SEARCH BY NAME" (facility name search) and "SEARCH BY CITY"
> (city-proximity search). The PDF-accurate labels are used above.

Each entry in the search tabs displays the waypoint identifier, type icon, bearing, and
distance from current aircraft position.

> **AMAPI notes:** Waypoint database lookup → `docs/knowledge/amapi_by_use_case.md` §10
> (`Nav_get`, `Nav_get_nearest`). User waypoint creation and storage → §11 (`Persist_add`
> for persist store encoding; encoding schema deferred to §14, Fragment G). FastFind
> predictive matching — no AMAPI native function; implement via `Nav_get_nearest` with partial
> identifier filter. Search tab list rendering → §7 (`Txt_add`/`Txt_set`) with scrollable
> list implementation per B4 Gap 2 (design-phase decision).

---

## 10. Settings / System Pages

**Scope.** The Settings and System pages provide user-configurable settings and system status
readouts. Operational workflows in §10 act on the Settings and System display pages documented
in §4.10 (Fragment C); §10 authors the operational workflows only — display page layouts and
page-field structures are not re-authored here. Unit-specific framing:
- **§10.1 CDI On Screen** is available on GNX 375 and GPS 175 only (not GNC 355/355A); lateral
  indicator only, per D-15.
- **§10.12 ADS-B Status** is framed for the GNX 375 built-in dual-link receiver (no external
  LRU required), per D-16.
- **§10.13 Logs** ADS-B traffic data logging is GNX 375 only (not on GPS 175 or GNC 355/355A),
  per D-16.

All other §10 sub-sections are functionally identical across GPS 175, GNC 355/355A, and
GNX 375 unless noted.

---

### 10.1 CDI Scale [pp. 87–88] + CDI On Screen [p. 89]

#### CDI Scale configuration

Access: Home > System > Setup > CDI Scale.

The CDI Scale setting selects the full-scale deflection value for the CDI output. Available
manual settings and their use-case:

| Setting | Full-Scale Deflection | Typical use |
|---------|----------------------|-------------|
| 0.30 nm | 0.30 nm | Approach scale (manual override) |
| 1.00 nm | 1.00 nm | Terminal area |
| 2.00 nm | 2.00 nm | En route |
| 5.00 nm | 5.00 nm | Wide-area / oceanic operations |

See §4.10 (Fragment C) for the CDI Scale display page layout and field descriptions.

**Auto-switching behavior [pp. 87–88; cross-ref §7.D, Fragment D].** The default CDI Scale
setting is Auto. In Auto mode, the unit switches scale automatically by flight phase:
en route (2.0 nm), terminal within 31 nm of destination (ramps 2.0 → 1.0 nm over 1 nm),
approach (1.0 nm → angular approach scale from 2 nm before FAF to FAF). A manual scale
selection caps the upper scale bound — selecting 1.0 nm prevents the en route phase from
using 2.0 nm — but the approach scale still tightens during an active approach regardless
of the manual upper bound. See §7.D (Fragment D) for the full auto-switching behavior and
HAL (Horizontal Alarm Limit) table.

**Scale annunciation.** The CDI Scale selection is reflected in the CDI scale slot of the
annunciator bar (§4.10, Fragment C). External CDI/HSI output scale follows the active CDI
Scale; see §15.6 (Fragment G) for the external output contract.

#### CDI On Screen [p. 89] — GNX 375 / GPS 175 only

Access: Home > System > Setup > CDI On Screen (available only on GNX 375 and GPS 175;
not present on GNC 355/355A).

Toggling **CDI On Screen** ON displays a lateral CDI scale indicator on screen below the
GPS NAV Status indicator key (see §4.3, Fragment B, for key context). When active:
- A **lateral deviation indicator** appears; deviation indications require an active flight plan.
- **Lateral only** — no vertical deviation indicator is displayed on the GNX 375 screen.
  Per D-15, the GNX 375 has no internal VDI; all vertical deviation is output exclusively to
  external CDI/VDI instruments (see §15.6, Fragment G, for the vertical deviation output
  contract; see §7.G, Fragment D, for the on-screen vs. external CDI framing).
- When a visual approach is active, visual approach lateral advisory annunciations appear.

The CDI On Screen toggle state persists across power cycles. See §4.10 (Fragment C) for the
CDI On Screen display page framing.

---

### 10.2 Airport Runway Criteria [p. 90]

Access: Home > System > Setup > Airport Runway Criteria.

Runway criteria settings determine which airports appear in the Nearest Airports list (§8.2)
and inform the terrain alerting algorithm to avoid nuisance alerts near qualifying airports.

**Runway Surface [p. 90].** Available options:

| Option | Airports included |
|--------|------------------|
| Any | All surface types (default) |
| Hard Only | Hard-surface runways only |
| Hard/Soft | Hard and soft surfaces; excludes water |
| Water | Water runways (seaplane operations) |

Selecting **Any** allows all surface types to appear in the Nearest Airport list and be
considered by the Terrain function.

**Minimum Runway Length.** Specify a minimum runway length (feet) to exclude shorter
airports from the Nearest Airport list and to inform the terrain function. Entering "0"
allows runways of any length.

**Include User Airports.** Toggle to include or exclude user-defined airport waypoints from
the Nearest Airport search. When deselected, user airports are excluded from the Nearest
results.

---

### 10.3 Clocks and Timers [p. 91]

Access: Home > Utilities > Clock/Timers.

Three timer types are available:

| Timer type | Description | Controls |
|------------|-------------|----------|
| Clock/Generic Timer | Stopwatch-style; counts up or down; specify countdown preset | Direction (Up/Down), Start, Stop, Timer Preset |
| Trip/Departure Timer | Measures elapsed airborne time since last ground-to-air transition | Criteria (Power On or In Air), Reset Timer |

For the **Clock/Generic Timer**, countdown resets to the preset value after reaching zero;
useful for fuel-tank switch reminders or ATC hold timing.

**Clock settings [p. 91].** Access: Home > System > Setup > Date/Time. Format options:
12-hour, 24-hour, and UTC. For 12-hour or 24-hour format, specify a local offset from UTC.

Timer state (countdown value, timer direction, criteria selection) persists across power
cycles. See §14 (Fragment G) for persistent state encoding.

---

### 10.4 Page Shortcuts [p. 92]

Access: Home > System > Setup > Page Shortcuts.

The locater bar has three slots. **Slot 1** is reserved for the Map page (not configurable).
**Slots 2 and 3** are pilot-configurable. Available shortcut pages:

| Option | Notes |
|--------|-------|
| Traffic | May not be available depending on configuration |
| Terrain | — |
| Weather | May not be available depending on configuration |
| Nearest Airport | — |
| Flight Plan | — |

Tap a slot key and select from the available pages. Tap **Restore Defaults** to reset both
slots to their defaults (Terrain for Slot 2, Nearest Airport for Slot 3). Verify shortcut
operation after assignment; availability depends on installed features and configuration.

---

### 10.5 Alerts Settings [p. 93]

Access: Home > System > Setup > Airspace Alerts.

Airspace alerts use three-dimensional data (altitude, latitude, longitude) to avoid nuisance
alerts. Alert generation does not alter airspace depiction on the Map page or Smart Airspace
settings.

Alert altitude buffer: specify an altitude buffer value (**Alt Buffer**) that triggers an
alert before actual airspace boundary penetration.

Airspace alert control keys (on/off toggle per type, except Prohibited):

| Airspace type | Configurable |
|--------------|-------------|
| Class B / TMA | On/Off |
| Class C / TMA | On/Off |
| Class D | On/Off |
| Restricted | On/Off |
| MOA (Military) | On/Off |
| Other | On/Off |
| **Prohibited** | **Cannot be disabled** |

Alerts for Prohibited airspace cannot be disabled. See §12 (Fragment F) for the full alert
type hierarchy and delivery behavior.

---

### 10.6 Unit Selections [p. 94]

Access: Home > System > Setup > Units.

Unit Selections allow the pilot to customize display units for seven parameter types.
Tap the applicable parameter key to open a menu and select the unit type.

| Parameter | Available units |
|-----------|----------------|
| Distance / Speed | Nautical miles / knots (NM/KT); Statute miles / mph (MI/MPH); Kilometers / kph (KM/KPH) |
| Altitude | Feet (FT); Meters (M) |
| Vertical Speed | Feet per minute (FPM); Meters per second (MPS) |
| NAV Angle | Magnetic (°M); True (°T) |
| Wind | Vector (speed and direction); Headwind/Crosswind components |
| Pressure | Inches of mercury (inHg); Millibars / hectopascals (mb/hPa) |
| Temperature | Celsius (°C); Fahrenheit (°F) |

Unit selections persist across power cycles. See §14 (Fragment G) for persistent state
encoding. Unit selections crossfill to a paired GPS navigator when Crossfill is enabled
(§10.9; crossfill scope includes Nav Angle, Fuel units, and Temperature).

---

### 10.7 Display Brightness Control [p. 95]

Access: Home > System > Setup > Backlight.

**Automatic brightness control.** By default, display brightness is controlled by the
built-in photocell based on ambient light levels. Dimming is limited to prevent on-screen
indications from becoming unreadable.

**Dimmer bus input (optional, installer-configured).** The unit can be configured to
incorporate an aircraft dimmer bus input in addition to the photocell. When dimmer bus input
reaches the minimum level, brightness reverts to the photocell — preventing a black display
if the dimmer bus fails.

**Manual backlight offset.** During automatic control, the pilot may apply a manual
brightness offset using the Backlight page controls (Decrease / Increase Backlight buttons).
The manual offset adjusts the intensity level relative to the photocell or dimmer bus input.
Manual offset settings **persist across power cycles** (see §14, Fragment G).

**Installer lighting curves.** The brightness response to control adjustments is set by
installer-configured curves. If brightness control is unsatisfactory, a Garmin dealer can
adjust the curves.

---

### 10.8 Scheduled Messages [p. 96]

Access: Home > Utilities > Scheduled Messages.

Scheduled Messages allow pilots to create custom reminder messages that appear at a
configured time or event. Active reminders appear at the top of the scheduled message list.

Three message types:

| Type | Displays when | Timer applicable |
|------|--------------|-----------------|
| One time | Timer expires; then repeats each power cycle until deleted | Yes |
| Periodic | After a specified duration; countdown repeats after each display | Yes |
| Event | At a specified date and time | No (date/time trigger) |

**Create a message [p. 96]:** Tap Create Scheduled Message > specify type, message content,
and countdown timer value (for One time and Periodic types). Examples: "Call FBO",
"Close flight plan", "Switch fuel tanks".

**Modify a message.** Select an existing message to open the options menu: **Edit Message**
(modify content/type/timer from the Scheduled Messages page or system message list),
**Reset Timer** (restart countdown), **Delete Message** (requires confirmation; removes from
list). Scheduled message definitions persist across power cycles. See §13 (Fragment F) for
message display behavior in the system message queue and §14 (Fragment G) for persistence.

---

### 10.9 Crossfill [p. 97]

Access: Home > System > Setup > Crossfill.

Crossfill enables automatic data sharing between two compatible Garmin GPS navigators
(GPS 175, GNC 355/355A, or GNX 375 units; or one of these units and a GTN Xi running
software v20.30 or later). Enabling Crossfill on one unit automatically enables it on the
paired unit.

> **Note:** GPS 175 / GNC 355(A) / GNX 375 units are **not compatible** with GTN units
> that have Search and Rescue enabled for crossfill.

**Crossfill data types [p. 97]:**

| Category | Data crossfilled |
|----------|-----------------|
| Alerts | Traffic pop-up acknowledgment; missed approach waypoint pop-up acknowledgment; altitude leg pop-up acknowledgment |
| Flight Plan Catalog | All stored flight plans (including active flight plan navigation data when Crossfill is on) |
| System Setup | Date/Time offset; nearest airport criteria; units (Nav angle, Fuel, Temperature); CDI Scale setting |
| User waypoints | All stored user waypoints |

Some data crossfills regardless of the current Crossfill on/off setting. If a Cross-Side
navigator is configured and Crossfill is off, a system message alerts the pilot. Crossfill
on/off state persists across power cycles.

---

### 10.10 Connectivity — Bluetooth [pp. 53–56]

Access: Home > System > Connext Setup.

The GNX 375 supports Bluetooth wireless connectivity via the **Connext** data link (see
Appendix B.3, Fragment A), enabling communication with portable electronic devices running
the **Garmin Pilot** app. The unit supports pairing with up to **13 Bluetooth-enabled
devices**, with up to **2 simultaneous active connections** [p. 53]. Auto-reconnect is not
available for Android devices.

**Connext features available on paired device [p. 53]:**
- GPS position and velocity information
- Uncorrected barometric pressure altitude used by transponder and ADS-B (GNX 375 only)
- ADS-B In traffic data (GNX 375 built-in; GPS 175 / GNC 355 with external ADS-B In source)
- FIS-B weather and flight information (GNX 375 built-in; GPS 175 / GNC 355 with external source)
- AHRS data from built-in sensor (GNX 375; for portable device use only; no output to installed avionics)

**Device management [pp. 54–55].** Toggle **Bluetooth Enabled** on/off. Assign a
**Device Name** for the unit's Bluetooth identity. Open **Paired Devices** to view all
paired devices and their connection status:
- Connected and communicating normally (green indicator)
- Not available or not communicating (inactive indicator)
- **Auto Reconnect**: enables automatic connection when the paired device is in range at power-up
- **Remove**: unpairs the device; requires confirmation; re-pairing requires removing on both devices

**Flight plan import via Bluetooth [p. 56].** When the Garmin Pilot app sends a flight plan
wirelessly, an advisory message notifies the pilot that a new flight plan is available for
preview. Tap **Preview** to review before loading. This function can be disabled if a
portable device makes repeated erroneous transfer attempts.

**Paired device list persistence.** Up to 13 paired-device records persist across power
cycles. See §14 (Fragment G) for persistence.

> **Scope caveat — v1.** The full Connext / Garmin Pilot pairing and data-exchange workflow
> involves significant implementation complexity (Bluetooth API integration, FPL format
> parsing, AHRS broadcast, traffic data bridging). This functionality **may be out of scope
> for the v1 Air Manager instrument**. The spec preserves the functional description for
> completeness; scope resolution is deferred to the design phase.

---

### 10.11 GPS Status [pp. 103–106]

Access: Home > System > GPS Status (or from the Utilities menu).

The GPS Status page provides real-time visibility into GPS receiver health and satellite
acquisition state.

**Satellite signal graph [p. 103].** A bar graph shows signal strength for up to **15
satellites** (SVIDs). Each bar is labeled with the satellite's SVID. Bar color and style
indicate acquisition state:

| Symbol | Condition |
|--------|-----------|
| No bar | Receiver searching for the satellite |
| Gray bar, empty | Satellite located |
| Gray bar, solid | Satellite located; collecting data |
| Yellow bar, solid | Data collected; satellite excluded from position solution |
| Cyan bar, cross-hatch | FDE excludes satellite (identified as faulty) |
| Cyan bar, solid | Data collected; not used in position solution |
| Green bar, solid | Satellite in use in current position solution |
| "D" inside bar | Differential corrections in use (SBAS/WAAS) |

SVID number ranges: GPS satellites 1–31; SBAS satellites 120–138.

**Position accuracy fields [p. 104].** Four accuracy fields appear on the GPS Status page:

| Label | Full name | Units | Meaning |
|-------|-----------|-------|---------|
| EPU | Estimated Position Uncertainty | ft or m | Horizontal position error estimated by the FDE algorithm |
| HDOP | Horizontal Dilution of Precision | dimensionless | Geometric dilution factor; lower = better geometry |
| HFOM | Horizontal Figure of Merit | ft or m | 95% confidence horizontal accuracy estimate |
| VFOM | Vertical Figure of Merit | ft or m | 95% confidence vertical accuracy estimate |

Lower values indicate higher accuracy. HFOM and VFOM represent 95% confidence levels.

**SBAS Providers [p. 105].** Tap the SBAS Providers key to select from available providers:

| Provider | Service area |
|----------|-------------|
| WAAS | Alaska, Canada, contiguous 48 states, most of Central America |
| EGNOS | Most of Europe and parts of North Africa |
| MSAS | Japan only |
| GAGAN | India only |

Operating with SBAS active outside the service area may cause elevated accuracy values.
The **LOI annunciation** is the controlling indication for GPS integrity regardless of
displayed accuracy values.

**GPS status annunciations [p. 105]:**

| Annunciation | Condition |
|-------------|-----------|
| Acquiring | Using last known position + orbital data to locate satellites |
| 3D Nav | 3D navigation mode; GPS receiver computing altitude from satellites |
| 3D Diff Nav | 3D navigation with differential corrections (SBAS/WAAS active) |
| LOI | Satellite coverage insufficient to pass integrity monitoring; occurs before FAF if approach active |

**GPS alerts [p. 106].** See §12 (Fragment F) for GPS alert hierarchy. Key conditions:
Loss of Integrity (LOI annunciation; yellow), Loss of Navigation (active course invalidated;
≥5 seconds without adequate satellites), Loss of Position (no GPS position solution; ownship
icon absent).

> **AMAPI notes:** GPS status page subscriptions use `docs/knowledge/amapi_by_use_case.md`
> §1 (`Xpl_dataref_subscribe` / `Msfs_variable_subscribe` for GPS fix type, SBAS state,
> satellite count, accuracy fields). Pattern 2 (multi-variable bus) applies for the
> multi-field GPS status data bus. SBAS provider selection write-back uses §2 (command
> dispatch). GPS status annunciation display uses Pattern 17 (annunciator visible).

---

### 10.12 ADS-B Status [pp. 107–108]

Access: Home > System > ADS-B Status.

**GNX 375 framing — built-in receiver.** On the GNX 375, the ADS-B Status page reports the
status of the **built-in dual-link ADS-B In/Out receiver** — no external LRU (GDL 88,
GTX 345, or equivalent) is required. The status key label reads "**ADS-B Status**" on the
GNX 375. On GPS 175 and GNC 355/355A, an external ADS-B source is required and the key
label reflects the configured external device. This framing is consistent with §4.10
(Fragment C) and D-16. No prose in §10.12 implies that the GNX 375 requires an external
ADS-B transceiver.

**Uplink time display [p. 107].** The primary ADS-B Status key shows last uplink time in
minutes since the last FIS-B uplink:

| Display color | Meaning |
|--------------|---------|
| Green | Last uplink < 5 minutes ago |
| Yellow | Last uplink 5–15 minutes ago |
| ">15" (yellow) | Last uplink > 15 minutes ago |
| Dashes | Valid uplink data unavailable (device offline or no coverage) |

Tap the key to view last uplink time and GPS source information (GPS source = GNX 375
built-in GPS receiver driving ADS-B Out position reports).

**FIS-B WX Status sub-page [p. 108].** Tap **FIS-B WX Status** to view the reception
quality and ground-station coverage status for individual FIS-B weather products. This
sub-page is also accessible from the FIS-B Weather setup menu (§4.9, Fragment C). For
FIS-B data types and reception behavior, cross-ref §4.9 (Fragment C).

**Traffic Application Status sub-page [p. 108].** Tap **Traffic Application Status** to
view the running state of the three traffic applications:

| Application | Description |
|------------|-------------|
| AIRB | Airborne ADS-B traffic surveillance |
| SURF | Surface traffic surveillance |
| ATAS (TSAA) | Airborne Traffic Alerting (Traffic Situational Awareness with Alerting) — GNX 375 |

Each application reports one of four states:

| State | Meaning |
|-------|---------|
| On | Running; required ownship data available and meets performance criteria |
| Available to Run | Configured; input data available but performance criteria not yet met |
| Unavailable to Run | Required input data not available due to a failure |
| Unavailable - Fault | Input data available but does not meet performance criteria, or non-computed data condition |

TSAA (ATAS) is the GNX 375-only traffic alerting application providing aural alerts; see
§4.9 (Fragment C) and §11.11 (Fragment F) for built-in ADS-B receiver source and TSAA
operational detail.

---

### 10.13 Logs [p. 109]

Access: Home > Utilities > Logs.

The Logs page provides access to diagnostic and data logging functions stored in the unit's
internal memory.

**WAAS Diagnostic Log** (available on all units — GPS 175, GNC 355/355A, and GNX 375):
- Log files generated automatically at unit power-up
- Oldest file overwritten when internal log capacity is reached
- Export path: "log_files" folder on SD card

**ADS-B Log — GNX 375 only** [p. 109]:
- ADS-B traffic data logging is available **on GNX 375 only**; not available on GPS 175 or
  GNC 355/355A (per D-16). The GNX 375 built-in dual-link ADS-B In receiver is the data source.
- Log files generated automatically at unit power-up
- Oldest file overwritten when internal log capacity is reached
- Export path: "log_files" folder on SD card
- ADS-B log files may take several minutes to export

**Export procedure [p. 109]:**
1. Insert an SD card.
2. Home > Utilities > Logs.
3. Select **WAAS Diagnostic Log** or **ADS-B Log** (ADS-B Log key available on GNX 375 only).
4. If no log files are present, the key is not available.

This framing is consistent with §4.10 Logs page (Fragment C) and D-16 ADS-B scope decision.

> **AMAPI notes:** Settings page operational workflows primarily use
> `docs/knowledge/amapi_by_use_case.md` §12 (`User_prop_add_*` for configurable unit
> selections, CDI scale, runway criteria, brightness mode, scheduled messages, Crossfill
> enable); §11 (`Persist_add/get/put` for settings that persist across power cycles per
> Pattern 11); §14 (`Timer_start` for clocks and flight timer). Pattern 9 (user-prop boolean
> toggle) applies to CDI On Screen, Crossfill, Bluetooth Enabled, and Include User Airports.
> §10.11 GPS status multi-field data bus → Pattern 2 (multi-variable bus). §10.12 ADS-B
> Status data subscriptions → §1 (dataref subscribe) + Pattern 2.

---

## Coupling Summary

This section is authored per D-18 for CD/CC coordination across the 7-fragment spec. It is not part of the spec body and is stripped on assembly.

### Backward cross-references (sections this fragment references authored in prior fragments)

- Fragment A §1 (Overview): GNX 375 baseline framing, no-internal-VDI constraint (D-15) — referenced in §10.1 CDI On Screen (lateral only, no vertical).
- Fragment A §2 (Physical Layout & Controls): Home key and menu navigation pattern — referenced in §8.1 Nearest Access, §10 Settings access; Connext as Bluetooth data service — §10.10.
- Fragment A §3 (Power-On / Startup / Database): Connext data link framing — referenced in §10.10 Bluetooth; GPS acquisition — referenced in §10.11 GPS Status.
- Fragment A Appendix B (Glossary): Terms verified present via grep before finalizing this list. **Verified-present terms claimed here:** SBAS (B.1), WAAS (B.1), CDI (B.1), VDI (B.1), GPSS (B.1), FIS-B (B.1 additions), UAT (B.1 additions), 1090 ES (B.1 additions), Extended Squitter (B.1 additions), TSAA (B.1 additions), Connext (B.3), TSO-C166b (B.1 additions), RAIM (B.1), FastFind (B.3), CDI On Screen (B.3), GPS NAV Status indicator key (B.3), SafeTaxi (B.3). **NOT claimed (absent from Appendix B per C2.2-C X17 and C2.2-D F11):** EPU, HFOM, VFOM, HDOP, TSO-C151c — these are GPS Status field labels used inline in §10.11 body but are NOT formal Appendix B glossary entries.
- Fragment B §4.3 (FPL Page): GPS NAV Status indicator key — §10.1 CDI On Screen toggle affects key layout; cross-ref for context.
- Fragment B §4.5 (Waypoint Information Display Pages): §9.1–9.5 operational workflows act on these displays. Search tabs, FastFind, User Waypoint page, Airport Information tabs all established in §4.5.
- Fragment B §4.6 (Nearest Display Pages): §8.1–8.5 operational workflows act on these displays. Entry limits, update intervals, runway criteria filter application established in §4.6.
- Fragment C §4.9 (Hazard Awareness — FIS-B + Traffic + TSAA): §9.2 Airport Information Weather tab + §10.12 ADS-B Status FIS-B WX Status + Traffic Application Status cross-ref; OPEN QUESTION 6 (TSAA aural delivery) cross-ref context only — not re-preserved here.
- Fragment C §4.10 (Settings/System Display Pages): §10.1–10.13 operational workflows act on these displays; CDI Scale display page, CDI On Screen toggle, ADS-B Status page layout, Logs page fields all established in §4.10.
- Fragment D §7.D (CDI Scale auto-switching): §10.1 CDI Scale operational workflow cross-refs §7.D for flight-phase auto-switching and manual-cap behavior.
- Fragment D §7.G (CDI deviation display): §10.1 CDI On Screen operational workflow cross-refs §7.G for lateral-only framing and D-15 consistency.

### Forward cross-references (sections this fragment writes that later fragments will reference)

- §9.4 User Waypoints → §14 Persistent State (Fragment G): 1,000-waypoint persist encoding schema.
- §10.3 Clocks and Timers → §14 Persistent State (Fragment G): timer state persistence.
- §10.6 Unit Selections → §14 Persistent State (Fragment G): unit-preference persistence.
- §10.7 Display Brightness → §14 Persistent State (Fragment G): brightness offset persistence.
- §10.8 Scheduled Messages → §14 Persistent State (Fragment G): message list persistence.
- §10.9 Crossfill → §14 Persistent State (Fragment G): Crossfill on/off state persistence.
- §10.10 Bluetooth → §14 Persistent State (Fragment G): paired-device list persistence.
- §10.1 CDI Scale → §15 External I/O (Fragment G) §15.6: external CDI/HSI output contract.
- §10.11 GPS Status → §15 External I/O (Fragment G): GPS status datarefs.
- §10.12 ADS-B Status → §15 External I/O (Fragment G): ADS-B status datarefs; §11 Transponder + ADS-B (Fragment F) for built-in receiver detail and §11.11 ADS-B In.
- §10.5 Alerts Settings → §12 Alerts (Fragment F): alert-type hierarchy and aural delivery.
- §10.8 Scheduled Messages → §13 Messages (Fragment F): message queue display and dismiss behavior.
- §10.12 FIS-B WX Status → §11.11 ADS-B In receiver status (Fragment F).

### Outline coupling footprint

This fragment draws from outline §§8–10 only. No content from §§1–7 (Fragments A + B + C + D), §§11–15, or Appendices A/B/C is authored here.
