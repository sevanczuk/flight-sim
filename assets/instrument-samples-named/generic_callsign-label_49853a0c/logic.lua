img_add_fullscreen"background.png"
source_prop = user_prop_add_enum("Source", "Simulator,Custom", "Custom", "Where does the callsign come from")
callsign_prop = user_prop_add_string("Callsign", "N26MA", "The callsign that should be visible on the callsign plate")

if user_prop_get(source_prop) == "Custom" then
    txt_callsign = txt_add(user_prop_get(callsign_prop), "font:arimo_bold.ttf; size:100; color:#dfe7ed; halign:center; valign:center;", 0, 0, 400, 120)
else
    txt_callsign = txt_add("SIM", "font:arimo_bold.ttf; size:100; color:#dfe7ed; halign:center; valign:center;", 0, 0, 400, 120)
end


xpl_dataref_subscribe("sim/aircraft/view/acf_tailnum", "STRING", function(callsign)
    if callsign ~= "" and user_prop_get(source_prop) == "Simulator" then
        txt_set(txt_callsign, callsign)
    end
end)

msfs_variable_subscribe("ATC ID", "STRING", function(callsign)
    if callsign ~= "" and user_prop_get(source_prop) == "Simulator" then
        txt_set(txt_callsign, callsign)
    end
end)

fsx_variable_subscribe("ATC ID", "STRING", function(callsign)
    if callsign ~= "" and user_prop_get(source_prop) == "Simulator" then
        txt_set(txt_callsign, callsign)
    end
end)