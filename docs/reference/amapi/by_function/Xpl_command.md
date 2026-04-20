---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: xpl_command
Namespace: Xpl
Source URL: https://wiki.siminnovations.com/index.php?title=Xpl_command
Revision: 4755
---

# Xpl command

## Signature

```
xpl_command(commandref)
```

## Description

xpl_command is used to send a command to X-Plane X-Plane uses commandrefs, these may be used to send commands to X-Plane. You can find the list of available commands [here](http://siminnovations.com/xplane/command/index.php).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `commandref` | String | Reference to a command from X-Plane (see here) |
| 2 | `value` | Number | Optional field. From AM/AP 4.1, you can set this argument to "BEGIN", "ONCE" or "END" command. Older versions can use provide 1 for a BEGIN command, or 0 for an END command. |

## Examples

### Example

```lua
-- Shut down X-plane
xpl_command("sim/operation/quit")
```

### Example

```lua
-- Only use the begin and end commands when necessary
function button_pressed()
  -- Engage starter motor
  xpl_command("sim/engines/engage_starters", "BEGIN")
end

function button_released()
  -- Disengage starter motor
  xpl_command("sim/engines/engage_starters", "END")
end
```

## External references

- [here](http://siminnovations.com/xplane/command/index.php)
