---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: ext_connected
Namespace: Ext
Source URL: https://wiki.siminnovations.com/index.php?title=Ext_connected
Revision: 5755
---

# Ext connected

## Signature

```
connected = ext_connected(source_tag)
```

## Description

ext_connected is used to check if an external data source is connected.

## Return value

connected

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `source_tag` | String | The data source tag. The source tag can be configured in the settings part of Air Manager. |

## Examples

### Example

```lua
if ext_connected("MY_DATA_SOURCE") then
  print("We are connected to MY_DATA_SOURCE!")
end
```
