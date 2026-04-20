-- Buttons
--
-- Define all pushbuttons and take action when pressed/released
--

function init_buttons()

    local bdir = fif(user_prop_get(btn_colour_prop)== "Black","black_buttons/","grey_buttons/")

    button_ident = button_add(bdir.."button_out_ident.png", bdir.."button_in_ident.png", 18,28,39,30,callback_ident_pressed)
    button_vfr = button_add(bdir.."button_out_vfr.png", bdir.."button_in_vfr.png", 18,75,39,30,callback_vfr_pressed)
    button_off = button_add(bdir.."button_out_off.png", bdir.."button_in_off.png", 132,66,30,40,callback_off_pressed, callback_off_released)
    button_on = button_add(bdir.."button_out_on.png", bdir.."button_in_on.png", 93,17,45,22,callback_on_pressed,callback_on_released)
    button_standby = button_add(bdir.."button_out_stby.png", bdir.."button_in_stby.png",70,64,33,45,callback_standby_pressed,callback_standby_released)
    button_alt = button_add(bdir.."button_out_alt.png", bdir.."button_in_alt.png",98,46,36,36,callback_alt_pressed,callback_alt_released)
    button_func = button_add(bdir.."button_out_func.png", bdir.."button_in_func.png", 582, 28, 39, 30,callback_func_button)
    button_crsr = button_add(bdir.."button_out_crsr.png", bdir.."button_in_crsr.png",640, 29, 39, 30,callback_crsr_button)
    button_start_stop = button_add(bdir.."button_out_startstop.png", bdir.."button_in_startstop.png", 580, 76, 39, 30, callback_start_stop_button)
    button_clr = button_add(bdir.."button_out_clr.png", bdir.."button_in_clr.png", 640, 78, 39, 30,callback_clr_button)

    button_0 = button_add(bdir.."button_out_0.png", bdir.."button_in_0.png", 21, 134, 39, 31, function() button_pressed(0) end)
    button_1 = button_add(bdir.."button_out_1.png", bdir.."button_in_1.png", 84, 134, 39, 30, function() button_pressed(1) end)
    button_2 = button_add(bdir.."button_out_2.png", bdir.."button_in_2.png", 147, 134, 39, 30, function() button_pressed(2) end)
    button_3 = button_add(bdir.."button_out_3.png", bdir.."button_in_3.png", 208, 134, 39, 30, function() button_pressed(3) end)
    button_4 = button_add(bdir.."button_out_4.png", bdir.."button_in_4.png", 270, 134, 39, 30, function() button_pressed(4) end)
    button_5 = button_add(bdir.."button_out_5.png", bdir.."button_in_5.png", 347, 134, 39, 30, function() button_pressed(5) end)
    button_6 = button_add(bdir.."button_out_6.png", bdir.."button_in_6.png", 409, 134, 39, 30, function() button_pressed(6) end)
    button_7 = button_add(bdir.."button_out_7.png", bdir.."button_in_7.png", 470, 134, 39, 30, function() button_pressed(7) end)
    button_8 = button_add(bdir.."button_out_8.png", bdir.."button_in_8.png", 577,134, 39,30, function() button_pressed(8) end)
    button_9 = button_add(bdir.."button_out_9.png", bdir.."button_in_9.png", 636,134, 39,30, function() button_pressed(9) end)

end


function callback_ident_pressed()
    xpl_command("sim/transponder/transponder_ident")
    msfs_event("XPNDR_IDENT_ON")
end

function callback_vfr_pressed()
    currentCodeString = user_prop_get(vfr_user_prop)
    enter_digit = 0
    update_display()
    xpl_dataref_write("sim/cockpit/radios/transponder_code", "INT", currentCodeString )
    fsx_event("XPNDR_SET", decimal_to_hex(currentCodeString) )    
    msfs_event("XPNDR_SET",decimal_to_hex(currentCodeString) ) 
end

function callback_off_timer()
    timer_stop(timer_off_pressed)
    xpl_command("sim/transponder/transponder_off")
    msfs_variable_write("TRANSPONDER STATE","Enum",0)
end

function callback_off_pressed()
    if (display_page > PAGE_OFF) then
        if (display_page >= PAGE_NORMAL) then
            display_page = PAGE_SHUTDOWN
        end
        timer_off_pressed = timer_start(2000,nil,callback_off_timer)        
        update_display()
    end
end

function callback_off_released()
    if (display_page == PAGE_SHUTDOWN) then
        display_page = PAGE_NORMAL
    end
    timer_stop(timer_off_pressed)
    update_display()
end

function callback_on_timer()
    timer_stop(timer_on_pressed)
    xpl_command("sim/transponder/transponder_on")
    msfs_variable_write("TRANSPONDER STATE","Enum",3)
end

function callback_on_pressed()
    if (display_page == PAGE_OFF) then
        timer_on_pressed = timer_start(2000,nil,callback_on_timer)
    else    
        xpl_command("sim/transponder/transponder_on")
        msfs_variable_write("TRANSPONDER STATE","Enum",3)
    end
end

function callback_on_released()
    timer_stop(timer_on_pressed)
end

function callback_standby_timer()
    timer_stop(timer_standby_pressed)
    xpl_command("sim/transponder/transponder_standby")
    msfs_variable_write("TRANSPONDER STATE","Enum",1)   
end

function callback_standby_pressed()
    if (display_page == PAGE_OFF) then
        timer_standby_pressed = timer_start(2000,nil,callback_standby_timer)
    else    
        xpl_command("sim/transponder/transponder_standby")
        msfs_variable_write("TRANSPONDER STATE","Enum",1)
    end
end

function callback_standby_released()
    timer_stop(timer_standby_pressed)
end

function callback_alt_timer()
    timer_stop(timer_alt_pressed)
    xpl_command("sim/transponder/transponder_alt")
    msfs_variable_write("TRANSPONDER STATE","Enum",4)
end

function callback_alt_pressed()
    if (display_page == PAGE_OFF) then
        timer_alt_pressed = timer_start(2000,nil,callback_alt_timer)
    else    
        xpl_command("sim/transponder/transponder_alt")
        msfs_variable_write("TRANSPONDER STATE","Enum",4)
    end
end

function callback_alt_released()
    timer_stop(timer_alt_pressed)
end

-- cancel squawk code and timer value entry when changing page 
-- move to next display page in sequence if unit powered on
function callback_func_button()
    if (display_page >= PAGE_NORMAL) then
        display_page = display_page + 1
        if (display_page > LAST_PAGE) then
            display_page = PAGE_NORMAL
        end    
    end  
    stop_alt_monitor()  
    gbl_elapsed_active = false
    gbl_countdown_entry = false
    update_display()
end

function callback_crsr_button()
    if (gbl_countdown_entry) then
        gbl_countdown_time = gbl_countdown_initial
        gbl_countdown_entry = false
        enter_digit = 0
    elseif (display_page >= PAGE_NORMAL and enter_digit > 0) then
        enter_digit = 0
    elseif (display_page == PAGE_COUNTDOWN and gbl_countdown_entry == false) then
        gbl_countdown_entry = true
        enter_digit = 1
    end 
    update_display()

end

function callback_start_stop_button()

    if (display_page == PAGE_FLT_TIMER) then  
        gbl_flight_time_active = not gbl_flight_time_active
    elseif (display_page == PAGE_ALT_MON) then
        toggle_alt_monitor()
    elseif (display_page == PAGE_COUNTUP) then
        gbl_elapsed_active = not gbl_elapsed_active
    elseif (display_page == PAGE_COUNTDOWN) then
        gbl_countdown_active = not gbl_countdown_active
        gbl_countdown_expired = false
    end   
end

function callback_clr_button()
    if (display_page >= PAGE_NORMAL and (enter_digit > 0 or entry_timeout > 0) and gbl_countdown_entry == false) then
        if (enter_digit == 0) then
            enter_digit = 4
            tempCodeString = tempCodeString - tempCodeString % 10
        end    
        if (enter_digit == 2) then
            tempCodeString = tempCodeString - tempCodeString % 1000
        elseif (enter_digit == 3) then
            tempCodeString = tempCodeString - tempCodeString % 100
        end   
        enter_digit = enter_digit-1
        if (enter_digit > 0) then
            entry_timeout = ENTRY_TIMEOUT_START
        end    
    elseif (display_page == PAGE_FLT_TIMER) then
        gbl_flight_time = 0
        gbl_flight_time_active = false
    elseif (display_page == PAGE_COUNTUP) then
        gbl_countup_time = 0
        gbl_elapsed_active = false
    elseif (display_page == PAGE_COUNTDOWN) then
        if (gbl_countdown_entry == true) then
            enter_digit = enter_digit -1
            if (enter_digit == 0) then
                entry_timeout = 0
                gbl_countdown_time = gbl_countdown_initial
                gbl_countdown_entry = false
            elseif (enter_digit == 1) then
                gbl_countdown_time = gbl_countdown_time - (gbl_countdown_time % 360000)
            elseif (enter_digit == 2) then
                gbl_countdown_time = gbl_countdown_time - (gbl_countdown_time % 36000)
            elseif (enter_digit == 3) then
                gbl_countdown_time = gbl_countdown_time - (gbl_countdown_time % 3600)
            elseif (enter_digit == 4) then
                gbl_countdown_time = gbl_countdown_time - (gbl_countdown_time % 600)
            elseif (enter_digit == 5) then
                gbl_countdown_time = gbl_countdown_time - (gbl_countdown_time % 60)
            end           
            entry_timeout = ENTRY_TIMEOUT_LAST        
        else
            gbl_countdown_time = gbl_countdown_initial
            gbl_countdown_active = false
        end    
    end
    update_display()
end


function decimal_to_hex(frequency)

    local hex = 0

    for i = 0, 3 do
        hex = hex + (math.floor(frequency % 10) << (i * 4))
        frequency = frequency / 10
    end
    
    return hex
    
end

function enter_transponder_code(digit)    

    if (digit < 8) then

        if (enter_digit == 0) then
            tempCodeString = digit*1000
        elseif (enter_digit == 1) then
            tempCodeString = tempCodeString + digit*100            
        elseif (enter_digit == 2) then
            tempCodeString = tempCodeString + digit*10
        elseif (enter_digit == 3) then
            tempCodeString = tempCodeString + digit
        end
    
        enter_digit = enter_digit +1

        if (enter_digit >= 4) then
            enter_digit = 0
            xpl_dataref_write("sim/cockpit/radios/transponder_code", "INT", tempCodeString)   
            fsx_event("XPNDR_SET", decimal_to_hex(tempCodeString))
            msfs_event("XPNDR_SET", decimal_to_hex(tempCodeString))  
        end

        entry_timeout = ENTRY_TIMEOUT_START
        update_display()
    end
end

function enter_countdown_time(digit)

    gbl_countdown_active = false
    enter_digit = enter_digit + 1 
    if (enter_digit == 2) then
        gbl_countdown_time = digit*36000
    elseif (enter_digit == 3) then
        gbl_countdown_time = gbl_countdown_time + digit*3600
    elseif (enter_digit == 4) then
        if (digit < 6) then
            gbl_countdown_time = gbl_countdown_time + digit*600
        else
            enter_digit = enter_digit - 1    
        end
    elseif (enter_digit == 5) then
        gbl_countdown_time = gbl_countdown_time + digit*60
    elseif (enter_digit == 6) then
        if (digit < 6) then
            gbl_countdown_time = gbl_countdown_time + digit*10
        else
            enter_digit = enter_digit - 1    
        end    
    elseif (enter_digit == 7) then
        gbl_countdown_time = gbl_countdown_time + digit
    end
    
    update_display()
    
    if (enter_digit >= 7) then
        enter_digit = 0
        entry_timeout = 0
        gbl_countdown_initial = gbl_countdown_time
        gbl_countdown_entry = false
    else
        entry_timeout = ENTRY_TIMEOUT_START        
    end    
end

function button_pressed(digit)
    if display_page == PAGE_COUNTDOWN and gbl_countdown_entry then
        enter_countdown_time(digit)    
    elseif display_page >= 2 then
        enter_transponder_code(digit)
    end    
end                            

                                                                            

