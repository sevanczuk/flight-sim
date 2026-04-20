---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: slider_add_ver
Namespace: Slider
Source URL: https://wiki.siminnovations.com/index.php?title=Slider_add_ver
Revision: 2985
---

# Slider add ver

## Signature

```
slider_id = slider_add_ver(image, x, y, width, height, tick_image, tick_width, tick_height, position_callback) slider_id = slider_add_ver(image, x, y, width, height, tick_image, tick_width, tick_height, position_callback, pressed_callback) slider_id = slider_add_ver(image, x, y, width, height, tick_image, tick_width, tick_height, position_callback, pressed_callback, released_callback)
```

## Description

slider_add_ver is used to add a vertical slider on the specified location.

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
| 6 | `tick_image` | String | The tick image. Note that this is both filename and extension. Only PNG files are accepted. |
| 7 | `tick_width` | Number | The slider tick width on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the slider tick. |
| 8 | `tick_height` | Number | The slider tick height on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the slider tick. |
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
slider_id = slider_add_ver("slider.png", 0, 0, 50, 200, "thumb.png", 40, 20, callback)
```
