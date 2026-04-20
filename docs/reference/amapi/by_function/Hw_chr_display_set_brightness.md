---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_chr_display_set_brightness
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_chr_display_set_brightness
Revision: 4364
---

# Hw chr display set brightness

## Signature

```
hw_chr_display_set_brightness(hw_chr_display_id, brightness) (from AM/AP 4.1) hw_chr_display_set_brightness(hw_chr_display_id, display, brightness)
```

## Description

hw_chr_display_set_brightness is used to set the brightness of a Hardware character display.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `hw_chr_display_id` | Object | This is the reference to the character display output. You can get this reference from the hw_chr_display_add function. |
| 2 | `display` | Number | (Optional) The display where you wish to put the text. This only works with character display types that can be daisy chained. First display is 0. |
| 3 | `brightness` | Number | The brightness. Ranges from 0.0 (Off) to 1.0 (Full brightness). |

## Examples

### Example (MAX7219)

```lua
-- Create MAX7219 based character display
display_chr_id = hw_chr_display_add("MAX7219", 1, "ARDUINO_MEGA2560_A_D4", "ARDUINO_MEGA2560_A_D5", "ARDUINO_MEGA2560_A_D6")

-- Set brightness of the first display to 50%
hw_chr_display_set_brightness(display_chr_id, 0, 0.5)
```

### Example (TM1638)

```lua
-- Create TM1638 based character display
display_chr_id = hw_chr_display_add("TM1638", 8, "ARDUINO_MEGA2560_A_D4", "ARDUINO_MEGA2560_A_D5", "ARDUINO_MEGA2560_A_D6")

-- Set brightness to 50%
hw_chr_display_set_brightness(display_chr_id, 0.5)
```
