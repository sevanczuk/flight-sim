---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: img_add
Namespace: Img
Source URL: https://wiki.siminnovations.com/index.php?title=Img_add
Revision: 5038
---

# Img add

## Signature

```
image_id = img_add(filename, x, y, width, height) image_id = img_add(filename, x, y, width, height, style)
```

## Description

img_add is used to show an image on the specified location. The image is also stored in memory for further references.

## Return value

image_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `filename` | String | This is the filename of the image you would like to show. Note that this is both filename and extension. Only the PNG file format is supported. |
| 2 | `x` | Number | This is the most left point of the canvas where your image should be shown. |
| 3 | `y` | Number | This is the most top point of the canvas where your image should be shown. |
| 4 | `width` | Number | The image width on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the image. From AM 2.1.1, nil will make the image the same width as the PNG image. |
| 5 | `height` | Number | The image height on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the image. From AM 2.1.1, nil will make the image the same height as the PNG image. |
| 6 | `style` | String | (Optional) The style to use. See the paragraph below for available style arguments. |

## Examples

### Example (Simple)

```lua
-- Load image
myimage1 = img_add("myimage1.png", 0, 0, 200, 200)

-- Load second image with some special styling options
myimage2 = img_add("myimage2.png", 200, 0, 200, 200, "opacity: 0.6; viewport_rect: 0 0 50 50")

-- Rotate image1
rotate(myimage1, 90)
```

### Example (Rotation animation)

```lua
-- Load image, and enable automatic animation when rotating
myimage1 = img_add("myimage1.png", 0, 0, 200, 200, "rotate_animation_type: LOG; rotate_animation_speed: 0.02")

-- Rotate image1
rotate(myimage1, 90)
```
