---------------------------------------------
--           Vacuum & Ammeter              --
-- Modification of Jason Tatum's original  --
-- Brian McMullan 20180324                 -- 
-- Property for background off/on          --
-- Property for dimming overlay            --
---------------------------------------------

---------------------------------------------
--   Properties                            --
---------------------------------------------
prop_BG = user_prop_add_boolean("Background",true,"Hide background?")
prop_DO = user_prop_add_boolean("Dimming overlay",false,"Enable dimming overlay?")

---------------------------------------------
--   Load and display images in Z-order    --
--   Loaded images selectable with prop    --
---------------------------------------------
img_add_fullscreen("VacAmp.png")
img_vac = img_add("needle3.png", -160, 0, 512, 512)
img_amp = img_add("needle3.png", 150, 0, 512, 512)
if user_prop_get(prop_BG) == false then
    img_add_fullscreen("VacAmpCover.png")
else
    img_add_fullscreen("VacAmpCoverwBG.png")
end    
if user_prop_get(prop_DO) == true then
    img_add_fullscreen("dimoverlay.png")
end

-----------------------------------------
-- Init default visibility & rotation --
-----------------------------------------
rotate(img_vac, 140)
rotate(img_amp, -90)

---------------------------------------------
--   Functions                             --
---------------------------------------------
function new_vac_xpl(suct_XPL, suct_AFL)

    suct = fif(suct_AFL > 0, suct_AFL, suct_XPL)
    suct = var_cap(suct, 2.9, 7.1)
    rotate(img_vac, 215.0 - (suct * 25.0) )

end

function new_vac_fsx(suctnorm, sucta2a)
    
    -- Somehow the A2A suction LVAR doesn't match with the value in the sim, the default suction value works better.
    -- So the if statement below has been disabled for now.
    -- if sucta2a ~= 0 then
        -- suct = suctnorm
    -- else
        -- suct = suctnorm
    -- end
    suct = suctnorm
    
    suct = var_cap(suct, 2.9, 7.1)
    rotate(img_vac, 215.0 - (suct * 25.0) )

end


function new_amps_xpl(amps)

    amps = var_cap(amps[1], -60, 60)
    rotate(img_amp , 270 + (amps))

end

function new_amps_fsx(ampsfsx, ampsa2a)

    if ampsa2a ~= nil and ampsa2a ~= 0 then
        amps = ampsa2a
    else
        amps = ampsfsx
    end
    
    amps = var_cap(amps, -60, 60)
    rotate(img_amp, 270 + amps)

end

function new_amps_fs2020(amps)

    amps = var_cap(amps, -60, 60)
    rotate(img_amp, 270 + amps * -1)

end

---------------------------------------------
--   Simulator Subscriptions               --
---------------------------------------------          
xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/suction_1_ratio","FLOAT",
                      "172/instruments/uni_suction", "FLOAT", new_vac_xpl)
xpl_dataref_subscribe("sim/cockpit2/electrical/battery_amps","FLOAT[8]", new_amps_xpl)

fsx_variable_subscribe("SUCTION PRESSURE", "Inches of Mercury",
                       "L:SuctionPressure", "inHg", new_vac_fsx)
fsx_variable_subscribe("ELECTRICAL BATTERY BUS AMPS", "Amperes",
                       "L:Ammeter1", "amps", new_amps_fsx)
                       
msfs_variable_subscribe("SUCTION PRESSURE", "Inches of Mercury", new_vac_fsx)
msfs_variable_subscribe("ELECTRICAL BATTERY BUS AMPS", "Amperes", new_amps_fs2020)                       
---------------------------------------------
--   END                                   --
---------------------------------------------                                 