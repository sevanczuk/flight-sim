---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: layer_mouse_cursor
Namespace: Layer
Source URL: https://wiki.siminnovations.com/index.php?title=Layer_mouse_cursor
Revision: 5840
---

# Layer mouse cursor

## Signature

```
layer_mouse_cursor(layer_id, cursor)
```

## Description

layer_mouse_cursor is used to set the mouse cursor when hovering over this layer.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `layer_id` | ID | Layer identifier. This can be obtained by calling function layer_add. |
| 2 | `cursor` | String | The cursor type, see list below. It is also possible to add you own custom cursor proving your own from resources folder, this image must be 32x32 32-bit PNG file. |

## Examples

### Example (Fixed cursor)

```lua
layer_id = layer_add(-1, 0, 0, 200, 200, function()
  -- Add nodes here
end)

-- Predefined cursor
layer_mouse_cursor(layer_id, "HAND")

-- Custom cursor (from resources folder, must be 32x32 PNG file)
layer_mouse_cursor(layer_id, "my_custom_cursor.png")
```

### Example (Dynamic cursor based on mouse position)

```lua
my_canvas =  canvas_add(0, 0, 500, 500, function()
   _rect(0,0,500,500)
   _fill("grey")
end)
    
function input_event_cb(id, x, y)
    if id == "MOUSE_MOTION" then
      local within_x = x >= 200 and x <= 400
      local within_y = y >= 200 and y <= 400
      
      if within_x and within_y then
          layer_mouse_cursor(layer_id, "HAND")
      elseif within_y and x > 400 then
          layer_mouse_cursor(layer_id, "RIGHT")
      elseif within_y and x < 200 then
          layer_mouse_cursor(layer_id, "LEFT")
      elseif within_x and y < 200 then
          layer_mouse_cursor(layer_id, "TOP")
      elseif within_x and y > 400 then
          layer_mouse_cursor(layer_id, "BOTTOM")
      else
          layer_mouse_cursor(layer_id, "POINTER")
      end
    end
end

layer_id = layer_add(1, 0, 0, 400, 400, function()
    my_canvas =  canvas_add(200, 200, 200, 200, function()
       _rect(0,0,200,200)
       _fill("red")
    end)
end, input_event_cb)
```
