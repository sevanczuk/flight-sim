---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: xpl_command_subscribe
Namespace: Xpl
Source URL: https://wiki.siminnovations.com/index.php?title=Xpl_command_subscribe
Revision: 4756
---

# Xpl command subscribe

## Signature

```
xpl_command_subscribe(commandref,callback_function)
```

## Description

xpl_command_subscribe is used to subscribe to a X-Plane command.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `commandref` | String | Reference to a command from X-Plane (see CommandRefs) |
| 2 | `callback_function` | Function | The function to call when a new command has been sent within X-Plane |

## Examples

### Example

```lua
-- This function will be called when the dial has gone up
 function fms_key_callback(typecmd)
   print("FMS key 0")

   -- Can be BEGIN, ONCE or END
   print("Command type = " .. typecmd)
 end

 -- subscribe to Air Manager command
 xpl_command_subscribe("sim/FMS/key_0", fms_key_callback)
```
