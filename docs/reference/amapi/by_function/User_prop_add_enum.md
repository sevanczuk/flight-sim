---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: user_prop_add_enum
Namespace: User
Source URL: https://wiki.siminnovations.com/index.php?title=User_prop_add_enum
Revision: 2391
---

# User prop add enum

## Signature

```
user_prop_id = user_prop_add_enum(name, possible_values, default_value, description)
```

## Description

user_prop_add_enum will add an additional user customizable setting to your instrument of the type string (enum).

## Return value

user_prop_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | The name of the user property. This name must be unique (there may only be one user property of a certain name in an instrument) |
| 2 | `possible_values` | String | The possible values of the property. |
| 3 | `default_value` | String | The default value of the property. The is the value the property gets when the user adds the instrument to a panel. |
| 4 | `description` | String | A description of the property, explaining to the user what function this user property has. |

## Examples

### Example

```lua
-- Let's give our instrument two properties
choice_prop = user_prop_add_enum("Choices", "Choice 1,Choice 2,Choice 3", "Choice 1", "You can choose one of these three choices")

-- We can check here what the user has configured
print("Selected choice: " .. user_prop_get(choice_prop) )
```
