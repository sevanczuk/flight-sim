# AMAPI by Use Case — Lightweight Index for GNC 355 Work

**Created:** 2026-04-20T09:50:02-04:00
**Source:** Purple Turn 53 — lightweight A3 (Stream A supplementary index). CD-authored, not CC-generated. Derived from `docs/reference/amapi/_index.md`.
**Purpose:** Fast lookup by task ("how do I read NAV frequency?") rather than by namespace. Complements the parser-generated namespace index with task-oriented groupings relevant to building the GNC 355 touchscreen GPS/COM.
**Stream:** A (AMAPI), Wave 2
**Replaces:** the originally-scoped A3 "CC task for cookbook/pattern catalog" — A2's output made that unnecessary; this lightweight CD document covers the gap.

All links resolve to the parser-generated reference docs at `docs/reference/amapi/by_function/`. Every function listed below is a live link in a markdown viewer.

## How to use this document

The GNC 355 instrument needs to do specific things: read simulator state (GPS position, NAV frequencies), respond to pilot input (touch on soft-keys, knob rotation), render dynamic content (map, CDI, frequency display), and persist state (flight plans, preferences). This index groups AMAPI functions by the task being performed rather than by API namespace.

When authoring the GNC 355 Design Spec (Stream C2 output), reach for this document first to identify candidate functions; then follow the live link into the function's reference doc for signature, arguments, and examples.

---

## 1. Reading simulator state (aircraft variables)

The GNC 355 needs to read aircraft position, altitude, heading, NAV frequencies, and pilot inputs continuously. Each simulator has its own variable namespace.

### X-Plane (uses "datarefs")
- [Xpl_dataref_subscribe](../reference/amapi/by_function/Xpl_dataref_subscribe.md) — subscribe to one or more datarefs with a callback
- [Xpl_connected](../reference/amapi/by_function/Xpl_connected.md) — check if X-Plane is running
- [Request_callback](../reference/amapi/by_function/Request_callback.md) — force a callback on any subscription (useful on instrument startup)

### MSFS 2020/2024 (unified API)
- [Msfs_variable_subscribe](../reference/amapi/by_function/Msfs_variable_subscribe.md) — subscribe to one or more SimConnect variables with a unit
- [Msfs_connected](../reference/amapi/by_function/Msfs_connected.md) — check if FS2020 or FS2024 is running (one function serves both)
- [Msfs_rpn](../reference/amapi/by_function/Msfs_rpn.md) — execute RPN scripts inside MSFS (for complex queries)

### Per-simulator variants (use if targeting one sim specifically)
- FS2020: [Fs2020_variable_subscribe](../reference/amapi/by_function/Fs2020_variable_subscribe.md), [Fs2020_connected](../reference/amapi/by_function/Fs2020_connected.md), [Fs2020_rpn](../reference/amapi/by_function/Fs2020_rpn.md)
- FS2024: [Fs2024_variable_subscribe](../reference/amapi/by_function/Fs2024_variable_subscribe.md), [Fs2024_connected](../reference/amapi/by_function/Fs2024_connected.md), [Fs2024_rpn](../reference/amapi/by_function/Fs2024_rpn.md)
- FSX/P3D: [Fsx_variable_subscribe](../reference/amapi/by_function/Fsx_variable_subscribe.md), [Fsx_connected](../reference/amapi/by_function/Fsx_connected.md), [P3d_connected](../reference/amapi/by_function/P3d_connected.md)

### Cross-simulator abstraction (D-01 scope)
- [Variable_subscribe](../reference/amapi/by_function/Variable_subscribe.md) — generic subscription across X-Plane, FSX, SI, and external sources. Likely the right choice for GNC 355's dual-sim scope.
- [Ext_variable_subscribe](../reference/amapi/by_function/Ext_variable_subscribe.md) / [Ext_connected](../reference/amapi/by_function/Ext_connected.md) — subscribe to variables from "external data sources" (third-party apps, FSUIPC, etc.)

---

## 2. Writing back to the simulator (pilot commands)

When the pilot taps OBS+ or tunes a frequency on the GNC 355, the instrument must push the change back to the sim.

### Writing variables (for state-like things: frequencies, altitudes, headings)
- [Xpl_dataref_write](../reference/amapi/by_function/Xpl_dataref_write.md)
- [Msfs_variable_write](../reference/amapi/by_function/Msfs_variable_write.md)
- [Fs2020_variable_write](../reference/amapi/by_function/Fs2020_variable_write.md) / [Fs2024_variable_write](../reference/amapi/by_function/Fs2024_variable_write.md) / [Fsx_variable_write](../reference/amapi/by_function/Fsx_variable_write.md)
- [Ext_variable_write](../reference/amapi/by_function/Ext_variable_write.md)

### Firing events (for one-shot actions: "swap COM freq", "direct-to waypoint")
- [Xpl_command](../reference/amapi/by_function/Xpl_command.md) + [Xpl_command_subscribe](../reference/amapi/by_function/Xpl_command_subscribe.md)
- [Msfs_event](../reference/amapi/by_function/Msfs_event.md) + [Msfs_event_subscribe](../reference/amapi/by_function/Msfs_event_subscribe.md)
- [Fs2020_event](../reference/amapi/by_function/Fs2020_event.md) / [Fs2024_event](../reference/amapi/by_function/Fs2024_event.md) / [Fsx_event](../reference/amapi/by_function/Fsx_event.md)
- [Fs2020_event_subscribe](../reference/amapi/by_function/Fs2020_event_subscribe.md) / [Fs2024_event_subscribe](../reference/amapi/by_function/Fs2024_event_subscribe.md) (no FSX event subscribe)
- [Ext_command](../reference/amapi/by_function/Ext_command.md) / [Ext_command_subscribe](../reference/amapi/by_function/Ext_command_subscribe.md)
- [Si_command](../reference/amapi/by_function/Si_command.md) / [Si_command_subscribe](../reference/amapi/by_function/Si_command_subscribe.md) — global ("Sim Innovations") command bus across instruments

---

## 3. Pilot input — touchscreen

The GNC 355 is a touchscreen GPS/COM. These are the core touch-interaction primitives.

- [Button_add](../reference/amapi/by_function/Button_add.md) — add a tap-able button with pressed/released callbacks. Most GNC 355 soft-keys will use this.
- [Touch_setting](../reference/amapi/by_function/Touch_setting.md) — configure touch-specific settings for dials/buttons/switches (e.g., tap-to-focus vs drag)
- [Mouse_setting](../reference/amapi/by_function/Mouse_setting.md) — configure mouse/pointer behavior on dials/buttons/switches (paired with touch for desktop use)
- [Layer_mouse_cursor](../reference/amapi/by_function/Layer_mouse_cursor.md) — set cursor shape when hovering a layer
- [Layer_add](../reference/amapi/by_function/Layer_add.md) — create a layer with its own input-event callback (useful for scrollable list regions, map pan/zoom gestures)

---

## 4. Pilot input — knobs and rotary encoders

Even in touchscreen units, Garmin designs frequently have a dual-concentric physical knob for cursor/volume/tuning.

### Virtual knobs (drawn on the screen)
- [Dial_add](../reference/amapi/by_function/Dial_add.md) — virtual dial with direction + optional press/release callbacks
- [Dial_click_rotate](../reference/amapi/by_function/Dial_click_rotate.md) — configure degrees per click
- [Dial_set_acceleration](../reference/amapi/by_function/Dial_set_acceleration.md) — set rotation acceleration

### Hardware knobs (physical panel)
- [Hw_dial_add](../reference/amapi/by_function/Hw_dial_add.md) — bind to a physical rotary encoder
- [Hw_dial_set_acceleration](../reference/amapi/by_function/Hw_dial_set_acceleration.md)

---

## 5. Pilot input — switches and sliders (secondary)

Less relevant to GNC 355 directly but useful for understanding the broader input API.

- [Switch_add](../reference/amapi/by_function/Switch_add.md), [Switch_get_position](../reference/amapi/by_function/Switch_get_position.md), [Switch_set_position](../reference/amapi/by_function/Switch_set_position.md)
- [Hw_switch_add](../reference/amapi/by_function/Hw_switch_add.md), [Hw_switch_get_position](../reference/amapi/by_function/Hw_switch_get_position.md)
- [Slider_add_hor](../reference/amapi/by_function/Slider_add_hor.md) / [Slider_add_ver](../reference/amapi/by_function/Slider_add_ver.md) / [Slider_add_cir](../reference/amapi/by_function/Slider_add_cir.md), [Slider_set_position](../reference/amapi/by_function/Slider_set_position.md)
- [Scrollwheel_add_hor](../reference/amapi/by_function/Scrollwheel_add_hor.md) / [Scrollwheel_add_ver](../reference/amapi/by_function/Scrollwheel_add_ver.md) — barrel-roll value pickers (might be useful for GNC 355 frequency tuning)

---

## 6. Drawing — static content (logos, backgrounds)

- [Img_add](../reference/amapi/by_function/Img_add.md) — place an image from the `resources/` folder
- [Img_add_fullscreen](../reference/amapi/by_function/Img_add_fullscreen.md) — place an image filling the entire instrument canvas
- [Txt_add](../reference/amapi/by_function/Txt_add.md), [Txt_set](../reference/amapi/by_function/Txt_set.md), [Txt_style](../reference/amapi/by_function/Txt_style.md) — place / update / restyle static text labels

---

## 7. Drawing — dynamic 2D content (CDI, compass rose, frequency display)

The GNC 355 map view, CDI needle, and bearing indicators all need dynamic rendering.

### The drawing primitive
- [Canvas_add](../reference/amapi/by_function/Canvas_add.md) — create a canvas region with a `draw_callback`. The callback is where all drawing happens. This is THE primary drawing API.
- [Canvas_draw](../reference/amapi/by_function/Canvas_draw.md) — force a canvas to redraw (use when underlying data changes)

### Canvas transforms (apply inside the `draw_callback`)
- [Canvas_translate](../reference/amapi/by_function/Canvas_translate.md)
- [Canvas_rotate](../reference/amapi/by_function/Canvas_rotate.md)
- [Canvas_scale](../reference/amapi/by_function/Canvas_scale.md)

### Path primitives (inside `draw_callback`)
- [Move_to](../reference/amapi/by_function/Move_to.md) — move the "pen" without drawing
- [Line_to](../reference/amapi/by_function/Line_to.md) — straight line from pen to point
- [Arc_to](../reference/amapi/by_function/Arc_to.md) — arc from pen to point
- [Bezier_to](../reference/amapi/by_function/Bezier_to.md) — cubic bezier
- [Quad_to](../reference/amapi/by_function/Quad_to.md) — quadratic bezier

### Shape primitives (inside `draw_callback`)
- [Arc](../reference/amapi/by_function/Arc.md) — freestanding arc
- [Circle](../reference/amapi/by_function/Circle.md)
- [Ellipse](../reference/amapi/by_function/Ellipse.md)
- [Rect](../reference/amapi/by_function/Rect.md) — rectangle, with optional rounded corners
- [Triangle](../reference/amapi/by_function/Triangle.md)

### Path control
- [Solid](../reference/amapi/by_function/Solid.md) — mark subsequent shape as solid
- [Hole](../reference/amapi/by_function/Hole.md) — mark subsequent shape as a hole (for compound paths)

### Fills and strokes (apply the accumulated path)
- [Fill](../reference/amapi/by_function/Fill.md) — solid color fill
- [Fill_gradient_linear](../reference/amapi/by_function/Fill_gradient_linear.md)
- [Fill_gradient_radial](../reference/amapi/by_function/Fill_gradient_radial.md)
- [Fill_gradient_box](../reference/amapi/by_function/Fill_gradient_box.md)
- [Fill_img](../reference/amapi/by_function/Fill_img.md) — fill with an image (e.g., textured fill)
- [Stroke](../reference/amapi/by_function/Stroke.md) — stroke the path

### Canvas-local text
- [Txt](../reference/amapi/by_function/Txt.md) — draw text inside a canvas draw_callback (vs `Txt_add` which is instrument-level)

---

## 8. Drawing — mechanical "running" displays (analog gauges, drum tapes)

The GNC 355 may use running displays for altitude tape, heading tape, VSI scale.

### Running image (for segmented scales — e.g., heading tape with image strip)
- [Running_img_add_hor](../reference/amapi/by_function/Running_img_add_hor.md)
- [Running_img_add_ver](../reference/amapi/by_function/Running_img_add_ver.md)
- [Running_img_add_cir](../reference/amapi/by_function/Running_img_add_cir.md) — circular running (e.g., compass rose)
- [Running_img_move_carot](../reference/amapi/by_function/Running_img_move_carot.md)

### Running text (for continuous numeric tapes)
- [Running_txt_add_hor](../reference/amapi/by_function/Running_txt_add_hor.md)
- [Running_txt_add_ver](../reference/amapi/by_function/Running_txt_add_ver.md)
- [Running_txt_add_cir](../reference/amapi/by_function/Running_txt_add_cir.md)
- [Running_txt_move_carot](../reference/amapi/by_function/Running_txt_move_carot.md)

---

## 9. Visual state management

Animating nodes (the objects returned by `_add` calls) across the instrument.

- [Move](../reference/amapi/by_function/Move.md) — move a node (image, text, canvas) with optional animation
- [Rotate](../reference/amapi/by_function/Rotate.md) — rotate a node, optionally with animation
- [Opacity](../reference/amapi/by_function/Opacity.md) — change transparency
- [Visible](../reference/amapi/by_function/Visible.md) — show / hide
- [Remove](../reference/amapi/by_function/Remove.md) — permanently delete a node
- [Z_order](../reference/amapi/by_function/Z_order.md) — move a node forward/backward in rendering order
- [Viewport_rect](../reference/amapi/by_function/Viewport_rect.md) — clip a node to a rectangle
- [Viewport_shape](../reference/amapi/by_function/Viewport_shape.md) — clip a node to an arbitrary drawn shape

### Grouping (animate multiple nodes together)
- [Group_add](../reference/amapi/by_function/Group_add.md)
- [Group_obj_add](../reference/amapi/by_function/Group_obj_add.md)
- [Group_obj_remove](../reference/amapi/by_function/Group_obj_remove.md)

### Layers (a layer is a z-ordered canvas region with optional input handling)
- [Layer_add](../reference/amapi/by_function/Layer_add.md)

---

## 10. Maps and navigation data

Critical for the GNC 355. The AMAPI provides both a map widget and NAV database access.

### Map widget (renders actual charts)
- [Map_add](../reference/amapi/by_function/Map_add.md) — create a map at x/y with a zoom level and data source
- [Map_goto](../reference/amapi/by_function/Map_goto.md) — pan to lat/lon
- [Map_zoom](../reference/amapi/by_function/Map_zoom.md) — change zoom
- [Map_baselayer](../reference/amapi/by_function/Map_baselayer.md) — swap baselayer source

### Map overlay layers (nav data rendered on top of the base map)
- [Map_add_nav_img_layer](../reference/amapi/by_function/Map_add_nav_img_layer.md) — e.g., VOR symbols
- [Map_add_nav_txt_layer](../reference/amapi/by_function/Map_add_nav_txt_layer.md) — e.g., waypoint identifiers
- [Map_add_nav_canvas_layer](../reference/amapi/by_function/Map_add_nav_canvas_layer.md) — custom-drawn overlay (most flexible)
- [Map_nav_canvas_layer_draw](../reference/amapi/by_function/Map_nav_canvas_layer_draw.md)

### NAV data queries (waypoints, VORs, airports — without rendering a map)
- [Nav_get](../reference/amapi/by_function/Nav_get.md) — look up a specific NAV item
- [Nav_get_nearest](../reference/amapi/by_function/Nav_get_nearest.md) — N nearest NAV items to a lat/lon
- [Nav_get_radius](../reference/amapi/by_function/Nav_get_radius.md) — NAV items within a radius
- [Nav_calc_bearing](../reference/amapi/by_function/Nav_calc_bearing.md) — bearing between two lat/lons
- [Nav_calc_distance](../reference/amapi/by_function/Nav_calc_distance.md) — distance between two lat/lons
- [Geo_rotate_coordinates](../reference/amapi/by_function/Geo_rotate_coordinates.md) — polar-to-cartesian helper

---

## 11. Persistence (flight plans, preferences, last-session state)

The GNC 355 must remember its state between sessions — pilots expect the flight plan, last-used frequencies, and settings to survive a restart.

- [Persist_add](../reference/amapi/by_function/Persist_add.md) — declare a persistence key with an initial value
- [Persist_get](../reference/amapi/by_function/Persist_get.md) — read
- [Persist_put](../reference/amapi/by_function/Persist_put.md) — write

---

## 12. User-configurable properties (instrument settings panel)

When the user right-clicks the instrument in Air Manager's designer, they see a settings panel populated by these functions.

- [User_prop_add_boolean](../reference/amapi/by_function/User_prop_add_boolean.md)
- [User_prop_add_integer](../reference/amapi/by_function/User_prop_add_integer.md)
- [User_prop_add_real](../reference/amapi/by_function/User_prop_add_real.md)
- [User_prop_add_string](../reference/amapi/by_function/User_prop_add_string.md)
- [User_prop_add_enum](../reference/amapi/by_function/User_prop_add_enum.md) — dropdown of preset values
- [User_prop_add_percentage](../reference/amapi/by_function/User_prop_add_percentage.md)
- [User_prop_add_hardware_id](../reference/amapi/by_function/User_prop_add_hardware_id.md) — picker for a physical panel ID (for hardware-paired instruments)
- [User_prop_add_table](../reference/amapi/by_function/User_prop_add_table.md) — multi-column editable table
- [User_prop_get](../reference/amapi/by_function/User_prop_get.md) — read a user property at runtime

### Related: interpolation helpers (often used with table user props)
- [Interpolate_linear](../reference/amapi/by_function/Interpolate_linear.md)
- [Interpolate_settings_from_user_prop](../reference/amapi/by_function/Interpolate_settings_from_user_prop.md)

---

## 13. Sound and video

- [Sound_add](../reference/amapi/by_function/Sound_add.md), [Sound_play](../reference/amapi/by_function/Sound_play.md), [Sound_loop](../reference/amapi/by_function/Sound_loop.md), [Sound_stop](../reference/amapi/by_function/Sound_stop.md), [Sound_volume](../reference/amapi/by_function/Sound_volume.md)
- [Video_stream_add](../reference/amapi/by_function/Video_stream_add.md), [Video_stream_ext_add](../reference/amapi/by_function/Video_stream_ext_add.md), [Video_stream_set](../reference/amapi/by_function/Video_stream_set.md)

---

## 14. Timing

The GNC 355 likely needs periodic work — blinking annunciators, flight-plan auto-advance, timer displays.

- [Timer_start](../reference/amapi/by_function/Timer_start.md) — one-shot or periodic timer
- [Timer_stop](../reference/amapi/by_function/Timer_stop.md)
- [Timer_running](../reference/amapi/by_function/Timer_running.md)

---

## 15. Data loading

- [Static_data_load](../reference/amapi/by_function/Static_data_load.md) — load JSON/CSV/text from the instrument's `resources/` folder (useful for frequency tables, airport databases bundled with the instrument)
- [Resource_info](../reference/amapi/by_function/Resource_info.md) — metadata about a resource file

---

## 16. Value manipulation helpers

- [Var_cap](../reference/amapi/by_function/Var_cap.md) — clamp to min/max
- [Var_round](../reference/amapi/by_function/Var_round.md) — round to N decimals
- [Var_format](../reference/amapi/by_function/Var_format.md) — format to N decimals (always showing them)
- [Log](../reference/amapi/by_function/Log.md) — write to the Air Manager log file (for debugging)

---

## 17. Instrument metadata and global bus

- [Instrument_get](../reference/amapi/by_function/Instrument_get.md) — reference another instrument on the same panel
- [Instrument_prop](../reference/amapi/by_function/Instrument_prop.md) — current instrument's settings (aircraft, version, dimensions)
- [Panel_prop](../reference/amapi/by_function/Panel_prop.md) — parent panel's settings
- [Has_feature](../reference/amapi/by_function/Has_feature.md) — feature detection (is a given API available in this AM/AP version?)

### Global variable bus (share state across instruments on the same panel)
- [Si_variable_create](../reference/amapi/by_function/Si_variable_create.md)
- [Si_variable_subscribe](../reference/amapi/by_function/Si_variable_subscribe.md)
- [Si_variable_write](../reference/amapi/by_function/Si_variable_write.md)

---

## 18. Out-of-scope for GNC 355 (noted for completeness)

These exist in AMAPI but the GNC 355 is unlikely to need them. Listed for completeness and cross-reference.

### Hardware panel integration (physical buttons/LEDs/displays)
If the GNC 355 is ever paired with a physical panel (dedicated knob/button hardware), the `Hw_*` family is relevant. For now, the target is a software-only instrument. All 28 Hw functions are in [_index.md §Hw](../reference/amapi/_index.md#hw-28-functions).

### Flight Illusion gauge integration (`Fi_*` family)
Mechanical gauge hardware. Not applicable. All 7 Fi functions are in [_index.md §Fi](../reference/amapi/_index.md#fi-7-functions).

### Scene (3D) — `Scene_*` family
Air Manager's 3D scene graph. GNC 355 is a 2D instrument. All 12 Scene functions are in [_index.md §Scene](../reference/amapi/_index.md#scene-12-functions).

### Device catalog (external hardware devices like Octavi, GFC500, RealSimGear)
The `Device_*` family is for external integrated avionics panels. Not directly applicable unless the GNC 355 acts as a device peer. See [_index.md §Device](../reference/amapi/_index.md#device-6-functions).

### Game controllers (joystick/HOTAS)
- [Game_controller_add](../reference/amapi/by_function/Game_controller_add.md), [Game_controller_list](../reference/amapi/by_function/Game_controller_list.md) — not applicable to GPS/COM unit

### Misc
- [Shut_down](../reference/amapi/by_function/Shut_down.md) — shut down the application. Rarely used from within an instrument.
- [Event_subscribe](../reference/amapi/by_function/Event_subscribe.md) — subscribe to global events (application-level, not sim variables)

---

## Quick-reference matrix — what a GNC 355 core loop looks like

| Concern | Primary function | Why |
|---|---|---|
| Read aircraft position | `Variable_subscribe` or sim-specific `_variable_subscribe` | Portable across X-Plane + MSFS |
| Read NAV frequency | Same family | Sim-specific variable name |
| Write NAV frequency (pilot tunes) | `_variable_write` (sim-specific) | Direct state change |
| Swap active/standby | `_event` (sim-specific) | Atomic sim-side swap |
| Render map | `Map_add` + `Map_add_nav_*_layer` | Use built-in map, not custom canvas |
| Render CDI needle | `Canvas_add` + `Rotate` | Custom drawing |
| Render softkey labels | `Txt_add` + `Txt_set` | Dynamic text |
| Render softkey backgrounds | `Button_add` with images | Tap detection free |
| Pilot taps softkey | `Button_add` `click_press_callback` | Standard button pattern |
| Pilot rotates outer knob | `Dial_add` (virtual) or `Hw_dial_add` (physical) | Rotation + optional click |
| Persist flight plan | `Persist_add` / `_get` / `_put` | Survives restart |
| Settings panel | `User_prop_add_*` family | User-configurable defaults |
| Periodic update | `Timer_start` | e.g., blinking annunciator |
| Feature detection | `Has_feature` | Graceful degradation on older AM versions |
| Debug print | `Log` | Writes to Air Manager log file |

---

## Notes

- **Function-reference link format:** `../reference/amapi/by_function/{Page_Name}.md`. The `../reference` prefix resolves from `docs/knowledge/` (this file's location) to `docs/reference/amapi/`.
- **Dual-simulator preference:** For GNC 355's XPL+MSFS scope, prefer `Variable_subscribe` (generic) over simulator-specific subscribers when possible. When NOT possible (events differ between sims), use `has_feature`-based conditional paths.
- **Coverage:** Every complete-parse function from A2 is categorized above at least once. Functions appear in multiple categories where relevant (e.g., `Canvas_add` appears only in §7 but is referenced from §8 and §10 contexts). The catalog pages (Device_list, Hardware_id_list) are reachable via [_index.md](../reference/amapi/_index.md) but not listed here since they're out of scope.
- **What this does NOT do:** This is not a cookbook. It does not show HOW to do things, only WHICH functions to reach for. "How" is the job of Stream B3 (pattern analysis from instrument samples) and the eventual GNC 355 Design Spec (Stream C2).
