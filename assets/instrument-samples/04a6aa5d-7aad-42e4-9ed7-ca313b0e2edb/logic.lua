---------------------------------------------
--           ADF gauge                     --
-- Modification of Jason Tatum's original  --
-- Brian McMullan 2018324                  -- 
-- Property for background off/on          --
-- Property for dimming overlay            --
-- Property for single needle RMI          --
-- Russ Green 26.05.20                     --
-- Property for approximated ADF dip       --
---------------------------------------------

---------------------------------------------
--   Properties                            --
---------------------------------------------
prop_BG = user_prop_add_boolean("Background Display",true,"Display background")
prop_DO = user_prop_add_boolean("Dimming Overlay",false,"Use Dimming overlay")
prop_RMI = user_prop_add_boolean("RMI",false,"Use as a single needle RMI")

prop_DIP = user_prop_add_boolean("Approximate Dip",false,"Approximate ADF dip (X-Plane only)")
prop_DIPAng = user_prop_add_integer("Dip Amount",0, 20, 10, "Maximum amount needle will dip towards low wing")

--variables used with moving the needle slowly
local current_bearing = 90
local target_bearing = 0
local factor = 0.26 --from macnfly Beechcraft RMI

---------------------------------------------
--   Load and display images in Z-order    --
--   Loaded images selectable with prop    --
---------------------------------------------
if user_prop_get(prop_BG) == false then
    img_add_fullscreen("ADF.png")
else
    img_add_fullscreen("ADFwBG.png")
end  
rose = img_add_fullscreen("OBScard.png", "rotate_animation_type: LOG; rotate_animation_speed: 0.08; rotate_animation_direction: FASTEST")
yellow_needle = img_add_fullscreen("ADFneedle.png")
img_add_fullscreen("ADFcover.png")
if user_prop_get(prop_DO) == true then
    img_add_fullscreen("dimoverlay.png")
end
if user_prop_get(prop_RMI) == false then
    img_add("adfknobshadow.png",33, 400,85,85)
end

---------------------------------------------
--   Functions                             --
---------------------------------------------
function new_rotation(rotation)
    if user_prop_get(prop_RMI) == true then
        rotate(rose, rotation * -1)
    end
end

function new_hdg(hdg)
    if user_prop_get(prop_RMI) == false then
        if hdg == 1 then
            xpl_command("sim/radios/adf1_card_down")
            fsx_event("ADF_CARD_DEC")
            msfs_event("ADF_CARD_DEC")
        elseif hdg == -1 then
            xpl_command("sim/radios/adf1_card_up")
            fsx_event("ADF_CARD_INC")
            msfs_event("ADF_CARD_INC")
        end
    end
end

function new_adf(heading, adfyellow)
    if user_prop_get(prop_DIP) == false then
        if user_prop_get(prop_RMI) == false then
            rotate(rose, heading* -1)
        end
        
        if adfyellow > 89.5 and adfyellow < 90.5 then
            rotate(yellow_needle, 90)
        else
            rotate(yellow_needle, adfyellow)
        end
    end
end

function new_adfdipped(heading, relbrg, rollang)
    --this method approximates ADF dip towards the low wing in a turn

    if user_prop_get(prop_DIP) == true then
        local enoughbank = false
        local rolldir = 0 --0 = left 1 = right
        local turntowards = false
        local trackingaway = false
        local abeam = false

        --check if we have more than 10degrees of bank on
        if rollang > -10 and rollang < 10 then
            enoughbank = false
        else
            enoughbank = true
        end
    
        --are we rolling left or right
        if rollang < 0 then
            rolldir = 0
        elseif rollang > 0 then
            rolldir = 1
        end
    
        --are we rolling towards the beacon
        if relbrg > 0 and rolldir == 1 then
            turntowards = true
        elseif relbrg < 0 and rolldir == 0 then
            turntowards = true
        else
            turntowards = false
        end

        --is the NDB behing us
        if (relbrg > 90) or (relbrg < -90) then
            trackingaway = true    
        else
            trackingaway = false
        end

        --is the NDB on the beam?  Assume 060 - 120 = true
        if (relbrg > 60 and relbrg < 120) or (relbrg < -60 and relbrg > -120) then
            abeam = true    
        else
            abeam = false
        end

        if turntowards == true and abeam == true then
            --we're abeam but need to wash out to zero error
            if rolldir == 0 then
                --we're turning left
                if relbrg == -90 then target_bearing = relbrg end
                if relbrg < -60 and relbrg > -90 then
                    target_bearing = relbrg - reducediperror(rollang,((user_prop_get(prop_DIPAng) - (user_prop_get(prop_DIPAng)/30)*(-relbrg-60))))
                end
                if relbrg < -90 and relbrg > -120 then
                    target_bearing = relbrg - reducediperror(rollang,((user_prop_get(prop_DIPAng) - (user_prop_get(prop_DIPAng)/30)*(-relbrg-60))))
                end
            else
                --we're turning right
                if relbrg == 90 then target_bearing = relbrg end
                if relbrg > 60 and relbrg < 90 then
                    target_bearing = relbrg + reducediperror(rollang,((user_prop_get(prop_DIPAng) - (user_prop_get(prop_DIPAng)/30)*(relbrg-60))))
                end
                if relbrg > 90 and relbrg < 120 then
                    target_bearing = relbrg + reducediperror(rollang,((user_prop_get(prop_DIPAng) - (user_prop_get(prop_DIPAng)/30)*(relbrg-60))))
                end
            end
        elseif turntowards == false and abeam == true then
            --turning away from the beacon and we're abeam but need to wash out to zero error in the reverse to what we did above
            if rolldir == 0 then
                --we're turning left
                if relbrg == 90 then target_bearing = relbrg end
                if relbrg > 60 and relbrg < 90 then
                    target_bearing = relbrg - reducediperror(rollang,((user_prop_get(prop_DIPAng) - (user_prop_get(prop_DIPAng)/30)*(relbrg-60))))
                end
                if relbrg > 90 and relbrg < 120 then
                    target_bearing = relbrg - reducediperror(rollang,((user_prop_get(prop_DIPAng) - (user_prop_get(prop_DIPAng)/30)*(relbrg-60))))
                end
            else
                --we're turning right
                if relbrg == -90 then target_bearing = relbrg end
                if relbrg < -60 and relbrg > -90 then
                    target_bearing = relbrg + reducediperror(rollang,((user_prop_get(prop_DIPAng) - (user_prop_get(prop_DIPAng)/30)*(-relbrg-60))))
                end
                if relbrg < -90 and relbrg > -120 then
                    target_bearing = relbrg + reducediperror(rollang,((user_prop_get(prop_DIPAng) - (user_prop_get(prop_DIPAng)/30)*(-relbrg-60))))
                end
            end
        elseif abeam == false then
            --ADF drip should be occuring
            if rolldir == 0 then
                --we're turning left
                if trackingaway == false then
                    target_bearing = relbrg - reducediperror(rollang, user_prop_get(prop_DIPAng))
                else
                    target_bearing = relbrg + reducediperror(rollang, user_prop_get(prop_DIPAng))
                end
            else
                --we're turning right
                if trackingaway == false then
                    target_bearing = relbrg + reducediperror(rollang, user_prop_get(prop_DIPAng))
                else
                    target_bearing = relbrg - reducediperror(rollang, user_prop_get(prop_DIPAng))
                end
            end    
        end
    end
end

function reducediperror(rollang, maxdip)
    local retval = 0
    if rollang > 10 or rollang < -10 then retval = maxdip end
    if rollang > 0 and rollang <= 10 then retval = (rollang - 2) end
    if rollang < 0 and rollang >= -10 then retval = 0 - (rollang + 2) end

    if retval < 0 then
        return var_cap(-retval, 0, maxdip)
    else
        return var_cap(retval, 0, maxdip)
    end
end



-- Slowly move needle to current bearing --
function timer_callback()
    if user_prop_get(prop_DIP) == true then
        
    
        raw_diff = (360 + target_bearing - current_bearing) %360
        diff = fif(raw_diff < 180, raw_diff, (360 - raw_diff) * -1)
        current_bearing = fif(math.abs(diff) < 0.001, target_bearing, current_bearing + (diff * factor) )
    end
end

---------------------------------------------
--   Controls Add                          --
---------------------------------------------
if user_prop_get(prop_RMI) == false then
    -- Detent settings
    detent_settings = {}
    detent_settings["1 detent/pulse"]  = "TYPE_1_DETENT_PER_PULSE"
    detent_settings["2 detents/pulse"] = "TYPE_2_DETENT_PER_PULSE"
    detent_settings["4 detents/pulse"] = "TYPE_4_DETENT_PER_PULSE"
    detent_setting = user_prop_add_enum("Detent setting", "1 detent/pulse,2 detents/pulse, 4 detents/pulse", "2 detents/pulse", "Select your rotary encoder type")
    dial_hdg = dial_add("adfknob.png", 33, 400, 85, 85, 5, new_hdg)
    dial_click_rotate(dial_hdg, 6)
    hw_dial_add("ADF heading dial", detent_settings[user_prop_get(detent_setting)], 3, new_hdg)
end
---------------------------------------------
--   Simulator Subscriptions               --
---------------------------------------------
xpl_dataref_subscribe("sim/cockpit/gyros/psi_ind_elec_pilot_degm", "FLOAT", new_rotation)
fsx_variable_subscribe("HEADING INDICATOR", "degrees", new_rotation)
msfs_variable_subscribe("HEADING INDICATOR", "degrees", new_rotation)

xpl_dataref_subscribe("sim/cockpit/radios/adf1_cardinal_dir", "FLOAT",
                      "sim/cockpit2/radios/indicators/adf1_relative_bearing_deg", "FLOAT", new_adf)
fsx_variable_subscribe("ADF CARD", "Degrees",
                       "ADF RADIAL:1", "Degrees", new_adf)
msfs_variable_subscribe("ADF CARD", "Degrees",
                        "ADF RADIAL:1", "Degrees", new_adf)
xpl_dataref_subscribe("sim/cockpit/radios/adf1_cardinal_dir", "FLOAT",
    "sim/cockpit2/radios/indicators/adf1_relative_bearing_deg", "FLOAT", 
    "sim/cockpit2/gauges/indicators/roll_electric_deg_pilot", "FLOAT",
    new_adfdipped)
 
-- Timers --
tmr_update = timer_start(0, 20, timer_callback)
                      
---------------------------------------------
-- END       ADF gauge                     --
---------------------------------------------                       