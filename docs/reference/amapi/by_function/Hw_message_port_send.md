---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_message_port_send
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_message_port_send
Revision: 4663
---

# Hw message port send

## Signature

```
hw_message_port_send(hw_message_port_id, message_id, payload_type, payload)
```

## Description

hw_message_port_send is used to send a message to an external MessagePort application, typically an Arduino program.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_message_port_id` | String | The is the reference to the Message port. You can get this reference from the hw_message_port_add function. |
| 2 | `message_id` | Integer | The message identifier, this can be an integer ranging from 0 to 65535 (16 bit unsigned int). |
| 3 | `payload_type` | String | Payload type. Can be "INT", "FLOAT", "BYTE" or "STRING". |
| 4 | `payload` | Integer[] | Send additional bytes with your message (0-8 bytes) |

## Examples

### Example

```lua
-- This function will be called when a message is received from the Arduino.
function new_message(id, payload)
  print("received new message with id " .. id)
end

id = hw_message_port_add("ARDUINO_MEGA2560_A", new_message)

-- You can also send messages to the Arduino
-- In this case a message with id 777 with 3 bytes (0x01, 0x02, 0x03)
hw_message_port_send(id, 777, "BYTE", { 1, 2, 3 } )

-- String example
hw_message_port_send(id, 777, "STRING", "hello")

-- Integer example
hw_message_port_send(id, 777, "INT", -450)

-- Float example
hw_message_port_send(id, 777, "FLOAT", { 1.2, 2.3} )
```
