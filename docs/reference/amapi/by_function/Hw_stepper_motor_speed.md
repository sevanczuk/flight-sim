---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_stepper_motor_speed
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_stepper_motor_speed
Revision: 2651
---

# Hw stepper motor speed

## Signature

```
hw_stepper_motor_speed(hw_stepper_motor_id, speed_rpm)
```

## Description

hw_stepper_motor_speed is used to set the speed of of the stepper motor.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_stepper_motor_id` | Object | The is the reference to the stepper motor. You can get this reference from the hw_stepper_motor_add function. |
| 2 | `speed` | rpm | The desired speed in rounds per minute (rpm). |

## Examples

### Example

```lua
-- Initiate stepper motor with:
-- 2048 steps
-- 10 rpm speed
-- On pins A2, A3, A4 and A5 of an Arduino Nano
id = hw_stepper_motor_add("DIRECT_4WIRE", 2048, 10, "ARDUINO_NANO_A_D2", "ARDUINO_NANO_A_D3", "ARDUINO_NANO_A_D4", "ARDUINO_NANO_A_D5")

-- Change speed to 5 rpm
hw_stepper_motor_speed(id, 5)
```
