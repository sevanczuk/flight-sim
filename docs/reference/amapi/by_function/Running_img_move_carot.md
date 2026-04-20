---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: running_img_move_carot
Namespace: Running
Source URL: https://wiki.siminnovations.com/index.php?title=Running_img_move_carot
Revision: 111
---

# Running img move carot

## Signature

```
running_img_move_carot(running_img_id,position)
```

## Description

running_img_move_carot is used set the carot of a running image object. Changing the carot will make the running image object scroll.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `running_img_id` | Number | The running image id of which to move the carot |
| 2 | `position` | Number | The position to move the carot to. |

## Examples

### Example

```lua
-- This will generate 7 image_objects circularly, with a radius of 350.
my_running_img_id = running_img_add_cir("picture.png",100,100,7,200,100, 350)

-- Set carot to 1
running_img_move_carot(my_running_img_id , 1)

-- Or to 2...
running_img_move_carot(my_running_img_id , 2)
```
