---------------------------------------------
--             EGT & Fuel Flow             --
-- Modification of Jason Tatum's original  --
-- Brian McMullan 20180324                 -- 
-- 20180711 fixed EGT needle for XP        -- 
-- Property for background off/on          --
-- Property for dimming overlay            --
---------------------------------------------

---------------------------------------------
--   Properties                            --
---------------------------------------------
prop_BG = user_prop_add_boolean("Background Display",true,"Show background?")
prop_DO = user_prop_add_boolean("Dimming Overlay",false,"Enable dimming overlay?")
prop_EGT = user_prop_add_integer("EGT maximum", 500, 5000, 2000, "Maximum EGT setting")
persist_max_egt = persist_add("egt_max", 0)
---------------------------------------------
--   Load and display images in Z-order    --
--   Loaded images selectable with prop    --
---------------------------------------------
img_add_fullscreen("EGT.png")
img_egt = img_add("needle3.png", -150, 0, 512, 512)
img_ff = img_add("needle3.png", 150, 0, 512, 512)
img_ref = img_add("egtref.png", -150, 0, 512, 512)
if user_prop_get(prop_BG) == false then
    img_add_fullscreen("EGTCover.png")
else
    img_add_fullscreen("EGTCoverwBG.png")
end    
persist_id = persist_add("egtref", "INT", 70)
if user_prop_get(prop_DO) == true then
    img_add_fullscreen("dimoverlay.png")
end
-----------------------------------------
-- Init, default visibility & rotation --
-----------------------------------------
-- get value
local refdegree = persist_get(persist_id)
rotate(img_ref, 145-refdegree)
rotate(img_egt, 145)
rotate(img_ff, -148)

---------------------------------------------
--   Functions                             --
---------------------------------------------
function new_egtref(value)
    refdegree = var_cap(refdegree - value, -15, 120)
    rotate(img_ref, 145 - refdegree)
    persist_put(persist_id, refdegree)
end

function new_egt_max(direction)
    persist_put(persist_max_egt, persist_get(persist_max_egt) - (direction * 10) )
end


function new_values(bus_volts, temp_xpl, flow_xpl, flow_afl, temp_afl)

    local far = 0

    if bus_volts[1] >= 10 and temp_afl == 0 then
        -- Temp_afl is always zero, only C returned from XPlane...
        -- EGT range is roughly 700C low to 1400C high
        far = temp_xpl[1]

        -- Pounds per hour
        lbh = flow_xpl[1] * 7936.64144
        -- Gallons per hours
        gph = lbh / 6.01
        gph = var_cap(gph, 0, 19)

    elseif bus_volts[1] >= 10 and temp_afl > 0 then
        far = temp_afl
        gph = var_cap(flow_afl, 0, 19)
    else
        far = 25
        gph = 0
    end
    
    -- Map the Celcius temp value with limits to angle for needle
    far = var_cap(far, (user_prop_get(prop_EGT) + persist_get(persist_max_egt)) - 400, user_prop_get(prop_EGT) + persist_get(persist_max_egt)) 
    rotate(img_egt, var_cap(110 / 400 * (far - ((user_prop_get(prop_EGT) + persist_get(persist_max_egt)) - 400)) * -1 + 145, 35, 145) )
  
    if (gph <= 5) then
        rotate(img_ff , 212 + (gph * 1.6))
    else
        rotate(img_ff , 220 + ((gph-5) * 7.7))
    end
    
end


function new_values_fsx(bus_volts, tempfsx, gallonsfsx, ffa2a, tempa2a)

    if ffa2a ~= 0 then
        selected_gph = ffa2a
    else
        selected_gph = gallonsfsx
    end
    
    if tempa2a ~= 0 then
        selected_far = tempa2a - 1150
    else
        selected_far = tempfsx - 925
    end

    if bus_volts >= 10 then
        far = selected_far
        gph = selected_gph
    else
        far = 25
        gph = 0
    end
    
    -- Map the Celcius temp value with limits to angle for needle
    far = var_cap(far, (user_prop_get(prop_EGT) + persist_get(persist_max_egt)) - 400, user_prop_get(prop_EGT) + persist_get(persist_max_egt)) 
    rotate(img_egt, var_cap(110 / 400 * (far - ((user_prop_get(prop_EGT) + persist_get(persist_max_egt)) - 400)) * -1 + 145, 35, 145) )
    
    if (gph <= 5) then
        rotate(img_ff , 212 + (gph * 1.6))
    else
        rotate(img_ff , 220 + ((gph-5) * 7.7))
    end    

end

---------------------------------------------
-- Switches, buttons and dials             --
---------------------------------------------
dial_knob = dial_add("egtrefknob.png", 21, 181, 150, 150, 3, new_egtref)
dial_egt_max = dial_add(nil, 345, 181, 150, 150, 3, new_egt_max)
dial_click_rotate(dial_knob, 4)
hw_dial_add("EGT reference dial", 3, new_egtref)
---------------------------------------------
--   Simulator Subscriptions               --
---------------------------------------------                      
xpl_dataref_subscribe("sim/cockpit2/electrical/bus_volts", "FLOAT[6]",
                      "sim/cockpit2/engine/indicators/EGT_deg_C","FLOAT[8]", 
                      "sim/flightmodel/engine/ENGN_FF_","FLOAT[8]",
                      "172/instruments/fuel_flow_GPH", "FLOAT",
                      "172/instruments/EGT_F", "FLOAT", new_values)

fsx_variable_subscribe("ELECTRICAL MAIN BUS VOLTAGE", "Volts",
                       "GENERAL ENG EXHAUST GAS TEMPERATURE:1", "fahrenheit", 
                       "ENG FUEL FLOW GPH:1", "Gallons per hour",
                       "L:Eng1_GPH", "gallons",
                       "L:Eng1_EGTGauge", "number", new_values_fsx)
                       
msfs_variable_subscribe("ELECTRICAL MAIN BUS VOLTAGE", "Volts",
                          "GENERAL ENG EXHAUST GAS TEMPERATURE:1", "fahrenheit", 
                          "ENG FUEL FLOW GPH:1", "Gallons per hour",
                          "L:Eng1_GPH", "gallons",
                          "L:Eng1_EGTGauge", "number", new_values_fsx)                       
---------------------------------------------
--   END                                   --
---------------------------------------------                            