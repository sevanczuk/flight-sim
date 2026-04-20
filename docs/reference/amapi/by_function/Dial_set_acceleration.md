---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: dial_set_acceleration
Namespace: Dial
Source URL: https://wiki.siminnovations.com/index.php?title=Dial_set_acceleration
Revision: 4491
---

# Dial set acceleration

## Signature

```
dial_set_acceleration(dial_id, acceleration)
```

## Description

dial_set_acceleration is used to set a new acceleration value for a dial.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `dial_add` | ID | Dial identifier. This can be obtained by calling dial_add. |
| 2 | `acceleration` | Number | A multiplier that will make the dial generate extra callbacks when the dial is being rotated faster. The multiplier is the maximum number of callbacks of one dial tick when this dial is being rotated at maximum speed. |

## Examples

### Example

```lua
function callback(direction)
  print("dial has been turned")
end
 
dial_id = dial_add("a.png", 100,100,100,100,callback)

-- Set acceleration
dial_set_acceleration(dial_id, 2)
```
