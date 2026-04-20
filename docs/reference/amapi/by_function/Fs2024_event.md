---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fs2024_event
Namespace: Fs2024
Source URL: https://wiki.siminnovations.com/index.php?title=Fs2024_event
Revision: 5750
---

# Fs2024 event

## Signature

```
fs2024_event(event) fs2024_event(event, type, value) fs2024_event(event, value) fs2024_event(event, value, value_2)
```

## Description

fs2024_event is used to send an event to FS2024. And can contain a value (this is optional). You can find the available events for FS2024 [here (official)](https://docs.flightsimulator.com/msfs2024/html/6_Programming_APIs/Key_Events/Key_Events.htm).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `event` | String | Reference to an event from Flight Simulator 2020. Use 'H:' prefix for H events, see example below. |
| 2 | `type` | String | (Optional) Data type, can be INT, FLOAT, DOUBLE, BOOL or STRING. |
| 3 | `value` | Number | (Optional) Send a value with the event. Some events support setting a value. |
| 4 | `value_2` | Number | (Optional) Send a value with the event. Some events support setting a value. |

## Examples

### Example

```lua
-- Toggle the Avionics Master switch
fs2024_event("TOGGLE_AVIONICS_MASTER")

-- Set stobe lights on
fs2024_event("STROBES_SET", 1)

-- Fire a H event
fs2024_event("H:AS1000_PFD_MENU_Push")
```

## External references

- [here (official)](https://docs.flightsimulator.com/msfs2024/html/6_Programming_APIs/Key_Events/Key_Events.htm)
