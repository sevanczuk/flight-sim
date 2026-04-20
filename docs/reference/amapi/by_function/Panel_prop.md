---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: panel_prop
Namespace: Panel
Source URL: https://wiki.siminnovations.com/index.php?title=Panel_prop
Revision: 3082
---

# Panel prop

## Signature

```
value = panel_prop(property)
```

## Description

panel_prop is used to get the settings from the current panel.

## Return value

value

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `property` | String | The type of property to fetch. See table below for the options |

## Examples

### Example

```lua
-- Print the panel author
print( panel_prop("AUTHOR") )

-- See if we started from the create/edit tab
if panel_prop("DEVELOPMENT") then
  print("We are running in development mode!")
end
```
