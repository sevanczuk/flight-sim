---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: si_command_subscribe
Namespace: Si
Source URL: https://wiki.siminnovations.com/index.php?title=Si_command_subscribe
Revision: 3550
---

# Si command subscribe

## Signature

```
si_command_subscribe(command_name,callback_function)
```

## Description

si_command_subscribe is used to subscribe on one or more global commands. Global commands can be used to communicate between instruments.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `command_name` | String | Reference to a global variable |
| 2 | `callback_function` | Function | The function to call when a new command has been sent |

## Examples

### Example

```lua
-- This function will be called when the dial has gone up
 function master_dial_up(typecmd)
   print("Dial has gone up")

   -- Can be BEGIN, ONCE or END
   print("Command type = " .. typecmd)
 end

 -- subscribe to command
 si_command_subscribe("MASTER_DIAL_UP", master_dial_up)
```
