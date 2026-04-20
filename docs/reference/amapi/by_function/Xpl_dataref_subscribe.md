---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: xpl_dataref_subscribe
Namespace: Xpl
Source URL: https://wiki.siminnovations.com/index.php?title=Xpl_dataref_subscribe
Revision: 5103
---

# Xpl dataref subscribe

## Signature

```
xpl_dataref_subscribe(dataref,type,...,callback_function)
```

## Description

xpl_dataref_subscribe is used to subscribe to one or more X-Plane datarefs. You can find the available datarefs [here](https://developer.x-plane.com/datarefs/).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 .. n | `dataref` | String | Reference to a dataref from X-Plane (see X-Plane DataRefs) |
| 2 .. n | `type` | String | Data type of the DataRef, can be INT,FLOAT,DOUBLE,INT[n],FLOAT[n],DOUBLE[n], BYTE[n] or STRING |
| last | `callback_function` | Function | The function to call when new data is available |

## Examples

### Example (single dataref)

```lua
-- This function will be called when new data is available from X-Plane
 function new_altitude_callback(altitude)
   print("New altitude: " .. altitude)
 end

 -- subscribe X-Plane datarefs
 xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/altitude_ft_pilot", "FLOAT", new_altitude_callback)
```

### Example (single array dataref)

```lua
-- This function will be called when new data is available from X-Plane
 function new_PT_rpm_callback(engine_ff)
   -- #engine_ff would give the array length
   -- data[1] would give the first object in the array
   print("Array contains " .. #engine_ff .. " items. Data on first position is: " .. engine_ff[1])
 end

 -- subscribe X-Plane datarefs
 xpl_dataref_subscribe("sim/flightmodel/engine/ENGN_FF_", "FLOAT[8]", new_PT_rpm_callback)
```

### Example (multi dataref)

```lua
-- It is also possible to subscribe to multiple datarefs
 -- Note that the order in which the datarefs are given to the xpl_dataref_subscribe function determines the order in which the datarefs will enter this function

 -- In our case 
 -- "sim/cockpit2/gauges/indicators/altitude_ft_pilot" maps to "altitude"
 -- "sim/cockpit2/gauges/indicators/airspeed_kts_pilot" maps to "speed"
 function new_altitude_and_speed_callback(altitude, speed)
   print("Altitude=" .. altitude .. " Speed=" .. speed)
 end

 -- multi subscribe
 xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/altitude_ft_pilot",  "FLOAT",
                       "sim/cockpit2/gauges/indicators/airspeed_kts_pilot", "FLOAT", new_altitude_and_speed_callback)
```

## External references

- [here](https://developer.x-plane.com/datarefs/)
