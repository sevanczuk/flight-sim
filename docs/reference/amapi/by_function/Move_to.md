---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: move_to
Namespace: Move
Source URL: https://wiki.siminnovations.com/index.php?title=Move_to
Revision: 2443
---

# Move to

## Signature

```
_move_to(x, y)
```

## Description

_move_to is used to move the drawing pen to a new location.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `x` | Number | This is the left pixel of the canvas where your pen go. |
| 2 | `y` | Number | This is the top pixel of the canvas where your pen go. |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200)

canvas_draw(canvas_id, function()
  -- Queue a line from 100,100 to 200,200
  _move_to(100, 100)
  _line_to(200, 200)
  
  -- Stroke the line (line width 6)
  _stroke("red", 6)
end)
```
