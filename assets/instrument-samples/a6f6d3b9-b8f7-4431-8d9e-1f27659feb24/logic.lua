-- Global variables
local gbl_power = false
local gbl_channel = 0
local gbl_com_vol = 0
local gbl_com_pwr = 0
local gbl_nav_vol = 0

function new_onoff(dir)

    if dir == 1 then
        msfs_event("COM" .. gbl_channel + 1 .. "_VOLUME_INC")
    else
        msfs_event("COM" .. gbl_channel + 1 .. "_VOLUME_DEC")
    end
    
    if com_pwr == 1 then
        xpl_dataref_write("sim/cockpit2/radios/actuators/audio_volume_com" .. gbl_channel + 1, "FLOAT", var_cap(gbl_com_vol + (dir * 0.1), 0, 1) )
    end
    
    if dir == -1 and (gbl_com_vol + (dir * 0.1)) <= 0 and com_pwr == 1 then
        xpl_dataref_write("sim/cockpit2/radios/actuators/com" .. gbl_channel + 1 .. "_power", "INT", 0)
    elseif dir == 1 and com_pwr == 0 then
        xpl_dataref_write("sim/cockpit2/radios/actuators/com" .. gbl_channel + 1 .. "_power", "INT", 1)
    end
    
end

function new_navvol(dir)

    if dir == 1 then
        msfs_event("NAV" .. gbl_channel + 1 .. "_VOLUME_INC")
    else
        msfs_event("NAV" .. gbl_channel + 1 .. "_VOLUME_DEC")
    end
    
    xpl_dataref_write("sim/cockpit2/radios/actuators/audio_volume_nav" .. gbl_channel + 1, "FLOAT", var_cap(gbl_nav_vol + (dir * 0.1), 0, 1) )

end

function new_comtransfer()

    if gbl_channel == 0 then
        xpl_command("sim/radios/com1_standy_flip")
        fsx_event("COM_STBY_RADIO_SWAP")
        msfs_event("COM_STBY_RADIO_SWAP")
    else
        xpl_command("sim/radios/com2_standy_flip")
        fsx_event("COM2_RADIO_SWAP")
        msfs_event("COM2_RADIO_SWAP")
    end

end

function new_navtransfer()

    if gbl_channel == 0 then
        xpl_command("sim/radios/nav1_standy_flip")
        fsx_event("NAV1_RADIO_SWAP")
        msfs_event("NAV1_RADIO_SWAP")
    else
        xpl_command("sim/radios/nav2_standy_flip")
        fsx_event("NAV2_RADIO_SWAP")
        msfs_event("NAV2_RADIO_SWAP")
    end

end

function new_combig(combigvar)

    if gbl_channel == 0 then
        if combigvar == 1 then
            xpl_command("sim/radios/stby_com1_coarse_up")
            fsx_event("COM_RADIO_WHOLE_INC")
            msfs_event("COM_RADIO_WHOLE_INC")
        elseif combigvar == -1 then
            xpl_command("sim/radios/stby_com1_coarse_down")
            fsx_event("COM_RADIO_WHOLE_DEC")
            msfs_event("COM_RADIO_WHOLE_DEC")
        end
    else
        if combigvar == 1 then
            xpl_command("sim/radios/stby_com2_coarse_up")
            fsx_event("COM2_RADIO_WHOLE_INC")
            msfs_event("COM2_RADIO_WHOLE_INC")
        elseif combigvar == -1 then
            xpl_command("sim/radios/stby_com2_coarse_down")
            fsx_event("COM2_RADIO_WHOLE_DEC")
            msfs_event("COM2_RADIO_WHOLE_DEC")
        end
    end

end

function new_comsmall(comsmallvar)

    if gbl_channel == 0 then
        if comsmallvar == 1 then
            xpl_command("sim/radios/stby_com1_fine_up_833")
            fsx_event("COM_RADIO_FRACT_INC")
            msfs_event("COM_RADIO_FRACT_INC")
        elseif comsmallvar == -1 then
            xpl_command("sim/radios/stby_com1_fine_down_833")
            fsx_event("COM_RADIO_FRACT_DEC")
            msfs_event("COM_RADIO_FRACT_DEC")
        end
    else
        if comsmallvar == 1 then
            xpl_command("sim/radios/stby_com2_fine_up_833")
            fsx_event("COM2_RADIO_FRACT_INC")
            msfs_event("COM2_RADIO_FRACT_INC")
        elseif comsmallvar == -1 then
            xpl_command("sim/radios/stby_com2_fine_down_833")
            fsx_event("COM2_RADIO_FRACT_DEC")
            msfs_event("COM2_RADIO_FRACT_DEC")
        end
    end

end

function new_navbig(navbigvar)
    
    if gbl_channel == 0 then
        if navbigvar == 1 then
            xpl_command("sim/radios/stby_nav1_coarse_up")
            fsx_event("NAV1_RADIO_WHOLE_INC")
            msfs_event("NAV1_RADIO_WHOLE_INC")
        elseif navbigvar == -1 then
            xpl_command("sim/radios/stby_nav1_coarse_down")
            fsx_event("NAV1_RADIO_WHOLE_DEC")
            msfs_event("NAV1_RADIO_WHOLE_DEC")
        end
    else
        if navbigvar == 1 then
            xpl_command("sim/radios/stby_nav2_coarse_up")
            fsx_event("NAV2_RADIO_WHOLE_INC")
            msfs_event("NAV2_RADIO_WHOLE_INC")
        elseif navbigvar == -1 then
            xpl_command("sim/radios/stby_nav2_coarse_down")
            fsx_event("NAV2_RADIO_WHOLE_DEC")
            msfs_event("NAV2_RADIO_WHOLE_DEC")
        end
    end

end

function new_navsmall(navsmallvar)

    if gbl_channel == 0 then
        if navsmallvar == 1 then
            xpl_command("sim/radios/stby_nav1_fine_up")
            fsx_event("NAV1_RADIO_FRACT_INC")
            msfs_event("NAV1_RADIO_FRACT_INC")
        elseif navsmallvar == -1 then
            xpl_command("sim/radios/stby_nav1_fine_down")
            fsx_event("NAV1_RADIO_FRACT_DEC")
            msfs_event("NAV1_RADIO_FRACT_DEC")
        end
    else
        if navsmallvar == 1 then
            xpl_command("sim/radios/stby_nav2_fine_up")
            fsx_event("NAV2_RADIO_FRACT_INC")
            msfs_event("NAV2_RADIO_FRACT_INC")
        elseif navsmallvar == -1 then
            xpl_command("sim/radios/stby_nav2_fine_down")
            fsx_event("NAV2_RADIO_FRACT_DEC")
            msfs_event("NAV2_RADIO_FRACT_DEC")
        end
    end

end

-- Add images in Z-order --
img_add_fullscreen("KX165A.png")
redline = img_add("redline.png", 349, 34, 2, 60, "visible:false")
img_com_vol = img_add("offswitch.png", 61, 154, 47, 47, "rotate_animation_type: LINEAR; rotate_animation_speed: 0.05")
img_nav_vol = img_add("navswitch.png", 414, 156, 38, 38, "rotate_animation_type: LINEAR; rotate_animation_speed: 0.05")

-- Add text --
txt_com = txt_add(" ", "size:36px; color: #fb2c00; halign: left;", 25, 48, 200, 200)
txt_comstby = txt_add(" ", "size:36px; color: #fb2c00; halign: left;", 200, 48, 200, 200)

txt_nav = txt_add(" ", "size:36px; color: #fb2c00; halign: left;", 365, 48, 200, 200)
txt_navstby = txt_add(" ", "size:36px; color: #fb2c00; halign: left;", 520, 48, 200, 200)

-- Set default visibility --
group_powered = group_add(redline, txt_com, txt_comstby, txt_nav, txt_navstby)
visible(group_powered, false)

-- Functions --
function new_navcomm(nav1, nav1stby, com1, com1stby, nav2, nav2stby, com2, com2stby, com1_power, com2_power, com1_volume, com2_volume, nav1_volume, nav2_volume, bus_volts, avionics)
    
    if gbl_channel == 0 then
        com     = com1
        comstby = com1stby
        nav     = nav1
        navstby = nav1stby
        com_pwr = com1_power
        com_vol = com1_volume
        nav_vol = nav1_volume
    else
        com     = com2
        comstby = com2stby
        nav     = nav2
        navstby = nav2stby
        com_pwr = com2_power
        com_vol = com2_volume
        nav_vol = nav2_volume
    end
    
    gbl_power = com_pwr == 1 and bus_volts[1] >= 10 and avionics == 1
    
    gbl_com_vol = com_vol
    gbl_nav_vol = nav_vol
    gbl_com_pwr = com_pwr
    
    visible(group_powered, gbl_power)

    txt_set(txt_com, string.format("%07.03f",com/1000, com%1000) )
    txt_set(txt_comstby, string.format("%07.03f",comstby/1000, comstby%1000))
    txt_set(txt_nav, string.format("%06.02f",nav/100, nav%100))
    txt_set(txt_navstby, string.format("%06.02f",navstby/100, navstby%100) )
    
    -- Rotate the COM volume and power dial
    if com_pwr == 0 then
        rotate(img_com_vol, 0)
    else
        rotate(img_com_vol, 15 + com_vol * 250)
    end
    
    -- Rotate the NAV volume dial
    rotate(img_nav_vol, -25 +  nav_vol * 250)
    
end

function new_navcom_fsx(nav1, nav1stby, com1, com1stby, nav2, nav2stby, com2, com2stby, bus_volts, avionics)

    avionics = fif(avionics, 1, 0)
    new_navcomm(nav1*100+0.01, nav1stby*100+0.01, com1*1000+0.01, com1stby*1000+0.01, nav2*100+0.01, nav2stby*100+0.01, com2*1000+0.01, com2stby*1000+0.01, 1, 1, 1, 1, 1, 1, {bus_volts}, avionics)
    
end

function new_navcom_fs2020(nav1, nav1stby, com1, com1stby, nav2, nav2stby, com2, com2stby, com1_volume, com2_volume, nav1_volume, nav2_volume, bus_volts, avionics)

    if gbl_channel == 0 then
        com     = com1
        comstby = com1stby
        nav     = nav1
        navstby = nav1stby
        com_pwr = com1_volume > 0
        com_vol = com1_volume
        nav_vol = nav1_volume
    else
        com     = com2
        comstby = com2stby
        nav     = nav2
        navstby = nav2stby
        com_pwr = com2_volume > 0
        com_vol = com2_volume
        nav_vol = nav2_volume
    end
    
    gbl_power = com_pwr and bus_volts >= 10 and avionics
    
    visible(group_powered, gbl_power)

    txt_set(txt_com, string.format("%07.03f", com) )
    txt_set(txt_comstby, string.format("%07.03f", comstby))
    txt_set(txt_nav, string.format("%06.02f", nav))
    txt_set(txt_navstby, string.format("%06.02f", navstby) )
    
    -- Rotate the COM volume and power dial
    if com_vol == 0 then
        rotate(img_com_vol, 0)
    else
        rotate(img_com_vol, 15 + com_vol * 2.5)
    end
    
    -- Rotate the NAV volume dial
    rotate(img_nav_vol, -25 +  nav_vol * 2.5)

end

-- Switches, buttons and dials --
switch_onoff = dial_add(nil, 61, 154, 47, 47, 5, new_onoff)
nav_volume   = dial_add(nil, 414, 156, 38, 38, 5, new_navvol)
comtransfer = button_add("switchfreq.png", "switchfreqpressed.png", 130, 135, 60, 38, new_comtransfer)
navtransfer = button_add("switchfreq.png", "switchfreqpressed.png", 487, 135, 60, 38, new_navtransfer)
combig = dial_add("dialbig.png", 209, 93, 126, 126, new_combig)
comsmall = dial_add("dialsmall.png", 243, 127, 58, 58, new_comsmall)
mouse_setting(comsmall, "CURSOR_LEFT", "ctr_cursor_ccw.png")
mouse_setting(comsmall, "CURSOR_RIGHT", "ctr_cursor_cw.png")
navbig = dial_add("dialbig.png", 574, 93, 126, 126, new_navbig)
navsmall = dial_add("dialsmall.png", 608, 127, 58, 58, new_navsmall)
mouse_setting(navsmall, "CURSOR_LEFT", "ctr_cursor_ccw.png")
mouse_setting(navsmall, "CURSOR_RIGHT", "ctr_cursor_cw.png")


-- Bus subscribe --
xpl_dataref_subscribe("sim/cockpit/radios/nav1_freq_hz", "INT", 
                      "sim/cockpit/radios/nav1_stdby_freq_hz", "INT",
                      "sim/cockpit2/radios/actuators/com1_frequency_hz_833", "INT",
                      "sim/cockpit2/radios/actuators/com1_standby_frequency_hz_833", "INT",
                      "sim/cockpit/radios/nav2_freq_hz", "INT", 
                      "sim/cockpit/radios/nav2_stdby_freq_hz", "INT",
                      "sim/cockpit2/radios/actuators/com2_frequency_hz_833", "INT",
                      "sim/cockpit2/radios/actuators/com2_standby_frequency_hz_833", "INT", 
                      "sim/cockpit2/radios/actuators/com1_power", "INT",
                      "sim/cockpit2/radios/actuators/com2_power", "INT",
                      "sim/cockpit2/radios/actuators/audio_volume_com1", "FLOAT",
                      "sim/cockpit2/radios/actuators/audio_volume_com2", "FLOAT",
                      "sim/cockpit2/radios/actuators/audio_volume_nav1", "FLOAT",
                      "sim/cockpit2/radios/actuators/audio_volume_nav2", "FLOAT",
                      "sim/cockpit2/electrical/bus_volts", "FLOAT[6]", 
                      "sim/cockpit/electrical/avionics_on", "INT", new_navcomm)
fsx_variable_subscribe("NAV ACTIVE FREQUENCY:1", "Mhz",
                       "NAV STANDBY FREQUENCY:1", "Mhz",
                       "COM ACTIVE FREQUENCY:1", "Mhz",
                       "COM STANDBY FREQUENCY:1", "Mhz",
                       "NAV ACTIVE FREQUENCY:2", "Mhz",
                       "NAV STANDBY FREQUENCY:2", "Mhz",
                       "COM ACTIVE FREQUENCY:2", "Mhz",
                       "COM STANDBY FREQUENCY:2", "Mhz", 
                       "ELECTRICAL AVIONICS BUS VOLTAGE", "Volts", 
                       "AVIONICS MASTER SWITCH", "Bool", new_navcom_fsx)
fs2020_variable_subscribe("NAV ACTIVE FREQUENCY:1", "Mhz",
                          "NAV STANDBY FREQUENCY:1", "Mhz",
                          "COM ACTIVE FREQUENCY:1", "Mhz",
                          "COM STANDBY FREQUENCY:1", "Mhz",
                          "NAV ACTIVE FREQUENCY:2", "Mhz",
                          "NAV STANDBY FREQUENCY:2", "Mhz",
                          "COM ACTIVE FREQUENCY:2", "Mhz",
                          "COM STANDBY FREQUENCY:2", "Mhz", 
                          "COM VOLUME:1", "Percent",
                          "COM VOLUME:2", "Percent",
                          "NAV VOLUME:1", "Percent",
                          "NAV VOLUME:2", "Percent",
                          "ELECTRICAL MAIN BUS VOLTAGE", "Volts", 
                          "AVIONICS MASTER SWITCH", "Bool", new_navcom_fs2020)
fs2024_variable_subscribe("NAV ACTIVE FREQUENCY:1", "Mhz",
                          "NAV STANDBY FREQUENCY:1", "Mhz",
                          "COM ACTIVE FREQUENCY:1", "Mhz",
                          "COM STANDBY FREQUENCY:1", "Mhz",
                          "NAV ACTIVE FREQUENCY:2", "Mhz",
                          "NAV STANDBY FREQUENCY:2", "Mhz",
                          "COM ACTIVE FREQUENCY:2", "Mhz",
                          "COM STANDBY FREQUENCY:2", "Mhz", 
                          "COM VOLUME:1", "Percent",
                          "COM VOLUME:2", "Percent",
                          "NAV VOLUME:1", "Percent",
                          "NAV VOLUME:2", "Percent",
                          "ELECTRICAL BUS VOLTAGE:1", "Volts", 
                          "AVIONICS MASTER SWITCH", "Bool", new_navcom_fs2020) 