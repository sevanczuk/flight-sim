---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: si_variable_write
Namespace: Si
Source URL: https://wiki.siminnovations.com/index.php?title=Si_variable_write
Revision: 3545
---

# Si variable write

## Signature

```
si_variable_write(var_id, value)
```

## Description

si_variable_write is used write to an Air Manager variable. Global variables can be used to communicate between instruments.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `var_id` | String | Reference to a global variable. Can be obtained using si_variable_create. |
| 2 | `value` | Object | The new value to write. You have to obay to the data type you have chosen in the si_variable_create function. It is not allowed to change type at runtime. |

## Examples

### Example

```lua
-- Create a new variable
var_id = si_variable_create("my_variable", "FLOAT", 1.5)

-- Changed my mind, I want it to be 2.5
si_variable_write(var_id, 2.5)
```
