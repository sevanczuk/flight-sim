---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_input_add
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_input_add
Revision: 2772
---

# Hw input add

## Signature

```
hw_input_id = hw_input_add(name, callback) (from AM/AP 3.5) hw_input_id = hw_input_add(hw_id, callback)
```

## Description

hw_input_add is used to add a hardware input to your instrument.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | A functional name to define the input. |
| 2 | `callback` | Function | This function will be called when the input state changes. The callback will provide one argument, state, which is true when the input is high, and low when the pin is low. |
