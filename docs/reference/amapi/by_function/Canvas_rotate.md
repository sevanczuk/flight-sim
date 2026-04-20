---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: canvas_rotate
Namespace: Canvas
Source URL: https://wiki.siminnovations.com/index.php?title=Canvas_rotate
Revision: 3009
---

# Canvas rotate

## Signature

```
_rotate(angle) _rotate(angle, anchor_x, anchor_y)
```

## Description

_rotate is used to rotate all shapes drawn after this call to have rotation.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `angle` | Number | Angle of rotation in degrees. |
| 2 | `anchor_x` | Number | (Optional) Left point of the anchor point to rotate around |
| 3 | `anchor_y` | Number | (Optional) Top point of the anchor point to rotate around |

## Examples

### Example

```lua
canvas_add(0, 0, 200, 200, function()
  -- Set rotation of 10 degrees      
  _rotate(10)

  -- Everything after this point will have the rotation applied to it

  -- Draw a red rectangle with rotation
  _rect(50, 50, 100, 100)
  _fill("red")

  -- Revert the rotation set before.
  -- From this point everything is drawn without any rotation	
  _rotate(-10)

  -- Draw a second smaller blue rectangle	
  _rect(75, 75, 50, 50)
  _fill("blue")
end)
```
