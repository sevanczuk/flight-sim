---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: device_connected
Namespace: Device
Source URL: https://wiki.siminnovations.com/index.php?title=Device_connected
Revision: 5783
---

# Device connected

## Signature

```
device_connected() device_connected(device_id)
```

## Description

device_connected is used to check if the device is connected. See [Device list](./Device_list.md) for available commands.

## Return value

connected

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `device_id` | id | (Optional) Device id. This can be obtained through Device_add function. Not needed when starting script within Device plugin. |

## Examples

### Example

```lua
-- Fire command
if device_connected() then
  print("We are connected!")
end
```
