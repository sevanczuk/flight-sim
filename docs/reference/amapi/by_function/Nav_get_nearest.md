---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: nav_get_nearest
Namespace: Nav
Source URL: https://wiki.siminnovations.com/index.php?title=Nav_get_nearest
Revision: 4229
---

# Nav get nearest

## Signature

```
nav_items = nav_get_nearest(nav_type, latitude, longitude, max_entries) (up to AM/AP 3.7) nav_get_nearest(nav_type, latitude, longitude, max_entries, callback) (from AM/AP 4.0) nav_get_nearest(nav_type, latitude, longitude, max_entries, timeout, callback) (from AM/AP 4.0)
```

## Description

nav_get_nearest can be used to get the nearest NAV points, based on a given latitude and longitude.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `nav_type` | String | The NAV type to query, click here to see the NAV types page for all available types. |
| 2 | `latitude` | Number | The latitude to search from |
| 3 | `longitude` | Number | The longitude to search from |
| 4 | `max_entries` | Integer | Limit the number of returned NAV points. |
| 5 | `timeout` | Number | (Optional) Wait timeout in seconds. If data is not available within the timeout, the callback will be called without data. Default 1 second. |
| 6 | `callback` | Function | Callback function when data is fetched. This function is also called on error or timeout. |

## Examples

### Example

```lua
local function data_callback(airports)
  if airports ~= nil then
    -- Print the found airports to log
    for i=1, #airports do
      print("ID=" .. airports[i]["ID"] .. " name:" .. airports[i]["NAME"] .. " lon:" .. airports[i]["LONGITUDE"] .. " lat:" .. airports[i]["LATITUDE"])
    end
  else
    print("Error while querying nav data")
  end
end

-- Find the nearest 10 Airports from a certain latitude and longitude
nav_get_nearest("AIRPORT", 52.222484, 5.483563, 10, data_callback)
```
