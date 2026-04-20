---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fsx_connected
Namespace: Fsx
Source URL: https://wiki.siminnovations.com/index.php?title=Fsx_connected
Revision: 4761
---

# Fsx connected

## Signature

```
connected = fsx_connected()
```

## Description

fsx_connected is used to check if there is an active connected with FSX.

## Return value

connected

## Examples

### Example

```lua
if fsx_connected() then
  print("Crikey, we are connected to FSX!")
end
```
