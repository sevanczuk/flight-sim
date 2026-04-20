-- Global variables
local gbl_vol_minor = 0
local gbl_vol_major = 0
local fs_bck_act = 0

local prop_nite = user_prop_add_boolean("Night lighting effect", false, "Dimming effect in combination with Air Manager backlight setting")

-- Background
img_add_fullscreen("background.png")

-- Row 1
button_add("btn_com_1_mic.png", "btn_com_1_mic_pressed.png", 25, 65, 146, 112, function()
    xpl_command("sim/audio_panel/transmit_audio_com1")
    fs2020_event("H:AS1000_MID_COM_Mic_1_Push")
    fs2024_event("B:AS1000_COM_1_MIC_MIDCOM", 1)
end)

button_add("btn_com_1.png", "btn_com_1_pressed.png", 157, 65, 146, 112, function()
    xpl_command("sim/audio_panel/select_audio_com1")
    fs2020_event("H:AS1000_MID_COM_1_Push")
    fs2024_event("B:AS1000_COM_1_MIDCOM", 1)
end)

-- Row 2
button_add("btn_com_2_mic.png", "btn_com_2_mic_pressed.png", 25, 187, 146, 112, function()
    xpl_command("sim/audio_panel/transmit_audio_com2")
    fs2020_event("H:AS1000_MID_COM_Mic_2_Push")
    fs2024_event("B:AS1000_COM_2_MIC_MIDCOM", 1)
end)

button_add("btn_com_2.png", "btn_com_2_pressed.png", 157, 187, 146, 112, function()
    xpl_command("sim/audio_panel/select_audio_com2")
    fs2020_event("H:AS1000_MID_COM_2_Push")
    fs2024_event("B:AS1000_COM_2_MIDCOM", 1)
end)

-- Row 3
button_add("btn_com_3_mic.png", "btn_com_3_mic_pressed.png", 25, 309, 146, 112, function()
    fs2020_event("H:AS1000_MID_COM_Mic_3_Push")
    fs2024_event("B:AS1000_COM_3_MIC_MIDCOM", 1)
end)

button_add("btn_com_3.png", "btn_com_3_pressed.png", 157, 309, 146, 112, function()
    fs2020_event("H:AS1000_MID_COM_3_Push")
    fs2024_event("B:AS1000_COM_3_MIDCOM", 1)
end)

-- Row 4
button_add("btn_com_1_2.png", "btn_com_1_2_pressed.png", 25, 431, 146, 112, function()
    fs2020_event("H:AS1000_MID_COM_Swap_1_2_Push")
    fs2024_event("B:AS1000_COM_SWAP_MIDCOM", 1)
end)

button_add("btn_tel.png", "btn_tel_pressed.png", 157, 431, 146, 112, function()
    fs2020_event("H:AS1000_MID_TEL_Push")
    fs2024_event("B:AS1000_COM_TEL_MIDCOM", 1)
end)

-- Row 5
button_add("btn_pa.png", "btn_pa_pressed.png", 25, 553, 146, 112, function()
    fs2020_event("H:AS1000_MID_PA_Push")
    fs2024_event("B:AS1000_PA_MIDCOM", 1)
end)

button_add("btn_spkr.png", "btn_spkr_pressed.png", 157, 553, 146, 112, function()
    fs2020_event("H:AS1000_MID_SPKR_Push")
    fs2024_event("B:AS1000_SPEAKER_MIDCOM", 1)
end)

-- Row 6
button_add("btn_mkr_mute.png", "btn_mkr_mute_pressed.png", 25, 675, 146, 112, function()
    xpl_command("sim/audio_panel/monitor_audio_mkr")
    fs2020_event("H:AS1000_MID_MKR_Mute_Push")
    fs2024_event("B:AS1000_MARKERMUTE_MIDCOM", 1)
end)

button_add("btn_hi_sens.png", "btn_hi_sens_pressed.png", 157, 675, 146, 112, function()
    fs2020_event("H:AS1000_MID_HI_SENS_Push")
    fs2024_event("B:AS1000_MARKERSENSITIVITYHIGH_MIDCOM", 1)
end)

-- Row 7
button_add("btn_dme.png", "btn_dme_pressed.png", 25, 797, 146, 112, function()
    xpl_command("sim/audio_panel/monitor_audio_dme")
    fs2020_event("H:AS1000_MID_DME_Push")
    fs2024_event("B:AS1000_DME_MIDCOM", 1)
end)

button_add("btn_nav_1.png", "btn_nav_1_pressed.png", 157, 797, 146, 112, function()
    xpl_command("sim/audio_panel/select_audio_nav1")
    fs2020_event("H:AS1000_MID_NAV_1_Push")
    fs2024_event("B:AS1000_NAV_1_MIDCOM", 1)
end)

-- Row 8
button_add("btn_adf.png", "btn_adf_pressed.png", 25, 919, 146, 112, function()
    xpl_command("sim/radios/select_audio_adf1")
    fs2020_event("H:AS1000_MID_ADF_Push")
    fs2024_event("B:AS1000_ADF_MIDCOM", 1)
end)

button_add("btn_nav_2.png", "btn_nav_2_pressed.png", 157, 919, 149, 112, function()
    xpl_command("sim/radios/select_audio_nav2")
    fs2020_event("H:AS1000_MID_NAV_2_Push")
    fs2024_event("B:AS1000_NAV_2_MIDCOM", 1)
end)

-- Row 9
button_add("btn_aux.png", "btn_aux_pressed.png", 25, 1041, 146, 112, function()
    fs2020_event("H:AS1000_MID_AUX_Push")
    fs2024_event("B:AS1000_AUX_MIDCOM", 1)
end)

-- Row 10
button_add("btn_man_sq.png", "btn_man_sq_pressed.png", 25, 1163, 146, 112, function()
    fs2020_event("H:AS1000_MID_MAN_SQ_Push")
    fs2024_event("B:AS1000_MAN_SQ_MIDCOM", 1)
end)

button_add("btn_play.png", "btn_play_pressed.png", 157, 1163, 146, 112, function()
    fs2020_event("H:AS1000_MID_Play_Push")
    fs2024_event("B:AS1000_PLAY_MIDCOM", 1)
end)

-- Row 10
button_add("btn_pilot.png", "btn_pilot_pressed.png", 25, 1285, 146, 112, function()
    fs2020_event("H:AS1000_MID_Isolate_Pilot_Push")
    fs2024_event("B:AS1000_ISOLATEPILOT_MIDCOM", 1)
end)

button_add("btn_coplt.png", "btn_coplt_pressed.png", 157, 1285, 146, 112, function()
    fs2020_event("H:AS1000_MID_Isolate_Copilot_Push")
    fs2024_event("B:AS1000_ISOLATECOPILOT_MIDCOM", 1)
end)

-- Night and day
img_black_out = img_add_fullscreen("blackout_overlay.png")
img_night     = img_add_fullscreen("night_labels.png")
group_night   = group_add(img_night)
opacity(img_black_out, 0.0)
opacity(group_night, 0.0)

-- Lights
img_com1_mic_on = img_add("triangle_light.png", 84, 56, 28, 16, "visible:false")
img_com1_on     = img_add("triangle_light.png", 216, 56, 28, 16, "visible:false")

img_com2_mic_on = img_add("triangle_light.png", 84, 178, 28, 16, "visible:false")
img_com2_on     = img_add("triangle_light.png", 216, 178, 28, 16, "visible:false")

img_com3_mic_on = img_add("triangle_light.png", 84, 300, 28, 16, "visible:false")
img_com3_on     = img_add("triangle_light.png", 216, 300, 28, 16, "visible:false")

img_com_1_2_on  = img_add("triangle_light.png", 84, 422, 28, 16, "visible:false")
img_tel_on      = img_add("triangle_light.png", 216, 422, 28, 16, "visible:false")

img_pa_on       = img_add("triangle_light.png", 84, 544, 28, 16, "visible:false")
img_spkr_on     = img_add("triangle_light.png", 216, 544, 28, 16, "visible:false")

img_mkr_mute_on = img_add("triangle_light.png", 84, 666, 28, 16, "visible:false")
img_hi_sens_on  = img_add("triangle_light.png", 216, 666, 28, 16, "visible:false")

img_dme_on      = img_add("triangle_light.png", 84, 788, 28, 16, "visible:false")
img_nav1_on     = img_add("triangle_light.png", 216, 788, 28, 16, "visible:false")

img_adf_on      = img_add("triangle_light.png", 84, 910, 28, 16, "visible:false")
img_nav2_on     = img_add("triangle_light.png", 216, 910, 28, 16, "visible:false")

img_aux_on      = img_add("triangle_light.png", 84, 1032, 28, 16, "visible:false")

img_man_sq_on   = img_add("triangle_light.png", 84, 1154, 28, 16, "visible:false")
img_play_on     = img_add("triangle_light.png", 216, 1154, 28, 16, "visible:false")

img_pilot_on    = img_add("triangle_light.png", 84, 1276, 28, 16, "visible:false")
img_copilot_on  = img_add("triangle_light.png", 216, 1276, 28, 16, "visible:false")

-- Simulator data
xpl_dataref_subscribe("sim/cockpit2/electrical/bus_volts", "FLOAT[2]", 
                      "sim/cockpit2/radios/actuators/audio_com_selection", "INT",
                      "sim/cockpit2/radios/actuators/audio_selection_com1", "INT",
                      "sim/cockpit2/radios/actuators/audio_selection_com2", "INT", 
                      
                      "sim/cockpit2/radios/actuators/audio_marker_enabled", "INT",

                      "sim/cockpit2/radios/actuators/audio_dme_enabled", "INT",
                      
                      "sim/cockpit2/radios/actuators/audio_selection_nav1", "INT",
                      "sim/cockpit2/radios/actuators/audio_selection_nav2", "INT",
                      "sim/cockpit2/radios/actuators/audio_selection_adf1", "INT", 
                      
                      "sim/operation/sound/radio_volume_ratio", "FLOAT", function(bus_volts, com_selection, audio_com_1, audio_com_2, audio_mkr, audio_dme, audio_nav1, audio_nav2, audio_adf, vol)
    
    local power = bus_volts[1] >= 8

    -- Com1
    visible(img_com1_mic_on, com_selection == 6 and power)
    visible(img_com1_on, audio_com_1 == 1 and power)
    
    -- Com2
    visible(img_com2_mic_on, com_selection == 7 and power)
    visible(img_com2_on, audio_com_2 == 1 and power)
    
    -- Marker / Mute
    visible(img_mkr_mute_on, audio_mkr == 1 and power)
    
    -- DME
    visible(img_dme_on, audio_dme == 1 and power)
    
    -- NAV
    visible(img_nav1_on, audio_nav1 == 1 and power)
    visible(img_nav2_on, audio_nav2 == 1 and power)
    
    -- ADF
    visible(img_adf_on, audio_adf == 1 and power)
    
    -- Volume
    gbl_vol_minor = vol

end)

fs2020_variable_subscribe("ELECTRICAL MAIN BUS VOLTAGE", "Volts", 
                          
                          "COM TRANSMIT:1","Bool",
                          "COM TRANSMIT:2","Bool",
                          
                          "COM RECEIVE:1", "Bool",
                          "COM RECEIVE:2", "Bool",
                          
                          "SPEAKER ACTIVE", "Bool",
                          
                          "MARKER BEACON TEST MUTE", "Bool",
                          "MARKER BEACON SENSITIVITY HIGH", "Bool",
                          
                          "DME SOUND", "Bool",
                          "ADF SOUND:1", "Bool",
                          
                          "NAV SOUND:1", "Bool",
                          "NAV SOUND:2", "Bool",
                          
                          "L:AS1000_MID_Display_Backup_Active", "Double",
                          
                          "AUDIO PANEL VOLUME", "Percent", function(bus_volts, mic_com_1, mic_com_2, audio_com_1, audio_com_2, audio_spkr, audio_mkr, mkr_hi_sens, audio_dme, audio_adf, audio_nav1, audio_nav2, backup_acitve)
                          
    local power = bus_volts >= 8
    
    -- Com1
    visible(img_com1_mic_on, mic_com_1 and power)
    visible(img_com1_on, audio_com_1 and power)
    
    -- Com2
    visible(img_com2_mic_on, mic_com_2 and power)
    visible(img_com2_on, audio_com_2 and power)
    
    -- Speaker
    visible(img_spkr_on, audio_spkr and power)
    
    -- Marker
    visible(img_mkr_mute_on, audio_mkr and power)
    visible(img_hi_sens_on, mkr_hi_sens and power)
    
    -- DME / ADF
    visible(img_dme_on, audio_dme and power)
    visible(img_adf_on, audio_adf and power)
    
    -- NAV
    visible(img_nav1_on, audio_nav1 and power)
    visible(img_nav2_on, audio_nav2 and power)
    
    fs_bck_act = backup_acitve
    gbl_vol_minor = vol

end)

fs2024_variable_subscribe("ELECTRICAL BUS VOLTAGE:1", "Volts", 
                          
                          "COM TRANSMIT:1","Bool",
                          "COM TRANSMIT:2","Bool",
                          "COM TRANSMIT:3","Bool",
                          
                          "COM RECEIVE:1", "Bool",
                          "COM RECEIVE:2", "Bool",
                          "COM RECEIVE:3", "Bool",
                          
                          "SPEAKER ACTIVE", "Bool",
                          
                          "MARKER BEACON TEST MUTE", "Bool",
                          "MARKER BEACON SENSITIVITY HIGH", "Bool",
                          
                          "DME SOUND", "Bool",
                          "ADF SOUND:1", "Bool",
                          
                          "NAV SOUND:1", "Bool",
                          "NAV SOUND:2", "Bool",
                          
                          "L:AS1000_MID_Display_Backup_Active", "Double",
                          
                          "B:AS1000_AUDIOPANELVOLUME_MIDCOM", "Percent",
                          "B:AS1000_AUDIOPANEL_PASS_COPILOT_MIDCOM", "Percent",
                          
                          "INTERCOM MODE", "Enum",
                          "INTERCOM SYSTEM ACTIVE", "Bool", function(bus_volts, mic_com_1, mic_com_2, mic_com_3, audio_com_1, audio_com_2, audio_com_3, audio_spkr, audio_mkr, mkr_hi_sens, audio_dme, audio_adf, audio_nav1, audio_nav2, backup_acitve, vol_major, vol_minor, intercom_mode, intercom_active)
                          
    local power = bus_volts >= 8
    
    -- Com1
    visible(img_com1_mic_on, mic_com_1 and power)
    visible(img_com1_on, audio_com_1 and power)
    
    -- Com2
    visible(img_com2_mic_on, mic_com_2 and power)
    visible(img_com2_on, audio_com_2 and power)
    
    -- Com3
    visible(img_com3_mic_on, mic_com_3 and power)
    visible(img_com3_on, audio_com_3 and power)
    
    -- Speaker
    visible(img_spkr_on, audio_spkr and power)
    
    -- Marker
    visible(img_mkr_mute_on, audio_mkr and power)
    visible(img_hi_sens_on, mkr_hi_sens and power)
    
    -- DME / ADF
    visible(img_dme_on, audio_dme and power)
    visible(img_adf_on, audio_adf and power)
    
    -- NAV
    visible(img_nav1_on, audio_nav1 and power)
    visible(img_nav2_on, audio_nav2 and power)
    
    -- ICS Isolation
    visible(img_pilot_on, (intercom_active and (intercom_mode <= 1)) and power)
    visible(img_copilot_on, (intercom_active and (intercom_mode >= 1)) and power)
    
    fs_bck_act = backup_acitve
    gbl_vol_minor = vol_minor
    gbl_vol_major = vol_major

end)

-- Rotary encoder
dial_add("rotary_outer.png", 94, 1510, 140, 140, function(dir)
    if dir == 1 then
        fs2020_event("H:AS1000_MID_Pass_Copilot_INC")
    else
        fs2020_event("H:AS1000_MID_Pass_Copilot_DEC")
    end
    fs2024_event("K:AUDIO_PANEL_VOLUME_SET", var_cap(gbl_vol_major + (5 * dir), 0, 100) )
end)

img_add("rotary_shadow_inner.png", 84, 1510, 160, 220)

dial_add("rotary_inner.png", 114, 1530, 100, 100, function(dir)
    xpl_dataref_write("sim/operation/sound/radio_volume_ratio", "FLOAT", var_cap(gbl_vol_minor + (dir * 0.05), 0, 1) )
    fs2020_event("AUDIO_PANEL_VOLUME_SET", var_cap(gbl_vol_minor + (5 * dir), 0, 100) )
    fs2024_event("B:AS1000_AUDIOPANEL_PASS_COPILOT_MIDCOM", var_cap(gbl_vol_minor + (5 * dir), 0, 100) )
end)

button_add(nil, nil, 139, 1555, 50, 50, function()
    fs2020_event("H:AS1000_MID_Pass_Copilot_DEC")
end)

-- Backup button
button_add("red_button.png", "red_button_pressed.png", 94, 1700, 140, 140, function()
    xpl_command("sim/GPS/G1000_display_reversion")
    if fs_bck_act == 1 then
        fs2020_variable_write("L:AS1000_MID_Display_Backup_Active", "Double", 0)
    else
        fs2020_variable_write("L:AS1000_MID_Display_Backup_Active", "Double", 1)
    end
    fs2024_event("B:AS1000_DISPLAYBACKUP_MIDCOM", 1)
end)

si_variable_subscribe("si/backlight_intensity", "DOUBLE", function(intensity)
    if user_prop_get(prop_nite) then
        opacity(img_black_out, intensity * 0.5)
        opacity(group_night, intensity)
    end
end)