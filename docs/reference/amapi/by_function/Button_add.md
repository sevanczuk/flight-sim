---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: button_add
Namespace: Button
Source URL: https://wiki.siminnovations.com/index.php?title=Button_add
Revision: 2347
---

# Button add

## Signature

```
button_id = button_add(img_normal,img_pressed,x,y,width,height,click_press_callback, click_release_callback)
```

## Description

button_add is used to add a button on the specified location. The button is also stored in memory for further references.

## Return value

button_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `img_normal` | String | This is the filename of the image you would like to show on your button. Note that this is both filename and extension. Its good practice to always use PNG format for images. JPG and BMP are also supported, but not recommended. |
| 2 | `img_pressed` | String | This is the filename of the image you would like to show on your button when the used presses it. Note that this is both filename and extension. Its good practice to always use PNG format for images. JPG and BMP are also supported, but not recommended. This field is optional, you can also provide it with 'nil'. |
| 3 | `x` | Number | This is the most left point of the canvas where your button should be shown. |
| 4 | `y` | Number | This is the most top point of the canvas where your button should be shown. |
| 5 | `width` | Number | The button width on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the button. |
| 6 | `height` | Number | The button height on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the button. |
| 7 | `click_press_callback` | Function | This function will be called when the button is being pressed. |
| 8 | `click_release_callback` | Function | This function will be called when the button is being released. (Optional) |

## Examples

### Example

```lua
function callback_pressed()
  print("I am pressed!")
end

function callback_released()
  print("I am released!")
end

-- At a button at x=100, y=100, width = 200, height=200
-- The function 'callback_pressed' will be called when the button is being pressed
-- The function 'released' will be called when the button is being released (This argument is optional)
button_id = button_add("a.png", "b.png", 100,100,200,200,callback_pressed, callback_released)
```
