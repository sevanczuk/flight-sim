---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: p3d_connected
Namespace: P3d
Source URL: https://wiki.siminnovations.com/index.php?title=P3d_connected
Revision: 4763
---

# P3d connected

## Signature

```
connected = p3d_connected()
```

## Description

p3d_connected is used to check if there is an active connected with Prepar3D.

## Return value

connected

## Examples

### Example

```lua
if p3d_connected() then
  print("Dearie me, we are connected to Prepar3D!")
end
```
