---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: nav_get_radius
Namespace: Nav
Source URL: https://wiki.siminnovations.com/index.php?title=Nav_get_radius
Revision: 4233
---

# Nav get radius

## Signature

```
nav_items = nav_get_radius(nav_type, lat, lon, distance) (up to AM/AP 3.7) nav_get_radius(nav_type, lat, lon, distance, max_entries, callback) (from AM/AP 4.0) nav_get_radius(nav_type, lat, lon, distance, max_entries, timeout, callback) (from AM/AP 4.0)
```

## Description

nav_get_radius can be used to get the NAV points, within a radius around a given latitude and longitude.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `nav_type` | String | The NAV type to query, click here to see the NAV types page for all available types. |
| 2 | `latitude` | Number | The latitude to search from |
| 3 | `longitude` | Number | The longitude to search from |
| 4 | `distance` | Number | The radius in which to search for the NAV points. (in nautical miles, nm) |
| 5 | `max_entries` | Integer | Limit the number of returned NAV points. |
| 6 | `timeout` | Number | (Optional) Wait timeout in seconds. If data is not available within the timeout, the callback will be called without data. Default 1 second. |
| 7 | `callback` | Function | Callback function when data is fetched. This function is also called on error or timeout. |

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

-- Find the Airports within 20 nautical miles from a certain latitude and longitude
nav_get_radius("AIRPORT", 52.222484, 5.483563, 20, 200, data_callback)
```
