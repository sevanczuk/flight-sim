# Weather Awareness

![Warning Icon](page_225_image_1_v2.jpg)
## WARNING

**Do not rely solely on datalink weather for weather information. Datalink weather provides a snapshot in time. It may not accurately reflect the current weather situation.**

![Note Icon](page_225_layout_ocr_aqyc_31_117_34_35.png)
## NOTE

*Datalink weather is not intended to replace weather briefings or in-flight weather reports from AFSS or ATC.*

### FEATURE REQUIREMENTS

* GPS 175/GNC 355 with UAT receiver (GDL 88, GTX 345, GNX 375) and FIS-B

OR

* GNX 375 and FIS-B

The FAA provides FIS-B as a Surveillance and Broadcast Service operating on the UAT (978 MHz) frequency band. FIS-B uses a network of FAA-operated ground-based transceivers to transmit weather datalink information to the aircraft’s receiver on a scheduled continuous basis.

<mark>The Flight Information Service-Broadcast (FIS-B) Weather service is freely available for aircraft equipped with a capable datalink universal access transceiver (UAT). Ground stations provide uninterrupted services for the majority of the contiguous U.S., Hawaii, Guam, Puerto Rico, and parts of Alaska. No weather subscription service is required. For the latest FAA ground station coverage information, visit: <u>www.faa.gov/nextgen/programs/adsb/</u></mark>

## Data Transmission Limitations

FIS-B broadcasts provide weather data in a repeating cycle which may take several minutes to completely transmit all available weather data. Therefore, not all weather data may be immediately present upon initial FIS-B signal acquisition.

## Line of Sight Reception

To receive FIS-B weather information, the aircraft’s datalink receiver must be within range and line-of-sight of an operating ground-based transceiver. Reception may be affected by altitude, terrain, and other factors. Per the FAA, much of the United States has FIS-B In airborne coverage at and above 3,000 feet AGL. Terminal coverage is available at altitudes below 3,000 feet AGL and is available when flying near approximately 235 major U.S. airports. Surface coverage allows FIS-B ground reception at approximately 36 major U.S. airports.