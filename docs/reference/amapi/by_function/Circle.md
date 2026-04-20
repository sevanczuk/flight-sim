---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: circle
Namespace: unprefixed
Source URL: https://wiki.siminnovations.com/index.php?title=Circle
Revision: 2458
---

# Circle

## Signature

```
_circle(cx, cy, radius)
```

## Description

_circle is used to draw a circle.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `cx` | Number | Left point of the center of the circle. |
| 2 | `cy` | Number | Top point of the center of the circle. |
| 3 | `radius` | Number | Radius of the circle in pixels. |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  -- Create a circle
  _circle(100, 100, 100)

  _fill("red")
end)
```
