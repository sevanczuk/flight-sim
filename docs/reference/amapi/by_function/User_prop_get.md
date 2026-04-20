---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: user_prop_get
Namespace: User
Source URL: https://wiki.siminnovations.com/index.php?title=User_prop_get
Revision: 4262
---

# User prop get

## Signature

```
value = user_prop_get(user_prop_id)
```

## Description

user_prop_get(user_prop_id) is used to get data from a a user property.

## Return value

value

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `user_prop_id` | String | user_prop_id is the reference to a certain user property. It is received from the user_prop_add_integer, user_prop_add_boolean, user_prop_add_string etc. functions. |

## Examples

### Example

```lua
-- Let's give our instrument two properties
screws_prop = user_prop_add_boolean("Show screws", true, "Show the screws")
bezel_prop  = user_prop_add_boolean("Show bezel", true, "Show the bezel")

-- We can check here what the user has configured
print("Show the screw graphics: " .. tostring(user_prop_get(screws_prop)) )
print("Show the bezel graphics: " .. tostring(user_prop_get(bezel_prop)) )
```
