---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: variable_subscribe
Namespace: Variable
Source URL: https://wiki.siminnovations.com/index.php?title=Variable_subscribe
Revision: 5873
---

# Variable subscribe

## Signature

```
variable_subscribe(source,variable_name,type,...,callback_function)
```

## Description

variable_subscribe is used to subscribe to more different data sources, such as X-Plane, FSX and SI variables.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 .. n | `source` | String | Can be "XPLANE", "FS2020", "FS2024", "FSX", "PREPAR3D" or "SI" |
| 2 .. n | `variable_name` | String | The name of the variable. This name depends on the source used. |
| 3 .. n | `data_type` | String | Data type of the variable. This depends on the source used. In general it can be INT,FLOAT,DOUBLE,INT[n],FLOAT[n],DOUBLE[n], BYTE[n] or STRING. |
| last | `callback_function` | String | The function to call when new data is available |

## Examples

### Example

```lua
-- Note that the order in which the variables are given to the variable_subscribe function determines the order in which the variables will enter this function

-- In our case 
-- "sim/cockpit2/gauges/indicators/altitude_ft_pilot" maps to "altitude"
-- "TIME ZULU" maps to "time_seconds"
-- "MY_CUSTOM_VARIABLE" maps to "my_custom_variable"
function callback_function(altitude, time_seconds, my_custom_variable)
  print("Altitude from X-Plane=" .. altitude)
  print("Time seconds from FSX=" .. time_seconds)
  print("My Custom variable from SI=" .. my_custom_variable)
end

-- multi subscribe
variable_subscribe("XPLANE", "sim/cockpit2/gauges/indicators/altitude_ft_pilot",  "FLOAT",
                   "FSX", "TIME ZULU", "Seconds",
                   "SI", "MY_CUSTOM_VARIABLE", "INT", callback_function)
```
