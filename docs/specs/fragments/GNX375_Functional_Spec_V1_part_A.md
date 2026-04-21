---
Created: 2026-04-21T15:30:00-04:00
Source: docs/tasks/c22_a_prompt.md
Fragment: A
Covers: §§1–3 + Appendix B + Appendix C
---

# GNX 375 Functional Spec V1 — Fragment A

This is Fragment A of 7 piecewise fragments per D-18. It covers the foundational sections
(§§1–3) and the cross-reference scaffolding appendices (Appendix B Glossary, Appendix C
Extraction Gaps) required by all subsequent fragments.

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
| **p. 125** | **Sparse** | **Land data symbols — image-only; text labels extracted but symbols absent. Supplement: `assets/gnc355_reference/land-data-symbols.png`. See §4.2 (C2.2-B).** |
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

**Significant content gap:** p. 125 land data symbols — supplement available (see C.1).

**Resolved gap (not active):** GNC 375 / GNX 375 disambiguation — resolved per D-12; GNX 375
is the correct designation.

---

### C.3 Summary

| Category | Count |
|---------|-------|
| Significant content gaps | 1 (land data symbols — supplement available) |
| Design decision gaps | 4 |
| Open research questions | 6 |
| Blank / filler pages (no functional gap) | 10 of 13 flagged pages |
| Empty pages | 1 (p. 309) |
| OCR-applied pages | 0 (Tesseract unavailable during extraction) |

---

## Coupling Summary

This section is authored per D-18 for CD/CC coordination. It is not part of the spec body
and is stripped on assembly.

### Backward cross-references

None. Fragment A is the first piece.

### Forward cross-references

- §1.3 no-internal-VDI constraint → §7 (Procedures, C2.2-D) and §15.6 (external CDI/VDI
  output contract, C2.2-G) per D-15.
- §1.4 "See Appendix A" → Appendix A authored in Fragment G (C2.2-G).
- §2.5, §2.7 inner knob push = Direct-to → §6 Direct-to Operation in Fragment D (C2.2-D).
- §3.5 Database SYNC / crossfill compatibility → §10.9 Crossfill in Fragment E (C2.2-E).
- Appendix B glossary terms (Mode S, 1090 ES, UAT, TSAA, FIS-B, TIS-B, IDENT, squawk
  code, WOW, etc.) referenced by all Fragments B–G; authored here to avoid forward-refs.

### Outline coupling footprint

This fragment draws from outline §§1, 2, 3, Appendix B, and Appendix C. No content from
§§4–15 or Appendix A is authored here.
