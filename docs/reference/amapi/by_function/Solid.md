---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: solid
Namespace: unprefixed
Source URL: https://wiki.siminnovations.com/index.php?title=Solid
Revision: 5886
---

# Solid

## Signature

```
_solid()
```

## Description

_solid is used to mark that the shape we are going to define afterwards is a solid shape.

## Return value

This function won't return any value.

## Examples

### Example

```lua
canvas_id = canvas_add(0, 0, 200, 200, function()
  -- Create a triangle
  _triangle(100, 0, 0, 200, 200, 200)
  
  -- Shape afterwards will be a hole
  _hole()
  
  -- Punch a hole right in the middle of the triangle
  _circle(100, 140, 50)
  
  -- Draw the complete shape
  _fill("red")
  
  -- Move back to solid shapes again
  _solid()
  
  -- Draw a second shape
  _rect(0, 0, 50, 50)
  _fill("blue")
end)
```
