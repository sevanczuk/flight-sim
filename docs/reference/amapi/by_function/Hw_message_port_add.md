---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_message_port_add
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_message_port_add
Revision: 2787
---

# Hw message port add

## Signature

```
hw_message_port_id = hw_message_port_add(name, message_callback) (from AM/AP 3.5) hw_message_port_id = hw_message_port_add(hw_id, message_callback)
```

## Description

hw_message_port_add is used to add a connection between your instrument and a custom Arduino program. It makes it possible to send messages between the instrument and the Arduino.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | A functional name to define the message port. |
| 2 | `message_callback` | Function | This function will be called when a message is received from the Arduino. |
