---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fill_img
Namespace: Fill
Source URL: https://wiki.siminnovations.com/index.php?title=Fill_img
Revision: 3233
---

# Fill img

## Signature

```
_fill_img(file_name, x, y, width, height) _fill_img(file_name, x, y, width, height, opacity)
```

## Description

_fill_img is used to apply all queued drawings into a fill (inside is the image provided).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `file_name` | String | File name of the image within the resource folder. Only PNG files are supported. |
| 2 | `x` | Number | X offset in pixels |
| 3 | `y` | Number | Y offset in pixels |
| 4 | `width` | Number | The width of the rendered image |
| 5 | `height` | Number | The height of the rendered image |
| 6 | `opacity` | Number | (Optional) The opacity in which the image should be drawn. Ranges from 0.0 (invisible) to 1.0 (completely visible). |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  -- Create a rectangle
  _rect(0, 0, 100, 100)

  -- Draw the image within the rectangle
  _fill_img("test.png", 0, 0, 100, 100)
end)
```
