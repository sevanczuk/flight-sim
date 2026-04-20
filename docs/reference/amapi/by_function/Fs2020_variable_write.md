---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fs2020_variable_write
Namespace: Fs2020
Source URL: https://wiki.siminnovations.com/index.php?title=Fs2020_variable_write
Revision: 5028
---

# Fs2020 variable write

## Signature

```
fs2020_variable_write(variable, unit, value)
```

## Description

fs2020_variable_write is used write a variable to FS2020 You can find the available variables for F2020 [here (official)](https://docs.flightsimulator.com/html/Programming_Tools/SimVars/Simulation_Variables.htm).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `variable` | String | Reference to a variable from Flight Simulator 2020 |
| 2 | `unit` | String | Unit of the variable, can be found with the variable. Different units can be used for different variables. For example Hours, Knots and RPM. |
| 3 | `value` | Number | The value to be written |

## Examples

### Examples

```lua
-- Write false to variable "GENERAL ENG GENERATOR ACTIVE:1"
fs2020_variable_write("GENERAL ENG GENERATOR ACTIVE:1", "Bool", false)
```

### Examples

```lua
-- Write to a LVAR. Note that LVAR's are very specific variables only used with a certain aircraft model
fs2020_variable_write("L:MSATR_MCDU1_L1", "Enum", 1)
```

## External references

- [here (official)](https://docs.flightsimulator.com/html/Programming_Tools/SimVars/Simulation_Variables.htm)
