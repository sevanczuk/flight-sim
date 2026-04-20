---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_input_read
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_input_read
Revision: 1641
---

# Hw input read

## Signature

```
state = hw_input_read(hw_input_id)
```

## Description

hw_input_read is used to read the state of a hardware input.

## Return value

state

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_input_id` | String | The is the reference to the input. You can get this reference from the hw_input_add function. |

## Examples

### Example

```lua
-- Callback function which is called when the input state changes
function input_change(state)
  print("new state = " .. tostring(state) )
end

-- Bind to Raspberry Pi 2, Header P1, Pin 40
inp_id = hw_input_add("RPI_V2_P1_40", input_change)

-- Read the actual state
-- state true  : input is high
-- state false : input is low
state = hw_input_read(inp_id)
```
