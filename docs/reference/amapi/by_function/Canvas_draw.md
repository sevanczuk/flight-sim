---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: canvas_draw
Namespace: Canvas
Source URL: https://wiki.siminnovations.com/index.php?title=Canvas_draw
Revision: 3919
---

# Canvas draw

## Signature

```
canvas_draw(canvas_id, draw_callback)
```

## Description

canvas_draw is used to force the canvas to redraw itself.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `canvas_id` | String | The is the reference to the canvas. You can get this reference from the canvas_add function. |
| 2 | `draw_callback` | Function | Optional. This function will be called on a redraw of the canvas. It should contain the individual draw functions like _line_to, _rect, etc. The initial width and height of the canvas are provided to the callback function (from AM/AP 4.0). |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200)

-- Do a redraw of the canvas
-- It is also possible to call this function from any callback.
-- For example, when a button is pressed or data from the flight simulator has been received
canvas_draw(canvas_id, function()
  -- Queue a line from 100,100 to 200,200
  _move_to(100, 100)
  _line_to(200, 200)
  
  -- Stroke the line (line width 6)
  _stroke("red", 6)
end)
```
