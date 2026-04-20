---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_stepper_motor_position
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_stepper_motor_position
Revision: 3320
---

# Hw stepper motor position

## Signature

```
hw_stepper_motor_position(hw_stepper_motor_id, position) hw_stepper_motor_position(hw_stepper_motor_id, position, direction)
```

## Description

hw_stepper_motor_position is used to set the position of of the stepper motor.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_stepper_motor_id` | Object | The is the reference to the stepper motor. You can get this reference from the hw_stepper_motor_add function. |
| 2 | `position` | Number | The desired position, ranging from 0.0 to 1.0. |
| 3 | `direction` | String | (Optional) The desired direction. Can be "SLOWEST", "FASTEST", "CLOCKWISE", "COUNTERCLOCKWISE", "ENDLESS_CLOCKWISE", "ENDLESS_COUNTERCLOCKWISE" or "STOP" (from AM/AP 3.7). Defaults to "FASTEST". |

## Examples

### Example

```lua
-- Initiate stepper motor with:
-- 2048 steps
-- 10 rpm speed
-- On pins A2, A3, A4 and A5 of an Arduino Nano
id = hw_stepper_motor_add("DIRECT_4WIRE", 2048, 10, "ARDUINO_NANO_A_D2", "ARDUINO_NANO_A_D3", "ARDUINO_NANO_A_D4", "ARDUINO_NANO_A_D5")

-- Set position to 75%
hw_stepper_motor_position(id, 0.75, "CLOCKWISE")

-- Rotate stepper motor endless
hw_stepper_motor_position(id, nil, "ENDLESS_CLOCKWISE")
```
