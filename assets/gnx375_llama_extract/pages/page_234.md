# CONUS & REGIONAL NEXRAD

FIS-B NEXRAD is uplinked to the aircraft as two separate weather products: CONUS and Regional NEXRAD. Both products display individually or simultaneously, separated by a white hash-marked boundary, based on source selection.

![Map showing Regional Echo Block, Regional Boundary, and CONUS Echo Block](page_234_image_1_v2.jpg)

CONUS & Regional NEXRAD Combined

Depending on the locations of received FIS-B ground stations, Regional NEXRAD coverage can extend as far as 250 nm around an aircraft’s position. Aircraft flying at higher altitudes typically receive data from more ground stations than aircraft flying at low altitudes.

Turbulence, Icing, Lightning, and Cloud Tops are regional with a rectangular border. Any areas lacking data within the border are masked.

FIS-B NEXRAD does not differentiate between liquid and frozen precipitation types.

Source options are selectable from the weather setup menu or the NEXRAD key at the bottom left of the FIS-B Weather page. The key label changes to reflect the active source.

![NEXRAD CONUS source selection key](page_234_image_3_v2.jpg)

![NEXRAD Regional source selection key](page_234_image_2_v2.jpg)

![NEXRAD Combined source selection key](page_234_image_4_v2.jpg)

CONUS

Regional

Combined

## CONUS
* Large, low-resolution weather image for the entire continental U.S.
* Pixels are 7.5 min (7.5 nm = 13.89 km) wide by 5 min (5 nm = 9.26 km) wide

## Regional
* High-resolution weather image with limited range, centered around each broadcasting ground station
* Pixels are 1.5 min (1.5 nm = 2.78 km) wide by 1 min (1 nm = 1.852 km) tall
* Each weather pixel varies with latitude. Above 60º latitude, pixel block width doubles to 3 min/nm for regional maps

## Combined
* Both CONUS and Regional NEXRAD images display simultaneously
* White hash mark indicates regional boundary