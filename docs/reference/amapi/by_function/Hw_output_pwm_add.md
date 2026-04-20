---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_output_pwm_add
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_output_pwm_add
Revision: 2777
---

# Hw output pwm add

## Signature

```
hw_output_pwm_id = hw_output_pwm_add(name, frequency_hz, initial_duty_cycle) (from AM/AP 3.5) hw_output_pwm_id = hw_output_pwm_add(hw_id, frequency_hz, initial_duty_cycle)
```

## Description

hw_output_pwm_add is used to add a hardware PWM output to your instrument.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | A functional name to define the PWM output. |
| 2 | `frequency_hz` | Number | The frequency of the PWM output signal, in Hz. |
| 3 | `initial_duty_cycle` | Number | The initial PWM duty cycle. Range 0.0 - 1.0, 0.0 being off, and 1.0 on. |
