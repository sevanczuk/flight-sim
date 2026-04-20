---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: event_subscribe
Namespace: Event
Source URL: https://wiki.siminnovations.com/index.php?title=Event_subscribe
Revision: 3285
---

# Event subscribe

## Signature

```
event_subscribe(callback)
```

## Description

event_subscribe is used to subscribe to global events. E.g., when the instrument or panel is starting, showing or closing.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `callback` | Function | Function that should be called on an event. |

## Examples

### Example (Generic)

```lua
function event_callback(event)
  print("Received event: " .. event)
end

event_subscribe(event_callback)
```

### Example (Flight simulator connection)

```lua
function event_callback(event)
    if event == "FLIGHT_SIM_CHANGED" then
        if xpl_connected() then
            print("We are connected to X-plane")
        else
            print("We are not connected to X-plane")
        end
    end
end

event_subscribe(event_callback)
```
