---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: ext_variable_subscribe
Namespace: Ext
Source URL: https://wiki.siminnovations.com/index.php?title=Ext_variable_subscribe
Revision: 5696
---

# Ext variable subscribe

## Signature

```
ext_variable_subscribe(source_tag,variable,data_type,...,callback_function)
```

## Description

ext_variable_subscribe is used to subscribe on one or more external source variables. External source can be used to connect Air Manager to other third party programs. This function is only supported in the Professional version of Air Manager

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `source_tag` | String | The data source tag. The source tag can be configured in the settings part of Air Manager. |
| 2 .. n | `variable` | String | Reference to an Sim Innovations variable |
| 3 .. n | `data_type` | String | Data type of the variable, can be INT, FLOAT, DOUBLE, BYTE, BOOL, STRING, INT[n], FLOAT[n], DOUBLE[n] or BYTE[n] |
| last | `callback_function` | String | The function to call when new data is available |

## Examples

### Example (single subscribe)

```lua
-- This function will be called when new data is available from another instrument
 function new_data_callback(data1)
   print("New data1: " .. data1)
 end

 -- subscribe to Air Manager variable
 ext_variable_subscribe("my_data_source", "my_variable", "FLOAT", new_data_callback)
```

### Example (single array subscribe)

```lua
-- This function will be called when new data is available from another instrument
 function new_data_callback(data1)
   -- #data1 would give the array length
   -- data[1] would give the first object in the array
   print("Array contains " .. #data1.. " items. Data on first position is: " .. data1[1])
 end

 -- subscribe X-plane datarefs on the AirBus
 ext_variable_subscribe("my_data_source", "my_variable", "FLOAT[8]", new_data_callback)
```

### Example (multi subscribe)

```lua
-- It is also possible to subscribe to multiple variables
 -- Note that the order in which the variables are given to the ext_variable_subscribe function determines the order in which the variables will enter this function

 -- In our case 
 -- "my_variable_1" maps to "data1"
 -- "my_variable_2" maps to "data2"
 function new_data_callback(data1, data2)
   print("data1=" .. data1.. " data2=" .. data2)
 end

 -- multi subscribe
 ext_variable_subscribe("my_data_source", 
                        "my_variable_1", "FLOAT",
                        "my_variable_2", "FLOAT", new_data_callback)
```
