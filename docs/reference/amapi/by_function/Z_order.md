---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: z_order
Namespace: Z
Source URL: https://wiki.siminnovations.com/index.php?title=Z_order
Revision: 2826
---

# Z order

## Signature

```
z_order(node_id, order)
```

## Description

z_order is used to move an instrument or layer node to another Z order. This can make it be drawn in the front or back of other nodes.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `node_id` | ID | Node identifier. This can be obtained from the instrument_get or layer_add function. |
| 2 | `order` | Number | The order. Lowest value is drawn at the back, highest is drawn on the top. The panel root lua is always drawn at order 0. |

## Examples

### Example

```lua
id = instrument_get("fd2f89a1-59ec-416f-8f28-e5b8bf4c1cbc")

if id ~= nil then
  -- Bring the instrument to the front
  z_order(id, 99)
else
  print("Could not find instrument")
end
```
