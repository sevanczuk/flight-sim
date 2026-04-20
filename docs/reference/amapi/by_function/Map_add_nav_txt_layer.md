---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: map_add_nav_txt_layer
Namespace: Map
Source URL: https://wiki.siminnovations.com/index.php?title=Map_add_nav_txt_layer
Revision: 4189
---

# Map add nav txt layer

## Signature

```
layer_id = map_add_nav_txt_layer(map_id, nav_type, nav_param, style, x, y, width, height)
```

## Description

map_add_nav_txt_layer is used to add a NAV layer to an existing map. A certain number of NAV types are available (see below). For every NAV point, you are able to add your own text label. The NAV points themselves are packaged within Air Manager.

## Return value

layer_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `map_id` | Number | The map_id to add the layer to. A map_id can be fetched by using function map_add. |
| 2 | `nav_type` | String | The NAV type to show in this layer, click here to see the NAV types page for all available types. |
| 3 | `nav_param` | String | The NAV param to use. This can be NAME, LONGITUDE or LATITUDE. |
| 4 | `style` | String | The style to use for the text. |
| 5 | `x` | Number | The x pixel offset of where the text should be shown. This is relative to the NAV point itself. |
| 6 | `y` | Number | The y pixel offset of where the text should be shown. This is relative to the NAV point itself. |
| 7 | `width` | Number | The desired width of the textbox. |
| 8 | `height` | Number | The desired height of the textbox. |

## Examples

### Example

```lua
-- Place a map to your instrument using the openstreetmap cycle map and zoom level of 10
id = map_add(0,0,500,500,"OSM_CYCLE", 10)

-- Add a NAV layer of type "NDB". For every NDB point a red bold text with the name of the NDB point will be shown.
layer_id = map_add_nav_txt_layer(id, "NDB", "NAME", "color: red; halign:center", -35, 15, 200, 40)

map_goto(id, 5.485053, 52.422607)
```
