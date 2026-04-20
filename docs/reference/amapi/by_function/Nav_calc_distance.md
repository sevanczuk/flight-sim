---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: nav_calc_distance
Namespace: Nav
Source URL: https://wiki.siminnovations.com/index.php?title=Nav_calc_distance
Revision: 4650
---

# Nav calc distance

## Signature

```
distance = nav_calc_distance(distance_type, lat1, lon1, lat2, lon2)
```

## Description

nav_calc_distance can be used to get the distance between two coordinates.

## Return value

distance

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `distance_type` | String | This can be "GREAT_CIRCLE" or "RHUMB_LINE". |
| 2 | `lat1` | Number | The latitude of coordinate 1. Use positive for north and negative for south. |
| 3 | `lon1` | Number | The longitude of coordinate 1. Use positive for east and negative for west. |
| 4 | `lat2` | Number | The longitude of coordinate 2. Use positive for east and negative for west. |
| 5 | `lon2` | Number | The longitude of coordinate 2. Use positive for east and negative for west. |

## Examples

### Example

```lua
-- Returns 713850.11697812 meters
distance = nav_calc_distance("GREAT_CIRCLE", 49.1763924, 18.9330891, 47.0249429, 9.868194)

-- Returns 844159.80527001 meters
distance = nav_calc_distance("RHUMB_LINE", 48.8584479, 2.2935777, 43.7232998, 10.3940864)
```
