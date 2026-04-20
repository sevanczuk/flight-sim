---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: game_controller_add
Namespace: Game
Source URL: https://wiki.siminnovations.com/index.php?title=Game_controller_add
Revision: 4390
---

# Game controller add

## Signature

```
game_controller_id = game_controller_add(name, callback)
```

## Description

game_controller_add is used to add a game controller.

## Return value

game_controller_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | Game controller name. Can be fetched from game_controller_list call. |
| 2 | `callback` | Function | Callback which is called when a button or axis is changed on the game controller. Three arguments will be provided in the callback. Type (0=Axis, 1=Button), index (0 based offset for multiple buttons or axis) and value. |

## Examples

### Example

```lua
function callback(type, index, value)
    print("type = " .. type .. ", index = " .. index .. ", value = " .. tostring(value))
end

list = game_controller_list()

for k, v in pairs(list) do
    game_controller_add(v, callback)
end
```
