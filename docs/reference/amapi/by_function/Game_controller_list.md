---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: game_controller_list
Namespace: Game
Source URL: https://wiki.siminnovations.com/index.php?title=Game_controller_list
Revision: 3985
---

# Game controller list

## Signature

```
game_controller_id = game_controller_list()
```

## Description

game_controller_list is used to list all available joysticks on the system.

## Return value

game_controller_list

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
