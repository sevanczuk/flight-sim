---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fi_gauge_prop_subscribe
Namespace: Fi
Source URL: https://wiki.siminnovations.com/index.php?title=Fi_gauge_prop_subscribe
Revision: 3387
---

# Fi gauge prop subscribe

## Signature

```
fi_gauge_prop_subscribe(fi_gauge_id, prop_name, callback_function)
```

## Description

fi_gauge_prop_subscribe is used to subscribe to a Flight Illusion gauge property. See [Flight Illusion Gauges](./Flight_Illusion_Gauges.md) [missing] for available properties.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `fi_gauge_id` | String | Reference to the flight illusion gauge. |
| 2 | `prop_name` | String | Name of the property. See Flight Illusion Gauges for available properties. |
| 3 | `callback_function` | Function | The function to call when the property value is changed. |

## Examples

### Example

```lua
-- Get a reference to the gauge
fi_gauge_id = fi_gauge_add(111, "ANALOGUE_ALTIMETER")

-- Subscribe to the AIR_PRESSURE property
fi_gauge_prop_subscribe(fi_gauge_id, "AIR_PRESSURE", function(value)
    print("air pressure = " .. value)
end)
```
