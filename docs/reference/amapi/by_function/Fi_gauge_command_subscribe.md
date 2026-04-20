---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fi_gauge_command_subscribe
Namespace: Fi
Source URL: https://wiki.siminnovations.com/index.php?title=Fi_gauge_command_subscribe
Revision: 3463
---

# Fi gauge command subscribe

## Signature

```
fi_gauge_command_subscribe(fi_gauge_id, command_name, callback_function)
```

## Description

fi_gauge_command_subscribe is used to subscribe to a Flight Illusion gauge command. See [Flight Illusion Gauges](./Flight_Illusion_Gauges.md) [missing] for available commands.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `fi_gauge_id` | String | Reference to the flight illusion gauge. |
| 2 | `comand_name` | String | Name of the command. See Flight Illusion Gauges for available commands. |
| 3 | `callback_function` | Function | The function to call when the command is fired. |

## Examples

### Example

```lua
-- Get a reference to the gauge
fi_gauge_id = fi_gauge_add(122, "BENDIX_KING_TRANSPONDER")

-- Subscribe to the IDF_PRESSED command
fi_gauge_command_subscribe(fi_gauge_id, "IDF_PRESSED", function()
    print("IDF pressed")
end)
```
