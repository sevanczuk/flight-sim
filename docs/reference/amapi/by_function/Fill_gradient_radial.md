---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fill_gradient_radial
Namespace: Fill
Source URL: https://wiki.siminnovations.com/index.php?title=Fill_gradient_radial
Revision: 3857
---

# Fill gradient radial

## Signature

```
_fill_gradient_radial(x, y, radius_inner, radius_outer, color_inner, color_outer)
```

## Description

_fill_gradient_radial is used to apply all queued drawings into a radial gradient fill.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `x` | Number | X position of the center of the circle |
| 2 | `y` | Number | Y position of the center of the circle |
| 3 | `radius_inner` | Number | Radius of inner color |
| 4 | `radius_outer` | Number | Radius of outer color |
| 5 | `color_inner` | Color | The color at point 1. Can be RGBA hex string ("#FF0000FF"), the name of the color ("red") or separate number table {1, 0, 0, 1 }. |
| 6 | `color_outer` | Color | The color at point 2. Can be RGBA hex string ("#FF0000FF"), the name of the color ("red") or separate number table {1, 0, 0, 1 }. |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  -- Create a shape
  _rect(0, 0, 200, 200)

  -- Fill gradient
  _fill_gradient_radial(100, 100, 35, 50, "red", "yellow")
end)
```
