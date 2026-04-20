---------------------------------------------
--        Vertical Speed Indicator         --
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
if user_prop_get(prop_BG) == false then
    img_add_fullscreen("VSI.png")
else
    img_add_fullscreen("VSIwBG.png")
end    
img_needle = img_add_fullscreen("vsineedle.png")
if user_prop_get(prop_DO) == true then
    img_add_fullscreen("dimoverlay.png")
end

---------------------------------------------
--   Init                                  --
---------------------------------------------

---------------------------------------------
--   Functions                             --
---------------------------------------------
function new_vs(fpm)
    
    fpm = var_cap(fpm, -2000, 2000)
    
    if fpm >= 500 then
        rotate(img_needle, (138 / 1500 * (fpm - 500)) + 35)
    elseif fpm >= 0 and fpm < 500 then
        rotate(img_needle, 35 / 500 * fpm)
    elseif fpm < 0 and fpm > -500 then
        rotate(img_needle, 35 / 500 * fpm)
    elseif fpm <= -500 then
        rotate(img_needle, (138 / 1500 * (fpm + 500)) - 35)
    end
end

---------------------------------------------
--   Simulator Subscriptions               --
---------------------------------------------
xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/vvi_fpm_pilot", "FLOAT", new_vs)

fsx_variable_subscribe("VERTICAL SPEED", "Feet per minute", new_vs)
msfs_variable_subscribe("VERTICAL SPEED", "Feet per minute", new_vs)

---------------------------------------------
-- END       VSI                           --
---------------------------------------------        