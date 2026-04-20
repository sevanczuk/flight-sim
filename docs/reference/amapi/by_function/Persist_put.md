---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: persist_put
Namespace: Persist
Source URL: https://wiki.siminnovations.com/index.php?title=Persist_put
Revision: 78
---

# Persist put

## Signature

```
persist_put(persist_id, value)
```

## Description

persist_put is used to put new data into a persistence object.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `persist_id` | Number | Persist_id is the reference to a certain persistence object. It is received from the persist_add function. |
| 2 | `value` | Object | The value that should be written to the persistence object. |

## Examples

### Example

```lua
-- Create a new persistence obeject
persist_id = persist_add("mykey", "INT[8]", { 1, 2, 3, 4, 5, 6, 7, 8 })

-- Put new data into the persistence object
persist_put(persist_id, { 8, 7, 6, 5, 4, 3, 2, 1 } )
```
