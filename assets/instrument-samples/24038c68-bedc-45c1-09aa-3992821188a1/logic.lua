local prp_streaming = user_prop_add_boolean("Streaming", true, "Enable video streaming with X-Plane 12")
local prp_unit      = user_prop_add_integer("Unit", 1, 2, 2, "Is this unit one or two")
local g_unit  = tostring(user_prop_get(prp_unit))
local g_xpl_version = nil
local g_com_vol = 0
local g_nav_vol = 0

-- Persistence
local prs_angle_left  = persist_add("angle_left", 0)
local prs_angle_right = persist_add("angle_right", 0)

local cnv_streaming_background = canvas_add(359, 43, 933, 529)

local canvas_width  = 870
local canvas_height = 464
local canv_message = canvas_add(390, 90, canvas_width, canvas_height)
-- Message for Raspberry Pi and tablet
if instrument_prop("PLATFORM") == "RASPBERRY_PI" or instrument_prop("PLATFORM") == "ANDROID" or instrument_prop("PLATFORM") == "IPAD" then
    canvas_draw(canv_message, function()
        _rect(0,0,canvas_width,canvas_height)
        _fill("red")
        _txt("STREAMING ONLY AVAILABLE IN X-PLANE 12", "font:roboto_bold.ttf; size:42; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) - 50 * 2)
        _txt("POP OUTS WORK ON THE DESKTOP ONLY", "font:roboto_bold.ttf; size:42; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) - 50 * 1)
        _txt("BUTTONS AND DIALS STILL WORK", "font:roboto_bold.ttf; size:42; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) + 50 * 1)
        _txt("CLICK HERE TO HIDE THIS MESSAGE", "font:roboto_bold.ttf; size:42; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) + 50 * 2)
    end)
    butn_hide = button_add(nil, nil, 390, 90, canvas_width, canvas_height, function()
        visible(canv_message, false)
        visible(butn_hide, false)
    end)
end

-- Message for desktop
local pers_msg_read = persist_add("msg_read", false)
if (instrument_prop("PLATFORM") == "WINDOWS" or instrument_prop("PLATFORM") == "MAC" or instrument_prop("PLATFORM") == "LINUX") and not persist_get(pers_msg_read) then
    canvas_draw(canv_message, function()
        _rect(0,0,canvas_width,canvas_height)
        _fill("blue")
        _txt("STREAMING ONLY AVAILABLE IN X-PLANE 12", "font:roboto_bold.ttf; size:42; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) - 50 * 2)
        _txt("EVERYTHING ELSE REQUIRES THE FLIGHTSIM POP OUT", "font:roboto_bold.ttf; size:42; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) - 50 * 1)
        _txt("SEE OUR WIKI FOR MORE INFORMATION", "font:roboto_bold.ttf; size:42; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) + 50 * 1)
        _txt("CLICK HERE TO HIDE THIS MESSAGE", "font:roboto_bold.ttf; size:42; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) + 50 * 2)
    end)
    butn_hide = button_add(nil, nil, 390, 90, canvas_width, canvas_height, function()
        visible(canv_message, false)
        visible(butn_hide, false)
        persist_put(pers_msg_read, true)
    end)
end

if user_prop_get(prp_streaming) and has_feature("VIDEO_STREAM") then
    -- Only draw black background when streaming is enabled and X-Plane 12 is loaded
    timer_check_streaming = timer_start(nil, 2500, function()
        if g_xpl_version ~= nil and g_xpl_version >= 120000 then
            timer_stop(timer_check_streaming)
            visible(canv_message, false)
            canvas_draw(cnv_streaming_background, function()
                _rect(0, 0, 933, 529)
                _fill(0, 0, 0)
            end)
        end
    end)

    if user_prop_get(prp_unit) == 1 then
        vst_gns530 = video_stream_add("xpl/GNS430_1", 390, 90, 870, 464)
    elseif user_prop_get(prp_unit) == 2 then
        vst_gns530 = video_stream_add("xpl/GNS430_2", 390, 90, 870, 464)
    end
end

xpl_dataref_subscribe("sim/version/xplane_internal_version", "INT", function(xpl_version)
    g_xpl_version = xpl_version
end)

img_add_fullscreen("background.png")

-- COM
img_dial_c_d = img_add("rotary_pwr_vol.png", 90, 64, 96, 96)
dial_c = dial_add(nil, 90, 64, 96, 96, function(dir)
    xpl_dataref_write("sim/cockpit2/radios/actuators/audio_volume_com" .. g_unit, "FLOAT", var_cap(g_com_vol + dir * 0.1, 0, 1) )
    if dir == 1 then
        msfs_event("K:COM2_VOLUME_INC")
    else
        msfs_event("K:COM2_VOLUME_DEC")
    end
end)
xpl_dataref_subscribe("sim/cockpit2/radios/actuators/audio_volume_com" .. g_unit, "FLOAT", function(volume)
    g_com_vol = volume
    rotate(img_dial_c_d, volume * 270)
end)
msfs_variable_subscribe("COM VOLUME:2", "Percent", function(volume)
    rotate(img_dial_c_d, volume * 2.7)
end)
button_add(nil, nil, 108, 82, 60, 60, function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_cvol")
    xpl_command("RXP/GNS/PWR_PUSH_" .. g_unit)
    msfs_event("K:RADIO_COMMNAV1_TEST_TOGGLE")
end)
button_add("softkey_com.png", "softkey_com_pressed.png", 257, 99, 106, 144, function()
    xpl_command("sim/radios/com" .. g_unit .. "_standy_flip")
    xpl_command("RXP/GNS/CFLP_" .. g_unit)
    msfs_event("H:AS430_COMSWAP_Push")
end)

-- NAV
img_dial_v_d = img_add("rotary_vol.png", 90, 218, 96, 96)
dial_v = dial_add(nil, 90, 218, 96, 96, function(dir)
    xpl_dataref_write("sim/cockpit2/radios/actuators/audio_volume_nav" .. g_unit, "FLOAT", var_cap(g_nav_vol + dir * 0.1, 0, 1) )
    if dir == 1 then
        msfs_event("K:NAV2_VOLUME_INC")
    else
        msfs_event("K:NAV2_VOLUME_DEC")
    end
end)
xpl_dataref_subscribe("sim/cockpit2/radios/actuators/audio_volume_nav" .. g_unit, "FLOAT", function(volume)
    g_nav_vol = volume
    rotate(img_dial_v_d, volume * 270)
end)
msfs_variable_subscribe("NAV VOLUME:2", "Percent", function(volume)
    rotate(img_dial_v_d, volume * 2.7)
end)
button_add(nil, nil, 108, 236, 60, 60, function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_vvol")
    msfs_event("K:RADIO_VOR2_IDENT_TOGGLE")
end)
button_add("softkey_vloc.png", "softkey_vloc_pressed.png", 257, 261, 106, 144, function()
    xpl_command("sim/radios/nav" .. g_unit .. "_standy_flip")
    xpl_command("RXP/GNS/VFLP_" .. g_unit)
    msfs_event("H:AS430_NAVSWAP_Push")
end)

-- C/V dials rotary_outer
dial_com_outer = dial_add("rotary_outer.png", 18, 405, 240, 240, function(dir)
    if dir == 1 then
        xpl_command("sim/GPS/g430n" .. g_unit .. "_coarse_up")
        xpl_command("RXP/GNS/COM_OUTR_CW_" .. g_unit)
        msfs_event("H:AS430_LeftLargeKnob_Right")
    else
        xpl_command("sim/GPS/g430n" .. g_unit .. "_coarse_down")
        xpl_command("RXP/GNS/COM_OUTR_CCW_" .. g_unit)
        msfs_event("H:AS430_LeftLargeKnob_Left")
    end
end)
mouse_setting(dial_com_outer, "CLICK_ROTATE", 5)
touch_setting(dial_com_outer, "ROTATE_TICK", 5)
img_add("led_ring_off.png", 55, 442, 166, 166)
img_add("rotary_inner_shadow.png", 37, 454, 202, 202)
img_led_ring_left = img_add("led_ring_on.png", 55, 442, 166, 166)
img_cv_d = img_add("rotary_inner_cv.png", 73, 460, 130, 130, "angle_z:" .. persist_get(prs_angle_left) )
img_cv_n = img_add("rotary_inner_cv_night.png", 73, 460, 130, 130, "angle_z:" .. persist_get(prs_angle_left) )
dial_add(nil, 73, 460, 130, 130, function(dir)

    -- Rotate day and night dial
    persist_put(prs_angle_left, persist_get(prs_angle_left) + dir * 5)
    rotate(img_cv_d, persist_get(prs_angle_left))
    rotate(img_cv_n, persist_get(prs_angle_left))

    if dir == 1 then
        xpl_command("sim/GPS/g430n" .. g_unit .. "_fine_up")
        xpl_command("RXP/GNS/COM_INNR_CW_" .. g_unit)
        msfs_event("H:AS430_LeftSmallKnob_Right")
    else
        xpl_command("sim/GPS/g430n" .. g_unit .. "_fine_down")
        xpl_command("RXP/GNS/COM_INNR_CCW_" .. g_unit)
        msfs_event("H:AS430_LeftSmallKnob_Left")
    end

end)
button_add(nil, nil, 98, 485, 80, 80, function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_nav_com_tog")
    xpl_command("RXP/GNS/COM_PUSH_" .. g_unit)
    msfs_event("H:AS430_LeftSmallKnob_Push")
end)

-- CRSR dials
dial_page_outer = dial_add("rotary_outer.png", 1342, 405, 240, 240, function(dir)
    if dir == 1 then
        xpl_command("sim/GPS/g430n" .. g_unit .. "_chapter_up")
        xpl_command("RXP/GNS/GPS_OUTR_CW_" .. g_unit)
        msfs_event("H:AS430_RightLargeKnob_Right")
    else
        xpl_command("sim/GPS/g430n" .. g_unit .. "_chapter_dn")
        xpl_command("RXP/GNS/GPS_OUTR_CCW_" .. g_unit)
        msfs_event("H:AS430_RightLargeKnob_Left")
    end
end)
mouse_setting(dial_page_outer, "CLICK_ROTATE", 5)
touch_setting(dial_page_outer, "ROTATE_TICK", 5)
img_add("led_ring_off.png", 1379, 442, 166, 166)
img_add("rotary_inner_shadow.png", 1361, 454, 202, 202)
img_led_ring_right = img_add("led_ring_on.png", 1379, 442, 166, 166)
img_cr_d = img_add("rotary_inner_crsr.png", 1397, 460, 130, 130, "angle_z:" .. persist_get(prs_angle_right) )
img_cr_n = img_add("rotary_inner_crsr_night.png", 1397, 460, 130, 130, "angle_z:" .. persist_get(prs_angle_right) )
dial_add(nil, 1397, 460, 130, 130, function(dir)

    -- Rotate day and night dial
    persist_put(prs_angle_right, persist_get(prs_angle_right) + dir * 5)
    rotate(img_cr_d, persist_get(prs_angle_right))
    rotate(img_cr_n, persist_get(prs_angle_right))

    if dir == 1 then
        xpl_command("sim/GPS/g430n" .. g_unit .. "_page_up")
        xpl_command("RXP/GNS/GPS_INNR_CW_" .. g_unit)
        msfs_event("H:AS430_RightSmallKnob_Right")
    else
        xpl_command("sim/GPS/g430n" .. g_unit .. "_page_dn")
        xpl_command("RXP/GNS/GPS_INNR_CCW_" .. g_unit)
        msfs_event("H:AS430_RightSmallKnob_Left")
    end

end)
button_add(nil, nil, 1422, 485, 80, 80, function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_cursor")
    xpl_command("RXP/GNS/GPS_PUSH_" .. g_unit)
    msfs_event("H:AS430_RightSmallKnob_Push")
end)

-- Bottom buttons - left to right
button_add("softkey_cdi.png", "softkey_cdi_pressed.png", 393, 570, 144, 96, function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_cdi")
    xpl_command("RXP/GNS/CDI_" .. g_unit)
    msfs_event("H:AS430_CDI_Push")
end)

button_add("softkey_obs.png", "softkey_obs_pressed.png", 573, 570, 144, 96, function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_obs")
    xpl_command("RXP/GNS/OBS_" .. g_unit)
    msfs_event("H:AS430_OBS_Push")
end)

button_add("softkey_msg.png", "softkey_msg_pressed.png", 753, 570, 144, 96, function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_msg")
    xpl_command("RXP/GNS/MSG_" .. g_unit)
    msfs_event("H:AS430_MSG_Push")
end)

button_add("softkey_fpl.png", "softkey_fpl_pressed.png", 933, 570, 144, 96, function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_fpl")
    xpl_command("RXP/GNS/FPL_" .. g_unit)
    msfs_event("H:AS430_FPL_Push")
end)

button_add("softkey_proc.png", "softkey_proc_pressed.png", 1113, 570, 144, 96, function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_proc")
    xpl_command("RXP/GNS/PROC_" .. g_unit)
    msfs_event("H:AS430_PROC_Push")
end)

-- Right buttons - top to bottom
img_add("softkey_range.png", 1291, 39, 286, 114)
img_range_dn = img_add("softkey_range_down_pressed.png", 1291, 39, 286, 114, "visible:false")
img_range_up = img_add("softkey_range_up_pressed.png", 1291, 39, 286, 114, "visible:false")

button_add(nil, nil, 1314, 57, 117, 82, function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_zoom_out")
    xpl_command("RXP/GNS/RDN_" .. g_unit)
    msfs_event("H:AS430_RNG_Zoom")
    visible(img_range_dn, true)
end,
function()
    visible(img_range_dn, false)
end)

button_add(nil, nil, 1431, 57, 117, 82, function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_zoom_in")
    xpl_command("RXP/GNS/RUP_" .. g_unit)
    msfs_event("H:AS430_RNG_Dezoom")
    visible(img_range_up, true)
end,
function()
    visible(img_range_up, false)
end)

button_add("softkey_direct.png", "softkey_direct_pressed.png", 1291, 153, 144, 106, function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_direct")
    xpl_command("RXP/GNS/DTO_" .. g_unit)
    msfs_event("H:AS430_DirectTo_Push")
end)

button_add("softkey_menu.png", "softkey_menu_pressed.png", 1433, 153, 144, 106, function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_menu")
    xpl_command("RXP/GNS/MNU_" .. g_unit)
    msfs_event("H:AS430_MENU_Push")
end)

button_add("softkey_clr.png", "softkey_clr_pressed.png", 1291, 257, 144, 106, function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_clr", "BEGIN")
    xpl_command("RXP/GNS/CLR_" .. g_unit, "BEGIN")
    timer_clr = timer_start(2000, function()
        msfs_event("H:AS430_CLR_Push_Long")
    end)
end,
function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_clr", "END")
    xpl_command("RXP/GNS/CLR_" .. g_unit, "END")
    if timer_running(timer_clr) then
        timer_stop(timer_clr)
        msfs_event("H:AS430_CLR_Push")
    end
end)

button_add("softkey_ent.png", "softkey_ent_pressed.png", 1433, 257, 144, 106, function()
    xpl_command("sim/GPS/g430n" .. g_unit .. "_ent")
    xpl_command("RXP/GNS/ENT_" .. g_unit)
    msfs_event("H:AS430_ENT_Push")
end)

-- Night and day
img_night = img_add_fullscreen("night_labels.png")
group_night = group_add(img_night, img_led_ring_left, img_led_ring_right, img_cv_n, img_cr_n)
group_day   = group_add(img_cv_d, img_cr_d)
opacity(group_night, 0.0)
opacity(group_day, 1.0)

si_variable_subscribe("si/backlight_intensity", "DOUBLE", function(intensity)
    opacity(group_night, intensity)
    opacity(group_day, 1 - intensity)
end)