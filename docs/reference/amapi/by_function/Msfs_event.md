---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: msfs_event
Namespace: Msfs
Source URL: https://wiki.siminnovations.com/index.php?title=Msfs_event
Revision: 5220
---

# Msfs event

## Signature

```
msfs_event(event) msfs_event(event, value_1) msfs_event(event, value_1, value_2)
```

## Description

msfs_event is used to send an event to FS2020/FS2024. And can contain a value (this is optional). You can find the available events for FS2020 [here (official)](https://docs.flightsimulator.com/html/Programming_Tools/Event_IDs/Event_IDs.htm) and FS2024 [here (official)](https://docs.flightsimulator.com/msfs2024/html/6_Programming_APIs/Key_Events/Key_Events.htm).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `event` | String | Reference to an event from Flight Simulator 2020/2024. Use 'H:' prefix for H events, see example below. |
| 2 | `value_1` | Number | (Optional) Send a value with the event. Some events support setting a value. |
| 3 | `value_2` | Number | (Optional) Send a value with the event. Some events support setting a value. |

## Examples

### Example

```lua
-- Toggle the Avionics Master switch
msfs_event("TOGGLE_AVIONICS_MASTER")

-- Set stobe lights on
msfs_event("STROBES_SET", 1)

-- Fire a H event
msfs_event("H:AS1000_PFD_MENU_Push")

-- Fire a B event
msfs_event("B:HANDLING_InertSep", 1)
```

## External references

- [here (official)](https://docs.flightsimulator.com/html/Programming_Tools/Event_IDs/Event_IDs.htm)
- [here (official)](https://docs.flightsimulator.com/msfs2024/html/6_Programming_APIs/Key_Events/Key_Events.htm)
