img_ann_back  = img_add_fullscreen("AnnunciatorBack.png")
img_ann_fuel  = img_add_fullscreen("AnnunciatorLowFuel.png", "visible:false")
img_ann_volts = img_add_fullscreen("AnnunciatorVolts.png", "visible:false")
img_ann_oil   = img_add_fullscreen("AnnunciatorOilPress.png", "visible:false")
img_ann_vac   = img_add_fullscreen("AnnunciatorVac.png", "visible:false")
img_ann_vacl  = img_add_fullscreen("AnnunciatorVacL.png", "visible:false")
img_ann_vacr  = img_add_fullscreen("AnnunciatorVacR.png", "visible:false")
img_ann_fuell = img_add_fullscreen("AnnunciatorLowFuelL.png", "visible:false")
img_ann_fuelr = img_add_fullscreen("AnnunciatorLowFuelR.png", "visible:false")
img_ann_bar   = img_add_fullscreen("AnnunciatorLine.png", "visible:false")

function new_battery_xpl(bus_volts, low_volt_warn, oil_pressure, battery_voltage, vacuum1, vacuum2, fuel_quantity, annunciator_test)

    local power = bus_volts[1] >= 8
    local light_test = annunciator_test == 1 and power
    
    -- Low fuel
    visible(img_ann_fuel, ((fuel_quantity[1] < 10 or fuel_quantity[2] < 10) or light_test) and power)
    visible(img_ann_fuell, (fuel_quantity[1] < 10 or light_test) and power)
    visible(img_ann_fuelr, (fuel_quantity[2] < 10 or light_test) and power)
    
    -- Oil pressure
    visible(img_ann_oil, (oil_pressure == 1 or light_test) and power)
    
    -- Vacuum
    visible(img_ann_vac, (vacuum1 < 3 or vacuum2 < 3 or light_test) and power)
    visible(img_ann_vacl, (vacuum1 < 3 or light_test) and power)
    visible(img_ann_vacr, (vacuum2 < 3 or light_test) and power)
    
    -- Volts
    visible(img_ann_volts, (low_volt_warn == 1 or light_test) and power)

end

function new_warn_fsx(oil_pressure, bus_volts, gen_volts, vacuum, fuelq_l, fuelq_r, test_switch)

    local power = bus_volts >= 8
    local light_test = test_switch == 0 and power
    
    -- Low fuel
    visible(img_ann_fuel, ((fuelq_l < 5 or fuelq_r < 5) or light_test) and power)
    visible(img_ann_fuell, (fuelq_l < 5 or light_test) and power)
    visible(img_ann_fuelr, (fuelq_r < 5 or light_test) and power)
    
    -- Oil pressure
    visible(img_ann_oil, (oil_pressure < 20 or light_test) and power)
    
    -- Vacuum
    visible(img_ann_vac, (vacuum < 3 or light_test) and power)
    visible(img_ann_vacl, (vacuum < 3 or light_test) and power)
    visible(img_ann_vacr, (vacuum < 3 or light_test) and power)
    
    -- Volts
    visible(img_ann_volts, (gen_volts < 24.5 or light_test) and power)

end

function new_warn_fs2020(oil_pressure, bus_volts, gen_volts, vacuum1, vacuum2, fuelq_l, fuelq_r, test_switch)

    local power = bus_volts >= 8
    local light_test = test_switch == 1 and power
    
    -- Low fuel
    visible(img_ann_fuel, ((fuelq_l < 5 or fuelq_r < 5) or light_test) and power)
    visible(img_ann_fuell, (fuelq_l < 5 or light_test) and power)
    visible(img_ann_fuelr, (fuelq_r < 5 or light_test) and power)
    
    -- Oil pressure
    visible(img_ann_oil, (oil_pressure < 20 or light_test) and power)
    
    -- Vacuum
    visible(img_ann_vac, (vacuum1 < 3 or vacuum2 < 3 or light_test) and power)
    visible(img_ann_vacl, (vacuum1 < 3 or light_test) and power)
    visible(img_ann_vacr, (vacuum2 < 3 or light_test) and power)
    
    -- Volts
    visible(img_ann_volts, (gen_volts < 24.5 or light_test) and power)
    
    -- Bar
    visible(img_ann_bar, light_test)
    
end

function new_warn_fs2024(oil_pressure, bus_volts, gen_volts, vacuum1, vacuum2, fuelq_l, fuelq_r, test_switch)

    local power = bus_volts >= 8
    local light_test = test_switch == 0 and power
    
    -- Low fuel
    visible(img_ann_fuel, ((fuelq_l < 5 or fuelq_r < 5) or light_test) and power)
    visible(img_ann_fuell, (fuelq_l < 5 or light_test) and power)
    visible(img_ann_fuelr, (fuelq_r < 5 or light_test) and power)
    
    -- Oil pressure
    visible(img_ann_oil, (oil_pressure < 20 or light_test) and power)
    
    -- Vacuum
    visible(img_ann_vac, (vacuum1 < 3 or vacuum2 < 3 or light_test) and power)
    visible(img_ann_vacl, (vacuum1 < 3 or light_test) and power)
    visible(img_ann_vacr, (vacuum2 < 3 or light_test) and power)
    
    -- Volts
    visible(img_ann_volts, (gen_volts < 24.5 or light_test) and power)

    -- Bar
    visible(img_ann_bar, light_test)
    
end

xpl_dataref_subscribe("sim/cockpit2/electrical/bus_volts", "FLOAT[6]",
                      "sim/cockpit/warnings/annunciators/low_voltage", "INT",
                      "sim/cockpit/warnings/annunciators/oil_pressure","INT",
                      "sim/cockpit2/electrical/battery_voltage_indicated_volts","FLOAT[8]",
                      "sim/cockpit/misc/vacuum", "FLOAT",
                      "sim/cockpit/misc/vacuum2", "FLOAT",
                      "sim/cockpit2/fuel/fuel_quantity","FLOAT[2]",
                      "sim/cockpit/warnings/annunciator_test_pressed", "INT",  new_battery_xpl)

fsx_variable_subscribe("GENERAL ENG OIL PRESSURE:1", "Psi",
                       "ELECTRICAL MAIN BUS VOLTAGE", "Volts",
                       "ELECTRICAL GENALT BUS VOLTAGE:1", "Volts",
                       "SUCTION PRESSURE", "inHg",
                       "FUEL TANK LEFT MAIN QUANTITY", "gallons",
                       "FUEL TANK RIGHT MAIN QUANTITY", "gallons", new_warn_fsx)
                       
fs2020_variable_subscribe("GENERAL ENG OIL PRESSURE:1", "Psi",
                          "ELECTRICAL MAIN BUS VOLTAGE", "Volts",
                          "ELECTRICAL GENALT BUS VOLTAGE:1", "Volts",
                          "SUCTION PRESSURE:1", "inHg",
                          "SUCTION PRESSURE:2", "inHg",
                          "FUEL TANK LEFT MAIN QUANTITY", "gallons",
                          "FUEL TANK RIGHT MAIN QUANTITY", "gallons", 
                          "L:buttonAnnTest", "Double", new_warn_fs2020)
                          
fs2024_variable_subscribe("GENERAL ENG OIL PRESSURE:1", "Psi",
                          "ELECTRICAL BUS VOLTAGE:1", "Volts",
                          "ELECTRICAL GENERATOR VOLTAGE:1", "Volts",
                          "SUCTION PRESSURE:1", "inHg",
                          "SUCTION PRESSURE:2", "inHg",
                          "FUEL TANK LEFT MAIN QUANTITY", "gallons",
                          "FUEL TANK RIGHT MAIN QUANTITY", "gallons",
                          "B:SAFETY_LIGHT", "Double", new_warn_fs2024)
-- END ANNUNCIATOR PANEL