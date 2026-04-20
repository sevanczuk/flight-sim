---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: user_prop_add_percentage
Namespace: User
Source URL: https://wiki.siminnovations.com/index.php?title=User_prop_add_percentage
Revision: 3496
---

# User prop add percentage

## Signature

```
user_prop_id = user_prop_add_percentage(name, min, max, default_value, description)
```

## Description

user_prop_add_percentage will add an additional user customizable setting to your instrument with a percentage type.

## Return value

user_prop_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | The name of the user property. This name must be unique (there may only be one user property of a certain name in an instrument) |
| 2 | `min` | Number | The minimum value of the property. (0= 0%, 1=100%) |
| 3 | `max` | Number | The maximum value of the property. (0= 0%, 1=100%) |
| 4 | `default_value` | Number | Default percentage. (0= 0%, 1=100%) |
| 5 | `description` | String | A description of the property, explaining to the user what function this user property has. |

## Examples

### Example

```lua
-- Let's give our instrument two properties
display_brightness_id = user_prop_add_percentage("Display brightness", 0.0, 1.0, 1.0, "Move the slider to adjust the display brightness")

-- We can check here what the user has configured
print("Display brightness = " .. user_prop_get(display_brightness_id) )
```
