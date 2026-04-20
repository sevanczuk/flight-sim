-- Global variables
local mode_xpl = nil
local mode_fs  = nil
local pan_vis  = false
local pal_x    = 2560
local pal_y    = 925
local g_xpl_version = nil
local gbl_ias       = 0
local gbl_vs_mode   = 0
local gbl_flc_mode  = 0
local gbl_fs_ap_alt = 0
local gbl_fs_ap_hdg = 0

display_pos = user_prop_add_enum("Display unit function","Pilot PFD,Copilot PFD,MFD,Aerobask PFD,Aerobask MFD","Pilot PFD","Select unit functional position")

-- Properties controls
local prop_ap   = user_prop_add_boolean("Autopilot", true, "Show autopilot controls")
local prop_sd1  = user_prop_add_boolean("SD slot 1", true, "Select to show or hide the SD card for slot 1")
local prop_sd2  = user_prop_add_boolean("SD slot 2", true, "Select to show or hide the SD card for slot 2")
local prop_strm = user_prop_add_boolean("Streaming", true, "Enable video streaming with X-Plane 12")
local prop_nite = user_prop_add_boolean("Night lighting effect", false, "Dimming effect in combination with Air Manager backlight setting")

if user_prop_get(display_pos) == "Pilot PFD" or user_prop_get(display_pos) == "Aerobask PFD" then
    mode_xpl = "1"
    mode_fs = "PFD"
elseif user_prop_get(display_pos) == "Copilot PFD" then
    mode_xpl = "2"
    mode_fs = "PFD"
elseif user_prop_get(display_pos) == "MFD" or user_prop_get(display_pos) == "Aerobask MFD" then
    mode_xpl = "3"
    mode_fs = "MFD"
end

-- Streaming / pop-out
local cnv_streaming_background = canvas_add(410, 94, 2060, 1548)

local canvas_width  = 2048
local canvas_height = 1536
local canv_message = canvas_add(416, 100, canvas_width, canvas_height)
-- Message for Raspberry Pi and tablet
if instrument_prop("PLATFORM") == "RASPBERRY_PI" or instrument_prop("PLATFORM") == "ANDROID" or instrument_prop("PLATFORM") == "IPAD" then
    canvas_draw(canv_message, function()
        _rect(0, 0, canvas_width,canvas_height)
        _fill("red")
        _txt("STREAMING ONLY AVAILABLE IN X-PLANE 12", "font:roboto_bold.ttf; size:72; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) - 55 * 2)
        _txt("POP OUTS WORK ON THE DESKTOP ONLY", "font:roboto_bold.ttf; size:72; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) - 55 * 1)
        _txt("BUTTONS AND DIALS STILL WORK", "font:roboto_bold.ttf; size:72; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) + 55 * 1)
        _txt("CLICK HERE TO HIDE THIS MESSAGE", "font:roboto_bold.ttf; size:72; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) + 55 * 2)
    end)
    butn_hide = button_add(nil, nil, 416, 100, canvas_width, canvas_height, function()
        visible(canv_message, false)
        visible(butn_hide, false)
    end)
end

-- Message for desktop
local pers_msg_read = persist_add("msg_read", false)
if (instrument_prop("PLATFORM") == "WINDOWS" or instrument_prop("PLATFORM") == "MAC" or instrument_prop("PLATFORM") == "LINUX") and not persist_get(pers_msg_read) then
    canvas_draw(canv_message, function()
        _rect(0, 0, canvas_width,canvas_height)
        _fill("blue")
        _txt("STREAMING ONLY AVAILABLE IN X-PLANE 12", "font:roboto_bold.ttf; size:72; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) - 55 * 2)
        _txt("EVERYTHING ELSE REQUIRES THE FLIGHTSIM POP OUT", "font:roboto_bold.ttf; size:72; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) - 55 * 1)
        _txt("SEE OUR WIKI FOR MORE INFORMATION", "font:roboto_bold.ttf; size:72; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) + 55 * 1)
        _txt("CLICK HERE TO HIDE THIS MESSAGE", "font:roboto_bold.ttf; size:72; color: white; halign:center;", canvas_width / 2, (canvas_height / 2) + 55 * 2)
    end)
    butn_hide = button_add(nil, nil, 416, 100, canvas_width, canvas_height, function()
        visible(canv_message, false)
        visible(butn_hide, false)
        persist_put(pers_msg_read, true)
    end)
end

if user_prop_get(prop_strm) and has_feature("VIDEO_STREAM") then
    -- Only draw black background when streaming is enabled and X-Plane 12 is loaded
    timer_check_streaming = timer_start(nil, 2500, function()
        if g_xpl_version ~= nil and g_xpl_version >= 120000 then
            timer_stop(timer_check_streaming)
            if user_prop_get(pers_msg_read) then
                visible(canv_message, false)
                visible(butn_hide, false)
            end
            canvas_draw(cnv_streaming_background, function()
                _rect(0, 0, 2060, 1548)
                _fill(0, 0, 0)
            end)
        end
    end)

    if user_prop_get(display_pos) == "Pilot PFD" then
        vst_g1000 = video_stream_add("xpl/G1000_PFD_1", 416, 100, 2048, 1536)
    elseif user_prop_get(display_pos) == "Copilot PFD" then
        vst_g1000 = video_stream_add("xpl/G1000_PFD_2", 416, 100, 2048, 1536)
    elseif user_prop_get(display_pos) == "MFD" then
        vst_g1000 = video_stream_add("xpl/G1000_MFD", 416, 100, 2048, 1536)
    elseif user_prop_get(display_pos) == "Aerobask PFD" then
        vst_g1000 = video_stream_add("xpl/gauges[1]", 416, 100, 2048, 1536, 1538, 1280, 1023, 768)
    elseif user_prop_get(display_pos) == "Aerobask MFD" then
        vst_g1000 = video_stream_add("xpl/gauges[1]", 416, 100, 2048, 1536, 1538, 512, 1023, 768)
    end
end

xpl_dataref_subscribe("sim/version/xplane_internal_version", "INT", function(xpl_version)
    g_xpl_version = xpl_version
end)

-- Background
img_add_fullscreen("background_ap.png", "visible:" .. tostring(user_prop_get(prop_ap)) )
img_add_fullscreen("background.png", "visible:" .. tostring(not user_prop_get(prop_ap)) )

-- SD card 1 visibility
img_add("no_sd_1.png", 2571, 375, 22, 249,  "visible:" .. tostring(not user_prop_get(prop_sd1)) )
img_add("sd_card_1.png", 2571, 375, 22, 249,  "visible:" .. tostring(user_prop_get(prop_sd1)) )

-- SD card 2 visibility
img_add("no_sd_2.png", 2571, 705, 22, 249,  "visible:" .. tostring(not user_prop_get(prop_sd2)) )
img_add("sd_card_2.png", 2571, 705, 22, 249,  "visible:" .. tostring(user_prop_get(prop_sd2)) )

-- Softkey pressed states and actions
-- Softkey toggle NAV
button_add("btn_toggle.png", "btn_toggle_pressed.png", 187, 185, 146, 113, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_nav_ff")
    msfs_event("H:AS1000_PFD_NAV_Switch")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey toggle COM
button_add("btn_toggle.png", "btn_toggle_pressed.png", 2547, 185, 146, 113, function()
    timer_stop(timer_emerg)
    timer_emerg = timer_start(2000, nil, function()
        xpl_dataref_write("sim/cockpit2/radios/actuators/com1_frequency_hz_833", "INT", 121500)
        msfs_event("COM_RADIO_SET_HZ", 121500000)
    end)
    tact_switch("PRESS")
end,
function()
    if timer_running(timer_emerg) then
        timer_stop(timer_emerg)
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_com_ff")
        msfs_event("H:AS1000_PFD_COM_Switch")
    end
    tact_switch("RELEASE")
end)

-- Softkey 1
button_add("btn_arrow.png", "btn_arrow_pressed.png", 432, 1706, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_softkey1")
    msfs_event("H:AS1000_" .. mode_fs .. "_SOFTKEYS_1")
    fsx_event("G1000_" .. mode_fs .. "_SOFTKEY1")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey 2
button_add("btn_arrow.png", "btn_arrow_pressed.png", 602, 1706, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_softkey2")
    msfs_event("H:AS1000_" .. mode_fs .. "_SOFTKEYS_2")
    fsx_event("G1000_" .. mode_fs .. "_SOFTKEY2")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey 3
button_add("btn_arrow.png", "btn_arrow_pressed.png", 772, 1706, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_softkey3")
    msfs_event("H:AS1000_" .. mode_fs .. "_SOFTKEYS_3")
    fsx_event("G1000_" .. mode_fs .. "_SOFTKEY3")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey 4
button_add("btn_arrow.png", "btn_arrow_pressed.png", 942, 1706, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_softkey4")
    msfs_event("H:AS1000_" .. mode_fs .. "_SOFTKEYS_4")
    fsx_event("G1000_" .. mode_fs .. "_SOFTKEY4")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey 5
button_add("btn_arrow.png", "btn_arrow_pressed.png", 1112, 1706, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_softkey5")
    msfs_event("H:AS1000_" .. mode_fs .. "_SOFTKEYS_5")
    fsx_event("G1000_" .. mode_fs .. "_SOFTKEY5")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey 6
button_add("btn_arrow.png", "btn_arrow_pressed.png", 1282, 1706, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_softkey6")
    msfs_event("H:AS1000_" .. mode_fs .. "_SOFTKEYS_6")
    fsx_event("G1000_" .. mode_fs .. "_SOFTKEY6")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey 7
button_add("btn_arrow.png", "btn_arrow_pressed.png", 1452, 1706, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_softkey7")
    msfs_event("H:AS1000_" .. mode_fs .. "_SOFTKEYS_7")
    fsx_event("G1000_" .. mode_fs .. "_SOFTKEY7")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey 8
button_add("btn_arrow.png", "btn_arrow_pressed.png", 1622, 1706, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_softkey8")
    msfs_event("H:AS1000_" .. mode_fs .. "_SOFTKEYS_8")
    fsx_event("G1000_" .. mode_fs .. "_SOFTKEY8")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey 9
button_add("btn_arrow.png", "btn_arrow_pressed.png", 1792, 1706, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_softkey9")
    msfs_event("H:AS1000_" .. mode_fs .. "_SOFTKEYS_9")
    fsx_event("G1000_" .. mode_fs .. "_SOFTKEY9")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey 10
button_add("btn_arrow.png", "btn_arrow_pressed.png", 1962, 1706, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_softkey10")
    msfs_event("H:AS1000_" .. mode_fs .. "_SOFTKEYS_10")
    fsx_event("G1000_" .. mode_fs .. "_SOFTKEY10")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey 11
button_add("btn_arrow.png", "btn_arrow_pressed.png", 2132, 1706, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_softkey11")
    msfs_event("H:AS1000_" .. mode_fs .. "_SOFTKEYS_11")
    fsx_event("G1000_" .. mode_fs .. "_SOFTKEY11")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey 12
button_add("btn_arrow.png", "btn_arrow_pressed.png", 2302, 1706, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_softkey12")
    msfs_event("H:AS1000_" .. mode_fs .. "_SOFTKEYS_12")
    fsx_event("G1000_" .. mode_fs .. "_SOFTKEY12")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey AP
button_ap = button_add("btn_ap.png", "btn_ap_pressed.png", 23, 895, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_ap")
    msfs_event("AP_MASTER")
    fsx_event("AP_MASTER")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey HDG
button_hdg = button_add("btn_hdg.png", "btn_hdg_pressed.png", 23, 1007, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_hdg")
    msfs_event("AP_PANEL_HEADING_HOLD")
    fsx_event("AP_PANEL_HEADING_HOLD")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey NAV
button_nav = button_add("btn_nav.png", "btn_nav_pressed.png", 23, 1119, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_nav")
    msfs_event("AP_NAV1_HOLD")
    fsx_event("AP_NAV1_HOLD")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey APR
button_apr = button_add("btn_apr.png", "btn_apr_pressed.png", 23, 1231, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_apr")
    msfs_event("AP_APR_HOLD")
    fsx_event("AP_APR_HOLD")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey VS
button_vs = button_add("btn_vs.png", "btn_vs_pressed.png", 23, 1343, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_vs")
    msfs_event("AP_PANEL_VS_HOLD")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey FLC
button_flc = button_add("btn_flc.png", "btn_flc_pressed.png", 23, 1455, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_flc")
    if gbl_flc_mode then
        msfs_event("FLIGHT_LEVEL_CHANGE_OFF")
    else
        msfs_event("FLIGHT_LEVEL_CHANGE_ON")
        msfs_event("AP_SPD_VAR_SET", gbl_ias)
    end
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey FD
button_fd = button_add("btn_fd.png", "btn_fd_pressed.png", 171, 895, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_fd")
    msfs_event("TOGGLE_FLIGHT_DIRECTOR")
    fsx_event("TOGGLE_FLIGHT_DIRECTOR")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey ALT
button_alt = button_add("btn_alt.png", "btn_alt_pressed.png", 171, 1007, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_alt")
    msfs_event("AP_PANEL_ALTITUDE_HOLD")
    fsx_event("AP_PANEL_ALTITUDE_HOLD")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey VNV
button_vnv = button_add("btn_vnv.png", "btn_vnv_pressed.png", 171, 1119, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_vnv")
    msfs_event("H:AS1000_VNAV_TOGGLE")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey BC
button_bc = button_add("btn_bc.png", "btn_bc_pressed.png", 171, 1231, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_bc")
    msfs_event("AP_BC_HOLD")
    fsx_event("AP_BC_HOLD")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey NOSEUP
button_nosup = button_add("btn_nose_up.png", "btn_nose_up_pressed.png", 171, 1343, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_nose_up")
    if gbl_vs_mode then
        msfs_event("AP_VS_VAR_INC")
        fsx_event("AP_VS_VAR_INC")
    elseif gbl_flc_mode then
        msfs_event("AP_SPD_VAR_DEC")
        fsx_event("AP_BC_HOLD")
    else
        msfs_event("AP_PITCH_REF_INC_UP")
        fsx_event("AP_PITCH_REF_INC_UP")
    end
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey NOSEDN
button_nosdn = button_add("btn_nose_dn.png", "btn_nose_dn_pressed.png", 171, 1455, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_nose_down")
    if gbl_vs_mode then
        msfs_event("AP_VS_VAR_DEC")
        fsx_event("AP_VS_VAR_DEC")
    elseif gbl_flc_mode then
        msfs_event("AP_SPD_VAR_INC")
        fsx_event("AP_SPD_VAR_INC")
    else
        msfs_event("AP_PITCH_REF_INC_DN")
        fsx_event("AP_PITCH_REF_INC_DN")
    end
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Autopilot visibility
group_btn_ap = group_add(button_ap, button_hdg, button_nav, button_apr, button_vs, button_flc, button_fd, button_alt, button_vnv, button_bc, button_nosup, button_nosdn)
visible(group_btn_ap, user_prop_get(prop_ap) )

-- Softkey DIRECT TO
button_add("btn_direct.png", "btn_direct_pressed.png", 2563, 1231, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_direct")
    msfs_event("H:AS1000_" .. mode_fs .. "_DIRECTTO")
    fsx_event("G1000_" .. mode_fs .. "_DIRECTTO_BUTTON")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey MENU
button_add("btn_menu.png", "btn_menu_pressed.png", 2711, 1231, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_menu")
    msfs_event("H:AS1000_" .. mode_fs .. "_MENU_Push")
    fsx_event("G1000_" .. mode_fs .. "_MENU_BUTTON")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey FPL
button_add("btn_fpl.png", "btn_fpl_pressed.png", 2563, 1343, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_fpl")
    msfs_event("H:AS1000_" .. mode_fs .. "_FPL_Push")
    fsx_event("G1000_" .. mode_fs .. "_FLIGHTPLAN_BUTTON")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey PROC
button_add("btn_proc.png", "btn_proc_pressed.png", 2711, 1343, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_proc")
    msfs_event("H:AS1000_" .. mode_fs .. "_PROC_Push")
    fsx_event("G1000_" .. mode_fs .. "_PROCEDURE_BUTTON")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Softkey CLR
button_add("btn_clr.png", "btn_clr_pressed.png", 2563, 1455, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_clr", 1)
    timer_fs2020_clear = timer_start(2000, function()
        msfs_event("H:AS1000_" .. mode_fs .. "_CLR_Long")
    end)
    fsx_event("G1000_" .. mode_fs .. "_CLEAR_BUTTON")
    tact_switch("PRESS")
end,
function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_clr", 0)
    if timer_running(timer_fs2020_clear) then
        timer_stop(timer_fs2020_clear)
        msfs_event("H:AS1000_" .. mode_fs .. "_CLR")
    end
    tact_switch("RELEASE")
end)

-- Softkey ENT
button_add("btn_ent.png", "btn_ent_pressed.png", 2711, 1455, 146, 112, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_ent")
    msfs_event("H:AS1000_" .. mode_fs .. "_ENT_Push")
    fsx_event("G1000_" .. mode_fs .. "_ENTER_BUTTON")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- CRS/BARO rotary knob
-- BARO rotary knob
baro_dial = dial_add("rotary_outer.png", 2610, 640, 200, 200, function(direction)
    if direction ==  -1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_baro_down")
        msfs_event("H:AS1000_" .. mode_fs .. "_BARO_DEC")
        fsx_event("KOHLSMAN_INC")
    elseif direction == 1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_baro_up")
        msfs_event("H:AS1000_" .. mode_fs .. "_BARO_INC")
        fsx_event("KOHLSMAN_DEC")
    end
    encoder_rotate("BIG")
end)
dial_click_rotate(baro_dial, 6)

-- Add CRS inner rotary shadow
img_add("rotary_shadow_inner.png", 2630, 670, 160, 220)

-- Add CRS rotary
crs_dial = dial_add("rotary_baro_inner.png", 2660, 690, 100, 100, 3, function(direction)
    if direction ==  -1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_crs_down")
        msfs_event("H:AS1000_" .. mode_fs .. "_CRS_DEC")
        fsx_event("VOR1_OBI_DEC")
    elseif direction == 1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_crs_up")
        msfs_event("H:AS1000_" .. mode_fs .. "_CRS_INC")
        fsx_event("VOR1_OBI_INC")
    end
    encoder_rotate("SMALL")
end)
dial_click_rotate(crs_dial, 6)
mouse_setting(crs_dial, "CURSOR_LEFT", "ctr_cursor_ccw.png")
mouse_setting(crs_dial, "CURSOR_RIGHT", "ctr_cursor_cw.png")

-- Add CRS rotary click region
button_add(nil,nil, 2690, 720, 40, 40, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_crs_sync")
    msfs_event("H:AS1000_" .. mode_fs .. "_CRS_PUSH")
    encoder_button("PRESS")
end,
function()
    encoder_button("RELEASE")
end)

-- HDG rotary knob
hdg_dial = dial_add("rotary_hdg.png", 98, 670, 140, 140, 3, function (direction)
    if direction ==  -1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_hdg_down")
        msfs_event("HEADING_BUG_DEC")
        fsx_event("HEADING_BUG_DEC")
    elseif direction == 1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_hdg_up")
        msfs_event("HEADING_BUG_INC")
        fsx_event("HEADING_BUG_INC")
    end
    encoder_rotate("BIG")
end)
dial_click_rotate(hdg_dial, 6)

-- Add HDG rotary click region
button_add(nil, nil, 148, 720, 40, 40, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_hdg_sync")
    msfs_event("HEADING_BUG_SET", gbl_fs_ap_hdg)
    fsx_event("HEADING_BUG_SET", gbl_fs_ap_hdg)
    encoder_button("PRESS")
end,
function()
    encoder_button("RELEASE")
end)

-- NAV rotary knob
-- Add NAV outer rotary
nav_dial_outer = dial_add("rotary_outer.png", 68, 310, 200, 200, function(direction)
    if direction ==  -1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_nav_outer_down")
        msfs_event("H:AS1000_" .. mode_fs .. "_NAV_Large_DEC")
        fsx_event("NAV1_RADIO_WHOLE_DEC")
    elseif direction == 1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_nav_outer_up")
        msfs_event("H:AS1000_" .. mode_fs .. "_NAV_Large_INC")
        fsx_event("NAV1_RADIO_WHOLE_INC")
    end
    encoder_rotate("BIG")
end)
dial_click_rotate(nav_dial_outer, 6)

-- Add NAV inner rotary shadow
img_add("rotary_shadow_inner.png", 88, 340, 160, 220)

-- Add NAV inner rotary
nav_dial_inner = dial_add("rotary_inner.png", 118, 360, 100, 100, function(direction)
    if direction ==  -1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_nav_inner_down")
        msfs_event("H:AS1000_" .. mode_fs .. "_NAV_Small_DEC")
        fsx_event("NAV1_RADIO_FRACT_DEC")
    elseif direction == 1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_nav_inner_up")
        msfs_event("H:AS1000_" .. mode_fs .. "_NAV_Small_INC")
        fsx_event("NAV1_RADIO_FRACT_INC")
    end
    encoder_rotate("SMALL")
end)
dial_click_rotate(nav_dial_outer, 6)
mouse_setting(nav_dial_inner, "CURSOR_LEFT", "ctr_cursor_ccw.png")
mouse_setting(nav_dial_inner, "CURSOR_RIGHT", "ctr_cursor_cw.png")

-- Add NAV rotary click region
button_add(nil, nil, 148, 390, 40, 40, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_nav12")
    msfs_event("H:AS1000_" .. mode_fs .. "_NAV_Push")
    encoder_button("PRESS")
end,
function()
    encoder_button("RELEASE")
end)

-- COM rotary knob
-- Add COM outer rotary
com_dial_outer = dial_add("rotary_outer.png", 2610, 310, 200, 200, function(direction)
    if direction ==  -1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_com_outer_down")
        msfs_event("H:AS1000_" .. mode_fs .. "_COM_Large_DEC")
        fsx_event("COM_RADIO_WHOLE_DEC")
    elseif direction == 1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_com_outer_up")
        msfs_event("H:AS1000_" .. mode_fs .. "_COM_Large_INC")
        fsx_event("COM_RADIO_WHOLE_INC")
    end
    encoder_rotate("BIG")
end)
dial_click_rotate(com_dial_outer, 6)

-- Add COM inner rotary shadow
img_add("rotary_shadow_inner.png", 2630, 340, 160, 220)

-- Add COM inner rotary
com_dial_inner = dial_add("rotary_inner.png", 2660, 360, 100, 100, function(direction)
    if direction ==  -1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_com_inner_down")
        msfs_event("H:AS1000_" .. mode_fs .. "_COM_Small_DEC")
        fsx_event("COM_RADIO_FRACT_DEC")
    elseif direction == 1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_com_inner_up")
        msfs_event("H:AS1000_" .. mode_fs .. "_COM_Small_INC")
        fsx_event("COM_RADIO_FRACT_INC")
    end
    encoder_rotate("SMALL")
end)
dial_click_rotate(com_dial_inner, 6)
mouse_setting(com_dial_inner, "CURSOR_LEFT", "ctr_cursor_ccw.png")
mouse_setting(com_dial_inner, "CURSOR_RIGHT", "ctr_cursor_cw.png")

-- Add COM rotary click region
button_add(nil, nil, 2690, 390, 40, 40, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_com12")
    msfs_event("H:AS1000_" .. mode_fs .. "_COM_Push")
    encoder_button("PRESS")
end,
function()
    encoder_button("RELEASE")
end)

-- FMS rotary knob
-- Add FMS outer rotary
fms_dial_outer = dial_add("rotary_outer.png", 2610, 1605, 200, 200, function(direction)
    if direction ==  -1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_fms_outer_down")
        msfs_event("H:AS1000_" .. mode_fs .. "_FMS_Lower_DEC")
        fsx_event("G1000_" .. mode_fs .. "_GROUP_KNOB_DEC")
    elseif direction == 1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_fms_outer_up")
        msfs_event("H:AS1000_" .. mode_fs .. "_FMS_Lower_INC")
        fsx_event("G1000_" .. mode_fs .. "_GROUP_KNOB_INC")
    end
    encoder_rotate("BIG")
end)
dial_click_rotate(fms_dial_outer, 6)

-- Add FMS inner rotary shadow
img_add("rotary_shadow_inner.png", 2630, 1635, 160, 220)

-- Add FMS inner rotary
fms_dial_inner = dial_add("rotary_inner.png", 2660, 1655, 100, 100, function(direction)
    if direction ==  -1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_fms_inner_down")
        msfs_event("H:AS1000_" .. mode_fs .. "_FMS_Upper_DEC")
        fsx_event("G1000_" .. mode_fs .. "_PAGE_KNOB_DEC")
    elseif direction == 1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_fms_inner_up")
        msfs_event("H:AS1000_" .. mode_fs .. "_FMS_Upper_INC")
        fsx_event("G1000_" .. mode_fs .. "_PAGE_KNOB_INC")
    end
    encoder_rotate("SMALL")
end)
dial_click_rotate(fms_dial_inner, 6)
mouse_setting(fms_dial_inner, "CURSOR_LEFT", "ctr_cursor_ccw.png")
mouse_setting(fms_dial_inner, "CURSOR_RIGHT", "ctr_cursor_cw.png")

-- Add FMS rotary click region
button_add(nil, nil, 2690, 1685, 40, 40, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_cursor")
    msfs_event("H:AS1000_" .. mode_fs .. "_FMS_Upper_PUSH")
    fsx_event("G1000_" .. mode_fs .. "_CURSOR_BUTTON")
    encoder_button("PRESS")
end,
function()
    encoder_button("RELEASE")
end)

-- ALT rotary knob
-- Add ALT outer rotary
alt_dial_outer = dial_add("rotary_outer.png", 68, 1605, 200, 200, function(direction)
    if direction ==  -1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_alt_outer_down")
        msfs_event("AP_ALT_VAR_SET_ENGLISH", gbl_fs_ap_alt - 1000)
        fsx_event("AP_ALT_VAR_SET_ENGLISH", gbl_fs_ap_alt - 1000)
    elseif direction == 1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_alt_outer_up")
        msfs_event("AP_ALT_VAR_SET_ENGLISH", gbl_fs_ap_alt + 1000)
        fsx_event("AP_ALT_VAR_SET_ENGLISH", gbl_fs_ap_alt + 1000)
    end
    encoder_rotate("BIG")
end)
dial_click_rotate(alt_dial_outer, 6)

-- Add ALT inner rotary shadow
img_add("rotary_shadow_inner.png", 88, 1635, 160, 220)

-- Add ALT inner rotary
alt_dial_inner = dial_add("rotary_inner.png", 118, 1655, 100, 100, function(direction)
    if direction ==  -1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_alt_inner_down")
        msfs_event("AP_ALT_VAR_SET_ENGLISH", gbl_fs_ap_alt - 100)
        fsx_event("AP_ALT_VAR_SET_ENGLISH", gbl_fs_ap_alt - 100)
    elseif direction == 1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_alt_inner_up")
        msfs_event("AP_ALT_VAR_SET_ENGLISH", gbl_fs_ap_alt + 100)
        fsx_event("AP_ALT_VAR_SET_ENGLISH", gbl_fs_ap_alt + 100)
    end
    encoder_rotate("SMALL")
end)
dial_click_rotate(alt_dial_inner, 6)
mouse_setting(alt_dial_inner, "CURSOR_LEFT", "ctr_cursor_ccw.png")
mouse_setting(alt_dial_inner, "CURSOR_RIGHT", "ctr_cursor_cw.png")

-- Add click to NAV VOL
navvol_dial = dial_add("rotary_vol.png", 133, 90, 70, 70, function(direction)
    if direction == 1 then
        msfs_event("NAV1_VOLUME_INC")
        msfs_event("NAV2_VOLUME_INC")
    elseif direction == -1 then
        msfs_event("NAV1_VOLUME_DEC")
        msfs_event("NAV2_VOLUME_DEC")
    end
    encoder_rotate("SMALL")
end)

-- Add click to COM VOL
comvol_dial = dial_add("rotary_vol.png", 2675, 90, 70, 70, function(direction)
    if direction ==  1 then
        msfs_event("COM1_VOLUME_INC")
        msfs_event("COM2_VOLUME_INC")
    elseif direction == -1 then
        msfs_event("COM1_VOLUME_DEC")
        msfs_event("COM2_VOLUME_DEC") 
    end
    encoder_rotate("SMALL")
end)

-- Pan joystick controls
img_add("shadow_joystick.png", 2610, 1005, 200, 200)
pan_background = img_add("pan_tool.png", pal_x , pal_y, 300, 300)

-- Add joystick up function
up_press = button_add(nil, "arrow_up.png", pal_x + 120, pal_y - 17, 60, 60, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_pan_up")
    msfs_event("H:AS1000_" .. mode_fs .. "_JOYSTICK_UP")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Add joystick up_rt function
uprt_press = button_add(nil, "arrow_uprt.png", pal_x + 209, pal_y + 30, 60, 60, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_pan_up_right")
    msfs_event("H:AS1000_" .. mode_fs .. "_JOYSTICK_RIGHT")
    msfs_event("H:AS1000_" .. mode_fs .. "_JOYSTICK_UP")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Add joystick up_lt function
uplt_press = button_add(nil, "arrow_uplt.png", pal_x + 30, pal_y + 30, 60, 60, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_pan_up_left")
    msfs_event("H:AS1000_" .. mode_fs .. "_JOYSTICK_LEFT")
    msfs_event("H:AS1000_" .. mode_fs .. "_JOYSTICK_UP")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Add joystick lt fuction
lt_press = button_add(nil, "arrow_lt.png", pal_x - 16, pal_y + 119, 60, 60, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_pan_left")
    msfs_event("H:AS1000_" .. mode_fs .. "_JOYSTICK_LEFT")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Add joystick rt function
rt_press = button_add(nil, "arrow_rt.png", pal_x + 256, pal_y + 119, 60, 60, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_pan_right")
    msfs_event("H:AS1000_" .. mode_fs .. "_JOYSTICK_RIGHT")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Add joystick dn function
dn_press = button_add(nil, "arrow_down.png", pal_x + 120, pal_y + 255, 60, 60, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_pan_down")
    msfs_event("H:AS1000_" .. mode_fs .. "_JOYSTICK_DOWN")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Add joystick dnrt function
dnrt_press = button_add(nil, "arrow_downrt.png", pal_x + 209, pal_y + 209, 60, 60, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_pan_down_right")
    msfs_event("H:AS1000_" .. mode_fs .. "_JOYSTICK_RIGHT")
    msfs_event("H:AS1000_" .. mode_fs .. "_JOYSTICK_DOWN")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

-- Add joystick dnlt function
dnlt_press = button_add(nil, "arrow_downlt.png", pal_x + 30, pal_y + 209, 60, 60, function()
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_pan_down_left")
    msfs_event("H:AS1000_" .. mode_fs .. "_JOYSTICK_LEFT")
    msfs_event("H:AS1000_" .. mode_fs .. "_JOYSTICK_DOWN")
    tact_switch("PRESS")
end,
function()
    tact_switch("RELEASE")
end)

group_pan = group_add(pan_background, up_press, uprt_press, uplt_press, lt_press, rt_press, dn_press, dnrt_press, dnlt_press)
visible(group_pan, false)

-- Add joystick turn function
rng_dial = dial_add("rotary_joystick.png", 2665, 1030, 90, 90, function(direction)
    if direction ==  -1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_range_down")
        msfs_event("H:AS1000_" .. mode_fs .. "_RANGE_DEC")
        fsx_event("G1000_" .. mode_fs .. "_ZOOMIN_BUTTON")
    elseif direction == 1 then
        xpl_command("sim/GPS/g1000n"..mode_xpl.."_range_up")
        msfs_event("H:AS1000_" .. mode_fs .. "_RANGE_INC")
        fsx_event("G1000_" .. mode_fs .. "_ZOOMOUT_BUTTON")
    end
    encoder_rotate("SMALL")
end)
dial_click_rotate(rng_dial, 6)

-- Add joystick click function
button_add(nil, nil, 2690, 1055, 40, 40, function()
    pan_vis = not pan_vis
    visible(group_pan, pan_vis)
    xpl_command("sim/GPS/g1000n"..mode_xpl.."_pan_push")
    msfs_event("H:AS1000_" .. mode_fs .. "_JOYSTICK_PUSH")
    encoder_button("PRESS")
end,
function()
    encoder_button("RELEASE")
end)

-- Night layer
img_black_out = img_add_fullscreen("blackout_overlay.png")
if user_prop_get(prop_ap) then
    img_night_layer = img_add_fullscreen("night_labels_ap.png")
else
    img_night_layer = img_add_fullscreen("night_labels.png")
end
opacity(img_black_out, 0)
group_night = group_add(img_night_layer)
opacity(group_night, 0)

-- Variable subscribes
msfs_variable_subscribe("AIRSPEED INDICATED", "Knots",
                          "AUTOPILOT VERTICAL HOLD", "Bool", 
                          "AUTOPILOT FLIGHT LEVEL CHANGE", "Bool",
                          "AUTOPILOT ALTITUDE LOCK VAR", "Feet", 
                          "PLANE HEADING DEGREES MAGNETIC", "Degrees", function(ias, vs, flc, ap_alt, heading) 
    gbl_ias       = math.floor(ias)
    gbl_vs_mode   = vs 
    gbl_flc_mode  = flc
    gbl_fs_ap_alt = ap_alt
    gbl_fs_ap_hdg = math.floor(heading + 0.5)
end)

-- Variable subscribes
fsx_variable_subscribe("AIRSPEED INDICATED", "Knots",
                       "AUTOPILOT VERTICAL HOLD", "Bool", 
                       "AUTOPILOT FLIGHT LEVEL CHANGE", "Bool",
                       "AUTOPILOT ALTITUDE LOCK VAR", "Feet", 
                       "PLANE HEADING DEGREES MAGNETIC", "Degrees", function(ias, vs, flc, ap_alt, heading) 
    gbl_ias       = math.floor(ias)
    gbl_vs_mode   = vs 
    gbl_flc_mode  = flc
    gbl_fs_ap_alt = ap_alt
    gbl_fs_ap_hdg = math.floor(heading + 0.5)
end)

si_variable_subscribe("si/backlight_intensity", "DOUBLE", function(intensity)
    if user_prop_get(prop_nite) then
        opacity(img_black_out, intensity * 0.5)
        opacity(group_night, intensity)
    end
end)