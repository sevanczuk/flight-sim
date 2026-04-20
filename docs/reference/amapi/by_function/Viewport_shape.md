---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: viewport_shape
Namespace: Viewport
Source URL: https://wiki.siminnovations.com/index.php?title=Viewport_shape
Revision: 5893
---

# Viewport shape

## Signature

```
viewport_shape(node_id, draw_fuction)
```

## Description

viewport_shape makes a node visible within a specified shape. You can define the shape using the canvas draw functions.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `node_id` | ID | The node id of which the viewport should be applied. |
| 2 | `draw_function` | Function | Define your shape inside this draw function. See list below on which draw functions are supported by viewport_shape |

## Examples

### Example

```lua
-- Create a blue rectangle using canvas. (Note that in this case we use canvas, viewport_shape can be used on all node types like text, images, dial etc.)
canvas_id = canvas_add(0, 0, 200, 200, function()
  _rect(0, 0, 100, 100)
  _fill("blue")
end)

-- Define a shape in which we look at this blue box, in this case through a circle shape
viewport_shape(canvas_id, function()
    _circle(80, 80, 50)
end)
```
