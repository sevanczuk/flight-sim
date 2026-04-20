---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fsx_variable_write
Namespace: Fsx
Source URL: https://wiki.siminnovations.com/index.php?title=Fsx_variable_write
Revision: 4766
---

# Fsx variable write

## Signature

```
fsx_variable_write(variable, unit, value)
```

## Description

fsx_variable_write is used write a variable to FSX or Prepar3D You can find the available variables for FSX [here](http://msdn.microsoft.com/en-us/library/cc526981.aspx) and the Prepar3D variables [here (official)](https://www.prepar3d.com/SDKv5/sdk/references/variables/simulation_variables.html).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `variable` | String | Reference to a variable from Flight Simulator X or Prepar3D |
| 2 | `unit` | String | Unit of the variable, can be found with the variable. Different units can be used for different variables. For example Hours, Knots and RPM (look here for FSX units and here for Prepar3D) |
| 3 | `value` | Number | The value to be written |

## Examples

### Examples

```lua
-- Write false to variable "GENERAL ENG GENERATOR ACTIVE:1"
fsx_variable_write("GENERAL ENG GENERATOR ACTIVE:1", "Bool", false)
```

### Examples

```lua
-- Write 50 to the IAS/TAS conversion chart
fsx_variable_write("L:AirspeedTAS", "number", 50)
```

## External references

- [here](http://msdn.microsoft.com/en-us/library/cc526981.aspx)
- [here (official)](https://www.prepar3d.com/SDKv5/sdk/references/variables/simulation_variables.html)
