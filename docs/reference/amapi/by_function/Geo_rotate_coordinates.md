---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: geo_rotate_coordinates
Namespace: Geo
Source URL: https://wiki.siminnovations.com/index.php?title=Geo_rotate_coordinates
Revision: 5018
---

# Geo rotate coordinates

## Signature

```
x, y = geo_rotate_coordinates(degrees, radius_x, radius_y)
```

## Description

geo_rotate_coordinates is used to get the x and y coordinates from a circle with a certain radius and angle.

## Return value

x

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `degrees` | Number | The number of degrees to calculate with. |
| 2 | `radius x` | Number | The x radius in pixels. This is the number of pixels from the center of the circle to the horizontal edge. |
| 3 | `radius y` | Number | This value is optional. The y radius in pixels. This is the number of pixels from the center of the circle to the vertical edge. |

## Examples

### Example

```lua
-- Calculate the x and y coordinate on 45 degrees with a radius of 200 pixels
myimage1 = img_add("myimage.png", 100, 100, 200, 200)

x, y = geo_rotate_coordinates(45,200)

move(myimage1, x, y, nil, nil)

-- Calculate the x and y coordinate (oval) on 45 degrees with a radius x of 200 pixels and radius y of 100 pixels
myimage2 = img_add("myimage.png", 100, 100, 200, 200)

x, y = geo_rotate_coordinates(45,200,100)

move(myimage2, x, y, nil, nil)
```
