---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_switch_add
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_switch_add
Revision: 2769
---

# Hw switch add

## Signature

```
hw_switch_id = hw_switch_add(name, nr_pins, callback) (from AM/AP 3.5) hw_switch_id = hw_switch_add(hw_id_0, hw_id_1, hw_pos_n,callback)
```

## Description

switch_add is used to add a hardware switch. Every position on the switch should use one hardware input.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | A functional name to define the switch. |
| 2 | `nr_pins` | Number | Number of input pins used for this switch. |
| 3 | `callback` | Function | This function will be called when the switch changed position. |
