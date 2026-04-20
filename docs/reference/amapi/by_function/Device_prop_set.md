---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: device_prop_set
Namespace: Device
Source URL: https://wiki.siminnovations.com/index.php?title=Device_prop_set
Revision: 4955
---

# Device prop set

## Signature

```
device_prop_set(prop_name, value) device_prop_set(prop_name, unit, value) device_prop_set(device_id, prop_name, value) device_prop_set(device_id, prop_name, unit, value)
```

## Description

device_prop_set is used to set a property for a device. Available properties depend on the device type. See [Device list](./Device_list.md) for available properties.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `device_id` | id | (Optional) Device id. This can be obtained through Device_add function. Not needed when starting script within Device plugin. |
| 2 | `prop_name` | String | Property name which need to be set. See the Device list for available properties. |
| 3 | `unit` | String | Some properties support multiple units, e.g. needle position in percentage or absolute steps. See the Device list for available units. |
| 4 | `value` | Object | The value the property needs to be set. Type depends on the chosen property. See the Device list for available properties. |

## Examples

### Example

```lua
-- Device is a RealSimGear GMA350 audio panel
-- Turn on the COM 1 light
device_prop_set("COM1_ON", true)
```
