---
Created: 2026-04-24T11:30:00-04:00
Source: docs/tasks/c22_f_prompt.md
Fragment: F
Covers: §§11–13 (Transponder + ADS-B Operation, Audio/Alerts/Annunciators, Messages)
---

# GNX 375 Functional Spec V1 — Fragment F

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

## Coupling Summary

This section is authored per D-18 for CD/CC coordination across the 7-fragment spec. It is not part of the spec body and is stripped on assembly. Fragment F is the most-coupled fragment in the series; backward-refs and forward-refs blocks are correspondingly denser than prior fragments.

### Backward cross-references (sections this fragment references authored in prior fragments)

- Fragment A §1 (Overview): GNX 375 baseline framing (Mode S Level 2els Class 1, TSO-C112e, 1090 ES ADS-B Out, built-in dual-link ADS-B In, sibling-unit distinctions) — referenced in §11.1 Overview and §11.11 ADS-B In sibling contrast.
- Fragment A §2 (Physical Layout & Controls): Home page navigation and XPDR key icon — §11.2 XPDR Control Panel access begins from Home > XPDR icon.
- Fragment A §3 (Power-On / Startup / Database): external altitude source framing (ADC/ADAHRS via altitude encoder, p. 34) — §11.1, §11.3 Setup Menu, §11.4 Altitude Reporting, §11.8 Extended Squitter, §11.13 item 1, §13.8 pressure altitude advisory all reference external altitude source.
- Fragment A Appendix B (Glossary): **Verified-present terms claimed as backward-refs (ITM-08 grep-verified):** 1090 ES, UAT, Extended Squitter, TSAA, FIS-B, TIS-B, Flight ID, IDENT, WOW, Target State and Status, TSO-C112e, TSO-C166b, Mode S, WAAS, SBAS, RAIM, Connext, GPSS, CDI, VDI. **NOT claimed (absent from Appendix B per C2.2-C X17, C2.2-D F11, C2.2-E C1):** EPU, HFOM, VFOM, HDOP, TSO-C151c.
- Fragment B §4.1 (Home Page): XPDR app icon on Home — §11.2 XPDR Control Panel access.
- Fragment C §4.9 (Hazard Awareness — FIS-B + Traffic + TSAA): §11.11 ADS-B In cross-refs §4.9 for display pages (receiver-side framing only in §11.11); §12.4 Aural Alerts cross-refs §4.9 for OPEN QUESTION 6 (TSAA aural delivery mechanism — verbatim OQ6 text not re-preserved in Fragment F); §12.7 Traffic Annunciations cross-refs §4.9; §12.8 Terrain Annunciations cross-refs §4.9; §13.11 Traffic System Advisories references §4.9 built-in receiver framing.
- Fragment D §7.2 (GPS Flight Phase Annunciations): §12.2 Annunciator Bar flight phase slot — 11-row annunciation table authored in §7.2; §12.2 cross-refs; not re-tabulated.
- Fragment D §7.9 (XPDR + ADS-B Approach Interactions): §11.4 XPDR Modes and §11.11 ADS-B In cross-ref §7.9 for approach-phase interaction detail.
- Fragment E §10.1 (CDI On Screen): §12.2 Annunciator Bar CDI scale indicator slot cross-ref.
- Fragment E §10.5 (Alerts Settings): §12.2 Annunciator Bar alert-level color semantics context.
- Fragment E §10.8 (Scheduled Messages): §13.7 Pilot-Specified Advisories cross-refs §10.8 for message creation/modify/delete workflow.
- Fragment E §10.11 (GPS Status): §12.5 GPS Status Annunciations cross-refs §10.11 for the full operational GPS Status page (satellite sky view, position accuracy fields, SBAS Providers selection).
- Fragment E §10.12 (ADS-B Status): §11.11 ADS-B In cross-refs §10.12 for the operational settings workflow (uplink time display, FIS-B WX Status sub-page, Traffic Application Status sub-page with AIRB/SURF/ATAS states). §11.11 authors receiver-side framing only; §10.12 is authoritative for the settings-page workflow.
- Fragment E §10.13 (Logs): §13.8 System Hardware Advisories references §10.13 for GNX 375-only ADS-B traffic log and WAAS diagnostic log export.

### Forward cross-references (sections this fragment writes that later fragments will reference)

- §11.14 XPDR Persistent State → §14 Persistent State (Fragment G): squawk code, mode, Flight ID (if configurable), ADS-B Out enable state, data field preference.
- §11 overall → §15 External I/O (Fragment G): XPDR code/mode/reply datarefs (XPL + MSFS); ADS-B Out state datarefs; IDENT command; Flight ID dataref (if editable). **OPEN QUESTIONS 4 and 5 forward-referenced.**
- §11.11 ADS-B In → §15 External I/O (Fragment G): ADS-B In receiver status datarefs; FIS-B reception datarefs; Traffic Application state datarefs.
- §11.4 Altitude Reporting + §11.8 Extended Squitter → §15.7 Altitude Source Dependency (Fragment G): external pressure altitude dataref contract.
- §12.2 Annunciator Bar FROM/TO slot + CDI scale slot → §15.6 External CDI/VDI Output Contract (Fragment G).

### Intra-fragment cross-references (within Fragment F)

- §11.7 Status Indications ↔ §12.9 XPDR Annunciations — status states rendered as annunciator elements.
- §11.13 XPDR Advisory Messages ↔ §13.9 XPDR Advisories (items 1–4, pp. 283–284).
- §11.13 XPDR Advisory Messages ↔ §13.11 Traffic System Advisories (items 5–9, p. 290).
- §12.4 Aural Alerts ↔ §13.9 / §13.11 — advisory conditions may trigger TSAA aural alerts; aural delivery mechanism cross-ref §4.9 OPEN QUESTION 6.

### Outline coupling footprint

This fragment draws from outline §§11–13 only. No content from §§1–10 (Fragments A through E), §§14–15, or Appendices A/B/C is authored here. Forward-refs to §§14–15 appear as prose cross-references only.
