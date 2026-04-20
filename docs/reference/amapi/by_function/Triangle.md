---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: triangle
Namespace: unprefixed
Source URL: https://wiki.siminnovations.com/index.php?title=Triangle
Revision: 2461
---

# Triangle

## Signature

```
_triangle(x1, y1, x2, y2, x3, y3)
```

## Description

_triangle is used to draw a triangle.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `x1` | Number | Left point of the first corner of the triangle |
| 2 | `y1` | Number | Top point of the first corner of the triangle |
| 3 | `x2` | Number | Left point of the second corner of the triangle |
| 4 | `y2` | Number | Top point of the second corner of the triangle |
| 5 | `x3` | Number | Left point of the third corner of the triangle |
| 6 | `y3` | Number | Top point of the third corner of the triangle |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  -- Create a triangle
  _triangle(100, 0, 0, 200, 200, 200)

  _fill("red")
end)
```
