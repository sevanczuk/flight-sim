---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: layer_add
Namespace: Layer
Source URL: https://wiki.siminnovations.com/index.php?title=Layer_add
Revision: 5824
---

# Layer add

## Signature

```
layer_id = layer_add(z_order, callback) layer_id = layer_add(z_order, callback, input_event_callback) (from AM/AP 5.0) layer_id = layer_add(z_order, x, y, w, h, callback) (from AM/AP 5.0) layer_id = layer_add(z_order, x, y, w, h, callback, input_event_callback) (from AM/AP 5.0)
```

## Description

layer_add is used to create a new layer. By default, the layer will have the same dimensions as the instrument or panel it is created in.

## Return value

layer_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `z_order` | Number | The Z order. Lowest value is drawn at the back, highest is drawn on the top. The panel/instrument root lua is always drawn at order 0. |
| 2 | `x` | Number | (Optional) X position in pixels of the layer |
| 3 | `y` | Number | (Optional) Y position in pixels of the layer |
| 4 | `width` | Number | (Optional) Width in pixels of the layer |
| 5 | `height` | Number | (Optional) Height in pixels of the layer |
| 6 | `callback` | Function | Callback function. Add GUI nodes (such as img_add, txt_add. etc. etc.) you create within this function will be added to this layer. |
| 7 | `input_event_callback` | Function | (Optional) Callback where input events (mouse & touch) are sent. Callback arguments are id, x, y and finger_id. |

## Examples

### Example

```lua
-- Create a layer with an image and text object
layer_id = layer_add(-4, function()
  img_add_fullscreen("myimage.png")
  txt_add("Hello world", "size: 20; color: black;", 0, 100, 60, 40) 
end)

-- You can apply node function on the layer, such as move, visible, opacity etc.
opacity(layer_id, 0.5)
```

### Example (Input events)

```lua
function input_event_cb(id, x, y)
  if id == "MOUSE_MOTION" then
    print("Mouse motion x=" .. x .. ", y=" .. y)
  end
end

-- Create a layer
layer_id = layer_add(4, 0, 0, 200, 200, function()
  -- We draw nothing inside the layer
end, input_event_cb)
```
