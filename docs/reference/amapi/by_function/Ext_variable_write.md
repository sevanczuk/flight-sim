---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: ext_variable_write
Namespace: Ext
Source URL: https://wiki.siminnovations.com/index.php?title=Ext_variable_write
Revision: 378
---

# Ext variable write

## Signature

```
ext_variable_write(source_tag,variable, unit, value)
```

## Description

ext_variable_write is used to write a variable on an external source variables. External source can be used to connect Air Manager to other third party programs. This function is only supported in the Professional version of Air Manager

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `source_tag` | String | The data source tag. The source tag can be configured in the settings part of Air Manager. |
| 2 | `variable` | String | Reference to a variable on the external source. |
| 3 | `type` | String | Data type of the variable, can be INT, FLOAT, DOUBLE, INT[n], FLOAT[n], DOUBLE[n] or BYTE[n] |
| 4 | `value` | Number | The value to be written |

## Examples

### Examples

```lua
-- Write 100 to variable my_variable", using the "my_data_source" data source
ext_variable_write("my_data_source", "my_variable", "INT", 100)
```
