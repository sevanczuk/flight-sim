---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: viewport_rect
Namespace: Viewport
Source URL: https://wiki.siminnovations.com/index.php?title=Viewport_rect
Revision: 2321
---

# Viewport rect

## Signature

```
viewport_rect(node_id,x,y,width,height)
```

## Description

viewport_rect makes a node visible within a specified frame. The frame is a rectangle.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `node_id` | ID | The node id of which the viewport should be applied. |
| 2 | `x` | Number | This is the most left point of the canvas where the viewport starts. |
| 3 | `y` | Number | This is the most top point of the canvas where the viewport starts. |
| 4 | `width` | Number | The width of the viewport. |
| 5 | `height` | Number | The height of the viewport. |

## Examples

### Example

```lua
-- Load and display text and images
myimage1 = img_add("myimage1.png", 0, 0, 200, 200)
myimage2 = img_add("myimage2.png", 200, 0, 200, 200)

-- Only the top left part of image1 is shown
viewport_rect(myimage1, 0, 0, 100, 100)

-- Only the top bottom right of image2 is shown
viewport_rect(myimage2, 300, 100, 100, 100)
```
