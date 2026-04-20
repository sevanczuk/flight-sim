user_prop_bg_id = user_prop_add_enum("Panel Background", "Grey,Black,Hidden", "Grey", "Select panel background")
user_prop_knobster = user_prop_add_boolean("Knobster button", false, "Use Knobster button to run starter")

--panel images
if user_prop_get(user_prop_bg_id) == "Grey" then
    img_add_fullscreen("sw_panel1.png")
elseif user_prop_get(user_prop_bg_id) == "Black" then
    img_add_fullscreen("sw_panel2.png")
else
    img_add_fullscreen("sw_panel_text_only2.png")
end

-- FUEL PUMP SWITCH
function fuel_pump_click_callback(position)

    fsx_event("TOGGLE_ELECT_FUEL_PUMP1")
    fs2020_event("TOGGLE_ELECT_FUEL_PUMP")
    fs2024_event("B:FUEL_PUMP_1",1 - position)

    if position == 0 then
        xpl_dataref_write("sim/cockpit/engine/fuel_pump_on", "INT[8]", {1})
    elseif position == 1 then
        xpl_dataref_write("sim/cockpit/engine/fuel_pump_on", "INT[8]", {0})
    end

end

fuel_pump_switch_id = switch_add("toggle_off.png", "toggle_on.png", 160,202,63,63,fuel_pump_click_callback)

function new_fuel_pump_switch_pos(pos)

    if pos[1] == 0 then
        switch_set_position(fuel_pump_switch_id, 0)
    elseif pos[1] == 1 then
        switch_set_position(fuel_pump_switch_id, 1)
    end
    
end    

function new_fuel_pump_switch_pos_fsx(sw_on)

    sw_on = fif(sw_on, 1, 0)
    new_fuel_pump_switch_pos({sw_on})

end

xpl_dataref_subscribe("sim/cockpit/engine/fuel_pump_on", "INT[8]",new_fuel_pump_switch_pos)
fsx_variable_subscribe("GENERAL ENG FUEL PUMP SWITCH:1", "Bool", new_fuel_pump_switch_pos_fsx)
fs2020_variable_subscribe("GENERAL ENG FUEL PUMP SWITCH:1", "Bool", new_fuel_pump_switch_pos_fsx)
fs2024_variable_subscribe("B:FUEL_PUMP_1", "Enum", function(pos)

    if pos == 0 then
        switch_set_position(fuel_pump_switch_id, 0)
    elseif pos == 1 then
        switch_set_position(fuel_pump_switch_id, 1)
    end

end)
-- END FUEL PUMP SWITCH

-- BEACON SWITCH
function beacon_click_callback(position)

    if position == 0 then
        xpl_dataref_write("sim/cockpit/electrical/beacon_lights_on","INT", 1)
        fsx_event("TOGGLE_BEACON_LIGHTS")
        msfs_event("TOGGLE_BEACON_LIGHTS")
    elseif position == 1 then
        xpl_dataref_write("sim/cockpit/electrical/beacon_lights_on","INT", 0)
        fsx_event("TOGGLE_BEACON_LIGHTS")
        msfs_event("TOGGLE_BEACON_LIGHTS")
    end

end

beacon_switch_id = switch_add("toggle_off.png", "toggle_on.png", 236,202,63,63,beacon_click_callback)

function new_beacon_switch_pos(sw_on)

    if sw_on == 0 then
        switch_set_position(beacon_switch_id, 0)
    elseif sw_on == 1 then
        switch_set_position(beacon_switch_id, 1)
    end
    
end    

function new_beacon_switch_pos_fsx(sw_on)

    sw_on = fif(sw_on, 1, 0)
    new_beacon_switch_pos(sw_on)

end

xpl_dataref_subscribe("sim/cockpit/electrical/beacon_lights_on","INT",new_beacon_switch_pos)
fsx_variable_subscribe("LIGHT BEACON", "Bool", new_beacon_switch_pos_fsx)
msfs_variable_subscribe("LIGHT BEACON ON", "Bool", new_beacon_switch_pos_fsx)
-- END BEACON SWITCH

-- LANDING LIGHT SWITCH
function landing_click_callback(position)

    if position == 0 then
        xpl_dataref_write("sim/cockpit/electrical/landing_lights_on","INT",1)
        fsx_event("LANDING_LIGHTS_ON")
        msfs_event("LANDING_LIGHTS_ON")
    elseif position == 1 then
        xpl_dataref_write("sim/cockpit/electrical/landing_lights_on","INT",0)
        fsx_event("LANDING_LIGHTS_OFF")
        msfs_event("LANDING_LIGHTS_OFF")
    end

end

landing_switch_id = switch_add("toggle_off.png", "toggle_on.png", 311,202,63,63,landing_click_callback)

function new_landing_switch_pos(sw_on)

    if sw_on == 0 then
        switch_set_position(landing_switch_id,0)
    elseif  sw_on == 1 then
        switch_set_position(landing_switch_id,1)
    end

end

function new_landing_switch_pos_fsx(sw_on)

    sw_on = fif(sw_on, 1, 0)
    new_landing_switch_pos(sw_on)
    
end

xpl_dataref_subscribe("sim/cockpit/electrical/landing_lights_on","INT", new_landing_switch_pos)
fsx_variable_subscribe("LIGHT LANDING", "Bool", new_landing_switch_pos_fsx)
msfs_variable_subscribe("LIGHT LANDING ON", "Bool", new_landing_switch_pos_fsx)
-- END LANDING LIGHT SWITCH

-- TAXI LIGHT SWITCH
function taxi_click_callback(position)

    if position == 0 then
        xpl_dataref_write("sim/cockpit/electrical/taxi_light_on","INT",1)
        fsx_event("TOGGLE_TAXI_LIGHTS")
        msfs_event("TOGGLE_TAXI_LIGHTS")
    elseif position == 1 then
        xpl_dataref_write("sim/cockpit/electrical/taxi_light_on","INT",0)
        fsx_event("TOGGLE_TAXI_LIGHTS")
        msfs_event("TOGGLE_TAXI_LIGHTS")
    end

end

taxi_switch_id = switch_add("toggle_off.png", "toggle_on.png",387,202,63,63, taxi_click_callback)

function new_taxi_switch_pos(sw_on)

    if sw_on == 0 then
        switch_set_position(taxi_switch_id,0)
    elseif  sw_on == 1 then
        switch_set_position(taxi_switch_id,1)
    end

end    

function new_taxi_switch_pos_fsx(sw_on)

    sw_on = fif(sw_on, 1, 0)
    new_taxi_switch_pos(sw_on)

end

xpl_dataref_subscribe("sim/cockpit/electrical/taxi_light_on","INT", new_taxi_switch_pos)
fsx_variable_subscribe("LIGHT TAXI", "Bool", new_taxi_switch_pos_fsx)
msfs_variable_subscribe("LIGHT TAXI", "Bool", new_taxi_switch_pos_fsx)
-- END TAXI LIGHT SWITCH

-- NAV LIGHTS SWITCH
function nav_click_callback(position)

    if position == 0 then
        xpl_dataref_write("sim/cockpit/electrical/nav_lights_on","INT",1)
        fsx_event("TOGGLE_NAV_LIGHTS")
        msfs_event("TOGGLE_NAV_LIGHTS")
    elseif position == 1 then
        xpl_dataref_write("sim/cockpit/electrical/nav_lights_on","INT",0)
        fsx_event("TOGGLE_NAV_LIGHTS")
        msfs_event("TOGGLE_NAV_LIGHTS")
    end

end

nav_switch_id = switch_add("toggle_off.png", "toggle_on.png", 463,202,63,63,nav_click_callback)

function new_nav_switch_pos(sw_on)

    if sw_on == 0 then
        switch_set_position(nav_switch_id,0)
    elseif  sw_on == 1 then
        switch_set_position(nav_switch_id,1)
    end

end    

function new_nav_switch_pos_fsx(sw_on)

    sw_on = fif(sw_on, 1, 0)
    new_nav_switch_pos(sw_on)

end

xpl_dataref_subscribe("sim/cockpit/electrical/nav_lights_on","INT", new_nav_switch_pos)
fsx_variable_subscribe("LIGHT NAV", "Bool", new_nav_switch_pos_fsx)
msfs_variable_subscribe("LIGHT NAV", "Bool", new_nav_switch_pos_fsx)
-- END NAV LIGHTS SWITCH

-- STROBE SWITCH
function strobe_click_callback(position)

    if position == 0 then
        xpl_dataref_write("sim/cockpit/electrical/strobe_lights_on","INT",1)
        fsx_event("STROBES_ON")
        msfs_event("STROBES_ON")
    elseif position == 1 then
        xpl_dataref_write("sim/cockpit/electrical/strobe_lights_on","INT",0)
        fsx_event("STROBES_OFF")
        msfs_event("STROBES_OFF")
    end

end

strobe_switch_id = switch_add("toggle_off.png", "toggle_on.png", 539,202,63,63,strobe_click_callback)

function new_strobe_switch_pos(sw_on)

    if sw_on == 0 then
        switch_set_position(strobe_switch_id,0)
    elseif  sw_on == 1 then
        switch_set_position(strobe_switch_id,1)
    end

end    

function new_strobe_switch_pos_fsx(sw_on)

    sw_on = fif(sw_on, 1, 0)
    new_strobe_switch_pos(sw_on)

end

xpl_dataref_subscribe("sim/cockpit/electrical/strobe_lights_on","INT", new_strobe_switch_pos)
fsx_variable_subscribe("LIGHT STROBE", "Bool", new_strobe_switch_pos_fsx)
msfs_variable_subscribe("LIGHT STROBE", "Bool", new_strobe_switch_pos_fsx)
-- END STROBE SWITCH

-- PITOT HEAT SWITCH
function pitot_click_callback(position)

    if position == 0 then
        xpl_dataref_write("sim/cockpit/switches/pitot_heat_on","INT",1)
        fsx_event("PITOT_HEAT_ON")
        msfs_event("PITOT_HEAT_ON")
    elseif position == 1 then
        xpl_dataref_write("sim/cockpit/switches/pitot_heat_on","INT",0)
        fsx_event("PITOT_HEAT_OFF")
        msfs_event("PITOT_HEAT_OFF")
    end

end

pitot_switch_id = switch_add("toggle_off.png", "toggle_on.png", 558,60,63,63,pitot_click_callback)

function new_pitot_switch_pos(sw_on)

    if sw_on == 0 then
        switch_set_position(pitot_switch_id,0)
    elseif  sw_on == 1 then
        switch_set_position(pitot_switch_id,1)
    end

end    

function new_pitot_switch_pos_fsx(sw_on)

    sw_on = fif(sw_on, 1, 0)
    new_pitot_switch_pos(sw_on)

end

xpl_dataref_subscribe("sim/cockpit/switches/pitot_heat_on","INT", new_pitot_switch_pos)
fsx_variable_subscribe("PITOT HEAT", "Bool", new_pitot_switch_pos_fsx)
msfs_variable_subscribe("PITOT HEAT", "Bool", new_pitot_switch_pos_fsx)
-- END PITOT HEAT SWITCH

-- ALTERNATOR SWITCH
function alt_click_callback(position)

    if position == 0 then
        xpl_command("sim/electrical/generators_toggle")
        fsx_event("TOGGLE_MASTER_ALTERNATOR")
        msfs_event("TOGGLE_MASTER_ALTERNATOR")
        if (not battery_sw_on) then fsx_event("TOGGLE_MASTER_BATTERY") end
    elseif position == 1 then
        xpl_command("sim/electrical/generators_toggle")
        fsx_event("TOGGLE_MASTER_ALTERNATOR")
        msfs_event("TOGGLE_MASTER_ALTERNATOR")
    end

end

alt_switch_id = switch_add("master_left_off.png", "master_left_on.png",237,24,58,130,alt_click_callback)

function new_alt_switch_pos(alt_on)

    if alt_on[1] == 0 then
        switch_set_position(alt_switch_id, 0)
    elseif alt_on[1] == 1 then
        switch_set_position(alt_switch_id, 1)
    end

end    

function new_alt_switch_pos_fsx(alt_on)

    new_alt_switch_pos({fif(alt_on, 1, 0)})
    
end

xpl_dataref_subscribe("sim/cockpit/electrical/generator_on", "INT[8]", new_alt_switch_pos)
fsx_variable_subscribe("GENERAL ENG GENERATOR SWITCH:1", "Bool", new_alt_switch_pos_fsx)
msfs_variable_subscribe("GENERAL ENG MASTER ALTERNATOR", "Bool", new_alt_switch_pos_fsx)
-- END ALTERNATOR SWITCH


-- BATTERY SWITCH
function bat_click_callback(position)

    if position == 0 then
        xpl_dataref_write("sim/cockpit/electrical/battery_on", "INT", 1)
        fsx_event("TOGGLE_MASTER_BATTERY")
        msfs_event("TOGGLE_MASTER_BATTERY")
    elseif position == 1 then
        xpl_dataref_write("sim/cockpit/electrical/battery_on", "INT", 0)
        fsx_event("TOGGLE_MASTER_BATTERY")
        msfs_event("TOGGLE_MASTER_BATTERY")
    end

end

bat_switch_id = switch_add("master_right_off.png", "master_right_on.png",295,24,58,130,bat_click_callback)

function new_bat_switch_pos(sw_on)

    if sw_on == 0 then
        switch_set_position(bat_switch_id, 0)
    elseif sw_on == 1 then
        switch_set_position(bat_switch_id, 1)
    end

end    

function new_bat_switch_pos_fsx(sw_on)

    new_bat_switch_pos(fif(sw_on, 1, 0) )
    battery_sw_on = sw_on
end

xpl_dataref_subscribe("sim/cockpit/electrical/battery_on", "INT", new_bat_switch_pos)
fsx_variable_subscribe("ELECTRICAL MASTER BATTERY", "Bool", new_bat_switch_pos_fsx)
msfs_variable_subscribe("ELECTRICAL MASTER BATTERY", "Bool", new_bat_switch_pos_fsx)
-- END BATTERY SWITCH

-- AVIONICS MASTER SWITCH
function avion_click_callback(position)

    fs2020_event("AVIONICS_MASTER_SET", 1 - position)
    fs2024_event("B:ELECTRICAL_LINE_BUS_1_TO_AVIONICS_BUS_1", 1 - position)
    xpl_dataref_write("sim/cockpit/electrical/avionics_on", "INT", 1 - position)

end

avion_switch_id = switch_add("white_ver_left_off.png", "white_ver_left_on.png",386,24,58,130,avion_click_callback)

function new_avion_switch_pos(sw_on)

    if sw_on == 0 then
        switch_set_position(avion_switch_id, 0)
    elseif  sw_on == 1 then
        switch_set_position(avion_switch_id, 1)
    end

end    

function new_avion_switch_pos_fsx(sw_on)

    new_avion_switch_pos(fif(sw_on, 1, 0) )
    
end

xpl_dataref_subscribe("sim/cockpit/electrical/avionics_on", "INT", new_avion_switch_pos)
fsx_variable_subscribe("AVIONICS MASTER SWITCH", "Bool", new_avion_switch_pos_fsx)
fs2020_variable_subscribe("AVIONICS MASTER SWITCH", "Bool", new_avion_switch_pos_fsx)
fs2024_variable_subscribe("B:ELECTRICAL_LINE_BUS_1_TO_AVIONICS_BUS_1", "Enum", new_avion_switch_pos)
-- END AVIONICS MASTER SWITCH


-- X-TIE SWITCH
function xtie_click_callback(position)

    fs2020_event("TOGGLE_AVIONICS_MASTER")
    fs2024_event("B:ELECTRICAL_LINE_BUS_2_TO_AVIONICS_BUS_2", 1 - position)
    xpl_dataref_write("sim/cockpit2/electrical/cross_tie", "INT", 1 - position)

end

xtie_switch_id = switch_add("white_ver_right_off.png", "white_ver_right_on.png",444,24,58,130,xtie_click_callback)

function new_xtie_switch_pos(sw_on)

    if sw_on == 0 then
        switch_set_position(xtie_switch_id, 0)
    elseif  sw_on == 1 then
        switch_set_position(xtie_switch_id, 1)
    end

end    

function new_xtie_switch_pos_fsx(sw_on)

    new_xtie_switch_pos(fif(sw_on, 1, 0) )
    
end

xpl_dataref_subscribe("sim/cockpit2/electrical/cross_tie", "INT", new_xtie_switch_pos)
fsx_variable_subscribe("AVIONICS MASTER SWITCH", "Bool", new_xtie_switch_pos_fsx)
fs2020_variable_subscribe("AVIONICS MASTER SWITCH", "Bool", new_xtie_switch_pos_fsx)
fs2024_variable_subscribe("B:ELECTRICAL_LINE_BUS_2_TO_AVIONICS_BUS_2", "Enum", new_xtie_switch_pos)
-- END X-TIE SWITCH

-- IGNITION KEY
img_add("key_ring.png", 31, 72, 125, 125)
ign_off = img_add("key_ctr_off.png",44,85,100,100)
ign_right = img_add("key_ctr_r.png",44,85,100,100)
ign_left = img_add("key_ctr_l.png",44,85,100,100)
ign_both = img_add("key_ctr_both.png",44,85,100,100)
ign_start = img_add("key_ctr_start.png",44,85,100,100)
visible(ign_off,true)
visible(ign_right,false)
visible(ign_left,false)
visible(ign_both,false)
visible(ign_start,false)

local ign_state = 0

function ignition_callback(ig_dir)

    --keep the switch position within bounds
    ign_state = var_cap(ign_state + ig_dir, 0, 4)

    --update sim with selected key switch state
    if ign_state == 0 then
        xpl_dataref_write("sim/cockpit2/engine/actuators/ignition_key", "INT[8]", {0}, 0)
     fsx_event("MAGNETO1_OFF")
     msfs_event("MAGNETO1_OFF")
    elseif ign_state == 1 then 
        xpl_dataref_write("sim/cockpit2/engine/actuators/ignition_key", "INT[8]", {1}, 0)
    if (ig_dir == -1) then fsx_event("MAGNETO1_LEFT") end
    if (ig_dir == -1) then msfs_event("MAGNETO1_LEFT") end
    fsx_event("MAGNETO1_RIGHT")
    msfs_event("MAGNETO1_RIGHT")
    elseif ign_state == 2 then 
        xpl_dataref_write("sim/cockpit2/engine/actuators/ignition_key", "INT[8]", {2}, 0)
    if (ig_dir == 1) then
            fsx_event("MAGNETO1_RIGHT")
            msfs_event("MAGNETO1_RIGHT")
            fsx_event("MAGNETO1_LEFT")
            msfs_event("MAGNETO1_LEFT")
    elseif (ig_dir == -1) then
            fsx_event("MAGNETO1_RIGHT")
            msfs_event("MAGNETO1_RIGHT")
        end
    elseif ign_state == 3 then 
        xpl_dataref_write("sim/cockpit2/engine/actuators/ignition_key", "INT[8]", {3}, 0)
    fsx_event("MAGNETO1_BOTH")
    msfs_event("MAGNETO1_BOTH")
    elseif ign_state == 4 then 
        --force start
        xpl_dataref_write("sim/cockpit2/engine/actuators/ignition_key", "INT[8]", {4}, 0, true)
    fsx_event("MAGNETO1_START")
    msfs_event("MAGNETO1_START")
    end

end

function ignition_button_pressed()
    if ign_state == 3 then
        xpl_command("sim/starters/engage_starter_1", 1)
        fsx_event("MAGNETO1_START")
        msfs_event("MAGNETO1_START")
    end
end

function ignition_button_released()
    xpl_command("sim/starters/engage_starter_1", 0)
    if ign_state == 4 then
        fsx_event("MAGNETO1_BOTH")
        msfs_event("MAGNETO1_BOTH")
    end
end

function key_pressed()
    --do nothing
end

function key_released()
    --disable start forcing when released from start position
    if (ign_state == 4) then xpl_dataref_write("sim/cockpit2/engine/actuators/ignition_key", "INT[8]", {3}, 0, false) end
end


ignition_sw = dial_add(nil,44,85,100,100,ignition_callback, key_pressed, key_released)
if user_prop_get(user_prop_knobster) then
    button_add(nil,nil,44,85,100,100,ignition_button_pressed, ignition_button_released)
end

function new_ignition(ign_pos)
    visible(ign_off, ign_pos[1] == 0)
    visible(ign_right, ign_pos[1] == 1)
    visible(ign_left, ign_pos[1] == 2)
    visible(ign_both, ign_pos[1] == 3)
    visible(ign_start, ign_pos[1] == 4)
    ign_state = ign_pos[1]
end

function new_ignition_fsx(left_state, right_state, start_state)

    if (not left_state and not right_state) then
        ign_pos = 0 --off
    elseif (not left_state and right_state) then
        ign_pos = 1 -- right
    elseif (left_state and not right_state) then
        ign_pos = 2 --left
    elseif (left_state and right_state and not start_state) then
        ign_pos = 3 --both
    elseif (left_state and right_state and start_state) then
        ign_pos = 4 --start
    end
    new_ignition({ign_pos})

end

xpl_dataref_subscribe("sim/cockpit2/engine/actuators/ignition_key", "INT[8]", new_ignition)
fsx_variable_subscribe("RECIP ENG LEFT MAGNETO:1", "Bool",
                       "RECIP ENG RIGHT MAGNETO:1", "Bool",
                       "GENERAL ENG STARTER:1", "Bool", new_ignition_fsx)
msfs_variable_subscribe("RECIP ENG LEFT MAGNETO:1", "Bool",
                          "RECIP ENG RIGHT MAGNETO:1", "Bool",
                          "GENERAL ENG STARTER:1", "Bool", new_ignition_fsx)                       
-- END IGNITION KEY