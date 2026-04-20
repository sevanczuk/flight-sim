---------------------------------------------
--           VOR - NAV2                    --
-- Modification of Jason Tatum's original  --
-- Brian McMullan 20180324                 -- 
-- Property for background off/on          --
-- Property for dimming overlay            --
-- some gauge initialization fixes         --
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
img_to = img_add_fullscreen("OBS2navto.png", "visible:false")
img_fr = img_add_fullscreen("OBS2navfr.png", "visible:false")
img_navflag = img_add_fullscreen("OBS2navflag.png")
if user_prop_get(prop_BG) == false then
    img_add_fullscreen("VOR.png")
else
    img_add_fullscreen("VORwBG.png")
end    
img_horbar = img_add("OBSneedle.png",0,-140,512,512, "rotate_animation_type: LOG; rotate_animation_speed: 0.05; rotate_animation_direction: FASTEST")
img_compring = img_add_fullscreen("OBScard.png", "rotate_animation_type: LOG; rotate_animation_speed: 0.05; rotate_animation_direction: FASTEST")
img_add_fullscreen("OBScover.png")
img_add("OBSknobshadow.png",31,395,85,85)
if user_prop_get(prop_DO) == true then
    img_add_fullscreen("dimoverlay.png")
end

---------------------------------------------
--   Functions                             --
---------------------------------------------
function new_obs(obs)
    if obs == 1 then
        xpl_command("sim/radios/copilot_obs2_down")
        fsx_event("VOR2_OBI_DEC")
        msfs_event("VOR2_OBI_DEC")
    elseif obs == -1 then
        xpl_command("sim/radios/copilot_obs2_up")
        fsx_event("VOR2_OBI_INC")
        msfs_event("VOR2_OBI_INC")
    end
end

function new_obsheading(obs)
    rotate(img_compring, obs * -1)
end

function new_info_fsx(nav2sig, tofromnav, glideslopeflag)
    nav2sign = fif(nav2sig, 1, 0)
    glideslopeflag = fif(glideslopeflag, 1, 0)
    new_info(nav2sig, tofromnav, glideslopeflag)
end

function new_info(nav2sig, tofromnav, glideslopeflag)
    visible(img_navflag, nav2sig == 0)
    visible(img_to, tofromnav == 1)
    visible(img_fr, tofromnav == 2)
    visible(img_navflag, tofromnav == 0)
end

function new_dots(horizontal, vertical)
    -- Localizer
    horizontal = var_cap(horizontal, -5, 5)
    rotate(img_horbar, horizontal * -12)
end

function new_dots_fsx(horizontal)
    -- Localizer
    horizontal = 4 / 127 * horizontal
    horizontal = var_cap(horizontal, -4, 4)
    rotate(img_horbar, horizontal * -6.1)
end

---------------------------------------------
--   Controls Add                          --
---------------------------------------------
dial_obs = dial_add("obsknob.png", 31, 395, 85, 85, 5, new_obs)
dial_click_rotate(dial_obs, 6)
-- Detent settings
detent_settings = {}
detent_settings["1 detent/pulse"]  = "TYPE_1_DETENT_PER_PULSE"
detent_settings["2 detents/pulse"] = "TYPE_2_DETENT_PER_PULSE"
detent_settings["4 detents/pulse"] = "TYPE_4_DETENT_PER_PULSE"
detent_setting = user_prop_add_enum("Detent setting", "1 detent/pulse,2 detents/pulse, 4 detents/pulse", "2 detents/pulse", "Select your rotary encoder type")
hw_dial_add("OBS dial", detent_settings[user_prop_get(detent_setting)], 3, new_obs)
---------------------------------------------
--   Simulator Subscriptions               --
---------------------------------------------
xpl_dataref_subscribe("sim/cockpit2/radios/actuators/hsi_obs_deg_mag_copilot", "FLOAT", new_obsheading)

xpl_dataref_subscribe("sim/cockpit2/radios/indicators/hsi_display_horizontal_copilot", "INT",
                      "sim/cockpit2/radios/indicators/hsi_flag_from_to_copilot", "INT", 
                      "sim/cockpit2/radios/indicators/hsi_display_vertical_copilot", "INT", new_info)

xpl_dataref_subscribe("sim/cockpit2/radios/indicators/hsi_hdef_dots_copilot", "FLOAT",
                      "sim/cockpit2/radios/indicators/hsi_vdef_dots_copilot", "FLOAT", new_dots)                  


fsx_variable_subscribe("NAV OBS:2", "Degrees", new_obsheading)
msfs_variable_subscribe("NAV OBS:2", "Degrees", new_obsheading)

fsx_variable_subscribe("NAV HAS NAV:2", "Bool",
                       "NAV TOFROM:2", "Enum",
                       "NAV GS FLAG:2", "Bool", new_info_fsx)
msfs_variable_subscribe("NAV HAS NAV:2", "Bool",
                        "NAV TOFROM:2", "Enum",
                        "NAV GS FLAG:2", "Bool", new_info_fsx)                       

fsx_variable_subscribe("NAV CDI:2", "Number", new_dots_fsx)
msfs_variable_subscribe("NAV CDI:2", "Number", new_dots_fsx)
                       
                  
---------------------------------------------
-- END                                     --
---------------------------------------------                          