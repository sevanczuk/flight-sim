---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_output_add
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_output_add
Revision: 2773
---

# Hw output add

## Signature

```
hw_output_id = hw_output_add(name, initial_state) (from AM/AP 3.5) hw_output_id = hw_output_add(hw_id, initial_state)
```

## Description

hw_output_add is used to add a hardware output to your instrument.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | A functional name to define the output. |
| 2 | `initial_state` | Boolean | The initial state of the output. When true, the pin will be driven high, otherwise low. |
