---------------------------------------------
--            Fuel Gauge Dual              --
-- Modification of Jason Tatum's original  --
-- Brian McMullan 20180324                 -- 
-- Property for background off/on          --
-- Property for dimming overlay            --
---------------------------------------------

---------------------------------------------
--   Properties                            --
---------------------------------------------
prop_BG = user_prop_add_boolean("Background Display",true,"Display background?")
prop_DO = user_prop_add_boolean("Dimming Overlay",false,"Enable dimming overlay?")

---------------------------------------------
--   Load and display images in Z-order    --
--   Loaded images selectable with prop    --
---------------------------------------------
img_add_fullscreen("DualFuel.png")
img_lt_fuel = img_add("needle3.png", -142, 0, 512, 512, "angle_z: 145; rotate_animation_type: LOG; rotate_animation_speed: 0.1")
img_rt_fuel = img_add("needle3.png", 142, 0, 512, 512, "angle_z: 215; rotate_animation_type: LOG; rotate_animation_speed: 0.1")
if user_prop_get(prop_BG) == false then
    img_add_fullscreen("DualFuelCover.png")
else
    img_add_fullscreen("DualFuelCoverwBG.png")
end    
if user_prop_get(prop_DO) == true then
    img_add_fullscreen("dimoverlay.png")
end

---------------------------------------------
--   Functions                             --
---------------------------------------------

function new_fuel(quan, bus_volts, fuel_L_AFL, fuel_R_AFL)

    fuel_L_XPL = var_cap(((quan[1]* 2.20462) / 6.0), 0, 26)
    fuel_R_XPL = var_cap(((quan[2]* 2.20462) / 6.0), 0, 26)
    
    fuel_left = fif(fuel_L_AFL > 0, fuel_L_AFL, fuel_L_XPL)
    fuel_right = fif(fuel_R_AFL > 0, fuel_R_AFL, fuel_R_XPL)

-- X-plane gives fuel in weight (pounds), so we have to divide by 6 lbs per gallon)
    if bus_volts[1] >= 10 then
        left = fuel_left
        right = fuel_right
    else
        left = 0
        right = 0
    end
    
    rotate(img_lt_fuel, 145 - (left * 4.23))
    rotate(img_rt_fuel, 215 + (right * 4.23))

end

function new_fuel_fsx(lefttank_FSX, righttank_FSX, lefttank_A2A, righttank_A2A, volts)

    lefttank = fif(lefttank_A2A > 0, lefttank_A2A, lefttank_FSX)
    righttank = fif(righttank_A2A > 0, righttank_A2A, righttank_FSX)

    if volts > 10 then
        left = lefttank
        right = righttank
    else
        left = 0
        right = 0
    end
    
    rotate(img_lt_fuel, 145 - (left * 4.23))
    rotate(img_rt_fuel, 215 + (right * 4.23))

end

function new_fuel_msfs(left, right, volts)


    if volts < 10 then
        left = 0
        right = 0
    end
    
    rotate(img_lt_fuel, 145 - (left * 4.23))
    rotate(img_rt_fuel, 215 + (right * 4.23))

end

---------------------------------------------
--   Simulator Subscriptions               --
---------------------------------------------
xpl_dataref_subscribe( "sim/cockpit2/fuel/fuel_quantity","FLOAT[9]",
                       "sim/cockpit2/electrical/bus_volts", "FLOAT[6]", 
                       "172/instruments/uni_fuel_L", "FLOAT", 
                       "172/instruments/uni_fuel_R", "FLOAT", new_fuel)

fsx_variable_subscribe("FUEL TANK LEFT MAIN QUANTITY", "gallons",
                       "FUEL TANK RIGHT MAIN QUANTITY", "gallons", 
                       "L:FuelLeftWingTank", "gallons",
                       "L:FuelRightWingTank", "gallons", 
                       "ELECTRICAL MAIN BUS VOLTAGE", "VOLTS", new_fuel_fsx)
                       
fs2020_variable_subscribe("FUEL TANK LEFT MAIN QUANTITY", "gallons",
                          "FUEL TANK RIGHT MAIN QUANTITY", "gallons", 
                          "ELECTRICAL MAIN BUS VOLTAGE", "VOLTS", new_fuel_msfs)

fs2024_variable_subscribe("FUEL TANK LEFT MAIN QUANTITY", "gallons",
                          "FUEL TANK RIGHT MAIN QUANTITY", "gallons", 
                          "ELECTRICAL BUS VOLTAGE:1", "VOLTS", new_fuel_msfs)
---------------------------------------------
--   END                                   --
---------------------------------------------                       