---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: ellipse
Namespace: unprefixed
Source URL: https://wiki.siminnovations.com/index.php?title=Ellipse
Revision: 2459
---

# Ellipse

## Signature

```
_ellipse(cx, cy, radius_x, radius_y)
```

## Description

_ellipse is used to draw an ellipse.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `cx` | Number | Left point of the center of the ellipse. |
| 2 | `cy` | Number | Top point of the center of the ellipse. |
| 3 | `radius_x` | Number | Horizontal radius of the ellipse in pixels. |
| 4 | `radius_y` | Number | Vertical radius of the ellipse in pixels. |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  -- Create a ellipse
  _ellipse(100, 100, 100, 50)

  _fill("red")
end)
```
