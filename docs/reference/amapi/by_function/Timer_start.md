---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: timer_start
Namespace: Timer
Source URL: https://wiki.siminnovations.com/index.php?title=Timer_start
Revision: 4320
---

# Timer start

## Signature

```
timer_id = timer_start(delay) (from AM/AP 4.1) timer_id = timer_start(delay, callback) (from AM/AP 3.5) timer_id = timer_start(delay, period, callback) timer_id = timer_start(delay, period, nr_calls, callback) (from AM/AP 3.5)
```

## Description

timer_start is used to start a timer, which will call a function at an configurable interval.

## Return value

timer_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `delay` | Number | Initial delay in milliseconds. After calling timer_start, the callback function will be executed after this delay. |
| 2 | `period` | Number | (Optional) Time between two function calls, in milliseconds. Providing it with 'nil' will make the function only get called once. |
| 3 | `nr_calls` | Number | (Optional) Number of callbacks. |
| 4 | `callback` | Number | (Optional, from AM/AP 4.1) This function will be called at every interval. Two arguments will be provided, the count and max (can be -1 if running infinitely). |

## Examples

### Example (one shot)

```lua
-- This function will be called once after one second
function timer_callback()
    print("Timer callback")
end

timer_start(1000, timer_callback)
```

### Example (interval)

```lua
-- This function will be called every second
function timer_callback(count)
    print("Timer callback " .. count)
end

timer_start(0, 1000, timer_callback)
```

### Example (limited call count)

```lua
-- This function will be called 5 times, once every second
function timer_callback(count, max)
    print("Timer callback " .. count .. " of " .. max)
end

timer_start(0, 1000, 5, timer_callback)
```
