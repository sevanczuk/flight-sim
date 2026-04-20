---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: mouse_setting
Namespace: Mouse
Source URL: https://wiki.siminnovations.com/index.php?title=Mouse_setting
Revision: 3825
---

# Mouse setting

## Signature

```
mouse_setting(node_id,property,value)
```

## Description

mouse_setting is used to configure mouse settings for dials, buttons or switches.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `node_id` | ID | Node identifier. This can be obtained by calling functions like dial_add or switch_add. |
| 2 | `property` | String | Setting property. |
| 3 | `value` | Object | The value to set for the property. The type of value depends on the chosen property. |

## Examples

### Example

```lua
function callback(direction)
  print("dial has been turned")
end
 
dial_id = dial_add("a.png", 100,100,100,100,callback)

-- We want to set our custom cursors for this dial
mouse_setting(dial_id , "CURSOR_LEFT", "cursor_left.png")
mouse_setting(dial_id , "CURSOR_RIGHT", "cursor_right.png")
```
