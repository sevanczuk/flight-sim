---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: xpl_dataref_write
Namespace: Xpl
Source URL: https://wiki.siminnovations.com/index.php?title=Xpl_dataref_write
Revision: 5009
---

# Xpl dataref write

## Signature

```
xpl_dataref_write(dataref,type,value,offset,force)
```

## Description

xpl_dataref_write is used write a dataref to X-Plane. You can find the available datarefs [here](https://developer.x-plane.com/datarefs/).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `dataref` | String | Reference to a dataref from X-Plane (see X-Plane DataRefs) |
| 2 | `type` | Number | Data type of the DataRef, can be INT, FLOAT, DOUBLE, BYTE, STRING, INT[n], FLOAT[n], DOUBLE[n] or BYTE[n] |
| 3 | `value` | Number | The value to be written |
| 4 | `offset` | Number | Optional field. Only to be used when writing arrays. Your value will start writing at a certain array offset. Starts at 0. |
| 5 | `force` | Boolean | Optional field, available from AM 2.1.1. Enabling this feature will make AM write the dataref every simulator frame. Make sure to disable the forcing again at some point in your code! |

## Examples

### Example

```lua
-- Write 99 to dataref "sim/cockpit2/radios/actuators/com1_standby_frequency_hz"
xpl_dataref_write("sim/cockpit2/radios/actuators/com1_standby_frequency_hz", "INT", 99)

-- Write 4 values to array dataref "sim/cockpit/switches/anti_ice_inlet_heat_per_enigne".
xpl_dataref_write("sim/cockpit/switches/anti_ice_inlet_heat_per_enigne", "INT[8]", {1, 1, 0, 1})

-- Write 4 values to array dataref with an offset "sim/aircraft/panel/acf_ins_size". Using an offset. [10]=0.1 , [11]=0.2, [12]=0.3, [13]=0.4
xpl_dataref_write("sim/aircraft/panel/acf_ins_size", "FLOAT[200]", {0.1, 0.2, 0.3, 0.4}, 9)
```

## External references

- [here](https://developer.x-plane.com/datarefs/)
