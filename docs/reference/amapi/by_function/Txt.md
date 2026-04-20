---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: txt
Namespace: unprefixed
Source URL: https://wiki.siminnovations.com/index.php?title=Txt
Revision: 5849
---

# Txt

## Signature

```
_txt(text, style, x, y) _txt(text, style, x, y, opacity)
```

## Description

_txt is used to draw text within a canvas.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `txt` | String | This is the txt being shown |
| 2 | `style` | String | The style to use. See the paragraph below for available style arguments. |
| 3 | `x` | Number | This is the most left point of the canvas where your text should be shown. |
| 4 | `y` | Number | This is the most top point of the canvas where your text should be shown. |
| 5 | `opacity` | Number | (Optional) The opacity in which the text should be drawn. Ranges from 0.0 (invisible) to 1.0 (completely visible). |

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  _txt("Hello world", "font:roboto_bold.ttf; size:16; color: green; halign:left;", 0, 0)
end)
```
