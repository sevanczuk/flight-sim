---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: running_txt_move_carot
Namespace: Running
Source URL: https://wiki.siminnovations.com/index.php?title=Running_txt_move_carot
Revision: 3673
---

# Running txt move carot

## Signature

```
running_txt_move_carot(running_txt_id, position)
```

## Description

running_txt_move_carot is used set the position of a running txt object. The carot is seen as the index of the virtual list that should be rendered at the center of the running text. Changing the carot will make the running txt object scroll.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `running_txt_id` | Number | The running txt id of which to move the carot |
| 2 | `position` | Number | The position to move the carot to. |

## Examples

### Example

```lua
function value_callback(item_nr)
  return "this is item " .. item_nr
end

-- This will generate 7 text_objects horizontally. Text objects are 200x100. Radius of the circle is 350.
my_running_txt_id = running_txt_add_cir(100,100,7,200,100,350, value_callback,"-fx-font-size:11pt; -fx-fill: white;")

-- Set position to 1
running_txt_move_carot(my_running_txt_id, 1)

-- Or to 2...
running_txt_move_carot(my_running_txt_id, 2)
```
