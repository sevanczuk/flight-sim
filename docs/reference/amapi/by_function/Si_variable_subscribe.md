---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: si_variable_subscribe
Namespace: Si
Source URL: https://wiki.siminnovations.com/index.php?title=Si_variable_subscribe
Revision: 5012
---

# Si variable subscribe

## Signature

```
si_variable_subscribe(variable,type,...,callback_function)
```

## Description

si_variable_subscribe is used to subscribe on one or more global variables. Global variables can be used to communicate between instruments.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 .. n | `variable` | String | Reference to a global variable |
| 2 .. n | `type` | String | Data type of the variable, can be INT, FLOAT, DOUBLE, BYTE, BOOL, STRING, INT[n], FLOAT[n], DOUBLE[n] or BYTE[n] |
| last | `callback_function` | Function | The function to call when new data is available |

## Examples

### Example (single variable)

```lua
-- Create the variable
 var1 = si_variable_create("my_variable", "FLOAT", 0) 

 -- This function will be called when new data is available from another instrument
 function new_data_callback(data1)
   print("New data1: " .. data1)
 end

 -- Subscribe to the global variable
 si_variable_subscribe("my_variable", "FLOAT", new_data_callback)
```

### Example (single array variable)

```lua
-- This function will be called when new data is available from another instrument
 function new_data_callback(data1)
   -- #data1 would give the array length
   -- data[1] would give the first object in the array
   print("Array contains " .. #data1.. " items. Data on first position is: " .. data1[1])
 end

 -- subscribe to the variable
 si_variable_subscribe("my_variable", "FLOAT[8]", new_data_callback)
```

### Example (multi variable)

```lua
-- It is also possible to subscribe to multiple variables
 -- Note that the order in which the variables are given to the si_variable_subscribe function determines the order in which the variables will enter this function

 -- In our case 
 -- "my_variable_1" maps to "data1"
 -- "my_variable_2" maps to "data2"
 function new_data_callback(data1, data2)
   print("data1=" .. data1.. " data2=" .. data2)
 end

 -- multi subscribe
 si_variable_subscribe("my_variable_1", "FLOAT",
                       "my_variable_2", "FLOAT", new_data_callback)
```
