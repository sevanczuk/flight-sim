---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_dial_add
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_dial_add
Revision: 5109
---

# Hw dial add

## Signature

```
hw_dial_id = hw_dial_add(name, callback) (from AM/AP 3.5) hw_dial_id = hw_dial_add(name, type, callback) (from AM/AP 3.5) hw_dial_id = hw_dial_add(name, acceleration, callback) (from AM/AP 3.5) hw_dial_id = hw_dial_add(name, type, acceleration, callback) (from AM/AP 3.5) hw_dial_id = hw_dial_add(name, type, acceleration, debounce, callback) (from AM/AP 3.5) hw_dial_id = hw_dial_add(hw_id_a, hw_id_b, callback) hw_dial_id = hw_dial_add(hw_id_a, hw_id_b, type, callback) hw_dial_id = hw_dial_add(hw_id_a, hw_id_b, acceleration, callback) hw_dial_id = hw_dial_add(hw_id_a, hw_id_b, type, acceleration, callback) hw_dial_id = hw_dial_add(hw_id_a, hw_id_b, type, acceleration, debounce, callback) (from AM/AP 3.5)
```

## Description

hw_dial_id is used to add a hardware rotary encoder to your instrument.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | A functional name to define the rotary encoder. |
| 2 | `type` | String | (Optional) Type of rotary encoder. Can be "TYPE_1_DETENT_PER_PULSE", "TYPE_2_DETENT_PER_PULSE" or "TYPE_4_DETENT_PER_PULSE". |
| 3 | `acceleration` | Number | (Optional) A multiplier that will make the dial generate extra callbacks when the dial is being rotated faster. The multiplier is the maximum number of callbacks of one dial tick when this dial is being rotated at maximum speed. |
| 4 | `debounce` | Number | (Optional) Select different debounce time in milliseconds. Default is 4 ms. |
| 5 | `callback` | Function | This function will be called when the rotary encoder rotates (both ways). The callback will provide one argument, direction, which is 1 for clockwise rotation, and -1 for counterclockwise rotation. |
