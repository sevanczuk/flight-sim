---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: dial_add
Namespace: Dial
Source URL: https://wiki.siminnovations.com/index.php?title=Dial_add
Revision: 4672
---

# Dial add

## Signature

```
dial_id = dial_add(image, x, y, width, height, direction_callback) dial_id = dial_add(image, x, y, width, height, direction_callback, pressed_callback) dial_id = dial_add(image, x, y, width, height, direction_callback, pressed_callback, released_callback) dial_id = dial_add(image, x, y, width, height, acceleration, direction_callback) dial_id = dial_add(image, x, y, width, height, acceleration, direction_callback, pressed_callback) dial_id = dial_add(image, x, y, width, height, acceleration, direction_callback, pressed_callback, released_callback)
```

## Description

dial_add is used to add a dial on the specified location. The dial is also stored in memory for further references.

## Return value

dial_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `image` | String | This is the filename of the image you would like to show on your dial. Note that this is both filename and extension. Its good practice to always use PNG format for images. JPG and BMP are also supported, but not recommended. |
| 2 | `x` | Number | This is the most left point of the canvas where your button should be shown. |
| 3 | `y` | Number | This is the most top point of the canvas where your button should be shown. |
| 4 | `width` | Number | The button width on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the button. |
| 5 | `height` | Number | The button height on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the button. |
| 6 | `acceleration` | Number | (Optional) A multiplier that will make the dial generate extra callbacks when the dial is being rotated faster. The multiplier is the maximum number of callbacks of one dial tick when this dial is being rotated at maximum speed. |
| 7 | `direction_callback` | Function | This function will be called when dial is being rotated. The function will give one argument, which will provide with a value telling which way the dial is being turned (1=clockwise, -1=counter-clockwise). |
| 8 | `pressed_callback` | Function | (Optional) This function will be called when the dial is being pressed. |
| 9 | `released_callback` | Function | (Optional) This function will be called when the dial is being released. |

## Examples

### Example

```lua
function callback(direction)
  -- Direction will have the value
  --  1: When the dial is being turned clockwise
  -- -1: When the dial is being turned anti-clockwise
  print("dial has been turned into direction " .. direction)
end

-- Adds a dial, The callback function will be called when the dial is being turned
dial_id = dial_add("a.png", 100,100,100,100,callback)
```
