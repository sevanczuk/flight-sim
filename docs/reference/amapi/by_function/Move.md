---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: move
Namespace: unprefixed
Source URL: https://wiki.siminnovations.com/index.php?title=Move
Revision: 3873
---

# Move

## Signature

```
move(node_id, x) move(node_id, x, y) move(node_id, x, y, width) move(node_id, x, y, width, height) move(node_id, x, y, width, height, animation_type) (from AM/AP 4.0) move(node_id, x, y, width, height, animation_type, animation_speed) (from AM/AP 4.0)
```

## Description

move is used to move an object. This can be an image, text, switch, button, joystick, slider, dial, scroll wheel or a map.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `node_id` | ID | Node identifier. This number can be obtained by calling functions like img_add or txt_add. |
| 2 | `x` | Number | (Optional) This is the most left point of the canvas where your object should be shown. |
| 3 | `y` | Number | (Optional) This is the most top point of the canvas where your object should be shown. |
| 4 | `width` | Number | (Optional) The new width of the object. |
| 5 | `height` | Number | (Optional) The new height of the object |
| 6 | `animation_type` | String | (Optional) Can be 'OFF', 'LINEAR' or 'LOG'. |
| 7 | `animation_speed` | Float | (Optional) Animation speed. Between 1.0 (Fastest) and 0.0 (Slowest) |

## Examples

### Example (Simple)

```lua
-- Add an image
myimage1 = img_add_fullscreen("myimage1.png")

-- Move image1 to x,y = 100,100, width=200, height=250
move(myimage1, 100, 100, 200, 250 )

-- Move image1 to x=200
-- Note that using 'nil' will ignore that parameter (last value will be preserved)
move(myimage1, 200, nil, nil, nil )
```

### Example (Animation)

```lua
-- Add an image
myimage1 = img_add_fullscreen("myimage1.png")

-- Enable animation
move(myimage1, nil, nil, nil, nil, "LOG", 0.04)

-- Any move done at this point will be animated
move(myimage1, 0, 0, 256, 256)
```
