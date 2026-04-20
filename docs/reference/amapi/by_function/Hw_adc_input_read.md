---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_adc_input_read
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_adc_input_read
Revision: 703
---

# Hw adc input read

## Signature

```
value = hw_adc_input_read(hw_adc_input_id)
```

## Description

hw_adc_input_read is used to read the value of a hardware ADC input.

## Return value

value

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_adc_input_id` | String | The is the reference to the ADC input. You can get this reference from the hw_adc_input_add function. |

## Examples

### Example

```lua
-- Callback function which is called when the ADC input value changes
function adc_input_change(value)
  print("new value = " .. tostring(value) )
end

-- Bind to pin 1 of Hardware port A
id = hw_adc_input_add("HW_PORT_A1", adc_input_change)

-- Read the actual state
value = hw_adc_input_read(id)
```
