---------------------------------------------
--  Sim Innovations - All rights reserved  --
--  Bendix/King KAP 140 Autopilot System   --
---------------------------------------------
-- User properties
prop_sound = user_prop_add_enum("Aural alert", "On,Off", "On", "Have aural alerts turned on or off")

-- Global variables --
local gbl_power             = false
local gbl_autopilot_mode    = 0
local gbl_ap_altitude       = 0
local gbl_ap_vsmode         = false
local has_blinked           = false
local baro_inhg_lit         = 0
local baro_hpa_lit          = 0
local baro_vis_time         = 0
local alert_on              = false
local within_200_stb        = false
local alt_reached           = false
local beep_alert            = true
local old_autopilot_mode    = 0
local gbl_vs_set_visible    = false

-- Persistence
local baro_inhg_hpa = persist_add("inhghpa_selection", "INT", 0) -- 0: inHg 1: HPA

-- Images --
img_add_fullscreen("background.png")
-- img_led = img_add("led.png", 23, 46, nil, nil)
img_ap = img_add("ap_light.png", 200, 36, nil, nil, "visible:false")
img_a_box = img_add("ap_box.png", 200, 36, nil, nil, "visible:false")
img_arm_l = img_add("arm_light.png", 184, 63, nil, nil, "visible:false")
img_yd = img_add("yd.png", 200, 65, nil, nil, "visible:false")
img_arm_r = img_add("arm_light.png", 309, 63, nil, nil, "visible:false")
img_trim_up = img_add("pt_up.png", 340, 35, nil, nil, "visible:false")
img_trim_dn = img_add("pt_dn.png", 340, 35, nil, nil, "visible:false")
img_comma = img_add("komma.png", 421, 60, nil, nil, "visible:false")
img_alert = img_add("alert_light.png", 381, 70, nil, nil, "visible:false")
img_fpm = img_add("fpm.png", 435, 70, nil, nil, "visible:false")
img_ft = img_add("ft_light.png", 470, 70, nil, nil, "visible:false")
img_hpa = img_add("hpa.png", 400, 88, nil, nil, "visible:false")
img_inhg = img_add("inhg.png", 447, 88, nil, nil, "visible:false")

txt_item1 = txt_add(" ", "size:42px; color: #ff5a00; halign:right;", 105, 26, 70, 45)
txt_item2 = txt_add(" ",  "size:42px; color: #ff5a00; halign:right;", 230, 26, 70, 45)
txt_item3 = txt_add(" ",  "size:42px; color: #ff5a00; halign:right;", 361, 26, 60, 45)
txt_item4 = txt_add(" ", "size:42px; color: #ff5a00; halign:right;", 341, 26, 150, 45)

txt_item5 = txt_add(" ", "size:42px; color: #ff5a00; halign:right;", 105, 63, 70, 45)
txt_item6 = txt_add(" ", "size:42px; color: #ff5a00; halign:right;", 230, 63, 70, 45)

-- Window image --
img_add("window.png", 100, 22, nil, nil)

-- Item group --
item_group = group_add(txt_item2, txt_item3, txt_item4, txt_item5, txt_item6)        

-- Sounds
snd_2seconds = sound_add("2seconds.wav")
snd_5beeps   = sound_add("5beeps.wav")

-- Buttons and dials functions --
function big_dial_callback(direction)

    -- Then write the required altitude (+-1000ft)
    if baro_inhg_lit == 0 and baro_hpa_lit == 0 then
        if direction == 1 and gbl_ap_altitude <= 29000 and gbl_power then
            xpl_dataref_write("sim/cockpit/autopilot/altitude", "FLOAT", (gbl_ap_altitude - gbl_ap_altitude%100) + 1000)
            msfs_event("AP_ALT_VAR_SET_ENGLISH", (gbl_ap_altitude - gbl_ap_altitude%100) + 1000)
        elseif direction == -1 and gbl_ap_altitude >= -9000 and gbl_power then
            xpl_dataref_write("sim/cockpit/autopilot/altitude", "FLOAT", (gbl_ap_altitude - gbl_ap_altitude%100) - 1000)
            msfs_event("AP_ALT_VAR_SET_ENGLISH", (gbl_ap_altitude - gbl_ap_altitude%100) - 1000)
        end
    else
        baro_vis_time = 30
        if direction == 1 then
            xpl_command("sim/instruments/barometer_up")
            msfs_event("KOHLSMAN_INC")
        elseif direction == -1 then
            xpl_command("sim/instruments/barometer_down")
            msfs_event("KOHLSMAN_DEC")
        end
    end
    
end

function small_dial_callback(direction)

    -- Then write the required altitude (+-100ft)
    if baro_inhg_lit == 0 and baro_hpa_lit == 0 then
        if direction == 1 and gbl_ap_altitude <= 29900 and gbl_power then
            xpl_dataref_write("sim/cockpit/autopilot/altitude", "FLOAT", (gbl_ap_altitude - gbl_ap_altitude%100) + 100)
            msfs_event("AP_ALT_VAR_SET_ENGLISH", (gbl_ap_altitude - gbl_ap_altitude%100) + 100)
        elseif direction == -1 and gbl_ap_altitude > -9900 and gbl_power then
            xpl_dataref_write("sim/cockpit/autopilot/altitude", "FLOAT", (gbl_ap_altitude - gbl_ap_altitude%100) - 100)
            msfs_event("AP_ALT_VAR_SET_ENGLISH", (gbl_ap_altitude - gbl_ap_altitude%100) - 100)
        end
    else
        baro_vis_time = 30
        if direction == 1 then
            xpl_command("sim/instruments/barometer_up")
            msfs_event("KOHLSMAN_INC")
        elseif direction == -1 then
            xpl_command("sim/instruments/barometer_down")
            msfs_event("KOHLSMAN_DEC")
        end
    end
    
end

function api_callback()

    -- Writing the default X-Plane autopilot mode dataref does not work for the Airfoil Labs Cessna 172, so we have to write that one too
    if gbl_autopilot_mode <= 1 and gbl_power then
        xpl_command("sim/autopilot/servos_toggle")
        msfs_event("AUTOPILOT_ON")
    elseif gbl_autopilot_mode == 2 and gbl_power then
        xpl_command("sim/autopilot/servos_toggle")
        xpl_command("sim/autopilot/autothrottle_off")
        msfs_event("AUTOPILOT_OFF")
    end

end

function hdg_callback()

    -- Autopilot heading-hold
    xpl_command("sim/autopilot/heading")
    msfs_event("AP_PANEL_HEADING_HOLD")

end

function nav_callback()

    -- Autopilot VOR/LOC arm
    xpl_command("sim/autopilot/NAV")
    msfs_event("AP_NAV1_HOLD")

end

function apr_callback()

    -- Autopilot approach
    xpl_command("sim/autopilot/approach")
    msfs_event("AP_APR_HOLD")

end

function rev_callback()

    -- Autopilot back-course
    xpl_command("sim/autopilot/back_course")
    msfs_event("AP_BC_HOLD")

end

function alt_callback()

    -- Autopilot altitude select or hold
    xpl_command("sim/autopilot/altitude_hold")
    msfs_event("AP_PANEL_ALTITUDE_HOLD")

end

function up_callback()

    timer_stop(timer_vs_visible)
    gbl_vs_set_visible = true
    timer_vs_visible = timer_start(3000,function()
        gbl_vs_set_visible = false
        if xpl_connected() then
            request_callback(new_xpl_data)
        elseif msfs_connected() then    
            request_callback(new_fs2020_data)
        end
    end)

    if not gbl_ap_vsmode then
        xpl_command("sim/autopilot/vertical_speed")
    end
    xpl_command("sim/autopilot/vertical_speed_up")
    msfs_event("AP_VS_VAR_INC")

end

function dn_callback()

    timer_stop(timer_vs_visible)
    gbl_vs_set_visible = true
    timer_vs_visible = timer_start(3000,function()
        gbl_vs_set_visible = false
        if xpl_connected() then
            request_callback(new_xpl_data)
        elseif msfs_connected() then    
            request_callback(new_fs2020_data)
        end
    end)

    if not gbl_ap_vsmode then
        xpl_command("sim/autopilot/vertical_speed")
    end
    xpl_command("sim/autopilot/vertical_speed_down")
    msfs_event("AP_VS_VAR_DEC")

end

function arm_callback()

    -- Autopilot altitude-hold ARM
    xpl_command("sim/autopilot/altitude_arm")
    -- FS2020?

end

function bar_callback_press()

    -- Show the barometric pressure
    -- Press once: Shows inHg value
    -- Press while showing: Swap between inHg and HPA
    baro_vis_time = 30
    
    timer_baro_switching = timer_start(1000,nil,function()
        if persist_get(baro_inhg_hpa) == 0 then
            persist_put(baro_inhg_hpa, 1)
            
            baro_inhg_lit = 0
            baro_hpa_lit = 1
        elseif persist_get(baro_inhg_hpa) == 1 then
            persist_put(baro_inhg_hpa, 0)
            
            baro_inhg_lit = 1
            baro_hpa_lit = 0
        end
        baro_vis_time = 30
    end)

    if persist_get(baro_inhg_hpa) == 0 then
        baro_inhg_lit = 1
        baro_hpa_lit = 0
    elseif persist_get(baro_inhg_hpa) == 1 then
        baro_inhg_lit = 0
        baro_hpa_lit = 1
    end

    if xpl_connected() then
        request_callback(new_xpl_data)
    elseif msfs_connected() then    
        request_callback(new_fs2020_data)
    end
    
end

function bar_callback_released()

    timer_stop(timer_baro_switching)

end

timer_baro = timer_start(0,100,function()
    baro_vis_time = var_cap(baro_vis_time - 1, 0, 30)
    
    if baro_vis_time == 0 then
        baro_inhg_lit = 0
        baro_hpa_lit = 0
    end
end)

-- Functions --
function new_xpl_data(bus_volts, avionics_on, autopilot_mode, autopilot_state, ap_altitude, ap_trim_up, ap_trim_down, approach_status, altitude_hold_status, 
                      baro_inhg, ap_vs_fpm, time_running, nav_status, yaw_damper_on, vs_lit, backcourse_on, h_ind)
                      
    -- Determine the power state of the autopilot system
    gbl_power = fif(bus_volts[1] > 14 and avionics_on == 1, true, false)
    visible(item_group, gbl_power)
    -- Write global variables
    gbl_autopilot_mode = autopilot_mode
    ap_vs_fpm          = var_round(ap_vs_fpm, 0)
    gbl_ap_altitude    = ap_altitude
    gbl_ap_vsmode      = vs_lit > 0

    -- Set text items
    -- Text item 1
    if (autopilot_state >> 2) & 1 == 1 and nav_status < 2 and gbl_power and autopilot_mode == 2 then
        txt_set(txt_item1, "ROL")
    elseif (autopilot_state >> 1) & 1 == 1 and nav_status < 2 and gbl_power and autopilot_mode == 2 then
        txt_set(txt_item1, "HDG")
    elseif nav_status == 2 and gbl_power and autopilot_mode == 2 then
        txt_set(txt_item1, "NAV")
    else
        txt_set(txt_item1, " ")
    end
    
    -- Make HDG blink for 5 seconds when REV mode is selected
    if (autopilot_state >> 1) & 1 == 1 and nav_status < 2 and gbl_power and autopilot_mode == 2 and backcourse_on == 1 and not timer_running(timer_hdg_blink) and not has_blinked then
        timer_hdg_blink = timer_start(nil, 250, 20, function(count,max_count)
            visible(txt_item1, count%2 == 0)
            -- Stop the blinking after 5 seconds
            has_blinked = count == 20
        end)
    elseif (autopilot_state >> 1) & 1 == 1 and nav_status < 2 and gbl_power and autopilot_mode == 2 and backcourse_on == 1 and has_blinked then
        visible(txt_item1, true)
    elseif gbl_power and autopilot_mode == 2 and backcourse_on == 0 then
        -- Will blink again when going back to REV mode
        visible(txt_item1, true)
        timer_stop(timer_hdg_blink)
        has_blinked = false
    end
    
    -- Text item 2
    if ((autopilot_state >> 4) & 1 == 1) and gbl_power and autopilot_mode == 2 then
        txt_set(txt_item2, "VS")
    elseif ((autopilot_state >> 14) & 1 == 1) and gbl_power and autopilot_mode == 2 then
        txt_set(txt_item2, "ALT")
    else
        txt_set(txt_item2, " ")
    end
    
    -- Barometric pressure values seperated into parts
    baro_hpa = baro_inhg * 33.863886666667
    local baro_hg_num1 = baro_inhg - (baro_inhg%1)
    local baro_mb_num1 = var_round((baro_hpa - (baro_hpa%1000)) / 1000, 0)
    local baro_hg_num2 = (baro_inhg%1) * 100
    local baro_mb_num2 = baro_hpa%1000

    -- Text item 3
    if gbl_power and (baro_inhg_lit == 0 and baro_hpa_lit == 0) and (vs_lit == 0 or not gbl_vs_set_visible) then
        txt_set(txt_item3, string.format("%.0f", (ap_altitude - (ap_altitude%1000)) / 1000) )
    elseif gbl_power and baro_inhg_lit == 1 then
        txt_set(txt_item3, string.format("%.0f", baro_hg_num1) )
    elseif gbl_power and baro_hpa_lit == 1 then
        txt_set(txt_item3, string.format("%.0f", baro_mb_num1) )
    elseif gbl_power and gbl_autopilot_mode == 2 and vs_lit >= 1 and gbl_vs_set_visible and (baro_inhg_lit == 0 and baro_hpa_lit == 0) then
    -- These are the thousands for the vertical speed
        if ap_vs_fpm > -1000 and ap_vs_fpm < 0 then
            txt_set(txt_item3, "-0" )
        elseif ap_vs_fpm >= 0 then
            txt_set(txt_item3, string.format("%.0f", (ap_vs_fpm - (ap_vs_fpm%1000)) / 1000) )
        elseif ap_vs_fpm <= -1000 then
            txt_set(txt_item3, string.format("-%.0f", (math.abs(ap_vs_fpm) - (math.abs(ap_vs_fpm)%1000)) / 1000) )
        end
    elseif gbl_power and gbl_autopilot_mode < 2 then
        txt_set(txt_item3, string.format("%.0f", (ap_altitude - (ap_altitude%1000)) / 1000) )
    else
        txt_set(txt_item3, " ")
    end

    -- Text item 4
    if gbl_power and (baro_inhg_lit == 0 and baro_hpa_lit == 0) and (vs_lit == 0 or not gbl_vs_set_visible) then
        txt_set(txt_item4, string.format("%03.0f", ap_altitude%1000) )
    elseif gbl_power and baro_inhg_lit == 1 then
        txt_set(txt_item4, string.format("%02.0f ", baro_hg_num2) )
    elseif gbl_power and baro_hpa_lit == 1 then
        txt_set(txt_item4, string.format("%03.0f", baro_mb_num2) )
    elseif gbl_power and gbl_autopilot_mode == 2 and vs_lit >= 1 and gbl_vs_set_visible and (baro_inhg_lit == 0 and baro_hpa_lit == 0) and ap_vs_fpm > 0 then
        txt_set(txt_item4, string.format("%03.0f", ap_vs_fpm % 1000) )
    elseif gbl_power and gbl_autopilot_mode == 2 and vs_lit >= 1 and gbl_vs_set_visible and (baro_inhg_lit == 0 and baro_hpa_lit == 0) then
    -- These are the hundreds for the vertical speed
        if ap_vs_fpm == 0.0 then
            txt_set(txt_item4, "000" )
        else
            txt_set(txt_item4, string.format("%03.0f", math.abs(ap_vs_fpm)%1000) )
        end
    elseif gbl_power and gbl_autopilot_mode < 2 then
        txt_set(txt_item4, string.format("%03.0f", ap_altitude%1000) )
    else
        txt_set(txt_item4, " ")
    end
    
    -- Text item 5 and ARM item left
    if (autopilot_state >> 8) & 1 and approach_status == 0 and nav_status == 1 and backcourse_on == 0 and gbl_power and autopilot_mode == 2 then
        txt_set(txt_item5, "NAV")
        visible(img_arm_l, true)
    elseif (autopilot_state >> 8) & 1 and approach_status == 0 and nav_status == 1 and backcourse_on == 1 and gbl_power and autopilot_mode == 2 then
        txt_set(txt_item5, "REV")
        visible(img_arm_l, true)
    elseif (autopilot_state >> 8) & 1 and approach_status >= 1 and backcourse_on == 0 and gbl_power and autopilot_mode == 2 then
        txt_set(txt_item5, "APR")
        visible(img_arm_l, true)
    else
        txt_set(txt_item5, " ")
        visible(img_arm_l, false)
    end    
    
    -- Text item 6 and ARM item right
    if altitude_hold_status == 1 and gbl_power and autopilot_mode == 2 then
        txt_set(txt_item6, "ALT")
        visible(img_arm_r, true)
    else
        txt_set(txt_item6, "")
        visible(img_arm_r, false)
    end
    
    -- Turn on/off boxed AP item
    visible(img_a_box, autopilot_mode == 2 and gbl_power)
    visible(img_ap, autopilot_mode == 2 and gbl_power)
    
    -- Altitude alerter
    -- The ALERT annunciate is illuminated 1000 ft. prior to the selected altitude, extinguishes 200 ft. prior to the selected altitude and illuminates momentarily
    -- when the selected altitude is reached. Once the selected altitude is reached a flashing ALERT illumination signifies that the 200 ft. “safe band” has been exceeded and will
    -- remain illuminated until 1000 ft. from the selected altitude. Associated with the visual alerting is an aural alert (5 short tones) which occurs 1000 feet from the selected altitude upon
    -- approaching the altitude and 200 feet from the selected altitude on leaving the altitude.
    if math.abs(h_ind - ap_altitude) <= 1000 and math.abs(h_ind - ap_altitude) > 200 then
        timer_stop(timer_reached)
        alt_reached = false
        if not beep_alert and gbl_power and user_prop_get(prop_sound) == "On" then
            sound_play(snd_5beeps)
            beep_alert = true
        end
        if not within_200_stb then
            alert_on = true
        end
        if within_200_stb and not timer_running(timer_deviation) then
            timer_deviation = timer_start(0,250,function()
                alert_on = not alert_on
            end)
        end
    elseif math.abs(h_ind - ap_altitude) < 200 and math.abs(h_ind - ap_altitude) > 50 then
        alert_on = false
        timer_stop(timer_deviation)
        timer_stop(timer_reached)
    elseif math.abs(h_ind - ap_altitude) <= 50 and not alt_reached then
        timer_stop(timer_deviation)
        within_200_stb = true
        alt_reached = true
        beep_alert = false
        timer_reached = timer_start(0,1000,5,function(counts,max_count)
            alert_on = true
            if counts == 5 then
                alert_on = false
                timer_stop(timer_reached)
            end
        end)
    elseif math.abs(h_ind - ap_altitude) > 1000 then
        timer_stop(timer_deviation)
        timer_stop(timer_reached)
        alert_on       = false
        within_200_stb = false
        alt_reached    = false
        beep_alert     = false
    end
    
    -- The actual alert image
    visible(img_alert, alert_on and gbl_power and not ((autopilot_state >> 4) & 1 == 1) )
    
    -- Autopilot system trim lights
    visible(img_trim_up, ap_trim_up == 1 and autopilot_mode == 2 and gbl_power)
    visible(img_trim_dn, ap_trim_down == 1 and autopilot_mode == 2 and gbl_power)
    
    -- Turn on/off the comma for the vertical speed or altitude
    visible(img_comma, gbl_power)
    
    -- Switch between HPA and inHG item when the BARO button is pressed
    visible(img_hpa, gbl_power and baro_hpa_lit == 1)
    visible(img_inhg, gbl_power and baro_inhg_lit == 1)
    
    -- Switch between FPM and FT item
    visible(img_ft, gbl_power and (vs_lit == 0 or not gbl_vs_set_visible) and (baro_inhg_lit == 0 and baro_hpa_lit == 0))
    visible(img_fpm, gbl_power and autopilot_mode == 2 and vs_lit >= 1 and gbl_vs_set_visible and baro_hpa_lit == 0 and baro_inhg_lit == 0)
    
    -- Show the yaw damper light
    visible(img_yd, gbl_power and autopilot_mode == 2 and yaw_damper_on == 1)
    
    -- Disconnect sound goes off when the autopilot is turned off
    if old_autopilot_mode ~= autopilot_mode then
        if old_autopilot_mode > 0 and autopilot_mode <= 1 and user_prop_get(prop_sound) == "On" then
            sound_play(snd_2seconds)
        end
        old_autopilot_mode = autopilot_mode
    end
    
end

local old_elevator_trim = 0

function new_fs2020_data(bus_volts, avionics_on, autopilot_on, fd_on, vs_lit, ap_vs_fpm, altitude_mode_on, ap_altitude, alt_arm, h_ind, roll_mode_on, nav_mode_on, heading_mode_on, back_course_on, approach_mode_on, 
                         pitch_mode_on, bank_mode_on, baro_inhg, baro_hpa, elevator_trim, yaw_damper_on)
                      
    -- Determine the power state of the autopilot system
    gbl_power = bus_volts > 14 and avionics_on
    visible(item_group, gbl_power)
    -- Write global variables
    if fd_on and not autopilot_on then
        gbl_autopilot_mode = 1
    elseif autopilot_on then
        gbl_autopilot_mode = 2
    else
        gbl_autopilot_mode = 0
    end
    ap_vs_fpm       = var_round(ap_vs_fpm, 0)
    gbl_ap_altitude = ap_altitude
    gbl_ap_vsmode   = vs_lit

    -- Set text items
    -- Text item 1
    if bank_mode_on and gbl_power and autopilot_on then
        txt_set(txt_item1, "ROL")
    elseif heading_mode_on and gbl_power and autopilot_on then
        txt_set(txt_item1, "HDG")
    elseif nav_mode_on and gbl_power and autopilot_on then
        txt_set(txt_item1, "NAV")
    else
        txt_set(txt_item1, " ")
    end
    
    -- Make HDG blink for 5 seconds when REV mode is selected
    if heading_mode_on and not nav_mode_on and gbl_power and autopilot_on and back_course_on and not timer_running(timer_hdg_blink) and not has_blinked then
        timer_hdg_blink = timer_start(nil, 250, 20, function(count,max_count)
            visible(txt_item1, count%2 == 0)
            -- Stop the blinking after 5 seconds
            has_blinked = count == 20
        end)
    elseif heading_mode_on and not nav_mode_on and gbl_power and autopilot_on and back_course_on and has_blinked then
        visible(txt_item1, true)
    elseif gbl_power and autopilot_on and not back_course_on then
        -- Will blink again when going back to REV mode
        visible(txt_item1, true)
        timer_stop(timer_hdg_blink)
        has_blinked = false
    end
    
    -- Text item 2
    if vs_lit and gbl_power and autopilot_on then
        txt_set(txt_item2, "VS")
    elseif altitude_mode_on and gbl_power and autopilot_on then
        txt_set(txt_item2, "ALT")
    elseif pitch_mode_on and gbl_power and autopilot_on then
        txt_set(txt_item2, "PIT")
    else
        txt_set(txt_item2, " ")
    end
    
    -- Barometric pressure values seperated into parts
    local baro_hg_num1 = baro_inhg - (baro_inhg%1)
    local baro_mb_num1 = var_round((baro_hpa - (baro_hpa%1000)) / 1000, 0)
    local baro_hg_num2 = (baro_inhg%1) * 100
    local baro_mb_num2 = baro_hpa%1000

    -- Text item 3
    if gbl_power and (baro_inhg_lit == 0 and baro_hpa_lit == 0) and (not vs_lit or not gbl_vs_set_visible) then
        if ap_altitude >= 0 then
            txt_set(txt_item3, string.format("%.0f", (math.abs(ap_altitude) - (math.abs(ap_altitude)%1000)) / 1000) )
        else
            txt_set(txt_item3, string.format("-%.0f", (math.abs(ap_altitude) - (math.abs(ap_altitude)%1000)) / 1000) )
        end
    elseif gbl_power and baro_inhg_lit == 1 then
        txt_set(txt_item3, string.format("%.0f", baro_hg_num1) )
    elseif gbl_power and baro_hpa_lit == 1 then
        txt_set(txt_item3, string.format("%.0f", baro_mb_num1) )
    elseif gbl_power and gbl_autopilot_mode == 2 and vs_lit and gbl_vs_set_visible and (baro_inhg_lit == 0 and baro_hpa_lit == 0) then
    -- These are the thousands for the vertical speed
        if ap_vs_fpm > -1000 and ap_vs_fpm < 0 then
            txt_set(txt_item3, "-0" )
        elseif ap_vs_fpm >= 0 then
            txt_set(txt_item3, string.format("%.0f", (ap_vs_fpm - (ap_vs_fpm%1000)) / 1000) )
        elseif ap_vs_fpm <= -1000 then
            txt_set(txt_item3, string.format("-%.0f", (math.abs(ap_vs_fpm) - (math.abs(ap_vs_fpm)%1000)) / 1000) )
        end
    elseif gbl_power and gbl_autopilot_mode < 2 then
        txt_set(txt_item3, string.format("%.0f", (ap_altitude - (ap_altitude%1000)) / 1000) )
    else
        txt_set(txt_item3, " ")
    end

    -- Text item 4
    if gbl_power and (baro_inhg_lit == 0 and baro_hpa_lit == 0) and (not vs_lit or not gbl_vs_set_visible) then
        txt_set(txt_item4, string.format("%03.0f", math.abs(ap_altitude)%1000) )
    elseif gbl_power and baro_inhg_lit == 1 then
        txt_set(txt_item4, string.format("%02.0f ", baro_hg_num2) )
    elseif gbl_power and baro_hpa_lit == 1 then
        txt_set(txt_item4, string.format("%03.0f", baro_mb_num2) )
    elseif gbl_power and gbl_autopilot_mode == 2 and vs_lit and gbl_vs_set_visible and (baro_inhg_lit == 0 and baro_hpa_lit == 0) and ap_vs_fpm > 0 then
        txt_set(txt_item4, string.format("%03.0f", ap_vs_fpm % 1000) )
    elseif gbl_power and gbl_autopilot_mode == 2 and vs_lit and gbl_vs_set_visible and (baro_inhg_lit == 0 and baro_hpa_lit == 0) then
    -- These are the hundreds for the vertical speed
        if ap_vs_fpm == 0.0 then
            txt_set(txt_item4, "000" )
        else
            txt_set(txt_item4, string.format("%03.0f", math.abs(ap_vs_fpm)%1000) )
        end
    elseif gbl_power and gbl_autopilot_mode < 2 then
        txt_set(txt_item4, string.format("%03.0f", ap_altitude%1000) )
    else
        txt_set(txt_item4, " ")
    end
    
    -- Text item 5 and ARM item left
    if nav_mode_on and not approach_mode_on and not back_course_on and gbl_power and gbl_autopilot_mode == 2 then
        txt_set(txt_item5, "NAV")
        visible(img_arm_l, true)
    elseif back_course_on and gbl_power and gbl_autopilot_mode == 2 then
        txt_set(txt_item5, "REV")
        visible(img_arm_l, true)
    elseif approach_mode_on and not back_course_on and gbl_power and gbl_autopilot_mode == 2 then
        txt_set(txt_item5, "APR")
        visible(img_arm_l, true)
    else
        txt_set(txt_item5, " ")
        visible(img_arm_l, false)
    end    
    
    -- Text item 6 and ARM item right
    if alt_arm and gbl_power and gbl_autopilot_mode == 2 then
        txt_set(txt_item6, "ALT")
        visible(img_arm_r, true)
    else
        txt_set(txt_item6, "")
        visible(img_arm_r, false)
    end
    
    -- Turn on/off boxed AP item
    visible(img_a_box, gbl_autopilot_mode == 2 and gbl_power)
    visible(img_ap, gbl_autopilot_mode == 2 and gbl_power)
    
    -- Altitude alerter
    -- The ALERT annunciate is illuminated 1000 ft. prior to the selected altitude, extinguishes 200 ft. prior to the selected altitude and illuminates momentarily
    -- when the selected altitude is reached. Once the selected altitude is reached a flashing ALERT illumination signifies that the 200 ft. “safe band” has been exceeded and will
    -- remain illuminated until 1000 ft. from the selected altitude. Associated with the visual alerting is an aural alert (5 short tones) which occurs 1000 feet from the selected altitude upon
    -- approaching the altitude and 200 feet from the selected altitude on leaving the altitude.
    if math.abs(h_ind - ap_altitude) <= 1000 and math.abs(h_ind - ap_altitude) > 200 then
        timer_stop(timer_reached)
        alt_reached = false
        if not beep_alert and gbl_power and user_prop_get(prop_sound) == "On" then
            sound_play(snd_5beeps)
            beep_alert = true
        end
        if not within_200_stb then
            alert_on = true
        end
        if within_200_stb and not timer_running(timer_deviation) then
            timer_deviation = timer_start(0,250,function()
                alert_on = not alert_on
            end)
        end
    elseif math.abs(h_ind - ap_altitude) < 200 and math.abs(h_ind - ap_altitude) > 50 then
        alert_on = false
        timer_stop(timer_deviation)
        timer_stop(timer_reached)
    elseif math.abs(h_ind - ap_altitude) <= 50 and not alt_reached then
        timer_stop(timer_deviation)
        within_200_stb = true
        alt_reached = true
        beep_alert = false
        timer_reached = timer_start(0,1000,5,function(counts,max_count)
            alert_on = true
            if counts == 5 then
                alert_on = false
                timer_stop(timer_reached)
            end
        end)
    elseif math.abs(h_ind - ap_altitude) > 1000 then
        timer_stop(timer_deviation)
        timer_stop(timer_reached)
        alert_on       = false
        within_200_stb = false
        alt_reached    = false
        beep_alert     = false
    end
    
    -- The actual alert image
    visible(img_alert, alert_on and gbl_power and not vs_lit)
    
    -- Autopilot system trim lights
    elevator_trim = var_round(elevator_trim, 5)
    
    if elevator_trim > old_elevator_trim then
        ap_trim_up = 1
        ap_trim_down = 0
    elseif elevator_trim < old_elevator_trim then
        ap_trim_down = 1
        ap_trim_up = 0
    else
        ap_trim_down = 0
        ap_trim_up = 0
    end
    old_elevator_trim = elevator_trim

    visible(img_trim_up, ap_trim_up == 1 and autopilot_on and gbl_power)
    visible(img_trim_dn, ap_trim_down == 1 and autopilot_on and gbl_power)
    
    -- Turn on/off the comma for the vertical speed or altitude
    visible(img_comma, gbl_power)
    
    -- Switch between HPA and inHG item when the BARO button is pressed
    visible(img_hpa, gbl_power and baro_hpa_lit == 1)
    visible(img_inhg, gbl_power and baro_inhg_lit == 1)
    
    -- Switch between FPM and FT item
    visible(img_ft, gbl_power and (vs_lit or not gbl_vs_set_visible) and (baro_inhg_lit == 0 and baro_hpa_lit == 0))
    visible(img_fpm, gbl_power and autopilot_on and vs_lit and gbl_vs_set_visible and baro_hpa_lit == 0 and baro_inhg_lit == 0)
    
    -- Show the yaw damper light
    visible(img_yd, gbl_power and autopilot_on and yaw_damper_on)
    
    -- Disconnect sound goes off when the autopilot is turned off
    if old_autopilot_mode ~= gbl_autopilot_mode then
        if old_autopilot_mode > 0 and gbl_autopilot_mode <= 1 and user_prop_get(prop_sound) == "On" then
            sound_play(snd_2seconds)
        end
        old_autopilot_mode = gbl_autopilot_mode
    end
    
end 
    
-- Buttons and dials --
dial_big = dial_add("big_dial.png", 563,50,124,124, big_dial_callback)
dial_click_rotate(dial_big, 2)
mouse_setting(dial_big , "CURSOR_LEFT", "large_cursor_left.png")
mouse_setting(dial_big , "CURSOR_RIGHT", "large_cursor_right.png")
dial_small = dial_add("small_dial.png", 582,71,86,86, small_dial_callback)
dial_click_rotate(dial_small, 2)
mouse_setting(dial_small , "CURSOR_LEFT", "cursor_left.png")
mouse_setting(dial_small , "CURSOR_RIGHT", "cursor_right.png")

button_api = button_add("ap_up.png",  "ap_dn.png",  19,136,46,30,  api_callback)
button_hdg = button_add("hdg_up.png", "hdg_dn.png", 114,136,46,30, hdg_callback)
button_nav = button_add("nav_up.png", "nav_dn.png", 194,136,46,30, nav_callback)
button_apr = button_add("apr_up.png", "apr_dn.png", 274,136,46,30, apr_callback)
button_rev = button_add("rev_up.png", "rev_dn.png", 354,136,46,30, rev_callback)
button_alt = button_add("alt_up.png", "alt_dn.png", 434,136,46,30, alt_callback)

button_up = button_add("up_up.png", "up_dn.png", 510,79,46,30,    up_callback)
button_dn = button_add("dn_up.png", "dn_dn.png", 510,131,46,30,    dn_callback)

button_arm = button_add("arm_up.png", "arm_dn.png", 558,17,46,30,    arm_callback)
button_bar = button_add("baro_up.png", "baro_dn.png", 630,17,46,30,    bar_callback_press, bar_callback_released)

-- Data subscription --
xpl_dataref_subscribe("sim/cockpit2/electrical/bus_volts", "FLOAT[6]", 
                      "sim/cockpit/electrical/avionics_on", "INT", 
                      "sim/cockpit/autopilot/autopilot_mode", "INT", 
                      "sim/cockpit/autopilot/autopilot_state", "INT", 
                      "sim/cockpit/autopilot/altitude", "FLOAT", 
                      "sim/cockpit/warnings/annunciators/autopilot_trim_up", "INT",
                      "sim/cockpit/warnings/annunciators/autopilot_trim_down", "INT", 
                      "sim/cockpit2/autopilot/approach_status", "INT", 
                      "sim/cockpit2/autopilot/altitude_hold_status", "INT", 
                      "sim/cockpit/misc/barometer_setting", "FLOAT", 
                      "sim/cockpit2/autopilot/vvi_dial_fpm", "FLOAT", 
                      "sim/time/total_running_time_sec", "FLOAT", 
                      "sim/cockpit2/autopilot/nav_status", "INT", 
                      "sim/cockpit/switches/yaw_damper_on", "INT", 
                      "sim/cockpit2/autopilot/vvi_status", "INT", 
                      "sim/cockpit/autopilot/backcourse_on", "INT", 
                      "sim/flightmodel/misc/h_ind", "FLOAT", new_xpl_data)
                      
fs2020_variable_subscribe("ELECTRICAL MAIN BUS VOLTAGE", "Volts", 
                          "AVIONICS MASTER SWITCH", "Bool", 
                          "AUTOPILOT MASTER", "Bool", 
                          "AUTOPILOT FLIGHT DIRECTOR ACTIVE", "Bool", 
                          "AUTOPILOT VERTICAL HOLD", "Bool",
                          "AUTOPILOT VERTICAL HOLD VAR", "Feet per minute", 
                          "AUTOPILOT ALTITUDE LOCK", "Bool",
                          "AUTOPILOT ALTITUDE LOCK VAR", "Feet", 
                          "AUTOPILOT ALTITUDE ARM", "Bool",
                          "INDICATED ALTITUDE", "Feet",
                          "AUTOPILOT WING LEVELER", "Bool", 
                          "AUTOPILOT NAV1 LOCK", "Bool", 
                          "AUTOPILOT HEADING LOCK", "Bool", 
                          "AUTOPILOT BACKCOURSE HOLD", "Bool", 
                          "AUTOPILOT APPROACH HOLD", "Bool",
                          "AUTOPILOT PITCH HOLD", "BOOL",
                          "AUTOPILOT BANK HOLD", "BOOL",
                          "KOHLSMAN SETTING HG", "inHg", 
                          "KOHLSMAN SETTING MB", "Millibars", 
                          "ELEVATOR TRIM PCT", "Percent", 
                          "AUTOPILOT YAW DAMPER", "Bool", new_fs2020_data)

fs2024_variable_subscribe("ELECTRICAL BUS VOLTAGE:1", "Volts", 
                          "AVIONICS MASTER SWITCH", "Bool", 
                          "AUTOPILOT MASTER", "Bool", 
                          "AUTOPILOT FLIGHT DIRECTOR ACTIVE", "Bool", 
                          "AUTOPILOT VERTICAL HOLD", "Bool",
                          "AUTOPILOT VERTICAL HOLD VAR", "Feet per minute", 
                          "AUTOPILOT ALTITUDE LOCK", "Bool",
                          "AUTOPILOT ALTITUDE LOCK VAR", "Feet", 
                          "AUTOPILOT ALTITUDE ARM", "Bool",
                          "INDICATED ALTITUDE", "Feet",
                          "AUTOPILOT WING LEVELER", "Bool", 
                          "AUTOPILOT NAV1 LOCK", "Bool", 
                          "AUTOPILOT HEADING LOCK", "Bool", 
                          "AUTOPILOT BACKCOURSE HOLD", "Bool", 
                          "AUTOPILOT APPROACH HOLD", "Bool",
                          "AUTOPILOT PITCH HOLD", "BOOL",
                          "AUTOPILOT BANK HOLD", "BOOL",
                          "KOHLSMAN SETTING HG", "inHg", 
                          "KOHLSMAN SETTING MB", "Millibars", 
                          "ELEVATOR TRIM PCT", "Percent", 
                          "AUTOPILOT YAW DAMPER", "Bool", new_fs2020_data)