-----------------------------------------------------------------
--   Attitude Indicator, Vacuum driven                         --
-- Modification of Jason Tatum's original                      --
-- Brian McMullan 20180327                                     -- 
-- Property for background off/on                              --
-- Property for dimming overlay                                --
-- Property for Pilot or Co-pilot                              --
-----------------------------------------------------------------

---------------------------------------------
--   Properties                            --
---------------------------------------------
prop_BG = user_prop_add_boolean("Background",true,"Display background?")
prop_DO = user_prop_add_boolean("Dimming overlay",false,"Enable dimming overlay?")
prop_Vx = user_prop_add_enum("X-Plane Pilot or Co-Pilot","PILOT,CO-PILOT","PILOT","Is this the pilot or co-pilot attitude indicator")

---------------------------------------------
--   Load and display images in Z-order    --
--   Loaded images selectable with prop    --
---------------------------------------------
img_bg = img_add_fullscreen("attbg.png")
img_horizon = img_add_fullscreen("attitude_horizon.png")
img_bankind = img_add_fullscreen("attroll.png")
img_hoop = img_add_fullscreen("atthoop.png")
img_flag = img_add("FailFlag.png", -124, -186, 512, 512)
rotate(img_flag, -30)
if user_prop_get(prop_BG) == false then
    img_add_fullscreen("attitude.png")
else
    img_add_fullscreen("attitudewBG.png")
end    

img_add_fullscreen("Bezel.png")
if user_prop_get(prop_DO) == true then
    img_add_fullscreen("dimoverlay.png")
end

local gbl_hoop_height = 0

---------------------------------------------
--   Functions                             --
---------------------------------------------

function new_attitude_xpl(roll1, roll2, pitch1, pitch2, hoop)

    -- Make hoop height global
    gbl_hoop_height = hoop
    
    -- Move the hoop
    move(img_hoop, nil, hoop * -2.4, nil, nil)
    
    
    -- Pitch and roll source
    local roll  = fif(user_prop_get(prop_Vx) == "PILOT", roll1, roll2)
    local pitch = fif(user_prop_get(prop_Vx) == "PILOT", pitch1, pitch2)

    -- Roll outer ring
    roll = var_cap(roll, -60, 60)
    rotate(img_bankind, roll *-1)
    rotate(img_bg, roll *-1)

    -- Roll horizon
    rotate(img_horizon  , roll * -1)

    -- Move horizon pitch
    pitch = var_cap(pitch, -25, 25)
    radial = math.rad(roll * -1)
    x = -(math.sin(radial) * pitch * 2.5)
    y = (math.cos(radial) * pitch * 2.5)
    move(img_horizon, x, y, nil, nil)

end

function new_attitude_fsx(roll, pitch, hoop)

    -- Move the hoop
    move(img_hoop, nil, hoop * -0.5, nil, nil)
    
    -- Roll outer ring
    roll = var_cap(roll, -60, 60)
    rotate(img_bankind, roll)
    rotate(img_bg, roll)

    -- Roll horizon
    rotate(img_horizon, roll)

    -- Move horizon pitch
    pitch = var_cap(pitch * -1, -25, 25)
    radial = math.rad(roll)
    x = -(math.sin(radial) * pitch * 2.5)
    y = (math.cos(radial) * pitch * 2.5)
    move(img_horizon, x, y, nil, nil)

end

function new_vac(vac1, vac2)

    local vac  = fif(user_prop_get(prop_Vx) == "PILOT", vac1, vac2)
    if vac <= 1 then
        rotate(img_flag, -30, "LOG", 0.008)
    else
        rotate(img_flag, -2, "LOG", 0.008)
    end

end

function new_knob(value)
    -- X-Plane
    xpl_dataref_write("sim/cockpit/misc/ah_adjust", "FLOAT", var_cap(gbl_hoop_height + (value * 0.5), -30, 30) )
    -- FSX / FS2020
    if value == 1 then
        fsx_event("ATTITUDE_BARS_POSITION_UP")
        msfs_event("ATTITUDE_BARS_POSITION_UP")
    else
        fsx_event("ATTITUDE_BARS_POSITION_DOWN")
        msfs_event("ATTITUDE_BARS_POSITION_DOWN")
    end
end

---------------------------------------------
--   Controls Add                          --
---------------------------------------------
dial_knob = dial_add("airknob.png", 213, 395, 85, 85, new_knob)
dial_click_rotate(dial_knob,6)
hw_dial_add("Hoop height dial", 2, new_knob)

---------------------------------------------
--   Simulator Subscriptions               --
---------------------------------------------
xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/roll_vacuum_deg_pilot", "FLOAT",
                      "sim/cockpit2/gauges/indicators/roll_vacuum_deg_copilot", "FLOAT",
                      "sim/cockpit2/gauges/indicators/pitch_vacuum_deg_pilot", "FLOAT", 
                      "sim/cockpit2/gauges/indicators/pitch_vacuum_deg_copilot", "FLOAT", 
                      "sim/cockpit/misc/ah_adjust", "FLOAT", new_attitude_xpl)
                    
xpl_dataref_subscribe("sim/cockpit/misc/vacuum", "FLOAT", 
                      "sim/cockpit/misc/vacuum2", "FLOAT", new_vac)
                      
fsx_variable_subscribe("ATTITUDE INDICATOR BANK DEGREES", "Degrees",
                       "ATTITUDE INDICATOR PITCH DEGREES", "Degrees", 
                       "ATTITUDE BARS POSITION", "Percent", new_attitude_fsx)
                       
fsx_variable_subscribe("SUCTION PRESSURE", "Inches of Mercury",
                       "SUCTION PRESSURE", "Inches of Mercury", new_vac)         

msfs_variable_subscribe("ATTITUDE INDICATOR BANK DEGREES", "Degrees",
                        "ATTITUDE INDICATOR PITCH DEGREES", "Degrees", 
                        "ATTITUDE BARS POSITION", "Percent", new_attitude_fsx)
                       
msfs_variable_subscribe("SUCTION PRESSURE", "Inches of Mercury", 
                        "SUCTION PRESSURE", "Inches of Mercury", new_vac)   
                       
---------------------------------------------
-- END    Attitude                         --
---------------------------------------------                       