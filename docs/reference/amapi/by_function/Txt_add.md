---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: txt_add
Namespace: Txt
Source URL: https://wiki.siminnovations.com/index.php?title=Txt_add
Revision: 5910
---

# Txt add

## Signature

```
txt_id = txt_add(text,style, x,y,width,height)
```

## Description

txt_add is used to show a text on the specified location. The txt is also stored in memory for further references.

## Return value

txt_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `txt` | String | This is the txt being shown |
| 2 | `style` | String | The style to use. See the paragraph below for available style arguments. |
| 3 | `x` | Number | This is the most left point of the canvas where your text should be shown. |
| 4 | `y` | Number | This is the most top point of the canvas where your text should be shown. |
| 5 | `width` | Number | The text width on the canvas. |
| 6 | `height` | Number | The text height on the canvas. |

## Examples

### Example

```lua
-- The myfont.ttf should be placed in the instrument resources folder
mytext = txt_add("hello world", "font:myfont.ttf; size:11; color: black; halign:left;", 0, 0, 200, 200)

-- rename text
txt_set(mytext, "goodbye world")
```
