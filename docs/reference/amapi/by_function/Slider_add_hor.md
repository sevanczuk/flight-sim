---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: slider_add_hor
Namespace: Slider
Source URL: https://wiki.siminnovations.com/index.php?title=Slider_add_hor
Revision: 2984
---

# Slider add hor

## Signature

```
slider_id = slider_add_hor(image, x, y, width, height, thumb_image, thumb_width, thumb_height, position_callback) slider_id = slider_add_hor(image, x, y, width, height, thumb_image, thumb_width, thumb_height, position_callback, pressed_callback) slider_id = slider_add_hor(image, x, y, width, height, thumb_image, thumb_width, thumb_height, position_callback, pressed_callback, released_callback)
```

## Description

slider_add_hor is used to add a horizontal slider on the specified location.

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
| 6 | `thumb_image` | String | The thumb image. This is the image that is moved. Note that this is both filename and extension. Only PNG files are accepted. |
| 7 | `thumb_width` | Number | The slider thumb width on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the slider thumb. |
| 8 | `thumb_height` | Number | The slider thumb height on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the slider thumb. |
| 9 | `position_callback` | Function | This function will be called when the user want to change position. Position ranges from 0.0 to 1.0. Note that you have to set the actual position of the slider with function slider_set_position. |
| 10 | `pressed_callback` | Function | (Optional) This function will be called when the slider is being pressed. |
| 11 | `released_callback` | Function | (Optional) This function will be called when the slider is being released. |

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
```
