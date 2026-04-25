# CDI Scale

![Home > System > Setup navigation path](page_87_image_2_v2.jpg)

Set the scale for the course deviation indicator. Scale values represent full scale deflection for the CDI to either side.

Options: • 0.30 nm • 1.00 nm • 2.00 nm • Auto

Scale selections are reflected in the annunciator bar.

![Comparison of Auto Setting Annunciation showing "ENR" and Manual Setting Annunciation showing "1.00 NM"](page_87_image_1_v2.jpg)

**CDI scale is set to “Auto” (default).** At the default setting, the scale sets to 2.0 nm during the en route phase of flight.

**Aircraft is within 31 nm of the destination airport (i.e., terminal area).**
The scale linearly ramps down to 1.0 nm over a distance of 1 nm.

**Aircraft is leaving the departure airport.** The scale is set to 1.0 nm once the aircraft is over 30 nm from the departure airport. It begins to gradually ramp up to 2 nm when the flight phase changes from terminal (TERM) to en route (ENR).

During GPS approach operations, the scale gradually transitions down to an angular scale.

**Aircraft is 2.0 nm before the final approach fix.** Scaling tightens from 1.0 nm to the angular full-scale deflection defined for the approach (typically 2.0º).

> Selecting a lower value (0.3 nm or 1.0 nm) prevents the selection of higher scale settings during ANY phase of flight. Example: If you select 1.0 nm, the unit uses this setting for en route and terminal phases, and ramps down further during approach.