---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: log
Namespace: unprefixed
Source URL: https://wiki.siminnovations.com/index.php?title=Log
Revision: 3667
---

# Log

## Signature

```
value = log(message, ...) value = log(type, message, ...)
```

## Description

log is used to write a message to the Air Manager or Air Player log file

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `type` | String | (Optional) Can be "INFO", "WARN" or "ERROR". Default is set to be an info message. |
| 2 .. n | `type` | Object | The message to put in the log |

## Examples

### Example

```lua
-- Send message "Hello world" as an info message
log("Hello world")

-- Send error message "Hello world" as an error message
log("ERROR", "Hello world")

-- Send two error messages
log("ERROR", "Hello world", "Goodbye world")
```
