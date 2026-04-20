---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: switch_add
Namespace: Switch
Source URL: https://wiki.siminnovations.com/index.php?title=Switch_add
Revision: 5333
---

# Switch add

## Signature

```
switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height) (from AM/AP 5.0) switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height, position_callback) switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height, position_callback, pressed_callback) switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height, position_callback, pressed_callback, released_callback) switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height, mode) (from AM/AP 5.0) switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height, mode, position_callback) (from AM/AP 4.0) switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height, mode, position_callback, pressed_callback) (from AM/AP 4.0) switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height, mode, position_callback, pressed_callback, released_callback) (from AM/AP 4.0)
```

## Description

switch_add is used to add a switch on the specified location. The switch is also stored in memory for further references.

## Return value

switch_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `img_pos_0` | String | The image for the first position. Note that this is both filename and extension. Its good practice to always use PNG format for images. JPG and BMP are also supported, but not recommended. |
| 2 | `img_pos_1` | String | The image for the second position |
| n | `img_pos_n` | String | The image for all other positions you might need. This is limitless |
| n+1 | `x` | Number | This is the most left point of the canvas where your switch should be shown. |
| n+2 | `y` | Number | This is the most top point of the canvas where your switch should be shown. |
| n+3 | `width` | Number | The switch width on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the switch. |
| n+4 | `height` | Number | The switch height on the canvas. Note that the software won't preserve the aspect ratio. Scaling will be done, both stretching and cropping of the switch. |
| n+5 | `mode` | String | (Optional) The Switch mode. Can be 'CIRCULAIR', 'PRESS', 'HORIZONTAL' or 'VERTICAL'. |
| n+6 | `position_callback` | Function | (Optional from AM/AP 5.0) This function will be called when the switch changed position. |
| n+7 | `pressed_callback` | Function | (Optional) This function will be called when the switch is being pressed. |
| n+8 | `released_callback` | Function | (Optional) This function will be called when the switch is being released. |

## Examples

### Example 1 (X-plane determines switch position, recommended!)

```lua
-- This is the recommended pattern to use when creating switches in your instrument

-- 1: The user clicks on the switch
-- 2: The switch_callback function is called (called 'callback' in this example)
-- 3: The instrument logic will send some kind of command to the flight simulator (in this case turn on/off the avionics) 
-- 4: The flight simulator will respond with a new state
-- 5: The instrument will set the switch accordingly

-- Using this pattern, the flight simulator determines the position the switch should have. This way all instrument switch states will be syncronized.


-- This function will be called when the switch is being clicked by the user.
-- Position is the current position. Ranging from 0 .. number of positions configured 
-- Direction is the direction the user wants the switch to go (this can be +1 for up, -1 for down) 
function callback(position, direction)
  
  if position == 0 then
    xpl_command("sim/systems/avionics_on")
  end

  if position == 1 then
    xpl_command("sim/systems/avionics_off")
  end

end

-- This function is called when the avionncs state is switchd in x-plane
-- When it does, we will changed our switch to sync with the avionics state in x-plane
function dataref_callback(avionics)
  if avionics == 0 then
    switch_set_position(switch_id, 0)
  end

  if avionics == 1 then
    switch_set_position(switch_id, 1)
  end
end

-- Add a switch with 2 states (on and off)
-- The callback function will be called when the switch is being clicked by the user
switch_id = switch_add("off.png", "on.png", 100,100,100,100,callback)

-- Subscribe to the avionics dataref
xpl_dataref_subscribe("sim/cockpit2/switches/avionics_power_on", "INT", dataref_callback)
```

### Example 2 (instrument determines switch position)

```lua
-- This function will be called when the switch is being clicked by the user. Note that the switch won't change position automatically.
-- Position is the current position. Ranging from 0 .. number of positions configured 
-- Direction is the direction the user wants the switch to go (this can be +1 for up, -1 for down)
function callback(position, direction)

  -- This is the position the switch was in when the user clicked the switch
  print("Switch position is at " .. position)
  
  -- Determine the new position the switch should take
  new_position = position + direction

  -- Apply the new position
  print("Setting the switch to position " .. new_position)
  switch_set_position(switch_id, new_position)
end

-- Add a switch with 3 states (a, b and c)
-- The callback function will be called when the switch is being clicked by the user
switch_id = switch_add("a.png", "b.png", "c.png", 100,100,100,100,callback)
```
