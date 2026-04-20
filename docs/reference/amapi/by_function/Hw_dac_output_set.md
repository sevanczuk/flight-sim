---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_dac_output_set
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_dac_output_set
Revision: 2202
---

# Hw dac output set

## Signature

```
hw_dac_output_set(hw_dac_output_id, value)
```

## Description

hw_dac_output_set is used to set a hardware output to a certain state.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_dac_output_id` | String | The is the reference to the DAC output. You can get this reference from the hw_dac_output_add function. |
| 2 | `value` | Number | The state to set the output. Ranges from 0.0 (GND) to 1.0 (VCC) |

## Examples

### Example

```lua
-- Bind to Raspberry Pi 2, Header P1, Pin 38, and drive the output right between GND and VCC
outp_id = hw_dac_output_add("HW_PORT_A3", 0.5)

-- Nah, rather have the output on a higher voltage
hw_dac_output_set(outp_id, 0.9)
```
