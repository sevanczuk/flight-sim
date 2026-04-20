---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: quad_to
Namespace: Quad
Source URL: https://wiki.siminnovations.com/index.php?title=Quad_to
Revision: 2451
---

# Quad to

## Signature

```
_quad_to(cp1, cp1y, cp2x, cp2y, x, y)
```

## Description

_quad_to is used to draw a quad line from the pen location to the new location provided in the arguments. The control point determines the arc of the line.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `cpx` | Number | This is the left pixel of the control point. |
| 2 | `cpy` | Number | This is the top pixel of the control point. |
| 3 | `x` | Number | This is the left pixel of the canvas where the end of your line should be. |
| 4 | `y` | Number | This is the top pixel of the canvas where the end of your line should be. |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  -- Create a quad line
  _move_to(20, 20)
  _quad_to(20, 100, 180, 20)

  _stroke("red", 4)
end)
```
