---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_dac_output_add
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_dac_output_add
Revision: 4380
---

# Hw dac output add

## Signature

```
hw_dac_output_id = hw_dac_output_add(name, initial_value) (from AM/AP 3.5) hw_dac_output_id = hw_dac_output_add(hw_id, initial_value)
```

## Description

hw_dac_output_add is used to add a DAC hardware output to your instrument.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | A functional name to define the DAC output. |
| 2 | `initial_value` | Number | The initial state of the DAC output. Ranges from 0.0 (GND) to 1.0 (VCC) |
