---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: timer_stop
Namespace: Timer
Source URL: https://wiki.siminnovations.com/index.php?title=Timer_stop
Revision: 4474
---

# Timer stop

## Signature

```
timer_stop(timer_id)
```

## Description

timer_stop is used to stop a previously started timer.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `timer_id` | Number | Timer_id received from the timer_start function. |

## Examples

### Example

```lua
myimage1 = img_add_fullscreen("myimage.png")
 
local rotation = 0
 
-- This function will be called every second
function timer_callback()
    rotate(myimage1,rotation)
 
    rotation = rotation + 1
end
 
mytimer1 = timer_start(0,1000,timer_callback)

-- Stop the timer right away
timer_stop(mytimer1)
```
