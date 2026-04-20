-- Global variables
local gbl_power = false
local gbl_aoa   = 0
local gbl_blink = false
local gbl_test  = false
local gbl_mute  = false

-- Images
img_add_fullscreen("gi260_background.png")

img_red1 = img_add("gi260_rv_on.png", 30, 23, 190, 106)
img_red2 = img_add("gi260_rv_on.png", 30, 69, 190, 106)

img_yel1 = img_add("gi260_yv_on.png", 30, 115, 190, 106)
img_yel2 = img_add("gi260_yv_on.png", 30, 161, 190, 106)
img_yel3 = img_add("gi260_sy_on.png", 30, 247, 190, 18)
img_yel4 = img_add("gi260_by_on.png", 30, 283, 190, 18)

img_gre1 = img_add("gi260_sg_on.png", 30, 318, 190, 18)
img_gre2 = img_add("gi260_gc_on.png", 105, 307, 40, 40)
img_gre3 = img_add("gi260_bg_on.png", 30, 353, 190, 18)
img_gre4 = img_add("gi260_bg_on.png", 30, 389, 190, 18)
img_gre5 = img_add("gi260_bg_on.png", 30, 425, 190, 18)

group_lights = group_add(img_red1, img_red2, img_yel1, img_yel2, img_yel3, img_yel4, img_gre1, img_gre2, img_gre3, img_gre4, img_gre5)
visible(group_lights, false)

-- Functions
function test_callback_pressed()
    gbl_test = true
    request_callback(new_data_xpl)
    request_callback(new_data_fs2020)
end

function test_callback_released()
    gbl_test = false
    request_callback(new_data_xpl)
    request_callback(new_data_fs2020)
end

function mute_callback_pressed()
    gbl_mute = not gbl_mute
end

function new_data_xpl(voltage, aoa)

    gbl_power = voltage[1] >= 10
    
    gbl_aoa = aoa
    
    -- Approach target AOA indicator (circle)
    visible(img_gre2, gbl_power)

    -- Other lights
    visible(img_red1, gbl_test and not timer_running(timer_blink) and gbl_power)
    visible(img_red2, gbl_test and not timer_running(timer_blink) and gbl_power)
    visible(img_yel1, (gbl_aoa >= 8 and gbl_power) or (gbl_power and gbl_test) )
    visible(img_yel2, (gbl_aoa >= 7 and gbl_power) or (gbl_power and gbl_test) )
    visible(img_yel3, (gbl_aoa >= 6 and gbl_power) or (gbl_power and gbl_test) )
    visible(img_yel4, (gbl_aoa >= 5 and gbl_power) or (gbl_power and gbl_test) )
    visible(img_gre1, (gbl_aoa >= 4 and gbl_power) or (gbl_power and gbl_test) )
    visible(img_gre3, (gbl_aoa >= 3 and gbl_power) or (gbl_power and gbl_test) )
    visible(img_gre4, (gbl_aoa >= 2 and gbl_power) or (gbl_power and gbl_test) )
    visible(img_gre5, (gbl_aoa >= 1 and gbl_power) or (gbl_power and gbl_test) )
    
    -- Start blinking red when over 8
    if gbl_aoa >= 9 and gbl_power and not timer_running(timer_blink) then
        timer_blink = timer_start(0, 200, timer_callback)
    elseif gbl_aoa < 9 and timer_running(timer_blink) then
        gbl_blink = false
        timer_stop(timer_blink)
    end

end

function new_data_fs2020(aoa, volts)

    new_data_xpl({volts}, aoa)
    
end

function timer_callback()

    gbl_blink = not gbl_blink

    visible(img_red1, (gbl_aoa >= 10 and gbl_power and gbl_blink) or gbl_test)
    visible(img_red2, (gbl_aoa >= 9 and gbl_power and gbl_blink) or gbl_test)
    
end

xpl_dataref_subscribe("sim/cockpit2/electrical/bus_volts", "FLOAT[6]", 
                      "sim/flightmodel2/misc/AoA_angle_degrees", "FLOAT", new_data_xpl)
                      
fs2020_variable_subscribe("ANGLE OF ATTACK INDICATOR", "Radians",
                          "ELECTRICAL MAIN BUS VOLTAGE", "Volts", new_data_fs2020)

fs2024_variable_subscribe("ANGLE OF ATTACK INDICATOR", "Radians",
                          "ELECTRICAL BUS VOLTAGE:1", "Volts", new_data_fs2020)                          
                          
fsx_variable_subscribe("ANGLE OF ATTACK INDICATOR", "Radians",
                       "ELECTRICAL MAIN BUS VOLTAGE", "Volts", new_data_fs2020)
                      
button_test = button_add("test_up.png","test_dn.png",22,460,98,28,test_callback_pressed,test_callback_released)
button_mute = button_add("mute_up.png","mute_dn.png",130,460,98,28,mute_callback_pressed)