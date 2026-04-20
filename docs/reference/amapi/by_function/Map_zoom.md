---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: map_zoom
Namespace: Map
Source URL: https://wiki.siminnovations.com/index.php?title=Map_zoom
Revision: 60
---

# Map zoom

## Signature

```
map_zoom(map_id,zoom)
```

## Description

map_zoom is used to set to change the zoom level of a map.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `map_id` | Number | Map identifier. This number can be obtained by calling map_add. |
| 2 | `zoom` | Number | The openstreemap zoom level. This value can normally range from 1 (whole earth) to 16 (closest to earth). This value is dependent on the base layer source type defined above. |

## Examples

### Example

```lua
-- Place a map to your instrument using the openstreetmap cycle map and zoom level of 10
id = map_add(0,0,500,500,"OSM_CYCLE", 10)

-- Nah, lets use zoom level 12, much nicer..
map_zoom(id, 12)
```
