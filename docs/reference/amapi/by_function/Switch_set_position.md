---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: switch_set_position
Namespace: Switch
Source URL: https://wiki.siminnovations.com/index.php?title=Switch_set_position
Revision: 3075
---

# Switch set position

## Signature

```
switch_set_position(switch_id,position)
```

## Description

switch_set_position is used to set a switch to a certain position.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `switch_id` | Number | Reference to the switch |
| 2 | `position` | Number | The position you want to switch to get. |

## Examples

### Example

```lua
-- This function will be called when the switch changed position
-- Position being the new position. Ranging from 0 .. number of positions configured 
function callback(position)
  print("switch position has been changed to position " .. position)
end
 
-- Add a switch with 3 states (a, b and c)
-- The callback function will be called when the switch changes position
switch_id = switch_add("a.png", "b.png", "c.png", 100, 100, 100, 100, callback)

-- Start the switch on position 1 (default is position 0)
switch_set_position(switch_id, 1)
```
