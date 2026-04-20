---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: hw_button_array_add
Namespace: Hw
Source URL: https://wiki.siminnovations.com/index.php?title=Hw_button_array_add
Revision: 4106
---

# Hw button array add

## Signature

```
hw_button_array_id = hw_button_array_add(name, nr_rows, nr_columns, pressed_callback, released_callback) (from AM/AP 3.5) hw_button_array_id = hw_button_array_add(nr_rows, nr_columns, hw_id_0, hw_id_1, ..., pressed_callback, released_callback)
```

## Description

hw_button_array_add is used to add a hardware button array to your instrument. A button array is a way to connect a lot of buttons to your project with a reduces required pin count. Normally, every button would need a separate pin. With the button array, you can decrease the number of pins needed by arranging the buttons into a grid (see schematic below). The grid has two different types of pins, rows and columns. Rows are set as an output and will be actively driven. Columns are set as input and are read to see if a button changed state.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | A functional name to define the button array. |
| 2 | `nr_rows` | Number | Number of rows. 8 is the maximum for the Arduino. |
| 3 | `nr_columns` | Number | Number of columns. 8 is the maximum for the Arduino. |
| 4 | `pressed_callback` | Function | This function will be called when a button is pressed. |
| 5 | `released_callback` | Function | (Optional) This function will be called when a button is released. |
