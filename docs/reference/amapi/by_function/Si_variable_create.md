---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: si_variable_create
Namespace: Si
Source URL: https://wiki.siminnovations.com/index.php?title=Si_variable_create
Revision: 4682
---

# Si variable create

## Signature

```
var_id = si_variable_create(variable, type, initial_value)
```

## Description

si_variable_create is used to create a global variable. A global variables can be used to communicate between instruments.

## Return value

var_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `variable` | String | Name of the variable |
| 2 | `type` | String | Data type of the variable, can be INT, FLOAT, DOUBLE, BYTE, BOOL, STRING, INT[n], FLOAT[n], DOUBLE[n] or BYTE[n] |
| 3 | `initial_value` | Object | Set the initial value for this variable. |

## Examples

### Example

```lua
-- Create a new variable
var_id = si_variable_create("my_variable", "FLOAT", 1.5)

-- Changed my mind, I want it to be 2.5
si_variable_write(var_id, 2.5)
```

### Example with an array

```lua
-- Create a new variable array
var_id = si_variable_create("my_variable", "FLOAT[4]", {1, 3.2, 5, 5.6})

-- Changed my mind, set all values to 0
si_variable_write(var_id, {0, 0, 0, 0})
```
