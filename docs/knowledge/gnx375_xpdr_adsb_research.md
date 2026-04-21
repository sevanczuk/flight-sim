# GNX 375 XPDR + ADS-B Research Findings

**Created:** 2026-04-21T11:33:00-04:00
**Source:** Purple Turn 21 — research task executing option (a) from Turn 20, authoritative deep-dive of Pilot's Guide XPDR content (pp. 75–85) and related ADS-B material before drafting the C2.1-375 task prompt
**Method:** Python against `assets/gnc355_pdf_extracted/text_by_page.json`. All 310 pages keyword-scanned for 30+ XPDR/ADS-B terms; pp. 18, 19, 20, 34, 37, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 102, 225, 244, 248, 282, 283, 284, 288, 289, 290 read in full.
**Purpose:** Authoritative reference for drafting the new §11 (XPDR + ADS-B Operation) section of the GNX 375 outline. Corrects the assumptions in the Turn 18 harvest map's preliminary §11 structure.

---

## Executive Summary

The GNX 375's XPDR/ADS-B is simpler and more tightly scoped than my Turn 18 harvest map anticipated. Specifically:

- **Three XPDR modes only** (Standby, On, Altitude Reporting) — no Ground or Test mode in the pilot-facing UI
- **No WOW-based auto-transitions documented** in the Pilot's Guide — mode selection is entirely pilot-initiated
- **No Anonymous mode on GNX 375** — that's GPS 175 / GNC 355 + GDL 88 territory
- **Flight ID is usually not editable** — factory/installer configured; only editable if configured to be so
- **IDENT duration is 18 seconds** (not unspecified)
- **ADS-B Out is 1090 MHz Extended Squitter** from the Mode S transponder — not a separate transmitter
- **ADS-B In is dual-link built-in** (1090 ES for traffic + 978 MHz UAT for FIS-B weather and UAT traffic)
- **No TSAA-specific configuration UI beyond standard traffic setup** — TSAA runs automatically when ADS-B In data is available
- **XPDR has its own failure model** separate from ADS-B failure modes — five distinct advisory messages cover the matrix

The XPDR "section" of the Pilot's Guide is 11 pages (pp. 75–85), of which 3 pages (83–85) cover **GPS 175 / GNC 355** ADS-B-via-GDL-88 control panels — those are NOT applicable to the GNX 375. The GNX 375's XPDR + ADS-B content is concentrated in **pp. 75–82**.

---

## Core XPDR Content (pp. 75–82)

### Page 75 — XPDR Control Panel [AVAILABLE WITH: GNX 375]

The XPDR is accessed via the XPDR key (placement varies by configuration but functionally equivalent to an app icon).

Control panel has five labeled UI regions:

1. **Squawk Code Entry Field** — displays the active code; digits being entered appear as underscores until confirmed
2. **VFR Key** — one-tap set to preprogrammed VFR code (factory default 1200; configurable)
3. **XPDR Mode Key** — opens the mode menu
4. **Squawk Code Entry Keys** — 8 digit keys (0–7); ATCRBS-compatible code range
5. **Data Field** — displays either pressure altitude or Flight ID (toggle via menu)

XPDR key becomes available again when:
- User enters a squawk code
- User opens the XPDR menu
- User views a message
- User selects the Mode key
- User leaves the control panel

(The XPDR key disappears while the control panel is active; re-appears when control panel is closed.)

### Page 76 — XPDR Setup Menu

Menu accessed from the control panel via Menu key. Three items:

1. **Data Field toggle** — switches the data field between pressure altitude and Flight ID
2. **1090 ES ADS-B Out enable** — toggle ON/OFF (only if configured to be pilot-controllable)
3. **Flight ID assignment** — if editable (configuration-dependent)

Display modes for the data field:
- **Pressure Altitude**: displays current pressure altitude from the configured altitude source
- **Flight ID**: displays the active Flight ID; unless configured otherwise, the Flight ID is not editable

### Page 77 — Extended Squitter and Flight ID

- **Extended Squitter ADS-B Out:** tapping the ADS-B Out key toggles transmission. "ON" state indicates ADS-B Out messages and position information are being transmitted.
- **Flight ID assignment:** requires configuration to be editable. If editable: alphanumeric, uppercase only, 8-character limit. Default active Flight ID displays automatically.

### Page 78 — XPDR Modes

Three modes available via the Mode menu:

| Mode | Reply to interrogations? | Pressure altitude in reply? | ADS-B Out includes altitude? | Bluetooth? | ADS-B In? |
|------|--------------------------|----------------------------|------------------------------|------------|-----------|
| **Standby** | No | — | No | Yes (remains operational) | Yes (receives, but is not a TIS-B participant) |
| **On** | Yes (identification only) | No | No | Yes | Yes |
| **Altitude Reporting** | Yes (identification + altitude) | Yes | Yes | Yes | Yes |

Reply (R) symbol on the display indicates the transponder is responding to interrogations (visible in On and Altitude Reporting modes).

Pilot's Guide note (p. 78): "During Altitude Reporting mode, all aircraft air/ground state transmissions are handled via the transponder and require no pilot action. Always use this mode while in the air and on the ground, unless otherwise requested by ATC."

This means: **Altitude Reporting mode handles air/ground state automatically** — the pilot does NOT need to switch modes on landing. No "Ground" or "GND" mode is exposed to the pilot. The transponder handles WOW internally.

### Page 79 — Squawk Code Entry

- Eight entry keys: 0–7 (ATCRBS range is 0000–7777 octal)
- Backspace key OR outer control knob to move cursor
- Unentered digits display as underscores
- Enter key confirms the new code
- Cancel key exits without changing

**Special squawk codes** (informational only — no preset buttons):
- **1200** — Default VFR code (USA)
- **7500** — Hijacking
- **7600** — Loss of communications
- **7700** — Emergency

Active squawk codes remain in use until a new code is entered.

### Page 80 — VFR Key and IDENT

**VFR key:** one-tap sets squawk to the preprogrammed VFR code (factory default 1200, configurable at installation).

**XPDR key (when already on the control panel) = IDENT:**
- Tapping activates IDENT function for **18 seconds**
- IDENT causes the transponder to send a distinguishing signal to ATC's screen
- Tapping the XPDR key when another page is active immediately opens the control panel (not IDENT).

### Page 81 — Transponder Status Indications

Four distinct visual states, shown by the control panel layout:

1. **IDENT active (unmodified code):** Reply active + IDENT function active + no change to transponder code
2. **IDENT with new squawk code:** Reply active + transponder code modified + IDENT active (tapping Enter on a modified code initiates IDENT automatically)
3. **Standby mode:** Standby mode indicator + current squawk code (inactive, meaning transponder is not replying)
4. **Altitude Reporting mode:** Altitude reporting mode indicator + reply active + identify function active + VFR squawk code (active)

Tap behaviors:
- **Altitude Reporting state:** tap initiates IDENT (code unmodified)
- **Standby state:** tap accepts modified code AND initiates IDENT

### Page 82 — Remote Control and XPDR Alert

**Remote control from G3X Touch:** transponder functions controllable from a connected G3X Touch display. Controllable features:
- Squawk code
- Transponder mode
- IDENT
- ADS-B transmission
- Flight ID

(For full remote operation, Pilot's Guide defers to the G3X Touch Pilot's Guide.)

**XPDR Alert (failure indication):**
- Red "X" displays over the IDENT key
- Advisory message alerts
- XPDR control page is not available while in failure state
- Failure annunciations are designed to be immediately recognizable
- If a failure occurs while the control page is active, the display automatically returns to the previous page

**Unit failure condition (p. 82 specific):** "GNX 375 ADS-B interboard communication failure" — this is one specific advisory message. For full XPDR failure advisory set, see pp. 282–284 and 290.

---

## What the XPDR Section Does NOT Include (Pp. 83–85)

Pages 83–85 cover **ADS-B Altitude Reporting** for **GPS 175 and GNC 355** when interfaced to a **GDL 88** transceiver. This is NOT applicable to the GNX 375 spec. The GNX 375's ADS-B is integrated into its built-in receiver; there is no separate ADS-B Altitude Reporting control panel.

**Specifically:** Anonymous mode (p. 84) is GPS 175 / GNC 355 + GDL 88 only. The GNX 375 has no Anonymous mode.

---

## Related Overview and Status Content

### Page 18 — Overview

"GNX 375 combines the functionality of GPS 175 with a **TSO-C112e (Level 2els, Class 1)** compliant mode S transponder that meets ADS-B Out requirements. A dual-link ADS-B In receiver provides the display of traffic and subscription-free weather."

**Correction to Turn 18 harvest map:** the TSO is **C112e**, not C112d. Level is "Level 2els, Class 1."

### Page 19 — Unit Comparison Table

Authoritative feature matrix:

| Unit | GPS/MFD | COM Radio | Mode S XPDR | Dual-link ADS-B In | 1090 ES ADS-B Out |
|------|:-------:|:---------:|:-----------:|:------------------:|:------------------:|
| GPS 175 | ✓ | | | | |
| GNC 355 | ✓ | ✓ | | | |
| **GNX 375** | ✓ | | ✓ | ✓ | ✓ |

### Page 34 — Altitude Source (ADC)

The transponder's pressure altitude input comes from an external altitude encoder or ADAHRS (e.g., GAE 12, GDC 74, integrated ADAHRS, etc.). The 375 itself does not measure pressure altitude. Multiple LRU options listed.

**Implication for spec:** the "pressure altitude" shown in the XPDR data field is sourced from an external input, not computed on the 375. Spec must document the altitude source dependency.

### Page 102 — System Status

System Status page displays "Transponder software version" **GNX 375 only**. Confirms the transponder is treated as a distinct software component with its own version tracking.

### Page 225 — FIS-B (Built-in vs. External Receiver)

FIS-B feature requirements:
- GPS 175 / GNC 355 with UAT receiver (GDL 88, GTX 345, or GNX 375) + FIS-B
- **OR: GNX 375 + FIS-B** (no external hardware needed)

FIS-B operates on 978 MHz UAT band. FAA-operated ground stations broadcast weather datalink.

### Page 244 — FIS-B Reception Status

FIS-B Reception page shows completeness of NOTAM-TFR, G-AIRMET, CWA, SIGMET data for received ground stations. UAT transceiver required.

### Page 248 — Intruder Display

Traffic symbols show altitude separation (above/below ownship), vertical trend arrow (climbing/descending). Directional vs. non-directional symbols. This is ADS-B In traffic content, not XPDR-specific.

---

## Advisory Messages (pp. 282–284 + 288–290)

Three categories of advisories affect XPDR + ADS-B behavior:

### Transponder hardware advisories (pp. 282–284)

Apply to GPS 175 / GNC 355 with GTX 345 transponder (NOT to GNX 375). GTX 345 overtemp/undertemp messages.

### GNX 375 / ADS-B advisories (pp. 283–284)

Applicable to the 375:

1. **"ADS-B Out fault. Pressure altitude source inoperative or connection lost."** — transponder lost communication with external altitude source
2. **"Transponder has failed."** — internal failure; 1090ES ADS-B Out fail, transponder fail, or comm lost
3. **"Transponder is operating in ground test mode."** — ground test; cycle power after completion
4. **"ADS-B is not transmitting position."** — transponder not receiving valid GPS position

### Traffic / ADS-B In advisories (pp. 288–290)

Split into two advisory tables:
- **Pp. 288–289** — GPS 175 and GNC 355 traffic advisories (GDL 88-based, NOT for GNX 375)
- **P. 290** — **GNX 375 traffic advisories** (applicable to 375):
  1. **"1090ES traffic receiver fault."** — unable to receive 1090 ES traffic
  2. **"ADS-B traffic alerting function inoperative."** — TSAA application unavailable to run
  3. **"ADS-B traffic function inoperative."** — ADS-B Traffic input failure; electrical fault; all applications unavailable
  4. **"Traffic/FIS-B functions inoperative."** — configuration data fault
  5. **"UAT traffic/FIS-B receiver fault."** — unable to receive UAT data

---

## Recommended §11 Structure for GNX 375 Outline

Based on the research, my Turn 18 anticipated §11 structure needs revision. Recommended revised structure:

### §11 Transponder + ADS-B Operation [AVAILABLE WITH: GNX 375]

**Scope.** The GNX 375's Mode S transponder with 1090 ES Extended Squitter ADS-B Out and dual-link ADS-B In receiver. Includes XPDR Control Panel, squawk code entry, mode selection, IDENT function, ADS-B Out transmission, Flight ID management, remote control via G3X Touch, and failure modes. This section replaces the 355's §11 COM Radio Operation.

**Source pages.** [pp. 18–20, 75–82, 102, 225, 244, 282–284, 290]

**Estimated length.** ~180 lines (down from Turn 18 estimate of ~200 lines, because several anticipated sub-sections don't exist in the actual unit).

#### 11.1 XPDR Overview and Capabilities [pp. 18, 19, 75]

- TSO-C112e (Level 2els, Class 1) compliant Mode S transponder
- 1090 ES Extended Squitter ADS-B Out
- Dual-link ADS-B In receiver (1090 ES for traffic + 978 MHz UAT for FIS-B weather and UAT traffic)
- Integrated with GNX 375's GPS/MFD for position reporting
- Altitude source: external (from ADC/ADAHRS via altitude encoder input; see p. 34)

#### 11.2 XPDR Control Panel [p. 75]

- Access via XPDR key (context-dependent placement)
- 5 UI regions: Squawk Code Entry Field, VFR Key, XPDR Mode Key, Squawk Code Entry Keys (0–7), Data Field
- XPDR key visibility rules (available when code entered / menu open / message viewed / Mode selected / leaving control panel)

#### 11.3 XPDR Setup Menu [p. 76]

- Data Field toggle: pressure altitude ↔ Flight ID
- 1090 ES ADS-B Out enable (configuration-dependent toggle)
- Flight ID assignment (configuration-dependent availability)

#### 11.4 XPDR Modes [p. 78]

- Three modes: Standby / On / Altitude Reporting
- Mode characteristics table (reply behavior, altitude inclusion, Bluetooth, ADS-B In)
- Altitude Reporting handles air/ground state automatically (no pilot intervention required)
- No Ground or Test mode exposed in pilot UI

#### 11.5 Squawk Code Entry [p. 79]

- Keypad layout (keys 0–7 only; ATCRBS range)
- Backspace key + outer knob cursor movement
- Enter/Cancel flow
- Underscore placeholder for unentered digits
- Special codes reference (1200 VFR, 7500 hijacking, 7600 loss of comms, 7700 emergency — informational, no preset buttons)

#### 11.6 VFR Key and IDENT [p. 80]

- VFR key: one-tap to preprogrammed VFR code (default 1200, configurable)
- IDENT: tapping XPDR key (while control panel active) activates IDENT for **18 seconds**
- IDENT signal distinguishes transponder on ATC's screen

#### 11.7 Transponder Status Indications [p. 81]

- Four visual states: IDENT active / IDENT with new code / Standby / Altitude Reporting
- Tap behaviors per state (Altitude Reporting → IDENT unmodified; Standby → accept new code + IDENT)

#### 11.8 Extended Squitter (ADS-B Out) [p. 77]

- 1090 MHz Extended Squitter transmission
- Toggle via XPDR Menu → ADS-B Out
- ON state indicates active transmission
- Transmits position information (from GNX 375's internal GPS) + pressure altitude (when in Altitude Reporting mode)

#### 11.9 Flight ID [pp. 76, 77, 82]

- Usually configured at installation (not editable by default)
- If editable: alphanumeric uppercase, 8-character max
- Default display behavior
- Remote editability via G3X Touch

#### 11.10 Remote Control via G3X Touch [p. 82]

- G3X Touch can control: squawk code, transponder mode, IDENT, ADS-B transmission, Flight ID
- Defers to G3X Touch Pilot's Guide for detailed operation
- **Open question for 375 spec:** whether this integration is in scope for the sim instrument (likely NO for v1; document as "available but not part of v1 instrument").

#### 11.11 ADS-B In (Built-in Dual-link Receiver) [pp. 18, 225, cross-ref §4.9]

- 1090 ES for traffic
- 978 MHz UAT for FIS-B weather + UAT traffic
- Drives FIS-B Weather page (§4.9)
- Drives Traffic Awareness page (§4.9)
- Enables TSAA traffic alerting (§4.9)
- No external receiver required (unlike GPS 175 / GNC 355 which need GDL 88 or GTX 345)
- Cross-reference to §4.9 for display pages and interactions

#### 11.12 XPDR Failure / Alert [p. 82]

- Red "X" over IDENT key on failure
- Advisory message alerts (see §13)
- XPDR control page becomes unavailable during failure
- Display auto-returns to previous page if failure occurs during active control-panel use

#### 11.13 XPDR Advisory Messages [pp. 283–284, 290]

- "ADS-B Out fault. Pressure altitude source inoperative..." — altitude source loss
- "Transponder has failed." — internal failure (1090 ES Out fail / XPDR fail / comm loss)
- "Transponder is operating in ground test mode." — ground test indicator
- "ADS-B is not transmitting position." — GPS position invalid
- "1090ES traffic receiver fault." — traffic-receive failure
- "ADS-B traffic alerting function inoperative." — TSAA app unavailable
- "ADS-B traffic function inoperative." — ADS-B Traffic input failure
- "Traffic/FIS-B functions inoperative." — configuration data fault
- "UAT traffic/FIS-B receiver fault." — UAT receive failure
- Cross-reference to §13 Messages for full advisory formatting

#### 11.14 XPDR Persistent State [§14 cross-ref]

- Squawk code retained across power cycles
- Mode setting retained
- Flight ID retained (if configurable, the user setting; otherwise the factory-set value)
- ADS-B Out enable state retained
- Data field preference (altitude vs. Flight ID) retained

**Open questions / flags:**
- XPL XPDR dataref names (e.g., `sim/cockpit2/radios/actuators/transponder_code`, `transponder_mode`) require verification against current XPL datareftool output during design.
- MSFS XPDR SimConnect variables (`TRANSPONDER CODE:1`, `TRANSPONDER IDENT`, `TRANSPONDER STATE`) — verify unit representations and availability per FS2020/FS2024.
- IDENT command in XPL and MSFS: XPL likely `sim/transponder/transponder_ident` or similar; MSFS `XPNDR_IDENT_ON`. Verify.
- Mode selection dataref: XPL exposes `transponder_mode` integer (0=off, 1=standby, 2=on, 3=alt? — or different scheme); verify.
- Remote control via G3X Touch: out of scope for v1 instrument.
- Anonymous mode: **does NOT apply** to GNX 375 (GPS 175 / GNC 355 + GDL 88 only; confirmed p. 84).

**AMAPI cross-refs:**
- `docs/knowledge/amapi_by_use_case.md` §1 (dataref subscriptions for XPDR state)
- `docs/knowledge/amapi_by_use_case.md` §2 (command dispatch for IDENT, mode change, code set)
- `docs/knowledge/amapi_by_use_case.md` §3 (Button_add for XPDR keypad digits — similar to COM frequency keypad in 355 outline §11.4)
- `docs/knowledge/amapi_by_use_case.md` §7 (Txt_add/Txt_set for squawk code display, active mode label, data field)
- `docs/knowledge/amapi_by_use_case.md` §11 (Persist_add for squawk code, mode, Flight ID)
- `docs/knowledge/amapi_patterns.md` Pattern 1 (triple-dispatch for XPDR actions: XPL + MSFS)
- `docs/knowledge/amapi_patterns.md` Pattern 2 (multi-variable bus for XPDR + ADS-B state)
- `docs/knowledge/amapi_patterns.md` Pattern 14 (parallel XPL + MSFS)
- `docs/knowledge/amapi_patterns.md` Pattern 17 (annunciator visible for XPDR mode indicator, Reply (R) indicator, IDENT state, failure "X")

---

## Corrections to Turn 18 Harvest Map §11 Anticipated Sub-sections

My Turn 18 anticipated 13 sub-sections. Turn 21 research gives 14 sub-sections with several structural changes:

| Turn 18 anticipated | Turn 21 corrected |
|---------------------|-------------------|
| 11.1 XPDR Overview | 11.1 XPDR Overview and Capabilities — content expanded to include altitude source dependency |
| 11.2 XPDR Modes | 11.4 XPDR Modes — renumbered; Standby/On/Altitude Reporting ONLY (Ground and Test were speculative; don't exist) |
| 11.3 Squawk Code Entry | 11.5 — renumbered |
| 11.4 IDENT Function | 11.6 — combined with VFR Key (both live on p. 80) |
| 11.5 Flight ID | 11.9 — renumbered; note that editability is configuration-dependent |
| 11.6 Extended Squitter (ADS-B Out) | 11.8 — renumbered |
| 11.7 Built-in ADS-B In Receiver | 11.11 — renumbered |
| 11.8 TSAA Traffic Application | **MERGED INTO §4.9 (Traffic Awareness) and §11.11 cross-reference** — TSAA is not a separate XPDR feature in the UI; it's the traffic app that consumes ADS-B In data |
| 11.9 XPDR Remote Control | 11.10 — renumbered |
| 11.10 XPDR Status Indications | 11.7 — renumbered |
| 11.11 XPDR Alerts and Status | **SPLIT:** 11.12 (Failure/Alert) + 11.13 (Advisory Messages) |
| 11.12 XPDR Configuration | **MERGED INTO 11.3 (XPDR Setup Menu) and 11.9 (Flight ID)** |
| 11.13 XPDR Persistent State | 11.14 — renumbered; content refined based on what's actually configurable |
| — | **NEW: 11.2 XPDR Control Panel** (UI layout section — this wasn't in Turn 18 but is needed) |
| — | **NEW: 11.6 VFR Key and IDENT** — combined because they share p. 80 |

Net effect: 14 sub-sections instead of 13. Structure is tighter and better reflects the Pilot's Guide organization.

---

## Cross-cutting Corrections to the Harvest Map

Beyond §11, the research surfaced two corrections applicable elsewhere:

### 1. TSO designation for GNX 375 XPDR

**Turn 18 harvest map (incorrect):** "TSO-C112d (Mode S Level 2els)"
**Per Pilot's Guide p. 18 (correct):** "TSO-C112e (Level 2els, Class 1)"

Scope: §1.1 Product description in the 375 outline.

### 2. Altitude source for XPDR

The 375's XPDR requires an external pressure altitude source (altitude encoder, ADAHRS). This is noted at p. 34 (System at a Glance — ADC & AHRS). The 355 outline's §15 (External I/O) didn't need to cover this because the 355 has no XPDR. The 375 outline's §15 must add altitude source as a dependency.

---

## Summary: XPDR/ADS-B Scope for 375 Outline

**Clear structure for C2.1-375 authoring:**
- §11 has 14 sub-sections covering XPDR Control Panel, Setup, Modes, Squawk Entry, VFR + IDENT, Status Indications, Extended Squitter, Flight ID, Remote Control, ADS-B In, Failure/Alert, Advisory Messages, and Persistent State
- Anonymous mode DROPPED (doesn't apply to 375)
- Ground and Test modes DROPPED (don't exist on 375)
- TSAA handled in §4.9 (Traffic Awareness) with §11.11 cross-reference — not as a separate XPDR sub-section
- Altitude-source dependency added to §15 External I/O

**Research coverage is now COMPLETE for the 375 outline authoring** (combined with Turn 20 navigation-role research). The C2.1-375 task prompt can be drafted with confidence.

**Open questions remaining** (for C2.1-375 or design phase):
1. Exact XPL/MSFS dataref/variable/event names for XPDR and ADS-B state (design-phase research)
2. Whether Remote Control via G3X Touch is in scope for v1 instrument (recommendation: NO; document as "available on real unit, not in v1 instrument")
3. Published altitude constraint display behavior (from Turn 20; still open)
4. Detailed fly-by/fly-over turn geometry (from Turn 20; still open)
5. Full ARINC 424 leg type list (from Turn 20; still open)
