---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: nav_calc_bearing
Namespace: Nav
Source URL: https://wiki.siminnovations.com/index.php?title=Nav_calc_bearing
Revision: 4651
---

# Nav calc bearing

## Signature

```
bearing = nav_calc_bearing(bearing_type, lat1, lon1, lat2, lon2)
```

## Description

nav_calc_bearing is used to calculate the bearing from the first coordinate to the second coordinate.

## Return value

bearing

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `bearing_type` | String | The type of bearing. This can be "GREAT_CIRCLE_START" or "RHUMB_LINE". |
| 2 | `lat1` | Number | The latitude of coordinate 1. Use positive for north and negative for south. |
| 3 | `lon1` | Number | The longitude of coordinate 1. Use positive for east and negative for west. |
| 4 | `lat2` | Number | The longitude of coordinate 2. Use positive for east and negative for west. |
| 5 | `lon2` | Number | The longitude of coordinate 2. Use positive for east and negative for west. |

## Examples

### Example

```lua
-- Returns 134.97072337671 degrees
bearing = nav_calc_bearing("GREAT_CIRCLE_START", 59.6727385, 9.5388091, 56.1731387, 15.5653304)

-- Returns 349.98012992945 degrees
bearing = nav_calc_bearing("RHUMB_LINE", 42.2445844, 1.0406613, 54.9958871, -2.3930225)
```
