---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fi_gauge_add
Namespace: Fi
Source URL: https://wiki.siminnovations.com/index.php?title=Fi_gauge_add
Revision: 4814
---

# Fi gauge add

## Signature

```
fi_gauge_id = fi_gauge_add(address, type)
```

## Description

fi_gauge_add is used to add a Flight Illusion gauge. Every Flight Illusion gauge must have a certain address (1-255) and is of a certain type.

## Return value

fi_gauge_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `address` | Number | Unique gauge address. Ranges from 1-255, and can be configured by Flight Illusion tools. |
| 2 | `type` | String | Gauge type. See Flight Illusion Gauges for available gauges. |

## Examples

### Example

```lua
-- Gauge is on address 12
-- Gauge type is a Single Needle gauge
fi_gauge = fi_gauge_add(12, "SINGLE_NEEDLE")

-- Set the position of the first needle to the middle
fi_gauge_prop_set(fi_gauge, "NEEDLE_POS_1", 0.5)
```
