---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: map_add_nav_img_layer
Namespace: Map
Source URL: https://wiki.siminnovations.com/index.php?title=Map_add_nav_img_layer
Revision: 4187
---

# Map add nav img layer

## Signature

```
layer_id = map_add_nav_img_layer(map_id, nav_type, filename, x, y, width, height)
```

## Description

map_add_nav_img_layer is used to add a NAV image layer to an existing map. A certain number of NAV types are available (see below). For every NAV point, you are able to add your own image. The NAV points themselves are packaged within Air Manager.

## Return value

layer_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `map_id` | Number | The map_id to add the layer to. A map_id can be fetched by using function map_add. |
| 2 | `nav_type` | String | The NAV type to show in this layer, click here to see the NAV types page for all available types. |
| 3 | `filename` | Number | The filename of the image to show at every NAV point. |
| 4 | `x` | Number | The x pixel offset of where the image should be shown. This is relative to the NAV point itself. |
| 5 | `y` | Number | The y pixel offset of where the image should be shown. This is relative to the NAV point itself. |
| 6 | `width` | Number | The desired width of the image. |
| 7 | `height` | Number | The desired height of the image. |

## Examples

### Example

```lua
-- Place a map to your instrument using the openstreetmap cycle map and zoom level of 10
id = map_add(0,0,500,500,"OSM_CYCLE", 10)

-- Add a NAV layer of type "NDB". For every NDB point, image "NDB-DME.png" will be shown.
layer_id = map_add_nav_img_layer(id, "NDB", "NDB-DME.png", -25, -25, 50, 50)

map_goto(id, 5.485053, 52.422607)
```
