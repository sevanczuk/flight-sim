---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fsx_event
Namespace: Fsx
Source URL: https://wiki.siminnovations.com/index.php?title=Fsx_event
Revision: 4617
---

# Fsx event

## Signature

```
fsx_event(event,value)
```

## Description

fsx_event is used to send an event to FSX or Prepar3D. And can contain a value (this is optional). You can find the available events for FSX [here](http://msdn.microsoft.com/en-us/library/cc526980.aspx) and the Prepar3D variables [here (official)](https://www.prepar3d.com/SDKv5/sdk/references/variables/event_ids.html).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `event` | String | Reference to an event from Flight Simulator X or Prepar3D |
| 2 | `value` | Number | (Optional) Send a value with the event. Some events support setting a value. |

## Examples

### Example

```lua
-- Toggle the Avionics Master switch
fsx_event("TOGGLE_AVIONICS_MASTER")

-- Set stobe lights on
fsx_event("STROBES_SET", 1)
```

## External references

- [here](http://msdn.microsoft.com/en-us/library/cc526980.aspx)
- [here (official)](https://www.prepar3d.com/SDKv5/sdk/references/variables/event_ids.html)
