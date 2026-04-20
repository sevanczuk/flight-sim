---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fs2024_connected
Namespace: Fs2024
Source URL: https://wiki.siminnovations.com/index.php?title=Fs2024_connected
Revision: 5211
---

# Fs2024 connected

## Signature

```
connected = fs2024_connected()
```

## Description

fs2024_connected is used to check if there is an active connected with FS2024.

## Return value

connected

## Examples

### Example

```lua
if fs2024_connected() then
  print("Crikey! We are connected to FS2024!")
end
```
