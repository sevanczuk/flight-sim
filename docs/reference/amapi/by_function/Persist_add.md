---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: persist_add
Namespace: Persist
Source URL: https://wiki.siminnovations.com/index.php?title=Persist_add
Revision: 5914
---

# Persist add

## Signature

```
persist_id = persist_add(key, initial_value)
```

## Description

persist_add is used to create a new persistence object. Data provided to a persistence object will remain between sessions.

## Return value

persist_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `key` | String | Unique identifier key to be able to keep different persistence objects separated. |
| 2 | `initial_value` | Object | The initial value of the persistence object. This value will be used when no data is yet available. This argument is optional, when not used, the data is typically initialized with all zero's. |

## Examples

### Example

```lua
-- Create a new persistence obeject
persist_id = persist_add("mykey", { 1, 2, 3, 4, 5, 6, 7, 8 })

-- Get the data from the persistence object
mydata = persist_get(persist_id)

-- Put new data into the persistence object
persist_put(persist_id, { 8, 7, 6, 5, 4, 3, 2, 1 } )
```
