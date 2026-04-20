---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: txt_style
Namespace: Txt
Source URL: https://wiki.siminnovations.com/index.php?title=Txt_style
Revision: 2799
---

# Txt style

## Signature

```
txt_style(txt_id,style)
```

## Description

txt_style is used to change the style of a text box.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `txt_id` | Number | Text identifier. This number can be obtained by calling txt_add. |
| 2 | `style` | String | The new style to apply. See txt_add for styling options. |

## Examples

### Example

```lua
-- Load and display text and images
mytext1 = txt_add("1013", "size: 40;", 420, 252, 60, 40)

-- Make it even bigger!
txt_style(mytext1 , "size: 60;")
```
