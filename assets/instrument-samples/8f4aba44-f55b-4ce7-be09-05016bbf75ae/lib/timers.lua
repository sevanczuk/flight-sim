-- timers
--
-- Countup and Countdown timer pages, plus startup splash screen timoeut

function init_timers()
    timer_start(0, 1000, elapsed_timer_callback)
end

-- This function is called every second to increment flight and elapsed timers, also reset entry timeout
-- count up (elapsed) timer increments when unit is powered and countup timer is active
-- flight timer increments whenever unit is powered and set to ON or ALT mode        
-- countdown timer decrements whenever unit is powered and countdown timer is active
function elapsed_timer_callback()

    if (gbl_elapsed_active) then
        gbl_countup_time = gbl_countup_time + 1
        update_display()
    end

    if gbl_flight_time_active and (display_page >= PAGE_NORMAL) then
        gbl_flight_time = gbl_flight_time + 1
        update_display()
    end

    if gbl_countdown_active then
        gbl_countdown_time = gbl_countdown_time + fif(gbl_countdown_expired,1,-1)
        if (gbl_countdown_time == 0) then
            gbl_countdown_expired = true
        end    
        update_display()
    end
                   
-- revert to previous displayed values if nothing entered for some time
    if (entry_timeout == 1) then
        enter_digit = 0
        gbl_countdown_entry = false
        update_display()
    end
    
    if (entry_timeout > 0) then
        entry_timeout = entry_timeout - 1         
    end    
end

function splash_timer_callback()

    if (display_page == PAGE_STARTUP) then
        display_page = PAGE_NORMAL
    end    
    update_display()
    timer_stop(timer_splash)    
end

function start_splash_timer()
    timer_splash = timer_start(5000,nil,splash_timer_callback)
end