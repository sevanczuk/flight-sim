---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: interpolate_linear
Namespace: Interpolate
Source URL: https://wiki.siminnovations.com/index.php?title=Interpolate_linear
Revision: 4449
---

# Interpolate linear

## Signature

```
value = interpolate_linear(settings, value) value = interpolate_linear(settings, value, cap) (from AM/AP 4.1)
```

## Description

interpolate_linear is used to interpolate a value with given settings.

## Return value

value

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `settings` | Table | Interpolate settings. Can be manually created (see example), or created from table user property with interpolate_settings_from_user_prop function. Make sure all settings are provided in ascending order. |
| 2 | `value` | Number | Input value. |
| 3 | `cap` | Boolean | (Optional, default false) When input range is outside of settings and cap is false, nil is returned. Otherwise the min or max output value is returned. |

## Examples

### Example (manual settings)

```lua
-- Create interpolate settings in ascending order
local settings = { { 0 , 0   },
                   { 10, 100 },
                   { 20, 200 },
                   { 30, 400 } }

-- Interpolate 25 (between 20-30)
local var = interpolate_linear(settings, 25)

-- Will print 300
print(var)
```

### Example (table user property)

```lua
-- Create a table with two columns in ascending order
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

### Example (using cap)

```lua
-- Create interpolate settings in ascending order
local settings = { { 0 , 0   },
                   { 10, 100 },
                   { 20, 200 },
                   { 30, 400 } }

-- Interpolate 40 (outside of input range)
var = interpolate_linear(settings, 40)

-- Will print nil
print(var)

-- Interpolate 40 again with cap set to true
var = interpolate_linear(settings, 40, true)

-- Will print 400
print(var)
```
