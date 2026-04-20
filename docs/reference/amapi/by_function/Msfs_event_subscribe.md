---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: msfs_event_subscribe
Namespace: Msfs
Source URL: https://wiki.siminnovations.com/index.php?title=Msfs_event_subscribe
Revision: 5262
---

# Msfs event subscribe

## Signature

```
msfs_event_subscribe(event, callback)
```

## Description

msfs_event_subscribe is used to subscribe to a FS2020/FS2024 event. Only B events are supported at the moment. You can find the available events for FS2020 [here (official)](https://docs.flightsimulator.com/html/Programming_Tools/Event_IDs/Event_IDs.htm) and FS2024 [here (official)](https://docs.flightsimulator.com/msfs2024/html/6_Programming_APIs/Key_Events/Key_Events.htm).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `event` | String | Reference to the FS2020/FS2024 event |
| 2 | `callback` | Function | The function to call when a new event has been sent within the sim |

## Examples

### Example

```lua
msfs_event_subscribe("B:HANDLING_InertSep", function()
    print("The event got triggered within the sim!")
end)

msfs_event_subscribe("B:AS1000_MENU_PUSH_MFD", function(value)
  if value > 0 then
    print("button was pressed")
  else
    print("button was released")
  end
end)
```

## External references

- [here (official)](https://docs.flightsimulator.com/html/Programming_Tools/Event_IDs/Event_IDs.htm)
- [here (official)](https://docs.flightsimulator.com/msfs2024/html/6_Programming_APIs/Key_Events/Key_Events.htm)
