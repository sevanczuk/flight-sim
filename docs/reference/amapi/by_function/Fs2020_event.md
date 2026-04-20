---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fs2020_event
Namespace: Fs2020
Source URL: https://wiki.siminnovations.com/index.php?title=Fs2020_event
Revision: 5749
---

# Fs2020 event

## Signature

```
fs2020_event(event) fs2020_event(event, type, value) (from AM/AP 5.0) fs2020_event(event, value) fs2020_event(event, value, value_2) (from AM/AP 4.1)
```

## Description

fs2020_event is used to send an event to FS2020. And can contain a value (this is optional). You can find the available events for FS2020 [here (official)](https://docs.flightsimulator.com/html/Programming_Tools/Event_IDs/Event_IDs.htm).

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
fs2020_event("TOGGLE_AVIONICS_MASTER")

-- Set stobe lights on
fs2020_event("STROBES_SET", 1)

-- Fire a H event
fs2020_event("H:AS1000_PFD_MENU_Push")

-- Fire a B event
fs2020_event("B:HANDLING_InertSep", 1)
```

## External references

- [here (official)](https://docs.flightsimulator.com/html/Programming_Tools/Event_IDs/Event_IDs.htm)
