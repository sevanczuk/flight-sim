---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_button_add
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_button_add
Revision: 2763
---

# Hw button add

## Signature

```
hw_button_id = hw_button_add(name, pressed_callback, released_callback) (from AM/AP 3.5) hw_button_id = hw_button_add(hw_id, pressed_callback, released_callback)
```

## Description

hw_button_add is used to add a hardware button to your instrument.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | A functional name to define the button. |
| 2 | `pressed_callback` | Function | This function will be called when the button is pressed. |
| 3 | `released_callback` | Function | This function will be called when the button is released. |
