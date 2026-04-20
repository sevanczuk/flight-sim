---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: arc_to
Namespace: Arc
Source URL: https://wiki.siminnovations.com/index.php?title=Arc_to
Revision: 2452
---

# Arc to

## Signature

```
_arc_to(cpx, cpy, x, y, radius)
```

## Description

_arc_to is used to draw a arc line from the pen location to the new location provided in the arguments. The control point and radius determine the arc of the line.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `cpx` | Number | This is the left pixel of the control point. |
| 2 | `cpy` | Number | This is the top pixel of the control point. |
| 3 | `x` | Number | This is the left pixel of the canvas where the end of your line should be. |
| 4 | `y` | Number | This is the top pixel of the canvas where the end of your line should be. |
| 5 | `radius` | Number | Radius of the arc in pixels |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  -- Create an arc line
  _move_to(20, 20)
  _line_to(100, 20)
  _arc_to(150, 20, 150, 70, 50)
  _line_to(150, 120)

  _stroke("red", 4)
end)
```
