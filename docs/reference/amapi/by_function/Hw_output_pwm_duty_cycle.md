---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_output_pwm_duty_cycle
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_output_pwm_duty_cycle
Revision: 956
---

# Hw output pwm duty cycle

## Signature

```
hw_output_pwm_duty_cycle(hw_output_pwm_id, duty_cycle)
```

## Description

hw_output_pwm_duty_cycle is used to change the duty cycle of a PWM output.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_output_pwm_id` | String | The is the reference to the PWM output. You can get this reference from the hw_output_pwm_add function. |
| 2 | `duty_cycle` | Number | The new PWM duty cycle. Range 0.0 - 1.0, 0.0 being off, and 1.0 on. |

## Examples

### Example

```lua
-- Bind to Raspberry Pi 2, Header P1, Pin 40
-- PWM frequency is set to 1 kHz, with a duty cycle of 50%.
output_id = hw_output_pwm_add("RPI_V2_P1_03", 1000, 0.5)

-- We can change the duty cycle runtime, in this case 20%
hw_output_pwm_duty_cycle(output_id, 0.2)
```
