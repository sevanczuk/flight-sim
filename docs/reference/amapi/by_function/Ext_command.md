---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: ext_command
Namespace: Ext
Source URL: https://wiki.siminnovations.com/index.php?title=Ext_command
Revision: 380
---

# Ext command

## Signature

```
ext_event(source_tag,event,value)
```

## Description

ext_event is used to send a command to an external source.External source can be used to connect Air Manager to other third party programs. This function is only supported in the Professional version of Air Manager.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `source_tag` | String | The data source tag. The source tag can be configured in the settings part of Air Manager. |
| 2 | `event` | String | Command name in the external source |
| 3 | `value` | Number | (Optional) Send a value with the command. Some commands support setting a value. |

## Examples

### Example (single variable)

```lua
-- Send command to "my_event" on data source "my_source"
ext_command("my_source","my_event")
```
