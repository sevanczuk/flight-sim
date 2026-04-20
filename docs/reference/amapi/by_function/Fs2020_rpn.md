---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: fs2020_rpn
Namespace: Fs2020
Source URL: https://wiki.siminnovations.com/index.php?title=Fs2020_rpn
Revision: 4805
---

# Fs2020 rpn

## Signature

```
fs2020_rpn(rpn_script, callback)
```

## Description

fs2020_rpn is used to execute a RPN script within FS2020. You can find more information about RPN scripts [here](https://docs.flightsimulator.com/html/Additional_Information/Reverse_Polish_Notation.htm).

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `rpn_script` | String | The RPN script to execute within FS2020. |
| 2 | `callback` | Function | (Optional) Return value from the executed RPN script. Three arguments are given, first is integer, second is float and third is string. Note that these arguments are nil when script could not be executed. Make sure to nil check in your callback. |

## Examples

### Example

```lua
-- Get OBS value
fs2020_rpn("(A:NAV1 OBS, degrees)", function(value_int, value_float, value_string)
  if value_int ~= nil then
    print("OBS value = " .. value_int)
  else
    print("Could not execute script")
  end
end)

-- Execute event
fs2020_rpn("(>K:TOGGLE_ICS)")
```

## External references

- [here](https://docs.flightsimulator.com/html/Additional_Information/Reverse_Polish_Notation.htm)
