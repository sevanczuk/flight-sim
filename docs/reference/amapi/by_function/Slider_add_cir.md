---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: slider_add_cir
Namespace: Slider
Source URL: https://wiki.siminnovations.com/index.php?title=Slider_add_cir
Revision: 3728
---

# Slider add cir

## Signature

```
slider_id = slider_add_cir(image, x, y, width, height, radius, start_angle, end_angle, thumb_image, thumb_width, thumb_height, position_callback) slider_id = slider_add_cir(image, x, y, width, height, radius, start_angle, end_angle, thumb_image, thumb_width, thumb_height, position_callback, pressed_callback) slider_id = slider_add_cir(image, x, y, width, height, radius, start_angle, end_angle, thumb_image, thumb_width, thumb_height, position_callback, pressed_callback, released_callback)
```

## Description

slider_add_cir is used to add a circulair slider on the specified location. The position output from 0 to 1 is always clockwise.

## Return value

slider_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `image` | String | The background image. Note that this is both filename and extension. Only PNG files are accepted. |
| 2 | `x` | Number | This is the most left point of the canvas where your slider should be shown. |
| 3 | `y` | Number | This is the most top point of the canvas where your slider should be shown. |
| 4 | `width` | Number | The slider width on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the slider. |
| 5 | `height` | Number | The slider height on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the slider. |
| 6 | `radius` | Number | The distance between the center of the slider and the center of the thumb. |
| 7 | `start_angle` | Number | The start angle where the slider starts, in degrees. This position is determined as 0.0. |
| 8 | `end_angle` | Number | The end angle where the slider ends, in degrees. This position is determined as 1.0. |
| 9 | `thumb_image` | String | The thumb image. Note that this is both filename and extension. Only PNG files are accepted. |
| 10 | `thumb_width` | Number | The slider thumb width on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the slider thumb. |
| 11 | `thumb_height` | Number | The slider thumb height on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the slider thumb. |
| 12 | `position_callback` | Function | This function will be called when the slider changed position. The position ranges from 0.0 to 1.0. |
| 13 | `pressed_callback` | Function | (Optional) This function will be called when the slider is being pressed. |
| 14 | `released_callback` | Function | (Optional) This function will be called when the slider is being released. |

## Examples

### Example (Fixed slider)

```lua
-- Called when slider changed position
function callback(position)

  -- Position is between 0.0 and 1.0
  print("slider changed to position " .. position)
end

-- Full from 90 to 270 degrees (bottom half)
slider_id = slider_add_cir("slider.png", 0, 0, 200, 50, 30, 90, 270, "thumb.png", 20, 40, callback)
```

### Example (Endless slider)

```lua
-- Called when slider changed position
function callback(position)

  -- Position is between 0.0 and 1.0
  print("slider changed to position " .. position)
end

-- Endless slider. Position 0.0 is at 0 degrees.
slider_id = slider_add_cir("slider.png", 0, 0, 200, 50, 30, 0, nil, "thumb.png", 20, 40, callback)
```
