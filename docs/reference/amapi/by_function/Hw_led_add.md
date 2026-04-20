---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_led_add
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_led_add
Revision: 3173
---

# Hw led add

## Signature

```
hw_led_id = hw_led_add(name, initial_brightness) (from AM/AP 3.5) hw_led_id = hw_led_add(hw_id, initial_brightness)
```

## Description

hw_led_add is used to add a LED output to your instrument.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | A functional name to define the LED. |
| 2 | `initial_brightness` | Number/Bool | The initial state of the LED. Ranges from 1.0 or true (full brightness) to 0.0 or false (off). |
