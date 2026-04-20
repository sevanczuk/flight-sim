---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: device_command_subscribe
Namespace: Device
Source URL: https://wiki.siminnovations.com/index.php?title=Device_command_subscribe
Revision: 4969
---

# Device command subscribe

## Signature

```
device_command_subscribe(cmd_name, callback) device_command_subscribe(device_id, cmd_name, callback)
```

## Description

device_cmd_subscribe is used to subscribe to a command for a device. Available commands depends on the device type. A callback is called when the property changes value. See [Device list](./Device_list.md) for available commands.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `device_id` | id | (Optional) Device id. This can be obtained through Device_add function. Not needed when starting script within Device plugin. |
| 2 | `cmd_name` | String | Command name which need to be set. See the Device list for available commands. |
| 3 | `callback` | function | Function that is called when command is fired. |

## Examples

### Example

```lua
-- Subscribe to property
device_command_subscribe("CMD_NAME", function()
  print("command fired")
end)
```
