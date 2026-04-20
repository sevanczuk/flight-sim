-- Display
--
-- Define all text and numbers shown on main display
-- Update and make visible/invisible on demand from other functions, using global data 
--
-- Constants
--
ENTRY_TIMEOUT_START = 8
ENTRY_TIMEOUT_LAST = 5
COUNTDOWN_INITIAL = 15*60

PAGE_OFF = 0
PAGE_STARTUP = 1

PAGE_NORMAL = 3
PAGE_FLT_TIMER = 4
PAGE_ALT_MON = 5
PAGE_COUNTUP = 6
PAGE_COUNTDOWN = 7
LAST_PAGE = PAGE_COUNTDOWN
PAGE_SHUTDOWN = 8

display_page = 0
entry_timeout = 0

-- flight timer (increments only in ON or ALT modes) and elapsed timer (always increments)
gbl_countup_time = 0
gbl_flight_time = 0
gbl_flight_time_active = true
gbl_elapsed_active = false
gbl_countdown_active = false
gbl_countdown_initial = COUNTDOWN_INITIAL
gbl_countdown_time = COUNTDOWN_INITIAL
gbl_countdown_expired = false
gbl_countdown_entry = false

-- current squawk and Flight ID, also temp versions used during data entry, enter_digit is index for digit/char being updated
currentCodeString = 0
tempCodeString = 0
enter_digit = 0

function init_display()
    -- Add images in Z-order --
    if (user_prop_get(rect_back_prop) == "Rectangular") then
        img_add_fullscreen("gtx_black_rectangle_backplate.png")
    end    
    img_add_fullscreen(fif(user_prop_get(btn_colour_prop)== "Black","black_buttons/gtx_back.png","grey_buttons/gtx_back.png"))

    -- Fonts
    colour_highlight = "color: #000000; background_color: #e8e65f;"
    colour_normal = "color: #e8e65f; background_color: #000000;"
    local colour_white = "color: white;"
    local font = "font:roboto_bold.ttf; "

    local font_huge_letter = font.."size:60px; halign: left;"..colour_normal
    local font_large_letter = font.."size:40px; halign: left;"..colour_normal
    local font_large_letter_centre = font.."size:40px; halign: center;"..colour_normal
    local font_large_letter_right = font.."size:40px; halign: right;"..colour_normal
    local font_pralt = font.."size:40px; halign: left;"..colour_normal
    local font_pralt_ft = font.."size:40px; halign: right;"..colour_normal
    local font_small_right  = font.."size:24px; halign: right;"..colour_normal
    local font_small_centre  = font.."size:24px; halign: centre;"..colour_normal
    local font_small_left  = font.."size:24px; halign: left;"..colour_normal
    local font_shutdown  = font.."size:20px; halign: left;"..colour_normal
    local font_tiny_left = font.."size:16px; halign: left;"..colour_normal
    local font_ident = font.."size:24px; halign: left;"..colour_highlight
    local font_model_front = font.."size: 16px; halign: right;"..colour_white
    
    -- Add text --
    -- Front panel model number painted on
    txt_model_front = txt_add(user_prop_get(gtx_model_prop),font_model_front,612,08,70,14)
    
    -- Startup Splash Screen
    txt_brand = txt_add("Garmin", font_small_left, 200, 39, 90, 25)
    txt_model = txt_add(user_prop_get(gtx_model_prop),font_large_letter_centre,265,29,150,35)
    txt_copyr = txt_add("(C) 1990-2012",font_small_left,431,39,120,20)
    txt_swver = txt_add("SW Version 7.00 Garmin Ltd or subs",font_small_centre,214,62,300,25)
    txt_selft = txt_add("Self Test In Progress",font_small_centre,270,85,200,25)
    group_splash_screen = group_add(txt_brand,txt_model,txt_copyr,txt_swver,txt_selft)
    visible(group_splash_screen,false)    
   
    -- Left hand mode/status
    txt_ident = txt_add("IDENT", font_ident, 190, 25, 55, 20)
    txt_mode = txt_add(" ", font_small_left, 190, 46, 200, 50)
    img_reply = img_add("reply_icon.png", 190, 72, 23, 22)
    group_status = group_add(txt_mode, txt_ident, img_reply)
    visible(group_status,false)
    
    -- Squawk code
    local squawk_spacing = 30
    local squawk_left = 257
    
    txt_squawk_1 = txt_add(" ", font_huge_letter, squawk_left, 40, squawk_spacing, 50)
    txt_squawk_2 = txt_add(" ", font_huge_letter, squawk_left+1*squawk_spacing, 40, squawk_spacing, 50)
    txt_squawk_3 = txt_add(" ", font_huge_letter, squawk_left+2*squawk_spacing, 40, squawk_spacing, 50)
    txt_squawk_4 = txt_add(" ", font_huge_letter, squawk_left+3*squawk_spacing, 40, squawk_spacing, 50)
    group_squawk_code = group_add(txt_squawk_1, txt_squawk_2, txt_squawk_3, txt_squawk_4)
    visible(group_squawk_code,false)

    -- Pressure Altitude common
    txt_pralt = txt_add("PRESSURE ALT", font_small_left, 426, 34, 131, 25)
    img_pralt_dir_up = img_add("up_icon.png",540,70,16,24)
    img_pralt_dir_down = img_add("down_icon.png",540,70,16,24) 
    group_pralt_dir = group_add(img_pralt_dir_up,img_pralt_dir_down)
    visible(group_pralt_dir,false)
               
    -- Pressure Altitude in Flight Level
    txt_pralt_fl = txt_add("FL", font_small_left, 449, 70, 28, 20)
    txt_pralt_fl_val = txt_add("---", font_pralt, 476, 60, 62, 32)
    group_pralt_fl = group_add(txt_pralt, txt_pralt_fl, txt_pralt_fl_val)
    visible(group_pralt_fl, false)

    -- Pressure Altitude in feet
    txt_pralt_ft = img_add("ft_icon.png", 525, 70, 10, 23)
    txt_pralt_ft_val = txt_add("-----", font_pralt_ft, 430,60, 90, 32)
    group_pralt_ft = group_add(txt_pralt, txt_pralt_ft, txt_pralt_ft_val)
    visible(group_pralt_ft, false)

    -- Flight Timer
    txt_flt_time_top = txt_add("FLIGHT TIME",font_small_left,426,34,125,25)
    txt_flt_time = txt_add("00:00:00",font_large_letter,425,56,125,32)
    group_flt_time = group_add(txt_flt_time_top,txt_flt_time)
    visible(group_flt_time,false)
    
    -- Alt monitor
    txt_alt_monitor_top = txt_add("ALT MONITOR",font_small_left,426,34,120,25)
    txt_alt_dev = txt_add("200",font_large_letter_right,382,56,90,32)
    txt_alt_dir = txt_add("ABOVE",font_small_left,490,65,65,32)
    img_ft_icon = img_add("ft_icon.png",477,64,10,23)
    group_alt_monitor = group_add(txt_alt_monitor_top,txt_alt_dev,txt_alt_dir,img_ft_icon)
    visible(group_alt_monitor,false)

    -- Count Up Timer
    txt_up_timer_top = txt_add("COUNT UP",font_small_left,426,34,125,25)
    txt_up_timer = txt_add("00:00:00",font_large_letter,425,56,125,32)
    group_up_timer = group_add(txt_up_timer_top,txt_up_timer)
    visible(group_up_timer,false)

    -- Count Down Timer
    countdown_width = 16
    colon_width = 12
    txt_down_timer_top = txt_add("COUNT DOWN",font_small_left,426,34,125,25)
    txt_down_expired = txt_add("EXPIRED",font_tiny_left,426,90,125,20)
    txt_down_1 = txt_add("0",font_large_letter,425,56,16,32)
    txt_down_2 = txt_add("0",font_large_letter,425+countdown_width,56,16,32)
    txt_down_3 = txt_add(":",font_large_letter,425+countdown_width*2+2,56,10,32)
    txt_down_4 = txt_add("0",font_large_letter,425+countdown_width*2+colon_width,56,16,32)
    txt_down_5 = txt_add("0",font_large_letter,425+countdown_width*3+colon_width,56,16,32)
    txt_down_6 = txt_add(":",font_large_letter,425+countdown_width*4+colon_width+2,56,10,32)
    txt_down_7 = txt_add("0",font_large_letter,425+countdown_width*4+colon_width*2,56,16,32)
    txt_down_8 = txt_add("0",font_large_letter,425+countdown_width*5+colon_width*2,56,16,32)
    group_down = group_add(txt_down_timer_top,txt_down_expired,txt_down_1,txt_down_2,txt_down_3,txt_down_4,txt_down_5,txt_down_6,txt_down_7,txt_down_8)
    visible(group_down,false)
    
    -- Powering Down
    txt_down1 = txt_add("Powering",font_shutdown, 456, 34, 80, 20)
    txt_down2 = txt_add("down; release", font_shutdown, 444, 52, 105, 20)
    txt_down3 = txt_add("to restore", font_shutdown, 460, 70, 75, 18)
    group_splash_down = group_add(txt_down1, txt_down2, txt_down3)
    visible(group_splash_down,false)
    
    -- Global text group for controlling when backlit 
    group_visible = group_add(txt_ident,txt_mode,txt_squawk_1,txt_squawk_2,txt_squawk_3,txt_squawk_4,img_reply,
                                   txt_pralt,txt_pralt_fl,txt_pralt_fl_val,txt_pralt_ft,txt_pralt_ft_val,
                                   txt_flt_time_top,txt_flt_time,
                                   txt_alt_monitor_top,txt_alt_dev,txt_alt_dir,img_pralt_dir_up,img_pralt_dir_down,img_ft_icon,
                                   txt_up_timer_top,txt_up_timer,
                                   txt_down_timer_top,txt_down_expired,
                                   txt_down_1,txt_down_2,txt_down_3,txt_down_4,txt_down_5,txt_down_6,txt_down_7,txt_down_8,
                                   txt_down1,txt_down2,txt_down3)

    -- Set defaults and user props
    visible(txt_mode,false)
    visible(txt_ident,false)
    visible(txt_pralt,false)

    visible(group_squawk_code,false)
end

function update_display()


    -- Reformat the display depending on current page
    if (display_page >= PAGE_NORMAL) then
        if (enter_digit > 0 and gbl_countdown_entry == false) then 
            squawk = tempCodeString
        else
            squawk = currentCodeString
        end
        txt_set(txt_squawk_1, string.format("%01.0f",math.floor(squawk / 1000)))
        txt_set(txt_squawk_2, string.format("%01.0f", math.floor(squawk / 100 % 10)))
        txt_set(txt_squawk_3, string.format("%01.0f", math.floor(squawk / 10 % 10)))
        txt_set(txt_squawk_4, string.format("%01.0f", squawk % 10))
        
        if (enter_digit > 0 and gbl_countdown_entry == false) then
            txt_set(txt_squawk_2, fif(enter_digit < 2,"-",string.format("%01.0f", math.floor(squawk / 100 % 10))))
            txt_set(txt_squawk_3, fif(enter_digit < 3,"-",string.format("%01.0f", math.floor(squawk / 10 % 10))))
            txt_set(txt_squawk_4, fif(enter_digit < 4,"-",string.format("%01.0f", squawk % 10)))
        end        

        txt_style(txt_squawk_2, fif(gbl_countdown_entry == false and (enter_digit == 1), colour_highlight, colour_normal))
        txt_style(txt_squawk_3, fif(gbl_countdown_entry == false and (enter_digit == 2), colour_highlight, colour_normal))
        txt_style(txt_squawk_4, fif(gbl_countdown_entry == false and (enter_digit == 3), colour_highlight, colour_normal))

    end
    
    if (display_page == PAGE_FLT_TIMER) then
        txt_set(txt_flt_time,string.format("%02d:%02d:%02d", math.floor(gbl_flight_time/3600), math.floor((gbl_flight_time%3600)/60), math.floor(gbl_flight_time%60)))
    elseif (display_page == PAGE_COUNTUP) then
        txt_set(txt_up_timer,string.format("%02d:%02d:%02d", math.floor(gbl_countup_time/3600), math.floor((gbl_countup_time%3600)/60), math.floor(gbl_countup_time%60)))
    elseif (display_page == PAGE_COUNTDOWN) then
        txt_set(txt_down_1,string.format("%01d",math.floor(gbl_countdown_time/36000)))
        txt_set(txt_down_2,string.format("%01d",math.floor((gbl_countdown_time%36000)/3600)))
        
        txt_set(txt_down_4,string.format("%01d",math.floor((gbl_countdown_time%3600)/600)))
        txt_set(txt_down_5,string.format("%01d",math.floor((gbl_countdown_time%600)/60)))
        
        txt_set(txt_down_7,string.format("%01d",math.floor((gbl_countdown_time%60)/10)))
        txt_set(txt_down_8,string.format("%01d",math.floor(gbl_countdown_time%10)))    
        
        txt_style(txt_down_1, fif(gbl_countdown_entry and (enter_digit == 1), colour_highlight, colour_normal))
        txt_style(txt_down_2, fif(gbl_countdown_entry and (enter_digit == 2), colour_highlight, colour_normal))
        txt_style(txt_down_4, fif(gbl_countdown_entry and (enter_digit == 3), colour_highlight, colour_normal))
        txt_style(txt_down_5, fif(gbl_countdown_entry and (enter_digit == 4), colour_highlight, colour_normal))
        txt_style(txt_down_7, fif(gbl_countdown_entry and (enter_digit == 5), colour_highlight, colour_normal))
        txt_style(txt_down_8, fif(gbl_countdown_entry and (enter_digit == 6), colour_highlight, colour_normal))                
    end

    -- Decide what to show (or not)    
    if (display_page < PAGE_NORMAL) then
        visible(group_status,false)
    end
    
    visible(group_splash_screen,display_page == PAGE_STARTUP)
    visible(group_splash_down, display_page == PAGE_SHUTDOWN) 
  
    visible(txt_mode, display_page >= PAGE_NORMAL)
    visible(group_squawk_code,display_page >= PAGE_NORMAL)
    if (user_prop_get(alt_mode_prop) == "Feet") then
        visible(group_pralt_ft, display_page == PAGE_NORMAL)
    else
        visible(group_pralt_fl, display_page == PAGE_NORMAL)
    end    
    if (display_page ~= PAGE_NORMAL) then
        visible(group_pralt_dir,false)
    end
        
    visible(group_flt_time,display_page == PAGE_FLT_TIMER) 
    
    visible(txt_alt_monitor_top,display_page == PAGE_ALT_MON)
    if (display_page ~= PAGE_ALT_MON) then
        visible(group_alt_monitor,false)
    end       
    
    visible(group_up_timer,display_page == PAGE_COUNTUP)    
    
    visible(group_down,display_page == PAGE_COUNTDOWN)
    visible(txt_down_expired,display_page == PAGE_COUNTDOWN and gbl_countdown_expired)   
    
end

