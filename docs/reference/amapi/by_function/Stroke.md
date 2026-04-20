---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: stroke
Namespace: unprefixed
Source URL: https://wiki.siminnovations.com/index.php?title=Stroke
Revision: 3316
---

# Stroke

## Signature

```
_stroke(color_name, line_width) _stroke(color_name, opacity, line_width) _stroke(color_hex, line_width) _stroke(r, g, b, line_width) _stroke(r, g, b, a, line_width)
```

## Description

_stroke is used to apply all queued drawings into a stroke (line).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `color` | Multiple | The color of the line. Can be RGBA hex string ("#FF0000FF"), the name of the color ("red") or separate number (1, 0, 0, 1). |
| 2 | `line_width` | Number | The width of the line in pixels. |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  -- Create a triangle
  _triangle(100, 10, 10, 190, 190, 190)

  -- Only use one, this illustrated the different ways of calling _stroke
  _stroke("#FF0000FF", 4)
  _stroke("red", 4)
  _stroke(1, 0, 0, 1, 4)
end)
```
