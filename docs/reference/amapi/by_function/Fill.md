---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fill
Namespace: unprefixed
Source URL: https://wiki.siminnovations.com/index.php?title=Fill
Revision: 4648
---

# Fill

## Signature

```
_fill(color) _fill(color, opacity) _fill(r, g, b) (deprecated from AM/AP 4.0) _fill(r, g, b, opacity) (deprecated from AM/AP 4.0)
```

## Description

_fill is used to apply all queued drawings into a fill (inside is a solid color).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `color` | Multiple | The color of the line. Can be RGBA hex string ("#FF0000FF"), the name of the color ("red") or separate number (1, 0, 0, 1). |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  -- Create a triangle
  _triangle(100, 0, 0, 200, 200, 200)

  -- From name
  _fill("red")

  -- From RGB string
  _fill("#FF0000FF")

  -- From RGB values (from AM/AP 4.0)
  _fill( { 1, 0, 0 } )

  -- From RGB values (before AM/AP 4.0)
  _fill(1, 0, 0)
end)
```
