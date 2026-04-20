---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: user_prop_add_string
Namespace: User
Source URL: https://wiki.siminnovations.com/index.php?title=User_prop_add_string
Revision: 2390
---

# User prop add string

## Signature

```
user_prop_id = user_prop_add_string(name, default_value, description)
```

## Description

user_prop_add_string will add an additional user customizable setting to your instrument of the type string (text).

## Return value

user_prop_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | The name of the user property. This name must be unique (there may only be one user property of a certain name in an instrument) |
| 2 | `default_value` | String | The default value of the property. The is the value the property gets when the user adds the instrument to a panel. |
| 3 | `description` | String | A description of the property, explaining to the user what function this user property has. |

## Examples

### Example

```lua
-- Let's give our instrument a property
title_prop = user_prop_add_string("Title", "Default title", "Text that shows up at the top of the instrument")

-- We can check here what the user has configured
print("Title: " .. user_prop_get(title_prop) )
```
