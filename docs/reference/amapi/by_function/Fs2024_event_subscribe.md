---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fs2024_event_subscribe
Namespace: Fs2024
Source URL: https://wiki.siminnovations.com/index.php?title=Fs2024_event_subscribe
Revision: 5325
---

# Fs2024 event subscribe

## Signature

```
fs2024_event_subscribe(event, callback)
```

## Description

fs2024_event_subscribe is used to subscribe to a FS2024 event. Only B events are supported at the moment.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `event` | String | Reference to the FS2024 event |
| 2 | `callback` | Function | The function to call when a new event has been sent within FS2024 |

## Examples

### Example

```lua
fs2024_event_subscribe("B:ELECTRICAL_LINE_BUS_1_TO_AVIONICS_BUS_1", function()
    print("The Cessna 172 G1000 avionics bus 1 switch was operated within FS2024!")
end)
```
