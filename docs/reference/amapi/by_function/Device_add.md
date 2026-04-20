---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: device_add
Namespace: Device
Source URL: https://wiki.siminnovations.com/index.php?title=Device_add
Revision: 4970
---

# Device add

## Signature

```
device_id = device_add(type, offset)
```

## Description

device_add is used to add a device. Note that the device needs to me added within the Air Manager or Air Player before you can access it here. See [Device list](./Device_list.md) for available devices.

## Return value

device_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `type` | String | Device type. See Device list for available devices. |
| 2 | `offset` | Number | (Optional) When you have multiple devices of the same type, you can provide an offset. |

## Examples

### Example

```lua
-- Add RealSimGear G5 device
my_device = device_add("REAL_SIM_GEAR_G5")

-- Print when the power button is released
device_command_subscribe("PWR_RELEASED", function()
    print"pwr released"
end)
```
