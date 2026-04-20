prop_BG = user_prop_add_boolean("Background Display", true, "Untick to Hide the background.")

img_add_fullscreen ("backplate.png")

arrow = img_add("flap_arrow.png", 0, 180, 132, 512, "move_animation_type: LOG; move_animation_speed: 0.1")
if user_prop_get(prop_BG) == true then
    img_add_fullscreen ("faceplate.png")
else
    img_add_fullscreen ("faceplatewBG.png")
end 

function move_flaps( flap_pos)
    move(arrow, nil, flap_pos * 361, nil, nil)
end

xpl_dataref_subscribe("sim/flightmodel2/controls/flap1_deploy_ratio", "FLOAT", move_flaps)
fsx_variable_subscribe("TRAILING EDGE FLAPS LEFT PERCENT", "Percent over 100", move_flaps)
msfs_variable_subscribe("TRAILING EDGE FLAPS LEFT PERCENT", "Percent over 100", move_flaps)