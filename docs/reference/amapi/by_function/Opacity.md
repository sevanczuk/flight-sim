---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: opacity
Namespace: unprefixed
Source URL: https://wiki.siminnovations.com/index.php?title=Opacity
Revision: 4482
---

# Opacity

## Signature

```
opacity(node_id, opacity) opacity(node_id, opacity, animation_type) (from AM/AP 4.0) opacity(node_id, opacity, animation_type, animation_speed) (from AM/AP 4.0)
```

## Description

opacity is used to change the opacity of a node (opaque -> transparent). This can be an image, text, switch, button, dial, joystick, slider, map, scroll wheel, group or an instrument.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `node_id` | ID | Node identifier. This number can be obtained by calling functions like img_add or txt_add. |
| 2 | `opacity` | Float | Ranges from 0.0 (Transparent) to 1.0 (Opaque). |
| 3 | `animation_type` | String | (Optional) Can be 'OFF', 'LINEAR' or 'LOG'. |
| 4 | `animation_speed` | Float | (Optional) Animation speed. Between 1.0 (Fastest) and 0.0 (Slowest) |

## Examples

### Example (Simple)

```lua
-- Load and display text and images
myimage1 = img_add_fullscreen("myimage1.png")

-- Images are fully opaque by default

-- Fully transparant
opacity(myimage1, 0.0)

-- And make it show again!
opacity(myimage1, 1.0)

-- 50% transparant
opacity(myimage1, 0.5)
```

### Example (Animation)

```lua
-- Add an image
myimage1 = img_add_fullscreen("myimage1.png")

-- Enable animation
opacity(myimage1, 1.0, "LOG", 0.04)

-- Any opacity done at this point will be animated
opacity(myimage1, 0)
```
