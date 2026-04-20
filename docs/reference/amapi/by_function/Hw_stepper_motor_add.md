---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_stepper_motor_add
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_stepper_motor_add
Revision: 3294
---

# Hw stepper motor add

## Signature

```
hw_stepper_motor_id = hw_stepper_motor_add(name, type, nr_steps, speed_rpm) (from AM/AP 3.5) hw_stepper_motor_id = hw_stepper_motor_add(name, type, nr_steps, speed_rpm, circular) (from AM/AP 3.6) hw_stepper_motor_id = hw_stepper_motor_add(type, nr_steps, speed_rpm, hw_id_1, hw_id_2, ...) (AM/AP 3.5) hw_stepper_motor_id = hw_stepper_motor_add(type, nr_steps, speed_rpm, circular, hw_id_1, hw_id_2, ...) (from AM/AP 3.6)
```

## Description

hw_stepper_motor_add is used to add a Hardware stepper motor.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | A functional name to define the stepper motor. |
| 2 | `type` | String | Type of stepper motor. Can be "4WIRE_4STEP", "4WIRE_6STEP" or "4WIRE_8STEP". |
| 3 | `nr_steps` | Number | Number of steps for one full rotation. |
| 4 | `speed_rpm` | Number | Speed of the stepper motor, in rounds per minute. |
| 5 | `circular` | Boolean | (Optional) Determines if the stepper motor rotate endlessly. Defaults to true. |
