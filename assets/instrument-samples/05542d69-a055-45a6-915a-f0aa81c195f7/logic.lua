---------------------------------------------
--           Airspeed Indicator            --
-- Modification of Jason Tatum's original  --
-- Brian McMullan 20180324                 -- 
-- Property for background off/on          --
-- Property for dimming overlay            --
---------------------------------------------

---------------------------------------------
--   Properties                            --
---------------------------------------------
prop_BG = user_prop_add_boolean("Background Display",true,"Display background")
prop_DO = user_prop_add_boolean("Dimming Overlay",false,"Use Dimming overlay")

---------------------------------------------
--   Load and display images in Z-order    --
--   Loaded images selectable with prop    --
---------------------------------------------
as_card = img_add_fullscreen("aircard.png", "rotate_animation_type: LOG; rotate_animation_speed: 0.08; rotate_animation_direction: FASTEST")
if user_prop_get(prop_BG) == false then
    img_add_fullscreen("airspeed.png")
    img_add_fullscreen("Bezel.png")    
else
    img_add_fullscreen("airspeedwBG.png")
end    
as_needle =  img_add("needle.png",0,0,512,512, "rotate_animation_type: LOG; rotate_animation_speed: 0.08")
img_add("airknobshadow.png",31,400,85,85)
card = 0
if user_prop_get(prop_DO) == true then
    img_add_fullscreen("dimoverlay.png")
end
--img_add_fullscreen("scratches.png")
---------------------------------------------
--   Functions                             --
---------------------------------------------
function new_speed(speed)

    speed = var_cap(speed, 0, 220)

    if speed >= 160 then
        rotate(as_needle,266 + ((speed-160)*1.3))
    elseif speed >= 120 then
        rotate(as_needle,205 + ((speed-120)*1.525))
    elseif speed >= 100 then
        rotate(as_needle,162 + ((speed-100)*2.15))
    elseif speed >= 70 then
        rotate(as_needle,92 + ((speed-70)*2.29))
    elseif speed >= 40 then
        rotate(as_needle,31 + ((speed-40)*2.033))
    else
        rotate(as_needle, (speed*0.775))
    end
    
end

function new_speed_fsx(speed_FSX, speed_A2A)

    speed = fif(speed_A2A > 0, speed_A2A, speed_FSX)
    
    new_speed(speed)
    
end

-- This function isn't setup yet.  FSX doesn't appear
-- to expose this value.  X-Plane might expose it as 
-- sim/aircraft/view/acf_asi_kts    int    y    enum    air speed indicator knots calibration
-- but I have not tested it.  For now, we just allow manual manipulation on the screen by 
-- clicking on the knob.
function new_cali(degrees)
    rotate(as_card, degrees)
end

function new_knob(value)
    card = card + value
    if card > 48 then
        card = 49
    end
    if card < -135 then
        card = -135
    end

    card = var_cap(card, -65, 16)
    rotate(as_card, card)
end

---------------------------------------------
--   Controls Add                          --
---------------------------------------------
dial_knob = dial_add("airknob.png", 31, 395, 85, 85, new_knob)
dial_click_rotate(dial_knob,6)
-- Detent settings
detent_settings = {}
detent_settings["1 detent/pulse"]  = "TYPE_1_DETENT_PER_PULSE"
detent_settings["2 detents/pulse"] = "TYPE_2_DETENT_PER_PULSE"
detent_settings["4 detents/pulse"] = "TYPE_4_DETENT_PER_PULSE"
detent_setting = user_prop_add_enum("Detent setting", "1 detent/pulse,2 detents/pulse, 4 detents/pulse", "2 detents/pulse", "Select your rotary encoder type")
hw_dial_add("KIAS/TAS card dial", detent_settings[user_prop_get(detent_setting)], 3, new_knob)
---------------------------------------------
--   Simulator Subscriptions               --
---------------------------------------------
xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/airspeed_kts_pilot", "FLOAT", new_speed)

fsx_variable_subscribe("AIRSPEED INDICATED", "knots", 
                       "L:AirspeedIndicatedNeedle", "number", new_speed_fsx)

msfs_variable_subscribe("AIRSPEED INDICATED", "knots",
                        "L:AirspeedIndicatedNeedle", "number", new_speed_fsx)
---------------------------------------------
-- END       Airspeed Indicator            --
---------------------------------------------
