---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: line_to
Namespace: Line
Source URL: https://wiki.siminnovations.com/index.php?title=Line_to
Revision: 2446
---

# Line to

## Signature

```
_line_to(x, y)
```

## Description

_line_to is used to draw a line from the pen location to the new location provided in the arguments.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `x` | Number | This is the left pixel of the canvas where the end of your line should be. |
| 2 | `y` | Number | This is the top pixel of the canvas where the end of your line should be. |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200)

canvas_draw(canvas_id, function()
  -- Queue a line from 100,100 through multiple points
  _move_to(100, 100)
  _line_to(150, 150)
  _line_to(100, 180)
  _line_to(50, 100)
  
  -- Stroke the line (line width 6)
  _stroke("red", 6)
end)
```
