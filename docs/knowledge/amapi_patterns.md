---
Created: 2026-04-20T00:00:00Z
Source: docs/tasks/amapi_patterns_prompt.md
---

# AMAPI Pattern Catalog

**Derived from:** 6 Tier 1 + 8 Tier 2 instrument samples per `docs/knowledge/instrument_samples_b2_subset_selection.md`.

**Companion documents:**
- [AMAPI by Use Case](amapi_by_use_case.md) — task-oriented function index
- [AMAPI Function Inventory](amapi_function_inventory.md) — authoritative function list
- Per-function reference: `docs/reference/amapi/by_function/`
- [Sample Appendix](amapi_patterns_sample_appendix.md) — per-sample notes and sample-specific techniques

## How to use this document

Each pattern describes an idiom used in practice by real AMAPI instruments. The pattern entry includes: the problem it solves, a code sketch, live cross-references to every AMAPI function used, a list of exemplar samples, and notes on variants or caveats.

When authoring the GNC 355 Design Spec, reach for this catalog when you need HOW — for WHICH function to use in the first place, see the [use-case index](amapi_by_use_case.md).

---

## Pattern index

### Category: Writing to the simulator

| # | Pattern | Samples | Description |
|---|---|:---:|---|
| [1](#pattern-1-triple-dispatch-buttondial) | Triple-dispatch button/dial | 5/6 T1 | Every pilot action fires XPL + FSX + MSFS commands in one callback |
| [18](#pattern-18-dual-xpl_command-native--rxp-plugin) | Dual xpl_command (native + RXP plugin) | 2/6 T1 | Each XPL action fires both sim-native and RXP-plugin commands |
| [19](#pattern-19-xpl_command-beginend-for-held-key-actions) | xpl_command BEGIN/END for held-key | 2/6 T1 | Press fires BEGIN; release fires END for continuous XPL commands |
| [23](#pattern-23-fs2024-b-event-dispatch) | FS2024 B: event dispatch | 2/8 T2 | FS2024-specific bus events use `B:` prefix distinct from H: events |
| [24](#pattern-24-l-lvar-in-msfsxpl-subscriptions-and-writes) | L: LVAR subscriptions and writes | 2/8 T2 + 1/6 T1 | Subscribe to and write MSFS local variables alongside SimConnect vars |

### Category: Reading simulator state

| # | Pattern | Samples | Description |
|---|---|:---:|---|
| [2](#pattern-2-multi-variable-subscription-bus) | Multi-variable subscription bus | 5/6 T1 | One subscribe call delivers many variables to a single callback |
| [3](#pattern-3-fs2024-reuses-fs2020-callback) | FS2024 reuses FS2020 callback | 3/6 T1 | fs2024_variable_subscribe wired to the same callback as fs2020 |
| [14](#pattern-14-parallel-xpl--msfs-subscriptions-for-same-state) | Parallel XPL + MSFS subscriptions | 2/6 T1 | Same state subscribed via both XPL and MSFS APIs; different callbacks |
| [22](#pattern-22-fsxmsfs-sim-adapter-normalization-function) | FSX/MSFS sim-adapter normalization | 3/8 T2 + 2/6 T1 | FSX adapter translates FSX data scale/format to XPL-equivalent before display |

### Category: Touchscreen / button input

| # | Pattern | Samples | Description |
|---|---|:---:|---|
| [4](#pattern-4-long-press-button-via-timer) | Long-press button via timer | 4/6 T1 | Press starts a timer; release checks if timer still running to distinguish short vs. long |

### Category: Knob / hardware dial input

| # | Pattern | Samples | Description |
|---|---|:---:|---|
| [11](#pattern-11-persist-dial-angle-across-sessions) | Persist dial angle across sessions | 2/6 T1 | Rotary knob angle saved to persist store; restored on startup via style string |
| [15](#pattern-15-mouse_setting--touch_setting-pair-on-dials) | mouse_setting + touch_setting pair | 2/6 T1 | Dials always pair mouse click-rotate with touch rotate-tick settings |
| [20](#pattern-20-detent-type-user-prop-for-hw_dial_add) | Detent-type user prop for hw_dial_add | 4/8 T2 | Enum user prop selects hardware rotary detent count; drives hw_dial_add |
| [21](#pattern-21-hw_dial_add-for-hardware-rotary-encoder) | hw_dial_add for hardware rotary encoder | 4/8 T2 | Bind a hardware knob alongside the virtual dial for Knobster/encoder support |

### Category: Visual state management

| # | Pattern | Samples | Description |
|---|---|:---:|---|
| [6](#pattern-6-power-state-group-visibility) | Power-state group visibility | 3/6 T1 | group_add all display elements; toggle group visibility on power state change |
| [7](#pattern-7-rotate-for-analog-display) | Rotate-for-analog display | 3/6 T1 | Map a sim variable linearly to image rotation degrees for needles/dials |
| [8](#pattern-8-img_add-with-initial-style-string) | img_add with initial style string | 3/6 T1 | img_add 6th arg sets initial visual state (visibility, angle, animation params) |
| [10](#pattern-10-daynight-group-opacity-via-si-backlight) | Day/night group opacity via si backlight | 2/6 T1 | Night and day image groups wired to SI backlight_intensity via opacity() |
| [17](#pattern-17-annunciator-visible-pattern) | Annunciator visible pattern | 2/6 T1 | Annunciator images start hidden; subscription callback toggles visibility per state |

### Category: Sound

| # | Pattern | Samples | Description |
|---|---|:---:|---|
| [16](#pattern-16-sound-on-state-change) | Sound on state change | 2/6 T1 | Track previous sim state; play sound in subscription callback on transition |

### Category: User properties / instrument configuration

| # | Pattern | Samples | Description |
|---|---|:---:|---|
| [5](#pattern-5-multi-instance-device-id-suffix) | Multi-instance device ID suffix | 3/6 T1 | Integer user prop lets multiple identical instruments share one panel |
| [9](#pattern-9-user-prop-boolean-feature-toggle) | User-prop boolean feature toggle | 3/6 T1 | Boolean user prop conditionally adds UI elements at startup |

### Category: Persistence

| # | Pattern | Samples | Description |
|---|---|:---:|---|
| [11](#pattern-11-persist-dial-angle-across-sessions) | Persist dial angle across sessions | 2/6 T1 | (Also in Knob input category; cross-referenced here) |

### Category: Instrument metadata / platform detection

| # | Pattern | Samples | Description |
|---|---|:---:|---|
| [12](#pattern-12-feature-detection-guard) | Feature-detection guard (has_feature) | 2/6 T1 | Guard optional API (e.g., VIDEO_STREAM) with has_feature() before calling |
| [13](#pattern-13-platform-conditional-canvas-message) | Platform-conditional canvas message | 2/6 T1 | Show different canvas content based on PLATFORM instrument_prop |

---

## Category: Writing to the simulator

### Pattern 1: Triple-dispatch button/dial

**Problem.** An instrument must work on X-Plane, FSX/P3D, and MSFS simultaneously. Each simulator uses a different API for the same pilot action.

**Solution.** Every button and dial callback unconditionally fires the XPL command, the FSX event, and the MSFS event in sequence — without checking which sim is connected. Dead calls on the inactive sim are harmless.

**Code sketch.**
```lua
local function btn_direct_callback()
    xpl_command("sim/GPS/g1000n" .. device_id_xpl .. "_direct")
    fsx_event("GPS_DIRECT_TO_BUTTON", device_id_rxp_fsx)
    msfs_event("H:AS530_DirectTo" .. device_id_pms)
end

button_add("btn_direct.png", nil, 410, 10, 90, 48, btn_direct_callback)
```

**Functions used.**
- [`xpl_command`](../reference/amapi/by_function/Xpl_command.md) — fires the X-Plane command by name; optional BEGIN/END arg for held commands
- [`fsx_event`](../reference/amapi/by_function/Fsx_event.md) — fires an FSX/P3D SimConnect event; second arg is event data value
- [`msfs_event`](../reference/amapi/by_function/Msfs_event.md) — fires an MSFS SimConnect event (H: bus); second arg is event value
- [`button_add`](../reference/amapi/by_function/Button_add.md) — registers press callback (and optional release callback)

**Exemplars.** The following samples use this pattern:
- `generic_garmin-gtn-650_1ae7feb5` — every pilot-action button (home, direct, push-top, push-bottom) and dial (vol, FMS outer, FMS inner) triple-dispatches
- `generic_garmin-gns-530_72b0d55c` — all 15+ buttons dispatch to XPL and MSFS (no FSX on this instrument)
- `generic_garmin-gns-430_24038c68` — identical structure to GNS 530
- `generic_bendixking-kap-140-autopilot-system_da394c59` — all AP mode buttons triple-dispatch to XPL + MSFS
- `generic_bendixking-kx-165a-ts0-com1nav1_a6f6d3b9` — full five-sim variant (XPL + FSX + FS2020/2024)

**Variants.**
- *Dual-sim (XPL + MSFS):* GNS 530/430 and KAP 140 omit the `fsx_event` call (instrument is scoped to XPL + MSFS only). The pattern still applies; just fewer dispatches.
- *Five-sim (XPL + FSX + P3D + FS2020 + FS2024):* KX 165A fires all three APIs. `fsx_event` covers both FSX and P3D; `msfs_event` covers both FS2020 and FS2024.
- *MSFS-only:* GFC 500 uses only `msfs_event` — no XPL or FSX calls. Not a triple-dispatch instrument.

**Caveats.** The "dead call" approach assumes that calling xpl_command when MSFS is connected (and vice versa) has no side effects. This is guaranteed by the AMAPI framework — each sim API call is silently ignored when that sim is not connected.

**GNC 355 relevance.** The GNC 355 targets X-Plane + MSFS. Every pilot action (button press, knob rotation, touchscreen tap) should use the dual-dispatch variant: `xpl_command` + `msfs_event`. The multi-instance device ID suffix (Pattern 5) may also apply if the instrument supports panel configurations with 2 GNC 355 units.

---

### Pattern 18: Dual xpl_command (native + RXP plugin)

**Problem.** X-Plane GPS instruments may be driven by the default sim GPS or by a third-party RXP plugin. A single XPL command only reaches one implementation.

**Solution.** Fire two `xpl_command` calls per button: the native X-Plane command (`"sim/GPS/..."`) and the RXP plugin command (`"RXP/GNS/..."`). Both are always fired; only the active GPS implementation responds.

**Code sketch.**
```lua
local function btn_direct_callback()
    xpl_command("sim/GPS/g430n1_direct")        -- native X-Plane GPS
    xpl_command("RXP/GNS/G430_1/DIRECTTO")      -- RealityXP GNS plugin
    msfs_event("H:AS530_DirectTo")
end
```

**Functions used.**
- [`xpl_command`](../reference/amapi/by_function/Xpl_command.md) — called twice per action with different command namespaces

**Exemplars.**
- `generic_garmin-gns-530_72b0d55c` — every button fires both `"sim/GPS/g530n..."` and `"RXP/GNS/G530_N/..."` commands
- `generic_garmin-gns-430_24038c68` — identical structure for GNS 430 equivalents

**Caveats.** The RXP command namespace is specific to the RealityXP GNS plugin. Commands sent to an unrecognized namespace are silently discarded by X-Plane. This pattern is unnecessary for non-GPS instruments or instruments that don't have a major aftermarket XPL plugin alternative.

**GNC 355 relevance.** The GNC 355 is itself a GPS navigator. If a RXP/GTN or similar plugin exposes a compatible command bus, this pattern would apply. Current GNC 355 spec scopes to native sim APIs only; dual-command may be added if plugin compatibility is required.

---

### Pattern 19: xpl_command BEGIN/END for held-key actions

**Problem.** Some X-Plane commands (e.g., CLR button held for menu exit) use a "begin" + "end" event pair to detect press-and-hold duration.

**Solution.** In the press callback, fire `xpl_command("...", "BEGIN")`. In the release callback, fire `xpl_command("...", "END")`. The instrument does not need to track the duration — X-Plane handles the semantic.

**Code sketch.**
```lua
local function clr_press()
    xpl_command("sim/GPS/g530n1_clr", "BEGIN")
    xpl_command("RXP/GNS/G530_1/CLR", "BEGIN")
    timer_start(2000, nil, clr_long_press_callback)
end

local function clr_release()
    xpl_command("sim/GPS/g530n1_clr", "END")
    xpl_command("RXP/GNS/G530_1/CLR", "END")
    if timer_running(tmr_clr) then
        timer_stop(tmr_clr)
        -- short press action here
    end
end

button_add("btn_clr.png", nil, x, y, w, h, clr_press, clr_release)
```

**Functions used.**
- [`xpl_command`](../reference/amapi/by_function/Xpl_command.md) — second arg `"BEGIN"` or `"END"` signals press state to X-Plane
- [`button_add`](../reference/amapi/by_function/Button_add.md) — provides separate press and release callbacks
- [`timer_start`](../reference/amapi/by_function/Timer_start.md) — (when combined with long-press detection per Pattern 4)
- [`timer_running`](../reference/amapi/by_function/Timer_running.md), [`timer_stop`](../reference/amapi/by_function/Timer_stop.md) — guard and cancel

**Exemplars.**
- `generic_garmin-gns-530_72b0d55c` — CLR button fires BEGIN/END on press/release; often combined with a long-press timer
- `generic_garmin-gns-430_24038c68` — identical CLR button pattern

**Caveats.** This pattern applies only to X-Plane commands that support the BEGIN/END semantic. The MSFS equivalent for held actions is typically handled via a separate long-press timer (Pattern 4) that fires different MSFS events for short vs. long press.

**GNC 355 relevance.** The GNC 355 has a CLR button that requires held-key detection for multi-level menu exit. This pattern will be used for the XPL command dispatch; a timer-based approach (Pattern 4) will handle the MSFS dispatch side.

---

### Pattern 23: FS2024 B: event dispatch

**Problem.** FS2024 introduced a separate event bus (`B:` prefix) for certain avionics actions, distinct from the SimConnect H: event bus used by FS2020.

**Solution.** When targeting FS2024, fire a `B:` prefixed event via `msfs_event` (or `fs2024_event`) in addition to or instead of the H: event. Survey FS2024 instruments to identify which actions use B: vs. H: events.

**Code sketch.**
```lua
local function btn_com_swap()
    -- FS2020 event bus
    msfs_event("H:AS1000_MID_COM_Radio_1_BTN_Push")
    -- FS2024 bus event (B: prefix)
    fs2024_event("B:AS1000_MID_COM_Radio_1_BTN_Push_EventID")
end
```

**Functions used.**
- [`msfs_event`](../reference/amapi/by_function/Msfs_event.md) — fires H: events (FS2020 compatible)
- [`Fs2024_event`](../reference/amapi/by_function/Fs2024_event.md) — fires B: bus events for FS2024-specific avionics

**Exemplars.**
- `generic_garmin-gma-1347d-audio-panel_965144b1` — audio panel COM/NAV selector buttons use both H: and B: dispatch for FS2024 compatibility
- `cessna-172_switch-panel_0fb7ea63` — switch events use B: prefix for FS2024

**Caveats.** B: event names are avionics-specific and change per aircraft/avionics package. This pattern requires knowing the FS2024 B: event name for the target avionics system — not always documented in MSFS SDK.

**GNC 355 relevance.** If the GNC 355 spec targets FS2024's Working Title G3X/GNC implementation, B: event dispatch will be required for some avionics interactions. The FS2024 event names for the GNC 355 should be researched during design.

---

### Pattern 24: L: LVAR in MSFS/FSX subscriptions and writes

**Problem.** Some MSFS aircraft behaviors are controlled by LVAR (local variable) gauge code rather than SimConnect variables. Standard `A:` or `H:` APIs cannot access these.

**Solution.** AMAPI `msfs_variable_subscribe` and `msfs_variable_write` accept `L:` prefixed variable names, allowing instruments to read and write LVARs alongside standard SimConnect variables.

**Code sketch.**
```lua
-- Subscribe to an LVAR alongside standard SimConnect vars
msfs_variable_subscribe(
    "AIRSPEED INDICATED", "knots",
    "L:XMLVAR_VNAVBUTTONVALUE", "Number",
    "L:AS1000_MID_Display_Backup_Active", "Number",
    ap_state_callback
)

-- Write an LVAR directly
msfs_variable_write("L:SF50_vnav_enable", "Number", 1)
```

**Functions used.**
- [`msfs_variable_subscribe`](../reference/amapi/by_function/Msfs_variable_subscribe.md) — accepts `L:` prefixed names alongside standard `A:` variables
- [`msfs_variable_write`](../reference/amapi/by_function/Msfs_variable_write.md) — writes a value to an LVAR by name

**Exemplars.**
- `generic_garmin-gfc-500-autopilot_c154321a` — `L:XMLVAR_VNAVBUTTONVALUE` subscribed to read VNAV state; `L:SF50_vnav_enable` write commented out as aircraft-specific variant
- `generic_garmin-gma-1347d-audio-panel_965144b1` — audio panel uses L: variables for FS2024 COM/NAV routing state
- `cessna-172_heading_079a54d1` — heading bug LVAR read from subscription for heading sync

**Caveats.** LVARs are aircraft-specific and undocumented in most MSFS SDK references. Their names must be discovered via MSFS developer mode variable inspection. LVAR support depends on the WASM/Gauge module running in the aircraft — if the aircraft doesn't define the LVAR, the subscription returns 0.

**GNC 355 relevance.** The GNC 355 on MSFS (Working Title GNS530 mod or native Garmin avionics) likely exposes LVARs for display state, active frequency, and CDI source. These will be needed for the MSFS subscription side of the instrument.

---

## Category: Reading simulator state

### Pattern 2: Multi-variable subscription bus

**Problem.** A stateful instrument (autopilot, COM/NAV radio) needs to display many sim variables simultaneously. Setting up separate subscription calls for each variable is verbose and creates many callback functions.

**Solution.** A single subscription call registers multiple variables — alternating variable-name and type-string pairs — all delivered to one callback function. The callback receives all values as positional parameters on each fire.

**Code sketch.**
```lua
local function new_xpl_data(
    alt_indicated, alt_setting, vs_fpm,
    ap_on, ap_hdg_mode, ap_nav_mode, ap_alt_mode,
    hdg_bug, alt_bug, vs_bug,
    nav1_has_gs, nav1_gs_flag, on_glideslope,
    gps_overrides_nav1, nav1_bearing, pitch_angle, roll_angle
)
    -- update all display elements
    txt_set(txt_alt, string.format("%d", alt_indicated))
    visible(img_ap_annun, ap_on > 0)
    -- ... more updates
end

xpl_dataref_subscribe(
    "sim/flightmodel/position/indicated_altitude", "FLOAT",
    "sim/cockpit/misc/barometer_setting",          "FLOAT",
    "sim/flightmodel/position/vh_ind_fpm",         "FLOAT",
    "sim/cockpit2/autopilot/autopilot_on",         "INT",
    "sim/cockpit2/autopilot/heading_mode",         "INT",
    -- ... more variables ...
    new_xpl_data
)
```

**Functions used.**
- [`xpl_dataref_subscribe`](../reference/amapi/by_function/Xpl_dataref_subscribe.md) — XPL multi-variable subscription; vararg pairs + callback at end
- [`fs2020_variable_subscribe`](../reference/amapi/by_function/Fs2020_variable_subscribe.md) — MSFS multi-variable subscription (same signature)
- [`fs2024_variable_subscribe`](../reference/amapi/by_function/Fs2024_variable_subscribe.md) — FS2024 subscription (same callback reuse per Pattern 3)
- [`fsx_variable_subscribe`](../reference/amapi/by_function/Fsx_variable_subscribe.md) — FSX subscription (same pattern; different variable names)
- [`msfs_variable_subscribe`](../reference/amapi/by_function/Msfs_variable_subscribe.md) — generic MSFS subscription (covers FS2020 + FS2024 in one call)

**Exemplars.**
- `generic_bendixking-kap-140-autopilot-system_da394c59` — 17 XPL variables → `new_xpl_data`; 21 MSFS variables → `new_fs2020_data`
- `generic_bendixking-kx-165a-ts0-com1nav1_a6f6d3b9` — 16 XPL vars + 10 FSX vars + 14 MSFS vars, each with its own callback
- `generic_garmin-gns-530_72b0d55c` — COM/NAV volume subscribed separately (2-var bus each) alongside state subscriptions
- `generic_garmin-gfc-500-autopilot_c154321a` — 17 MSFS variables → `ap_cb` (MSFS-only)
- `cessna-172_heading_079a54d1` (Tier 2) — heading + heading bug subscribed together in one bus

**Variants.**
- *Small bus (2–5 vars):* Audio panels and simpler instruments use 2–5 variable buses; the pattern still applies.
- *Single-var subscription:* For a truly isolated variable (e.g., XPL version string), a 1-var subscription is fine — same API, just one pair before the callback.

**Caveats.** All variables in a bus are delivered simultaneously on each update. If variables update at different frequencies, all are delivered at the rate of the fastest-changing one. Splitting high-frequency variables into a separate bus from slow-changing ones can reduce CPU load.

**GNC 355 relevance.** Core pattern for the GNC 355 display. The instrument will need to subscribe to: active/standby COM frequency, active/standby NAV frequency, GPS state, CDI source, OBS angle, NAV bearing, course deviation, flag states, and power state — likely 15–25 variables total across XPL and MSFS buses.

---

### Pattern 3: FS2024 reuses FS2020 callback

**Problem.** FS2024 exposes the same SimConnect variable names as FS2020 for most avionics data. Maintaining two separate callback functions for the same display logic duplicates code.

**Solution.** Register `fs2024_variable_subscribe` with the same variable list and the same callback function as `fs2020_variable_subscribe`. The AMAPI framework delivers FS2024 data to the same handler. No code duplication in the display logic.

**Code sketch.**
```lua
local function new_avionics_data(freq_active, freq_standby, power)
    txt_set(txt_active, string.format("%.3f", freq_active / 1000))
    txt_set(txt_stby,   string.format("%.3f", freq_standby / 1000))
    visible(group_display, power > 0)
end

-- FS2020 subscription
fs2020_variable_subscribe(
    "COM ACTIVE FREQUENCY:1", "Hz",
    "COM STANDBY FREQUENCY:1", "Hz",
    "AVIONICS MASTER SWITCH", "Bool",
    new_avionics_data
)

-- FS2024 uses the same callback — no duplicate logic needed
fs2024_variable_subscribe(
    "COM ACTIVE FREQUENCY:1", "Hz",
    "COM STANDBY FREQUENCY:1", "Hz",
    "AVIONICS MASTER SWITCH", "Bool",
    new_avionics_data   -- same function reference
)
```

**Functions used.**
- [`fs2020_variable_subscribe`](../reference/amapi/by_function/Fs2020_variable_subscribe.md) — subscribes to FS2020 SimConnect variables
- [`fs2024_variable_subscribe`](../reference/amapi/by_function/Fs2024_variable_subscribe.md) — subscribes to FS2024 SimConnect variables; accepts same callback

**Exemplars.**
- `generic_bendixking-kap-140-autopilot-system_da394c59` — `fs2024_variable_subscribe(..., new_fs2020_data)` — explicit reuse of the FS2020 callback
- `generic_bendixking-kx-165a-ts0-com1nav1_a6f6d3b9` — same pattern; 14 variables shared between FS2020 and FS2024 subs
- `generic_garmin-gfc-500-autopilot_c154321a` — uses `msfs_variable_subscribe` which covers both FS2020 and FS2024 in a single call (variant)

**Variants.**
- *Single msfs_variable_subscribe:* If the instrument targets only MSFS (not XPL), use `msfs_variable_subscribe` — it covers both FS2020 and FS2024 automatically with one call. The explicit dual-subscription (Pattern 3) is only needed when the instrument also targets XPL (requiring separate `xpl_dataref_subscribe`).
- *Different FS2024 variable set:* A few FS2024 instruments expose additional variables not in FS2020 (e.g., COM TRANSMIT:3). In this case, use separate callbacks with the FS2024 one having more parameters.

**GNC 355 relevance.** If the GNC 355 supports both FS2020 and FS2024 via explicit subs (not the generic msfs call), FS2024 should reuse the FS2020 callback wherever variable names are identical.

---

### Pattern 14: Parallel XPL + MSFS subscriptions for same state

**Problem.** An instrument reads the same logical state (e.g., COM volume) from two different simulators, each with different API calls and different variable names for the same thing.

**Solution.** Subscribe to the state via both `xpl_dataref_subscribe` and `msfs_variable_subscribe`, each wired to a separate update callback. The callbacks each call the same display-update helper, normalizing any scale differences first.

**Code sketch.**
```lua
local function update_com_vol(vol)
    rotate(img_com_vol, 15 + var_cap(vol, 0, 1) * 250)
end

-- X-Plane: volume as 0.0–1.0 float
xpl_dataref_subscribe(
    "sim/cockpit2/radios/actuators/audio_volume_com0", "FLOAT",
    function(v) update_com_vol(v) end
)

-- MSFS: volume as 0–100 percent
msfs_variable_subscribe(
    "COM VOLUME:1", "Percent",
    function(v) update_com_vol(v / 100) end
)
```

**Functions used.**
- [`xpl_dataref_subscribe`](../reference/amapi/by_function/Xpl_dataref_subscribe.md) — subscribes to the XPL version of the variable
- [`msfs_variable_subscribe`](../reference/amapi/by_function/Msfs_variable_subscribe.md) — subscribes to the MSFS version of the same logical state
- [`rotate`](../reference/amapi/by_function/Rotate.md) — display update target (in this example)
- [`var_cap`](../reference/amapi/by_function/Var_cap.md) — clamp value to valid range

**Exemplars.**
- `generic_garmin-gns-530_72b0d55c` — COM volume and NAV volume each have parallel XPL + MSFS subscriptions
- `generic_garmin-gns-430_24038c68` — identical parallel subscription structure

**Caveats.** The two callbacks may fire at different rates if the sims update their respective variables at different intervals. The display should tolerate this gracefully (it usually does — display just updates when data arrives). On sim switch, only one subscription path is active; the other's callback never fires.

**GNC 355 relevance.** If the GNC 355 displays any state that has different variable names in XPL vs. MSFS (e.g., active COM frequency, CDI source), this pattern applies. The XPL and MSFS subscriptions will need separate callbacks that normalize to a common format before display.

---

### Pattern 22: FSX/MSFS sim-adapter normalization function

**Problem.** FSX delivers some variables in a different scale or format than X-Plane (e.g., COM frequency as MHz float in FSX vs. integer Hz in XPL). Handling the discrepancy inside the main display function complicates it.

**Solution.** Write a thin adapter callback for FSX (and P3D) that normalizes FSX-specific data formats and delegates to the XPL-compatible display function. The adapter is wired as the FSX subscription callback; the display function remains sim-agnostic.

**Code sketch.**
```lua
-- Display function expects integer Hz (XPL format)
local function new_navcomm(com_active_hz, com_stby_hz, nav_active_hz, nav_stby_hz, pwr)
    txt_set(txt_com,  string.format("%.3f", com_active_hz / 1000000))
    txt_set(txt_comstby, string.format("%.3f", com_stby_hz  / 1000000))
    visible(group_powered, pwr > 0)
end

-- FSX adapter: MHz float → Hz int, bool → int
local function new_navcom_fsx(com_active_mhz, com_stby_mhz, nav_active_mhz, nav_stby_mhz, pwr_bool)
    new_navcomm(
        math.floor(com_active_mhz * 1000000),
        math.floor(com_stby_mhz  * 1000000),
        math.floor(nav_active_mhz * 1000000),
        math.floor(nav_stby_mhz  * 1000000),
        fif(pwr_bool, 1, 0)   -- bool → int
    )
end

xpl_dataref_subscribe("COM ACTIVE FREQUENCY", "Hz", ..., new_navcomm)
fsx_variable_subscribe("COM ACTIVE FREQUENCY:1", "MHz", ..., new_navcom_fsx)
```

**Functions used.**
- [`fsx_variable_subscribe`](../reference/amapi/by_function/Fsx_variable_subscribe.md) — FSX subscription; adapter function as callback
- [`xpl_dataref_subscribe`](../reference/amapi/by_function/Xpl_dataref_subscribe.md) — XPL subscription; canonical display function as callback

**Exemplars.**
- `generic_bendixking-kx-165a-ts0-com1nav1_a6f6d3b9` — `new_navcom_fsx()` normalizes FSX MHz floats + boolean power to XPL Hz integers + integer power; delegates to `new_navcomm()`
- `cessna-172_heading_079a54d1` (Tier 2) — heading data normalized from FSX degrees-float to integer format
- `cessna-172_altimeter_cf5829f6` (Tier 2) — barometric pressure normalized from FSX inHg float

**Caveats.** FSX targeting is increasingly rare in new instruments (FSX is legacy). New GNC 355 development can omit FSX support unless explicitly required.

**GNC 355 relevance.** Low priority — GNC 355 scope is XPL + MSFS. If FSX support is ever added, this adapter pattern would normalize FSX frequency formats to the XPL Hz integer format used by the main display function.

---

## Category: Touchscreen / button input

### Pattern 4: Long-press button via timer

**Problem.** A button must distinguish a short press from a long press (e.g., HOME short = menu back, HOME long = direct-to home waypoint).

**Solution.** In the press callback, start a timer with the long-press threshold duration. In the release callback, check if the timer is still running — if yes, it was a short press (cancel timer, fire short action); if no, the timer already fired the long-press action. The timer callback contains the long-press action.

**Code sketch.**
```lua
local tmr_home

local function home_long_press()
    xpl_command("sim/GPS/g1000n1_home_long")
    msfs_event("H:GTN650_HOME_LONG")
end

local function home_press()
    timer_stop(tmr_home)
    tmr_home = timer_start(1500, nil, home_long_press)
end

local function home_release()
    if timer_running(tmr_home) then
        timer_stop(tmr_home)
        -- short press action
        xpl_command("sim/GPS/g1000n1_home")
        msfs_event("H:GTN650_HOME")
    end
    -- if timer not running, long press already fired
end

button_add("btn_home.png", nil, x, y, w, h, home_press, home_release)
```

**Functions used.**
- [`button_add`](../reference/amapi/by_function/Button_add.md) — provides separate press and release callbacks via 7th and 8th arguments
- [`timer_start`](../reference/amapi/by_function/Timer_start.md) — starts the long-press detection countdown (first arg = delay ms, second = nil for one-shot)
- [`timer_stop`](../reference/amapi/by_function/Timer_stop.md) — cancels the timer on early release
- [`timer_running`](../reference/amapi/by_function/Timer_running.md) — tests whether the timer is still pending in the release callback

**Exemplars.**
- `generic_garmin-gtn-650_1ae7feb5` — HOME button (1500ms threshold) and FMS push-bottom (500ms threshold)
- `generic_garmin-gns-530_72b0d55c` — CLR button (2000ms threshold for multi-level menu clear); also combined with BEGIN/END (Pattern 19)
- `generic_garmin-gns-430_24038c68` — same CLR button pattern
- `generic_bendixking-kap-140-autopilot-system_da394c59` — ALT button long-press for altitude-select mode

**Variants.**
- *Combined with BEGIN/END (Pattern 19):* The GNS 530 CLR button fires `xpl_command("...", "BEGIN")` on press and `xpl_command("...", "END")` on release, with the long-press timer also running. The timer determines which MSFS action to fire; the BEGIN/END determines the XPL held-key behavior.
- *Different thresholds:* HOME uses 1500ms; FMS push uses 500ms; CLR uses 2000ms. The threshold depends on the UX intent (accidental-trigger prevention vs. responsiveness).

**Caveats.** If the user holds the button and the long-press fires, the release callback must not also fire the short-press action — the `timer_running` check prevents this correctly. Do not skip the `timer_stop` in the press callback; stale timers from rapid double-presses can cause ghost actions.

**GNC 355 relevance.** The GNC 355 touchscreen has several buttons that distinguish short vs. long press: CRSR (on/off vs. menu exit), CLR (back one level vs. return to root), and MENU (page menu vs. main menu). This pattern will be used for all of them.

---

## Category: Knob / hardware dial input

### Pattern 11: Persist dial angle across sessions

**Problem.** A rotary knob's visual angle represents meaningful state (e.g., COM frequency cursor position) that should survive instrument reload and panel restart.

**Solution.** Use `persist_add` to register the angle storage slot. On every rotation, `persist_put` updates the stored angle. At startup, read with `persist_get` and include the value in the `img_add` style string (`"angle_z:N"`) to initialize the image at the correct angle. Also call `rotate(img, persist_get(...))` after creation to sync the runtime rotation state.

**Code sketch.**
```lua
local prs_angle_outer = persist_add("outer_angle", 0)

local img_dial_outer = img_add("rotary_outer.png", x, y, w, h,
    "angle_z:" .. persist_get(prs_angle_outer))

local function outer_rotate(direction)
    local new_angle = persist_get(prs_angle_outer) + direction * 5
    persist_put(prs_angle_outer, new_angle)
    rotate(img_dial_outer, new_angle)
    -- dispatch to sim...
end

local dial_outer = dial_add("dial_outer.png", x, y, w, h, outer_rotate)
```

**Functions used.**
- [`persist_add`](../reference/amapi/by_function/Persist_add.md) — registers a named persist slot with a default value; returns a handle
- [`persist_get`](../reference/amapi/by_function/Persist_get.md) — reads the current persisted value
- [`persist_put`](../reference/amapi/by_function/Persist_put.md) — writes a new value to the persist slot
- [`img_add`](../reference/amapi/by_function/Img_add.md) — style string arg (6th) sets `"angle_z:N"` for initial angle restore
- [`rotate`](../reference/amapi/by_function/Rotate.md) — updates the image rotation at runtime
- [`dial_add`](../reference/amapi/by_function/Dial_add.md) — registers the rotation callback

**Exemplars.**
- `generic_garmin-gns-530_72b0d55c` — `prs_angle_left` and `prs_angle_right` for the two outer concentric dials
- `generic_garmin-gns-430_24038c68` — identical structure for GNS 430 dual dials

**Caveats.** The angle is stored in degrees. `persist_add` default value is the starting angle (0 = unrotated). If the step size in `outer_rotate` (5°) doesn't divide evenly into 360, the stored angle will drift over many sessions — acceptable for visual state, but not for instruments that derive position from angle arithmetic.

**GNC 355 relevance.** The GNC 355 has a concentric outer/inner knob (FMS knob) for data entry. Both the outer and inner knob angles should be persisted if they represent display cursor position or frequency cursor state that should survive session restarts.

---

### Pattern 15: mouse_setting + touch_setting pair on dials

**Problem.** A dial must respond to both mouse-click rotation (desktop) and touch-based rotation (tablet/touchscreen). The two input methods have different sensitivity settings.

**Solution.** After creating a dial, always apply both `mouse_setting(dial, "CLICK_ROTATE", N)` and `touch_setting(dial, "ROTATE_TICK", N)` with appropriate sensitivity values. These two calls always appear together on the same dial.

**Code sketch.**
```lua
local dial_outer = dial_add("dial_outer.png", x, y, w, h, outer_rotate_callback)
mouse_setting(dial_outer, "CLICK_ROTATE", 5)   -- 5° per mouse click
touch_setting(dial_outer, "ROTATE_TICK", 5)    -- 5° per touch tick
```

**Functions used.**
- [`dial_add`](../reference/amapi/by_function/Dial_add.md) — creates the virtual dial widget and registers its callback
- [`mouse_setting`](../reference/amapi/by_function/Mouse_setting.md) — configures mouse interaction mode and sensitivity
- [`touch_setting`](../reference/amapi/by_function/Touch_setting.md) — configures touch interaction mode and sensitivity

**Exemplars.**
- `generic_garmin-gns-530_72b0d55c` — COM/NAV outer dials (C/V outer) and page outer dials each get the mouse+touch pair
- `generic_garmin-gns-430_24038c68` — same pairing for equivalent dials

**Caveats.** The `mouse_setting` `"CLICK_ROTATE"` mode fires the callback each N degrees of mouse drag. The `touch_setting` `"ROTATE_TICK"` fires per touch gesture tick. The N value need not be identical between mouse and touch, though in practice instruments use the same value (5° in GNS 530/430). Omitting `touch_setting` on a touchscreen panel will make the dial unresponsive to touch input.

**GNC 355 relevance.** The GNC 355 outer/inner FMS knob should have both settings. Given the GNC 355 is primarily a touchscreen instrument (with a physical knob), the `touch_setting` for the virtual dial and a `hw_dial_add` (Pattern 21) for Knobster hardware are both applicable.

---

### Pattern 20: Detent-type user prop for hw_dial_add

**Problem.** Hardware rotary encoders (Knobster, similar) have different hardware detent configurations — 1, 2, or 4 pulses per physical click depending on the encoder model. The instrument needs to match.

**Solution.** Expose an enum user property with the detent options. At startup, read the property, look up the corresponding `TYPE_N_DETENT_PER_PULSE` constant in a table, and pass it to `hw_dial_add`.

**Code sketch.**
```lua
local up_detent = user_prop_add_enum(
    "Detent setting",
    "1 detent/pulse,2 detents/pulse,4 detents/pulse",
    "1 detent/pulse",
    "Match your rotary encoder hardware"
)

local detent_settings = {
    ["1 detent/pulse"] = TYPE_1_DETENT_PER_PULSE,
    ["2 detents/pulse"] = TYPE_2_DETENTS_PER_PULSE,
    ["4 detents/pulse"] = TYPE_4_DETENTS_PER_PULSE,
}

local hw_dial = hw_dial_add("hw_outer_knob", detent_settings[user_prop_get(up_detent)], 1, outer_rotate_callback)
```

**Functions used.**
- [`user_prop_add_enum`](../reference/amapi/by_function/User_prop_add_enum.md) — creates a dropdown of string options in the instrument configuration panel
- [`user_prop_get`](../reference/amapi/by_function/User_prop_get.md) — reads the selected option string at startup
- `hw_dial_add` — registers a hardware rotary encoder binding (see Pattern 21)

**Exemplars.**
- `cessna-172_altimeter_cf5829f6` — `up_detent` enum drives altimeter inner knob `hw_dial_add`
- `cessna-172_vor-nav1ils_94a0e896` — same detent pattern for VOR OBS knob
- `cessna-172_adf_04a6aa5d` — same detent pattern for ADF frequency knob
- `cessna-172_heading_079a54d1` — same detent pattern for heading bug knob

**Caveats.** The enum option strings must exactly match the keys used in the Lua table lookup. `user_prop_get` returns the string value of the selected option. This pattern is only relevant when `hw_dial_add` is also used (Pattern 21); without hardware binding, the detent setting does nothing.

**GNC 355 relevance.** If the GNC 355 instrument supports Knobster or similar hardware encoder for the FMS knob, this detent pattern should be included as a user-configurable option.

---

### Pattern 21: hw_dial_add for hardware rotary encoder

**Problem.** Some Air Manager users have physical rotary encoder hardware (Knobster, DIY encoders) that should drive the instrument's knobs independently of the mouse/touch virtual dial.

**Solution.** Use `hw_dial_add` to bind a named hardware knob to a callback, alongside the existing `dial_add` virtual knob. Both share the same callback function. The detent type (Pattern 20) configures the hardware pulse count.

**Code sketch.**
```lua
local function outer_rotate(direction)
    -- direction: +1 or -1
    persist_put(prs_angle, persist_get(prs_angle) + direction * 5)
    rotate(img_outer, persist_get(prs_angle))
    xpl_command("sim/GPS/g530n1_coarse_" .. fif(direction > 0, "up", "down"))
    msfs_event("H:AS530_COARSE_" .. fif(direction > 0, "INC", "DEC"))
end

-- Virtual dial (mouse/touch)
local virt_dial = dial_add("dial_outer.png", x, y, w, h, outer_rotate)
mouse_setting(virt_dial, "CLICK_ROTATE", 5)
touch_setting(virt_dial, "ROTATE_TICK", 5)

-- Hardware encoder binding
hw_dial_add("outer_knob", detent_settings[user_prop_get(up_detent)], 1, outer_rotate)
```

**Functions used.**
- `hw_dial_add` — binds a named hardware encoder to a callback; args: name, detent type, step, callback
- [`dial_add`](../reference/amapi/by_function/Dial_add.md) — virtual dial for mouse/touch (see Pattern 15)
- [`user_prop_get`](../reference/amapi/by_function/User_prop_get.md) — reads detent setting for `hw_dial_add` (see Pattern 20)

**Exemplars.**
- `cessna-172_altimeter_cf5829f6` — altimeter knob has both `dial_add` and `hw_dial_add`
- `cessna-172_vor-nav1ils_94a0e896` — VOR OBS knob dual binding
- `cessna-172_adf_04a6aa5d` — ADF frequency knob dual binding
- `cessna-172_heading_079a54d1` — heading bug knob dual binding

**Caveats.** `hw_dial_add` requires the user to configure their hardware in Air Manager's device panel (assign the physical encoder to the named slot). If no hardware is mapped, `hw_dial_add` simply does nothing — it doesn't break the instrument.

**GNC 355 relevance.** Medium priority. Include `hw_dial_add` alongside `dial_add` for the FMS outer and inner knobs if Knobster/encoder support is desired. Pair with the detent-type user prop (Pattern 20).

---

## Category: Visual state management

### Pattern 6: Power-state group visibility

**Problem.** An instrument's entire display (all LCD text, annunciators, needle images) should appear and disappear as a unit when the avionics master switch toggles. Toggling each element individually is verbose and error-prone.

**Solution.** Add all display elements to a group with `group_add`. Assign the result to a variable. In the subscription callback, call `visible(group, power_state)` once to show or hide all elements.

**Code sketch.**
```lua
local txt_com   = txt_add("----.--", {}, x1, y1, w1, h1)
local txt_stby  = txt_add("----.--", {}, x2, y2, w2, h2)
local img_led   = img_add("led.png", x3, y3, w3, h3, "visible:false")

local group_display = group_add(txt_com, txt_stby, img_led)
visible(group_display, false)   -- start hidden

local function on_state(com_freq, stby_freq, avionics_on)
    visible(group_display, avionics_on > 0)
    txt_set(txt_com,  string.format("%.3f", com_freq  / 1e6))
    txt_set(txt_stby, string.format("%.3f", stby_freq / 1e6))
end
```

**Functions used.**
- [`group_add`](../reference/amapi/by_function/Group_add.md) — creates a group from any number of node handles; returns a group handle
- [`visible`](../reference/amapi/by_function/Visible.md) — toggles visibility of a node or group; called with the group handle
- [`img_add`](../reference/amapi/by_function/Img_add.md) — individual elements that become group members

**Exemplars.**
- `generic_bendixking-kap-140-autopilot-system_da394c59` — `item_group` contains all 6 LCD text items; `visible(item_group, gbl_power)` on every state update
- `generic_bendixking-kx-165a-ts0-com1nav1_a6f6d3b9` — `group_powered` contains all COM/NAV display elements; starts hidden, shown when power is on
- `generic_garmin-gfc-500-autopilot_c154321a` — uses `opacity(img_backlight, ...)` as the power indicator; explicit visibility group for YD elements

**Variants.**
- *Gated via `opacity`:* The GFC 500 fades the backlight image to opacity 0 rather than using `visible(group, false)`. This creates a smooth power-off animation vs. instant hide.
- *Per-element visibility:* Some instruments set `visible(img, false)` on each element individually, without a group. This is more verbose but provides finer per-element control.

**Caveats.** `group_add` in AMAPI creates a logical group, not a visual container with layout. The group handle only supports `visible()`, `opacity()`, and `remove()` — not position or size operations.

**GNC 355 relevance.** The GNC 355 display powers on/off with the avionics master. Group all display elements (frequency readouts, CDI indicator, annunciators) so the power-state transition is a single `visible(group_display, avionics_on)` call.

---

### Pattern 7: Rotate-for-analog display

**Problem.** An instrument displays an analog value (heading, altitude, COM volume) by rotating a needle or dial image. The sim value (a float or integer in sim units) must be mapped to a rotation angle in degrees.

**Solution.** In the subscription callback, compute a rotation angle as a linear map of the sim value, then call `rotate(img, angle)`. The mapping formula (`base_angle + value * scale`) is instrument-specific.

**Code sketch.**
```lua
local img_com_vol = img_add("knob_vol.png", x, y, w, h,
    "rotate_animation_type: LINEAR; rotate_animation_speed: 0.05")

local function on_com_vol(vol_xpl)
    -- XPL: vol is 0.0–1.0; map to 15°–265° (250° range)
    rotate(img_com_vol, 15 + var_cap(vol_xpl, 0, 1) * 250)
end

-- MSFS delivers 0–100 percent — different scale
local function on_com_vol_msfs(vol_pct)
    rotate(img_com_vol, 15 + var_cap(vol_pct, 0, 100) * 2.5)
end
```

**Functions used.**
- [`rotate`](../reference/amapi/by_function/Rotate.md) — sets the rotation angle of an image node (degrees, clockwise)
- [`img_add`](../reference/amapi/by_function/Img_add.md) — creates the needle/dial image; style string can include animation params (see Pattern 8)
- [`var_cap`](../reference/amapi/by_function/Var_cap.md) — clamps value to valid range before scaling

**Exemplars.**
- `generic_garmin-gns-530_72b0d55c` — volume dial knob rotated by COM and NAV volume subscriptions
- `generic_garmin-gns-430_24038c68` — same pattern for GNS 430 volume dials
- `generic_bendixking-kx-165a-ts0-com1nav1_a6f6d3b9` — `rotate(img_com_vol, 15 + com_vol * 250)` for XPL; `15 + com_vol * 2.5` for MSFS (different scale)
- `cessna-172_altimeter_cf5829f6` (Tier 2) — altimeter needle rotation maps altitude to degrees
- `cessna-172_heading_079a54d1` (Tier 2) — heading bug needle rotation

**Variants.**
- *Smooth animation:* Include `"rotate_animation_type: LOG"` or `"LINEAR"` in the `img_add` style string (Pattern 8) — the image then animates to each new angle rather than snapping.
- *Power-off snap:* Call `rotate(img, 0)` when power is off to snap the needle to the zero position.

**GNC 355 relevance.** If the GNC 355 includes any analog needle display (CDI deviation needle, bearing needle, OBS indicator), this pattern applies. The CDI deviation would map course deviation dots (±2 dots = ±full deflection) to a rotation angle.

---

### Pattern 8: img_add with initial style string

**Problem.** An image needs a non-default initial visual state (hidden, pre-rotated, with animation parameters) at the moment of creation — without requiring a separate `visible()` or `rotate()` call immediately after.

**Solution.** Pass a CSS-like style string as the 6th argument to `img_add`. The string can set `visible`, `angle_z`, and rotation animation parameters. This initializes the image in the correct state atomically at creation time.

**Code sketch.**
```lua
-- Hidden annunciator — no separate visible() call needed
local img_ap = img_add("ap_light.png", x1, y1, 24, 24, "visible:false")

-- Pre-rotated dial with smooth animation
local img_dial = img_add("needle.png", x2, y2, 80, 80,
    "angle_z:45; rotate_animation_type: LOG; rotate_animation_speed: 0.08; rotate_animation_direction: FASTEST")

-- Initial angle restored from persist
local img_rotary = img_add("rotary.png", x3, y3, 60, 60,
    "angle_z:" .. persist_get(prs_angle))
```

**Functions used.**
- [`img_add`](../reference/amapi/by_function/Img_add.md) — 6th argument is a semicolon-delimited style string. Supported properties include: `visible`, `angle_z`, `rotate_animation_type` (LOG|LINEAR), `rotate_animation_speed`, `rotate_animation_direction` (FASTEST|CLOCKWISE|COUNTERCLOCKWISE)

**Exemplars.**
- `generic_bendixking-kap-140-autopilot-system_da394c59` — all 12 annunciator images initialized with `"visible:false"`
- `generic_garmin-gns-530_72b0d55c` — rotary images initialized with `"angle_z:" .. persist_get(...)` for angle restore
- `generic_garmin-gns-430_24038c68` — same persist-angle initialization
- `cessna-172_altimeter_cf5829f6` (Tier 2) — `"rotate_animation_type: LOG; rotate_animation_speed: 0.08; rotate_animation_direction: FASTEST"` for smooth needle movement

**Caveats.** The style string format is undocumented in the AMAPI reference but observed consistently across samples. Semicolons delimit properties; spaces around `:` and `;` appear to be accepted. Unknown property names are silently ignored.

**GNC 355 relevance.** Any CDI/OBS needle images should include animation parameters. Annunciator images (GPS/NAV flag, alert annunciators) should be initialized with `"visible:false"`.

---

### Pattern 10: Day/night group opacity via si backlight

**Problem.** An instrument must display different visual themes for day (bright cockpit) and night (dimmed cockpit). The transition should be smooth and system-driven, not manually controlled.

**Solution.** Create two `group_add` groups — one containing night-mode images, one for day-mode images. Subscribe to `"si/backlight_intensity"` via `si_variable_subscribe`. In the callback, set `opacity(group_night, intensity)` and `opacity(group_day, 1 - intensity)`. As backlight intensity goes from 0→1, night images fade in and day images fade out.

**Code sketch.**
```lua
local img_day_bezel   = img_add("bezel_day.png",   x, y, w, h)
local img_night_leds  = img_add("leds_night.png",  x, y, w, h)
local img_night_bezel = img_add("bezel_night.png", x, y, w, h)

local group_day   = group_add(img_day_bezel)
local group_night = group_add(img_night_leds, img_night_bezel)

si_variable_subscribe("si/backlight_intensity", "DOUBLE", function(intensity)
    opacity(group_night, intensity)
    opacity(group_day,   1 - intensity)
end)
```

**Functions used.**
- [`si_variable_subscribe`](../reference/amapi/by_function/Si_variable_subscribe.md) — subscribes to the Air Manager system variable `si/backlight_intensity`; callback fires when user changes backlight slider
- [`group_add`](../reference/amapi/by_function/Group_add.md) — groups day or night images so all are affected by a single `opacity()` call
- [`opacity`](../reference/amapi/by_function/Opacity.md) — sets transparency of a node or group (0.0 = transparent, 1.0 = opaque)

**Exemplars.**
- `generic_garmin-gns-530_72b0d55c` — night images (LED rings, night dial variant) vs. day images (day dial); backlight drives crossfade
- `generic_garmin-gns-430_24038c68` — identical day/night crossfade structure

**Caveats.** `si/backlight_intensity` is an Air Manager system variable, not a simulator variable — it's set by the Air Manager backlight slider in the panel editor, not by the sim's cockpit lighting state. If you need to respond to in-sim cockpit lighting, subscribe to an XPL dataref (e.g., `"sim/graphics/misc/cockpit_light_level"`) or MSFS variable instead.

**GNC 355 relevance.** Include day/night theming for the GNC 355 bezel and button labels. The display itself (OLED/LCD content) may be always-on but the surrounding panel elements benefit from day/night crossfade.

---

### Pattern 17: Annunciator visible pattern

**Problem.** An instrument shows state-based annunciator lights (AP, HDG, NAV, ALT on an autopilot; COM TX on a radio). Each annunciator must appear when its condition is true and disappear otherwise.

**Solution.** Create annunciator images with `img_add("light.png", ..., "visible:false")` to start hidden. In the subscription callback, call `visible(img, condition)` for each annunciator based on the relevant state variable.

**Code sketch.**
```lua
local img_ap  = img_add("ap_annun.png",  x1, y1, 32, 32, "visible:false")
local img_hdg = img_add("hdg_annun.png", x2, y2, 32, 32, "visible:false")
local img_nav = img_add("nav_annun.png", x3, y3, 32, 32, "visible:false")

local function on_ap_state(ap_engaged, hdg_mode, nav_mode, alt_mode)
    visible(img_ap,  ap_engaged > 0)
    visible(img_hdg, hdg_mode == 2)
    visible(img_nav, nav_mode == 2)
end
```

**Functions used.**
- [`img_add`](../reference/amapi/by_function/Img_add.md) — creates annunciator image; `"visible:false"` style string for initial state
- [`visible`](../reference/amapi/by_function/Visible.md) — boolean show/hide of the annunciator; second arg is a boolean or numeric expression

**Exemplars.**
- `generic_bendixking-kap-140-autopilot-system_da394c59` — 12 annunciators (AP, HDG, NAV, APR, REV, ALT, ARM, BARO, deviation lights); all start hidden, toggled in `new_xpl_data` and `new_fs2020_data`
- `generic_garmin-gfc-500-autopilot_c154321a` — white triangle annunciators for each AP mode; `visible(img_tri, mode_active)` in `ap_cb`
- `generic_garmin-340-audio-panel_d30c0bb4` (Tier 2) — COM/NAV active/transmit annunciators
- `generic_garmin-gma-1347d-audio-panel_965144b1` (Tier 2) — extensive annunciator array for audio routing state

**Caveats.** `visible()` accepts a boolean, integer, or expression. When the sim value is an integer (0/1), `visible(img, state > 0)` converts cleanly. Avoid passing float values directly — AMAPI may interpret a float close to zero as truthy.

**GNC 355 relevance.** The GNC 355 has GPS/NAV flag annunciators (TO/FROM, CDI source, active leg annunciator). All should use this pattern. The GPS and VLOC annunciators are among the most important display elements.

---

## Category: Sound

### Pattern 16: Sound on state change

**Problem.** An instrument plays an alert sound when the simulator enters a specific state (autopilot disconnect, altitude reached). The sound should fire once on transition, not on every subscription callback fire.

**Solution.** Maintain a global variable tracking the previous state. In the subscription callback, compare old vs. new state; call `sound_play(snd)` only when a transition is detected. Update the old-state variable after the comparison.

**Code sketch.**
```lua
local snd_disconnect = sound_add("disconnect.wav")
local old_ap_mode = 0

local function on_ap_state(ap_engaged, altitude_alert, ...)
    -- transition: autopilot just disengaged
    if old_ap_mode > 0 and ap_engaged == 0 then
        sound_play(snd_disconnect)
    end
    -- transition: altitude alert just triggered
    if altitude_alert > 0 and old_alt_alert == 0 then
        sound_play(snd_alert)
    end
    old_ap_mode   = ap_engaged
    old_alt_alert = altitude_alert
end
```

**Functions used.**
- [`sound_add`](../reference/amapi/by_function/Sound_add.md) — loads a sound file from the instrument's resources folder; returns a handle
- [`sound_play`](../reference/amapi/by_function/Sound_play.md) — plays the loaded sound; can be called with optional volume/pan args

**Exemplars.**
- `generic_bendixking-kap-140-autopilot-system_da394c59` — plays `snd_2seconds` (disconnect beep) when `new_xpl_data` detects `old_autopilot_mode > 0 && ap_on == 0`; `snd_5beeps` for altitude deviation
- `generic_garmin-gfc-500-autopilot_c154321a` — plays `press_snd` / `release_snd` / `dial_snd` on every interaction (not state-change — see note)

**Variants.**
- *Interaction sound (GFC 500):* Rather than state-change detection, the GFC 500 plays a sound on every button press and release via the shared release callback. The "silence.wav fallback" sub-pattern (see appendix) means the `sound_play` call is always safe.
- *Counted blink timer + sound:* The KAP 140 coordinates sound with a counted blink timer for altitude deviation alerts — the timer fires 5 times (5 beeps); each timer callback plays one beep.

**GNC 355 relevance.** The GNC 355 does not have a speaker, but its surrounding panel instrument host may. If the instrument spec includes alert sounds (e.g., message annunciator alert tone), this state-transition pattern should be used.

---

## Category: User properties / instrument configuration

### Pattern 5: Multi-instance device ID suffix

**Problem.** A panel may have two or more identical instruments (e.g., two GTN 650s for pilot and copilot). Their sim commands must be addressable independently.

**Solution.** Add an integer user property (Device ID 1 or 2). At startup, derive three suffix variants from it: an XPL command suffix, an FSX event offset, and an MSFS event name suffix. Append these to every command/event dispatch in callbacks.

**Code sketch.**
```lua
local prop_device_id = user_prop_add_integer("Device ID", 1, 1, 2,
    "1 = pilot side; 2 = copilot side")

-- Compute suffix forms at startup
local device_id        = user_prop_get(prop_device_id)
local device_id_xpl    = "_" .. tostring(device_id)           -- "_1" or "_2"
local device_id_rxp_fsx = fif(device_id == 1, 0, 8)          -- 0 or 8 (RXP FSX offset)
local device_id_pms    = fif(device_id == 1, "", "_2")        -- "" or "_2"

-- Use in callbacks
local function btn_direct_callback()
    xpl_command("sim/GPS/g1000n" .. device_id_xpl .. "_direct")
    fsx_event("GPS_DIRECT_TO_BUTTON", device_id_rxp_fsx)
    msfs_event("H:AS530_DirectTo" .. device_id_pms)
end
```

**Functions used.**
- [`user_prop_add_integer`](../reference/amapi/by_function/User_prop_add_integer.md) — exposes the Device ID as a panel-configuration control; args: name, default, min, max, description
- [`user_prop_get`](../reference/amapi/by_function/User_prop_get.md) — reads the selected value at startup

**Exemplars.**
- `generic_garmin-gtn-650_1ae7feb5` — Device ID 1–2; three suffix forms for XPL, FSX, and MSFS dispatches
- `generic_garmin-gns-530_72b0d55c` — Unit 1–2; used in XPL and RXP command strings
- `generic_garmin-gns-430_24038c68` — same unit-ID suffix pattern

**Caveats.** The suffix encoding (XPL uses `_1`/`_2`, FSX uses `0`/`8`, MSFS uses `""`/`"_2"`) is specific to each GPS family's sim integration. The encoding must be researched against the target instrument's sim plugin documentation.

**GNC 355 relevance.** If the GNC 355 instrument spec supports pilot/copilot dual-panel configurations, include a Device ID user property. The XPL command namespace for the GNC 355 (`RXP/GTN/...` or `sim/GNS/...`) will determine the encoding.

---

### Pattern 9: User-prop boolean feature toggle

**Problem.** The instrument has optional UI features (e.g., YD button, Knobster hardware support, audio feedback) that not all users need. Hardcoding them wastes panel space or requires the user to dismiss an unwanted element.

**Solution.** Add a `user_prop_add_boolean` for each optional feature. At instrument startup, read the prop and conditionally create the UI elements — `button_add`, `img_add`, `dial_add`, `hw_dial_add` — only if the prop is true. Uncreated elements don't exist in the DOM and don't consume any resources.

**Code sketch.**
```lua
local up_yd_shown    = user_prop_add_boolean("Show YD button",  true, "Show the Yaw Damper button")
local up_knobster    = user_prop_add_boolean("Knobster support", false, "Enable hardware knob binding")
local up_play_sounds = user_prop_add_boolean("Play Sounds",      true, "Click sounds on interaction")

-- YD button exists only if prop is true
if user_prop_get(up_yd_shown) then
    local img_yd_btn = img_add("yd_btn.png", x, y, w, h, "visible:false")
    button_add(nil, "yd_btn_pressed.png", x, y, w, h, yd_callback)
end

-- Knobster hw binding exists only if prop is true
if user_prop_get(up_knobster) then
    hw_dial_add("outer_knob", detent_settings[user_prop_get(up_detent)], 1, outer_callback)
end
```

**Functions used.**
- [`user_prop_add_boolean`](../reference/amapi/by_function/User_prop_add_boolean.md) — exposes a checkbox in instrument configuration; args: name, default, description
- [`user_prop_get`](../reference/amapi/by_function/User_prop_get.md) — reads the boolean value at startup; controls `if` branch

**Exemplars.**
- `generic_garmin-gfc-500-autopilot_c154321a` — YD Shown, Knobster, Play Sounds booleans each gate DOM additions
- `generic_garmin-gns-530_72b0d55c` — streaming enable boolean gates `video_stream_add` and its polling timer
- `generic_garmin-gns-430_24038c68` — same streaming toggle pattern

**Caveats.** User props are read at instrument load time only. Changes to props require panel reload. This is by design — the "DOM structure" (which elements exist) is determined once at startup. Do not use `user_prop_get` inside subscription callbacks to control element existence (that's a visibility pattern, not a feature toggle).

**GNC 355 relevance.** The GNC 355 may benefit from boolean props for: Knobster support (adds `hw_dial_add`), pilot/copilot side selection, and IFR vs. VFR color theme. This is a configuration-time decision (not runtime) so the boolean feature-toggle pattern is correct.

---

## Category: Instrument metadata / platform detection

### Pattern 12: Feature-detection guard (has_feature)

**Problem.** An instrument uses an AMAPI feature (e.g., video streaming) that may not be available on all platforms. Calling an unavailable API causes errors.

**Solution.** Wrap the optional API call in `if has_feature("FEATURE_NAME") then ... end`. The guard is typically also combined with a user-prop boolean check (Pattern 9) so the feature can be disabled even when the platform supports it.

**Code sketch.**
```lua
local up_streaming = user_prop_add_boolean("Enable streaming", true, "Stream GPS pop-out (XPL12+)")

if user_prop_get(up_streaming) and has_feature("VIDEO_STREAM") then
    local canvas_stream = canvas_add(0, 0, 1600, 1180)
    video_stream_add(canvas_stream, 0, 0, 1600, 1180)
    -- polling timer to wait for XPL12 connection...
end
```

**Functions used.**
- `has_feature` — returns true if the named API feature is available on the current Air Manager build/platform
- [`user_prop_add_boolean`](../reference/amapi/by_function/User_prop_add_boolean.md) — user opt-in (see Pattern 9)
- [`canvas_add`](../reference/amapi/by_function/Canvas_add.md), [`video_stream_add`](../reference/amapi/by_function/Video_stream_add.md) — the guarded optional feature

**Exemplars.**
- `generic_garmin-gns-530_72b0d55c` — `has_feature("VIDEO_STREAM")` guards the entire streaming setup block
- `generic_garmin-gns-430_24038c68` — identical guard

**Caveats.** `has_feature` returns a boolean. The set of valid feature names is not comprehensively documented in the A2 reference — known values are discovered from samples. As of the samples analyzed, `"VIDEO_STREAM"` is the only observed feature name.

**GNC 355 relevance.** The GNC 355 will display a moving-map page and chart page. If these are implemented via video streaming (XPL12 pop-out), a `has_feature("VIDEO_STREAM")` guard is needed. For software-drawn content (canvas), no guard is needed.

---

### Pattern 13: Platform-conditional canvas message

**Problem.** An instrument runs on both desktop (Windows/Mac) and embedded (Raspberry Pi, Android tablet) platforms. Setup instructions or warnings differ by platform, or certain features are desktop-only.

**Solution.** Use `instrument_prop("PLATFORM")` to detect the platform string. Display a canvas-drawn message with a dismiss button for platforms that need special instructions. On desktop, show a first-launch-only message using a persist flag.

**Code sketch.**
```lua
local prs_msg_read = persist_add("msg_read", false)

local platform = instrument_prop("PLATFORM")
if platform == "RASPBERRY_PI" or platform == "ANDROID" then
    -- always show setup guide on embedded platforms
    local cnv_msg = canvas_add(0, 0, 1600, 1180)
    canvas_draw(cnv_msg, function()
        _rect(0, 0, 1600, 1180)
        _fill(0, 0, 0, 200)
        _txt("Setup required: ...", 100, 400, 1400, 100)
    end)
    button_add(nil, nil, 700, 800, 200, 50, function()
        visible(cnv_msg, false)
    end)
elseif not persist_get(prs_msg_read) then
    -- desktop: show once then persist dismiss
    local cnv_msg = canvas_add(0, 0, 1600, 1180)
    -- ... draw message ...
    button_add(nil, nil, x_dismiss, y_dismiss, w, h, function()
        visible(cnv_msg, false)
        persist_put(prs_msg_read, true)
    end)
end
```

**Functions used.**
- `instrument_prop` — returns a string property of the instrument environment; `"PLATFORM"` returns the host platform
- [`canvas_add`](../reference/amapi/by_function/Canvas_add.md) — creates a 2D canvas overlay for the message
- [`canvas_draw`](../reference/amapi/by_function/Canvas_draw.md) — draws text and shapes into the canvas
- [`persist_add`](../reference/amapi/by_function/Persist_add.md), [`persist_get`](../reference/amapi/by_function/Persist_get.md), [`persist_put`](../reference/amapi/by_function/Persist_put.md) — one-time-show flag (desktop only)
- [`button_add`](../reference/amapi/by_function/Button_add.md) — dismiss button
- [`visible`](../reference/amapi/by_function/Visible.md) — hides canvas on dismiss

**Exemplars.**
- `generic_garmin-gns-530_72b0d55c` — Pi/tablet path shows static guide; desktop path shows first-launch guide
- `generic_garmin-gns-430_24038c68` — identical platform-conditional message structure

**GNC 355 relevance.** If the GNC 355 instrument includes setup instructions (e.g., how to pair with the sim's GPS), a platform-conditional message is the standard pattern. Otherwise, skip.

---

## Pattern cross-reference

### By AMAPI namespace: which patterns use each function

| AMAPI Function | Patterns |
|---|---|
| `button_add` | 1 (triple-dispatch), 4 (long-press), 9 (feature toggle), 13 (platform message), 17 (annunciator), 19 (BEGIN/END) |
| `dial_add` | 11 (persist angle), 15 (mouse+touch pair), 21 (hw_dial + virtual) |
| `fs2020_variable_subscribe` | 2 (multi-var bus), 3 (FS2024 reuse) |
| `fs2024_variable_subscribe` | 2 (multi-var bus), 3 (FS2024 reuse), 23 (B: event) |
| `fsx_event` | 1 (triple-dispatch), 22 (FSX adapter) |
| `fsx_variable_subscribe` | 2 (multi-var bus), 22 (FSX adapter) |
| `group_add` | 6 (power-state), 10 (day/night opacity) |
| `has_feature` | 12 (feature guard) |
| `hw_dial_add` | 20 (detent user prop), 21 (hardware encoder) |
| `img_add` | 6 (power-state), 7 (rotate-analog), 8 (style string), 11 (persist angle), 17 (annunciator) |
| `img_add_fullscreen` | 1 (triple-dispatch context) |
| `instrument_prop` | 13 (platform message) |
| `msfs_event` | 1 (triple-dispatch), 23 (B: event) |
| `msfs_variable_subscribe` | 2 (multi-var bus), 14 (parallel XPL+MSFS), 24 (L: LVAR) |
| `msfs_variable_write` | 24 (L: LVAR) |
| `opacity` | 10 (day/night opacity) |
| `persist_add` | 11 (persist angle), 13 (platform message) |
| `persist_get` | 11 (persist angle), 13 (platform message) |
| `persist_put` | 11 (persist angle), 13 (platform message) |
| `rotate` | 7 (rotate-analog), 11 (persist angle) |
| `si_variable_subscribe` | 10 (day/night opacity) |
| `sound_add` | 16 (sound on state-change) |
| `sound_play` | 16 (sound on state-change) |
| `timer_running` | 4 (long-press), 19 (BEGIN/END) |
| `timer_start` | 4 (long-press) |
| `timer_stop` | 4 (long-press), 19 (BEGIN/END) |
| `touch_setting` | 15 (mouse+touch pair) |
| `user_prop_add_boolean` | 9 (feature toggle), 12 (feature guard) |
| `user_prop_add_enum` | 20 (detent user prop) |
| `user_prop_add_integer` | 5 (device ID) |
| `user_prop_get` | 5 (device ID), 9 (feature toggle), 20 (detent prop) |
| `var_cap` | 7 (rotate-analog), 14 (parallel XPL+MSFS) |
| `video_stream_add` | 12 (feature guard) |
| `visible` | 6 (power-state), 13 (platform message), 17 (annunciator) |
| `xpl_command` | 1 (triple-dispatch), 18 (dual command), 19 (BEGIN/END) |
| `xpl_dataref_subscribe` | 2 (multi-var bus), 14 (parallel XPL+MSFS) |
| `xpl_dataref_write` | 14 (parallel XPL+MSFS context) |

---

## What this catalog does NOT cover

- **Sample-specific techniques.** Idioms that appeared in only one Tier 1 sample and didn't validate against the corpus. See the companion [sample appendix](amapi_patterns_sample_appendix.md).
- **Hardware patterns (`hw_*` beyond hw_dial_add).** The GNC 355 is currently scoped as software-only; hardware-panel binding patterns beyond the Knobster support above are deprioritized.
- **3D scene patterns (`Scene_*`).** The GNC 355 is 2D-only.
- **Flight Illusion hardware (`Fi_*`).** Not applicable.
- **Device catalog (`Device_*`).** Applies to integrated avionics panels, not standalone instruments.
- **Canvas drawing patterns.** Canvas was observed only for platform-conditional messages and streaming overlays in the analyzed samples; complex canvas-drawn instrument faces (gauges drawn in code) were not found and are not documented here.
