---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: running_img_add_ver
Namespace: Running
Source URL: https://wiki.siminnovations.com/index.php?title=Running_img_add_ver
Revision: 2340
---

# Running img add ver

## Signature

```
running_img_id = running_img_add_ver(filename, x,y,nr_visible_items,item_width,item_height)
```

## Description

running_img_add_ver is used to add a running image object. Running imagecan be used to make multiple image objects scrollable vertically.

## Return value

running_img_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `filename` | String | This is the filename of the image you would like to show. Note that this is both filename and extension. Its good practice to always the PNG format for images. JPG and BMP are also supported, but not recommended. |
| 2 | `x` | Number | This is the most left point of the canvas where your running image should be shown. |
| 3 | `y` | Number | This is the most top point of the canvas where your running image should be shown. |
| 4 | `nr_visible_items` | Number | Number of image items that should be shown. |
| 5 | `item_width` | Number | The width of every image object in pixels. |
| 6 | `item_height` | Number | The height of every image object in pixels. |

## Examples

### Example

```lua
-- This will generate 7 image_objects vertically.
my_running_img_id = running_img_add_ver("picture.png",100,100,7,200,100)

-- Set carot to 1
running_img_move_carot(my_running_img_id , 1)

-- Or to 2...
running_img_move_carot(my_running_img_id , 2)
```
