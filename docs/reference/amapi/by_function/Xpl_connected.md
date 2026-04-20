---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: xpl_connected
Namespace: Xpl
Source URL: https://wiki.siminnovations.com/index.php?title=Xpl_connected
Revision: 4757
---

# Xpl connected

## Signature

```
connected = xpl_connected()
```

## Description

xpl_connected is used to check if there is an active connected with X-Plane.

## Return value

connected

## Examples

### Example

```lua
if xpl_connected() then
  print("Wowsers, we are connected to X-Plane!")
end
```
