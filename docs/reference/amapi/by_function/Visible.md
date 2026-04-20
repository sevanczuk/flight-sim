---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: visible
Namespace: unprefixed
Source URL: https://wiki.siminnovations.com/index.php?title=Visible
Revision: 2317
---

# Visible

## Signature

```
visible(node_id,visible)
```

## Description

visible is used to make a node visible or invisible. This can be an image, text, switch, button, dial, joystick, slider, map, scroll wheel or a group.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `node_id` | ID | Node identifier. This number can be obtained by calling functions like img_add or txt_add. |
| 2 | `visible` | Boolean | True if image should make visible, False if it should be hidden. |

## Examples

### Examples

```lua
-- Load and display text and images
myimage1 = img_add_fullscreen("myimage1.png")

-- Images are visible by default

-- Hide the image
visible(myimage1, false)

-- And make it show again!
visible(myimage1, true)

-- Make it visible when the variable 'light' is 1
visible(myimage1, light == 1)

-- Make it visible when the variable 'light' is equal to or higher than 10
visible(myimage1, light >= 10)

-- Make it visible when the variable 'light' is anything else than 10
visible(myimage1, light ~= 10)

-- When variable 'light' is a boolean. A boolean is always true or false, or 1 or 0.
visible(myimage1, light)
```
