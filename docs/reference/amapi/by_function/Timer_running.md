---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: timer_running
Namespace: Timer
Source URL: https://wiki.siminnovations.com/index.php?title=Timer_running
Revision: 359
---

# Timer running

## Signature

```
running = timer_running(timer_id)
```

## Description

timer_running is used to check if the timer is currently running.

## Return value

running

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `timer_id` | Number | Timer_id received from the timer_start function. |

## Examples

### Example

```lua
-- Start a timer
timer_id = timer_start(0,1000,nil)

-- Check if the timer is running
if timer_running(timer_id) then
  print("The timer is running!")
else
  print("The timer is not running...")
end
```
