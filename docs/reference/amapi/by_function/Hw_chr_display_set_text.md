---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_chr_display_set_text
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_chr_display_set_text
Revision: 3405
---

# Hw chr display set text

## Signature

```
hw_chr_display_set_text(hw_chr_display_id, text) hw_chr_display_set_text(hw_chr_display_id, line, text) hw_chr_display_set_text(hw_chr_display_id, display, line, text)
```

## Description

hw_chr_display_set_text is used to set the text on a Hardware character display.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_chr_display_id` | Object | This is the reference to the character display output. You can get this reference from the hw_chr_display_add function. |
| 2 | `display` | Number | (Optional) The display where you wish to show the text. This only works with character display types that can be daisy chained. First display is 0. |
| 3 | `line` | Number | (Optional) The line where you wish to put the text. First line is 0. |
| 4 | `text` | String | The text. |

## Examples

### Example

```lua
-- Bind to the Arduino MEGA 2560 on channel A.
-- hw_id 1 = MAX7219 DIN (ARDUINO_MEGA2560_A_D4 in this example)
-- hw_id 2 = MAX7219 CLK (ARDUINO_MEGA2560_A_D5 in this example)
-- hw_id 3 = MAX7219 CS  (ARDUINO_MEGA2560_A_D6 in this example)
display_chr_id = hw_chr_display_add("MAX7219", 1, "ARDUINO_MEGA2560_A_D4", "ARDUINO_MEGA2560_A_D5", "ARDUINO_MEGA2560_A_D6")

-- Set text "12345" on display 0 (first), line 0
hw_chr_display_set_text(display_chr_id, 0, 0, "12345")
```
