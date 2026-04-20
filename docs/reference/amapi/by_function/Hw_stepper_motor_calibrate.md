---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_stepper_motor_calibrate
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_stepper_motor_calibrate
Revision: 2650
---

# Hw stepper motor calibrate

## Signature

```
hw_stepper_motor_calibrate(hw_stepper_motor_id) hw_stepper_motor_calibrate(hw_stepper_motor_id, position)
```

## Description

hw_stepper_motor_calibrate is used to set the current physical position of the stepper motor to a defined position.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_stepper_motor_id` | Object | The is the reference to the stepper motor. You can get this reference from the hw_stepper_motor_add function. |
| 2 | `position` | Number | (Optional) The position to assign to the current physical position. Default 0.0. |

## Examples

### Example

```lua
-- Initiate stepper motor with:
-- 2048 steps
-- 10 rpm speed
-- On pins A2, A3, A4 and A5 of an Arduino Nano
id = hw_stepper_motor_add("DIRECT_4WIRE", 2048, 10, "ARDUINO_NANO_A_D2", "ARDUINO_NANO_A_D3", "ARDUINO_NANO_A_D4", "ARDUINO_NANO_A_D5")

-- We have a sensor halfway of our stepper motor
-- When this input is high, the stepper motor will be set to virual position 0.5
hw_input_add("ARDUINO_NANO_A_D6", function(state)
  if state then
    hw_stepper_motor_calibrate(id, 0.5)
  end
end)
```
