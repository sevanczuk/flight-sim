---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: group_add
Namespace: Group
Source URL: https://wiki.siminnovations.com/index.php?title=Group_add
Revision: 5710
---

# Group add

## Signature

```
group_id = group_add(node_id, node_id, ...)
```

## Description

group_add is to group together Nodes. This function will provide with a group_id.

## Return value

group_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 .. n | `node_id` | ID | A reference to the node. This can be a button_id, switch_id, dial_id, etc. etc. |

## Examples

### Example

```lua
function click(var)
end

-- Make some GUI objects, In this case a switch, button and a dial
button_id = button_add("off.png",nil,50,50,145,145,click)
switch_id = switch_add("off.png","on.png","off.png","on.png",50,200,145,145,click)
dial_id = dial_add("on.png",200,200,145,145,click)

-- Group them together
group_id = group_add(button_id, switch_id,  dial_id)

-- Make the entire group not visible
visible(group_id,false)
```
