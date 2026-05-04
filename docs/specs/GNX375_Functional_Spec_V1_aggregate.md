# GNX 375 Functional Spec V1

<!-- Assembled from seven part files via scripts/assemble_gnx375_spec.py.
     Source manifest: docs/specs/GNX375_Functional_Spec_V1.md
     Fragments: GNX375_Functional_Spec_V1_part_{A..G}.md
     Generated: 2026-05-04T07:36:16-04:00 -->

---

## 1. Overview

**Scope.** Defines the GNX 375's identity, establishes it as the primary instrument per D-12,
and sets scope boundaries for this spec. GNX 375 is a 2" × 6.25" panel-mount GPS/MFD with
Mode S transponder and built-in dual-link ADS-B In/Out.

---

### 1.1 Product description and family placement [p. 18]

The GNX 375 is a 2" × 6.25" panel-mount navigator with a full-color capacitive touchscreen and
Bluetooth. Its distinguishing hardware: a TSO-C112e (Level 2els, Class 1) compliant Mode S
transponder and a built-in dual-link ADS-B In/Out receiver. ADS-B Out is transmitted via 1090
MHz Extended Squitter. ADS-B In covers both 1090 MHz Extended Squitter (traffic) and 978 MHz
UAT (traffic and subscription-free FIS-B weather), providing TSAA traffic alerting without
external hardware.

Sibling units in Pilot's Guide 190-02488-01 Rev. C:

- **GPS 175** — GPS/MFD only; no COM, no transponder, no built-in ADS-B. External ADS-B In
  possible via GDL 88 or GTX 345.
- **GNC 355/355A** — GPS/MFD + TSO-C169a VHF COM (25 kHz; 355A adds 8.33 kHz); no
  transponder, no built-in ADS-B.
- **GNX 375 (baseline)** — GPS/MFD + Mode S transponder (TSO-C112e) + built-in dual-link
  ADS-B In/Out.

---

### 1.2 Unit feature comparison [p. 19]

| Feature | GPS 175 | GNC 355 / 355A | GNX 375 |
|---------|---------|----------------|---------|
| GPS/WAAS navigation | ✓ | ✓ | ✓ |
| Moving map, terrain, FPL | ✓ | ✓ | ✓ |
| VHF COM radio | — | ✓ | — |
| Mode S transponder (TSO-C112e) | — | — | ✓ |
| ADS-B Out (1090 ES) | — | — | ✓ |
| ADS-B In — dual-link (1090 ES + UAT) | External only | External only | Built-in |
| TSAA traffic alerting with aural alerts | — | — | ✓ |
| CDI On Screen | ✓ | — | ✓ |
| GPS NAV Status indicator key | ✓ | — | ✓ |
| Database Concierge / Bluetooth | ✓ | ✓ | ✓ |

---

### 1.3 Scope of this spec [D-01, D-12]

**Covers:** screen pages (layout, data fields, navigation model); pilot input behaviors (button,
knob, touch actions, mode transitions); XPDR + ADS-B functions; alerts and annunciations;
state persistence; external I/O for X-Plane 12 (primary) and MSFS (secondary).

**Excludes:**
- Pilot technique and aeronautical guidance
- MSFS-specific implementation details (secondary per D-01; addressed in §15 only)
- IFR operating procedures beyond instrument behavior (deferred to design phase)
- On-screen VDI — the GNX 375 has **no internal VDI**; vertical deviation is output only to
  external CDI/VDI instruments (full treatment in §7 and §15.6 per D-15)
- COM radio — the GNX 375 has no VHF COM; see forthcoming GNC 355/355A spec

---

### 1.4 How to read this spec

GNX 375-exclusive features are marked **"GNX 375 only"**. Features shared by GPS 175 and
GNX 375 but absent on GNC 355/355A are marked **"GPS 175 + GNX 375"**. The Pilot's Guide
"AVAILABLE WITH: GNX 375" marker is the authoritative source for 375-exclusive features.

Sibling-unit differences are noted inline where material; full comparative treatment is in
Appendix A (see Fragment G, C2.2-G).

---

## 2. Physical Layout & Controls

**Scope.** Documents the GNX 375 hardware interface: bezel components, SD card, touchscreen
gestures, keys, knob functions, page navigation labels, and color conventions. This section is
the physical-action reference for all pilot interactions in the spec. Key distinction: the GNX 375
inner knob push = Direct-to window access, not COM standby tuning (GNC 355/355A behavior).

---

### 2.1 Bezel components [p. 21]

Bezel hardware is identical across GPS 175, GNC 355/355A, and GNX 375.

- **Power/Home key** — powers unit on (short press from off) or off (hold ≥0.5 s); returns to
  Home page from any page.
- **Inner & outer concentric knobs** — multipurpose input; full behavior in §2.5 and §2.7.
- **Photocell** — ambient light sensor for automatic display brightness adjustment.
- **SD card slot** — database updates, log export, screenshots, software upgrades, Flight
  Stream 510 connectivity; see §2.2.
- **Ledges** — hand stability during data entry.

---

### 2.2 SD card slot operations [p. 22]

**Requirements:** FAT32 format, 8–32 GB capacity.

Uses: data log export, screen captures, software upgrades, database updates, system
configuration saves, Flight Stream 510 wireless connectivity.

**Insertion:** power off the unit; hold card with label facing the display's left edge; push until
back edge is flush with the bezel. **Ejection:** power off; press lightly on the exposed edge to
release the spring latch. Never insert or remove while in flight.

**macOS note:** do not use macOS to format SD cards intended for avionics use. Use the SD
Memory Card Formatter app (SDcard.org), Quick Format option.

---

### 2.3 Touchscreen gestures [p. 23]

| Gesture | Motion | Uses |
|---------|--------|------|
| **Tap** | Brief single-finger contact | Open page/menu; activate key; select option; show map info |
| **Tap and hold** | Touch and hold | Continuous scroll (directional keys); continuous increment/decrement |
| **Swipe** | Touch, slide, lift | Multi-pane navigation (left/right); list scroll; map pan |
| **Flick** | Quick up or down motion | Fast list scroll |
| **Pinch & stretch** | Two fingers together/apart | Map zoom: stretch = zoom in, pinch = zoom out |

> **AMAPI notes:** Long-press (tap and hold) → `docs/knowledge/amapi_by_use_case.md` §3,
> Pattern 4. Map pan/zoom and scrollable list gestures beyond `button_add` are a B4 Gap 2
> area; consult GTN 650 sample for implementation patterns.

---

### 2.4 Keys and UI primitives [pp. 24–26]

**Common command keys:** Messages (system messages list; flashes when unread); Back (previous
page, cancel); Menu (context menu); Enter (confirm); Select (choose item).

**Function keys** — toggle a function on/off; current state shown below the key label.

**App icons** — Home page tiles launching apps; some apps (Utilities, System) have subpage icons.

**Menus** — expandable panes; multi-pane menus navigated by swipe or inner knob turn. Pop-up
menus open at the default or previously selected value.

**Lists** — scrollable; all keys inactive during scroll; scroll bar shown.

**Tabs** — left/right side panes grouping content (lists, data fields, function keys, or mixed).

**Keypads:** numeric (single pane; Backspace and Enter always at right); alphanumeric (multiple
keysets accessed by swipe or key; active keyset indicated at bottom).

---

### 2.5 Control knob functions [pp. 27–30]

**Inner knob push behavior differs substantially from GNC 355/355A — this is a key
implementation distinction.**

| Knob | Action | GPS 175 / GNX 375 |
|------|--------|--------------------|
| Outer | Turn | Page shortcut selection (locater bar); cursor placement; cursor movement in data field |
| Inner | Turn | Map zoom; list scroll; data input; character modification in data entry |
| Inner | **Push** | **Opens Direct-to window (first push); activates direct-to course (second push)** |

GNC 355/355A inner push behavior (absent on GNX 375): first push enables standby
frequency tuning; second push enables COM volume control. No COM-radio knob mode
sequence exists on the GNX 375.

> **AMAPI notes:** `docs/knowledge/amapi_by_use_case.md` §4, Patterns 11, 15, 20, 21.
> Pattern 15 (mouse_setting + touch_setting pair) applies to the dual concentric knob.

---

### 2.6 Page navigation labels (locater bar) [pp. 28–29]

- **Slot 1** — dedicated Map shortcut (fixed, not configurable).
- **Slots 2–3** — user-customizable page shortcuts.
- Active slot indicated by cyan background and border; outer knob advances through slots.

**Knob function indicators** (icons right of bar) show available actions per active page context:

| Context | Available knob functions |
|---------|--------------------------|
| Map active | Map zoom; toggle user fields |
| Flight Plan active | FPL scrolling |
| Home page active | Page shortcut navigation; access Direct-to window |
| Direct-to window active | Waypoint editing; activate course |

---

### 2.7 Knob shortcuts [pp. 29–30]

**GPS 175 / GNX 375 shortcut:** from the Home page, push the inner knob once → Direct-to
window opens. After selecting a waypoint, push again → activates the direct-to course.

The GNC 355/355A standby frequency tuning shortcut (push from most pages) and COM
volume shortcut (second push) are absent on the GNX 375. A cyan border indicates active
knob focus mode.

---

### 2.8 Screenshots [p. 31]

**Requirements:** SD card, FAT32, 8–32 GB. **Limitation:** not available with Flight Stream 510.

**Capture:** push and hold the inner control knob; while depressed, push and release the
Home/Power key. A camera icon momentarily appears in the annunciator bar. Images save to
the `print` folder in the SD card root directory.

---

### 2.9 Color conventions [p. 32]

| Color | Meaning on GNX 375 |
|-------|---------------------|
| Red | Warning conditions |
| Yellow | Cautionary conditions |
| Green | Safe operating conditions; engaged modes |
| White | Scales and markings; current data and values; heading legs |
| Magenta | GPS navigation data; active flight plan legs; parallel track |
| Cyan | Pilot-selectable references; knob focus indicator |
| Gray | Missing or expired data; product unavailable |
| Blue | Water (map depiction) |

The Pilot's Guide associates Green with "Active COM frequency" and Cyan with "Standby COM
frequency." These descriptions apply to GNC 355/355A only — the GNX 375 has no COM radio.

---

## 3. Power-On, Self-Test, and Startup State

**Scope.** Documents the startup sequence, self-test, fuel preset, power-off, and database
management lifecycle. Startup and database behavior is **identical across GPS 175, GNC 355,
and GNX 375** (harvest map §3 [FULL] categorization).

---

### 3.1 Power-up sequence [p. 38]

1. Unit receives power from the aircraft electrical system; bezel key backlight momentarily
   illuminates.
2. Startup screen displays: unit software versions, installed database names and status,
   and a **Database Updates** access key (startup-only features).
3. System failure annunciations typically clear within 30 seconds.
4. Tap **Continue** → Instrument Panel Self-Test page.
5. If an instrument remains flagged after one minute, check the associated LRU; contact
   Garmin support.

---

### 3.2 Instrument panel self-test [p. 38]

Continuous built-in test (CBIT) exercises the processor, memory, and all external inputs and
outputs. The Instrument Panel Self-Test page shows expected results of all external equipment
checks. The pilot should verify that CDI outputs and displayed data are correct for connected
equipment. Failure annunciations clear as checks pass; persistent annunciations after one
minute indicate real faults. Fuel setup keys are also accessible on this page depending on unit
configuration (see §3.3).

---

### 3.3 Preset fuel quantities [p. 39]

Fuel setup keys reside on the startup page or the Instrument Panel Self-Test page (unit
configuration dependent):

- **Fuel on Board** — enter current fuel quantity via keypad; preset keys for "full" and "tabs"
  aid rapid entry. Field may not be editable if interfaced with a digital fuel computer.
- **Fuel Flow** — set fuel flow amount; value auto-decrements based on current flow.

> **Caution:** Ensure fuel quantity values are accurate before flight.

---

### 3.4 Power-off [p. 39]

Push and hold the Power/Home key ≥0.5 s → countdown timer initiates; power-off annunciation
replaces the knob function indicator. Unit shuts down when the timer reaches zero.

> **Warning:** Do not power off the unit while airborne unless operational procedures require it.

---

### 3.5 Database loading and management [pp. 40–52]

**Supported database types:**

| Database | Content | Expires? |
|---------|---------|---------|
| Navigation | Airport, NAVAID, waypoint, airspace (Garmin or Jeppesen) | Yes |
| Obstacles | Obstacle and wire data | Yes |
| SafeTaxi | Airport surface diagrams | Yes |
| Basemap | Water, geopolitical boundaries, roads | No |
| Terrain | Terrain elevation data | No |

Databases reside in internal memory. An SD card (FAT32, 8–32 GB) is required for all update
methods. Basemap and Terrain do not expire; all others update on a regular cycle.

**Active vs. standby:** active databases are in use; standby databases are preloaded awaiting
their effective date. Yellow text at startup indicates databases that are unavailable, pre-effective,
missing date info, or expired.

**Manual updates (startup page, ground only):** tap **Databases** → Database Updates page →
select individual databases or **Select All** → tap **Start**. The unit restarts automatically on
completion. By default, only recommended databases are shown; **Show All** reveals all
entries including pre-effective and error-state entries. Basemap and Terrain transfer
automatically without user action. **Select Region** appears when two databases of the same
type and cycle cover different regions; **Error Info** shows error details.

**Automatic updates:** when a newer database is detected on the SD card or in the standby
queue and the aircraft is on ground, on-screen prompts guide the transfer; unit restarts on
completion.

**Database Concierge (wireless):** requires Flight Stream 510 + Garmin Pilot app + ground.
Pilot downloads databases in Garmin Pilot; Flight Stream 510 transfers wirelessly. Supports
automatic updates for effective-date databases and preloading of pre-effective databases.
Progress shown via status bars. Tap **WiFi Info** (startup or Database Updates page) for
connection status, device name, SSID, and password. Tap **Skip** to cancel unfinished transfers;
completed databases activate; "Transfers interrupted" displays if none completed.

**Database SYNC:** synchronizes active and standby databases across configured LRUs (GPS 175,
GI 275, GNC 355, GNX 375, GDU TXi v3.10+, GTN v6.72, GTN Xi v20.20+). Not applicable to
Terrain; does not support Chart Streaming. Toggle: Home > System > System Status > Menu >
DB SYNC. When a standby database becomes effective on ground, each LRU prompts for restart.
SYNC covers both active and standby slots.

> **AMAPI notes:** Persist state across power cycles → `docs/knowledge/amapi_by_use_case.md`
> §11 (Persist_add/get/put). Power-state group visibility for startup vs. operational display →
> `docs/knowledge/amapi_patterns.md` Pattern 6.

---

## Appendix B: Glossary and Abbreviations

**Scope.** Aviation abbreviations from the Pilot's Guide Glossary (pp. 299–304) plus
GNX 375-specific XPDR/ADS-B additions, AMAPI terms, and Garmin product terms. This
appendix is in Fragment A so later fragments can reference glossary terms without
forward-referencing unauthored content.

---

### B.1 Aviation abbreviations [pp. 299–304]

Key abbreviations used throughout this spec (subset; full source in Pilot's Guide Section 8).

| Term | Definition |
|------|-----------|
| **ACT** | Altitude Compensated Tilt |
| **ADC** | Air Data Computer |
| **ADAHRS** | Air Data / Attitude & Heading Reference System |
| **ADS-B** | Automatic Dependent Surveillance Broadcast |
| **AP** | Autopilot |
| **ARTCC** | Air Route Traffic Control Center |
| **CDI** | Course Deviation Indicator — lateral deviation from desired course |
| **DTK** | Desired Track — desired course between two waypoints |
| **ETE** | Estimated Time En route |
| **FAF** | Final Approach Fix |
| **FLTA** | Forward Looking Terrain Avoidance |
| **FPL** | Flight Plan |
| **GPS** | Global Positioning System |
| **GPSS** | Global Positioning System Steering — roll-steering output to autopilot |
| **GSL** | Geometric Sea Level |
| **IAF** | Initial Approach Fix |
| **LNAV** | Lateral Navigation — non-precision GPS approach guidance |
| **LPV** | Localizer Performance with Vertical guidance — precision GPS approach |
| **MAP** | Missed Approach Point |
| **MFD** | Multi-Function Display |
| **NDB** | Non-Directional Beacon |
| **OBS** | Omni Bearing Selector |
| **RAIM** | Receiver Autonomous Integrity Monitoring |
| **SBAS** | Satellite-Based Augmentation System |
| **SVID** | Satellite-Vehicle Identification |
| **TAF** | Terminal Aerodrome Forecast |
| **TFR** | Temporary Flight Restriction |
| **TSAA** | Traffic Situational Awareness with Alerting — see B.1 additions |
| **VCALC** | Vertical Calculator |
| **VDI** | Vertical Deviation Indicator — external instrument driven by GNX 375 output |
| **VLOC** | VOR / Localizer |
| **VOR** | VHF Omnidirectional Range |
| **WAAS** | Wide Area Augmentation System |
| **XPDR** | Transponder |
| **XTK** | Cross-Track deviation |

---

### B.1 additions — GNX 375 XPDR/ADS-B terms

All 15 terms are used in §§11–15 and required by Fragments C–G.

| Term | Definition |
|------|-----------|
| **Mode S** | Selective addressing transponder protocol (ICAO Annex 10); enables individual aircraft addressing and Extended Squitter ADS-B Out; superset of Mode C |
| **Mode C** | Altitude-encoding transponder reply format used by ATC radar interrogation; Mode S is the successor superset |
| **1090 ES** | 1090 MHz Extended Squitter — ADS-B Out format used by the GNX 375; carries position, velocity, and identity |
| **UAT** | Universal Access Transceiver — 978 MHz ADS-B In band; the GNX 375 dual-link receiver covers 1090 ES and UAT |
| **Extended Squitter** | Continuous 1090 MHz ADS-B Out broadcast from the Mode S transponder; carries Target State and Status and other ADS-B Out fields |
| **TSAA** | Traffic Situational Awareness with Alerting — ADS-B traffic alerting on GNX 375; provides visual and aural alerts (GNX 375 only) |
| **FIS-B** | Flight Information Services – Broadcast — weather and NOTAM datalink on 978 MHz UAT; provides NEXRAD, METARs, TAFs, TFRs, PIREPs without subscription |
| **TIS-B** | Traffic Information Service – Broadcast — ATC radar targets re-broadcast over ADS-B; supplements the traffic picture with non-ADS-B aircraft |
| **Flight ID** | Transponder-broadcast aircraft identification (callsign or registration); retained across power cycles on GNX 375 |
| **Squawk code** | 4-digit octal identity code (0000–7777) assigned by ATC; entered via XPDR Control Panel keypad; retained across power cycles |
| **IDENT** | Transponder special position identification pulse (SPI); activated via XPDR Control Panel; 18-second duration on GNX 375 |
| **WOW** | Weight On Wheels — sensor indicating air vs. ground state; referenced in §7 approach-phase XPDR behavior; handled internally by GNX 375 |
| **Target State and Status** | ADS-B Out message field reporting selected altitude, autopilot mode, and TCAS/ACAS state; part of Extended Squitter payload |
| **TSO-C112e** | FAA Technical Standard Order for Mode S transponder compliance; Level 2els, Class 1; GNX 375 transponder is TSO-C112e compliant (not TSO-C112d) |
| **TSO-C166b** | FAA Technical Standard Order for ADS-B Out compliance (1090 ES); GNX 375 ADS-B Out is TSO-C166b compliant |

---

### B.2 AMAPI-specific terms

| Term | Definition |
|------|-----------|
| **Air Manager** | Panel simulation platform for which this instrument is authored |
| **AMAPI** | Air Manager API — Lua-based programming interface for instrument development |
| **dataref** | X-Plane simulator variable (read or write); subscribed via `xpl_dataref_subscribe` |
| **persist store** | Air Manager key-value store surviving power cycles; accessed via `Persist_add/get/put` |
| **canvas** | AMAPI 2D drawing surface; vector graphics via `canvas_add` and draw callbacks |
| **dial** | AMAPI rotary input: virtual (`dial_add`), hardware (`hw_dial_add`) |
| **button_add** | AMAPI touchscreen tap handler; primary input primitive |
| **triple-dispatch** | Pattern 1 — one user action dispatches to XPL command, MSFS event, and local state simultaneously |

---

### B.3 Garmin-specific terms

| Term | Definition |
|------|-----------|
| **FastFind** | Predictive waypoint entry; matches partial identifier input to database in real time |
| **Connext** | Garmin Bluetooth data service; exchanges FPL, traffic, weather, position with portable devices |
| **SafeTaxi** | High-resolution airport surface diagram overlay (runways, taxiways, landmarks, hot spots) |
| **Smart Airspace** | De-emphasizes airspace boundaries not pertinent to the aircraft's current altitude |
| **CDI On Screen** | Optional on-screen lateral CDI indicator; GPS 175 + GNX 375 only (not GNC 355/355A) |
| **GPS NAV Status indicator key** | Lower-right from/to/next route display; GPS 175 + GNX 375 only (not GNC 355/355A) |

---

## Appendix C: Extraction Gaps and Manual-Review-Required Pages

**Scope.** Pages flagged by C1 extraction as sparse or empty, and content gaps identified
during outline authoring. GNC 375 / GNX 375 disambiguation is resolved per D-12 and is
not an active flag.

---

### C.1 Sparse pages list [extraction_report.md]

| Page | Status | Impact |
|------|--------|--------|
| p. 1 | Sparse | Cover page — image-only logo; no functional content gap |
| p. 36 | Sparse | Intentionally blank — no gap |
| p. 110 | Sparse | Intentionally blank — no gap |
| **p. 125** | **Sparse** | **Land data symbols — image-only; text labels extracted but symbols absent. See §4.2 (C2.2-B).** |
| p. 208 | Sparse | Intentionally blank — no gap |
| p. 222 | Sparse | Intentionally blank — no gap |
| p. 270 | Sparse | Intentionally blank — no gap |
| p. 271 | Sparse | Section 6 header / TOC only; content on subsequent pages — no gap |
| p. 292 | Sparse | Intentionally blank — no gap |
| p. 298 | Sparse | Intentionally blank — no gap |
| p. 308 | Sparse | Intentionally blank — no gap |
| p. 309 | Empty | Truly empty — no content |
| p. 310 | Sparse | Page number only — no content |

**XPDR pages pp. 75–82: CLEAN (not in sparse list).** Full XPDR text is available for §11
authoring in C2.2-F. Pages pp. 83–85 are also clean but contain GPS 175 / GNC 355 + GDL 88
content only — not applicable to GNX 375 §11.

---

### C.2 Content gaps identified during outline authoring

**Design decision gaps** (architectural decisions required during C2.2):

1. Map page rendering (§4.2): canvas vs. Map_add API vs. video streaming — decision needed
   before C2.2-B authoring.
2. Scrollable list implementation (§4.3, §4.5): no AMAPI precedent (B4 Gap 2); consult
   GTN 650 sample or develop new pattern.
3. XPDR/ADS-B dataref names (§15): not in Pilot's Guide; require XPL datareftool verification
   during design phase (OPEN QUESTION 4 + 5).
4. External CDI/VDI output datarefs (§15.6): names require design-phase research.

**Open research questions** (design-phase investigation required):

1. Altitude constraints on FPL legs (§4.3, §7): automatic display of procedure altitude
   restrictions — behavior unknown in extracted PDF.
2. ARINC 424 leg type enumeration (§7): incomplete in Pilot's Guide.
3. Fly-by vs. fly-over turn geometry (§7): behavioral details sparse.
4. Exact XPL XPDR dataref names (§15): verify against datareftool.
5. MSFS XPDR SimConnect variable names (§15): FS2020 vs. FS2024 differences.
6. TSAA aural alert delivery (§11, §4.9): `sound_play` vs. external audio panel — spec-body
   design decision.

**Significant content gap:** p. 125 land data symbols (see C.1).

**Resolved gap (not active):** GNC 375 / GNX 375 disambiguation — resolved per D-12; GNX 375
is the correct designation.

---

### C.3 Summary

| Category | Count |
|---------|-------|
| Significant content gaps | 1 (land data symbols) |
| Design decision gaps | 4 |
| Open research questions | 6 |
| Blank / filler pages (no functional gap) | 10 of 13 flagged pages |
| Empty pages | 1 (p. 309) |
| OCR-applied pages | 0 (Tesseract unavailable during extraction) |


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

#### Land data symbols [p. 125 — sparse]

Land data symbols are depicted on the map basemap at appropriate map detail levels.
Pilot's Guide p. 125 is sparse (image-only; text labels extracted but symbol graphics absent).
Symbols include:

- Railroad
- National highway
- Freeway
- Local highway
- Local road
- River and lake boundaries
- State and province borders
- Small, medium, and large city symbols

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


## 11. Transponder + ADS-B Operation (GNX 375 Only)

The GNX 375's Mode S transponder (TSO-C112e, Level 2els, Class 1) with integrated 1090 ES Extended Squitter ADS-B Out and a built-in dual-link ADS-B In receiver is the feature that most distinguishes the GNX 375 from its siblings. This section wholesale replaces §11 COM Radio Operation from the GNC 355 spec: the GNX 375 has no VHF COM radio. The GPS 175 and GNC 355/355A have no transponder and no ADS-B Out; they require an external GDL 88 or GTX 345 for ADS-B In data. All XPDR framing in this section follows D-16: three pilot-selectable modes only; WOW air/ground state handled automatically; built-in dual-link ADS-B In receiver; TSAA aural alerts on GNX 375; Remote G3X Touch control documented but out of v1 scope.

---

### 11.1 XPDR Overview and Capabilities [pp. 18–19, 75]

The GNX 375 incorporates a TSO-C112e (Level 2els, Class 1) compliant Mode S transponder [p. 18]. Capabilities:

- **Mode S transponder:** TSO-C112e; three pilot-selectable modes (Standby, On, Altitude Reporting)
- **ADS-B Out:** 1090 MHz Extended Squitter; TSO-C166b compliant; integrated with the Mode S transmitter (not a separate LRU)
- **ADS-B In:** built-in dual-link receiver — 1090 ES (traffic) + 978 MHz UAT (FIS-B weather and UAT traffic); no external hardware required
- **Pressure altitude source:** external (from ADC/ADAHRS via altitude encoder input; GNX 375 does not compute pressure altitude internally — cross-ref §3 Fragment A for external source framing, §15.7 Fragment G for the dataref contract)
- **XPDR Control Panel:** accessed via the XPDR key (app icon on Home page)

Sibling contrast: GPS 175 and GNC 355/355A have no transponder, no ADS-B Out, and no built-in ADS-B In receiver. For the full feature matrix, cross-ref Appendix A.

**AMAPI cross-refs:** `amapi_by_use_case.md` §1 (dataref subscriptions for XPDR state, ADS-B status); `amapi_patterns.md` Pattern 14 (parallel XPL + MSFS subscriptions — XPDR datarefs differ substantially between sims).

---

### 11.2 XPDR Control Panel [p. 75]

Access: tap the XPDR key (app icon) on the Home page (cross-ref §4.1 Fragment B). The XPDR key is context-sensitive: it is unavailable while the control panel is active, and reappears when you enter a squawk code, open the XPDR menu, view a message, select the Mode key, or leave the control panel.

Five labeled UI regions on the control panel [p. 75]:

| # | Region | Function |
|---|--------|----------|
| 1 | Squawk Code Entry Field | Displays the active 4-digit squawk code; unentered digits appear as underscores |
| 2 | VFR Key | One-tap sets squawk to the preprogrammed VFR code |
| 3 | XPDR Mode Key | Opens mode selection menu (Standby / On / Altitude Reporting) |
| 4 | Squawk Code Entry Keys (0–7) | Eight-key ATCRBS code entry keypad |
| 5 | Data Field | Displays pressure altitude or Flight ID (toggled via Setup Menu) |

**AMAPI cross-refs:** `amapi_by_use_case.md` §3 (Button_add for digit keys, VFR key, Mode key); §7 (Txt_add/Txt_set for squawk code display and data field text); B4 Gap 3 (squawk code digit display via Running_txt_add_hor).

---

### 11.3 XPDR Setup Menu [p. 76]

Access: tap Menu from the XPDR Control Panel. Three items:

| Item | Function | Availability |
|------|----------|-------------|
| Data Field | Toggle data field between **Pressure Altitude** and **Flight ID** | Always available |
| ADS-B Out | Enable / disable 1090 ES ADS-B Out transmission | Only if configured pilot-controllable at installation |
| Flight ID | Assign a unique flight identifier | Only if Flight ID configured editable at installation |

When Data Field = Pressure Altitude, the field shows altitude from the external ADC/ADAHRS source. If the source is unavailable, the field is blank and advisory item 1 (§11.13) is generated.

**AMAPI cross-refs:** `amapi_by_use_case.md` §2 (command dispatch for menu item selection, ADS-B Out toggle).

---

### 11.4 XPDR Modes [p. 78]

The GNX 375 transponder has exactly **three pilot-selectable modes**: Standby, On, and Altitude Reporting [p. 78]. There is no Ground mode, no Test mode in the pilot UI, and no Anonymous mode on the GNX 375. (Anonymous mode is a GPS 175/GNC 355 + GDL 88 feature only, per D-16.) Tapping the XPDR Mode Key opens the mode selection menu with these three options.

**Mode characteristics [p. 78]:**

| Mode | Reply Behavior | Pressure Altitude in ADS-B Out | TIS-B Participant | ADS-B In |
|------|---------------|-------------------------------|-------------------|----------|
| Standby | No interrogation replies; no ADS-B Out | No | No | Active |
| On | Replies to interrogations (identification only) | No | Yes | Active |
| Altitude Reporting | Replies to identification + altitude interrogations | Yes | Yes | Active |

Key notes:
- The **Reply (R) symbol** displays in On and Altitude Reporting modes to indicate the transponder is responding to ATC radar interrogations.
- In Altitude Reporting mode, all aircraft air/ground state transmissions are handled **automatically** via the transponder — no pilot mode change is required on landing or takeoff [p. 78]. Use Altitude Reporting at all times unless ATC instructs otherwise.
- ADS-B In is active in all three modes; TIS-B participant status is active only in On and Altitude Reporting, not Standby.
- Cross-ref §7.9 (Fragment D) for approach-phase XPDR mode interaction detail.

**AMAPI cross-refs:** `amapi_by_use_case.md` §1 (dataref for transponder_mode); §2 (command dispatch for mode selection); `amapi_patterns.md` Pattern 1 (triple-dispatch for XPDR mode set: XPL + MSFS + FS2024 B if applicable); Pattern 17 (annunciator for mode indicator, Reply R symbol).

---

### 11.5 Squawk Code Entry [p. 79]

Eight digit keys (0–7) provide access to all ATCRBS codes in the range 0000–7777 (octal) [p. 79]. Entry sequence:

1. Tap a digit key to begin the code selection sequence.
2. Use the Backspace key or the outer control knob to move the cursor.
3. Digits not yet entered display as underscores.
4. Tap **Enter** to activate the new code; tap **Cancel** to exit without changing the active code.
5. The active squawk code remains in use until a new code is entered.

**Special squawk codes — informational only; no preset buttons [p. 79]:**

| Code | Designation |
|------|-------------|
| 1200 | Default VFR code (USA) |
| 7500 | Hijacking |
| 7600 | Loss of communications |
| 7700 | Emergency |

The GNX 375 provides no dedicated preset buttons for 7500, 7600, or 7700; pilots enter these via the standard 0–7 keypad.

**AMAPI cross-refs:** `amapi_by_use_case.md` §3 (Button_add for keypad digit entry); §2 (Xpl_dataref_write for transponder_code on Enter; MSFS XPNDR_SET event — subject to OPEN QUESTION 5).

---

### 11.6 VFR Key and IDENT [p. 80]

**VFR Key.** Tapping the VFR Key once sets the squawk code to the preprogrammed VFR code (factory default 1200; may be changed at installation). No additional keypad entry is required.

**IDENT function.** Tapping the XPDR key while the XPDR Control Panel is active sends a Special Position Identification (SPI) signal to ATC for **18 seconds** [p. 80], distinguishing the transponder on the controller's radar display. The IDENT active state is visible on the annunciator and Data Field for the full 18-second period.

Tapping the XPDR key from **another page** (not the control panel) opens the control panel — it does not activate IDENT. IDENT is only triggered by tapping the XPDR key while already on the control panel.

**AMAPI cross-refs:** `amapi_by_use_case.md` §2 (command dispatch for IDENT activation, VFR code set); `amapi_patterns.md` Pattern 1 (triple-dispatch for XPDR actions: XPL IDENT command + MSFS XPNDR_IDENT_ON — exact names subject to OPEN QUESTION 4/5).

---

### 11.7 Transponder Status Indications [p. 81]

Four distinct visual states are displayed on the XPDR Control Panel [p. 81]:

| State | Reply Status | Code Status | IDENT Status | Tap XPDR Key Behavior |
|-------|-------------|-------------|--------------|----------------------|
| IDENT active — unmodified code | Active | Unmodified | Active (18-sec) | Initiates IDENT with unmodified code |
| IDENT with new squawk code | Active | Modified | Active | Accepts modified code and initiates IDENT |
| Standby | Inactive | Current code displayed | Inactive | — |
| Altitude Reporting | Active | Active code displayed | Accessible | Initiates IDENT with unmodified code |

The Reply (R) symbol is visible in the Active reply states (On and Altitude Reporting). Cross-ref §12.9 for how these states map to XPDR annunciator elements.

**AMAPI cross-refs:** `amapi_patterns.md` Pattern 17 (annunciator visible for each XPDR state); Pattern 2 (multi-variable bus for XPDR code + mode + reply + IDENT state).

---

### 11.8 Extended Squitter (ADS-B Out) [p. 77]

The GNX 375 transmits ADS-B Out via the integrated 1090 MHz Extended Squitter of the Mode S transponder — not a separate transmitter [p. 77].

**Toggle:** XPDR Setup Menu → ADS-B Out (ON/OFF). Available only if configured as pilot-controllable at installation. When ON, the display shows the ON state indicator.

**Transmitted content when ON:**
- GPS position (from the GNX 375's internal GPS receiver)
- Pressure altitude (from external ADC/ADAHRS — included only when in Altitude Reporting mode)
- Mode S squitter (identity + Extended Squitter payload including Target State and Status)

In Standby mode, ADS-B Out does not transmit even if the ADS-B Out toggle is ON. The ADS-B Out enable state is retained across power cycles (see §11.14).

**AMAPI cross-refs:** `amapi_by_use_case.md` §2 (command dispatch for ADS-B Out toggle); §1 (ADS-B Out state dataref — XPL: TBD; MSFS: `TRANSPONDER STATE` — subject to OPEN QUESTION 4/5).

---

### 11.9 Flight ID [pp. 76, 77, 82]

Flight ID is the aircraft identifier broadcast in the ADS-B Out Extended Squitter payload. On the GNX 375, Flight ID is typically configured at installation and is **not editable by the pilot by default** [p. 77]. If configured editable, Flight ID is alphanumeric, uppercase only, 8-character maximum.

The active Flight ID displays in the Data Field when the Data Field is set to Flight ID mode (via §11.3 XPDR Setup Menu). If not editable, the field retains the installer-set value. Remote Flight ID editability via G3X Touch is documented in §11.10 (v1 out-of-scope). Flight ID is retained across power cycles (see §11.14).

**AMAPI cross-refs:** `amapi_by_use_case.md` §11 (Persist_add for Flight ID if configurable); §7 (Txt_set for data field Flight ID display).

---

### 11.10 Remote Control via G3X Touch [p. 82]

A connected Garmin G3X Touch display can control transponder functions remotely [p. 82]. Remote control features:
- Squawk code
- Transponder mode
- IDENT activation
- ADS-B Out transmission enable
- Flight ID assignment

For operation of transponder remote control, the Pilot's Guide defers to the G3X Touch Pilot's Guide.

**v1 scope flag:** Remote XPDR control via G3X Touch is **not implemented in the v1 Air Manager instrument.** The real GNX 375 supports this capability; it is documented here for completeness. Confirm v1 exclusion remains appropriate at the design-phase review.

---

### 11.11 ADS-B In (Built-in Dual-link Receiver) [pp. 18, 225; cross-ref §4.9]

The GNX 375 incorporates a **built-in dual-link ADS-B In receiver** — no external hardware required [p. 225]:

- **1090 ES link (1090 MHz):** receives ADS-B Out transmissions from other aircraft for traffic display
- **UAT link (978 MHz):** receives FIS-B weather and NOTAM broadcasts; receives UAT-equipped traffic

This distinguishes the GNX 375 from GPS 175 and GNC 355/355A, which have no built-in ADS-B In and require an external GDL 88, GTX 345, or equivalent LRU for equivalent functionality.

The built-in receiver drives three functions (cross-ref §4.9 Fragment C for display behavior — authoritative for display-side detail; §11.11 authors receiver-side framing only):
- FIS-B Weather page
- Traffic Awareness page and TSAA alerting
- TSAA aural traffic alerts (GNX 375 only)

Receiver operational notes:
- **Operates in all three XPDR modes** (Standby, On, Altitude Reporting)
- **TIS-B participant status:** active only when in On or Altitude Reporting mode — NOT in Standby. (TIS-B re-broadcasts ATC radar targets over ADS-B; participant status means ownship is eligible to receive TIS-B uplinks.)
- For ADS-B Status settings-page workflow (uplink time, FIS-B WX Status sub-page, Traffic Application Status sub-page with AIRB/SURF/ATAS states): cross-ref §10.12 (Fragment E) — authoritative for that page's operational workflow.

**Simulator availability flag:** XPL provides partial ADS-B dataref exposure; MSFS has limited ADS-B traffic data. The Air Manager instrument must define behavior when ADS-B In data is absent or degraded (design-phase decision; see §15 Fragment G for the dataref contract and OPEN QUESTION 4 + OPEN QUESTION 5 for variable name verification).

**AMAPI cross-refs:** `amapi_by_use_case.md` §1 (dataref subscriptions for ADS-B In receiver status, FIS-B reception state); `amapi_patterns.md` Pattern 14 (parallel XPL + MSFS subscriptions for ADS-B In datarefs).

---

### 11.12 XPDR Failure / Alert [p. 82]

If the transponder fails [p. 82]:
- A **red "X"** displays over the IDENT key on the XPDR Control Panel
- Advisory messages are generated (cross-ref §11.13 for conditions; §13.9 for message-system context)
- The XPDR Control Panel is **not available** for input during a failure
- If a failure occurs while the control panel is the active page, the display **automatically returns to the previous page**

Specific condition noted on p. 82: "GNX 375 ADS-B interboard communication failure" — loss of communication between the ADS-B In receiver board and the main unit. For pilot response, consult the AFMS.

**AMAPI cross-refs:** `amapi_patterns.md` Pattern 17 (annunciator visible for failure "X" indicator); Pattern 6 (power-state group visibility for control panel availability on failure).

---

### 11.13 XPDR Advisory Messages [pp. 283–284, 290]

Nine distinct advisory conditions applicable to the GNX 375. §13.9 cross-references items 1–4; §13.11 cross-references items 5–9.

**From pp. 283–284 — XPDR/ADS-B Out conditions:**

| # | Advisory Text | Condition |
|---|--------------|-----------|
| 1 | "ADS-B Out fault. Pressure altitude source inoperative or connection lost." | Transponder loses communication with the external pressure altitude source |
| 2 | "Transponder has failed." | Internal failure: 1090 ES ADS-B Out failure, transponder failure, or communication with transponder lost |
| 3 | "Transponder is operating in ground test mode." | Transponder forced airborne for ground test; cycle GNX 375 power after test completes |
| 4 | "ADS-B is not transmitting position." | Transponder not receiving a valid GPS position from the internal GPS receiver |

**From p. 290 — GNX 375 Traffic/ADS-B In conditions:**

| # | Advisory Text | Condition |
|---|--------------|-----------|
| 5 | "1090ES traffic receiver fault." | Unit unable to receive 1090 Extended Squitter traffic |
| 6 | "ADS-B traffic alerting function inoperative." | TSAA application reports it is unavailable to run |
| 7 | "ADS-B traffic function inoperative." | ADS-B Traffic input failure (ADS-B/ADS-R/TIS-B input fault, electrical fault, or all traffic applications unavailable/faulted) |
| 8 | "Traffic/FIS-B functions inoperative." | ADS-B In configuration data fault (configuration parameters invalid) |
| 9 | "UAT traffic/FIS-B receiver fault." | Unit unable to receive UAT traffic and FIS-B data |

**Total: 9 advisory conditions** (items 1–4 from pp. 283–284 + items 5–9 from p. 290). The GPS 175/GNC 355 traffic advisory set (pp. 288–289), which references GDL 88 LRU failures, is NOT applicable to the GNX 375 and does not appear here.

**AMAPI cross-refs:** `amapi_by_use_case.md` §7 (Txt_add for advisory message text display); `amapi_patterns.md` Pattern 17 (MSG key flash state for pending advisories).

---

### 11.14 XPDR Persistent State [§14 cross-ref]

The following XPDR settings are retained across power cycles:
- **Squawk code** — active code at power-down restored on power-up
- **Mode setting** — Standby / On / Altitude Reporting
- **Flight ID** — installer-configured value (or pilot-set value if configurable)
- **ADS-B Out enable state** — ON/OFF retained
- **Data field preference** — Pressure Altitude vs. Flight ID display mode

For the persistence encoding schema used by the Air Manager instrument, cross-ref §14 (Fragment G).

**AMAPI cross-refs:** `amapi_by_use_case.md` §11 (Persist_add for squawk code, mode, Flight ID, ADS-B Out state, data field preference).

---

**Open questions / flags (§11 overall):**

- **OPEN QUESTION 4 (XPL XPDR dataref names):** XPL dataref names for XPDR code (`sim/cockpit2/radios/actuators/transponder_code`), mode (`transponder_mode`), reply state, IDENT command, and ADS-B Out state require verification against current XPL datareftool output during design phase. Forward-ref §15 (Fragment G).
- **OPEN QUESTION 5 (MSFS XPDR SimConnect variables):** `TRANSPONDER CODE:1`, `TRANSPONDER IDENT`, `TRANSPONDER STATE` names and behavior differences between FS2020 and FS2024 require design-phase research; Pattern 23 (FS2024 B: event dispatch) may apply. Forward-ref §15 (Fragment G).
- **§11.10 G3X Touch remote control:** v1 out-of-scope; confirm at design-phase review.
- **§11.11 simulator ADS-B In availability:** define degraded-mode behavior for absent or partial simulator ADS-B data at design phase.

**AMAPI notes for §11:** `amapi_by_use_case.md` §1 (XPDR code/mode/reply/ADS-B subscriptions), §2 (mode set, squawk entry, IDENT, ADS-B Out toggle, VFR code), §7 (squawk code display, data field, advisory text), §11 (Persist_add for XPDR persistent state); `amapi_patterns.md` Pattern 1 (triple-dispatch for XPDR button actions), Pattern 2 (multi-variable bus for XPDR status), Pattern 14 (parallel XPL + MSFS subscriptions), Pattern 16 (sound on state change for TSAA aural alerts), Pattern 17 (annunciator for XPDR state indicators), Pattern 23 (FS2024 B event dispatch — may apply to XPDR mode/code/IDENT).

---

## 12. Audio, Alerts, and Annunciators

The GNX 375 alert system generates three categories of annunciations (Warning, Caution, Advisory), presented via an annunciator bar at the bottom of the screen, pop-up windows for terrain/traffic threats, and aural voice messages. Most of §12 is unit-agnostic across the GPS 175/GNC 355/GNX 375 family; GNX 375-specific content: §12.4 Aural Alerts are present on the GNX 375 via the TSAA application; §12.9 XPDR Annunciations replaces COM Annunciations from the GNC 355 spec entirely.

---

### 12.1 Alert Type Hierarchy [p. 98]

Annunciations are grouped by urgency and required pilot response, displayed in priority order [p. 98]:

| Level | Display | Priority | Required Response |
|-------|---------|----------|-------------------|
| Warning | White text on red background | 1 (highest) | Immediate pilot action required |
| Caution | Black text on amber background | 2 | Timely pilot action; abnormal condition present |
| Advisory | Black/white text on white background | 3 (lowest) | Awareness; no immediate action required |

A warning may follow a caution if no corrective action is taken (e.g., continued path toward alerted terrain). System advisories display on a dedicated scrollable message list; function/mode-specific advisories appear in the annunciator bar.

---

### 12.2 Alert Annunciations (Annunciator Bar) [p. 99]

Alert annunciations are abbreviated messages in the **annunciator bar** along the bottom of the screen. Colors match alert level (§12.1). On alert trigger, the annunciation flashes by alternating text/background colors; turns solid after five seconds; remains solid until the condition is resolved [p. 99].

Annunciator bar slot assignments:
- **Alert/Inhibit/Test Mode slot:** warning, caution, and advisory annunciations
- **FROM/TO Advisories slot:** flight phase From/To waypoint advisory (p. 183); pilot's authoritative TO/FROM reference
- **Procedure Phase Advisories slot:** flight phase annunciation (OCEANS, ENRT, TERM, DPRT, LNAV+V, LPV, etc.) — cross-ref §7.2 (Fragment D) for the 11-row flight phase annunciation table; not re-tabulated here
- **Waypoint/Power-Off/COM Advisories slot:** waypoint advisories, power-off indicators, and CDI scale indicator — cross-ref §10.1 (Fragment E) for CDI On Screen operational workflow

Cross-ref §10.5 (Fragment E) for Alerts Settings page where pilots configure alert levels. Annunciator bar visibility by power and alert state: `amapi_patterns.md` Pattern 6 (power-state group visibility).

**AMAPI cross-refs:** `amapi_patterns.md` Pattern 17 (annunciator visible for active alerts), Pattern 6 (power-state group visibility for bar activation).

---

### 12.3 Pop-up Alerts [p. 100]

If a warning or caution relating to terrain or traffic occurs, a pop-up window displays — only if the alerted function's associated page is not already active [p. 100].

Each pop-up provides: threat indication; alert annunciation; option to inhibit or mute; control to close; and direct access to the associated page (Go to \<Page\> key). Pop-up priority: terrain alerts over simultaneous traffic alerts.

To acknowledge and return to the previous view, tap **Close**. To open the indicated page, tap **Go to \<Page\>**.

---

### 12.4 Aural Alerts [p. 101]

**Aural traffic alerts are present on the GNX 375** via the TSAA (Traffic Situational Awareness with Alerting) application [p. 101]. Traffic alerts are accompanied by an aural voice message; voice gender is configured at installation.

Key behavior:
- The **Mute Alert** function silences only the **current active aural alert** — it does not mute future alerts [p. 101].
- Advisory conditions that may trigger aural alerts: §13.11 (Traffic System Advisories) and §13.9 (XPDR Advisories).

**OPEN QUESTION 6 cross-reference:** The design-phase decision on the TSAA aural alert delivery mechanism (direct `sound_play` from the Air Manager instrument vs. dependency on an external audio panel) is preserved as OPEN QUESTION 6 in §4.9 (Fragment C). See §4.9 for the full open-question text and design options. Fragment F does not re-preserve the verbatim text; all aural delivery design is deferred to that cross-reference.

**AMAPI cross-refs:** `amapi_patterns.md` Pattern 16 (sound on state change — TSAA aural delivery); Pattern 17 (mute state indicator).

---

### 12.5 GPS Status Annunciations [pp. 104–106]

GPS status annunciates under the following conditions [p. 105]:

| Annunciation | Condition |
|--------------|-----------|
| Acquiring | GPS receiver using last known position and orbital data to determine visible satellites |
| 3D Nav | 3-D navigation mode; GPS receiver computes altitude from satellite data |
| 3D Diff Nav | 3-D navigation mode with SBAS differential corrections active |
| LOI | Satellite coverage insufficient to pass built-in integrity monitoring tests |
| GPS FAIL | GPS receiver hardware failure or WAAS board failure |

SBAS/WAAS provider selection is on the GPS Status page; available providers include WAAS (North America), EGNOS (Europe), MSAS (Japan), GAGAN (India). The LOI annunciation is the controlling indication for navigation integrity regardless of EPU/accuracy field values [p. 105].

Cross-ref §10.11 (Fragment E) for the full GPS Status operational page workflow (satellite sky view, position accuracy fields, SBAS Providers selection).

**AMAPI cross-refs:** `amapi_by_use_case.md` §1 (dataref subscribe for GPS fix type, SBAS state, integrity); `amapi_patterns.md` Pattern 17 (annunciator for GPS state).

---

### 12.6 GPS Alerts [p. 106]

Two GPS alert conditions can affect course guidance [p. 106]:

- **LOI (Loss of Integrity):** GPS integrity does not meet the requirements for the current flight phase. Yellow "LOI" annunciation. Occurs before the final approach fix when an approach is active.
- **GPS Fail (Loss of Navigation / Loss of Position):** multiple causes — insufficient satellites, erroneous position, on-board hardware failure, or inability to determine a GPS position solution. Annunciation is cause-specific; ownship icon is absent when no GPS position solution is available.

Cross-ref §13.5 for the advisory message text associated with these conditions.

---

### 12.7 Traffic Annunciations [p. 254]

Traffic annunciations are generated by TSAA and the ADS-B traffic display. For the full traffic annunciation table (threat levels, alert types, aural alert triggers), cross-ref §4.9 Traffic Awareness (Fragment C). The GNX 375 built-in dual-link receiver is the data source; display behavior is authoritative in Fragment C.

**AMAPI cross-refs:** `amapi_patterns.md` Pattern 17 (annunciator visible for traffic alert state).

---

### 12.8 Terrain Annunciations [pp. 268–269]

Terrain alert annunciations are generated by the terrain and obstacle awareness function. For the full terrain annunciation table (alert conditions, visual and aural triggers, inhibit function), cross-ref §4.9 Terrain Awareness (Fragment C). Terrain alerting is identical across all three units.

---

### 12.9 XPDR Annunciations (GNX 375 — replaces COM Annunciations)

This sub-section replaces the COM Annunciations sub-section from the GNC 355 spec. The GNX 375 has no VHF COM radio; all annunciation elements here are transponder-related.

XPDR annunciation elements on the XPDR Control Panel:

| Element | Description |
|---------|-------------|
| Squawk Code Display | Active 4-digit squawk code (0000–7777 octal); unentered digits shown as underscores |
| Mode Indicator | SBY (Standby) / ON (On) / ALT (Altitude Reporting) — **three modes only, per D-16** |
| Reply (R) Indicator | Transponder responding to ATC interrogations (On and Altitude Reporting modes) |
| IDENT Active Indicator | 18-second IDENT state active; visible in annunciator bar and Data Field |
| Failure Indicator | Red "X" over IDENT key when transponder fails (cross-ref §11.12) |

Cross-ref §11.7 for the full four-state status indication table with tap behaviors.

**AMAPI cross-refs:** `amapi_patterns.md` Pattern 17 (annunciator visible for each element state); Pattern 2 (multi-variable bus for squawk code + mode + reply + IDENT state).

---

**AMAPI notes for §12:** `amapi_by_use_case.md` §7 (Txt_add/Txt_set for annunciator bar text), §9 (Visible, Opacity, Move for alert element management); `amapi_patterns.md` Pattern 6 (power-state group visibility for annunciator bar), Pattern 16 (sound on state change for TSAA aural alerts), Pattern 17 (annunciator visible for all alert states and XPDR elements).

---

## 13. Messages

The advisory message system categorizes system-status advisories by function. Most recent advisories appear at the top of the queue; view-once advisories remain until acknowledged; the MSG key flashes when unread advisories are present. Two sub-sections are GNX 375-specific: §13.9 XPDR Advisories replaces COM Radio Advisories from the GNC 355 spec; §13.11 Traffic System Advisories is framed for the GNX 375 built-in receiver message set, distinct from the GPS 175/GNC 355 external-LRU advisory set.

---

### 13.1 Message System Overview [p. 272]

The advisory message system maintains a queue of system-related messages [p. 272]:

- **Most recent** advisories appear at the top of the list.
- **View-once** advisories remain in the queue until the pilot views them.
- **Persistent (conditional)** advisories remain active until the indicated condition is resolved.
- All advisories are logged internally; the log may be exported to an SD card.
- In dual-navigator installations, advisory messages are **not crossfilled** — each unit displays messages based on data it receives; view messages on both navigators.

**MSG key behavior:** displays at the left screen edge when an advisory is present. Flashes for a new (unread) advisory; turns solid once all active advisories are acknowledged; disappears after all active advisories are cleared.

---

### 13.2 Airspace Advisories [p. 273]

Airspace advisories are informational only; no pilot action is required. Alerted airspace types depend on Airspace Alerts settings [p. 273]:

| Advisory | Condition |
|----------|-----------|
| AIRSPACE ALERT - Inside airspace. | Aircraft is inside the alerted airspace |
| AIRSPACE ALERT - Airspace within 4 nm and entry in less than 10 minutes. | Airspace within 4 nm; projected entry < 10 min |
| AIRSPACE ALERT - Airspace entry in less than 10 minutes. | Projected entry in < 10 min (>4 nm away) |
| AIRSPACE ALERT - Within 4 nm of airspace. | Airspace < 4 nm; entry may not be projected |

Covered airspace classes: Class B, C, D, E; TFRs, MOAs, restricted areas.

---

### 13.3 Database Advisories [p. 274]

Database advisories indicate navigation or terrain database issues [p. 274]: database unavailable or corrupt; terrain display unavailable for current GPS position (outside coverage area); stored flight plan contains user-modified procedures or airways that conflict with the current navigation database; database update has modified or removed a waypoint from a stored flight plan.

---

### 13.4 Flight Plan Advisories [pp. 275–276]

Flight plan advisories relate to wireless FPL import and external display connectivity [pp. 275–276]:
- Flight plan import failure (unable to decode, catalog full, or wireless import not possible)
- New imported flight plans available for preview
- Stored flight plan waypoint no longer in current navigation database
- **GDU disconnected** — communication with connected G3X Touch display lost
- **External flight plan crossfill inoperative** — crossfill function with the G3X Touch unavailable

---

### 13.5 GPS/WAAS Advisories [pp. 277–278]

GPS/WAAS advisories indicate navigation solution issues [pp. 277–278]:
- GPS receiver has failed (internal communication to WAAS board inoperative)
- GPS Loss of Integrity — verify GPS position with other navigation equipment
- GPS navigation lost due to insufficient satellites or erroneous position
- GPS position lost (insufficient satellites > 5 seconds; no position solution)
- GPS searching sky (WAAS board acquiring position; can take longer after extended off-period)
- Low internal GPS clock battery; GPS receiver needs service

---

### 13.6 Navigation Advisories [pp. 279–280]

Navigation advisories relate to course reference and waypoint data [pp. 279–280]:
- **Set Course on CDI/HSI to \<current DTK\>:** selected CDI/HSI course does not match desired track
- **Holding EFC time has expired:** Expected Further Clearance time passed; consider contacting ATC
- True north / Magnetic north approach advisories when NAV angle setting and loaded approach reference do not match
- **Non-WGS84 Waypoint:** active waypoint references a non-WGS84 geodetic datum; navigation continues but pilot is notified

---

### 13.7 Pilot-Specified Advisories [p. 280]

Pilot-specified advisories display when the associated Scheduled Message timer expires or reaches a preset value. They are informational only; no pilot action is required. Cross-ref §10.8 (Fragment E) for the Scheduled Messages page workflow (create, modify, delete custom message timers).

---

### 13.8 System Hardware Advisories [pp. 281–285]

System Hardware advisories indicate unit hardware or configuration faults [pp. 281–285]:
- **\<Unit\> knob-push stuck:** dual concentric inner knob stuck; use touchscreen controls; contact dealer if persistent
- **\<Unit\> cooling fan failed / over temp / under temp:** temperature management faults; backlight may dim to reduce heat; contact dealer
- **Pilot stored data was lost:** error in stored data (map settings, user waypoints, catalogs, unit conventions); recheck settings
- **Remote Go Around key is stuck:** remote GA key depressed > 30 seconds
- **\<Unit\> needs service:** GNX 375 fault related to ADS-B/Nav communication, altitude encoder calibration, audio ROM, configuration module, non-volatile memory, or suppression bus; contact dealer
- **\<Unit\> SD card invalid or failed:** card unreadable or corrupt; reformat and re-insert or contact dealer
- **\<Name\> log encountered an error when exporting / exported successfully:** WAAS or traffic log export status (cross-ref §10.13 Fragment E for GNX 375-only ADS-B traffic log and WAAS diagnostic log)
- **Heading source inoperative or connection lost:** no heading data; heading-up map unavailable
- **Pressure altitude source inoperative or connection lost:** no pressure altitude from any source (also generates §11.13 item 1 / §13.9 item 1 XPDR advisory)
- **Crossfill is inoperative / turned off / LRU Software mismatch:** crossfill configuration issues

**GNX 375-specific [p. 102]:** The System Status page includes a **Transponder software version** field visible only on the GNX 375 (GPS 175 and GNC 355/355A do not show this field). Relevant for service contact and firmware verification.

Cross-ref §13.9 for XPDR advisory conditions; §13.11 for GNX 375 ADS-B In receiver fault advisories.

---

### 13.9 XPDR Advisories (GNX 375 — replaces COM Radio Advisories) [pp. 283–284]

This sub-section replaces the COM Radio Advisories sub-section from the GNC 355 spec. The GNX 375 has no VHF COM radio; all advisories here are transponder and ADS-B Out related.

Four XPDR/ADS-B Out advisory conditions applicable to the GNX 375, sourced from pp. 283–284. For full advisory text and condition descriptions, cross-ref §11.13 items 1–4:

1. ADS-B Out fault — pressure altitude source inoperative or connection lost (§11.13 item 1)
2. Transponder has failed (§11.13 item 2)
3. Transponder is operating in ground test mode (§11.13 item 3)
4. ADS-B is not transmitting position (§11.13 item 4)

These four conditions are the complete XPDR/ADS-B Out advisory set applicable to the GNX 375 from pp. 283–284.

---

### 13.10 Terrain Advisories [p. 287]

| Advisory | Condition | Corrective Action |
|----------|-----------|------------------|
| Terrain alerts are inhibited. Re-enable alerts in the Terrain menu. | Pilot enabled the terrain alert inhibit function | Open Terrain menu and deselect Terrain Inhibit |

---

### 13.11 Traffic System Advisories (GNX 375 — built-in receiver message set) [p. 290]

The GNX 375 traffic system advisory set references the **built-in 1090 ES and UAT receivers** — no external LRU (GDL 88, GTX 345) is involved. Five advisory conditions, sourced from p. 290. For full advisory text and condition details, cross-ref §11.13 items 5–9:

| # | Advisory Text | §11.13 Ref |
|---|--------------|------------|
| 5 | "1090ES traffic receiver fault." | Item 5 |
| 6 | "ADS-B traffic alerting function inoperative." | Item 6 |
| 7 | "ADS-B traffic function inoperative." | Item 7 |
| 8 | "Traffic/FIS-B functions inoperative." | Item 8 |
| 9 | "UAT traffic/FIS-B receiver fault." | Item 9 |

**Distinction from sibling-unit traffic advisories:** The GPS 175/GNC 355 traffic advisory set (pp. 288–289) references GDL 88 LRU-specific failures (GDL 88 configuration module fault, GDL 88 communication loss, GDL 88 needs service, etc.). Those messages are **NOT applicable to the GNX 375** — the GNX 375 uses no external ADS-B LRU and has no GDL 88 failure modes. Implementors must not apply the pp. 288–289 message set to the GNX 375 instrument.

---

### 13.12 VCALC Advisories [p. 291]

| Advisory | Condition |
|----------|-----------|
| Approaching top of descent. | Aircraft within 60 seconds of the calculated top of descent |
| Arriving at VCALC target altitude. | Aircraft approaching the VCALC target altitude |

---

### 13.13 Waypoint Advisories [p. 291]

Waypoint advisories relate to user waypoint import operations [p. 291]:
- User waypoint import failed — improper file format or waypoint catalog full
- User waypoints imported successfully
- User waypoints imported successfully — existing waypoints reused (duplicate avoidance)

---

**AMAPI notes for §13:** `amapi_by_use_case.md` §7 (Txt_add/Txt_set for message queue display and advisory text rendering); `amapi_patterns.md` Pattern 17 (MSG key flash state for pending advisories); note B4 Gap 2 for scrollable advisory list implementation (no established AMAPI pattern precedent).

---

## 14. Persistent State

The GNX 375 retains several categories of state across power cycles using the Air Manager persist store (Persist_add, Persist_get, Persist_put). §14.1 replaces the GNC 355's COM State category with XPDR State, reflecting the GNX 375's transponder role and the absence of a VHF COM radio. All remaining persistent state categories — display/UI, flight planning, scheduled messages, Bluetooth pairing, and crossfill — are functionally analogous to GPS-navigator persistent state and are shared across GPS 175, GNC 355, and GNX 375 with the exceptions noted per section. Operational cross-ref for XPDR persistent state: see §11.14 (Fragment F), which authored the §14 forward-ref.

---

### 14.1 XPDR State (GNX 375 — replaces COM State) [pp. 75–82]

The following XPDR settings survive power-off and are restored on the next power-up. This list replaces the COM State enumeration that §14.1 contains in the GNC 355 equivalent, consistent with D-16's framing that the GNX 375 has three XPDR modes and no COM radio.

| Persistent Item | Behavior at Power-On | Notes |
|----------------|----------------------|-------|
| **Squawk code** | Restored to last-set 4-digit octal code | Retains last ATC-assigned or pilot-entered code [p. 75] |
| **XPDR mode** | Restored to last-set mode | Three modes only per D-16: Standby / On / Altitude Reporting [p. 78]; no Ground, Test, or Anonymous modes |
| **Flight ID** | Restored to installer-configured or pilot-set value | Pilot-editable only if enabled at installation [pp. 77, 85] |
| **ADS-B Out enable state** | Restored to ON or OFF | Toggled via XPDR Setup Menu |
| **Data field preference** | Restored to Pressure Altitude or Flight ID | Controls what appears in the XPDR data field [p. 75] |

No COM state persists on the GNX 375; the unit has no VHF COM radio. §14.1 is the canonical persistent state specification that §11.14 (Fragment F) forward-referenced.

> **Open question — Flight plan catalog serialization:** Air Manager persist API is scalar (key-value string pairs). The FPL catalog (§14.3) requires a defined encoding scheme (e.g., JSON string per flight plan, or multiple keys per waypoint). This is a design-phase decision; see §14.3 for additional context.

---

### 14.2 Display and UI State [pp. 58, 89]

The unit retains the following display and interface preferences across power cycles:

- **Display brightness** — manual offset setting retained [p. 58 context: "the unit retains settings over power cycles"]
- **Unit selections** — distance, speed, altitude, VSI, nav angle, wind, pressure, temperature; all retained [see §10.6, Fragment E]
- **Page shortcuts** — locator bar slots 2–3 retain pilot-assigned page assignments
- **CDI scale setting** — en route / terminal / approach angular scale selection retained [see §10.1, Fragment E]
- **CDI On Screen toggle** — enabled/disabled state retained; GNX 375 + GPS 175 only [p. 89]; see §4.10 (Fragment C)
- **Runway criteria** — runway length and surface type filter settings retained [see §10.5, Fragment E]

---

### 14.3 Flight Planning State

The GNX 375 preserves the full flight planning data corpus across power cycles:

- **Flight plan catalog** — all stored flight plans retained; encoding scheme is a design-phase decision (Air Manager persist API is scalar; encoding required for multi-waypoint structures)
- **User waypoints** — up to 1,000 user-defined waypoints retained [p. 156 context; see §9.4, Fragment E]
- **Active flight plan** — the active FPL at power-down is restored at power-up
- **Active direct-to** — behavior is device-specific; design-phase device testing required to confirm whether an in-progress direct-to survives power cycle

> **Open question — Active direct-to persistence:** The Pilot's Guide does not explicitly document whether an active direct-to is retained across a power cycle. Verify at design phase to determine whether the instrument must restore or discard an in-flight direct-to on power-up.

---

### 14.4 Scheduled Messages [p. 97 context]

Message definitions configured in the Scheduled Messages app — including trigger conditions, message text, and acknowledgment rules — are retained across power cycles. Trigger states (whether a message has been acknowledged in the current session) may reset on power-up; each new session begins with all scheduled messages in the pending/unacknowledged state. See §10.8 (Fragment E) for the Scheduled Messages configuration workflow.

---

### 14.5 Bluetooth Pairing [pp. 175–176 context]

The GNX 375 retains up to 13 paired Bluetooth device records and their associated auto-connect preferences. Each device entry persists: device name, pairing status, and auto-connect flag. Devices not in range at power-up remain in the pairing list and reconnect automatically when they come into range if auto-connect is enabled. See §10.10 (Fragment E) for the Bluetooth setup workflow and Connext data-service context.

---

### 14.6 Crossfill Data [p. 97]

The crossfill on/off setting is retained across power cycles. When crossfill is enabled and the dual-navigator wiring requirement is met (requires a compatible Garmin partner unit), the setting is applied at power-on without pilot intervention. Cross-ref §10.9 (Fragment E) for Crossfill configuration details.

---

**AMAPI notes for §14.** Use-case §11 in `amapi_by_use_case.md` covers Persist_add, Persist_get, and Persist_put — the three primitives for all §14 persistent state items. Pattern 11 in `amapi_patterns.md` (persist dial angle/state across sessions) is the primary authoring pattern; apply to XPDR mode, squawk code, CDI scale, unit selections, and all boolean toggle states. Catalog persistence (§14.3) requires a serialization wrapper around the scalar persist API; this is an open design-phase decision.

---

## 15. External I/O (Datarefs and Commands)

This section specifies the data exchange surfaces between the GNX 375 Air Manager instrument and the host simulator — X-Plane 12 (XPL, primary per D-01) and MSFS (secondary). §15 specifies interface names, types, and contracts; it does not re-author the pilot-facing XPDR behaviors specified in §11 (Fragment F) — cross-ref §11 for behavioral semantics. COM-specific datarefs and events from the GNC 355 §15 equivalent are dropped; XPDR and ADS-B datarefs/events are added per D-16. The external CDI/VDI output contract is per D-15 (no on-screen VDI on GNX 375). The altitude source dependency is per D-16 (external ADC/ADAHRS only).

---

### 15.1 XPL Datarefs — Reads

Subscriptions established at instrument load; updated continuously at the dataref's native refresh rate. XPDR-related entries are provisional — marked [OQ4].

| Dataref (candidate name) | Type | Purpose | Notes |
|--------------------------|------|---------|-------|
| `sim/flightmodel/position/latitude` | float | GPS latitude (deg) | Primary navigation |
| `sim/flightmodel/position/longitude` | float | GPS longitude (deg) | Primary navigation |
| `sim/flightmodel/position/elevation` | float | GPS altitude MSL (m) | Navigation display |
| `sim/cockpit2/radios/actuators/transponder_code` | int | XPDR squawk code (octal) | [OQ4 — verify name] |
| `sim/cockpit2/radios/actuators/transponder_mode` | int | XPDR mode 0–3 | [OQ4 — verify; mode mapping: 0=Standby, 1=On, 2=Alt Rpt] |
| TBD — transponder reply state | int | Active interrogation/reply flag | [OQ4 — verify name in datareftool] |
| TBD — ADS-B Out enable state | int | ADS-B Out on/off | [OQ4 — verify name] |
| TBD — pressure altitude (external ADC) | float | Pressure altitude for XPDR | [OQ4 — sourced from external ADC/ADAHRS; verify dataref name] |
| `sim/cockpit2/electrical/avionics_on` | int | Avionics master switch | Power-state gating |
| `sim/flightmodel/position/mag_psi` | float | Magnetic heading (deg) | Navigation display |
| `sim/flightmodel/position/groundspeed` | float | Ground speed (m/s) | Navigation display |
| `sim/flightmodel/position/hpath` | float | True track (deg) | Navigation display |
| TBD — cross-track deviation | float | XTK (nm) | CDI display |
| TBD — CDI source (GPS vs. VLOC) | int | Active CDI source select | CDI/HSI routing |
| TBD — TO/FROM flag | int | Course TO (1) vs. FROM (0) | Annunciator bar; external CDI |
| TBD — GPS flight phase | int | ENRT/TERM/LNAV/LPV/etc. | Annunciator bar |
| TBD — active waypoint identifier | string | Next waypoint ID | GPS NAV Status key |
| TBD — CDI lateral deviation | float | Lateral deviation (dots or nm) | On-screen CDI; external CDI output (§15.6) |

---

### 15.2 XPL Datarefs — Writes

Written by the instrument on confirmed pilot input; reflected into the simulator's transponder model.

| Dataref (candidate name) | Type | Trigger | Notes |
|--------------------------|------|---------|-------|
| `sim/cockpit2/radios/actuators/transponder_code` | int | Pilot squawk entry confirmed via keypad Enter | [OQ4 — verify name] |
| `sim/cockpit2/radios/actuators/transponder_mode` | int | Pilot mode selection (Standby / On / Altitude Reporting) | [OQ4 — verify name; only three valid values] |
| TBD — ADS-B Out enable | int | Pilot toggle via XPDR Setup Menu | [OQ4 — verify name] |

---

### 15.3 XPL Commands

Commands dispatched by the instrument to the simulator; no return value. All XPDR commands are provisional [OQ4].

| Command (candidate) | Trigger | Notes |
|--------------------|---------|-------|
| TBD — XPDR IDENT command | Pilot tap of XPDR key (control panel active) | 18-second IDENT pulse [p. 80]; [OQ4] |
| TBD — XPDR mode cycle | Mode key tap for sequential mode advance | [OQ4] |
| TBD — XPDR discrete mode set | Pilot selects specific mode from menu | [OQ4] |
| TBD — Direct-to activate | Pilot confirms Direct-to from waypoint | Cross-ref §6 (Fragment D) |
| TBD — approach activation | Pilot taps Activate on Procedures page | Cross-ref §7 (Fragment D) |
| TBD — missed approach | Pilot initiates missed approach | Cross-ref §7 (Fragment D) |

> **OPEN QUESTION 4 (XPL XPDR dataref names):** XPL dataref names for XPDR code (`sim/cockpit2/radios/actuators/transponder_code`), mode (`sim/cockpit2/radios/actuators/transponder_mode`), reply state, ADS-B Out enable state, and external pressure altitude source require verification against current XPL datareftool output during design phase. These candidate names are provisional. All entries marked [OQ4] in §§15.1–15.3 must be resolved against the XPL datareftool before implementation. Forward-flag for D1 Design Spec resolution.

---

### 15.4 MSFS Variables — Reads

Subscribed via `Msfs_variable_subscribe` (MSFS secondary path per D-01). Variable names and encoding differ materially from XPL equivalents; parallel-subscription pattern per `amapi_patterns.md` Pattern 14 is required.

| MSFS Variable | Type | Purpose | Notes |
|---------------|------|---------|-------|
| `TRANSPONDER CODE:1` | int (octal) | Squawk code | [OQ5 — verify units and encoding; octal interpretation] |
| `TRANSPONDER STATE` | int | XPDR mode state | [OQ5 — verify integer meanings; typical: 0=Off, 1=Standby, 2=On, 3=Alt Rpt] |
| `TRANSPONDER IDENT` | bool | IDENT active | [OQ5 — verify availability in FS2020 and FS2024] |
| `GPS POSITION LAT` / `GPS POSITION LON` / `GPS ALTITUDE` | float | GPS position and altitude | Primary navigation |
| `GPS GROUND SPEED` | float | Ground speed (knots) | Navigation display |
| `GPS GROUND MAGNETIC TRACK` | float | Magnetic track (deg) | Navigation display |
| `AVIONICS MASTER SWITCH` | bool | Avionics power state | Power-state gating |

---

### 15.5 MSFS Events — Writes

Events dispatched to the MSFS simulator model on confirmed pilot input.

| Event | Trigger | Notes |
|-------|---------|-------|
| `XPNDR_SET` | Pilot squawk code entry confirmed | Sets squawk code (value in octal) |
| `XPNDR_IDENT_ON` | Pilot IDENT tap | Activates 18-second IDENT |
| `XPNDR_STATE_SET` or equivalent | Pilot mode selection | Sets XPDR mode integer |
| FS2024 B equivalents (TBD) | Per Pattern 23 | [OQ5 — FS2024 may require different event names or parameter encoding] |

> **OPEN QUESTION 5 (MSFS XPDR SimConnect variables):** `TRANSPONDER CODE:1`, `TRANSPONDER STATE`, and `TRANSPONDER IDENT` variable names and behavioral differences between FS2020 and FS2024 require design-phase research. FS2024 introduced breaking changes in several SimConnect variable names and event formats; `amapi_patterns.md` Pattern 23 (FS2024 B: event dispatch) may apply to XPDR mode and code set operations. All entries marked [OQ5] in §§15.4–15.5 must be verified against both FS2020 and FS2024 SDK references during design phase. Forward-flag for D1 Design Spec resolution.

---

### 15.6 External CDI/VDI Output Contract [D-15]

The GNX 375 drives external navigation instruments via an output contract specified here per D-15. **The GNX 375 has no on-screen VDI of any kind.** All vertical deviation output is external-only, routed to a connected VDI or CDI instrument [Pilot's Guide p. 205: "Only external CDI/VDI displays provide vertical deviation indications"]. The on-375 display provides flight phase annunciations on the annunciator bar (LNAV+V, LP+V, LPV, etc.) but no glidepath needle, glideslope needle, or vertical deviation scale.

| Output | Target Instrument Class | Purpose | Notes |
|--------|------------------------|---------|-------|
| Lateral deviation value | External CDI/HSI | Deviation needle deflection | Scale varies by CDI scale mode (en route / terminal / approach angular) |
| Course angle (DTK) | External CDI/HSI OBS | Desired track for course centering | Updates continuously during navigation |
| CDI scale mode | External CDI/HSI | En route → Terminal → Approach angular | Auto-transitions at flight phase changes |
| TO/FROM flag | External CDI flag indicator | Determines needle sense | Annunciator bar FROM/TO field is pilot's primary reference [p. 183] |
| GPSS roll steering | Compatible autopilots (KAP 140, KFC 225) | Roll-steering command for autopilot coupling | Enabled when GPSS or APR Output configured [pp. 183, 207] |
| **Vertical deviation** | **External VDI** | **Glidepath deviation for LPV, LP+V, LNAV+V approaches** | **D-15: no on-screen VDI — external VDI only** |
| Glidepath capture | Autopilot (APR coupling) | LPV glidepath arm/capture signal | Feeds KAP 140 / KFC 225 GS input [p. 207] |

> **Design-phase flag — CDI/VDI output dataref names:** XPL dataref names for lateral deviation output to external CDI (candidate: `sim/cockpit/radios/nav1_hdef_dots` or a GPS-specific dataref) require design-phase research. XPL likely exposes GPS glidepath deviation for vertical deviation output; exact name requires verification. Both must be resolved before §15.6 is implementation-ready. MSFS equivalents have no established candidates; require SimConnect research.

---

### 15.7 Altitude Source Dependency [p. 34, D-16]

The GNX 375 transponder requires an **external altitude source** for pressure altitude reporting and ADS-B Out altitude encoding. The GNX 375 does not compute pressure altitude internally. Supported external sources: Air Data Computer (ADC — e.g., Garmin GDC 74), Air Data / Attitude & Heading Reference System (ADAHRS), or a standalone altitude encoder (p. 34, D-16).

Behavioral implications for simulation:

- The XPDR data field displays pressure altitude **only when the external altitude dataref is subscribed and reporting valid data**
- When the external altitude source is absent or invalid, the XPDR data field falls back to Flight ID display (if configured) or a fault state
- The advisory **"ADS-B Out fault. Pressure altitude source inoperative or connection lost."** triggers when the external altitude source is lost — cross-ref §11.13 item 1 (Fragment F) and §13.9 (Fragment F)
- ADS-B Out continues to transmit when altitude source is absent but without pressure altitude in the Extended Squitter payload, which may trigger an ATC advisory to the pilot

The XPL pressure altitude dataref subscription for this source is included in §15.1 (TBD — pressure altitude, external ADC, marked [OQ4]).

---

**AMAPI notes for §15.** Use-case §1 in `amapi_by_use_case.md` (Xpl_dataref_subscribe, Msfs_variable_subscribe) is the primary subscription mechanism for §§15.1 and §15.4. Use-case §2 (Xpl_command, Msfs_event) covers write-back for §§15.2, §15.3, and §15.5. Pattern 1 (`amapi_patterns.md` — triple-dispatch) applies to all XPDR write operations: one pilot action dispatches to XPL dataref write, MSFS event, and local state update simultaneously. Pattern 14 (parallel XPL + MSFS subscriptions) is essential for XPDR datarefs, which differ substantially between simulators. Pattern 23 (FS2024 B: event dispatch) applies to MSFS XPDR writes on FS2024.

---

## Appendix A: Family Delta — GNX 375 as Baseline

This appendix provides a compact functional comparison of the GNX 375 against sibling units covered in Pilot's Guide 190-02488-01 Rev. C. The GNX 375 is the baseline per D-12; differences are framed as what GPS 175 and GNC 355/355A lack versus the GNX 375 baseline, and what GNC 355/355A adds that the GNX 375 does not have. The shelved GNC 355 outline (`docs/specs/GNC355_Functional_Spec_V1_outline.md`) preserves a 355-baseline version of this appendix for eventual GNC 355 implementation.

---

### A.1 Unit Identification and D-12 Context

Pilot's Guide 190-02488-01 Rev. C covers three GPS navigator families:

- **GPS 175** — GPS/MFD only; TSO-C146e compliant; no COM radio, no transponder, no ADS-B
- **GNC 355 / GNC 355A** — GPS/MFD + VHF COM radio; no transponder or ADS-B; 355A adds 8.33 kHz channel spacing for European operations
- **GNX 375** — GPS/MFD + Mode S transponder (TSO-C112e, Level 2els, Class 1) + dual-link ADS-B In (1090 ES + UAT) + ADS-B Out (1090 ES, TSO-C166b); no COM radio

**GNX 375 is the primary instrument for this project per D-12** (pivot from GNC 355 to GNX 375; rationale: the GNX 375 is in the more-frequently-flown aircraft, and has a materially different capability set centered on transponder and ADS-B operation). The D-02 reference to "GNC 375" was a nomenclature error resolved by D-12: the correct product designation is **GNX 375** ("X" denotes transponder/ADS-B extensions).

GNC 355 implementation is **deferred** per D-12. The shelved GNC 355 outline preserves the 355-baseline version of this spec for eventual resumption, including a 355-baseline Appendix A in which GNC 355 is primary and GNX 375 is the variant. No further GNC 355 spec work is in-scope for the current workstream.

---

### A.2 GPS 175 vs. GNX 375 — GPS 175 Lacks

The GPS 175 is functionally identical to the GNX 375 in all GPS/MFD navigation capabilities. The GPS 175 lacks the following GNX 375-exclusive features:

| Feature | GPS 175 | GNX 375 | Source |
|---------|---------|---------|--------|
| Mode S transponder (entire §11) | — | ✓ | pp. 75–82 |
| ADS-B Out (Extended Squitter, 1090 ES, TSO-C166b) | — | ✓ | pp. 18–20 |
| Built-in dual-link ADS-B In (1090 ES + UAT) | External GDL 88 / GTX 345 required | Built-in | pp. 18–20 |
| TSAA traffic alerting with aural alerts | — | ✓ | pp. 18–20 |
| ADS-B traffic logging | — | ✓ | §10.13 (Fragment E) |

**GPS 175 is identical to GNX 375 for:**
- All GPS/MFD navigation (map, FPL, Direct-to, Procedures, Nearest, Waypoints, Planning pages, Terrain/TAWS)
- **CDI On Screen** — GPS 175 + GNX 375 only [p. 89]; not available on GNC 355/355A
- **GPS NAV Status indicator key** — GPS 175 + GNX 375 only [p. 158]; not available on GNC 355/355A
- **Knob push = Direct-to** — GPS 175 + GNX 375 pattern; GNC 355 uses knob push for standby-frequency tuning
- FIS-B weather — GPS 175 requires external GDL 88/GTX 345 for FIS-B reception; display behavior is otherwise identical to GNX 375 built-in

---

### A.3 GNC 355/355A vs. GNX 375

The GNC 355/355A and GNX 375 share all GPS/MFD navigation capabilities but diverge on radio and transponder features.

**GNC 355/355A lacks (vs. GNX 375 baseline):**

| Feature | GNC 355/355A | GNX 375 | Source |
|---------|-------------|---------|--------|
| Mode S transponder (§11) | — | ✓ | pp. 75–82 |
| ADS-B Out (1090 ES) | — | ✓ | pp. 18–20 |
| Built-in ADS-B In (dual-link) | External hardware required | Built-in | pp. 18–20 |
| TSAA traffic alerting with aural alerts | — | ✓ | pp. 18–20 |
| ADS-B traffic logging | — | ✓ | §10.13 (Fragment E) |
| CDI On Screen | — | ✓ | p. 89 |
| GPS NAV Status indicator key | — | ✓ | p. 158 |

**GNC 355/355A adds (features NOT present on GNX 375):**

| Feature | GNC 355/355A | GNX 375 | Source |
|---------|-------------|---------|--------|
| **VHF COM radio** (entire §11 COM radio operation) | ✓ | — | pp. 55–74 |
| COM Standby Control Panel (§4.11) | ✓ | — | — |
| 25 kHz channel spacing (355); 8.33 kHz also (355A) | ✓ | — | p. 60 |
| COM volume and sidetone offset | ✓ | — | pp. 58–63 |
| COM monitor mode | ✓ | — | pp. 60–63 |
| Reverse frequency lookup (RFL) | ✓ | — | pp. 60–63 |
| User COM frequencies (up to 15) | ✓ | — | p. 72 |
| COM alerts | ✓ | — | — |
| **Flight Plan User Field** on FPL page | ✓ | — | p. 155 |
| Direct-to via standby-frequency-tune (knob push) | ✓ | — | — |

**Identical on both units:**
- All GPS/MFD navigation features (map, FPL, Direct-to, Procedures, Nearest, Waypoints, Planning pages, Terrain/TAWS)
- FIS-B weather (GNC 355 requires external receiver; GNX 375 built-in; display page behavior identical)
- Traffic display (GNC 355 requires external hardware, no TSAA aural alerts; GNX 375 built-in with TSAA aural; display layout analogous, alert capability differs)
- Bluetooth / Connext data service
- Database Concierge

---

### A.4 GNX 375 Variants

No GNX 375A variant or equivalent is documented in Pilot's Guide 190-02488-01 Rev. C. The GPS 175 and GNC 355 families include "A" variants (GPS 175A; GNC 355A with 8.33 kHz channel spacing); no corresponding variant is documented for the GNX 375 in the current Pilot's Guide revision.

> **Placeholder:** If Garmin releases a GNX 375 variant (e.g., a hypothetical GNX 375A), this section will enumerate its feature differences from the GNX 375 baseline. No action required until a variant is documented in an updated Pilot's Guide.

---

### A.5 Feature Matrix — All Units [pp. 18–20]

Tri-unit comparison across all primary feature categories. **✓** = supported natively; **ext** = requires external hardware (GDL 88, GTX 345, or equivalent); **—** = not available.

| Feature Category | GPS 175 | GNC 355/355A | GNX 375 |
|-----------------|---------|-------------|---------|
| GPS/WAAS navigation (LNAV, LPV, LP, LNAV+V, LP+V) | ✓ | ✓ | ✓ |
| Moving Map | ✓ | ✓ | ✓ |
| Flight Plan (FPL) management | ✓ | ✓ | ✓ |
| Direct-to Operation | ✓ | ✓ | ✓ |
| Procedures (SID / STAR / Approach) | ✓ | ✓ | ✓ |
| Nearest Functions | ✓ | ✓ | ✓ |
| Waypoint Information | ✓ | ✓ | ✓ |
| Planning Pages (VCALC / Fuel / DALT / TAS / RAIM) | ✓ | ✓ | ✓ |
| FIS-B Weather | ext | ext | ✓ |
| Traffic Display | ext | ext | ✓ |
| TSAA Aural Traffic Alerts | — | — | ✓ |
| Terrain / TAWS (FLTA, PDA) | ✓ | ✓ | ✓ |
| Bluetooth / Connext | ✓ | ✓ | ✓ |
| Database Concierge | ✓ | ✓ | ✓ |
| Mode S XPDR + ADS-B Out | — | — | ✓ |
| CDI On Screen | ✓ | — | ✓ |
| GPS NAV Status indicator key | ✓ | — | ✓ |
| VHF COM Radio | — | ✓ | — |
| ADS-B Traffic Logging | — | — | ✓ |

*Source: Pilot's Guide pp. 18–20 and distributed "AVAILABLE WITH" annotations throughout the manual (e.g., p. 89 CDI On Screen, p. 158 GPS NAV Status key, p. 155 Flight Plan User Field). "ext" = requires external GDL 88, GTX 345, or compatible receiver.*

---

**AMAPI notes for Appendix A.** Appendix A is descriptive and comparative; no AMAPI patterns are directly triggered by its content. The feature matrix confirms that XPDR + ADS-B (§11), CDI On Screen (§4.10/§10.1), GPS NAV Status key (§4.3), and ADS-B traffic logging (§10.13) are GNX 375-exclusive or GPS 175 + GNX 375 shared features — not available on GNC 355. When implementing the GNX 375 Air Manager instrument, these distinctions confirm which sub-sections are GNX 375 exclusive and must not be conditionally compiled for other unit types.
