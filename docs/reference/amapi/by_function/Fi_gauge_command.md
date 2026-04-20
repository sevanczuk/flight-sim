---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fi_gauge_command
Namespace: Fi
Source URL: https://wiki.siminnovations.com/index.php?title=Fi_gauge_command
Revision: 4511
---

# Fi gauge command

## Signature

```
fi_gauge_command(fi_gauge_id, command_name)
```

## Description

fi_gauge_command is used to send a command for a Flight Illusion gauge. Available properties depend on the gauge type. See [Flight Illusion Gauges](./Flight_Illusion_Gauges.md) [missing] for available commands.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `fi_gauge_id` | String | Reference to the Flight Illusion gauge. |
| 2 | `command_name` | String | Command name which need to be set. See Flight Illusion Gauges for available commands. |

## Examples

### Example

```lua
-- Gauge type is a single needle
fi_gauge = fi_gauge_add(12, "BENDIX_KING_AUTOPILOT")

-- Turn off autopilot
fi_gauge_command(fi_gauge, "AUTOPILOT_OFF")
```
