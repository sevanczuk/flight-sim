---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: slider_set_position
Namespace: Slider
Source URL: https://wiki.siminnovations.com/index.php?title=Slider_set_position
Revision: 3401
---

# Slider set position

## Signature

```
slider_set_position(slider_id,position)
```

## Description

slider_set_position is used to set a slider to a certain position. Position always ranges from 0.0 (begin) to 1.0 (end).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `slider_id` | String | Reference to the slider |
| 2 | `position` | Number | The position you want to slider to get. |

## Examples

### Example

```lua
-- Called when user drags slider to certain position
function callback(position)

  -- Set the slider position to the new proposed position
  slider_set_position(slider_id, position)
end

-- Create a new slider
slider_id = slider_add_hor("slider.png", 0, 0, 200, 50, "thumb.png", 20, 40, callback)

-- Set the slider to 50% of it's total range
slider_set_position(slider_id, 0.5)
```
