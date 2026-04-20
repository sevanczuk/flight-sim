---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_dial_set_acceleration
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_dial_set_acceleration
Revision: 3079
---

# Hw dial set acceleration

## Signature

```
hw_dial_set_acceleration(hw_dial_id, acceleration)
```

## Description

hw_dial_set_acceleration is used to change the acceleration of a rotary encoder.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_dial_id` | id | The is the reference to the rotary encoder. You can get this reference from the hw_dial_add function. |
| 2 | `acceleration` | Number | A multiplier that will make the dial generate extra callbacks when the dial is being rotated faster. The multiplier is the maximum number of callbacks of one dial tick when this dial is being rotated at maximum speed. |

## Examples

### Example

```lua
function dial_change(direction)
  if direction == 1 then
    print("The dial turned clockwise")
  else if direction == -1 then
    print("The dial turned counterclockwise")
  end
end

-- Create the rotary encoder
my_dial = hw_dial_add("Heading", dial_change)

-- Change the acceleration
hw_dial_set_acceleration(my_dial, 2.0)
```
