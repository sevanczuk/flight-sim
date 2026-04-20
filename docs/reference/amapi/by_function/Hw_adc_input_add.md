---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_adc_input_add
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_adc_input_add
Revision: 2774
---

# Hw adc input add

## Signature

```
hw_adc_input_id = hw_adc_input_add(name, callback) (from AM/AP 3.5) hw_adc_input_id = hw_adc_input_add(name, hysteresis, callback) (from AM/AP 3.5) hw_adc_input_id = hw_adc_input_add(hw_id, callback) hw_adc_input_id = hw_adc_input_add(hw_id, hysteresis, callback)
```

## Description

hw_adc_input_add is used to add a hardware ADC input to your instrument.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_id` | name | A functional name to define the ADC input. |
| 2 | `hysteresis` | Number | (Optional) Hysteresis value between 0.0 and 1.0. Increase the hysteresis if your ADC source is unstable. Default is 0.02. |
| 3 | `callback` | Function | This function will be called when the ADC input value changes. The callback will provide one argument, value, which ranged from 0.0 to 1.0 (in most cases ranges from GND -> VCC). |

## Examples

### Example

```lua
-- Callback function which is called when the ADC input state changes
-- 0.0 : GND (lowest voltage)
-- 1.0 : VCC (highest voltage)
function adc_input_change(value)
  print("new value= " .. tostring(value) )
end

-- Create a ADC input
hw_adc_input_add("Volume", adc_input_change)
```

### Example 2

```lua
-- Callback function which is called when the ADC input state changes
-- 0.0 : GND (lowest voltage)
-- 1.0 : VCC (highest voltage)
function adc_input_change(value)
  print("new value= " .. tostring(value) )
end

-- Bind to the first pin of hardware port A
hw_adc_input_add("HW_PORT_A1", adc_input_change)
```
