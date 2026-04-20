---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: user_prop_add_real
Namespace: User
Source URL: https://wiki.siminnovations.com/index.php?title=User_prop_add_real
Revision: 2744
---

# User prop add real

## Signature

```
user_prop_id = user_prop_add_real(name, min, max, default_value, description)
```

## Description

user_prop_add_real will add an additional user customizable setting to your instrument of the type float.

## Return value

user_prop_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | The name of the user property. This name must be unique (there may only be one user property of a certain name in an instrument) |
| 2 | `min` | Number | The minimum value of the property. |
| 3 | `max` | Number | The maximum value of the property. |
| 4 | `default_value` | Number | The default value of the property. The is the value the property gets when the user adds the instrument to a panel. |
| 5 | `description` | String | A description of the property, explaining to the user what function this user property has. |

## Examples

### Example

```lua
-- Let's give our instrument two properties
warn_user_prop = user_prop_add_real("Warning Speed Limit", 2.2, 3.0, 2.5, "Speed limit where the warning light should be visible")
alert_user_prop = user_prop_add_real("Alert Speed Limit", 4.3, 5.3, 5.0, "Speed limit where the alert light should be visible")

-- We can check here what the user has configured
print("The warning alarm is set to " .. tostring(user_prop_get(warn_user_prop) ) )
print("The Alert alarm is set to " .. tostring(user_prop_get(alert_user_prop) ) )
```
