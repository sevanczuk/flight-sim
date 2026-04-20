---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fs2020_variable_subscribe
Namespace: Fs2020
Source URL: https://wiki.siminnovations.com/index.php?title=Fs2020_variable_subscribe
Revision: 5227
---

# Fs2020 variable subscribe

## Signature

```
fs2020_variable_subscribe(variable, unit, callback_function)
```

## Description

fs2020_variable_subscribe is used to subscribe on one or more FS2020 variables. You can find the available variables for F2020 [here (official)](https://docs.flightsimulator.com/html/Programming_Tools/SimVars/Simulation_Variables.htm).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 .. n | `variable` | String | Reference to a variable from Flight Simulator 2020. Use prefix 'L:' for LVARS, see example below. |
| 2 .. n | `unit` | String | Unit of the variable, can be found with the variable. Different units can be used for different variables. For example Hours, Knots and RPM. |
| last | `callback_function` | Function | The function to call when new data is available |

## Examples

### Examples

```lua
-- This function will be called when new data is available from FS2020
 function new_altitude_callback(altitude)
   -- Prints the altitude in the debug window
   print("New altitude: " .. altitude)
 end

 -- subscribe to FS2020 variable
 fs2020_variable_subscribe("INDICATED ALTITUDE", "Feet", new_altitude_callback)
```

### Examples

```lua
-- This function will be called when new data is available from FS2020
 function new_rpm_callback(engine_rpm)
   -- Prints the RPM for engine 2 in the debug window
   print("The RPM for engine 2 is: " .. engine_rpm)
 end

 -- subscribe to FS2020 variable
 fs2020_variable_subscribe("GENERAL ENG RPM:2", "Rpm", new_rpm_callback)
```

### Examples

```lua
-- It is also possible to subscribe to multiple variables
 -- Note that the order in which the variables are given to the fs2020_variable_subscribe function determines the order in which the variables will enter the callback function

 -- In our case 
 -- "INDICATED ALTITUDE" maps to "altitude"
 -- "AIRSPEED INDICATED" maps to "speed"
 function new_altitude_and_speed_callback(altitude, speed)
   print("Altitude=" .. altitude .. " Speed=" .. speed)
 end

 -- multi subscribe
 fs2020_variable_subscribe("INDICATED ALTITUDE", "Feet",
                           "AIRSPEED INDICATED", "Knots", new_altitude_and_speed_callback)
```

### Examples

```lua
-- This function will be called when new data is available from FS2020
 function new_rpm_callback(engine_rpm)
   -- Prints the A2A Cessna 172 engine RPM in the debug window
   print("The RPM is: " .. engine_rpm)
 end

 -- Subscribe FS2020 Cessna 172 LVAR on the databus
 -- Use L: in front of the LVAR name to indicate that it is an LVAR you are using
 fs2020_variable_subscribe("L:Eng1_RPM", "RPM", new_rpm_callback)
```

### Examples

```lua
-- This function will be called when new data is available from FS2020
 function new_data(engine_rpm, hobbs)
   -- Prints the A2A Cessna 172 engine RPM and engine hours in the debug window. Use \n to create a new line when printing in the debug window.
   print("The RPM is: " .. engine_rpm .. "\nThe number of hobbs hours is: " .. hobbs)
 end

 -- Subscribe FS2020 172 LVAR on the databus
 -- Use L: in front of the LVAR name to indicate that it is an LVAR you are using
 fs2020_variable_subscribe("L:Eng1_RPM", "RPM",
                           "L:Counter1Hours", "hours", new_data)
```

## External references

- [here (official)](https://docs.flightsimulator.com/html/Programming_Tools/SimVars/Simulation_Variables.htm)
