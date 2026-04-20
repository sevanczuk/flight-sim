---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: si_command
Namespace: Si
Source URL: https://wiki.siminnovations.com/index.php?title=Si_command
Revision: 3549
---

# Si command

## Signature

```
si_command(command_name) si_command(command_name, type)
```

## Description

si_command is used to send a global command. Global commands can be used to communicate between instruments.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `command_name` | String | Reference to a global command |
| 2 | `type` | String | (Optional) Can be "BEGIN", "ONCE" or "END". |

## Examples

### Example (single variable)

```lua
-- Let another instrument know that the master dial has turned up
si_command("MASTER_DIAL_UP")
```
