---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: device_command
Namespace: Device
Source URL: https://wiki.siminnovations.com/index.php?title=Device_command
Revision: 4964
---

# Device command

## Signature

```
device_command(cmd_name) device_command(device_id, cmd_name)
```

## Description

device_command is used to fire a command for a device. Available commands depend on the device type. See [Device list](./Device_list.md) for available commands.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `device_id` | id | (Optional) Device id. This can be obtained through Device_add function. Not needed when starting script within Device plugin. |
| 2 | `cmd_name` | String | Command name which need to be set. See the Device list for available commnads. |

## Examples

### Example

```lua
-- Fire command
device_command("CMD_NAME")
```
