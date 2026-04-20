------------------------------------------
-- Generic Instruments Xplane           --
--                                      --
--                                      --
-- 2021/07 FvG                          --
-- Bendix-King KN62A DME receiver       --
------------------------------------------

----------
-- Init --
----------

img_add_fullscreen("background.png")
img_add("knob.png",830,50,140,140)
local Power_flag = false 
local OnOff_flag = 1
local F_flag = 1

Hz = 0
Topline_id = txt_add(" ","font:digital-7 (mono italic).ttf;size:36;color:orange;halign:left;",70,25,450, 150)
Botline_id = txt_add(" ","font:digital-7 (mono italic).ttf;size:16;color:orange;halign:left;",70,90,450, 150)
Click_id = sound_add("click.wav")

-----------
-- Nodes --
-----------

-- On/Off switch
On_off_id = switch_add("slide_off.png","slide_on.png",645,140,70,32,
        function(pos,dir)
            OnOff_flag = pos + dir
            sound_play(Click_id)
            switch_set_position(On_off_id,OnOff_flag)
        end)
switch_set_position(On_off_id,1)

--RMT/FREQ/GST switch
RMT_FREQ_GST_id = switch_add("slide_left.png","slide_mid.png","slide_right.png",645,65,105,32,
        function(pos,dir)
            F_flag = pos + dir
            sound_play(Click_id)
            switch_set_position(RMT_FREQ_GST_id,F_flag)
        end)
switch_set_position(RMT_FREQ_GST_id,1)

-- Outer ring frequenty dial
Outer_ring_id = dial_add(nil,820,50,160,130,
        function(dir)
            if F_flag == 1 then
                if dir == 1 then
                    Hz = Hz + 100
                    else Hz = Hz - 100
                end
                sound_play(Click_id)
                xpl_dataref_write("sim/cockpit2/radios/actuators/nav_frequency_hz","INT[12]",{Hz},2)
            end
        end)

-- Inner ring frequenty dial
Inner_ring_id = dial_add(nil,860,55,85,85,
        function(dir)
            if F_flag == 1 then
                if dir == 1 then
                    Hz = Hz + 5
                    else Hz = Hz - 5
                end
                sound_play(Click_id)
                xpl_dataref_write("sim/cockpit2/radios/actuators/nav_frequency_hz","INT[12]",{Hz},2)
            end
        end)


------------------
-- Subscription --
------------------

-- Panel brightness
xpl_dataref_subscribe("sim/cockpit2/switches/instrument_brightness_ratio","FLOAT[32]",
        function(dm)
            opacity(Topline_id,dm[1])
            opacity(Botline_id,dm[1])
        end)

-- Main loop
xpl_dataref_subscribe("sim/cockpit/electrical/avionics_on", "INT",
                          "sim/cockpit/electrical/battery_on", "INT", 
                              "sim/cockpit2/electrical/generator_on", "INT[8]", 
                                  "sim/flightmodel/engine/ENGN_running", "INT[8]",
                                      "sim/cockpit2/radios/actuators/nav_dme_frequency_hz","INT[12]",
                                          "sim/cockpit2/radios/indicators/nav_dme_distance_nm","FLOAT[12]",
                                              "sim/cockpit2/radios/indicators/nav_dme_speed_kts","FLOAT[12]",
                                                  "sim/cockpit2/radios/indicators/nav_dme_time_min","FLOAT[12]",
                                                      "sim/time/local_time_sec","FLOAT", -- to make sure the main loop is called
        
        function(avionics,battery,generator,engine,hz,fnm,fkt,min,sec)
            Power_flag = fif((battery == 1 or (generator[1] == 1 and engine[1] == 1) 
                        or (generator[2] == 1 and engine[2] == 1)) and avionics == 1, true, false)
            if Power_flag == true and OnOff_flag == 1 then  -- instrument has power and is switched on
                if F_flag == 0 then -- RMT mode
                    txt_set(Botline_id,"NM           KT       MIN")
                    if fnm[1] > 0 then
                        fnm[1] = var_cap(var_round(fnm[1],1),0,99)
                        fkt[1] = var_round(fkt[1],0)
                        min[1] = var_round(min[1],0)
                        txt_set(Topline_id,string.format("%04.1f  %03d %03d",fnm[1],fkt[1],min[1]))
                        else txt_set(Topline_id,"---  --- ---")
                     end   
                 elseif F_flag == 1 then  -- FREQ mode
                        txt_set(Botline_id,"NM               MHZ")
                        Hz = hz[3]
                        if fnm[3] > 0 then
                            fnm[3] = var_cap(var_round(fnm[3],1),0,99)
                            txt_set(Topline_id,string.format("%04.1f  %0.2f",fnm[3],hz[3] / 100))
                            else txt_set(Topline_id,string.format("---   %0.2f",hz[3] / 100))
                        end
                 elseif F_flag == 2 then -- Distance/Groundspeed/TTS RMT mode
                        txt_set(Botline_id,"NM           KT       MIN")
                        if fnm[3] > 0 then
                            fnm[3] = var_cap(var_round(fnm[3],1),0,99)
                            fkt[3] = var_round(fkt[3],0)
                            min[3] = var_round(min[3],0)
                            txt_set(Topline_id,string.format("%04.1f  %03d %03d",fnm[3],fkt[3],min[3]))
                            else txt_set(Topline_id,"---  --- ---")
                        end
                     end
             else txt_set(Topline_id," ") -- clear dispay
                  txt_set(Botline_id," ")
             end
        end)


---------
-- END --
---------
