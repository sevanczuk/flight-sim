---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: device_prop_subscribe
Namespace: Device
Source URL: https://wiki.siminnovations.com/index.php?title=Device_prop_subscribe
Revision: 5153
---

# Device prop subscribe

## Signature

```
device_prop_subscribe(prop_name, callback) device_prop_subscribe(device_id, prop_name, callback)
```

## Description

device_prop_subscribe is used to subscribe to a property for a device. Available properties depend on the device type. A callback is called when the property changes value. See [Device list](./Device_list.md) for available properties.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `device_id` | id | (Optional) Device id. This can be obtained through Device_add function. Not needed when starting script within Device plugin. |
| 2 | `prop_name` | String | Property name which need to be set. See the Device list for available properties. |
| 3 | `callback` | function | Function that is called when property value changes. First argument contains the data. |

## Examples

### Example

```lua
-- Subscribe to property
device_prop_subscribe("PROP_NAME", function(data)
  print("got " .. tostring(data) )
end)
```
