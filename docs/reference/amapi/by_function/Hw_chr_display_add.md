---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_chr_display_add
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_chr_display_add
Revision: 5809
---

# Hw chr display add

## Signature

```
hw_chr_display_id = hw_chr_display_add(name, type, ...) (from AM/AP 3.5) hw_chr_display_id = hw_chr_display_add(type, ...)
```

## Description

hw_chr_display_add is used to add a Hardware character display. Right now the MAX7219, HD44780, TM1637 and TM1638 based character boards are supported, and the control of 8-segment modules.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | A functional name to define the character display. |
| 2 | `type` | String | Type of characer display. Can be "MAX7219", "8SEGMENT", "HD44780", "TM1637", or "TM1638". |
| ... | `...` | ... | Depends on type of character display chosen. See below for possible modes. |
