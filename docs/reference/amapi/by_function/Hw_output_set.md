---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_output_set
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_output_set
Revision: 1840
---

# Hw output set

## Signature

```
hw_output_set(hw_output_id, state)
```

## Description

hw_output_set is used to set a hardware output to a certain state.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_output_id` | String | The is the reference to the output. You can get this reference from the hw_output_add function. |
| 2 | `state` | Boolean | The state to set the output. When true, the pin will be driven high, otherwise low. |

## Examples

### Example

```lua
-- Bind to Raspberry Pi 2, Header P1, Pin 38, and drive the output high
outp_id = hw_output_add("RPI_V2_P1_38", true)

-- Nah, rather have the output low
hw_output_set(outp_id, false)
```
