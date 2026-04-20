-- Altitude Monitor
--
-- Handle altitude monitor page, which displays deviations from altitude when start pressed
--
local ALERTING_DEVIATION = 200

gbl_altitude = 0
target_altitude = 0
alt_mon_active = false
alt_mon_alert_state = false
alt_abs_rounded = 0

function stop_alt_monitor()
    alt_mon_active = false  
    visible(txt_alt_dev,false)
    visible(img_ft_icon,false)
    visible(txt_alt_dir,false)
    timer_stop(timer_alt_monitor)
end    

function start_alt_monitor()
    alt_mon_active = true
    target_altitude = gbl_altitude
    txt_set(txt_alt_dev,"0")
    txt_set(txt_alt_dir,"")
    visible(group_alt_monitor,true)
    timer_alt_monitor = timer_start(400,400,callback_alt_monitor_timer)      
end    

function toggle_alt_monitor()
    if (alt_mon_active) then
        stop_alt_monitor()
    else
        start_alt_monitor()
    end    
end

function callback_alt_monitor_timer()
    alt_mon_alert_state = not alt_mon_alert_state
    if (display_page == PAGE_ALT_MON) then
        if alt_mon_active and (alt_abs_rounded > ALERTING_DEVIATION) then
            visible(txt_alt_dir,alt_mon_alert_state)
        else
            visible(txt_alt_dir,alt_mon_active)
        end
     else
         visible(txt_alt_dir,false)
     end       
end

function callback_altitude(altitude)
    gbl_altitude = altitude
    if (alt_mon_active) then
        if (display_page == PAGE_ALT_MON) then
            alt_deviation = gbl_altitude - target_altitude
            alt_abs_deviation = math.abs(alt_deviation)
            alt_abs_rounded = var_cap(math.floor(alt_abs_deviation/100)*100,0,9900)
            if (alt_abs_rounded >= 100) then
                txt_set(txt_alt_dev,tostring(alt_abs_rounded))
                visible(txt_alt_dev,true)
                visible(img_ft_icon,true)
                txt_set(txt_alt_dir,fif(alt_deviation > 0,"ABOVE","BELOW"))
            else           
                visible(txt_alt_dev,false)
                visible(img_ft_icon,false)
                txt_set(txt_alt_dir,"LEVEL")
            end
        else
            visible(txt_alt_dev,false)
            visible(img_ft_icon,false)
        end        
    end
end

function init_alt_monitor()

    xpl_dataref_subscribe("sim/cockpit2/autopilot/altitude_readout_preselector", "FLOAT", callback_altitude)
    fsx_variable_subscribe("PLANE ALTITUDE","feet", callback_altitude)
    msfs_variable_subscribe("PLANE ALTITUDE","feet", callback_altitude)
end
                                                              
