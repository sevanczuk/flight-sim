---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fs2020_connected
Namespace: Fs2020
Source URL: https://wiki.siminnovations.com/index.php?title=Fs2020_connected
Revision: 4765
---

# Fs2020 connected

## Signature

```
connected = fs2020_connected()
```

## Description

fs2020_connected is used to check if there is an active connected with FS2020.

## Return value

connected

## Examples

### Example

```lua
if fs2020_connected() then
  print("Good heavens, we are connected to FS2020!")
end
```
