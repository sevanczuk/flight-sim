-- Global variables --
local persist_power = persist_add("power", 2)
local gbl_power  = 0
local gbl_dist1  = 0
local gbl_speed1 = 0
local gbl_dist2  = 0
local gbl_speed2 = 0
local update_gui = nil

-- Button functions --
function new_state(state, direction)
    -- Set the new state of the switch and remember this
    switch_set_position(dme_switch, state + direction)
    persist_put(persist_power, state + direction)
    update_gui()
end

-- Add images in Z-order --
img_add_fullscreen("background.png")

-- Add text  in Z-order --
txt_naut = txt_add(" ", "size:34px; color: #fb2c00; halign: right;", 10, 30, 125, 150)
txt_nm = txt_add("NM", "size:20px; font:GOST Common.ttf; color: #fb2c00; halign: left;", 135, 42, 50, 50)
txt_nav1 = txt_add("1", "size:22px; font:GOST Common.ttf; color: #fb2c00; halign: left;", 175, 50, 50, 50)
txt_nav2 = txt_add("2", "size:22px; font:GOST Common.ttf; color: #fb2c00; halign: left;",175, 30, 50, 50)

txt_knots = txt_add(" ", "size:34px; color: #fb2c00; halign: right;", 170, 30, 150, 150)
txt_kt = txt_add("KT", "size:20px; font:GOST Common.ttf; color: #fb2c00; halign: left;", 322, 42, 50, 50)

txt_mn = txt_add(" ", "size:34px; color: #fb2c00; halign: right;", 318, 30, 150, 150)
txt_min = txt_add("MIN", "size:20px; font:GOST Common.ttf; color: #fb2c00; halign: left;", 470, 42, 50, 50)

-- Add a group --
group_text = group_add(txt_naut, txt_nm, txt_knots, txt_kt, txt_mn, txt_min)
visible(group_text, false)

-- Functions --
function update_gui()

    -- Get the state of the power switch
    selected = math.floor(persist_get(persist_power))

    -- print(selected)
    -- print(selected)
    -- Turn DME and off (make text visible and invisible)
    visible(group_text, gbl_power and selected < 2)

    -- Are we seeing data from DME1 or DME2?
    visible(txt_nav1, selected == 0 and gbl_power)
    visible(txt_nav2, selected == 1 and gbl_power)
    
    -- Set distance
    if selected == 0 then
        distance = var_cap(gbl_dist1, 0, 389)
    elseif selected == 1 then
        distance = var_cap(gbl_dist2, 0, 389)
    else
        distance = 0
    end

    if distance < 100 then
        txt_set(txt_naut, string.format("%04.01f", distance) )
    else
        txt_set(txt_naut, string.format("%03.0f", distance) )
    end
    
    -- Set speed
    if selected == 0 then
        speed = var_cap(gbl_speed1, 0, 999)
    elseif selected == 1 then
        speed = var_cap(gbl_speed2, 0, 999)
    else
        speed = 0
    end
    
    txt_set(txt_knots, string.format("%02.0f", speed) )
    
    -- Set time in minutes (dataref time is in seconds)
    if selected == 0 and speed > 0 then
        minutes = var_cap(gbl_dist1 / gbl_speed1 * 60, 0, 99)
    elseif selected == 1 and speed > 0 then
        minutes = var_cap(gbl_dist2 / gbl_speed2 * 60, 0, 99)
    else
        minutes = 0
    end
    
    txt_set(txt_mn, string.format("%.0f", minutes) )

end

function new_data_xpl(dist1, speed1, dist2, speed2, avionics, bus_volts)

    -- Do we have power?
    gbl_power = avionics == 1 and bus_volts[1] >= 8
    
    -- Make everything global
    gbl_dist1  = dist1
    gbl_speed1 = speed1
    gbl_dist2  = dist2
    gbl_speed2 = speed2
    
    update_gui()

end

function new_data_fsx(dist1, speed1, dist2, speed2, avionics)

    -- Do we have power?
    gbl_power = avionics

    -- Make everything global
    gbl_dist1  = dist1
    gbl_speed1 = speed1
    gbl_dist2  = dist2
    gbl_speed2 = speed2
    
    update_gui()
    
end

-- Switch add --
dme_switch = switch_add("knob_dn.png", "knob_up.png", "knob_off.png", 582, 31, 64, 64, new_state)
hw_switch_add("Source selector", 3, function(position)
    switch_set_position(dme_switch, position)
    persist_put(persist_power, position)
    update_gui()
end)
switch_set_position(dme_switch, persist_get(persist_power) )

-- Subscribe to data --
xpl_dataref_subscribe("sim/cockpit/radios/nav1_dme_dist_m", "FLOAT", 
                      "sim/cockpit/radios/nav1_dme_speed_kts", "FLOAT",
                      "sim/cockpit/radios/nav2_dme_dist_m", "FLOAT", 
                      "sim/cockpit/radios/nav2_dme_speed_kts", "FLOAT",
                      "sim/cockpit/electrical/avionics_on", "INT",
                      "sim/cockpit2/electrical/bus_volts", "FLOAT[6]", new_data_xpl)
fsx_variable_subscribe("NAV DME:1", "nautical mile",
                       "NAV DMESPEED:1", "Knots",
                       "NAV DME:2", "nautical mile",
                       "NAV DMESPEED:2", "Knots",
                       "CIRCUIT AVIONICS ON", "Bool", new_data_fsx)
msfs_variable_subscribe("NAV DME:1", "nautical mile",
                          "NAV DMESPEED:1", "Knots",
                          "NAV DME:2", "nautical mile",
                          "NAV DMESPEED:2", "Knots",
                          "CIRCUIT AVIONICS ON", "Bool", new_data_fsx)                       
update_gui()