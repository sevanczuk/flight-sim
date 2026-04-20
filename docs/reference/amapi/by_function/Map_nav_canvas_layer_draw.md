---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: map_nav_canvas_layer_draw
Namespace: Map
Source URL: https://wiki.siminnovations.com/index.php?title=Map_nav_canvas_layer_draw
Revision: 4211
---

# Map nav canvas layer draw

## Signature

```
map_nav_canvas_layer_draw(layer_id)
```

## Description

map_nav_canvas_layer_draw is used to redraw all the canvas for each nav object. The default draw callback provided with the map_add will be called.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `layer_id` | ID | Map nav canvas layer ID. This ID can be obtained by calling function map_add_nav_canvas_layer. |

## Examples

### Examples

```lua
-- Place a map to your instrument using the openstreetmap cycle map and zoom level of 10
map_id = map_add(0, 0, 512, 512, "OSM_CYCLE", 7)

local incr_value = 0

-- Add the canvas draw callback
function canvas_draw_callback(vhf_navaid_data)
  _circle(25, 25, 25)
  _fill("magenta")
  _txt(vhf_navaid_data["ICAO"] .. incr_value, "font:roboto_bold.ttf; size:16; color: black; halign:center; valign:center", 25, 25)
end

-- Add a NAV layer of type "VHF_NAVAID". For every VHF_NAVAID station the canvas draw callback will be called.
layer_id = map_add_nav_canvas_layer(map_id, "AIRPORT", -25, -25, 50, 50, canvas_draw_callback)

map_goto(map_id, 52.422607, 5.485053)

-- Redraw all nav objects every 100 ms
timer_start(0, 100, function()
    incr_value = incr_value + 1
    map_nav_canvas_layer_draw(layer_id)
end)
```
