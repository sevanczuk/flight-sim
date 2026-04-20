---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: static_data_load
Namespace: Static
Source URL: https://wiki.siminnovations.com/index.php?title=Static_data_load
Revision: 5874
---

# Static data load

## Signature

```
data = static_data_load(path) data = static_data_load(path, options) (from AM/AP 3.6 or later) static_data_load(path, callback) static_data_load(path, options, callback) (from AM/AP 3.6 or later)
```

## Description

static_data_load is used to get load static data from a JSON, CSV or text file located in the resources folder.

## Return value

data

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `path` | String | The location of the static file inside the resources folder (*.csv, *.json or *.txt). |
| 2 | `options` | String | (Options) Extra options. See the table below for available options. |
| 3 | `callback` | Function | (Optional) Function is called when data has been loaded. Data argument contains the data, is nil on error. The file will be read synchronously when the callback function is not provided. |

## Examples

### Example (JSON)

```json
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 27,
  "address": {
    "streetAddress": "21 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": "10021-3100"
  },
  "phoneNumbers": [
    "212 555-1234",
    "646 555-4567",
    "123 456-7890"
  ]
}
```

### Example (JSON)

```lua
-- person.json is location in the resources folder
data = static_data_load("person.json")

if data ~= nil then
  -- Print first name
  print(data["firstName"])

  -- Print street address
  print(data["address"]["streetAddress"])

  -- Print all phone numbers
  for key,value in pairs(data["phoneNumbers"]) do
    print(value)
  end
end
```

### Example (JSON)

```lua
-- person.json is location in the resources folder
static_data_load("person.json", function(data)
  -- Print first name
  print(data["firstName"])

  -- Print street address
  print(data["address"]["streetAddress"])
  
  -- Print all phone numbers
  for key,value in pairs(data["phoneNumbers"]) do
    print(value)
  end
end)
```

### Example (CSV)

```lua
-- cars.csv is location in the resources folder
data = static_data_load("cars.csv", "csv_header=true")

if data ~= nil then
  -- Print all cars
  for key,value in pairs(data) do
    print(value["Make"] .. " " .. value["Model"] .. " " .. value["Description"] .. " from " .. value["Year"] .. ", now only for " .. value["Price"] .. "!")
  end
end
```

### Example (CSV)

```lua
-- cars.csv is location in the resources folder
static_data_load("cars.csv", function(data)
  -- Print all cars
  for key,value in pairs(data) do
    print(value["Make"] .. " " .. value["Model"] .. " " .. value["Description"] .. " from " .. value["Year"] .. ", now only for " .. value["Price"] .. "!")
  end
end)
```

### Example (Text)

```lua
-- cars.txt is location in the resources folder
data = static_data_load("cars.txt")

if data ~= nil then
  -- Print all cars
  for key, value in pairs(data) do
    print("line " .. key .. " has car: " .. value)
  end
end
```

### Example (Text)

```lua
-- cars.txt is location in the resources folder
static_data_load("cars.txt", function(data)
  -- Print all cars
  for key, value in pairs(data) do
    print("line " .. key .. " has car: " .. value)
  end
end)
```
