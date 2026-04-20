---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: ext_command_subscribe
Namespace: Ext
Source URL: https://wiki.siminnovations.com/index.php?title=Ext_command_subscribe
Revision: 5693
---

# Ext command subscribe

## Signature

```
ext_command_subscribe(command_name,callback_function)
```

## Description

ext_command_subscribe is used to subscribe to an external data source commands.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `command_name` | String | Reference to the command |
| 2 | `callback_function` | Function | The function to call when a new command has been sent |

## Examples

### Example

```lua
-- This function will be called when the command is fired
 function command_callback()
   print("command fired")
 end

 -- subscribe to command
 ext_command_subscribe("MY_DATA_SOURCE", "my_command", command_callback)
```
