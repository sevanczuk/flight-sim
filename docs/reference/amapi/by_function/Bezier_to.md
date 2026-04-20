---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: bezier_to
Namespace: Bezier
Source URL: https://wiki.siminnovations.com/index.php?title=Bezier_to
Revision: 2449
---

# Bezier to

## Signature

```
_bezier_to(cp1x, cp1y, cp2x, cp2y, x, y)
```

## Description

_bezier_to is used to draw a bezier line from the pen location to the new location provided in the arguments. Two control points determine the arc of the line.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `cp1x` | Number | This is the left pixel of the first control point. |
| 2 | `cp1y` | Number | This is the top pixel of the first control point. |
| 3 | `cp2x` | Number | This is the left pixel of the second control point. |
| 4 | `cp2y` | Number | This is the top pixel of the second control point. |
| 5 | `x` | Number | This is the left pixel of the canvas where the end of your line should be. |
| 6 | `y` | Number | This is the top pixel of the canvas where the end of your line should be. |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  -- Create a brezier line
  _move_to(20, 20)
  _bezier_to(20, 100, 200, 100, 140, 20)

  _stroke("red", 4)
end)
```
