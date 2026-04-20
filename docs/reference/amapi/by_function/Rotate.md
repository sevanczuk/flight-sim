---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: rotate
Namespace: unprefixed
Source URL: https://wiki.siminnovations.com/index.php?title=Rotate
Revision: 5713
---

# Rotate

## Signature

```
rotate(node_id, degrees) rotate(node_id, degrees, anchor_x, anchor_y, anchor_z) rotate(node_id, degrees, animation_type, animation_speed) (from AM/AP 4.0) rotate(node_id, degrees, animation_type, animation_speed, animation_direction) (from AM/AP 4.0) rotate(node_id, degrees, anchor_x, anchor_y, anchor_z, animation_type, animation_speed, animation_direction) (from AM/AP 4.0)
```

## Description

rotate is used to rotate an image, txt or canvas object. The object will be rotated around the center of the object, unless a custom anchor point is provided.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `node_id` | ID | Node identifier. This number can be obtained by calling functions like img_add, txt_add or canvas_add. |
| 2 | `degrees` | Number | Number of degrees to rotate the object to. |
| 3 | `anchor_x` | Number | (Optional) Rotate around this X coordinate. |
| 4 | `anchor_y` | Number | (Optional) Rotate around this Y coordinate. |
| 5 | `anchor_z` | Number | (Optional) Rotate around this Z coordinate. |
| 6 | `animation_type` | String | (Optional) Can be 'OFF', 'LINEAR' or 'LOG'. |
| 7 | `animation_speed` | Float | (Optional) Animation speed. Between 1.0 (Fastest) and 0.0 (Slowest) |
| 8 | `animation_direction` | String | (Optional) Can be 'DIRECT', 'CW', 'CCW', 'FASTEST' or 'SLOWEST'. Default is 'DIRECT'.The 'DIRECT' mode will use the absolute rotation value (so it you go from 0 to 720 it will make two full rotations). All others will use the relative position (from 0 720 won't do anything since they are the same angle). |

## Examples

### Example (Simple)

```lua
-- Load and display text and images
myimage1 = img_add_fullscreen("myimage1.png")

-- Rotate myimage1 to 90 degrees
rotate(myimage1, 90)

-- This will also rotate the image to 90 degrees (450-360)
rotate(myimage1, 450)
```

### Example (Animation)

```lua
-- Add an image
myimage1 = img_add_fullscreen("myimage1.png")

-- Enable animation
rotate(myimage1, 0, "LOG", 0.04)

-- Any rotation done at this point will be animated
rotate(myimage1, 90)
```
