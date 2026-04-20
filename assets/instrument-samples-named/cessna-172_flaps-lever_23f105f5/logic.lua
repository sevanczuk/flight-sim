img_add_fullscreen("background.png")
img_flaps_pos = img_add("position_indicator.png", 163, 58, 24, 24)

function slider_callback(position)

    if position <= 0.5 then
        xpl_dataref_write("sim/cockpit2/controls/flap_ratio", "FLOAT", 0.33 / 0.5 * position)
        fsx_event("FLAPS_SET", 5461 / 0.5 * position)
        msfs_event("FLAPS_SET", 5461 / 0.5 * position)
    elseif position > 0.5 and position < 0.85 then
        xpl_dataref_write("sim/cockpit2/controls/flap_ratio", "FLOAT", 0.33 + (0.33 / 0.35 * (position - 0.5)) )
        fsx_event("FLAPS_SET", 5461 + (5461 / 0.35 * (position - 0.5)) )
        msfs_event("FLAPS_SET", 5461 + (5461 / 0.35 * (position - 0.5)) )
    elseif position >= 0.85 then
        xpl_dataref_write("sim/cockpit2/controls/flap_ratio", "FLOAT", 0.66 + (0.34 / 0.15 * (position - 0.85)) )
        fsx_event("FLAPS_SET", 10922 + (5461 / 0.15 * (position - 0.85)) )
        msfs_event("FLAPS_SET", 10922 + (5461 / 0.15 * (position - 0.85)) )
    end

    if position > 0.5 and position < 0.85 then
        move(slider_handle, 215, nil, nil, nil)
    elseif position >= 0.85 then
        move(slider_handle, 225, nil, nil, nil)
    elseif position <= 0.5 then
        move(slider_handle, 195, nil, nil, nil)
    end

end

slider_handle = slider_add_ver(nil, 195, 60, 150, 390, "flaps_handle.png", 146, 62, slider_callback)

-- Create interpolate settings
local settings = { { 0 , 58 },
                   { 0.33, 243 },
                   { 0.66, 331 },
                   { 1, 426 } }

xpl_dataref_subscribe("sim/cockpit2/controls/flap_handle_deploy_ratio", "FLOAT", 
                      "sim/cockpit2/controls/flap_handle_request_ratio", "FLOAT", function(flap_pos, handle_pos)
    move(img_flaps_pos, nil, interpolate_linear(settings, flap_pos), nil, nil)
    slider_set_position(slider_handle, handle_pos)
end)

fsx_variable_subscribe("TRAILING EDGE FLAPS LEFT PERCENT", "PERCENT", function(flap_pos)
    move(img_flaps_pos, nil, interpolate_linear(settings, flap_pos / 100), nil, nil)
    slider_set_position(slider_handle, flap_pos / 100)
end)

msfs_variable_subscribe("TRAILING EDGE FLAPS LEFT PERCENT", "PERCENT", 
                        "FLAPS HANDLE PERCENT", "PERCENT", function(flap_pos, handle_pos)
    move(img_flaps_pos, nil, interpolate_linear(settings, flap_pos / 100), nil, nil)
    slider_set_position(slider_handle, handle_pos / 100)
end)