---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: scrollwheel_add_hor
Namespace: Scrollwheel
Source URL: https://wiki.siminnovations.com/index.php?title=Scrollwheel_add_hor
Revision: 2987
---

# Scrollwheel add hor

## Signature

```
scrollwheel_id = scrollwheel_add_hor(segment_image, x, y, width, height, segment_width, segment_height, direction_callback) scrollwheel_id = scrollwheel_add_hor(segment_image, x, y, width, height, segment_width, segment_height, direction_callback, pressed_callback) scrollwheel_id = scrollwheel_add_hor(segment_image, x, y, width, height, segment_width, segment_height, direction_callback, pressed_callback, released_callback)
```

## Description

scrollwheel_add_hor is used to add a vertical scroll wheel to an instrument.

## Return value

scrollwheel_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `segment_image` | String | The segment image. The scroll wheel is drawn by repeating a certain segment image. Make sure to design this segment image to pit perfectly next to each other. Note that this is both filename and extension. Only PNG files are accepted. |
| 2 | `x` | Number | This is the most left point of the canvas where your scroll wheel should be shown. |
| 3 | `y` | Number | This is the most top point of the canvas where your scroll wheel should be shown. |
| 4 | `width` | Number | The scroll wheel width on the canvas. |
| 5 | `height` | Number | The scroll wheel height on the canvas. |
| 7 | `segment_width` | Number | The scroll wheel segment width on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the slider tick. |
| 8 | `segment_height` | Number | The scroll wheel segment height on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the slider tick. |
| 9 | `direction_callback` | Function | This function will be called when the user manipulates the scroll wheel. A direction argument is supplied, where -1 is scrolled left, and 1 is scrolled right. |
| 10 | `pressed_callback` | Function | (Optional) This function will be called when the scroll wheel is being pressed. |
| 11 | `released_callback` | Function | (Optional) This function will be called when the scroll wheel is being released. |

## Examples

### Example

```lua
-- Called when user drags the scroll wheel
function callback(direction)

  if direction == -1 then
    print("scroll wheel dragged left")
  end

  if direction == 1 then
    print("scroll wheel dragged right")
  end
end

-- Create a new scroll wheel
scrollwheel_id = scrollwheel_add_hor("segment.png", 0, 0, 200, 200, 50, 50, callback)
```
