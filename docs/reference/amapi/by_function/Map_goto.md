---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: map_goto
Namespace: Map
Source URL: https://wiki.siminnovations.com/index.php?title=Map_goto
Revision: 686
---

# Map goto

## Signature

```
map_goto(map_id,lat,lon)
```

## Description

map_goto is used to set the map location to a certain place on earth. This place is defined by using longitude and latitude. Use [this](http://itouchmap.com/latlong.html) website to determine the longitude and latitude of any place on earth.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `map_id` | Number | Map identifier. This number can be obtained by calling map_add. |
| 2 | `lat` | Number | The latitude to move the map to. |
| 3 | `lon` | Number | The longitude to move the map to. |

## Examples

### Example

```lua
-- Place a map to your instrument using the openstreetmap cycle map and zoom level of 10
id = map_add(0,0,500,500,"OSM_CYCLE", 10)

-- Goto the beautiful city of Nijkerk, the Netherlands
map_goto(id, 52.222607, 5.485053)
```

## External references

- [this](http://itouchmap.com/latlong.html)
