---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fi_gauge_prop_set
Namespace: Fi
Source URL: https://wiki.siminnovations.com/index.php?title=Fi_gauge_prop_set
Revision: 3499
---

# Fi gauge prop set

## Signature

```
fi_gauge_prop_set(fi_gauge_id, prop_name, value) fi_gauge_prop_set(fi_gauge_id, prop_name, unit, value)
```

## Description

fi_gauge_prop_set is used to set a property for a Flight Illusion engine cluster. Available properties depend on the engine cluster type. See [Flight Illusion Gauges](./Flight_Illusion_Gauges.md) [missing] for available properties.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `fi_gauge_id` | String | Reference to the Flight Illusion gauge. |
| 2 | `prop_name` | String | Property name which need to be set. See Flight Illusion Gauges for available properties. |
| 3 | `unit` | String | Some properties support multiple units, e.g. needle position in percentage or absolute steps. See Flight Illusion Gauges for available units. |
| 4 | `value` | Object | The value the property needs to be set. Type depends on the chosen property. See Flight Illusion Gauges for available properties. |

## Examples

### Example

```lua
-- Gauge type is a single needle
fi_gauge = fi_gauge_add(12, "SINGLE_NEEDLE")

-- Set the position of the needle to the middle
fi_gauge_prop_set(fi_gauge, "NEEDLE_POS_1", 0.5)
```
