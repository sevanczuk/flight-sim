---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fi_engine_cluster_add
Namespace: Fi
Source URL: https://wiki.siminnovations.com/index.php?title=Fi_engine_cluster_add
Revision: 5119
---

# Fi engine cluster add

## Signature

```
fi_engine_cluster_id = fi_engine_cluster_add(type)
```

## Description

fi_engine_cluster_add is used to add a flight illusion engine cluster.

## Return value

fi_engine_cluster_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `type` | String | Gauge type. See Flight Illusion Engine Clusters for available engine clusters. |

## Examples

### Example

```lua
-- Gauge type is a Robinson R22 engine cluster
fi_engine_cluster_id = fi_engine_cluster_add("ROBINSON_R22")

-- Set the position of the first needle to the middle
fi_engine_cluster_prop_set(fi_engine_cluster_id , "NEEDLE_POS_1", 0.5)
```
