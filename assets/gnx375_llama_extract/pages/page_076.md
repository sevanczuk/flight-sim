# XPDR Setup

```mermaid
graph TD
    XPDR_Menu[XPDR Menu] --- Data_Field[Data Field]
    Data_Field --- PRESS_ALT[PRESS ALT]
    Data_Field --- FLT_ID[FLT ID]
    XPDR_Menu --- ADSB_Out[ADS-B Out]
    XPDR_Menu --- Flight_ID[Flight ID]
    Flight_ID --- Specify[Specify flight ID<br/>if configurable]
```

Tap **Menu** to access the transponder setup options. From here you can:

* Change the display of data
* Enable 1090 ES ADS-B Out functionality (if configured)
* Assign a unique flight ID

## Displaying Data

![Transponder Data Field display showing PRESS ALT](page_76_image_1_v2.jpg)

Toggles the data field between pressure altitude and flight ID.

### Pressure Altitude

![Pressure ALT: 2297 FT](page_76_layout_ocr_seso_51_297_115_27.png)

Displays the current pressure altitude.

### Flight ID

![Flight ID: FLY4GA](page_76_layout_ocr_cxcj_222_297_114_27.png)

Displays the active Flight ID. Unless configured, the Flight ID is not editable.