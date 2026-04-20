---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: shut_down
Namespace: Shut
Source URL: https://wiki.siminnovations.com/index.php?title=Shut_down
Revision: 1938
---

# Shut down

## Signature

```
value = shut_down(type)
```

## Description

shut_down is used to shut down the application (Air Manager or Air Player) or the system where the instrument runs on

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `type` | String | "APPLICATION" if you want to shut down Air Manager or Air Player, or "SYSTEM" if you want to shutdown the system (windows, Raspberry Pi etc.) |

## Examples

### Example

```lua
-- Shut down Windows or the Raspberry Pi
shut_down("SYSTEM")
```
