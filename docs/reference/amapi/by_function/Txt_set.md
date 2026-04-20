---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: txt_set
Namespace: Txt
Source URL: https://wiki.siminnovations.com/index.php?title=Txt_set
Revision: 113
---

# Txt set

## Signature

```
txt_set(txt_id, text)
```

## Description

txt_set is used change the text on a txt_id.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `txt_id` | Number | Reference to a txt object |
| 2 | `txt` | String | This is the txt being shown |

## Examples

### Example

```lua
-- Load and display text and images
mytext1 = txt_add("hello world", "", 0, 0, 800, 200)

-- rename text
txt_set(mytext1, "goodbye world")
```
