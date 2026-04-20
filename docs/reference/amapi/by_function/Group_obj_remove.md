---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: group_obj_remove
Namespace: Group
Source URL: https://wiki.siminnovations.com/index.php?title=Group_obj_remove
Revision: 5712
---

# Group obj remove

## Signature

```
group_obj_remove(group_id, gui_id, ...)
```

## Description

group_obj_remove is used to remove additional objects from an existing group. This can be an image, text, switch, button, dial, map or a group.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `group_id` | String | Group identifier. This can be obtained from the group_add function. |
| 2 .. n | `gui_id` | String | A reference to a gui object. This can be a button_id, switch_id, dial_id, image_id, txt_id or map_id. |

## Examples

### Example

```lua
-- Load and display text and images
myimage1 = img_add_fullscreen("myimage1.png")
myimage2 = img_add_fullscreen("myimage2.png")
myimage3 = img_add_fullscreen("myimage3.png")

-- Let's create a group from these three images
group_id = group_add(myimage1, myimage2, myimage3)

-- Let's remove two from the list
group_obj_remove(group_id, myimage2, myimage3)

-- And add one back again
group_obj_add(group_id, myimage3)
```
