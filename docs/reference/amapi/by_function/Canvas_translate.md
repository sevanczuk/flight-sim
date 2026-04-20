---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: canvas_translate
Namespace: Canvas
Source URL: https://wiki.siminnovations.com/index.php?title=Canvas_translate
Revision: 3200
---

# Canvas translate

## Signature

```
_translate(x, y)
```

## Description

_translate is used to move all shapes drawn after this call in x and/or y position.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `x` | Number | X position |
| 2 | `y` | Number | Y position |

## Examples

### Example

```lua
canvas_add(0, 0, 200, 200, function()
  -- Draw a red rectangle with rotation
  _rect(0, 0, 100, 100)
  _fill("red")

  -- From this point everything is drawn with a x offset of 100
  _translate(100, 0)

  -- Draw a second blue rectangle
  -- Because of the tranlate above, this will be drawn at the 100, 0 position
  _rect(0, 0, 100, 100)
  _fill("blue")
end)
```
