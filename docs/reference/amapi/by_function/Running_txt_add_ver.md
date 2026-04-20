---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: running_txt_add_ver
Namespace: Running
Source URL: https://wiki.siminnovations.com/index.php?title=Running_txt_add_ver
Revision: 2344
---

# Running txt add ver

## Signature

```
running_txt_id = running_txt_add_ver(x,y,nr_visible_items,item_width,item_height,value_callback,style)
```

## Description

running_txt_add_ver is used to add a running text object. Running text can be used to make multiple text objects scrollable vertically.

## Return value

running_txt_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `x` | Number | This is the most left point of the canvas where your running text should be shown. |
| 2 | `y` | Number | This is the most top point of the canvas where your running text should be shown. |
| 3 | `nr_visible_items` | Number | Number of text items that should be shown. |
| 4 | `item_width` | Number | The width of every text object in pixels. |
| 5 | `item_height` | Number | The height of every text object in pixels. |
| 6 | `value_callback` | Function | Callback function which will ask for the text that should be shown. |
| 7 | `style` | String | The style to use. See txt_add for available style properties. |

## Examples

### Example

```lua
function value_callback(item_nr)
  return "this is item " .. item_nr
end

-- This will generate 7 text_objects vertically. Text objects are 200x100.
my_running_txt_id = running_txt_add_ver(100,100,7,200,100,value_callback, "size:11; color: black;")

-- Set carot to 1
running_txt_move_carot(my_running_txt_id, 1)

-- Or to 2...
running_txt_move_carot(my_running_txt_id, 2)
```
