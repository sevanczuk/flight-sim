---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fi_engine_cluster_prop_set
Namespace: Fi
Source URL: https://wiki.siminnovations.com/index.php?title=Fi_engine_cluster_prop_set
Revision: 3501
---

# Fi engine cluster prop set

## Signature

```
fi_engine_cluster_prop_set(fi_gauge_id, prop_name, value) fi_engine_cluster_prop_set(fi_gauge_id, prop_name, unit, value)
```

## Description

fi_engine_cluster_prop_set is used to set a property for a Flight Illusion engine cluster. Available properties depend on the gauge type. See [Flight Illusion Engine Clusters](./Flight_Illusion_Engine_Clusters.md) [missing] for available properties.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `fi_engine_cluster_id` | String | Reference to the Flight Illusion engine cluster. |
| 2 | `prop_name` | String | Property name which need to be set. See Flight Illusion Engine Clusters for available properties. |
| 3 | `unit` | String | Some properties support multiple units, e.g. needle position in percentage or absolute steps. See Flight Illusion Engine Clusters for available units. |
| 4 | `value` | Object | The value the property needs to be set. Type depends on the chosen property. See Flight Illusion Gauges for available properties. |

## Examples

### Example

```lua
-- Gauge type is a Robinson R22 engine cluster
fi_engine_cluster_id = fi_engine_cluster_add("R22")

-- Set the position of the first needle to the middle
fi_engine_cluster_prop_set(fi_engine_cluster_id , "NEEDLE_POS_1", 0.5)
```
