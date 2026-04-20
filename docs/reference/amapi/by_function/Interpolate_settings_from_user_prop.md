---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: interpolate_settings_from_user_prop
Namespace: Interpolate
Source URL: https://wiki.siminnovations.com/index.php?title=Interpolate_settings_from_user_prop
Revision: 3590
---

# Interpolate settings from user prop

## Signature

```
value = interpolate_settings_from_user_prop(user_prop_table_value)
```

## Description

interpolate_settings_from_user_prop is used to create interpolate settings from a table user property.

## Return value

settings

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `user_prop_table_value` | Table | Value from a table user property. Can be obtained by calling user_prop_get on your table user property. See example below. |

## Examples

### Example

```lua
-- Create a table with two columns
local val = user_prop_add_table("Needle calibration", "Fill table with calibration data",
                                  "Speed", "DOUBLE", 0, "Fill in the speed of the flight simulator",
                                  "Needle position", "DOUBLE", 0, "Set needle position in steps")

-- Create interpolate settings from user property
local settings = interpolate_settings_from_user_prop(user_prop_get(val))

-- Interpolate using settings made by the user
local var = interpolate_linear(settings, 25)

--Print result
print(var)
```
