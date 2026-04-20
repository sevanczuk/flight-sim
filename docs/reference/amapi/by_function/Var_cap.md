---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: var_cap
Namespace: Var
Source URL: https://wiki.siminnovations.com/index.php?title=Var_cap
Revision: 84
---

# Var cap

## Signature

```
value = var_cap(value,min,max)
```

## Description

var_cap is used to limit a value to a given minimum and maximum value.

## Return value

value

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `value` | Number | The is the value that needs to be limited to the min and max value. |
| 2 | `min` | Number | The minimum value to limit to. |
| 3 | `max` | Number | The maximum value to limit to. |

## Examples

### Example

```lua
-- Returns 15
myvalue = var_cap(15,10,20)

-- Returns 10
myvalue = var_cap(9,10,20)

-- Returns 20
myvalue = var_cap(21,10,20)
```
