---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: img_add_fullscreen
Namespace: Img
Source URL: https://wiki.siminnovations.com/index.php?title=Img_add_fullscreen
Revision: 4472
---

# Img add fullscreen

## Signature

```
image_id = img_add_fullscreen(filename) image_id = img_add_fullscreen(filename, style)
```

## Description

img_add_fullscreen is used to show an image fullscreen on the canvas. The image is also stored in memory for further references.

## Return value

image_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `filename` | String | This is the filename of the image you would like to show. Note that this is both filename and extension. Only the PNG file format is supported. |
| 2 | `style` | String | (Optional) The style to use. See img_add for available style arguments. |

## Examples

### Example

```lua
-- Load and display text and images
myimage1 = img_add_fullscreen("myimage1.png")

-- Note that myimage2 is placed on top of image1. Off course, transparency is supported.
myimage2 = img_add_fullscreen("myimage2.png")
```
