---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: remove
Namespace: unprefixed
Source URL: https://wiki.siminnovations.com/index.php?title=Remove
Revision: 2850
---

# Remove

## Signature

```
remove(node_id)
```

## Description

remove is used to remove a node object. The object will be removed from the system. You cannot access the node_id anymore after the remove function has been called!

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `node_id` | ID | Node identifier. This number can be obtained by calling functions like img_add, txt_add or canvas_add. |

## Examples

### Example

```lua
-- Load and display text and images
myimage1 = img_add_fullscreen("myimage1.png")

-- And remove it again...
remove(myimage1)

-- Make sure to NEVER access the myimage1 anymore at this point!
```
