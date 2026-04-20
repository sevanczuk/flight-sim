---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_switch_get_position
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_switch_get_position
Revision: 2243
---

# Hw switch get position

## Signature

```
position = hw_switch_get_position(hw_switch_id)
```

## Description

hw_switch_get_position is used to get the current position of a hardware switch.

## Return value

position

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_switch_id` | Object | The is the reference to the switch. You can get this reference from the hw_switch_add function. |

## Examples

### Example

```lua
-- Callback function which is called when the switch position changes
function position_changed(position)
  print("new position = " .. tostring(position) )
end

-- Bind to Raspberry Pi 2, Header P1, Pin 40
switch_id = hw_switch_add("RPI_V2_P1_40", position_changed)

-- Read the current position
position = hw_switch_get_position(switch_id)
```
