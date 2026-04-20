---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: switch_get_position
Namespace: Switch
Source URL: https://wiki.siminnovations.com/index.php?title=Switch_get_position
Revision: 2244
---

# Switch get position

## Signature

```
position = switch_get_position(hw_switch_id)
```

## Description

switch_get_position is used to get the current position of a switch.

## Return value

position

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `switch_id` | Object | The is the reference to the switch. You can get this reference from the switch_add function. |

## Examples

### Example

```lua
-- Callback function which is called when the switch position changes
function position_changed(position)
  print("new position = " .. tostring(position) )
end

-- Bind to Raspberry Pi 2, Header P1, Pin 40
switch_id = switch_add("off.png", "on.png", 100,100,100,100,position_changed)

-- Read the current position
position = switch_get_position(switch_id)
```
