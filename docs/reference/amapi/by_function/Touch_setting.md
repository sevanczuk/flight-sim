---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: touch_setting
Namespace: Touch
Source URL: https://wiki.siminnovations.com/index.php?title=Touch_setting
Revision: 2328
---

# Touch setting

## Signature

```
touch_setting(node_id,property,value)
```

## Description

touch_setting is used to configure touch settings for dials, buttons or switches.

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
  print("dial has been turned another 90 degrees")
end
 
dial_id = dial_add("a.png", 100,100,100,100,callback)

-- We want to get a dial tick every 90 degrees
touch_setting(dial_id , "ROTATE_TICK", 90)

-- We do not want to show highlighting on this dial
touch_setting(dial_id , "SHOW_HIGHLIGHT", false)
```
