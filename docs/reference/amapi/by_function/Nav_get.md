---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: nav_get
Namespace: Nav
Source URL: https://wiki.siminnovations.com/index.php?title=Nav_get
Revision: 4264
---

# Nav get

## Signature

```
nav_item = nav_get(nav_type, nav_property, value) (up to AM/AP 3.7) nav_get(nav_type, nav_property, value, callback) (from AM/AP 4.0) nav_get(nav_type, nav_property, value, timeout, callback) (from AM/AP 4.0)
```

## Description

nav_get can be used to get NAV information from one of its NAV properties. This way AIRP, VOR, NDB and FIX navigation points can be queried.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `nav_type` | String | The NAV type to query, click here to see the NAV types page for all available types. |
| 2 | `property_type` | String | The property type to search for, see the NAV types list below. |
| 3 | `value` | String | The value of the NAV item to search for. |
| 4 | `timeout` | Number | (Optional) Wait timeout in seconds. If data is not available within the timeout, the callback will be called without data. Default 1 second. |
| 5 | `callback` | Function | Callback function when data is fetched. This function is also called on error or timeout. |

## Examples

### Example

```lua
local function data_callback(airports)
  if airports ~= nil then
    -- Print the found airports to log
    for i=1, #airports do
      print("ID:" .. airports[i]["ID"] .. " name:" .. airports[i]["NAME"] .. " lon:" .. airports[i]["LONGITUDE"] .. " lat:" .. airports[i]["LATITUDE"])
    end
  else
    print("Error while querying nav data")
  end
end

-- We are looking for ENTO airport
nav_get("AIRPORT", "ICAO", "ENTO", data_callback)
```
