---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fs2020_event_subscribe
Namespace: Fs2020
Source URL: https://wiki.siminnovations.com/index.php?title=Fs2020_event_subscribe
Revision: 5033
---

# Fs2020 event subscribe

## Signature

```
fs2020_event_subscribe(event, callback)
```

## Description

fs2020_event_subscribe is used to subscribe to a FS2020 event. Only B events are supported at the moment.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `event` | String | Reference to the FS2020 event |
| 2 | `callback` | Function | The function to call when a new event has been sent within FS2020 |

## Examples

### Example

```lua
fs2020_event_subscribe("B:HANDLING_InertSep", function()
      print("The event got triggered within FS2020!")
  end)
```
