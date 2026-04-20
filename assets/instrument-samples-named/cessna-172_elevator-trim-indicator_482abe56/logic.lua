img_add_fullscreen("trimback.png")
img_trim = img_add("trimindicator.png", 38, 145, 33, 10)
img_add_fullscreen("trimcover.png")

function new_trim(trim)

    move(img_trim, 38, 145 + (125 * var_cap(trim, -1, 1)), nil, nil)

end


xpl_dataref_subscribe("sim/cockpit2/controls/elevator_trim", "FLOAT", new_trim)
fsx_variable_subscribe("ELEVATOR TRIM INDICATOR", "Position", new_trim)
msfs_variable_subscribe("ELEVATOR TRIM INDICATOR", "Position", new_trim)