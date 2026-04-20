---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: resource_info
Namespace: Resource
Source URL: https://wiki.siminnovations.com/index.php?title=Resource_info
Revision: 3909
---

# Resource info

## Signature

```
meta_data = resource_info(filename)
```

## Description

resource_info can be used to get information of a resource file. This can also be used to check if a resource exists.

## Return value

meta_data

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `filename` | String | The file name of the resource. Including it's extension. |

## Examples

### Example

```lua
-- We are looking for more information about the bla.png image
resource_meta = resource_info("bla.png")

-- Check if the image could be found
if resource_meta == nil then
  print("bla.png not found!")
elseif resource_meta["TYPE"] == "IMAGE" then
  print("bla.png is an image and has w=" .. resource_meta["WIDTH"] .. " h=" .. resource_meta["HEIGHT"])
else
  print("bla.png is not an image!")
end
```
