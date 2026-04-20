---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: msfs_connected
Namespace: Msfs
Source URL: https://wiki.siminnovations.com/index.php?title=Msfs_connected
Revision: 5229
---

# Msfs connected

## Signature

```
connected = msfs_connected()
```

## Description

msfs_connected is used to check if there is an active connected with FS2020 or FS2024.

## Return value

connected

## Examples

### Example

```lua
if msfs_connected() then
  print("Good heavens, we are connected to FS2020/FS2024!")
end
```
