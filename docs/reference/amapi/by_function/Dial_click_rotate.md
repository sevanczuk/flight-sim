---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: dial_click_rotate
Namespace: Dial
Source URL: https://wiki.siminnovations.com/index.php?title=Dial_click_rotate
Revision: 126
---

# Dial click rotate

## Signature

```
dial_click_rotate(dial_id,degrees_delta)
```

## Description

dial_click_rotate is used to set the number of degrees the dial should rotate on each click.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `dial_id` | Number | Reference to the dial |
| 2 | `degrees_delta` | Number | The number of degrees the dial should rotate on each click. |

## Examples

### Example

```lua
function callback(direction)
  print("dial has been turned into direction " .. direction)
end
 
dial_id = dial_add("a.png", 100,100,100,100,callback)

-- Set the dial to rotate 20 degrees, every time someone clicks the dial
dial_click_rotate(dial_id, 20)
```
