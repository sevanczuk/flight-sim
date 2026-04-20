prop_source = user_prop_add_enum("Source", "Simulator,Local", "Simulator", "Choose the time source")
prop_local  = user_prop_add_enum("Local hobbs", "Total,Current", "Total", "Show current hobbs or total")
prop_count  = user_prop_add_boolean("Count total", true, "Count total when showing current hobbs or simulator?")
persist_local_hobbs = persist_add("localhobbs", 0)

img_back_light_off = img_add_fullscreen("background.png")
img_back_light_on = img_add_fullscreen("background_light.png", "visible:false")
img_hg = img_add("hourglass.png", 173, 156, 22, 42)
txt_whole = txt_add("0", "size:75; color: #000000; halign:right", -214, 141, 610, 200)
txt_dot = txt_add(".", "size:75; color: #000000; halign:right", -190, 141, 610, 200)
txt_fract = txt_add("0", "size:75; color: #000000; halign:right", -166, 141, 610, 200)

group_items = group_add(img_hg, txt_whole, txt_dot, txt_fract)
visible(group_items, user_prop_get(prop_source) == "Local")

xpl_dataref_subscribe("sim/time/hobbs_time", "FLOAT", 
                      "sim/cockpit2/electrical/bus_volts", "FLOAT[6]", 
                      "sim/cockpit/electrical/cockpit_lights_on", "INT", function(hobbs_time, bus_volts, lights)

    if user_prop_get(prop_source) == "Simulator" then                 
        visible(group_items, bus_volts[1] >= 8)
        visible(img_back_light_on, bus_volts[1] >= 8 and lights == 1)

        local fract = math.floor((hobbs_time % 3600) / 360)
        txt_set(txt_fract, string.format("%.0f", fract) )
    
        local hours = math.floor(hobbs_time / 3600)
        txt_set(txt_whole, string.format("%.0f", hours) )
    end
    
end)

fsx_variable_subscribe("GENERAL ENG ELAPSED TIME:1", "Seconds", 
                       "ELECTRICAL MAIN BUS VOLTAGE", "Volts", 
                       "LIGHT PANEL", "Bool", function(hobbs_time, bus_volts, lights)

    if user_prop_get(prop_source) == "Simulator" then                 
        visible(group_items, bus_volts >= 8)
        visible(img_back_light_on, bus_volts >= 8 and lights)

        local fract = math.floor((hobbs_time % 3600) / 360)
        txt_set(txt_fract, string.format("%.0f", fract) )
    
        local hours = math.floor(hobbs_time / 3600)
        txt_set(txt_whole, string.format("%.0f", hours) )
    end
    
end)

fs2020_variable_subscribe("GENERAL ENG ELAPSED TIME:1", "Seconds", 
                          "ELECTRICAL MAIN BUS VOLTAGE", "Volts", 
                          "LIGHT PANEL", "Bool", function(hobbs_time, bus_volts, lights)

    if user_prop_get(prop_source) == "Simulator" then                 
        visible(group_items, bus_volts >= 8)
        visible(img_back_light_on, bus_volts >= 8 and lights)

        local fract = math.floor((hobbs_time % 3600) / 360)
        txt_set(txt_fract, string.format("%.0f", fract) )
    
        local hours = math.floor(hobbs_time / 3600)
        txt_set(txt_whole, string.format("%.0f", hours) )
    end
    
end)

fs2024_variable_subscribe("GENERAL ENG ELAPSED TIME:1", "Seconds", 
                          "ELECTRICAL BUS VOLTAGE:1", "Volts", 
                          "LIGHT PANEL", "Bool", function(hobbs_time, bus_volts, lights)

    if user_prop_get(prop_source) == "Simulator" then                 
        visible(group_items, bus_volts >= 8)
        visible(img_back_light_on, bus_volts >= 8 and lights)

        local fract = math.floor((hobbs_time % 3600) / 360)
        txt_set(txt_fract, string.format("%.0f", fract) )
    
        local hours = math.floor(hobbs_time / 3600)
        txt_set(txt_whole, string.format("%.0f", hours) )
    end
    
end)

timer_start(nil, 1000, function(timer_sec)

    if user_prop_get(prop_count) then
        persist_put(persist_local_hobbs, persist_get(persist_local_hobbs) + 1)
    end 

    if user_prop_get(prop_source) == "Local" and user_prop_get(prop_source) == "Current" then                 
        local fract = math.floor((timer_sec % 3600) / 360)
        txt_set(txt_fract, string.format("%.0f", fract) )
    
        local hours = math.floor(timer_sec / 3600)
        txt_set(txt_whole, string.format("%.0f", hours) )
    elseif user_prop_get(prop_source) == "Local" and user_prop_get(prop_source) == "Total" then
        local fract = math.floor((persist_get(persist_local_hobbs) % 3600) / 360)
        txt_set(txt_fract, string.format("%.0f", fract) )
    
        local hours = math.floor(persist_get(persist_local_hobbs) / 3600)
        txt_set(txt_whole, string.format("%.0f", hours) )
    end

end)
