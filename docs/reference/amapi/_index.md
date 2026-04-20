---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Total functions: 212
Total pages: 270
---

# AMAPI Reference — Catalog Index

Generated from `assets/air_manager_api/parsed/_index.json`.

## By namespace

### Air (1 functions)

- [Air_Manager_5.x_User_Manual](by_function/Air_Manager_5.x_User_Manual.md) — `\info.xml (contains meta data information) \logic.lua (contains entry point for execution) \preview.png (used by Air Manager in UI, e.g. when used is designing a panel) \lib\ (additional libraries) \resources\ (contains images, font, sounds, etc)`

### Arc (1 functions)

- [Arc_to](by_function/Arc_to.md) — `_arc_to(cpx, cpy, x, y, radius)` — _arc_to is used to draw a arc line from the pen location to the new location provided in the arguments.

### Bezier (1 functions)

- [Bezier_to](by_function/Bezier_to.md) — `_bezier_to(cp1x, cp1y, cp2x, cp2y, x, y)` — _bezier_to is used to draw a bezier line from the pen location to the new location provided in the arguments.

### Button (1 functions)

- [Button_add](by_function/Button_add.md) — `button_id = button_add(img_normal,img_pressed,x,y,width,height,click_press_callback, click_release_callback)` — button_add is used to add a button on the specified location.

### Canvas (5 functions)

- [Canvas_add](by_function/Canvas_add.md) — `canvas_id = canvas_add(x, y, width, height, draw_callback)` — canvas_add is used to create a canvas that allows to draw dynamic shapes like lines, rectangles, circles etc.
- [Canvas_draw](by_function/Canvas_draw.md) — `canvas_draw(canvas_id, draw_callback)` — canvas_draw is used to force the canvas to redraw itself.
- [Canvas_rotate](by_function/Canvas_rotate.md) — `_rotate(angle) _rotate(angle, anchor_x, anchor_y)` — _rotate is used to rotate all shapes drawn after this call to have rotation.
- [Canvas_scale](by_function/Canvas_scale.md) — `_scale(x, y)` — _scale is used to scale all shapes drawn after this call in x and/or y axle.
- [Canvas_translate](by_function/Canvas_translate.md) — `_translate(x, y)` — _translate is used to move all shapes drawn after this call in x and/or y position.

### Device (6 functions)

- [Device_add](by_function/Device_add.md) — `device_id = device_add(type, offset)` — device_add is used to add a device.
- [Device_command](by_function/Device_command.md) — `device_command(cmd_name) device_command(device_id, cmd_name)` — device_command is used to fire a command for a device.
- [Device_command_subscribe](by_function/Device_command_subscribe.md) — `device_command_subscribe(cmd_name, callback) device_command_subscribe(device_id, cmd_name, callback)` — device_cmd_subscribe is used to subscribe to a command for a device.
- [Device_connected](by_function/Device_connected.md) — `device_connected() device_connected(device_id)` — device_connected is used to check if the device is connected.
- [Device_prop_set](by_function/Device_prop_set.md) — `device_prop_set(prop_name, value) device_prop_set(prop_name, unit, value) device_prop_set(device_id, prop_name, value) device_prop_set(device_id, prop_name, unit, value)` — device_prop_set is used to set a property for a device.
- [Device_prop_subscribe](by_function/Device_prop_subscribe.md) — `device_prop_subscribe(prop_name, callback) device_prop_subscribe(device_id, prop_name, callback)` — device_prop_subscribe is used to subscribe to a property for a device.

### Dial (3 functions)

- [Dial_add](by_function/Dial_add.md) — `dial_id = dial_add(image, x, y, width, height, direction_callback) dial_id = dial_add(image, x, y, width, height, direction_callback, pressed_callback) dial_id = dial_add(image, x, y, width, height, direction_callback, pressed_callback, released_callback) dial_id = dial_add(image, x, y, width, height, acceleration, direction_callback) dial_id = dial_add(image, x, y, width, height, acceleration, direction_callback, pressed_callback) dial_id = dial_add(image, x, y, width, height, acceleration, direction_callback, pressed_callback, released_callback)` — dial_add is used to add a dial on the specified location.
- [Dial_click_rotate](by_function/Dial_click_rotate.md) — `dial_click_rotate(dial_id,degrees_delta)` — dial_click_rotate is used to set the number of degrees the dial should rotate on each click.
- [Dial_set_acceleration](by_function/Dial_set_acceleration.md) — `dial_set_acceleration(dial_id, acceleration)` — dial_set_acceleration is used to set a new acceleration value for a dial.

### Event (1 functions)

- [Event_subscribe](by_function/Event_subscribe.md) — `event_subscribe(callback)` — event_subscribe is used to subscribe to global events.

### Ext (5 functions)

- [Ext_command](by_function/Ext_command.md) — `ext_event(source_tag,event,value)` — ext_event is used to send a command to an external source.
- [Ext_command_subscribe](by_function/Ext_command_subscribe.md) — `ext_command_subscribe(command_name,callback_function)` — ext_command_subscribe is used to subscribe to an external data source commands.
- [Ext_connected](by_function/Ext_connected.md) — `connected = ext_connected(source_tag)` — ext_connected is used to check if an external data source is connected.
- [Ext_variable_subscribe](by_function/Ext_variable_subscribe.md) — `ext_variable_subscribe(source_tag,variable,data_type,...,callback_function)` — ext_variable_subscribe is used to subscribe on one or more external source variables.
- [Ext_variable_write](by_function/Ext_variable_write.md) — `ext_variable_write(source_tag,variable, unit, value)` — ext_variable_write is used to write a variable on an external source variables.

### Fi (7 functions)

- [Fi_engine_cluster_add](by_function/Fi_engine_cluster_add.md) — `fi_engine_cluster_id = fi_engine_cluster_add(type)` — fi_engine_cluster_add is used to add a flight illusion engine cluster.
- [Fi_engine_cluster_prop_set](by_function/Fi_engine_cluster_prop_set.md) — `fi_engine_cluster_prop_set(fi_gauge_id, prop_name, value) fi_engine_cluster_prop_set(fi_gauge_id, prop_name, unit, value)` — fi_engine_cluster_prop_set is used to set a property for a Flight Illusion engine cluster.
- [Fi_gauge_add](by_function/Fi_gauge_add.md) — `fi_gauge_id = fi_gauge_add(address, type)` — fi_gauge_add is used to add a Flight Illusion gauge.
- [Fi_gauge_command](by_function/Fi_gauge_command.md) — `fi_gauge_command(fi_gauge_id, command_name)` — fi_gauge_command is used to send a command for a Flight Illusion gauge.
- [Fi_gauge_command_subscribe](by_function/Fi_gauge_command_subscribe.md) — `fi_gauge_command_subscribe(fi_gauge_id, command_name, callback_function)` — fi_gauge_command_subscribe is used to subscribe to a Flight Illusion gauge command.
- [Fi_gauge_prop_set](by_function/Fi_gauge_prop_set.md) — `fi_gauge_prop_set(fi_gauge_id, prop_name, value) fi_gauge_prop_set(fi_gauge_id, prop_name, unit, value)` — fi_gauge_prop_set is used to set a property for a Flight Illusion engine cluster.
- [Fi_gauge_prop_subscribe](by_function/Fi_gauge_prop_subscribe.md) — `fi_gauge_prop_subscribe(fi_gauge_id, prop_name, callback_function)` — fi_gauge_prop_subscribe is used to subscribe to a Flight Illusion gauge property.

### Fill (4 functions)

- [Fill_gradient_box](by_function/Fill_gradient_box.md) — `_fill_gradient_box(x, y, width, height, corner, feather, color_inner, color_outer)` — _fill_gradient_box is used to apply all queued drawings into a boxed gradient fill.
- [Fill_gradient_linear](by_function/Fill_gradient_linear.md) — `_fill_gradient_linear(x1, y1, x2, y2, color_1, color_2)` — _fill_gradient_linear is used to apply all queued drawings into a linear gradient fill.
- [Fill_gradient_radial](by_function/Fill_gradient_radial.md) — `_fill_gradient_radial(x, y, radius_inner, radius_outer, color_inner, color_outer)` — _fill_gradient_radial is used to apply all queued drawings into a radial gradient fill.
- [Fill_img](by_function/Fill_img.md) — `_fill_img(file_name, x, y, width, height) _fill_img(file_name, x, y, width, height, opacity)` — _fill_img is used to apply all queued drawings into a fill (inside is the image provided).

### Fs2020 (6 functions)

- [Fs2020_connected](by_function/Fs2020_connected.md) — `connected = fs2020_connected()` — fs2020_connected is used to check if there is an active connected with FS2020.
- [Fs2020_event](by_function/Fs2020_event.md) — `fs2020_event(event) fs2020_event(event, type, value) (from AM/AP 5.0) fs2020_event(event, value) fs2020_event(event, value, value_2) (from AM/AP 4.1)` — fs2020_event is used to send an event to FS2020.
- [Fs2020_event_subscribe](by_function/Fs2020_event_subscribe.md) — `fs2020_event_subscribe(event, callback)` — fs2020_event_subscribe is used to subscribe to a FS2020 event.
- [Fs2020_rpn](by_function/Fs2020_rpn.md) — `fs2020_rpn(rpn_script, callback)` — fs2020_rpn is used to execute a RPN script within FS2020.
- [Fs2020_variable_subscribe](by_function/Fs2020_variable_subscribe.md) — `fs2020_variable_subscribe(variable, unit, callback_function)` — fs2020_variable_subscribe is used to subscribe on one or more FS2020 variables.
- [Fs2020_variable_write](by_function/Fs2020_variable_write.md) — `fs2020_variable_write(variable, unit, value)` — fs2020_variable_write is used write a variable to FS2020 You can find the available variables for F2020 [here (official)](https://docs.

### Fs2024 (6 functions)

- [Fs2024_connected](by_function/Fs2024_connected.md) — `connected = fs2024_connected()` — fs2024_connected is used to check if there is an active connected with FS2024.
- [Fs2024_event](by_function/Fs2024_event.md) — `fs2024_event(event) fs2024_event(event, type, value) fs2024_event(event, value) fs2024_event(event, value, value_2)` — fs2024_event is used to send an event to FS2024.
- [Fs2024_event_subscribe](by_function/Fs2024_event_subscribe.md) — `fs2024_event_subscribe(event, callback)` — fs2024_event_subscribe is used to subscribe to a FS2024 event.
- [Fs2024_rpn](by_function/Fs2024_rpn.md) — `fs2024_rpn(rpn_script, callback)` — fs2024_rpn is used to execute a RPN script within FS2024.
- [Fs2024_variable_subscribe](by_function/Fs2024_variable_subscribe.md) — `fs2024_variable_subscribe(variable, unit, callback_function)` — fs2024_variable_subscribe is used to subscribe on one or more FS2024 variables.
- [Fs2024_variable_write](by_function/Fs2024_variable_write.md) — `fs2024_variable_write(variable, unit, value)` — fs2024_variable_write is used write a variable to FS2024 You can find the available variables for F2024 [here (official)](https://docs.

### Fsx (4 functions)

- [Fsx_connected](by_function/Fsx_connected.md) — `connected = fsx_connected()` — fsx_connected is used to check if there is an active connected with FSX.
- [Fsx_event](by_function/Fsx_event.md) — `fsx_event(event,value)` — fsx_event is used to send an event to FSX or Prepar3D.
- [Fsx_variable_subscribe](by_function/Fsx_variable_subscribe.md) — `fsx_variable_subscribe(variable,unit,callback_function)` — fsx_variable_subscribe is used to subscribe on one or more FSX or Prepar3D variables.
- [Fsx_variable_write](by_function/Fsx_variable_write.md) — `fsx_variable_write(variable, unit, value)` — fsx_variable_write is used write a variable to FSX or Prepar3D You can find the available variables for FSX [here](http://msdn.

### Game (2 functions)

- [Game_controller_add](by_function/Game_controller_add.md) — `game_controller_id = game_controller_add(name, callback)` — game_controller_add is used to add a game controller.
- [Game_controller_list](by_function/Game_controller_list.md) — `game_controller_id = game_controller_list()` — game_controller_list is used to list all available joysticks on the system.

### Geo (1 functions)

- [Geo_rotate_coordinates](by_function/Geo_rotate_coordinates.md) — `x, y = geo_rotate_coordinates(degrees, radius_x, radius_y)` — geo_rotate_coordinates is used to get the x and y coordinates from a circle with a certain radius and angle.

### Group (3 functions)

- [Group_add](by_function/Group_add.md) — `group_id = group_add(node_id, node_id, ...)` — group_add is to group together Nodes.
- [Group_obj_add](by_function/Group_obj_add.md) — `group_obj_add(group_id, gui_id, ...)` — group_obj_add is used to add additional objects to an existing group.
- [Group_obj_remove](by_function/Group_obj_remove.md) — `group_obj_remove(group_id, gui_id, ...)` — group_obj_remove is used to remove additional objects from an existing group.

### Has (1 functions)

- [Has_feature](by_function/Has_feature.md) — `feature_available = has_feature(name)` — has_feature can be used to check if the current version of Air Manager or Air Player supports the asked feature.

### Hw (28 functions)

- [Hw_adc_input_add](by_function/Hw_adc_input_add.md) — `hw_adc_input_id = hw_adc_input_add(name, callback) (from AM/AP 3.5) hw_adc_input_id = hw_adc_input_add(name, hysteresis, callback) (from AM/AP 3.5) hw_adc_input_id = hw_adc_input_add(hw_id, callback) hw_adc_input_id = hw_adc_input_add(hw_id, hysteresis, callback)` — hw_adc_input_add is used to add a hardware ADC input to your instrument.
- [Hw_adc_input_read](by_function/Hw_adc_input_read.md) — `value = hw_adc_input_read(hw_adc_input_id)` — hw_adc_input_read is used to read the value of a hardware ADC input.
- [Hw_button_add](by_function/Hw_button_add.md) — `hw_button_id = hw_button_add(name, pressed_callback, released_callback) (from AM/AP 3.5) hw_button_id = hw_button_add(hw_id, pressed_callback, released_callback)` — hw_button_add is used to add a hardware button to your instrument.
- [Hw_button_array_add](by_function/Hw_button_array_add.md) — `hw_button_array_id = hw_button_array_add(name, nr_rows, nr_columns, pressed_callback, released_callback) (from AM/AP 3.5) hw_button_array_id = hw_button_array_add(nr_rows, nr_columns, hw_id_0, hw_id_1, ..., pressed_callback, released_callback)` — hw_button_array_add is used to add a hardware button array to your instrument.
- [Hw_chr_display_add](by_function/Hw_chr_display_add.md) — `hw_chr_display_id = hw_chr_display_add(name, type, ...) (from AM/AP 3.5) hw_chr_display_id = hw_chr_display_add(type, ...)` — hw_chr_display_add is used to add a Hardware character display.
- [Hw_chr_display_set_brightness](by_function/Hw_chr_display_set_brightness.md) — `hw_chr_display_set_brightness(hw_chr_display_id, brightness) (from AM/AP 4.1) hw_chr_display_set_brightness(hw_chr_display_id, display, brightness)` — hw_chr_display_set_brightness is used to set the brightness of a Hardware character display.
- [Hw_chr_display_set_text](by_function/Hw_chr_display_set_text.md) — `hw_chr_display_set_text(hw_chr_display_id, text) hw_chr_display_set_text(hw_chr_display_id, line, text) hw_chr_display_set_text(hw_chr_display_id, display, line, text)` — hw_chr_display_set_text is used to set the text on a Hardware character display.
- [Hw_connected](by_function/Hw_connected.md) — `value = hw_connected(hw_node_id) value = hw_connected(hw_id)` — hw_connected is used to check if the given hardware node or hardware id is connected to the hardware.
- [Hw_dac_output_add](by_function/Hw_dac_output_add.md) — `hw_dac_output_id = hw_dac_output_add(name, initial_value) (from AM/AP 3.5) hw_dac_output_id = hw_dac_output_add(hw_id, initial_value)` — hw_dac_output_add is used to add a DAC hardware output to your instrument.
- [Hw_dac_output_set](by_function/Hw_dac_output_set.md) — `hw_dac_output_set(hw_dac_output_id, value)` — hw_dac_output_set is used to set a hardware output to a certain state.
- [Hw_dial_add](by_function/Hw_dial_add.md) — `hw_dial_id = hw_dial_add(name, callback) (from AM/AP 3.5) hw_dial_id = hw_dial_add(name, type, callback) (from AM/AP 3.5) hw_dial_id = hw_dial_add(name, acceleration, callback) (from AM/AP 3.5) hw_dial_id = hw_dial_add(name, type, acceleration, callback) (from AM/AP 3.5) hw_dial_id = hw_dial_add(name, type, acceleration, debounce, callback) (from AM/AP 3.5) hw_dial_id = hw_dial_add(hw_id_a, hw_id_b, callback) hw_dial_id = hw_dial_add(hw_id_a, hw_id_b, type, callback) hw_dial_id = hw_dial_add(hw_id_a, hw_id_b, acceleration, callback) hw_dial_id = hw_dial_add(hw_id_a, hw_id_b, type, acceleration, callback) hw_dial_id = hw_dial_add(hw_id_a, hw_id_b, type, acceleration, debounce, callback) (from AM/AP 3.5)` — hw_dial_id is used to add a hardware rotary encoder to your instrument.
- [Hw_dial_set_acceleration](by_function/Hw_dial_set_acceleration.md) — `hw_dial_set_acceleration(hw_dial_id, acceleration)` — hw_dial_set_acceleration is used to change the acceleration of a rotary encoder.
- [Hw_input_add](by_function/Hw_input_add.md) — `hw_input_id = hw_input_add(name, callback) (from AM/AP 3.5) hw_input_id = hw_input_add(hw_id, callback)` — hw_input_add is used to add a hardware input to your instrument.
- [Hw_input_read](by_function/Hw_input_read.md) — `state = hw_input_read(hw_input_id)` — hw_input_read is used to read the state of a hardware input.
- [Hw_led_add](by_function/Hw_led_add.md) — `hw_led_id = hw_led_add(name, initial_brightness) (from AM/AP 3.5) hw_led_id = hw_led_add(hw_id, initial_brightness)` — hw_led_add is used to add a LED output to your instrument.
- [Hw_led_set](by_function/Hw_led_set.md) — `hw_led_set(hw_led_id, brightness)` — hw_led_set is used to set a LED output to a certain brightness.
- [Hw_message_port_add](by_function/Hw_message_port_add.md) — `hw_message_port_id = hw_message_port_add(name, message_callback) (from AM/AP 3.5) hw_message_port_id = hw_message_port_add(hw_id, message_callback)` — hw_message_port_add is used to add a connection between your instrument and a custom Arduino program.
- [Hw_message_port_send](by_function/Hw_message_port_send.md) — `hw_message_port_send(hw_message_port_id, message_id, payload_type, payload)` — hw_message_port_send is used to send a message to an external MessagePort application, typically an Arduino program.
- [Hw_output_add](by_function/Hw_output_add.md) — `hw_output_id = hw_output_add(name, initial_state) (from AM/AP 3.5) hw_output_id = hw_output_add(hw_id, initial_state)` — hw_output_add is used to add a hardware output to your instrument.
- [Hw_output_pwm_add](by_function/Hw_output_pwm_add.md) — `hw_output_pwm_id = hw_output_pwm_add(name, frequency_hz, initial_duty_cycle) (from AM/AP 3.5) hw_output_pwm_id = hw_output_pwm_add(hw_id, frequency_hz, initial_duty_cycle)` — hw_output_pwm_add is used to add a hardware PWM output to your instrument.
- [Hw_output_pwm_duty_cycle](by_function/Hw_output_pwm_duty_cycle.md) — `hw_output_pwm_duty_cycle(hw_output_pwm_id, duty_cycle)` — hw_output_pwm_duty_cycle is used to change the duty cycle of a PWM output.
- [Hw_output_set](by_function/Hw_output_set.md) — `hw_output_set(hw_output_id, state)` — hw_output_set is used to set a hardware output to a certain state.
- [Hw_stepper_motor_add](by_function/Hw_stepper_motor_add.md) — `hw_stepper_motor_id = hw_stepper_motor_add(name, type, nr_steps, speed_rpm) (from AM/AP 3.5) hw_stepper_motor_id = hw_stepper_motor_add(name, type, nr_steps, speed_rpm, circular) (from AM/AP 3.6) hw_stepper_motor_id = hw_stepper_motor_add(type, nr_steps, speed_rpm, hw_id_1, hw_id_2, ...) (AM/AP 3.5) hw_stepper_motor_id = hw_stepper_motor_add(type, nr_steps, speed_rpm, circular, hw_id_1, hw_id_2, ...) (from AM/AP 3.6)` — hw_stepper_motor_add is used to add a Hardware stepper motor.
- [Hw_stepper_motor_calibrate](by_function/Hw_stepper_motor_calibrate.md) — `hw_stepper_motor_calibrate(hw_stepper_motor_id) hw_stepper_motor_calibrate(hw_stepper_motor_id, position)` — hw_stepper_motor_calibrate is used to set the current physical position of the stepper motor to a defined position.
- [Hw_stepper_motor_position](by_function/Hw_stepper_motor_position.md) — `hw_stepper_motor_position(hw_stepper_motor_id, position) hw_stepper_motor_position(hw_stepper_motor_id, position, direction)` — hw_stepper_motor_position is used to set the position of of the stepper motor.
- [Hw_stepper_motor_speed](by_function/Hw_stepper_motor_speed.md) — `hw_stepper_motor_speed(hw_stepper_motor_id, speed_rpm)` — hw_stepper_motor_speed is used to set the speed of of the stepper motor.
- [Hw_switch_add](by_function/Hw_switch_add.md) — `hw_switch_id = hw_switch_add(name, nr_pins, callback) (from AM/AP 3.5) hw_switch_id = hw_switch_add(hw_id_0, hw_id_1, hw_pos_n,callback)` — switch_add is used to add a hardware switch.
- [Hw_switch_get_position](by_function/Hw_switch_get_position.md) — `position = hw_switch_get_position(hw_switch_id)` — hw_switch_get_position is used to get the current position of a hardware switch.

### Img (2 functions)

- [Img_add](by_function/Img_add.md) — `image_id = img_add(filename, x, y, width, height) image_id = img_add(filename, x, y, width, height, style)` — img_add is used to show an image on the specified location.
- [Img_add_fullscreen](by_function/Img_add_fullscreen.md) — `image_id = img_add_fullscreen(filename) image_id = img_add_fullscreen(filename, style)` — img_add_fullscreen is used to show an image fullscreen on the canvas.

### Instrument (2 functions)

- [Instrument_get](by_function/Instrument_get.md) — `instrument_id = instrument_get(uuid) instrument_id = instrument_get(uuid, offset)` — instrument_get is used to get a reference to an instrument.
- [Instrument_prop](by_function/Instrument_prop.md) — `value = instrument_prop(property)` — instrument_prop is used to get the settings from the current instrument like aircraft, type, version, height, width, development, etc etc.

### Interpolate (2 functions)

- [Interpolate_linear](by_function/Interpolate_linear.md) — `value = interpolate_linear(settings, value) value = interpolate_linear(settings, value, cap) (from AM/AP 4.1)` — interpolate_linear is used to interpolate a value with given settings.
- [Interpolate_settings_from_user_prop](by_function/Interpolate_settings_from_user_prop.md) — `value = interpolate_settings_from_user_prop(user_prop_table_value)` — interpolate_settings_from_user_prop is used to create interpolate settings from a table user property.

### Layer (2 functions)

- [Layer_add](by_function/Layer_add.md) — `layer_id = layer_add(z_order, callback) layer_id = layer_add(z_order, callback, input_event_callback) (from AM/AP 5.0) layer_id = layer_add(z_order, x, y, w, h, callback) (from AM/AP 5.0) layer_id = layer_add(z_order, x, y, w, h, callback, input_event_callback) (from AM/AP 5.0)` — layer_add is used to create a new layer.
- [Layer_mouse_cursor](by_function/Layer_mouse_cursor.md) — `layer_mouse_cursor(layer_id, cursor)` — layer_mouse_cursor is used to set the mouse cursor when hovering over this layer.

### Line (1 functions)

- [Line_to](by_function/Line_to.md) — `_line_to(x, y)` — _line_to is used to draw a line from the pen location to the new location provided in the arguments.

### Map (8 functions)

- [Map_add](by_function/Map_add.md) — `map_id = map_add(x,y,width,height,source,zoom)` — map_add is used to add a map to your instrument.
- [Map_add_nav_canvas_layer](by_function/Map_add_nav_canvas_layer.md) — `layer_id = map_add_nav_canvas_layer(map_id, nav_type, x, y, width, height, draw_callback)` — map_add_nav_canvas_layer is used to add a NAV canvas layer to an existing map.
- [Map_add_nav_img_layer](by_function/Map_add_nav_img_layer.md) — `layer_id = map_add_nav_img_layer(map_id, nav_type, filename, x, y, width, height)` — map_add_nav_img_layer is used to add a NAV image layer to an existing map.
- [Map_add_nav_txt_layer](by_function/Map_add_nav_txt_layer.md) — `layer_id = map_add_nav_txt_layer(map_id, nav_type, nav_param, style, x, y, width, height)` — map_add_nav_txt_layer is used to add a NAV layer to an existing map.
- [Map_baselayer](by_function/Map_baselayer.md) — `map_baselayer(layer_id, source)` — map_baselayer is used to change the baselayer source used in the map.
- [Map_goto](by_function/Map_goto.md) — `map_goto(map_id,lat,lon)` — map_goto is used to set the map location to a certain place on earth.
- [Map_nav_canvas_layer_draw](by_function/Map_nav_canvas_layer_draw.md) — `map_nav_canvas_layer_draw(layer_id)` — map_nav_canvas_layer_draw is used to redraw all the canvas for each nav object.
- [Map_zoom](by_function/Map_zoom.md) — `map_zoom(map_id,zoom)` — map_zoom is used to set to change the zoom level of a map.

### Mouse (1 functions)

- [Mouse_setting](by_function/Mouse_setting.md) — `mouse_setting(node_id,property,value)` — mouse_setting is used to configure mouse settings for dials, buttons or switches.

### Move (1 functions)

- [Move_to](by_function/Move_to.md) — `_move_to(x, y)` — _move_to is used to move the drawing pen to a new location.

### Msfs (6 functions)

- [Msfs_connected](by_function/Msfs_connected.md) — `connected = msfs_connected()` — msfs_connected is used to check if there is an active connected with FS2020 or FS2024.
- [Msfs_event](by_function/Msfs_event.md) — `msfs_event(event) msfs_event(event, value_1) msfs_event(event, value_1, value_2)` — msfs_event is used to send an event to FS2020/FS2024.
- [Msfs_event_subscribe](by_function/Msfs_event_subscribe.md) — `msfs_event_subscribe(event, callback)` — msfs_event_subscribe is used to subscribe to a FS2020/FS2024 event.
- [Msfs_rpn](by_function/Msfs_rpn.md) — `msfs_rpn(rpn_script, callback)` — msfs_rpn is used to execute a RPN script within FS2020 / FS2024.
- [Msfs_variable_subscribe](by_function/Msfs_variable_subscribe.md) — `msfs_variable_subscribe(variable, unit, callback_function)` — msfs_variable_subscribe is used to subscribe on one or more FS2020/FS2024 variables.
- [Msfs_variable_write](by_function/Msfs_variable_write.md) — `msfs_variable_write(variable, unit, value)` — msfs_variable_write is used write a variable to FS2020/FS2024 You can find the available variables for F2020 [here (official)](https://docs.

### Nav (5 functions)

- [Nav_calc_bearing](by_function/Nav_calc_bearing.md) — `bearing = nav_calc_bearing(bearing_type, lat1, lon1, lat2, lon2)` — nav_calc_bearing is used to calculate the bearing from the first coordinate to the second coordinate.
- [Nav_calc_distance](by_function/Nav_calc_distance.md) — `distance = nav_calc_distance(distance_type, lat1, lon1, lat2, lon2)` — nav_calc_distance can be used to get the distance between two coordinates.
- [Nav_get](by_function/Nav_get.md) — `nav_item = nav_get(nav_type, nav_property, value) (up to AM/AP 3.7) nav_get(nav_type, nav_property, value, callback) (from AM/AP 4.0) nav_get(nav_type, nav_property, value, timeout, callback) (from AM/AP 4.0)` — nav_get can be used to get NAV information from one of its NAV properties.
- [Nav_get_nearest](by_function/Nav_get_nearest.md) — `nav_items = nav_get_nearest(nav_type, latitude, longitude, max_entries) (up to AM/AP 3.7) nav_get_nearest(nav_type, latitude, longitude, max_entries, callback) (from AM/AP 4.0) nav_get_nearest(nav_type, latitude, longitude, max_entries, timeout, callback) (from AM/AP 4.0)` — nav_get_nearest can be used to get the nearest NAV points, based on a given latitude and longitude.
- [Nav_get_radius](by_function/Nav_get_radius.md) — `nav_items = nav_get_radius(nav_type, lat, lon, distance) (up to AM/AP 3.7) nav_get_radius(nav_type, lat, lon, distance, max_entries, callback) (from AM/AP 4.0) nav_get_radius(nav_type, lat, lon, distance, max_entries, timeout, callback) (from AM/AP 4.0)` — nav_get_radius can be used to get the NAV points, within a radius around a given latitude and longitude.

### P3d (1 functions)

- [P3d_connected](by_function/P3d_connected.md) — `connected = p3d_connected()` — p3d_connected is used to check if there is an active connected with Prepar3D.

### Panel (1 functions)

- [Panel_prop](by_function/Panel_prop.md) — `value = panel_prop(property)` — panel_prop is used to get the settings from the current panel.

### Persist (3 functions)

- [Persist_add](by_function/Persist_add.md) — `persist_id = persist_add(key, initial_value)` — persist_add is used to create a new persistence object.
- [Persist_get](by_function/Persist_get.md) — `value = persist_get(persist_id)` — persist_get(persist_id) is used to get data from a persistence object.
- [Persist_put](by_function/Persist_put.md) — `persist_put(persist_id, value)` — persist_put is used to put new data into a persistence object.

### Quad (1 functions)

- [Quad_to](by_function/Quad_to.md) — `_quad_to(cp1, cp1y, cp2x, cp2y, x, y)` — _quad_to is used to draw a quad line from the pen location to the new location provided in the arguments.

### Request (1 functions)

- [Request_callback](by_function/Request_callback.md) — `request_callback(callback_function)` — request_callback is used to force a callback on a given data subscription (X-Plane, FSX, FS2, FS2020, IIC or external so

### Resource (1 functions)

- [Resource_info](by_function/Resource_info.md) — `meta_data = resource_info(filename)` — resource_info can be used to get information of a resource file.

### Running (8 functions)

- [Running_img_add_cir](by_function/Running_img_add_cir.md) — `running_img_id = running_img_add_cir(filename, x,y,nr_visible_items,item_width,item_height,radius) running_img_id = running_img_add_cir(filename, x,y,nr_visible_items,item_width,item_height,radius_x,radius_y)` — running_img_add_cir is used to add a running image object.
- [Running_img_add_hor](by_function/Running_img_add_hor.md) — `running_img_id = running_img_add_hor(filename, x,y,nr_visible_items,item_width,item_height)` — running_img_add_hor is used to add a running image object.
- [Running_img_add_ver](by_function/Running_img_add_ver.md) — `running_img_id = running_img_add_ver(filename, x,y,nr_visible_items,item_width,item_height)` — running_img_add_ver is used to add a running image object.
- [Running_img_move_carot](by_function/Running_img_move_carot.md) — `running_img_move_carot(running_img_id,position)` — running_img_move_carot is used set the carot of a running image object.
- [Running_txt_add_cir](by_function/Running_txt_add_cir.md) — `running_txt_id = running_txt_add_cir(x,y,nr_visible_items,item_width,item_height,radius,value_callback,style) running_txt_id = running_txt_add_cir(x,y,nr_visible_items,item_width,item_height,radius_x,radius_y,value_callback,style)` — running_txt_add_cir is used to add a running text object.
- [Running_txt_add_hor](by_function/Running_txt_add_hor.md) — `running_txt_id = running_txt_add_hor(x,y,nr_visible_items,item_width,item_height,value_callback,style)` — running_txt_add_hor is used to add a running text object.
- [Running_txt_add_ver](by_function/Running_txt_add_ver.md) — `running_txt_id = running_txt_add_ver(x,y,nr_visible_items,item_width,item_height,value_callback,style)` — running_txt_add_ver is used to add a running text object.
- [Running_txt_move_carot](by_function/Running_txt_move_carot.md) — `running_txt_move_carot(running_txt_id, position)` — running_txt_move_carot is used set the position of a running txt object.

### Scene (12 functions)

- [Scene_add](by_function/Scene_add.md) — `scene_id = scene_add(x, y, width, height)` — scene_add is used to create a scene that allows to draw 3D shapes like spheres, cubes etc.
- [Scene_camera_add](by_function/Scene_camera_add.md) — `camera_id = scene_camera_add(scene_id)` — scene_camera_add is used to create a camera object.
- [Scene_light_add](by_function/Scene_light_add.md) — `light_id = scene_light_add(scene_id)` — scene_light_add is used to create a light object.
- [Scene_material_add](by_function/Scene_material_add.md) — `material_id = scene_material_add(scene_id, resource) material_id = scene_material_add(scene_id, resource, scroll_u, scroll_v, scale_u, scale_v, angle) material_id = scene_material_add(scene_id, w, h, draw_callback) material_id = scene_material_add(scene_id, w, h, draw_callback, scroll_u, scroll_v, scale_u, scale_v, angle)` — scene_material_add is used to create a material object.
- [Scene_mesh_add](by_function/Scene_mesh_add.md) — `mesh_id = scene_mesh_add(scene_id, resource)` — scene_mesh_add is used to create a mesh object.
- [Scene_mesh_set_material](by_function/Scene_mesh_set_material.md) — `scene_mesh_set_material(mesh_id, material_id)` — scene_mesh_set_material is used to set a material to an existing mesh (3d object).
- [Scene_node_add](by_function/Scene_node_add.md) — `scene_node_id = scene_node_add(scene_id) scene_node_id = scene_node_add(scene_id, attach_object)` — scene_node_add is used to create a scene node.
- [Scene_node_attach](by_function/Scene_node_attach.md) — `scene_node_attach(scene_node_id, attach_object)` — scene_node_attach is used attach an existing camera, light or mesh to a scene node.
- [Scene_node_move](by_function/Scene_node_move.md) — `scene_node_move(scene_node_id, x, y, z)` — scene_node_move is used translate a scene node within it's scene.
- [Scene_node_rotate](by_function/Scene_node_rotate.md) — `scene_node_rotate(scene_node_id, x, y, z)` — scene_node_rotate is used rotate a scene node within it's scene.
- [Scene_node_scale](by_function/Scene_node_scale.md) — `scene_node_scale(scene_node_id, x, y, z)` — scene_node_scale is used scale a scene node within it's scene.
- [Scene_viewport_add](by_function/Scene_viewport_add.md) — `viewport_id = scene_viewport_add(scene_id)` — scene_viewport_add is used to create a viewport object.

### Scrollwheel (2 functions)

- [Scrollwheel_add_hor](by_function/Scrollwheel_add_hor.md) — `scrollwheel_id = scrollwheel_add_hor(segment_image, x, y, width, height, segment_width, segment_height, direction_callback) scrollwheel_id = scrollwheel_add_hor(segment_image, x, y, width, height, segment_width, segment_height, direction_callback, pressed_callback) scrollwheel_id = scrollwheel_add_hor(segment_image, x, y, width, height, segment_width, segment_height, direction_callback, pressed_callback, released_callback)` — scrollwheel_add_hor is used to add a vertical scroll wheel to an instrument.
- [Scrollwheel_add_ver](by_function/Scrollwheel_add_ver.md) — `scrollwheel_id = scrollwheel_add_ver(segment_image, x, y, width, height, segment_width, segment_height, direction_callback) scrollwheel_id = scrollwheel_add_ver(segment_image, x, y, width, height, segment_width, segment_height, direction_callback, pressed_callback) scrollwheel_id = scrollwheel_add_ver(segment_image, x, y, width, height, segment_width, segment_height, direction_callback, pressed_callback, released_callback)` — scrollwheel_add_ver is used to add a vertical scroll wheel to an instrument.

### Shut (1 functions)

- [Shut_down](by_function/Shut_down.md) — `value = shut_down(type)` — shut_down is used to shut down the application (Air Manager or Air Player) or the system where the instrument runs on

### Si (5 functions)

- [Si_command](by_function/Si_command.md) — `si_command(command_name) si_command(command_name, type)` — si_command is used to send a global command.
- [Si_command_subscribe](by_function/Si_command_subscribe.md) — `si_command_subscribe(command_name,callback_function)` — si_command_subscribe is used to subscribe on one or more global commands.
- [Si_variable_create](by_function/Si_variable_create.md) — `var_id = si_variable_create(variable, type, initial_value)` — si_variable_create is used to create a global variable.
- [Si_variable_subscribe](by_function/Si_variable_subscribe.md) — `si_variable_subscribe(variable,type,...,callback_function)` — si_variable_subscribe is used to subscribe on one or more global variables.
- [Si_variable_write](by_function/Si_variable_write.md) — `si_variable_write(var_id, value)` — si_variable_write is used write to an Air Manager variable.

### Slider (4 functions)

- [Slider_add_cir](by_function/Slider_add_cir.md) — `slider_id = slider_add_cir(image, x, y, width, height, radius, start_angle, end_angle, thumb_image, thumb_width, thumb_height, position_callback) slider_id = slider_add_cir(image, x, y, width, height, radius, start_angle, end_angle, thumb_image, thumb_width, thumb_height, position_callback, pressed_callback) slider_id = slider_add_cir(image, x, y, width, height, radius, start_angle, end_angle, thumb_image, thumb_width, thumb_height, position_callback, pressed_callback, released_callback)` — slider_add_cir is used to add a circulair slider on the specified location.
- [Slider_add_hor](by_function/Slider_add_hor.md) — `slider_id = slider_add_hor(image, x, y, width, height, thumb_image, thumb_width, thumb_height, position_callback) slider_id = slider_add_hor(image, x, y, width, height, thumb_image, thumb_width, thumb_height, position_callback, pressed_callback) slider_id = slider_add_hor(image, x, y, width, height, thumb_image, thumb_width, thumb_height, position_callback, pressed_callback, released_callback)` — slider_add_hor is used to add a horizontal slider on the specified location.
- [Slider_add_ver](by_function/Slider_add_ver.md) — `slider_id = slider_add_ver(image, x, y, width, height, tick_image, tick_width, tick_height, position_callback) slider_id = slider_add_ver(image, x, y, width, height, tick_image, tick_width, tick_height, position_callback, pressed_callback) slider_id = slider_add_ver(image, x, y, width, height, tick_image, tick_width, tick_height, position_callback, pressed_callback, released_callback)` — slider_add_ver is used to add a vertical slider on the specified location.
- [Slider_set_position](by_function/Slider_set_position.md) — `slider_set_position(slider_id,position)` — slider_set_position is used to set a slider to a certain position.

### Sound (5 functions)

- [Sound_add](by_function/Sound_add.md) — `sound_id = sound_add(filename, volume)` — sound_add is used to load a sound file.
- [Sound_loop](by_function/Sound_loop.md) — `sound_loop(sound_id)` — sound_loop is used to play a previously loaded sound.
- [Sound_play](by_function/Sound_play.md) — `sound_play(sound_id)` — sound_play is used to play a previously loaded sound.
- [Sound_stop](by_function/Sound_stop.md) — `sound_stop(sound_id)` — sound_stop is used to stop a previously loaded sound.
- [Sound_volume](by_function/Sound_volume.md) — `sound_volume(sound_id, volume)` — sound_volume is used to change the volume a previously loaded sound.

### Static (1 functions)

- [Static_data_load](by_function/Static_data_load.md) — `data = static_data_load(path) data = static_data_load(path, options) (from AM/AP 3.6 or later) static_data_load(path, callback) static_data_load(path, options, callback) (from AM/AP 3.6 or later)` — static_data_load is used to get load static data from a JSON, CSV or text file located in the resources folder.

### Switch (3 functions)

- [Switch_add](by_function/Switch_add.md) — `switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height) (from AM/AP 5.0) switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height, position_callback) switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height, position_callback, pressed_callback) switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height, position_callback, pressed_callback, released_callback) switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height, mode) (from AM/AP 5.0) switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height, mode, position_callback) (from AM/AP 4.0) switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height, mode, position_callback, pressed_callback) (from AM/AP 4.0) switch_id = switch_add(img_pos_0, img_pos_1, img_pos_n, x, y, width, height, mode, position_callback, pressed_callback, released_callback) (from AM/AP 4.0)` — switch_add is used to add a switch on the specified location.
- [Switch_get_position](by_function/Switch_get_position.md) — `position = switch_get_position(hw_switch_id)` — switch_get_position is used to get the current position of a switch.
- [Switch_set_position](by_function/Switch_set_position.md) — `switch_set_position(switch_id,position)` — switch_set_position is used to set a switch to a certain position.

### Timer (3 functions)

- [Timer_running](by_function/Timer_running.md) — `running = timer_running(timer_id)` — timer_running is used to check if the timer is currently running.
- [Timer_start](by_function/Timer_start.md) — `timer_id = timer_start(delay) (from AM/AP 4.1) timer_id = timer_start(delay, callback) (from AM/AP 3.5) timer_id = timer_start(delay, period, callback) timer_id = timer_start(delay, period, nr_calls, callback) (from AM/AP 3.5)` — timer_start is used to start a timer, which will call a function at an configurable interval.
- [Timer_stop](by_function/Timer_stop.md) — `timer_stop(timer_id)` — timer_stop is used to stop a previously started timer.

### Touch (1 functions)

- [Touch_setting](by_function/Touch_setting.md) — `touch_setting(node_id,property,value)` — touch_setting is used to configure touch settings for dials, buttons or switches.

### Txt (3 functions)

- [Txt_add](by_function/Txt_add.md) — `txt_id = txt_add(text,style, x,y,width,height)` — txt_add is used to show a text on the specified location.
- [Txt_set](by_function/Txt_set.md) — `txt_set(txt_id, text)` — txt_set is used change the text on a txt_id.
- [Txt_style](by_function/Txt_style.md) — `txt_style(txt_id,style)` — txt_style is used to change the style of a text box.

### User (9 functions)

- [User_prop_add_boolean](by_function/User_prop_add_boolean.md) — `user_prop_id = user_prop_add_boolean(name, default_value, description)` — user_prop_add_float will add an additional user customizable setting to your instrument of the type boolean (true or false).
- [User_prop_add_enum](by_function/User_prop_add_enum.md) — `user_prop_id = user_prop_add_enum(name, possible_values, default_value, description)` — user_prop_add_enum will add an additional user customizable setting to your instrument of the type string (enum).
- [User_prop_add_hardware_id](by_function/User_prop_add_hardware_id.md) — `user_prop_id = user_prop_add_hardware_id(name, default_value, description)` — user_prop_add_hardware_id will add an additional user customizable setting to your instrument of the type hardware ID.
- [User_prop_add_integer](by_function/User_prop_add_integer.md) — `user_prop_id = user_prop_add_integer(name, min, max, default_value, description)` — user_prop_add_integer will add an additional user customizable setting to your instrument of the type integer.
- [User_prop_add_percentage](by_function/User_prop_add_percentage.md) — `user_prop_id = user_prop_add_percentage(name, min, max, default_value, description)` — user_prop_add_percentage will add an additional user customizable setting to your instrument with a percentage type.
- [User_prop_add_real](by_function/User_prop_add_real.md) — `user_prop_id = user_prop_add_real(name, min, max, default_value, description)` — user_prop_add_real will add an additional user customizable setting to your instrument of the type float.
- [User_prop_add_string](by_function/User_prop_add_string.md) — `user_prop_id = user_prop_add_string(name, default_value, description)` — user_prop_add_string will add an additional user customizable setting to your instrument of the type string (text).
- [User_prop_add_table](by_function/User_prop_add_table.md) — `user_prop_id = user_prop_add_table(name, description, column_name, column_type, column_default_value, column_description, ...)` — user_prop_add_percentage will add an additional user customizable setting to your instrument with a table.
- [User_prop_get](by_function/User_prop_get.md) — `value = user_prop_get(user_prop_id)` — user_prop_get(user_prop_id) is used to get data from a a user property.

### Var (3 functions)

- [Var_cap](by_function/Var_cap.md) — `value = var_cap(value,min,max)` — var_cap is used to limit a value to a given minimum and maximum value.
- [Var_format](by_function/Var_format.md) — `value = var_format(value,decimals)` — var_format is used to round a number to a certain number of decimals and always shows that selected amount of decimals.
- [Var_round](by_function/Var_round.md) — `value = var_round(value,decimals)` — var_round is used to round a number to a certain number of decimals

### Variable (1 functions)

- [Variable_subscribe](by_function/Variable_subscribe.md) — `variable_subscribe(source,variable_name,type,...,callback_function)` — variable_subscribe is used to subscribe to more different data sources, such as X-Plane, FSX and SI variables.

### Video (3 functions)

- [Video_stream_add](by_function/Video_stream_add.md) — `video_stream_id = video_stream_add(key, x, y, width, height) video_stream_id = video_stream_add(key, x, y, width, height, tex_x, tex_y, tex_width, tex_height)` — video_stream_add is used to add a video stream to an instrument.
- [Video_stream_ext_add](by_function/Video_stream_ext_add.md) — `video_stream_id = video_stream_ext_add(tag, key, x, y, width, height) video_stream_id = video_stream_ext_add(tag, key, x, y, width, height, tex_x, tex_y, tex_width, tex_height)` — video_stream_add is used to add a custom video stream.
- [Video_stream_set](by_function/Video_stream_set.md) — `video_stream_id = video_stream_set(video_stream_id, key) video_stream_id = video_stream_set(video_stream_id, key, tex_x, tex_y, tex_width, tex_height)` — video_stream_set is used to change the texture or texture size of a video stream.

### Viewport (2 functions)

- [Viewport_rect](by_function/Viewport_rect.md) — `viewport_rect(node_id,x,y,width,height)` — viewport_rect makes a node visible within a specified frame.
- [Viewport_shape](by_function/Viewport_shape.md) — `viewport_shape(node_id, draw_fuction)` — viewport_shape makes a node visible within a specified shape.

### Xpl (5 functions)

- [Xpl_command](by_function/Xpl_command.md) — `xpl_command(commandref)` — xpl_command is used to send a command to X-Plane X-Plane uses commandrefs, these may be used to send commands to X-Plane.
- [Xpl_command_subscribe](by_function/Xpl_command_subscribe.md) — `xpl_command_subscribe(commandref,callback_function)` — xpl_command_subscribe is used to subscribe to a X-Plane command.
- [Xpl_connected](by_function/Xpl_connected.md) — `connected = xpl_connected()` — xpl_connected is used to check if there is an active connected with X-Plane.
- [Xpl_dataref_subscribe](by_function/Xpl_dataref_subscribe.md) — `xpl_dataref_subscribe(dataref,type,...,callback_function)` — xpl_dataref_subscribe is used to subscribe to one or more X-Plane datarefs.
- [Xpl_dataref_write](by_function/Xpl_dataref_write.md) — `xpl_dataref_write(dataref,type,value,offset,force)` — xpl_dataref_write is used write a dataref to X-Plane.

### Z (1 functions)

- [Z_order](by_function/Z_order.md) — `z_order(node_id, order)` — z_order is used to move an instrument or layer node to another Z order.

## Unprefixed API functions (16)

- [Arc](by_function/Arc.md) — `_arc(cx, cy, start_angle, end_angle, radius, direction)` — _arc is used to draw a arc line.
- [Circle](by_function/Circle.md) — `_circle(cx, cy, radius)` — _circle is used to draw a circle.
- [Ellipse](by_function/Ellipse.md) — `_ellipse(cx, cy, radius_x, radius_y)` — _ellipse is used to draw an ellipse.
- [Fill](by_function/Fill.md) — `_fill(color) _fill(color, opacity) _fill(r, g, b) (deprecated from AM/AP 4.0) _fill(r, g, b, opacity) (deprecated from AM/AP 4.0)` — _fill is used to apply all queued drawings into a fill (inside is a solid color).
- [Hole](by_function/Hole.md) — `_hole()` — _hole is used to mark that the shape we are going to define afterwards is a hole shape.
- [Log](by_function/Log.md) — `value = log(message, ...) value = log(type, message, ...)` — log is used to write a message to the Air Manager or Air Player log file
- [Move](by_function/Move.md) — `move(node_id, x) move(node_id, x, y) move(node_id, x, y, width) move(node_id, x, y, width, height) move(node_id, x, y, width, height, animation_type) (from AM/AP 4.0) move(node_id, x, y, width, height, animation_type, animation_speed) (from AM/AP 4.0)` — move is used to move an object.
- [Opacity](by_function/Opacity.md) — `opacity(node_id, opacity) opacity(node_id, opacity, animation_type) (from AM/AP 4.0) opacity(node_id, opacity, animation_type, animation_speed) (from AM/AP 4.0)` — opacity is used to change the opacity of a node (opaque -> transparent).
- [Rect](by_function/Rect.md) — `_rect(x, y, width, height) _rect(x, y, width, height, all_corners) _rect(x, y, width, height, top_left_corner, top_right_corner, bottom_left_corner, bottom_right_corner) (from AM/AP 3.6)` — _rect is used to draw a rectangle.
- [Remove](by_function/Remove.md) — `remove(node_id)` — remove is used to remove a node object.
- [Rotate](by_function/Rotate.md) — `rotate(node_id, degrees) rotate(node_id, degrees, anchor_x, anchor_y, anchor_z) rotate(node_id, degrees, animation_type, animation_speed) (from AM/AP 4.0) rotate(node_id, degrees, animation_type, animation_speed, animation_direction) (from AM/AP 4.0) rotate(node_id, degrees, anchor_x, anchor_y, anchor_z, animation_type, animation_speed, animation_direction) (from AM/AP 4.0)` — rotate is used to rotate an image, txt or canvas object.
- [Solid](by_function/Solid.md) — `_solid()` — _solid is used to mark that the shape we are going to define afterwards is a solid shape.
- [Stroke](by_function/Stroke.md) — `_stroke(color_name, line_width) _stroke(color_name, opacity, line_width) _stroke(color_hex, line_width) _stroke(r, g, b, line_width) _stroke(r, g, b, a, line_width)` — _stroke is used to apply all queued drawings into a stroke (line).
- [Triangle](by_function/Triangle.md) — `_triangle(x1, y1, x2, y2, x3, y3)` — _triangle is used to draw a triangle.
- [Txt](by_function/Txt.md) — `_txt(text, style, x, y) _txt(text, style, x, y, opacity)` — _txt is used to draw text within a canvas.
- [Visible](by_function/Visible.md) — `visible(node_id,visible)` — visible is used to make a node visible or invisible.

## Catalog pages (2)

- [Device_list](by_function/Device_list.md) — 17 entries.
- [Hardware_id_list](by_function/Hardware_id_list.md) — 12 entries.
