# GNC 355 → GNX 375 Outline Harvest Map

**Created:** 2026-04-21T09:23:16-04:00
**Source:** Purple Turn 18 — Step 2 of the Option 5 execution plan per D-12
**Purpose:** Section-by-section reusability categorization of the shelved GNC 355 outline (`docs/specs/GNC355_Functional_Spec_V1_outline.md`), guiding authorship of the dedicated GNX 375 outline. This is working material for CC's C2.1-375 task; it is NOT a published deliverable.
**Source outline:** `docs/specs/GNC355_Functional_Spec_V1_outline.md` (1,327 lines; 18 divisions; PASS WITH NOTES compliance)
**Companion:** `docs/specs/pivot_355_to_375_rationale.md` (pivot rationale); `docs/decisions/D-12-pivot-gnc355-to-gnx375-primary-instrument.md` (decision)

---

## Summary

**Division count by category:**

| Category | Count | Share |
|----------|------:|------:|
| Fully reusable | 8 | 44% |
| Partially reusable | 7 | 39% |
| 355-only (omit from 375) | 2 | 11% |
| 375-needs-new-content (add) | ~6 feature areas + 1 major new section | — |

**Estimated 375 outline length:** roughly comparable to 355's 2,800 lines. Net effect: –295 lines (removing §4.11 + §11 + COM-related bits in §§12–15) offset by +300–400 lines (new XPDR section from pp. 75–85, ADS-B In/Out treatment upgrade, procedural fidelity augmentations in §7 per Turn 19 audit **as corrected by Turn 20 research** — see `docs/knowledge/gnx375_ifr_navigation_role_research.md` and D-15). Net ≈ 2,800–2,900 lines.

**Turn 20 research correction.** Items 11–25 under §7 procedural fidelity were partly over-scoped in Turn 19. Research confirmed that the 375 has NO internal VDI (vertical deviation is output only to external CDI/VDI per Pilot's Guide p. 205) and only an OPTIONAL small on-screen lateral CDI ("CDI On Screen" toggle). Per D-15, several items are reframed from "on-375 display" to "output contract to external instrument," and item 21 (altitude constraints) becomes an explicit open research question. Authoritative reference: `docs/knowledge/gnx375_ifr_navigation_role_research.md` §"Corrections to Turn 19 Harvest Map."

**Key structural changes:**

1. **§11 swap.** Section 11 (COM Radio Operation, ~200 lines, entirely 355-only) is replaced wholesale by a new Section 11: Transponder + ADS-B Operation, sourced from pp. 75–85 of the Pilot's Guide plus cross-cutting ADS-B content currently distributed across §4.9, §10.12, and §13.11.
2. **§4.11 deletion.** The COM Standby Control Panel sub-section (~60 lines, 355-only) is dropped entirely. The 375 has no analogous always-visible overlay.
3. **§4.9 framing flip.** Hazard Awareness (FIS-B weather + traffic) pivots from "external ADS-B receiver required" (355 framing) to "built-in dual-link receiver" (375 framing). Structural content mostly transfers; framing language and feature-requirement blocks change substantially.
4. **Appendix A baseline flip.** Family delta pivots from 355-baseline to 375-baseline. GPS 175 and GNC 355 become the comparison units; GNX 375's own features become baseline.
5. **§7 procedural fidelity augmentations.** The Procedures section gets additional content on XPDR altitude reporting during approach, ADS-B traffic display during approach, and the interaction between GPS flight phase annunciations and XPDR/ADS-B state. Structural content transfers; new interaction passages added.
6. **§15 I/O overhaul.** All COM-specific datarefs/events drop; XPDR and ADS-B datarefs/events added. Structural template transfers; specific API names all swap.

**Most judgment-heavy calls (flagged for CD/CC attention during 375 outline authoring):**

- Whether XPDR + ADS-B belongs as ONE §11 (combined) or TWO sections (§11 XPDR, §12 ADS-B renumbering downstream). Recommendation: combined §11, because the 375's XPDR and ADS-B are tightly coupled (Extended Squitter = transponder-driven ADS-B Out; they share hardware and UI).
- How deeply to embed ADS-B In content in §4.9 Hazard Awareness vs. keeping it in the new §11. Recommendation: §4.9 covers the USER-FACING displays (weather page, traffic page); §11 covers the UNDERLYING receiver/transmitter state and control.
- Whether procedural fidelity augmentations in §7 warrant a new §7.9 "Approach-phase XPDR/ADS-B behavior" sub-section or should be interleaved into existing sub-sections. Recommendation: interleaved (matches Pilot's Guide narrative structure), with a short §7.9 summary block.

---

## Legend

- **[FULL]** Fully reusable — structure, content, page references all transfer verbatim to 375 outline. No changes required other than possibly renaming "GNC 355" → "GNX 375" in scope statements.
- **[PART]** Partially reusable — overall structure transfers but specific sub-bullets, framing, or feature-requirement blocks need 375-specific edits. Usually the page references remain valid.
- **[355]** 355-only — content has no 375 equivalent; omit from 375 outline. Preserved in shelved 355 outline for the eventual 355 implementation.
- **[NEW]** 375-needs-new-content — feature area that the 355 outline omitted, flagged as out-of-scope, or underweighted; 375 outline needs fresh authoring. Pilot's Guide pages typically specified.

---

## Harvest by Section

### §1 Overview [pp. 18–20, ~50 lines] — **[PART]**

- 1.1 Product description and family placement — baseline needs to flip. 355's "GPS/MFD + VHF COM" becomes 375's "GPS/MFD + Mode S transponder + built-in dual-link ADS-B In/Out." Sibling unit framing flips: GPS 175 and GNC 355/355A become the siblings.
- 1.2 Unit feature comparison table — content fully transfers; just reorders for 375-baseline presentation.
- 1.3 Scope — structural template transfers; key language flips. "COM functions" → "XPDR + ADS-B functions"; "25/8.33 kHz channel spacing" → drop entirely; "TSO-C169a" → drop (355 TSO); 375 TSOs added (TSO-C166b for ADS-B, TSO-C112d for Mode S).
- 1.4 How to read this spec — structural template transfers. "GNC 355/355A only" → "GNX 375 only" flips meaning; family-delta markers flip accordingly.

**375-needs-new-content:** nothing substantive beyond language flips; no new sub-sections.

**Open questions:** the 355 outline's Open Questions block flagged the GNC 375 / GNX 375 disambiguation. Per D-12 this is resolved (GNX 375 is correct). The 375 outline can drop this flag.

---

### §2 Physical Layout & Controls [pp. 21–32, ~150 lines] — **[PART]**

- 2.1 Bezel components [p. 21] — **[FULL]** Bezel hardware (Power/Home, concentric knobs, photocell, SD slot, ledges) is identical across units.
- 2.2 SD card slot operations [p. 22] — **[FULL]** Identical.
- 2.3 Touchscreen gestures [p. 23] — **[FULL]** Identical (same touchscreen on all three units).
- 2.4 Keys and UI primitives [pp. 24–26] — **[FULL]** Identical.
- 2.5 Control knob functions [pp. 27–30] — **[PART]** Outer knob behavior identical. Inner knob push behavior DIFFERS: 355's "knob push = standby frequency tuning, second push = COM volume" is 355-specific. 375's inner knob push = Direct-to access (same as GPS 175). Knob mode sequence entirely reframes.
- 2.6 Page navigation labels (locater bar) [pp. 28–29] — **[FULL]** Identical.
- 2.7 Knob shortcuts [pp. 29–30] — **[PART]** 355 and 375 have different shortcut sequences. 375 inherits the GPS 175 pattern: knob push from Home = Direct-to window, second push = activate. No COM volume phase.
- 2.8 Screenshots [p. 31] — **[FULL]** Identical.
- 2.9 Color conventions [p. 32] — **[FULL]** Identical color semantics; "magenta = active flight plan elements" etc. shared.

**375-needs-new-content:** nothing new; just the 375-specific knob behavior notes in §2.5 and §2.7.

**AMAPI cross-refs:** same as 355 (Pattern 4 long-press, Pattern 11 persist dial angle, Pattern 15 mouse+touch, etc.). B4 Gap 2 (touchscreen beyond button_add) still applies.

---

### §3 Power-On, Self-Test, and Startup State [pp. 38–52, ~80 lines] — **[FULL]**

- All five sub-sections (power-up, self-test, fuel preset, power-off, database management) apply identically across GPS 175, GNC 355, and GNX 375. Database types, manual/automatic/Concierge updates, SYNC — all identical.
- **[FULL]** — direct transfer.

---

### §4 Display Pages — [Major section ~800 lines]

#### §4.1 Home Page and Page Navigation Model [pp. 17, 28–29, 86] — **[PART]**

- Home page layout, locater bar, back key, Power/Home behavior — all shared.
- **App icon inventory DIFFERS.** 375 adds an XPDR app icon on Home (not present on 355). 355 may have different or no COM-specific icon on Home beyond the persistent standby control panel. Icon inventory needs 375-specific enumeration.
- **375-needs-new-content:** XPDR app icon presence on Home; any 375-specific default locater bar slot 2–3 preferences.

**Open questions:** image-based page; exact icon layout requires device reference or screen captures (same gap the 355 outline flagged).

#### §4.2 Map Page [pp. 113–139, ~200 lines] — **[FULL]** (with tiny adjustments)

- Map user fields default set DIFFERS (355 defaults = distance/ground speed/desired track/track; 375 defaults noted as "different" per 355 outline §4.2 line 196 — exact 375 defaults need to come from Pilot's Guide).
- All other content (map orientation, TOPO, overlays, SafeTaxi, interactions, graphical FPL editing, land/aviation symbols) is identical.
- B4 Gap 1 (canvas-drawn overlays for Smart Airspace + SafeTaxi) still applies.
- **[FULL]** with page-ref edit for default user fields.

#### §4.3 Active Flight Plan (FPL) Page [pp. 140–157, ~150 lines] — **[PART]**

- Waypoint list, active leg coloring, Airport Info shortcut, data columns, Collapse Airways, OBS toggle, Dead Reckoning, Parallel Track, Flight Plan Catalog, User Airport Symbol, Fly-over Waypoint Symbol — all shared.
- **GPS NAV Status indicator key (GPS 175/GNX 375 only, NOT GNC 355) [p. 158]** — flip from "NOT on 355" to PRESENT on 375. This is a 375-relevant feature the 355 outline correctly excluded; 375 outline MUST include as a primary feature.
- **Flight Plan User Field (GNC 355/355A only) [p. 155]** — DELETE for 375. User fields on 375 come from the Map page data corner set, not FPL-specific.
- B4 Gap 2 (scrollable list implementation) still applies.
- 375-needs-new-content: elaboration of GPS NAV Status indicator key functionality.

#### §4.4 Direct-to Page [pp. 159–164, ~60 lines] — **[FULL]**

- Direct-to layout, search tabs, activation, user holds — all shared across units.

#### §4.5 Waypoint Information Pages [pp. 165–178, ~100 lines] — **[FULL]**

- Waypoint types, page layouts, airport tabs (Info/Procedures/Weather/Chart), FastFind, search tabs, USER tab — all shared.
- Note: airport Weather tab on 375 benefits from built-in ADS-B FIS-B reception (no external hardware needed); the "requires FIS-B reception" flag in the 355 outline changes from "external required" to "built-in available." Minor framing change in the open-questions block, not a structural change.

#### §4.6 Nearest Pages [pp. 179–180, ~50 lines] — **[FULL]**

- All nearest types (airports, NDB, VOR, intersection, VRP, ARTCC, FSS) shared. Runway criteria filter shared.

#### §4.7 Procedures Pages [pp. 181–207, ~200 lines] — **[FULL]** (structure; add XPDR-interaction notes)

- Procedures app overview, GPS flight phase annunciations, departure/arrival/approach selection, ILS monitoring, missed approach, approach hold, DME Arc, RF Leg, Vectors to Final, Visual Approach, Autopilot Outputs — all structurally shared.
- **375-needs-new-content (light):** in the Open Questions / flags block, add notes about XPDR altitude reporting during approach and ADS-B traffic display during approach. These are interaction points with the new §11; the §7 structure doesn't change.
- Note: §7 operational workflows section (distinct from §4.7 display pages) gets heavier XPDR/ADS-B interaction content; see §7 below.

#### §4.8 Planning Pages [pp. 209–221, ~80 lines] — **[FULL]**

- VCALC, Fuel Planning, DALT/TAS/Wind, RAIM — all shared.

#### §4.9 Hazard Awareness Pages [pp. 223–269, ~120 lines] — **[PART]** (substantial framing flip)

- **FIS-B Weather page [pp. 225–244]** — structurally shared; framing flips.
  - 355 framing: "Requires external ADS-B receiver (GDL 88 or GTX 345)"
  - 375 framing: "Receiver is built-in; no external hardware required"
  - Product inventory (NEXRAD, METARs, TAFs, AIRMETs, SIGMETs, PIREPs, cloud tops, lightning, CWA, winds/temps aloft, icing, turbulence, TFRs) is identical.
  - Product status, WX Info Banner, setup menu, raw text reports, reception status page — identical structure, updated framing.
- **Traffic Awareness page [pp. 245–256]** — structurally shared; framing flips + aural alerts added.
  - 355 framing: "Requires external ADS-B In (GDL 88, GTX 345) + NO aural alerts"
  - 375 framing: "Built-in dual-link ADS-B In receiver + TSAA traffic application + aural alerts"
  - Traffic display layout, symbol types, setup menu, interactions, annunciations, alerting — identical structure.
  - **375-needs-new-content:** TSAA aural alert behavior, alert-silencing options, interaction with GNX 375 XPDR state (ALT mode required for Mode S reporting).
- **Terrain Awareness page [pp. 257–269]** — **[FULL]**. Terrain works identically across units (all require terrain database; GPS altitude for terrain same; FLTA + PDA same).

**AMAPI cross-refs:** same as 355 — Canvas-drawn overlays are B4 Gap 1; Pattern 17 annunciator visibility applies.

#### §4.10 Settings and System Pages [pp. 86–109, ~80 lines] — **[PART]**

- Pilot Settings layout, CDI Scale [pp. 87–88], System Status, GPS Status [pp. 103–106], Logs [p. 109] — structurally shared.
- **CDI On Screen [p. 89]** — GPS 175 + GNX 375 only; NOT on GNC 355. 375 outline MUST include as a primary feature. 355 outline correctly excluded.
- **ADS-B Status page [pp. 107–108]** — framing flips. 355: "Requires GDL 88 or GTX 345"; 375: "Built-in receiver status; last uplink time; FIS-B WX status; Traffic Application status." Logs section mentions GNX 375 has ADS-B traffic logging (355 has WAAS diagnostic only) — this flips.
- **375-needs-new-content:** CDI On Screen page detail, ADS-B Status reframed for built-in receiver, Logs updated for 375 traffic-logging capability.

#### §4.11 COM Standby Control Panel (GNC 355/355A Only) [pp. 57–74, ~60 lines] — **[355]**

- ENTIRE SUB-SECTION OMITTED from 375 outline. The 375 has no COM radio and no equivalent always-visible control overlay.
- Content stays in shelved 355 outline for eventual 355 resumption.
- **The section number 4.11 in the 375 outline may be repurposed** for something else (e.g., Transponder Control Panel as a persistent overlay) if the 375 has such a feature, OR removed entirely with §4.12+ renumbering. Pilot's Guide should be consulted (pp. 75–85) to determine whether the 375's XPDR has a persistent control-panel overlay like the 355's COM panel. **NEEDS VERIFICATION** during C2.1-375 authoring.

---

### §5 Flight Plan Editing [pp. 144–157, ~200 lines] — **[FULL]**

- Flight Plan Catalog, Create Flight Plan, Waypoint Options, Graphical FPL Editing, OBS Mode, Parallel Track, Dead Reckoning, Airway Handling, Flight Plan Data Fields — all workflows identical across units.
- B4 Gap 2 (scrollable list) still applies.
- Open question about flight plan catalog serialization via Persist API still applies to 375.

---

### §6 Direct-to Operation [pp. 159–164, ~80 lines] — **[FULL]**

- Direct-to basics, search tabs, activation workflows, user holds — all shared.

---

### §7 Procedures [pp. 181–207, ~300 lines] — **[PART]** (structure reuses; adds XPDR/ADS-B interaction content)

- 7.1 Flight Procedure Basics, 7.2 GPS Flight Phase Annunciations, 7.3 Departures, 7.4 Arrivals, 7.5 Approaches, 7.6 Missed Approach, 7.7 Approach Hold, 7.8 Autopilot Outputs — all structurally shared.
- **375-needs-new-content (meaningful):** procedural fidelity augmentations per D-12 Q3c scope expansion:
  - 7.8 or new 7.9: XPDR altitude reporting during approach phase. GNX 375's ALT mode is typically active during approach for Mode C/S altitude reporting to ATC. Spec should document the expected interaction: XPDR ALT mode behavior tied to WOW (weight-on-wheels) state, transition at takeoff/landing, etc.
  - 7.8 or new 7.9: ADS-B traffic display behavior during approach phase. TSAA application interacts with approach-phase flight phase annunciations (OCEANS/ENRT/TERM/DPRT/LNAV+V/LNAV/LP+V/LP/LPV).
  - 7.5 approach sub-section: ADS-B OUT transmission behavior during approach — squitter message set, target state reporting.
  - 7.8 Autopilot Outputs: no meaningful change (roll steering identical).
- Page references for these XPDR/ADS-B interactions come from pp. 75–85 (XPDR) and pp. 245–256 (Traffic) — already in outline scope.

**AMAPI cross-refs:** same as 355.

---

### §8 Nearest Functions [pp. 179–180, ~60 lines] — **[FULL]**

- Identical across units.

---

### §9 Waypoint Information Pages [pp. 165–178, ~120 lines] — **[FULL]**

- Database waypoint types, airport info, VOR/NDB pages, user waypoint create/edit/delete/import, FastFind, search tabs — all identical.
- Open question about user waypoint storage schema (up to 1,000 waypoints) still applies to 375.

---

### §10 Settings / System Pages [pp. 86–109, ~200 lines] — **[PART]**

- 10.1 CDI Scale, 10.2 Airport Runway Criteria, 10.3 Clocks and Timers, 10.4 Page Shortcuts, 10.5 Alerts Settings, 10.6 Unit Selections, 10.7 Display Brightness, 10.8 Scheduled Messages, 10.9 Crossfill, 10.10 Bluetooth, 10.11 GPS Status — all structurally shared.
- 10.1 CDI Scale — add CDI On Screen (per §4.10 above) as a settings-affected feature on 375.
- **10.12 ADS-B Status** — framing flips from "Requires GDL 88 or GTX 345 (for GPS 175/GNC 355)" to "Built-in receiver; status page for uplink time, GPS source, FIS-B WX status, traffic application status." Structural content same; feature-requirement block updates.
- **10.13 Logs** — update: 375 has ADS-B traffic logging (355 has only WAAS diagnostic). Export procedure identical.
- **375-needs-new-content:** new settings sub-section for **XPDR configuration** (if applicable — squawk, mode defaults, Flight ID, VFR squawk code, etc.). This may live in §10 as 10.14 or in the new §11 as part of XPDR operation. Design decision during C2.1-375 authoring.

---

### §11 COM Radio Operation (GNC 355/355A Only) [pp. 57–74, ~200 lines] — **[355]**

- ENTIRE SECTION OMITTED from 375 outline.
- REPLACED WHOLESALE by new §11: **Transponder + ADS-B Operation** — see NEW section below.
- Content stays in shelved 355 outline for eventual 355 resumption.

---

### §11 (NEW for 375) Transponder + ADS-B Operation [pp. 75–85 + ADS-B content throughout] — **[NEW]**

**Full authoring required.** The 355 outline did not cover XPDR because the 355 has no transponder. This is the single largest new-content area for the 375 outline. Estimated ~200 lines of outline content (which will expand to ~300–400 lines of spec body in C2.2).

**Anticipated sub-sections (to be refined during C2.1-375 authoring):**

- 11.1 XPDR Overview [pp. 75–76]: Mode S transponder capability, ADS-B Out via Extended Squitter at 1090 MHz, Mode C altitude reporting. TSO-C112d (Mode S Level 2els) + TSO-C166b (1090 ES).
- 11.2 XPDR Modes: Standby (SBY), On, Altitude Reporting (ALT), Ground (GND), Test (TEST). Mode transitions, WOW-based auto-transitions, pilot-initiated selection.
- 11.3 Squawk Code Entry: keypad entry, 4-digit octal range, invalid code handling, VFR squawk (1200) shortcut, emergency codes (7500/7600/7700) treatment.
- 11.4 IDENT Function: IDENT button press, duration, ATC flash indication, Extended Squitter Flight ID broadcast during IDENT.
- 11.5 Flight ID: assignment during configuration, callsign broadcast via Extended Squitter, relationship to tail number.
- 11.6 Extended Squitter (ADS-B Out): 1090 MHz transmission format, Target State and Status report, Aircraft Operational Status report, TIS-B uplink reception (separate from FIS-B).
- 11.7 Built-in ADS-B In Receiver: dual-link (978 MHz UAT + 1090 MHz ES), FIS-B reception, TIS-B reception, traffic computation.
- 11.8 TSAA Traffic Application: prediction algorithm, advisory/alert thresholds, aural alerts, interaction with approach flight phase.
- 11.9 XPDR Remote Control: G3X Touch remote panel integration (if applicable), airplane-specific configuration.
- 11.10 XPDR Status Indications: active code display, mode indication, reply indicator, IDENT active indicator, failure annunciations.
- 11.11 XPDR Alerts and Status: transponder temperature warning, failure conditions, 1090 ES receiver fault, UAT receiver fault, ADS-B Out fault conditions.
- 11.12 XPDR Configuration: Flight ID setting, VFR code setting, mode defaults, ADS-B Out enable/disable.
- 11.13 XPDR Persistent State: squawk code retained across power cycles, mode setting retained, Flight ID retained.

**AMAPI cross-refs for new §11:**
- `docs/knowledge/amapi_by_use_case.md` §1 (dataref subscriptions for XPDR state, ADS-B status)
- `docs/knowledge/amapi_by_use_case.md` §2 (command dispatch for squawk entry, mode change, IDENT)
- `docs/knowledge/amapi_by_use_case.md` §3 (touchscreen for keypad entry — same patterns as COM frequency keypad in 355 outline §11.4; B4 Gap 2 considerations similar)
- `docs/knowledge/amapi_by_use_case.md` §7 (Txt_add/Txt_set for squawk code display, active mode label)
- `docs/knowledge/amapi_by_use_case.md` §11 (Persist_add for squawk, mode, Flight ID retention)
- `docs/knowledge/amapi_patterns.md` Pattern 1 (triple-dispatch for XPDR actions: XPL command + MSFS event — parallel to COM patterns but for XPDR)
- `docs/knowledge/amapi_patterns.md` Pattern 2 (multi-variable bus for XPDR + ADS-B state)
- `docs/knowledge/amapi_patterns.md` Pattern 14 (parallel XPL + MSFS: XPDR datarefs differ substantially between sims)
- `docs/knowledge/amapi_patterns.md` Pattern 17 (annunciator visibility for XPDR mode, IDENT, failure)
- B4 Gap 3: squawk code digit display may warrant Running_txt_add_hor consultation, similar to COM frequency display.

**Open questions / flags:**
- Exact XPL XPDR dataref names (e.g., `sim/cockpit2/radios/actuators/transponder_code`, `transponder_mode`, `transponder_id`) require verification against current XPL datareftool output.
- MSFS XPDR SimConnect variables (`TRANSPONDER CODE:1`, `TRANSPONDER IDENT`) + XPDR mode representation differ across FS2020 and FS2024; B: event bus may expose additional controls per Pattern 23.
- Remote XPDR control via G3X Touch: hardware-integration scope may be out of scope for v1 software-only instrument (same treatment as 355's remote frequency selection in §11.8).
- TSAA aural alert delivery mechanism in Air Manager: does the instrument emit audio via `sound_play` directly, or does it depend on an external audio panel instrument? This is a spec-body design decision.
- ADS-B In data availability in simulators: X-Plane has partial ADS-B dataref exposure; MSFS has limited ADS-B traffic data beyond the AI traffic stream. Spec must define behavior when data is absent vs. degraded.

---

### §12 Audio, Alerts, and Annunciators [pp. 98–101, ~100 lines] — **[PART]**

- 12.1 Alert Type Hierarchy, 12.2 Annunciator Bar, 12.3 Pop-up Alerts, 12.5 GPS Status Annunciations, 12.6 GPS Alerts, 12.7 Traffic Annunciations, 12.8 Terrain Annunciations — all structurally shared.
- **12.4 Aural Alerts** — framing flips. 355 says "Traffic alerts (GNX 375 only, not GNC 355)"; 375 framing says "Aural traffic alerts present via TSAA application." Structural content same; framing flips.
- **12.9 COM Annunciations (GNC 355/355A)** — DELETE from 375.
- **12.9 (NEW for 375) XPDR Annunciations** — add. Squawk code display, mode indicator (SBY/ON/ALT/GND/TEST), reply indicator, IDENT active indicator, failure annunciations. Reference new §11.

---

### §13 Messages [pp. 271–291, ~150 lines] — **[PART]**

- 13.1 Message System Overview, 13.2 Airspace, 13.3 Database, 13.4 Flight Plan, 13.5 GPS/WAAS, 13.6 Navigation, 13.7 Pilot-Specified, 13.8 System Hardware, 13.10 Terrain, 13.12 VCALC, 13.13 Waypoint — all structurally shared.
- **13.9 COM Radio Advisories (GNC 355 Specific)** — DELETE from 375.
- **13.9 (NEW for 375) XPDR Advisories** — add. Transponder failure advisory, 1090 ES receiver fault, UAT receiver fault, ADS-B Out fault, transponder temperature warning. Sourced from pp. 286 (which in 355 covers COM advisories and also has XPDR advisories per 355 outline §13.11 reference to pp. 288–290). Verify exact page refs during authoring.
- **13.11 Traffic System Advisories** — 355 and 375 have DIFFERENT message sets per Appendix A of the 355 outline. 375's traffic advisories reference the built-in receivers (1090 ES + UAT), not external LRU failures. REFRAME. Page refs stay pp. 288–290; content interpretation flips.

---

### §14 Persistent State [pp. 58, 60, 63, 72, 97, ~50 lines] — **[PART]**

- 14.2 Display and UI State, 14.3 Flight Planning State, 14.4 Scheduled Messages, 14.5 Bluetooth Pairing, 14.6 Crossfill Data — all shared.
- **14.1 COM State (GNC 355/355A)** — DELETE from 375. COM volume, sidetone offset, user frequencies, standby frequency — none apply to 375.
- **14.1 (NEW for 375) XPDR State** — add. Squawk code retained, mode setting retained, Flight ID retained, VFR squawk configuration retained. Page refs from new §11.
- Open question about flight plan catalog serialization via Persist API (scalar-only) still applies to 375.

---

### §15 External I/O (Datarefs and Commands) [N/A — dataref names not in PDF, ~50 lines] — **[PART]** (structural template transfers; all specific API names swap)

- **15.1 XPL Datarefs Reads:** DROP `sim/cockpit2/radios/actuators/com1_frequency_hz`, `com1_standby_hz`, `audio_volume_com0`. ADD `sim/cockpit2/radios/actuators/transponder_code`, `transponder_mode`, `transponder_id`, and ADS-B-related datarefs (TBD exact names).
- **15.2 XPL Datarefs Writes:** DROP COM 1 standby write. ADD XPDR code write, XPDR mode write.
- **15.3 XPL Commands:** DROP COM 1 flip-flop. ADD XPDR IDENT command, XPDR mode-select commands.
- **15.4 MSFS Variables Reads:** DROP `COM ACTIVE FREQUENCY:1`, `COM STANDBY FREQUENCY:1`, `COM VOLUME:1`. ADD `TRANSPONDER CODE:1`, `TRANSPONDER IDENT`, `TRANSPONDER STATE`, ADS-B traffic variables (TBD exact names).
- **15.5 MSFS Events Writes:** DROP `COM1_RADIO_SWAP`, `COM_RADIO_SET_HZ`. ADD `XPNDR_SET`, `XPNDR_IDENT_ON`, `XPNDR_STATE_SET`.
- **15.6 (NEW for 375) Sim-specific notes:** X-Plane's XPDR dataref model differs from MSFS's SimConnect XPDR event model; Pattern 14 (parallel XPL + MSFS with different variable names) applies heavily.

All XPDR dataref/variable exact names require verification during design, as the 355 outline's Open Questions / flags block noted for COM state. The 375 outline's corresponding flag is structurally identical with substitution.

---

### Appendix A: Family Delta [pp. 18–20 + distributed "AVAILABLE WITH" annotations, ~150 lines] — **[PART]** (substantial flip)

- **Baseline flip.** 375 becomes baseline; 355 and GPS 175 become comparison units.
- **A.1 Unit identification and coverage note** — drop the GNC 375 / GNX 375 disambiguation flag (resolved per D-12 and D-02 amendment); add a note pointing back to D-12 for the pivot.
- **A.2 GPS 175 vs. GNX 375 differences:**
  - GPS 175 lacks: Mode S transponder (new §11), ADS-B Out, Extended Squitter, TSAA, aural alerts, ADS-B traffic logging, built-in FIS-B + 1090 ES receivers.
  - GPS 175 adds: nothing (GPS 175 is the minimal unit).
  - All GPS/MFD features: identical to GNX 375.
- **A.3 GNC 355 vs. GNX 375 differences:**
  - GNC 355 lacks: Mode S transponder, ADS-B Out, Extended Squitter, TSAA, aural alerts, ADS-B traffic logging, built-in dual-link receiver, CDI On Screen, GPS NAV Status indicator key.
  - GNC 355 adds: VHF COM radio (355-outline §11), COM Standby Control Panel (355-outline §4.11), 25 kHz channel spacing (355A also has 8.33 kHz), sidetone volume offset, reverse frequency lookup, user frequencies.
- **A.4 (new) GNX 375 variants:** none currently in Pilot's Guide (no GNX 375A equivalent); placeholder if Garmin ever releases a variant.
- **A.5 Feature matrix:** reorder columns with GNX 375 first; features stay the same.

**355 outline Appendix A content fully available for back-port when 355 implementation resumes** — the 355-baseline version of this appendix is preserved as-is in the shelved outline.

---

### Appendix B: Glossary and Abbreviations [pp. 299–304, ~50 lines] — **[FULL]** (with additions)

- Pilot's Guide Glossary content is unit-agnostic.
- **Additions for 375:** Mode S, Mode C, TSAA, 1090 ES, UAT, Extended Squitter, FIS-B, TIS-B, Flight ID, Target State and Status, squawk code, IDENT, WOW (weight-on-wheels).
- AMAPI-specific and Garmin-specific term sections (B.2, B.3) mostly shared; minor updates.

---

### Appendix C: Extraction Gaps and Manual-Review-Required Pages [pp. 1, 36, 110, 125, 208, 222, 270, 271, 292, 298, 308, 309, 310, ~30 lines] — **[FULL]**

- Same sparse/empty page inventory from C1 extraction; no changes.
- C.2 content gaps: the dataref-names gap, map rendering architecture gap, scrollable list gap, Home page icon layout gap all carry over. The GNC 375/GNX 375 disambiguation gap resolves per D-12; drop from 375 appendix.
- Add: XPDR-related pp. 75–85 not previously reviewed in the 355 outline (because XPDR was out of scope for 355). These pages are now in scope; Appendix C should note whether any of them fell into the sparse list from extraction_report.md. Quick check of extraction_report.md during C2.1-375 authoring will resolve this.

---

## 375-Needs-New-Content Synthesis

Consolidated list of content the 375 outline must originate (not derive from the 355 outline):

### Major new section

1. **§11 (NEW): Transponder + ADS-B Operation** (~200 outline lines). Sourced from pp. 75–85 of the Pilot's Guide plus cross-cutting ADS-B content currently distributed across §4.9 (traffic requirements), §10.12 (ADS-B Status), §13.11 (traffic advisories). See §11 breakdown above for anticipated sub-sections.

### Feature-level additions (not entire sections)

2. **CDI On Screen [p. 89]** — 375-only display feature; referenced in both §4.10 (Settings and System display page) and §10.1 (CDI Scale settings).
3. **GPS NAV Status indicator key [p. 158]** — 375-only feature; referenced in §4.3 (FPL page display).
4. **XPDR app icon on Home page** — 375-only Home page icon; referenced in §4.1.
5. **TSAA aural alerts** — 375-only capability; referenced in §4.9 (traffic page), §11 (TSAA sub-section), §12 (aural alerts).
6. **ADS-B traffic logging** — 375-only log type; referenced in §10.13 (Logs).
7. **XPDR alerts/advisories** — 375-only message category; replaces §13.9 COM advisories.

### Procedural fidelity augmentations (§7)

Per D-12 Q3c, full procedural fidelity for instrument approaches is an explicit target. The 355 outline's §7 is structurally sound but thin on several procedural-fidelity concerns that directly support the LPV-approach-flying use case. The 375 outline must expand on these. Flagged here so C2.1-375 authoring doesn't miss them.

#### (A) XPDR + ADS-B interactions during approach

8. **XPDR altitude reporting during approach** — WOW-based mode transitions, ALT mode during approach phase. Likely new §7.9 or interleaved in §7.5 (Approaches).
9. **ADS-B traffic display during approach** — TSAA behavior during approach flight phase, alert suppression considerations.
10. **ADS-B Out transmission during approach** — Target State and Status report behavior.

#### (B) Vertical guidance fidelity

The 355 outline lists the vertical-capable flight phases (LNAV+V, LP+V, LPV, LNAV/VNAV) but does not detail the pilot-facing vertical guidance experience. These are essential for sim-based approach flying:

11. **~~Vertical Deviation Indicator (VDI) display~~ — DROPPED per Turn 20 research.** The GNX 375 has no internal VDI. Pilot's Guide p. 205 explicitly: "Only external CDI/VDI displays provide vertical deviation indications." The 375 OUTPUTS vertical deviation (for LPV/LP+V/LNAV+V/LNAV-VNAV approaches) to external CDI/VDI and to compatible autopilots (p. 207). **Replaced by:** §15 External I/O spec entry for vertical deviation output contract (dataref/event names, update rate, scale semantics). See D-15 and the research document. No on-375 VDI rendering is to be specified.
12. **Glidepath vs. glideslope nomenclature** — Garmin usage: *glideslope* = ILS radio vertical (from NAV receiver, not GPS); *glidepath* = GPS-derived vertical (LPV/LP+V/LNAV+V/LNAV/VNAV). The spec should use Garmin's terminology consistently and document the distinction for pilots who use both interchangeably.
13. **Advisory vs. primary vertical distinction** — +V suffix modes (LNAV+V, LP+V) provide advisory vertical only; pilot still flies to published MDA. LPV provides primary vertical to DA. Display must communicate this distinction (color, annunciation, alert behavior). LNAV/VNAV uses baro-VNAV for vertical — different source, same advisory status as +V suffixes.
14. **ILS approach display behavior (GPS monitoring only) — REFRAMED per Turn 20.** Pilot's Guide p. 198: "ILS and LOC approaches are not approved for GPS. GPS guidance is for monitoring purposes only." Selecting an ILS/LOC approach triggers a pop-up message. The 375 continues to provide GPS lateral monitoring on the annunciator bar. There is no VDI to hide/show on the 375 (item 11 dropped). External CDI/HSI follows the NAV receiver (the 375 has no NAV radio). Spec needs: pop-up behavior on ILS load, flight phase annunciations during ILS (likely stays TERM/LPV-unavailable), any "VLOC" source indication if the 375 communicates with the external CDI's NAV/GPS source switch.
15. **Approach mode transitions** — LPV → LNAV downgrade on integrity loss (HAL/VAL exceedance), LP → LNAV+V downgrade, LNAV/VNAV → LNAV on baro-VNAV loss. Each transition has a pilot-visible annunciation, possibly a message queue entry, a VDI behavior change. Spec needs these transitions enumerated.
16. **CDI scale auto-switching by flight phase — KEEP with clarification per Turn 20.** Per Pilot's Guide p. 87: Auto CDI scale follows en route 2.0 nm → terminal 1.0 nm (within 31 nm of destination, linear ramp over 1 nm) → approach angular scale (tightens from 1.0 nm to approach-defined angular full-scale deflection at 2.0 nm before FAF; typically 2.0° angular, p. 87). Manual settings (0.30 / 1.00 / 2.00 nm) cap the upper end per flight phase. HAL limits track scale per p. 88 table. The 375 OUTPUTS this scale to external CDI/HSI and also annunciates the current scale on the annunciator bar and the optional on-screen CDI. Spec must document BOTH the output contract and the on-screen annunciation.

#### (C) Full procedural features (waypoint sequencing, course guidance)

17. **Turn anticipation / waypoint sequencing alert** — as aircraft approaches a turn waypoint, the 375 alerts the pilot (visual, and via aural on GNX 375 via TSAA) that a turn is imminent. Typically 10 seconds before the turn, with fly-by waypoints starting the turn early to capture the outbound course. Spec needs: alert timing, visual manifestation (annunciation? countdown timer?), interaction with fly-by vs. fly-over waypoints.
18. **Fly-by vs. fly-over waypoint turn behavior** — the 355 outline §4.3 mentions the Fly-over Waypoint Symbol [p. 157]. Spec needs the behavioral distinction: fly-by = anticipate the turn and cut the corner to capture the outbound course smoothly; fly-over = overfly the waypoint before turning. Affects how the system computes and displays the turn.
19. **Active leg transition visual feedback** — when the aircraft crosses from one leg to the next, the magenta "active leg" indicator advances. Timing, visual transition (snap? fade?), CDI scale behavior during transition. Spec needs the UX detail.
20. **ARINC 424 leg type handling** — published procedures use TF (track-to-fix), CF (course-to-fix), DF (direct-to-fix), RF (radius-to-fix), VA (heading-to-altitude), CA (course-to-altitude), HA/HF/HM (holding), etc. The 355 outline §7.5 mentions RF legs but doesn't enumerate the set. Spec needs a list of supported leg types and the display/guidance behavior per type.
21. **Altitude constraints on flight plan legs — REFRAMED AS OPEN QUESTION per Turn 20 research.** Pilot's Guide does not prominently document automatic display of published procedure altitude restrictions. VCALC (pp. 211–212) is a separate pilot-input planning tool, NOT automatic from procedure data. Spec authoring should flag this as an open question: "Whether the 375 displays published altitude constraints on flight plan legs (cross at/above/below/between) is not documented in the extracted PDF. Research needed or flag as behavior unknown."
22. **Approach arming vs. active states** — when an approach is loaded, the system is in "approach armed" state (terminal CDI scale, GPS lateral only). Crossing the FAF triggers "approach active" (approach-mode CDI scale, vertical guidance engaged if applicable). The arming/activation state transition is a significant pilot-visible event with annunciation, scale change, and possibly autopilot mode change. Spec needs this state machine.
23. **CDI deviation display (pilot-visible rendering) — REFRAMED per Turn 20 research.** The 375 has:
    - **Optional on-screen lateral CDI** via "CDI On Screen" toggle (p. 89, GPS 175 + GNX 375 only). Renders below the GPS NAV Status indicator key. Lateral deviation only; no vertical. Uses the CDI Scale setting (p. 87). Only shows when an active flight plan exists.
    - **Primary external CDI/HSI** driven by the 375's lateral-deviation output. The pilot's primary tactical nav reference during approach is the external CDI, not the on-375 optional CDI.
    Spec needs: on-screen CDI rendering (small lateral indicator, scale annotation); clear documentation that the primary CDI is external; output contract for external CDI in §15. No integration with VDI on the 375 itself because there is no on-375 VDI.
24. **"To/From" flag rendering — REFRAMED per Turn 20.** Per Pilot's Guide p. 183, the 375 displays a FROM/TO field on the annunciator bar (in addition to outputting TO/FROM to the external CDI). Composite-type external CDIs only get "TO" indications — the annunciator bar FROM/TO field is the authoritative source for the pilot. Spec needs: annunciator-bar FROM/TO field behavior, external CDI TO/FROM output contract, and the composite-CDI caveat.
25. **Autopilot coupling during approach** — the 355 outline §7.8 mentions roll steering terminates when approach mode selected. For full procedural fidelity, spec needs the autopilot-mode interaction during approach: GPSS roll steering through terminal, heading mode for vectors-to-final, approach-mode coupling for LPV glidepath. Likely dataref-heavy, research-required during design.

### Framing flips (no new sub-sections; framing/feature-requirement language changes)

11. **§4.9 Hazard Awareness** — built-in receiver framing (was external-dependent).
12. **§10.12 ADS-B Status** — built-in receiver framing.
13. **§12.4 Aural Alerts** — aural alerts present (was 375-only exclusion).
14. **§13.11 Traffic System Advisories** — 375-specific message set.
15. **Appendix A** — 375 as baseline.

---

## Content to Remove from 375 Outline

Wholesale removals (content preserved in shelved 355 outline for eventual 355 resumption):

1. **§4.11 COM Standby Control Panel** (~60 outline lines)
2. **§11 COM Radio Operation** (~200 outline lines) — replaced by new XPDR+ADS-B §11
3. **§12.9 COM Annunciations** (~10 outline lines) — replaced by new XPDR Annunciations
4. **§13.9 COM Radio Advisories (GNC 355 Specific)** (~10 outline lines) — replaced by new XPDR Advisories
5. **§14.1 COM State persistence** (~10 outline lines) — replaced by new XPDR State persistence
6. **§15 COM-related datarefs/variables/events** (~15 outline lines within §15.1–15.5) — replaced by XPDR/ADS-B datarefs/variables/events
7. **§4.3 Flight Plan User Field (GNC 355/355A only)** [p. 155] (~3 outline lines)
8. **§1.1 8.33 kHz channel spacing mention** (355A-specific) — drop from product description

Total wholesale removals: ~308 outline lines.

---

## Content to Reframe/Flip for 375

Structural content transfers; framing language or feature-requirement blocks flip:

1. **§1.1 Product description** — flip baseline from COM to XPDR+ADS-B
2. **§2.5 Control knob functions (inner knob push)** — knob sequence differs
3. **§2.7 Knob shortcuts** — 375 uses Direct-to pattern
4. **§4.2 Map Page default user fields** — 375 defaults differ from 355
5. **§4.9 Hazard Awareness** — external → built-in receiver framing
6. **§10.12 ADS-B Status** — external → built-in framing
7. **§10.13 Logs** — update for 375 traffic logging
8. **§12.4 Aural Alerts** — present on 375
9. **§13.11 Traffic System Advisories** — 375-specific message set
10. **Appendix A Family Delta** — baseline flip to 375

---

## Recommendations for C2.1-375 Task Prompt

The harvest supports a focused CC task prompt. Suggested emphasis:

### Explicit scope directives

- Primary unit: **GNX 375**. GPS 175 and GNC 355/355A are comparison units in Appendix A only.
- Pilot's Guide coverage: all pp. 1–310 of `assets/gnc355_pdf_extracted/text_by_page.json` are in scope, with special attention to **pp. 75–85 (XPDR)** which were out of scope for the 355 outline.
- **Full procedural fidelity target:** §7 Procedures MUST include XPDR + ADS-B interaction content supporting LPV approach flying in the sim.
- **ADS-B as primary, not external:** §4.9, §10.12, §13.11 must frame ADS-B In/Out as built-in features, not external-hardware-dependent.

### Reference material CC should consult

- **This harvest map** (`docs/knowledge/355_to_375_outline_harvest_map.md`) — primary categorization guide.
- **Shelved 355 outline** (`docs/specs/GNC355_Functional_Spec_V1_outline.md`) — reference for [FULL] sections. CC copies structure, page refs, and sub-bullet content verbatim where indicated.
- **PDF content** via `assets/gnc355_pdf_extracted/text_by_page.json` — fresh read for [NEW] content (XPDR pp. 75–85, ADS-B cross-cutting content).
- **AMAPI knowledge** (`docs/knowledge/amapi_by_use_case.md`, `docs/knowledge/amapi_patterns.md`) — cross-refs carry over; XPDR + ADS-B subscription/dispatch patterns follow same idioms as COM.

### Section-by-section directive hints

- **§1–3:** structural template from 355 outline with language flips per §1 notes above.
- **§4:** walk sub-sections per this harvest map; §4.1, §4.3, §4.9, §4.10 need the identified edits; §4.11 drops; other sub-sections [FULL].
- **§5, §6, §8, §9:** full transfer from 355 outline.
- **§7:** full transfer PLUS new procedural fidelity content.
- **§10:** full transfer with §10.12, §10.13, and XPDR-config additions.
- **§11:** new authoring from pp. 75–85 + cross-cutting ADS-B content.
- **§12, §13, §14, §15:** partial transfer with the flips and additions identified.
- **Appendix A:** baseline flip authoring.
- **Appendix B:** additions to glossary.
- **Appendix C:** full transfer minus resolved GNC 375/GNX 375 flag.

### Anti-drift directives

- Sub-bullets remain noun phrases / topic descriptors, NOT prose paragraphs (same constraint as 355 outline).
- Page references [pp. N] throughout.
- AMAPI cross-refs in each section.
- Open questions / flags sub-section where applicable.
- Format recommendation paragraph at top (piecewise / monolithic / one-task-per-section TBD per D-13 after outline reviewed).

### Anticipated total length

~2,750–2,850 lines (similar to 355 outline; net-flat after subtractions + additions).

### Anticipated deliverable

`docs/specs/GNX375_Functional_Spec_V1_outline.md`

---

## Harvest meta-notes

- Harvest authored in one CD turn (~30 min) per Turn 18 efficiency rationale.
- Pivot watched con #3 from `pivot_355_to_375_rationale.md` (harvest-step scope creep) NOT triggered; harvest stayed within time-box.
- This document is working material for the C2.1-375 task. It is not re-reviewed via `/spec-review` (not a technical spec). If C2.1-375 compliance surfaces a harvest-map error (e.g., "this [FULL] section is actually [PART] because X"), CD updates this document and re-runs the affected portion of the C2.1-375 task.
- Decision log: this turn wrote no new D-NN entry. Harvest execution is an implementation step of D-12's Option 5; no new decisions emerged.
