---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fill_gradient_box
Namespace: Fill
Source URL: https://wiki.siminnovations.com/index.php?title=Fill_gradient_box
Revision: 3855
---

# Fill gradient box

## Signature

```
_fill_gradient_box(x, y, width, height, corner, feather, color_inner, color_outer)
```

## Description

_fill_gradient_box is used to apply all queued drawings into a boxed gradient fill.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `x` | Number | X position of the box in pixels |
| 2 | `y` | Number | Y position of the box in pixels. |
| 3 | `width` | Number | Width of the box in pixels. |
| 4 | `height` | Number | Height of the box in pixels |
| 5 | `corner` | Number | Corner radius in pixels. |
| 6 | `feather` | Number | Feather, this determines the blurring effect. |
| 7 | `color_inner` | Color | The color at point 1. Can be RGBA hex string ("#FF0000FF"), the name of the color ("red") or separate number table {1, 0, 0, 1 }. |
| 8 | `color_outer` | Color | The color at point 2. Can be RGBA hex string ("#FF0000FF"), the name of the color ("red") or separate number table {1, 0, 0, 1 }. |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  -- Create a shape
  _rect(0, 0, 200, 200)

  -- Fill gradient
  _fill_gradient_box(75, 75, 50, 50, 10, 10, "red", "yellow")
end)
```
