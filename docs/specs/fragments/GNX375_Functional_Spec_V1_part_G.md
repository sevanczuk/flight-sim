---
Created: 2026-04-25T09:00:00-04:00
Source: docs/tasks/c22_g_prompt.md
Fragment: G
Covers: §§14–15 + Appendix A (Persistent State, External I/O, Family Delta)
---

# GNX 375 Functional Spec V1 — Fragment G

This is the seventh and final of seven piecewise spec-body fragments per D-18. It covers §14 Persistent State, §15 External I/O (Datarefs and Commands), and Appendix A Family Delta. On archive, the seven-fragment C2.2 decomposition is complete and the aggregate spec is assembly-ready for C3 review.

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

---

## Coupling Summary

This section is authored per D-18 for CD/CC coordination across the 7-fragment spec. It is not part of the spec body and is stripped on assembly. Fragment G is the closing fragment — every forward-ref authored in Fragments A through F lands here, making this the most backward-ref-dense Coupling Summary in the series. Per ITM-12, each reference is expanded into 2–4 sentences of prose rather than compact bullets. Target length 95–105 lines.

---

### Backward cross-references

**Fragment A §1 Overview.**
Fragment G §14 Persistent State and Appendix A Family Delta draw on the GNX 375 product positioning established in §1: TSO-C112e Mode S transponder, 1090 ES ADS-B Out, dual-link ADS-B In, GNX 375 primary per D-12.
Appendix A.1 explicitly cites §1 and D-12 for unit-family context.
§14.1 XPDR State depends on §1's feature-set framing: a unit without a transponder has no XPDR State to persist.

**Fragment A §1.3 External CDI/VDI architectural constraint.**
§1.3 established the no-internal-VDI framing at the overview level, citing D-15 as the architectural authority.
Fragment G §15.6 is where this constraint is fully operationalized as the External CDI/VDI Output Contract, with interface-level detail.
Reading §15.6 in the context of §1.3 makes clear that the external-output-only design is an intentional architectural decision, not a missing feature.

**Fragment A §3 Power-On and external altitude source framing.**
§15.7 Altitude Source Dependency cites the external altitude source framing first established in §3: GNX 375 reads pressure altitude from an external ADC/ADAHRS (altitude encoder, GDC 74, GAE 12, or equivalent) per p. 34.
The §3 backward-ref ensures §15.7 is read as the simulation-layer implementation of a hardware dependency established at startup, not as a novel constraint.

**Fragment A Appendix B Glossary — ITM-08 grep-verify.**
Glossary terms used in Fragment G were verified present in Appendix B via grep before finalizing this list per ITM-08.
**Confirmed present (27 terms):** Mode S, 1090 ES, UAT, Extended Squitter, TSAA, FIS-B, TIS-B, Flight ID, Squawk code, IDENT, WOW, Target State and Status, TSO-C112e, TSO-C166b (all B.1 additions); CDI, VDI, GPSS, WAAS, SBAS, LNAV, LPV, RAIM, ADC, ADAHRS (B.1); Connext (B.3); dataref, persist store (B.2).
**NOT claimed (absent per C2.2-C X17, D F11, E C1, F C1):** EPU, HFOM, VFOM, HDOP, TSO-C151c.

**Fragment B §4.1–§4.3 (Home, Map, FPL display pages).**
Fragment G §14.2 references the persistent brightness setting and locator bar page shortcuts introduced in Fragment B's display page coverage.
§14.3 Flight Planning State formalizes the FPL catalog persistence that §4.3 established as the primary flight planning data structure.
The user waypoint capacity (1,000 max) and FPL data model from §4.3 directly inform the persist-store encoding design question flagged in §14.3.

**Fragment C §4.7 Procedures display page (GPSS and VDI forward-refs).**
Fragment C §4.7 authored multiple forward-references to §15.6 (External CDI/VDI Output Contract) and §15 (XPDR + ADS-B datarefs).
Fragment G §15.6 resolves all of these: GPSS roll steering output contract, LPV glidepath deviation, and vertical deviation output to external VDI for LPV/LP+V/LNAV+V approaches.
The open question on autopilot dataref names from §4.7 is preserved in §15.6 as a design-phase flag.

**Fragment C §4.10 CDI On Screen toggle.**
§4.10 established CDI On Screen as a user-toggled setting that persists across power cycles, and forward-referenced §15.6 for the external output contract.
Fragment G §14.2 provides the formal persistence specification for the CDI On Screen toggle state.
Fragment G §15.6 provides the external CDI output contract §4.10 pointed to. Both §4.10 forward-refs resolve here.

**Fragment D §5 FPL Editing and §6 Direct-to Operation.**
Fragment D §5 forward-referenced §15 External I/O for flight-plan-change datarefs; Fragment G §15.3 includes Direct-to activate and approach activation commands as the simulator-interface counterparts.
The FPL catalog persisted in §14.3 is the backing store for the FPL and Direct-to operations authored in §5 and §6.

**Fragment D §7 Procedures, §7.8 Autopilot Outputs, and §7.9 XPDR approach interactions.**
Fragment D §7.9 authored XPDR state interactions during approach phases; Fragment G §15.1–§15.3 provide the dataref/command surfaces (squawk writes, mode commands, IDENT dispatch).
Fragment D §7.8 and §7.G forward-referenced §15.6 for the GPSS + APR output contract; those references resolve in §15.6.
The MSFS equivalents for all XPDR approach interactions are in §§15.4–15.5.

**Fragment E §§8–10 (Nearest, Waypoint Info, Settings) — six persistence forward-refs.**
Six Fragment E sub-sections forward-referenced §14 for persistent state encoding: §10.3 (timer state), §10.6 (unit selections), §10.7 (brightness offset), §10.8 (scheduled messages), §10.9 (crossfill), §10.10 (Bluetooth).
Each resolves in Fragment G §14.2–§14.6, which provides the canonical per-category persistence specification.
Fragment E §10.1 (CDI Scale) and §10.11 (GPS Status) forward-referenced §15; those resolve in §§15.1 and §15.6 respectively.

**Fragment E §10.12 ADS-B Status and §10.13 ADS-B Traffic Logging.**
§10.12 forward-referenced §15 for ADS-B receiver status datarefs; §15.1's subscription table addresses this.
§10.13 confirmed ADS-B traffic logging as a GNX 375-exclusive capability; Appendix A.5 Feature Matrix reflects this as a GNX 375-only row.
Together these sub-sections close the ADS-B In display and logging loop that §11 (Fragment F) introduced.

**Fragment F §11 XPDR + ADS-B (overall simulator interface).**
Fragment G §15.1–§15.5 provide the simulator interface surface for every pilot action authored in §11: squawk entry, mode change, IDENT, ADS-B Out toggle, and advisory conditions.
The §11 behavioral spec and the §15 interface spec are complementary — §11 is what the pilot sees and does; §15 is how the instrument communicates those actions and states to the simulator.

**Fragment F §11.13 XPDR Advisory Messages and §13.9 XPDR Advisories.**
The advisory "ADS-B Out fault. Pressure altitude source inoperative or connection lost." is authored in §11.13 item 1 and §13.9 as the pilot-facing message.
Fragment G §15.7 specifies the I/O dependency that triggers it (external ADC/ADAHRS unavailable), and §15.7 explicitly cross-references §11.13 and §13.9 to close this loop.

**Fragment F §11.14 XPDR Persistent State (primary §14.1 forward-ref target).**
§11.14 was the forward-ref target pointing to §14 for the canonical persistence specification.
Fragment G §14.1 delivers that specification: squawk code, mode (Standby/On/Altitude Reporting — three modes per D-16), Flight ID, ADS-B Out enable state, and data field preference.
§14.1 is fully consistent with §11.14's preview; §14.1 is the authoritative definition and §11.14 is its operational context.

**Fragment F §12.2 Annunciator Bar FROM/TO slot and CDI scale indicator.**
§12.2 forward-referenced §15.6 for the external CDI/VDI output contract.
Fragment G §15.6 establishes the TO/FROM flag output to external CDI, CDI scale mode auto-transitions, and lateral deviation output — all consistent with §12.2's framing that the annunciator bar FROM/TO is the pilot's primary reference and the external CDI output is secondary.

---

### Forward cross-references

Fragment G is the closing fragment of the GNX 375 Functional Spec V1 body. There are no forward-refs to later fragments because no later fragments exist. Every behavior, dataref, state, or feature delta that Fragments A through F deferred to §14, §15, or Appendix A resolves within this fragment. The assembled spec will contain no unresolved forward-references from the C2.2 fragment series.

---

### Intra-fragment cross-references

**§14.1 XPDR State ↔ §15.1/§15.2/§15.3 XPL Datarefs and Commands.**
The five §14.1 persistent state items (squawk code, mode, Flight ID, ADS-B Out enable, data field preference) correspond one-for-one to dataref reads in §15.1 and writes in §15.2/§15.3.
§14.1 is the what-persists spec; §15 is the how-to-read-and-write spec. Any change to the §14.1 enumeration must be reflected in the §15 dataref tables simultaneously — the same state items viewed from two perspectives.

**§15.6 External CDI/VDI Output Contract ↔ §15.1 XPL Datarefs Reads.**
The §15.6 outputs (lateral deviation, vertical deviation, TO/FROM, CDI scale, GPSS) are sourced from a subset of the §15.1 dataref subscriptions.
§15.6 specifies the target-instrument contract; §15.1 specifies the source dataref names. Resolving the §15.6 CDI/VDI output dataref-name flag will simultaneously update the TBD entries in §15.1.

**§15.7 Altitude Source Dependency ↔ §14.1 and §15.1 pressure altitude dataref.**
§15.7 establishes that pressure altitude comes from an external ADC/ADAHRS, not internal GNX 375 computation, creating two intra-fragment effects: (a) §14.1 omits pressure altitude from persistence — it comes fresh from the external source each cycle; (b) §15.1 includes the pressure altitude dataref subscription [OQ4] to receive it.
§14.1, §15.1, and §15.7 form a consistent triangle: omit from persistence, subscribe from external source, define the dependency contract.

---

### Outline coupling footprint

This fragment draws exclusively from outline §§14–15 and Appendix A. No content from §§1–13 (Fragments A–F), Appendix B Glossary, or Appendix C Extraction Gaps is authored here. Together with Fragments A through F, this fragment completes the **7-fragment decomposition per D-18 §"Task partition"** — Fragments A–G cover all 15 outline sections plus Appendices A, B, and C with zero overlap and no gaps. The GNX 375 Functional Spec V1 body is **assembly-ready**; CD to author `scripts/assemble_gnx375_spec.py` and prepend the Review Priority Guide per D-22 post-archive.
