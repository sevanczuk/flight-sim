---------------------------------------------
--             Chronometer                 --
-- Modification of Russ Barlows original   --
--                OAT & Time indicator     --
-- Brian McMullan 20180324                 -- 
-- Property for background off/on          --
-- Property for dimming overlay            --
---------------------------------------------

---------------------------------------------
--   Properties                            --
---------------------------------------------
prop_BG = user_prop_add_boolean("Background Display",true,"Hide background?")
prop_DO = user_prop_add_boolean("Dimming Overlay",false,"Enable dimming overlay?")

---------------------------------------------
--   Load and display images in Z-order    --
--   Loaded images selectable with prop    --
---------------------------------------------
-- Load images in Z-order --
if user_prop_get(prop_BG) == false then
    img_add_fullscreen("Chrono.png")
else
    img_add_fullscreen("ChronowBG.png")
end    
img_on = img_add_fullscreen("ChronoON.png")
img_light = img_add_fullscreen("ChronoONLight.png")
img_UT = img_add("arrowup.png",57,213,34,6)
img_FT = img_add("arrowdown.png",57,222,34,6)
img_LT = img_add("arrowup.png",105,213,34,6)
img_ET = img_add("arrowdown.png",105,222,34,6)

if user_prop_get(prop_DO) == true then
    img_add_fullscreen("dimoverlay.png")
end

-- Load text in Z-order --
txt_time = txt_add(" ", "size:74px; color: black; halign: right;", 137, 185, 200, 100)
txt_tempvolt = txt_add(" ", "size:74px; color: black; halign: center;", 48, 100, 300, 250)

-- Set default visibility --
visible(img_on, false)
visible(img_light, false)
visible(img_UT, false)
visible(img_FT, false)
visible(img_LT, false)
visible(img_ET, false)
visible(txt_time, false)

-- General vars --
local gbl_power      = false
local gbl_oatv_state = 0
local gbl_time_state = 0
local gbl_time_reset = 0

-- Button functions --
function new_oatv()
    gbl_oatv_state = (gbl_oatv_state + 1) % 3
end

function new_time()
    gbl_time_state = (gbl_time_state + 1) % 4
end

local stopwatch_seconds = 0
local stopwatch_minutes = 0
function new_control_pressed()
    if gbl_time_state == 3 and gbl_power then
        timer_stop(timer_stopwatch_reset)
        timer_stopwatch_reset = timer_start(1000, nil, function()
            xpl_command("sim/instruments/timer_reset")
            stopwatch_seconds = 0
            stopwatch_minutes = 0
        end)
    end

    if (fsx_connected() or p3d_connected() or msfs_connected()) and not timer_running(timer_stopwatch) and gbl_time_state == 3 and gbl_power then
        timer_stopwatch = timer_start(nil, 1000, function(count)
            stopwatch_seconds = var_cap(stopwatch_seconds + 1, 0, 3599)
            stopwatch_minutes = var_cap(((stopwatch_seconds / 60) - ((stopwatch_seconds / 60)%1))%60, 0, 59)
        end)
    elseif fsx_connected() or p3d_connected() or msfs_connected() and timer_running(timer_stopwatch) then
        timer_stop(timer_stopwatch)
    end
    
    xpl_command("sim/instruments/timer_start_stop")
end

function new_control_released()
    timer_stop(timer_stopwatch_reset)
end

-- Functions --
function new_timeoat(zulu_hours, zulu_minutes, local_hours, local_minutes, time_flight, elapsed_minutes, elapsed_seconds, temperature, light, voltage, bus_voltage)

    gbl_power = bus_voltage[1] >= 10
    visible(img_on, gbl_power)
    visible(img_light, light >= 1 and gbl_power)
    
    if gbl_time_state == 0 then
        vis_time = string.format("%02.0f:%02.0f", (zulu_hours - (zulu_hours%1)), (zulu_minutes - (zulu_minutes%1))%60)
    elseif gbl_time_state == 1 then
        vis_time = string.format("%02.0f:%02.0f", (local_hours - (local_hours%1)), (local_minutes - (local_minutes%1))%60)
    elseif gbl_time_state == 2 then
        vis_time = string.format("%02.0f:%02.0f",(time_flight / 3600), ( (time_flight / 60) % 60) )
    elseif gbl_time_state == 3 then
        vis_time = string.format("%02.0f:%02.0f", elapsed_minutes, elapsed_seconds)
    end

    visible(img_UT, gbl_time_state == 0 and gbl_power)
    visible(img_FT, gbl_time_state == 2 and gbl_power)
    visible(img_LT, gbl_time_state == 1 and gbl_power)
    visible(img_ET, gbl_time_state == 3 and gbl_power)
    
    if gbl_oatv_state == 0 and gbl_power then
        txt_set(txt_tempvolt, string.format("T " .. "%.0f" .. "'C", temperature ) )
    elseif gbl_oatv_state == 1 and gbl_power then
        txt_set(txt_tempvolt, string.format("T " .. "%.0f" .. "'F", (temperature * 1.8) + 32 ) )
    elseif gbl_oatv_state == 2 and gbl_power then
        txt_set(txt_tempvolt, var_format(voltage[1], 1) .. "E" )
    else
        txt_set(txt_tempvolt, " ")
    end
    
    visible(txt_time, gbl_power)
    txt_set(txt_time, vis_time)
    
end

function new_timeoat_fsx(zulu_hours, zulu_minutes, local_hours, local_minutes, time_elapsed, temperature, light, voltage, bus_voltage)

    light = fif(light, 1, 0)

    -- There is no flight time and timer elapsed time in FSX
    new_timeoat(zulu_hours, zulu_minutes, local_hours, local_minutes, time_elapsed, stopwatch_minutes, stopwatch_seconds%60, temperature, light, {bus_voltage}, {bus_voltage})
end

---------------------------------------------
-- Switches, buttons and dials             --
---------------------------------------------
button_oatv    = button_add("buttonred.png","buttonredpr.png",140,-16,120,120, new_oatv)
button_time    = button_add("buttonblue.png", "buttonbluepr.png", 60, 280, 120, 120, new_time)
button_control = button_add("buttonblue.png", "buttonbluepr.png", 223, 280, 120, 120, new_control_pressed, new_control_released)

hw_button_add("OAT/Volt button", new_oatv)
hw_button_add("Select button", new_time)
hw_button_add("Control button", new_control_pressed, new_control_released)

---------------------------------------------
--   Simulator Subscriptions               --
---------------------------------------------
xpl_dataref_subscribe("sim/cockpit2/clock_timer/zulu_time_hours", "INT", 
                      "sim/cockpit2/clock_timer/zulu_time_minutes", "INT",
                      "sim/cockpit2/clock_timer/local_time_hours", "INT",
                      "sim/cockpit2/clock_timer/local_time_minutes", "INT",
                      "sim/time/total_flight_time_sec", "FLOAT",
                      "sim/cockpit2/clock_timer/elapsed_time_minutes", "INT",
                      "sim/cockpit2/clock_timer/elapsed_time_seconds", "INT",
                      "sim/weather/temperature_ambient_c", "FLOAT",
                      "sim/cockpit/electrical/cockpit_lights_on", "INT", 
                      "sim/cockpit2/electrical/battery_voltage_indicated_volts", "FLOAT[8]", 
                      "sim/cockpit2/electrical/bus_volts", "FLOAT[6]", new_timeoat)

fsx_variable_subscribe("ZULU TIME", "Hours",
                       "ZULU TIME", "Minutes",
                       "LOCAL TIME", "Hours",
                       "LOCAL TIME", "Minutes",
                       "SIM TIME", "Seconds",
                       "TOTAL AIR TEMPERATURE", "Celsius", 
                       "LIGHT PANEL", "Bool", 
                       "ELECTRICAL BATTERY VOLTAGE", "Volts",
                       "ELECTRICAL MAIN BUS VOLTAGE", "Volts", new_timeoat_fsx)
                       
fs2020_variable_subscribe("ZULU TIME", "Hours",
                          "ZULU TIME", "Minutes",
                          "LOCAL TIME", "Hours",
                          "LOCAL TIME", "Minutes",
                          "SIM TIME", "Seconds",
                          "AMBIENT TEMPERATURE", "Celsius", 
                          "LIGHT PANEL", "Bool", 
                          "ELECTRICAL BATTERY VOLTAGE", "Volts",
                          "ELECTRICAL MAIN BUS VOLTAGE", "Volts", new_timeoat_fsx)

fs2024_variable_subscribe("ZULU TIME", "Hours",
                          "ZULU TIME", "Minutes",
                          "LOCAL TIME", "Hours",
                          "LOCAL TIME", "Minutes",
                          "SIM TIME", "Seconds",
                          "AMBIENT TEMPERATURE", "Celsius", 
                          "LIGHT PANEL", "Bool", 
                          "ELECTRICAL BATTERY VOLTAGE", "Volts",
                          "ELECTRICAL BUS VOLTAGE:1", "Volts", new_timeoat_fsx) 
                       
---------------------------------------------
--   END   Chronometer                     --
---------------------------------------------