---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: canvas_scale
Namespace: Canvas
Source URL: https://wiki.siminnovations.com/index.php?title=Canvas_scale
Revision: 3201
---

# Canvas scale

## Signature

```
_scale(x, y)
```

## Description

_scale is used to scale all shapes drawn after this call in x and/or y axle.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `x` | Number | X axle scaling |
| 2 | `y` | Number | Y axle scaling |

## Examples

### Example

```lua
canvas_add(0, 0, 200, 200, function()
  -- Draw a red rectangle with rotation
  _rect(0, 0, 100, 100)
  _fill("red")

  -- From this point everything is drawn twice as small, at 50%.
  _scale(0.5, 0.5)

  -- Draw a second blue rectangle
  -- Because of the scale above, this will be drawn with a width of 50, and a height of 50
  _rect(0, 0, 100, 100)
  _fill("blue")
end)
```
