---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: arc
Namespace: unprefixed
Source URL: https://wiki.siminnovations.com/index.php?title=Arc
Revision: 2456
---

# Arc

## Signature

```
_arc(cx, cy, start_angle, end_angle, radius, direction)
```

## Description

_arc is used to draw a arc line. The radius determines the arc of the line.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `cx` | Number | This is the left pixel of the control point. |
| 2 | `cy` | Number | This is the top pixel of the control point. |
| 3 | `start_angle` | Number | The starting angle, in degrees (0 is at the 3 o'clock position of the arc's circle) |
| 4 | `end_angle` | Number | The ending angle, in degrees |
| 5 | `radius` | Number | Radius of the arc in pixels |
| 6 | `direction` | Boolean | (Optional) true = clockwise, false = counterclockwise |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  -- Create a arc line
  _arc(100, 100, 90, 180, 50)

  _stroke("red", 4)
end)
```
