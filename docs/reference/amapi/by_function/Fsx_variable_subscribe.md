---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fsx_variable_subscribe
Namespace: Fsx
Source URL: https://wiki.siminnovations.com/index.php?title=Fsx_variable_subscribe
Revision: 4618
---

# Fsx variable subscribe

## Signature

```
fsx_variable_subscribe(variable,unit,callback_function)
```

## Description

fsx_variable_subscribe is used to subscribe on one or more FSX or Prepar3D variables. You can find the available variables for FSX [here](http://msdn.microsoft.com/en-us/library/cc526981.aspx) and the Prepar3D variables [here (official)](https://www.prepar3d.com/SDKv5/sdk/references/variables/simulation_variables.html).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 .. n | `variable` | String | Reference to a variable from Flight Simulator X or Prepar3D |
| 2 .. n | `unit` | String | Unit of the variable, can be found with the variable. Different units can be used for different variables. For example Hours, Knots and RPM (look here for FSX units and here for Prepar3D) |
| last | `callback_function` | Function | The function to call when new data is available |

## Examples

### Examples

```lua
-- This function will be called when new data is available from FSX or Prepar3D
 function new_altitude_callback(altitude)
   -- Prints the altitude in the debug window
   print("New altitude: " .. altitude)
 end

 -- subscribe to FSX / Prepar3D variables on the databus
 fsx_variable_subscribe("INDICATED ALTITUDE", "Feet", new_altitude_callback)
```

### Examples

```lua
-- This function will be called when new data is available from FSX or Prepar3D
 function new_rpm_callback(engine_rpm)
   -- Prints the RPM for engine 2 in the debug window
   print("The RPM for engine 2 is: " .. engine_rpm)
 end

 -- subscribe FSX / Prepar3D variables on the databus
 fsx_variable_subscribe("GENERAL ENG RPM:2", "Rpm", new_rpm_callback)
```

### Examples

```lua
-- It is also possible to subscribe to multiple variables
 -- Note that the order in which the variables are given to the fsx_variable_subscribe function determines the order in which the variables will enter the callback function

 -- In our case 
 -- "INDICATED ALTITUDE" maps to "altitude"
 -- "AIRSPEED INDICATED" maps to "speed"
 function new_altitude_and_speed_callback(altitude, speed)
   print("Altitude=" .. altitude .. " Speed=" .. speed)
 end

 -- multi subscribe
 fsx_variable_subscribe("INDICATED ALTITUDE", "Feet",
                       "AIRSPEED INDICATED", "Knots", new_altitude_and_speed_callback)
```

### Examples

```lua
-- This function will be called when new data is available from FSX or Prepar3D
 function new_rpm_callback(engine_rpm)
   -- Prints the A2A Cessna 172 engine RPM in the debug window
   print("The RPM is: " .. engine_rpm)
 end

 -- Subscribe FSX / Prepar3D A2A Cessna 172 LVAR on the databus
 -- Use L: in front of the LVAR name to indicate that it is an LVAR you are using
 fsx_variable_subscribe("L:Eng1_RPM", "RPM", new_rpm_callback)
```

### Examples

```lua
-- This function will be called when new data is available from FSX or Prepar3D
 function new_data(engine_rpm, hobbs)
   -- Prints the A2A Cessna 172 engine RPM and engine hours in the debug window. Use \n to create a new line when printing in the debug window.
   print("The RPM is: " .. engine_rpm .. "\nThe number of hobbs hours is: " .. hobbs)
 end

 -- Subscribe FSX / Prepar3D A2A Cessna 172 LVAR on the databus
 -- Use L: in front of the LVAR name to indicate that it is an LVAR you are using
 fsx_variable_subscribe("L:Eng1_RPM", "RPM",
                        "L:Counter1Hours", "hours", new_data)
```

### Examples

```lua
-- Subscribing to a PMDG variable works the same as FSX variables.
 -- Be sure to use the exact same key and type name from the PMDG variable list.

 function new_PMDG_data_callback(fqtyc, startvalve1, startvalve2, domeswitch)
   print("Fuel quantity center = " .. fqtyc .. "\nStarter valve 1 open = " .. tostring(startvalve1) .. "\nStarter valve 2 open = " .. tostring(startvalve2) .. "\nDome light switch setting = " .. domeswitch)
 end
 
 -- multi subscribe
 fsx_variable_subscribe("PMDG 737NGX:FUEL_QtyCenter", "NUMBER",
                        "PMDG 737NGX:ENG_StartValve:1", "BOOL",
                        "PMDG 737NGX:ENG_StartValve:2", "BOOL",
                        "PMDG 737NGX:LTS_DomeWhiteSw", "ENUM", new_PMDG_data_callback)
```

## External references

- [here](http://msdn.microsoft.com/en-us/library/cc526981.aspx)
- [here (official)](https://www.prepar3d.com/SDKv5/sdk/references/variables/simulation_variables.html)
