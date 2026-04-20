---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: canvas_add
Namespace: Canvas
Source URL: https://wiki.siminnovations.com/index.php?title=Canvas_add
Revision: 3920
---

# Canvas add

## Signature

```
canvas_id = canvas_add(x, y, width, height, draw_callback)
```

## Description

canvas_add is used to create a canvas that allows to draw dynamic shapes like lines, rectangles, circles etc. in your instrument.

## Return value

canvas_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `x` | Number | This is the most left point of the canvas. |
| 2 | `y` | Number | This is the most top point of the canvas. |
| 3 | `width` | Number | The canvas width in pixels. |
| 4 | `height` | Number | The canvas height in pixels. |
| 5 | `draw_callback` | Function | (Optional) This function will be called on a redraw of the canvas. It should contain the individual draw functions like _line_to, _arc, etc. The initial width and height of the canvas are provided to the callback function (from AM/AP 4.0). |

## Examples

### Example (Static circle)

```lua
circle_id = canvas_add(0, 0, 200, 200, function()
  -- Create full circle with center 100,100 and radius 100 px
  _circle(100, 100, 100)
  _fill("red")
end)
```

### Example (Static rectangle)

```lua
rectangle_id = canvas_add(0, 0, 200, 200, function()
  -- Create full rectangle
  -- x = 50
  -- y = 50
  -- width = 150
  -- height = 150
   _rect(50,50,100,100)
   _fill("red")
end)
```

### Example (Dynamic draw based on flight simulator data)

```lua
canvas_id = canvas_add(0, 0, 200, 200)

function callback(altitude, speed)
  -- Data from flight simulator has changed

  -- Let's redraw the canvas based on the new data
  canvas_draw(canvas_id, function()
    -- Set initial position
    _move_to(200, 100)
    
    -- Draw a line
    if altitude > 100 then
      _line_to(200, 200)
    else
      _line_to(190, 190)
    end
    
    _stroke("red", 2)
  end)
end

xpl_dataref_subscribe("ALTITUDE_DATAREF", "INT",
                      "SPEED_DATAREF", "INT", callback)
```
