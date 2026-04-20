---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: request_callback
Namespace: Request
Source URL: https://wiki.siminnovations.com/index.php?title=Request_callback
Revision: 4760
---

# Request callback

## Signature

```
request_callback(callback_function)
```

## Description

request_callback is used to force a callback on a given data subscription (X-Plane, FSX, FS2, FS2020, IIC or external sources)

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `function_callback` | String | The callback function that should be updated |

## Examples

### Example

```lua
-- This function will be called when new data is available from X-Plane
  function new_altitude_callback(altitude)
    print("New altitude: " .. altitude)
  end

  -- Subscribe X-Plane datarefs
  xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/altitude_ft_pilot", "FLOAT", new_altitude_callback)

  -- Force a callback. The 'new_altitude_callback' function will be called here with its current arguments.
  request_callback(new_altitude_callback)
```
