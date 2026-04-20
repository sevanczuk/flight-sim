---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_led_set
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_led_set
Revision: 2964
---

# Hw led set

## Signature

```
hw_led_set(hw_led_id, brightness)
```

## Description

hw_led_set is used to set a LED output to a certain brightness.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_led_id` | String | The is the reference to the LED output. You can get this reference from the hw_led_add function. |
| 2 | `brightness` | Number/Bool | The initial state of the LED. Ranges from 1.0 or true (full brightness) to 0.0 or false (off). |

## Examples

### Example

```lua
-- Bind to Raspberry Pi 2, Header P1, Pin 38, and drive the LED to full brightness
led_id = hw_led_add("RPI_V2_P1_38", 1.0)

-- Nah, rather have the LED set to 50% brightness
hw_led_set(led_id, 0.5)
```
