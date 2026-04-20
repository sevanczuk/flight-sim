-- Variables --
device_id_prop = user_prop_add_integer("Device ID", 1, 2, 1, "Set the device ID")
local device_id = tostring(user_prop_get(device_id_prop))
local device_id_pms = fif(user_prop_get(device_id_prop) == 1, "", "_2")
local device_id_rxp_fsx = fif(user_prop_get(device_id_prop) == 1, 0, 8)

-- Add background image
img_add_fullscreen("background.png")


-- Add buttons
btn_home = button_add("btn_home.png", "btn_home_pressed.png", 1467, 35, 126, 100, function()
    timer_stop(timer_home_push_long)
    xpl_command("RXP/GTN/HOME_" .. device_id)
    fsx_event("GPS_MENU_BUTTON", device_id_rxp_fsx + 2)
    timer_home_push_long = timer_start(1500, nil, function()
        msfs_event("H:GTN750" .. device_id_pms .. "_HomePushLong")
    end)
end,
function()
    fsx_event("GPS_MENU_BUTTON", device_id_rxp_fsx + 4)
    if timer_running(timer_home_push_long) then
        timer_stop(timer_home_push_long)
        msfs_event("H:GTN750" .. device_id_pms .. "_HomePush")
    end 
end)
btn_direct = button_add("btn_direct.png", "btn_direct_pressed.png", 1467, 1073, 126, 100, function()
    xpl_command("RXP/GTN/DTO_" .. device_id)
    fsx_event("GPS_DIRECTTO_BUTTON", device_id_rxp_fsx)
    msfs_event("H:GTN750" .. device_id_pms .. "_DirectToPush")
end)


-- Add dial top
dial_top = dial_add("rotary_black.png", 0, 4, 152, 152, function(direction)
    if direction == 1 then
        xpl_command("RXP/GTN/VOL_CW_" .. device_id)
        fsx_event("GPS_BUTTON2", device_id_rxp_fsx)
        msfs_event("H:GTN750" .. device_id_pms .. "_VolInc")
    elseif direction == -1 then
        xpl_command("RXP/GTN/VOL_CCW_" .. device_id)
        fsx_event("GPS_BUTTON3", device_id_rxp_fsx)
        msfs_event("H:GTN750" .. device_id_pms .. "_VolDec")
    end
end)
img_add("rotary.png", 33, 37, 86, 86)


-- Add dial bottom
dial_bottom_outer = dial_add("xl_rotary_black.png", 1419, 1339, 200, 200, function(direction)
    if direction == 1 then
        xpl_command("RXP/GTN/FMS_OUTER_CW_" .. device_id)
        fsx_event("GPS_GROUP_KNOB_INC", device_id_rxp_fsx)
        msfs_event("H:GTN750" .. device_id_pms .. "_KnobLargeInc")
    elseif direction == -1 then
        xpl_command("RXP/GTN/FMS_OUTER_CCW_" .. device_id)
        fsx_event("GPS_GROUP_KNOB_DEC", device_id_rxp_fsx)
        msfs_event("H:GTN750" .. device_id_pms .. "_KnobLargeDec")
    end
end)
img_add("xl_rotary.png", 1451, 1371, 136, 136)
img_add("rotary_shadow.png", 1446, 1386, 146, 146)

dial_bottom_inner = dial_add("inner_rotary_black.png", 1470, 1390, 98, 98, function(direction)
    if direction == 1 then
        xpl_command("RXP/GTN/FMS_INNER_CW_" .. device_id)
        fsx_event("GPS_PAGE_KNOB_INC", device_id_rxp_fsx)
        msfs_event("H:GTN750" .. device_id_pms .. "_KnobSmallInc")
    elseif direction == -1 then
        xpl_command("RXP/GTN/FMS_INNER_CCW_" .. device_id)
        fsx_event("GPS_PAGE_KNOB_DEC", device_id_rxp_fsx)
        msfs_event("H:GTN750" .. device_id_pms .. "_KnobSmallDec")
    end
end)
mouse_setting(dial_bottom_inner, "CURSOR_LEFT", "ctr_cursor_ccw.png")
mouse_setting(dial_bottom_inner, "CURSOR_RIGHT", "ctr_cursor_cw.png")
img_add("inner_rotary.png", 1470, 1390, 98, 98)


-- Add rotary push functions
push_top = button_add(nil, "click.png", 56, 60, 40, 40, function()
    xpl_command("RXP/GTN/VOL_PUSH_" .. device_id)
    fsx_event("GPS_BUTTON1", device_id_rxp_fsx)
    msfs_event("H:GTN750" .. device_id_pms .. "_VolPush")
end)
push_bottom = button_add(nil, "click.png", 1499, 1419, 40, 40, function()
    timer_stop(timer_bottom_push_long)
    xpl_command("RXP/GTN/FMS_PUSH_" .. device_id)
    fsx_event("GPS_CURSOR_BUTTON", device_id_rxp_fsx + 2)
    timer_bottom_push_long = timer_start(500, nil, function()
        msfs_event("H:GTN750" .. device_id_pms .. "_KnobPushLong")
    end)
end,
function()
    fsx_event("GPS_CURSOR_BUTTON", device_id_rxp_fsx + 4)
    if timer_running(timer_bottom_push_long) then
        timer_stop(timer_bottom_push_long)
        msfs_event("H:GTN750" .. device_id_pms .. "_KnobPush")
    end        
end)