---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: instrument_prop
Namespace: Instrument
Source URL: https://wiki.siminnovations.com/index.php?title=Instrument_prop
Revision: 3039
---

# Instrument prop

## Signature

```
value = instrument_prop(property)
```

## Description

instrument_prop is used to get the settings from the current instrument like aircraft, type, version, height, width, development, etc etc...

## Return value

value

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `property` | String | The type of property to fetch. See table below for the options |

## Examples

### Example

```lua
-- Print the instrument author
print( instrument_prop("AUTHOR") )

-- See if we started from the create/edit tab
if instrument_prop("DEVELOPMENT") then
  print("We are running in development mode!")
end
```
