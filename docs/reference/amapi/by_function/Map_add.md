---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: map_add
Namespace: Map
Source URL: https://wiki.siminnovations.com/index.php?title=Map_add
Revision: 5101
---

# Map add

## Signature

```
map_id = map_add(x,y,width,height,source,zoom)
```

## Description

map_add is used to add a map to your instrument. You can add any openstreetmap as a base layer for your map. Note that an internet connection is required as the base layer is fetched from the openstreetmap servers directly.

## Return value

map_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `x` | Number | This is the most left point of the canvas where your map should be shown. |
| 2 | `y` | Number | This is the most top point of the canvas where your map should be shown. |
| 3 | `width` | Number | The map width in pixels. |
| 4 | `height` | Number | The map height in pixels. |
| 5 | `base_layer` | String | The openstreetmap base layer to use. See available base layers below. Use 'nil' if you don't want any base layer at all. |
| 6 | `zoom` | Number | The openstreemap zoom level. This value can normally range from 1 (whole earth) to 16 (closest to earth). This value is dependent on the base layer source type defined above. |

## Examples

### Example

```lua
-- Place a map to your instrument using the openstreetmap cycle map and zoom level of 10
id = map_add(0,0,500,500,"OSM_CYCLE", 10)

-- Goto the beautiful city of Nijkerk, the Netherlands
map_goto(id, 52.222607, 5.485053)
```
