---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: user_prop_add_table
Namespace: User
Source URL: https://wiki.siminnovations.com/index.php?title=User_prop_add_table
Revision: 3510
---

# User prop add table

## Signature

```
user_prop_id = user_prop_add_table(name, description, column_name, column_type, column_default_value, column_description, ...)
```

## Description

user_prop_add_percentage will add an additional user customizable setting to your instrument with a table.

## Return value

user_prop_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | The name of the user property. This name must be unique (there may only be one user property of a certain name in an instrument) |
| 2 | `description` | String | A description of the property, explaining to the user what function this user property has. |
| 3 .. n | `column_name` | String | Column name |
| 4 .. n | `column_type` | String | Column type, can be INT, DOUBLE, STRING or BOOLEAN |
| 5 .. n | `column_default_value` | Object | Default value for the column |
| 6 .. n | `column_description` | String | Column description |

## Examples

### Example

```lua
-- Create a table with two columns
local val = user_prop_add_table("Needle calibration", "Fill table with calibration data",
                                  "Speed", "STRING", "blabla222", "Fill in the speed of the flight simulator",
                                  "Needle position", "INT", 3, "Set needle position in Steps")

local rows = user_prop_get(val)
for row_index, row_cells in ipairs(rows) do
    for cell_index, cell_value in ipairs(row_cells) do
        print("row " .. row_index .. ", column " .. cell_index .. " has value " .. tostring(cell_value))
    end
end
```
