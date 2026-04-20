-- Properties
prop_BG = user_prop_add_boolean("Background",true,"Display background?")
-- Images and text
img_background = img_add_fullscreen("n_plate.png")
img_add("callsign_plate.png", 32, 112, 344, 104)
callsign_prop = user_prop_add_string("Callsign", "", "Fill in your own callsign or leave empty for the sim callsign")
txt_callsign = txt_add("CE-172", "size:80px; font:arimo_bold.ttf; color:white; halign:center;", 0, 125, 400, 84)

-- Functions
visible(img_background, user_prop_get(prop_BG))

function new_callsign_xpl(callsign)

    if user_prop_get(callsign_prop) ~= "" then
        txt_set(txt_callsign, user_prop_get(callsign_prop) )
    else
        txt_set(txt_callsign, callsign)
    end

end

function new_callsign_fsx(callsign)

    if user_prop_get(callsign_prop) ~= "" then
        txt_set(txt_callsign, user_prop_get(callsign_prop) )
    else
        txt_set(txt_callsign, callsign)
    end

end

xpl_dataref_subscribe("sim/aircraft/view/acf_tailnum", "STRING", new_callsign_xpl)
fsx_variable_subscribe("ATC ID", "STRING", new_callsign_fsx)
msfs_variable_subscribe("ATC ID", "STRING", new_callsign_fsx)