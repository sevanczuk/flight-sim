---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fill_gradient_linear
Namespace: Fill
Source URL: https://wiki.siminnovations.com/index.php?title=Fill_gradient_linear
Revision: 3854
---

# Fill gradient linear

## Signature

```
_fill_gradient_linear(x1, y1, x2, y2, color_1, color_2)
```

## Description

_fill_gradient_linear is used to apply all queued drawings into a linear gradient fill.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `x1` | Number | X position of point 1 in pixels. |
| 2 | `y1` | Number | Y position of point 1 in pixels. |
| 3 | `x2` | Number | X position of point 2 in pixels. |
| 4 | `y2` | Number | Y position of point 2 in pixels. |
| 5 | `color_1` | Color | The color at point 1. Can be RGBA hex string ("#FF0000FF"), the name of the color ("red") or separate number table {1, 0, 0, 1 }. |
| 6 | `color_2` | Color | The color at point 2. Can be RGBA hex string ("#FF0000FF"), the name of the color ("red") or separate number table {1, 0, 0, 1 }. |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  -- Create a shape
  _rect(0, 0, 200, 200)

  -- Fill gradient
  _fill_gradient_linear(0, 0, 200, 200, "red", "yellow")
end)
```
