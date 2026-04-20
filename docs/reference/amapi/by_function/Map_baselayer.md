---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: map_baselayer
Namespace: Map
Source URL: https://wiki.siminnovations.com/index.php?title=Map_baselayer
Revision: 3227
---

# Map baselayer

## Signature

```
map_baselayer(layer_id, source)
```

## Description

map_baselayer is used to change the baselayer source used in the map.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `layer_id` | Number | Map identifier. This number can be obtained by calling map_add. |
| 2 | `source` | String | The openstreetmap base layer to use. See map_add for available base layers. |

## Examples

### Example

```lua
-- Place a map to your instrument using the openstreetmap cycle map and zoom level of 10
id = map_add(0,0,500,500,"OSM_CYCLE", 10)

-- We want to use the standard openstreetmap
map_baselayer(id, "OSM_STANDARD")
```
