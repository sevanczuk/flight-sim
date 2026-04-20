---------------------------------------------
--           VOR / NAV1 with ILS           --
-- Modification of Jason Tatum's original  --
-- Brian McMullan 20180324                 -- 
-- Property for background off/on          --
-- Property for dimming overlay            --
-- some gauge initialization fixes         --
---------------------------------------------

---------------------------------------------
--   Properties                            --
---------------------------------------------
prop_VOR = user_prop_add_enum("Source", "VOR 1,VOR 2", "VOR 1", "Choose VOR source NAV 1 or NAV 2")
prop_BG  = user_prop_add_boolean("Background Display",true,"Display background?")
prop_DO  = user_prop_add_boolean("Dimming Overlay",false,"Enable dimming overlay?")
local gbl_src = fif(user_prop_get(prop_VOR) == "VOR 1", 1, 2)

---------------------------------------------
--   Load and display images in Z-order    --
--   Loaded images selectable with prop    --
---------------------------------------------
img_to = img_add_fullscreen("OBSnavto.png", "visible:false")
img_fr = img_add_fullscreen("OBSnavfr.png", "visible:false")
img_navflag = img_add_fullscreen("OBSnavflag.png")
img_gs = img_add_fullscreen("OBSgsflagoff.png")
img_gsflag = img_add_fullscreen("OBSgsflag.png")
if user_prop_get(prop_BG) == false then
    img_add_fullscreen("VORILS.png")
else
    img_add_fullscreen("VORILSwBG.png")
end    
img_horbar = img_add("OBSneedle.png",0,-180,512,512)
img_verbar = img_add("OBSneedle.png",-150,0,512,512)
rotate(img_verbar, -90)
img_compring = img_add_fullscreen("OBScard.png", "rotate_animation_type: LOG; rotate_animation_speed: 0.08; rotate_animation_direction: FASTEST")
img_add_fullscreen("OBScover.png")
img_add("OBSknobshadow.png",31,395,85,85)

if user_prop_get(prop_DO) == true then
    img_add_fullscreen("dimoverlay.png")
end

---------------------------------------------
--   Functions                             --
---------------------------------------------

-- BUTTON, SWITCH AND DIAL FUNCTIONS --
function new_obs(obs)

    if obs == 1 then
        if user_prop_get(prop_VOR) == "VOR 1" then
            xpl_command("sim/radios/obs1_down")
            fsx_event("VOR1_OBI_DEC")
            msfs_event("VOR1_OBI_DEC")
        else
            xpl_command("sim/radios/copilot_obs2_down")
            fsx_event("VOR2_OBI_DEC")
            msfs_event("VOR2_OBI_DEC")
        end
    elseif obs == -1 then
        if user_prop_get(prop_VOR) == "VOR 1" then
            xpl_command("sim/radios/obs1_up")
            fsx_event("VOR1_OBI_INC")
            msfs_event("VOR1_OBI_INC")
        else
            xpl_command("sim/radios/copilot_obs2_up")
            fsx_event("VOR2_OBI_INC")
            msfs_event("VOR2_OBI_INC")
        end
    end

end

function new_data_xpl(obs1, obs2, hor1, hor2, ver1, ver2, tofrom1, tofrom2, gsflag1, gsflag2)

    -- OBS
    if gbl_src == 1 then
        rotate(img_compring, obs1 * -1)
    else
        rotate(img_compring, obs2 * -1)
    end
    
    -- Horizontal and vertical navigation
    if gbl_src == 1 then
        rotate(img_horbar, -29.8 / 2.5 * hor1, "LOG", 0.05)
        rotate(img_verbar, 21.8 / 2 * ver1 - 90, "LOG", 0.05)
    else
        rotate(img_horbar, -29.8 / 2 * hor2, "LOG", 0.05)
        rotate(img_verbar, 21.8 / 2 * ver2 - 90, "LOG", 0.05)
    end
    
    -- To / from and glide slope
    if gbl_src == 1 then
        visible(img_to, tofrom1 == 1)
        visible(img_fr, tofrom1 == 2)
        visible(img_navflag, tofrom1 == 0)
        visible(img_gsflag, gsflag1 == 1)
    else
        visible(img_to, tofrom2 == 1)
        visible(img_fr, tofrom2 == 2)
        visible(img_navflag, tofrom2 == 0)
        visible(img_gsflag, gsflag2 == 1)
    end

end

function new_data_fs(obs1, obs2, hor1, hor2, ver1, ver2, tofrom1, tofrom2, gsflag1, gsflag2)

    -- OBS
    if gbl_src == 1 then
        rotate(img_compring, obs1 * -1)
    else
        rotate(img_compring, obs2 * -1)
    end
    
    -- Horizontal and vertical navigation
    if gbl_src == 1 then
        rotate(img_horbar, -29.8 / 127 * hor1, "LOG", 0.05)
        rotate(img_verbar, 21.8 / 119 * ver1 - 90, "LOG", 0.05)
    else
        rotate(img_horbar, -29.8 / 127 * hor2, "LOG", 0.05)
        rotate(img_verbar, 21.8 / 119 * ver2 - 90, "LOG", 0.05)
    end
    
    -- To / from and glide slope
    if gbl_src == 1 then
        visible(img_to, tofrom1 == 1)
        visible(img_fr, tofrom1 == 2)
        visible(img_navflag, tofrom1 == 0)
        visible(img_gsflag, not gsflag1)
    else
        visible(img_to, tofrom2 == 1)
        visible(img_fr, tofrom2 == 2)
        visible(img_navflag, tofrom2 == 0)
        visible(img_gsflag, not gsflag2)
    end

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
fsx_variable_subscribe("NAV OBS:1", "Degrees",
                       "NAV OBS:2", "Degrees",
                       
                       "NAV CDI:1", "Number", 
                       "NAV CDI:2", "Number",

                       "NAV GSI:1", "Number",
                       "NAV GSI:2", "Number", 
                       
                       "NAV TOFROM:1", "Enum",
                       "NAV TOFROM:2", "Enum", 
                       
                       "NAV GS FLAG:1", "Bool",
                       "NAV GS FLAG:2", "Bool", new_data_fs)

msfs_variable_subscribe("NAV OBS:1", "Degrees",
                        "NAV OBS:2", "Degrees",
                          
                        "NAV CDI:1", "Number", 
                        "NAV CDI:2", "Number",
                          
                        "NAV GSI:1", "Number",
                        "NAV GSI:2", "Number", 
                          
                        "NAV TOFROM:1", "Enum",
                        "NAV TOFROM:2", "Enum", 
                          
                        "NAV GS FLAG:1", "Bool",
                        "NAV GS FLAG:2", "Bool", new_data_fs)

xpl_dataref_subscribe("sim/cockpit/radios/nav1_obs_degm", "FLOAT",
                      "sim/cockpit/radios/nav2_obs_degm2", "FLOAT", 
                      
                      "sim/cockpit/radios/nav1_hdef_dot", "FLOAT",
                      "sim/cockpit/radios/nav2_hdef_dot", "FLOAT", 
                      
                      "sim/cockpit/radios/nav1_vdef_dot", "FLOAT",
                      "sim/cockpit/radios/nav2_vdef_dot", "FLOAT", 
                      
                      "sim/cockpit/radios/nav1_fromto", "INT", 
                      "sim/cockpit/radios/nav2_fromto", "INT",

                      "sim/cockpit2/radios/indicators/nav1_flag_glideslope_mech", "INT",
                      "sim/cockpit2/radios/indicators/nav2_flag_glideslope_mech", "INT", new_data_xpl)                  
---------------------------------------------
-- END                                     --
---------------------------------------------                          