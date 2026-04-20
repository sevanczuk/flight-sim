---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: instrument_get
Namespace: Instrument
Source URL: https://wiki.siminnovations.com/index.php?title=Instrument_get
Revision: 2789
---

# Instrument get

## Signature

```
instrument_id = instrument_get(uuid) instrument_id = instrument_get(uuid, offset)
```

## Description

instrument_get is used to get a reference to an instrument. This function only works in a panel lua file, and only instruments that are part of the panel can be retrieved.

## Return value

instrument_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `uuid` | String | The UUID string for the instrument. |
| 2 | `offset` | Number | (Optional) Offset when multiple instruments of the same type are part of the panel. |

## Examples

### Example

```lua
id = instrument_get("fd2f89a1-59ec-416f-8f28-e5b8bf4c1cbc")

if id ~= nil then
  -- Make the instrument invisible
  visible(id, false)
else
  print("Could not find instrument")
end
```
