---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: rect
Namespace: unprefixed
Source URL: https://wiki.siminnovations.com/index.php?title=Rect
Revision: 3162
---

# Rect

## Signature

```
_rect(x, y, width, height) _rect(x, y, width, height, all_corners) _rect(x, y, width, height, top_left_corner, top_right_corner, bottom_left_corner, bottom_right_corner) (from AM/AP 3.6)
```

## Description

_rect is used to draw a rectangle.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `x` | Number | Left point of the rectangle. |
| 2 | `y` | Number | Top point of the rectangle. |
| 3 | `width` | Number | Width of the rectangle. |
| 4 | `heigth` | Number | Height of the rectangle. |
| 5 | `corner` | Number | (Optional) Radius of arcs on every corner of the rectangle, use if you want rounded corners. |
| 5 | `top_left_corner` | Number | (Optional) Radius of arcs on top left corner of the rectangle, use if you want rounded corners. |
| 6 | `top_right_corner` | Number | (Optional) Radius of arcs on top right corner of the rectangle, use if you want rounded corners. |
| 7 | `bottom_left_corner` | Number | (Optional) Radius of arcs on bottom left corner of the rectangle, use if you want rounded corners. |
| 8 | `bottom_right_corner` | Number | (Optional) Radius of arcs on bottom right corner of the rectangle, use if you want rounded corners. |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  -- Create a rectangle
  _rect(50, 50, 100, 100)

  _fill("red")
end)
```
