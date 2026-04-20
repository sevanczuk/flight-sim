---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: var_format
Namespace: Var
Source URL: https://wiki.siminnovations.com/index.php?title=Var_format
Revision: 86
---

# Var format

## Signature

```
value = var_format(value,decimals)
```

## Description

var_format is used to round a number to a certain number of decimals and always shows that selected amount of decimals.

## Return value

value

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `value` | Number | The is the value that needs to be rounded. |
| 2 | `decimals` | Number | The number of decimals the value should get. |

## Examples

### Example

```lua
-- Returns 1
myvalue = var_format(1.2, 0)

-- Returns 1.2
myvalue = var_format(1.2, 1)

-- Returns 1.20
myvalue = var_format(1.2, 2)

-- Returns 1.230
myvalue = var_format(1.23, 3)

-- Returns 1.2 (note that var_round rounds to the nearest value)
myvalue = var_format(1.16789, 1)
```
