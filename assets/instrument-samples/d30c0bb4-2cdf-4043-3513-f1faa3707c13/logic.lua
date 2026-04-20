-- Garmin 340 Audio Panel--
-- Created by--
-- Snake Stack Solutions--
-- Updated by Evan Smith to include Prepar3d / fsx(?)--
-- Updated by Siminnovations to support FS2020
--
-- Updated by David Chambers Oct 2022 to include:
-- Extending graphics to include volume control legends
-- Adding Marker Beacon Sensitity switching and LEDs
-- COM1/2 switching when listening to both
-- Speaker, PA button and light functions linked to sim where supported
-- Pilot and Crew isolation buttons/lights operation (not directly supported by any sim)
-- External speaker (available in FS2020 only)
-- Radio volume control implemented for pilot side only and for X-Plane only
-- Avionics power required before unit functions
-- Self test on power-up illuminates all lights for 1 second
-- Configuration option for rounded or rectangular corners
--
-- Known limitations
-- COM3 button does nothing (which matches 99% of real world aircraft)

prop_backplate = user_prop_add_boolean("Black rectangular corners",false,"Tick to fill in the corners, leave blank for rounded corners")
prop_val_backplate = user_prop_get(prop_backplate)

if prop_val_backplate then
    img_add_fullscreen("340black_backplate.png")
end    
img_add_fullscreen("340body.png")
img_add_fullscreen("markers.png")
img_outter = img_add_fullscreen("outtermkr_lit.png")
img_middle = img_add_fullscreen("middlemkr_lit.png")
img_inner = img_add_fullscreen("innermkr_lit.png")

-- Constants for selected comm values expected by XPlane per original code
local Comm1 = 6
local Comm2 = 7

local gbl_volume = 0
local gbl_test   = false
local gbl_power  = false


local STATE_OFF = 0
local STATE_POWERUP_LIGHTS_OFF = 1
local STATE_POWERUP_LIGHTS_ON = 2
local STATE_ON = 3

local gbl_state = STATE_OFF

local fsxData = false 

local selectedTrRadio = Comm1

local monCom1 = false
local monCom2 = false
local monBoth = false

ISOLATE_NORMAL = 1
ISOLATE_PILOT = 2
ISOLATE_CREW = 3

local isolate = ISOLATE_NORMAL

local spkr_active = false
local pa_active = false
local com12_active = false
local mkr_sens_high = false

--
function request_callback_all()
    request_callback(new_audio_data_xpl)
    request_callback(new_audio_data_fsx_p3d)
    request_callback(new_audio_data_fs2020)
end

function adf_press()
    if (gbl_power) then
        xpl_command("sim/audio_panel/monitor_audio_adf1")
        -- confirmed fsx and prepar3d 
        fsx_event("RADIO_ADF_IDENT_TOGGLE")
        msfs_event("RADIO_ADF_IDENT_TOGGLE")
    end
end

function dme_press()

    if (gbl_power) then
        xpl_command("sim/audio_panel/monitor_audio_dme")
        -- confirmed fsx and prepar3d 
        fsx_event("RADIO_SELECTED_DME_IDENT_TOGGLE")
        msfs_event("RADIO_SELECTED_DME_IDENT_TOGGLE")
    end
end


function nav2_press()

    if (gbl_power) then
        xpl_command("sim/audio_panel/monitor_audio_nav2")
        -- confirmed fsx and prepar3d 
        fsx_event("RADIO_VOR2_IDENT_TOGGLE")
        msfs_event("RADIO_VOR2_IDENT_TOGGLE")
    end
end

function nav1_press()
    if (gbl_power) then
        xpl_command("sim/audio_panel/monitor_audio_nav1")
        -- confirmed fsx and prepar3d 
        fsx_event("RADIO_VOR1_IDENT_TOGGLE")
        msfs_event("RADIO_VOR1_IDENT_TOGGLE")
    end
end

function com3_press()
end

function com2_press()

    if (gbl_power) then
        -- Not permitted to turn off COM2 receiver when set to transmit on COM2
        if (selectedTrRadio == Comm1) then
            xpl_command("sim/audio_panel/monitor_audio_com2")
        
            -- confirmed fsx and prepar3d 
            fsx_event("COM_RECEIVE_ALL_TOGGLE")
            msfs_event("COM_RECEIVE_ALL_TOGGLE")
        end
        
        monBoth = monCom1 and monCom2      
    end
end

function com1_press()

    if (gbl_power) then
        -- Not permitted to turn off COM1 receiver when set to transmit on COM1
        if (selectedTrRadio == Comm2) then
            xpl_command("sim/audio_panel/monitor_audio_com1")
        
            -- confirmed fsx and prepar3d 
            fsx_event("COM_RECEIVE_ALL_TOGGLE")
            msfs_event("COM_RECEIVE_ALL_TOGGLE")
        end

        monBoth = monCom1 and monCom2
    end
end

function mkr_press()

    if (gbl_power) then
        xpl_command("sim/annunciator/marker_beacon_mute_or_off")
        -- confirmed fsx and prepar3d 
        fsx_event("MARKER_SOUND_TOGGLE")
        msfs_event("MARKER_SOUND_TOGGLE")
    end
end

function mic1()

    if (gbl_power) then
    
        monBoth = monCom1 and monCom2
            
        xpl_command("sim/audio_panel/transmit_audio_com1")
        -- confirmed fsx and prepar3d 
        fsx_event("COM1_TRANSMIT_SELECT")
        msfs_event("COM1_TRANSMIT_SELECT")    
            
        if monBoth then
            xpl_command("sim/audio_panel/monitor_audio_com2_on")
            if (selectedTrRadio == Comm1)
            then
                -- confirmed fsx and prepar3d 
                fsx_event("COM_RECEIVE_ALL_SET",1)
                msfs_event("COM_RECEIVE_ALL_SET",1)
            end
        end
    end
end

function mic2()

    if (gbl_power) then

        monBoth = monCom1 and monCom2
        xpl_command("sim/audio_panel/transmit_audio_com2")
        -- confirmed fsx and prepar3d
        fsx_event("COM2_TRANSMIT_SELECT")
        msfs_event("COM2_TRANSMIT_SELECT")    
        
        if monBoth then
            xpl_command("sim/audio_panel/monitor_audio_com1_on")
            if (selectedTrRadio == Comm2)
            then
                -- confirmed fsx and prepar3d 
                fsx_event("COM_RECEIVE_ALL_SET",1)
                msfs_event("COM_RECEIVE_ALL_SET",1)
            end
        end
        
    end
end

function mic3()
end

function com12_press()
    com12_active = not com12_active
    request_callback_all()
end

function sens_press()
    if (gbl_power) then
        -- Toggle the local variable in case aircraft model does not support it
        -- if it does then this value will be overwritten on data refresh from sim
        mkr_sens_high = not mkr_sens_high
        request_callback_all()
        
        xpl_command("sim/annunciator/marker_beacon_sens_toggle")
        -- not supported by fsx or Prepar3d (V1-5)
        msfs_event("MARKER_BEACON_SENSITIVITY_HIGH", fif(mkr_sens_high,0,1))

    end
end

function test_press()
    if (gbl_power) then
        gbl_test = true
        request_callback_all()
    end
end

function test_release()
    if (gbl_power) then
        gbl_test = false
        request_callback_all()
    end
end

function spkr_press()

    if (gbl_power) then
        spkr_active = not spkr_active
        request_callback_all()
    end    
end

function pa_press()

    if (gbl_power) then
        pa_active = not pa_active
        request_callback_all()
    end
end

function pilot_press()

    if (gbl_power) then
        if isolate == ISOLATE_PILOT then
            isolate = ISOLATE_NORMAL
        else
            isolate = ISOLATE_PILOT
        end        
        request_callback_all()
     end
end

function crew_press()

    if (gbl_power) then
        if (isolate == ISOLATE_CREW) then
            isolate = ISOLATE_NORMAL
        else
            isolate = ISOLATE_CREW
        end
        request_callback_all()
    end
end

function knob_turn_pilot(direction)
    if (gbl_power) then
        xpl_dataref_write("sim/operation/sound/radio_volume_ratio", "FLOAT", var_cap(gbl_volume + (direction * 0.05), 0, 1) )
        -- not supported by fsx / prepar3d
        -- No event ID to drive FS2020, although there is a non-writeable data variable output from the simulator
    end
end

function knob_turn_copilot()
end

adf_key = button_add("button2.png", "button2press.png", 695, 13, 61, 51, adf_press, adf_release)
adf_on = img_add("button2on.png", 695, 13, 61, 51)

dme_key = button_add("button2.png", "button2press.png", 623, 13, 61, 51, dme_press, nil)
dme_on = img_add("button2on.png", 624, 13, 61, 51)

nav2_key = button_add("button2.png", "button2press.png", 550, 13, 61, 51, nav2_press, nil)
nav2_on = img_add("button2on.png", 550, 13, 61, 51)

nav1_key = button_add("button2.png", "button2press.png", 472, 13, 61, 51, nav1_press, nil)
nav1_on = img_add("button2on.png", 472, 13, 61, 51)

com1_key = button_add("button2.png", "button2press.png", 218, 13, 61, 51, com1_press, nil)
com1_on = img_add("button2on.png", 218, 13, 61, 51)

com2_key = button_add("button2.png", "button2press.png", 293, 13, 61, 51, com2_press, nil)
com2_on = img_add("button2on.png", 293, 13, 61, 51)

com3_key = button_add("button2.png", "button2press.png", 366, 13, 61, 51, com3_press, nil)
com3_on = img_add("button2on.png", 366, 13, 61, 51)

mkr_key = button_add("button2.png", "button2press.png", 138, 13, 61, 51, mkr_press, nil)
mkr_on = img_add("button2on.png", 138, 13, 61, 51)

com1mic_key = button_add("button1.png", "button1press.png", 218, 75, 61, 89, mic1, nil)
com1mic_on = img_add("button1on.png", 218, 75, 61, 89)

com2mic_key = button_add("button1.png", "button1press.png", 293, 75, 61, 89, mic2, nil)
com2mic_on = img_add("button1on.png", 293, 75, 61, 89)

com3mic_key = button_add("button1.png", "button1press.png", 366, 75, 61, 89, mic3, nil)
com3mic_on = img_add("button1on.png", 366, 75, 61, 89)

com1_2mic_key = button_add("button1.png", "button1press.png", 472, 75, 61, 89, com12_press, nil)
com1_2mic_on = img_add("button1on.png", 472, 75, 61, 89)

sens_key = button_add("button3.png", "button3press.png", 138, 130,67, 34, sens_press, nil)
test_key = button_add("button3.png", "button3press.png", 808, 24,67, 34, test_press, test_release)

spkr_key = button_add("button4.png", "button4press.png", 545, 74, 98, 36, spkr_press, nil)
spkr_on = img_add("button4on.png", 545, 74, 98, 36)

pa_key = button_add("button4.png", "button4press.png", 545, 126, 98, 36, pa_press, nil)
pa_on = img_add("button4on.png", 545, 126, 98, 36)

pilot_key = button_add("button4.png", "button4press.png", 660, 74, 98, 36, pilot_press, nil)
pilot_on = img_add("button4on.png", 660, 74, 98, 36)

crew_key = button_add("button4.png", "button4press.png", 660, 126, 98, 36, crew_press, nil)
crew_on = img_add("button4on.png", 660, 126, 98, 36)

mkr_sens_hi_on = img_add("button1on.png", 128, 79, 61, 89)
mkr_sens_lo_on = img_add("button1on.png", 128, 99, 61, 89)

pilot_knob = dial_add("knob.png", 20, 70, 80, 80, knob_turn_pilot)
dial_click_rotate(pilot_knob, 3)

copilot_knob = dial_add("knob.png", 800, 70, 80, 80, knob_turn_copilot)
dial_click_rotate(copilot_knob, 3)

visible(mkr_on, false)
    
visible(img_outter, false)
visible(img_middle, false)
visible(img_inner, false)

visible(com1_on, false)
visible(com1mic_on, false)

visible(com2_on, false)
visible(com2mic_on, false)

visible(com3_on, false)
visible(com3mic_on, false)

visible(nav1_on, false)
visible(nav2_on, false)
visible(dme_on, false)
visible(adf_on, false)
    
visible(com1_2mic_on, false)
visible(spkr_on, false)
visible(pa_on, false)
visible(pilot_on, false)
visible(crew_on, false)

visible(mkr_sens_lo_on, false)
visible(mkr_sens_hi_on, false)

function callback_timer_powerup(count)
    
    if (gbl_state == STATE_OFF) then
        timer_stop(timer_powerup)
    elseif (gbl_state == STATE_POWERUP_LIGHTS_OFF) then
        gbl_state = STATE_POWERUP_LIGHTS_ON
        request_callback_all()
    else
        gbl_state = STATE_ON
        timer_stop(timer_powerup)
    end      
    request_callback_all()     
end

function audio_callback(adf, nav2, nav1, com2, com1, com_sel, mkr, dme, outter, middle, inner, volume, battery_on, avionics_on, spkr_lit)

    gbl_power = fif(battery_on > 0 and avionics_on > 0, true, false)
    if (gbl_power == false) then
        gbl_state = STATE_OFF
        timer_stop(timer_powerup)
    elseif (gbl_power and (gbl_state == STATE_OFF)) then
        gbl_state = STATE_POWERUP_LIGHTS_OFF
        timer_powerup = timer_start(1000,1000,callback_timer_powerup)
        gbl_power = false
    end
    
    test_lit = gbl_test or (gbl_state == STATE_POWERUP_LIGHTS_ON)

    selectedTrRadio = com_sel
    
    monCom1 = (com1 == 1)
    monCom2 = (com2 == 1)   
    
    visible(mkr_on, (mkr == 0 or test_lit) and gbl_power)
    visible(mkr_sens_lo_on, (not mkr_sens_high or test_lit) and gbl_power)
    visible(mkr_sens_hi_on, (mkr_sens_high or test_lit) and gbl_power)
    
    visible(img_outter, (outter == 1 or test_lit) and gbl_power)
    visible(img_middle, (middle == 1 or test_lit) and gbl_power)
    visible(img_inner, (inner == 1 or test_lit) and gbl_power)

    gbl_volume = volume

    visible(com1_on, (com1 == 1 or com12_active or test_lit) and gbl_power)
    visible(com1mic_on, (com_sel == Comm1 or com12_active or test_lit) and gbl_power)

    visible(com2_on, (com2 == 1 or com12_active or test_lit) and gbl_power)
    visible(com2mic_on, (com_sel == Comm2 or com12_active or test_lit) and gbl_power)

    visible(com3_on, test_lit and gbl_power)
    visible(com3mic_on, test_lit and gbl_power)

    visible(nav1_on, (nav1 == 1 or test_lit) and gbl_power)
    visible(nav2_on, (nav2 == 1 or test_lit) and gbl_power)
    visible(dme_on, (dme == 1 or test_lit) and gbl_power)
    visible(adf_on, (adf == 1 or test_lit) and gbl_power)
    
    visible(com1_2mic_on, (com12_active or test_lit) and gbl_power)
    visible(spkr_on, (spkr_lit or test_lit) and gbl_power)
    visible(pa_on, (pa_active or test_lit) and gbl_power)
    visible(pilot_on, ((isolate == ISOLATE_PILOT) or test_lit) and gbl_power)
    visible(crew_on, ((isolate == ISOLATE_CREW) or test_lit) and gbl_power)
    
end

function new_audio_data_xpl(adf, nav2, nav1, com2, com1, com_sel, mkr, dme, outter, middle, inner, volume, battery_on, avionics_on)

    audio_callback(adf, nav2, nav1, com2, com1, com_sel, mkr, dme, outter, middle, inner, volume, battery_on, avionics_on,spkr_active)
end

function bool_to_number(value)
    return value and 1 or 0
end

function new_audio_data_fsx_p3d(fsxAvionics, fsxOM, fsxMM, fsxIM, fsxMS,fsxCT1,fsxCT2,fsxCRA,fsxNS1,fsxNS2,fsxADF,fsxDME,fsxBattery)
 
    fsxData = true

    -- Reset listen buttons based on com recieve all
    if (fsxCRA)
    then
        com1 = 1
        com2 = 1
    else 
        com1 = bool_to_number(fsxCT1)
        com2 = bool_to_number(fsxCT2)
    end

    -- set xp transmit value based on whether fsx comm 1 transmit is set
    if (fsxCT1)
    then
        com_sel = Comm1
    else
        com_sel = Comm2
    end
 
    adf = bool_to_number(fsxADF)
    nav1 = bool_to_number(fsxNS1)
    nav2 = bool_to_number(fsxNS2)
    mkr = bool_to_number(fsxMS)
    dme = bool_to_number(fsxDME)
    outter = bool_to_number(fsxOM)
    middle = bool_to_number(fsxMM)
    inner = bool_to_number(fsxIM)
    volume = 0
    battery_on = bool_to_number(fsxBattery)
    avionics_on = bool_to_number(fsxAvionics)

    new_audio_data_xpl(adf, nav2, nav1, com2, com1, com_sel, mkr, dme, outter, middle, inner, volume, battery_on, avionics_on,spkr_active)

end

function new_audio_data_fs2020(fsxAvionics, fsxOM, fsxMM, fsxIM, fsxMS,fsxCT1,fsxCT2,fsxCRA,fsxNS1,fsxNS2,fsxADF,fsxDME,speaker_on,fsxBattery,fsxMBSens,fsx_Volume)
 
    fsxData = true

    -- Reset listen buttons based on com recieve all
    if (fsxCRA)
    then
        com1 = 1
        com2 = 1
    else 
        com1 = bool_to_number(fsxCT1)
        com2 = bool_to_number(fsxCT2)
    end

    -- set xp transmit value based on whether fsx comm 1 transmit is set
    if (fsxCT1)
    then
        com_sel = Comm1
    else
        com_sel = Comm2
    end
 
    adf = bool_to_number(fsxADF)
    nav1 = bool_to_number(fsxNS1)
    nav2 = bool_to_number(fsxNS2)
    mkr = bool_to_number(fsxMS)
    dme = bool_to_number(fsxDME)
    outter = bool_to_number(fsxOM)
    middle = bool_to_number(fsxMM)
    inner = bool_to_number(fsxIM)
    volume = 0
    battery_on = bool_to_number(fsxBattery)
    avionics_on = bool_to_number(fsxAvionics)
    
    mkr_sens_high = bool_to_number(fsxMBSens) == 1

    audio_callback(adf, nav2, nav1, com2, com1, com_sel, mkr, dme, outter, middle, inner, volume, battery_on, avionics_on,speaker_on or spkr_active)

end

xpl_dataref_subscribe("sim/cockpit2/radios/actuators/audio_selection_adf1", "INT",
                      "sim/cockpit2/radios/actuators/audio_selection_nav2", "INT",
                      "sim/cockpit2/radios/actuators/audio_selection_nav1", "INT",
                      "sim/cockpit2/radios/actuators/audio_selection_com2", "INT",
                      "sim/cockpit2/radios/actuators/audio_selection_com1", "INT",
                      "sim/cockpit2/radios/actuators/audio_com_selection", "INT",
                      "sim/cockpit2/radios/actuators/audio_marker_enabled", "INT",
                      "sim/cockpit2/radios/actuators/audio_dme_enabled", "INT", 
                      "sim/cockpit2/radios/indicators/outer_marker_lit", "INT",
                      "sim/cockpit2/radios/indicators/middle_marker_lit", "INT",
                      "sim/cockpit2/radios/indicators/inner_marker_lit", "INT",
                      "sim/operation/sound/radio_volume_ratio", "FLOAT", 
                      "sim/cockpit/electrical/battery_on", "INT", 
                      "sim/cockpit/electrical/avionics_on", "INT", new_audio_data_xpl)

fsx_variable_subscribe("CIRCUIT AVIONICS ON", "Bool",
                       "OUTER MARKER", "Bool",
                       "MIDDLE MARKER", "Bool",
                       "INNER MARKER", "Bool",
                       "MARKER SOUND", "Bool",
                       "COM TRANSMIT:1", "Bool",
                       "COM TRANSMIT:2", "Bool",
                       "COM RECEIVE ALL", "Bool",
                       "NAV SOUND:1", "Bool",
                       "NAV SOUND:2", "Bool", 
                       "ADF SOUND:1", "Bool",
                       "DME SOUND", "Bool",
                       "ELECTRICAL MASTER BATTERY","Bool",new_audio_data_fsx_p3d)
                       
msfs_variable_subscribe("CIRCUIT AVIONICS ON", "Bool",
                          "OUTER MARKER", "Bool",
                          "MIDDLE MARKER", "Bool",
                          "INNER MARKER", "Bool",
                          "MARKER SOUND", "Bool",
                          "COM TRANSMIT:1", "Bool",
                          "COM TRANSMIT:2", "Bool",
                          "COM RECEIVE ALL", "Bool",
                          "NAV SOUND:1", "Bool",
                          "NAV SOUND:2", "Bool", 
                          "ADF SOUND:1", "Bool",
                          "DME SOUND", "Bool",
                          "SPEAKER ACTIVE", "Bool",
                          "ELECTRICAL MASTER BATTERY","Bool",
                          "MARKER BEACON SENSITIVITY HIGH","Bool",
                          "AUDIO PANEL VOLUME","Percent",
                          new_audio_data_fs2020)                       

img_add_fullscreen("340letteringv2.png")
img_add_fullscreen("marker_text.png")