---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_connected
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_connected
Revision: 3047
---

# Hw connected

## Signature

```
value = hw_connected(hw_node_id) value = hw_connected(hw_id)
```

## Description

hw_connected is used to check if the given hardware node or hardware id is connected to the hardware.

## Return value

connected

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_node_id / hw_id` | Hardware node / String | Can be a hw_node_id, which is a reference to a certain hardware node. It is received from the hw_button_add, hw_switch_add, hw_dial_add etc. functions. Alternatively, it can also be a hardware id (Hardware ID list). |

## Examples

### Example (Hardware node)

```lua
id = hw_button_add("My button", function()
  -- Button is pressed
end)

if hw_connected(id) then
  print("The button is connected to the hardware")
end
```

### Example (Hardware id)

```lua
if hw_connected("ARDUINO_NANO_A_D11") then
  print("Pin D11 on Arduino Nano on channel A is connected")
end
```
