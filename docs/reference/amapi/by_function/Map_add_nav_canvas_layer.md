---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: map_add_nav_canvas_layer
Namespace: Map
Source URL: https://wiki.siminnovations.com/index.php?title=Map_add_nav_canvas_layer
Revision: 5108
---

# Map add nav canvas layer

## Signature

```
layer_id = map_add_nav_canvas_layer(map_id, nav_type, x, y, width, height, draw_callback)
```

## Description

map_add_nav_canvas_layer is used to add a NAV canvas layer to an existing map. A certain number of NAV types are available (see below). For every NAV type, you are able to add a canvas.

## Return value

layer_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `map_id` | Number | The map_id to add the layer to. A map_id can be fetched by using function map_add. |
| 2 | `nav_type` | String | The NAV type to query, click here to see the NAV types page for all available types. |
| 3 | `x` | Number | The x pixel offset of where the canvas should be shown. |
| 4 | `y` | Number | The y pixel offset of where the canvas should be shown. |
| 5 | `width` | Number | The desired width of the canvas. |
| 6 | `height` | Number | The desired height of the canvas. |
| 7 | `draw_callback` | String | This function will be called on a redraw of the canvas. |

## Examples

### Example

```lua
-- Place a map to your instrument using the openstreetmap cycle map and zoom level of 10
map_id = map_add(0, 0, 512, 512, "OSM_CYCLE", 10)

-- Add the canvas draw callback
function canvas_draw_callback(airport_data)
  _circle(25, 25, 25)
  _fill("magenta")
  _txt(airport_data["ICAO"], "font:roboto_bold.ttf; size:16; color: black; halign:center; valign:center", 25, 25)
end

-- Add a NAV layer of type "AIRPORT". For every AIRPORTstation the canvas draw callback will be called.
layer_id = map_add_nav_canvas_layer(map_id, "AIRPORT", -25, -25, 50, 50, canvas_draw_callback)

map_goto(map_id, 52.422607, 5.485053)
```
