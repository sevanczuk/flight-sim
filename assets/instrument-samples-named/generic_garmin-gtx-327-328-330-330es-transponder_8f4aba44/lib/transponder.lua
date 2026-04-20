-- Transponder
-- Process changes in simulator data including power and altitude etc.
--
-- Flight level/altitude displayed should be independent of altimeter setting, or altitude shown on altimeter
-- Instead, based on Pressure Altitude using QNE of 29.92 inches or 1013 hPa
--
-- Show nothing when powered off, splash screen briefly after power up, 
-- update the squawk code and flight level when driven by the simulator output
-- these may be overridden during data entry or when other pages are displayed
--
-- FS2020 and X-plane modes returned are 0 = off, 1 = standby, 2 = on, 4 = alt, 5 = Ground
-- Modes selected by buttons are       0 = off, 1 = standby, 3 = on, 4 = alt
-- Mode updated by simulator 

local TMODE_OFF = 0
local TMODE_STANDBY = 1
local TMODE_ON = 2
local TMODE_ALT = 3
local TMODE_TST = 4
local TMODE_GND = 5

function init_transponder()

    xpl_dataref_subscribe("sim/cockpit/radios/transponder_id", "INT",
                      "sim/cockpit/radios/transponder_code", "INT",
                      "sim/cockpit/radios/transponder_mode", "INT",
                      "sim/cockpit/misc/barometer_setting","FLOAT",
                      "sim/flightmodel/misc/h_ind", "FLOAT", 
                      "sim/cockpit2/gauges/indicators/vvi_fpm_pilot", "FLOAT",
                      "sim/cockpit2/switches/instrument_brightness_ratio", "FLOAT[32]",
                      "sim/cockpit2/electrical/bus_volts", "FLOAT[6]",
                      "sim/cockpit/electrical/avionics_on","INT",
                      "sim/cockpit/radios/transponder_light", "INT", 
                      callback_transponder_xpl)               
    fsx_variable_subscribe("TRANSPONDER CODE:1", "Enum", 
                       "PRESSURE ALTITUDE", "Feet",
                       "VERTICAL SPEED", "Feet per minute", 
                       "LIGHT PANEL POWER SETTING:4", "Percent",
                       "ELECTRICAL MAIN BUS VOLTAGE", "Volts", 
                       "ELECTRICAL AVIONICS BUS VOLTAGE", "Volts",
                       callback_transponder_fsx)                                 
    msfs_variable_subscribe("TRANSPONDER IDENT:1","Bool",
                       "TRANSPONDER CODE:1","BCO16",
                       "TRANSPONDER STATE:1","Enum",
                       "PRESSURE ALTITUDE","Feet",
                       "VERTICAL SPEED", "Feet per minute",
                       "LIGHT PANEL POWER SETTING:4", "Percent",
                       "ELECTRICAL MAIN BUS VOLTAGE","Volts",
                       "ELECTRICAL AVIONICS BUS VOLTAGE","Volts",
                       callback_transponder_fs2020)
end


-- Functions --

function update_transponder(ident, squawk, mode, alt, vsi, brightness, avionics_powered, reply)

    -- First time power up or power fail
    if (mode == TMODE_OFF) then
        display_page = PAGE_OFF
    elseif (mode > TMODE_OFF) and (display_page == PAGE_OFF) then
        display_page = PAGE_STARTUP
        start_splash_timer()
    end

    if (avionics_powered == false) or (mode == TMODE_OFF) then
        display_page = PAGE_OFF
        gbl_elapsed_active = false
        gbl_countup_time = 0
        gbl_flight_time = 0
        gbl_countdown_time = COUNTDOWN_INITIAL
        stop_alt_monitor()
    end

    currentCodeString = squawk

    
    if mode == TMODE_OFF then
        txt_set(txt_mode, "")
    elseif mode == TMODE_STANDBY then
        txt_set(txt_mode, "STBY")
    elseif mode == TMODE_ON then
        txt_set(txt_mode, "ON")
    elseif mode == TMODE_ALT then
        txt_set(txt_mode, "ALT")
    elseif mode == TMODE_TST then
        txt_set(txt_mode, "TST")
-- GND mode only supported in FS2020, not X-plane        
    elseif mode == TMODE_GND then
        txt_set(txt_mode, "GND")    
    end
    
    if (mode == TMODE_ON) then
        txt_set(txt_pralt_fl_val,"---")
        txt_set(txt_pralt_ft_val,"-----")
    elseif (mode == TMODE_ALT) then
        txt_set(txt_pralt_fl_val,string.format("%03.0f",var_cap(var_round(alt / 100,0),-30,999)))
        txt_set(txt_pralt_ft_val,string.format("%5.0f",var_cap(var_round(alt / 100,0)*100,-3000,99999)))
    else
        txt_set(txt_pralt_fl_val,"")
        txt_set(txt_pralt_ft_val,"")
    end
    
    visible(txt_ident, ident == 1 and mode >= 2 and display_page >= PAGE_NORMAL) 
    visible(img_pralt_dir_up,display_page == PAGE_NORMAL and vsi >= 500)
    visible(img_pralt_dir_down,display_page == PAGE_NORMAL and vsi <= -500)
    
    visible(img_reply,reply == 1 and display_page >= PAGE_NORMAL)
    if (user_prop_get(dimmer_prop)) then
        opacity(group_visible,(0.6+0.4*brightness))
    end
    
    update_display()
end

function callback_transponder_xpl(ident, squawk, mode, baro, ind_press_alt, vsi, brightness, bus_volts, avionics_on, reply)

    pressure_alt = ind_press_alt - (baro - 29.92)*1000
    avionics_powered = bus_volts[1] > 5 and avionics_on == 1

    update_transponder(ident,squawk,mode,pressure_alt, vsi, brightness[1], avionics_powered, reply)
end    

function callback_transponder_fsx(squawk, alt, vsi, brightness, bus_volts, avionics_volts)

    -- ident and mode not supported in FSX
    ident = 0

    avionics_powered = avionics_volts > 5
    update_transponder(ident, squawk, TMODE_ALT, alt, vsi, brightness/100, avionics_powered, 0)
end

function hex_to_decimal(hex)

    local returndec = 0

    for i = 3, 0, -1 do
        returndec = returndec*10 + (math.floor(hex/(16^i)) % 16)
    end

    return returndec
end


local fmode_map = {TMODE_OFF,TMODE_STANDBY,TMODE_TST,TMODE_ON,TMODE_ALT,TMODE_GND}
-- Convert FS2020 modes to X-plane        
-- Convert squawk code from hex to decimal as used by X-plane and FSX        

function callback_transponder_fs2020(ident, squawk, tmode, alt, vsi, brightness, bus_volts, avionics_volts)

    fmode = fmode_map[var_cap(tmode+1,1,6)] 
    squawk = hex_to_decimal(squawk)
    avionics_powered = avionics_volts > 5
    update_transponder(fif(ident==false,0,1), squawk, fmode, alt, vsi, brightness/100, bus_volts, 0)
end



