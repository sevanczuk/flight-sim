-- Garmin GTX Transponder Series
--
-- MODELS
--
-- GTX 327. Mode-C, VFR only
-- GTX 328, Mode-S, VFR only
-- GTX 330, Mode-S, VFR and IFR
-- GTX 330ES, Mode-S and ADS-B, VFR and IFR
--
-- All have almost identical user interface from the pilot's perspective. 
--
-- OPERATION
--
-- Press and hold STANDBY, ON or ALT for 2 seconds to startup
-- Shutdown warning for 1 second
-- Splash screen with model number and self-test message fofr 5 seconds after startup
--
-- Enter/change squawk code by pressing buttons 0-7. Correct last digit by pressing CLR, even up to 5 seconds after new entry. Times out/reverts after 7 seconds.
-- Use VFR button to reset squawk to default VFR code 
-- IDENT button sends a code which highlights your aircraft on controllers' display for 17 seconds.
-- Use FUNC button to sequence through different display pages, Pressure Alt, Flight Time, Alt Monitor, Count Up, Count Down
-- Flight Timer page: Counts when in ALT or ON mode (not standby or ground). Can be reset using CLR button and restarted with START
-- Alt Monitor page: Activate using START/STOP which sets current level. Warns and flashes for deviations more than 200ft
-- Count up timer: Use START/STOP and CLR to reset
-- Count down timer: Use START/STOP. CLR to reset to last entered value. Use CRSR to enter new start value which must have all six digits.
-- Display dims with panel lighting if configured to do so
--
-- CONFIGURATION OPTIONS
--
-- Model number, displayed top right of front panel but has no other effect
-- Default VFR code, eg 1200 for North America, 7000 for Europe
-- Altitude mode: Display flight level (Europe) or altitude in feet (North America). Always based on standard pressure setting 1013hPa or 29.92in
-- Blackplate: Optionally fill in the rounded corners with black depending on panel
-- Button colour: Choice of black or grey
-- Dim Control: Optionally dim the display based oninstrument brightness control
--
-- Features not yet supported
--
-- Contrast Page
-- Display brightness page
-- 8 button reduces contrast/display brightness (but is only used for countdown timer entry)
-- 9 button increases above
-- Automatic GND/ALT mode switching after take-off/landing (assumed handled by aircraft model)
-- Entry of Flight ID (configuration mode page option)
-- Audio alert when countdown timer expires
-- Audio alert when deviating from altitude monitored
-- Outside air temperature and density altitude page (rarely fitted)

gtx_model_prop = user_prop_add_enum("GTX Model","GTX 327,GTX 328,GTX 330,GTX 330ES","GTX 330","Select model number")
vfr_user_prop = user_prop_add_integer("VFR code", 1, 7777, 1200, "Default VFR code")
alt_mode_prop = user_prop_add_enum("Altitude display","Feet,Flight Level","Flight Level","Select altitude display format")
rect_back_prop = user_prop_add_enum("Backplate","Rectangular,Rounded","Rounded","Select rectangular to fill in corners")
btn_colour_prop = user_prop_add_enum("Button colour","Black,Grey","Black","Select colour of buttons")
dimmer_prop = user_prop_add_boolean("Dim with instrument brightness",false,"")

init_transponder()
init_alt_monitor()
init_display()
init_buttons()
init_timers()


