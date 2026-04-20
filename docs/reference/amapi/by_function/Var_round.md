---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: var_round
Namespace: Var
Source URL: https://wiki.siminnovations.com/index.php?title=Var_round
Revision: 85
---

# Var round

## Signature

```
value = var_round(value,decimals)
```

## Description

var_round is used to round a number to a certain number of decimals

## Return value

value

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `value` | Number | The is the value that needs to be rounded |
| 2 | `decimals` | Number | The number of decimals the value should get. |

## Examples

### Example

```lua
-- Returns 1
myvalue = var_round(1.12345,0)

-- Returns 1.1
myvalue = var_round(1.12345,1)

-- Returns 1.12
myvalue = var_round(1.12345,2)

-- Returns 1.2 (note that var_round rounds to the nearest value)
myvalue = var_round(1.16789,1)

-- Returns 1.16789
myvalue = var_round(1.16789,100)
```
