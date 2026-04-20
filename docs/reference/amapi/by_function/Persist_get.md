---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: persist_get
Namespace: Persist
Source URL: https://wiki.siminnovations.com/index.php?title=Persist_get
Revision: 79
---

# Persist get

## Signature

```
value = persist_get(persist_id)
```

## Description

persist_get(persist_id) is used to get data from a persistence object.

## Return value

value

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `persist_id` | Number | Persist_id is the reference to a certain persistence object. It is received from the persist_add function. |

## Examples

### Example

```lua
-- Create a new persistence obeject
persist_id = persist_add("mykey", "INT[8]", { 1, 2, 3, 4, 5, 6, 7, 8 })

-- Get the data from the persistence object
mydata = persist_get(persist_id)
```
