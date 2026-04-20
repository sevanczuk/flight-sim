---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: running_txt_add_cir
Namespace: Running
Source URL: https://wiki.siminnovations.com/index.php?title=Running_txt_add_cir
Revision: 4414
---

# Running txt add cir

## Signature

```
running_txt_id = running_txt_add_cir(x,y,nr_visible_items,item_width,item_height,radius,value_callback,style) running_txt_id = running_txt_add_cir(x,y,nr_visible_items,item_width,item_height,radius_x,radius_y,value_callback,style)
```

## Description

running_txt_add_cir is used to add a running text object. Running text can be used to make multiple text objects scrollable circular.

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
| 6 | `radius_x` | Number | The horizontal radius from the middle of the circle in pixels. |
| 7 | `radius_y` | Number | (Optional) The vertical radius from the middle of the circle in pixels. When not present, radius_x is used. |
| 8 | `value_callback` | Function | Callback function which will ask for the text that should be shown. |
| 9 | `style` | String or Function | The style to use. More information on styles. |

## Examples

### Example

```lua
-- This example generates a rotating compass rose
function value_callback(i)
    t = i % 12

    if t == 0 then
        return "N"
    elseif t == 1 then
        return "33"
    elseif t == 2 then
        return "30"
    elseif t == 3 then
        return "W"
    elseif t == 4 then
        return "24"
    elseif t == 5 then
        return "21"
    elseif t == 6 then
        return "S" 
    elseif t == 7 then
        return "15"
    elseif t == 8 then
        return "12"
    elseif t == 9 then
        return "E"
    elseif t == 10 then
        return "6" 
    elseif t == 11 then
        return "3"
    end
    
    value = 36 - (t*3)
    
    if value < 0 then
        value = value + 36
    end
    
    return value
end

-- This will generate a compass rose. Text objects are 50x50. Radius of the circle is 200.
my_running_txt_id = running_txt_add_cir(231,231,12,50,50,200,value_callback,"size:40px; color:black; font:arimo_bold.ttf; halign:center; valign:center")

-- Now we rotate the compass with a timer for a breathtaking demonstration ;-)
timer_start(nil,50,function(count)
    local heading = count % 360 -- The count is transformed into a heading
    running_txt_move_carot(my_running_txt_id, (heading / 30) + 6) -- 360 / 30 equals 12 (hence 12 items), plus 6 to make it start at 0 / North
end)
```
