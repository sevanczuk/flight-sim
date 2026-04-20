# Raw Notes: generic_garmin-gns-430_24038c68

## Metadata (from info.xml)

| Field | Value |
|---|---|
| Aircraft | Generic |
| Type | Garmin GNS 430 |
| Author | Sim Innovations |
| Version | 109 |
| Sim compat | XPL + FS2020 + FS2024 (no FSX/P3D) |
| Dimensions | 1600 × 670 |
| Source | UNKNOWN (vs GNS 530 which is ONLINE) |

## Structural outline

The GNS 430 logic.lua is structurally identical to the GNS 530 — same sections in the same order, same AMAPI patterns, different:
- Default unit is 2 (GNS 530 defaults to 1)
- MSFS event names use `AS430_*` prefix (vs `AS530_*`)
- Video stream IDs: `xpl/GNS430_1` / `xpl/GNS430_2`
- Canvas dimensions differ (870×464 vs 1040×760)
- No VNAV button (GNS 430 lacks VNAV)
- Range buttons have a different visual approach: separate `img_range_dn`/`img_range_up` images toggled in press/release callbacks

| Section | Lines | Summary |
|---|---|---|
| User props + globals | 1–6 | Same as GNS 530 |
| Persistence | 8–10 | Same as GNS 530 |
| Canvas setup | 12–16 | Streaming background + message canvas (smaller) |
| Platform-conditional messages | 17–49 | Identical pattern to GNS 530 |
| Streaming setup | 51–69 | Same has_feature guard + polling timer |
| XPL version subscription | 71–73 | Same |
| Background | 75 | Same |
| COM controls | 77–103 | Same structure, COM2 event names (unit 2 default) |
| NAV controls | 105–130 | Same structure |
| COM/NAV dual dials | 132–173 | Same persist-angle dual-concentric pattern |
| CRSR dual dials | 175–216 | Same pattern |
| Bottom buttons | 218–306 | CDI, OBS, MSG, FPL, PROC; range buttons use image toggle |
| Night/day groups | 308–316 | Same si_variable_subscribe backlight pattern |

## API call inventory

Identical to GNS 530 (all same function families, approximately same call counts):

| Function | Calls | Notes |
|---|---|---|
| `user_prop_add_boolean` | 1 | |
| `user_prop_add_integer` | 1 | Default 2 (GNS 430 is typically unit 2) |
| `persist_add` | 3 | Same three: angle_left, angle_right, msg_read |
| `canvas_add` | 2 | |
| `has_feature` | 1 | VIDEO_STREAM guard |
| `video_stream_add` | 1 | |
| `timer_start` | 3 | Polling + CLR long-press |
| `xpl_dataref_subscribe` | 2 | XPL version + volume |
| `xpl_dataref_write` | 2 | Volume write |
| `msfs_variable_subscribe` | 2 | Volume read |
| `xpl_command` | ~22 | Dual per button (sim-native + RXP) |
| `msfs_event` | ~22 | H: events |
| `img_add_fullscreen` | 2 | Background + night |
| `img_add` | ~12 | Including img_range_dn/up for range buttons |
| `button_add` | ~14 | |
| `dial_add` | 6 | Same 4 navigation dials + 2 volume dials |
| `mouse_setting` | 2 | |
| `touch_setting` | 2 | |
| `rotate` | 6+ | |
| `visible` | 6+ | Range button images toggled on press/release |
| `opacity` | 4 | |
| `group_add` | 2 | |
| `si_variable_subscribe` | 1 | |

## Notable idioms observed

All idioms from GNS 530 are confirmed:
- Triple-dispatch (XPL + MSFS)
- Dual xpl_command (sim-native + RXP plugin)
- Persist dial angle
- Platform-conditional one-time message
- Feature-detection guard + streaming + polling timer
- Parallel XPL + MSFS volume subscriptions
- Day/night group opacity via si_variable_subscribe
- mouse_setting + touch_setting pair
- Long-press CLR with xpl_command BEGIN/END
- img_add with initial style string for angle_z

**New idiom (GNS 430 vs GNS 530):**

10. **Visual button feedback via image toggle on press/release.** The Range Up/Down button area uses a shared `img_add("softkey_range.png", ...)` as a background plus separate `img_range_dn` and `img_range_up` images initially hidden. Press callback: `visible(img_range_dn, true)`. Release callback: `visible(img_range_dn, false)`. This provides visual press feedback without using the button_add's built-in second-image parameter — useful when multiple sub-regions share a button graphic.

## Sim-portability approach

Identical to GNS 530: XPL + MSFS dual dispatch. No FSX.

## Questions / anomalies

- `source` in info.xml is "UNKNOWN" for GNS 430 vs "ONLINE" for GNS 530. This may indicate GNS 430 was installed from a local file rather than downloaded from the Air Manager store. No functional impact.
- GNS 430 confirmation: the code is clearly a copy of GNS 530 with event names and dimensions adjusted. This validates that the GNS 530 patterns are general (not unique to 530) and used for the entire GNS family.
