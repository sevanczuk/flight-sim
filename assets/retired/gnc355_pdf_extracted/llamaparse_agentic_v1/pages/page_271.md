
Based on the provided image, here is a detailed analysis of the content, which is a page from a pilot's guide.

The page, numbered 5-36, is titled "Hazard Awareness" and focuses on "GPS Altitude for Terrain." It explains the technical aspects of how GPS altitude is used for terrain awareness systems.

### Key Information from the Page

The document is structured into two main sections:

----

#### **1. FEATURE REQUIREMENTS**

This section explains the fundamental requirements for GPS altitude to function correctly.

- **GPS Altitude Derivation:** GPS altitude is calculated from satellite measurements.
- **3-D Fix Requirement:** To obtain an accurate 3-D fix (latitude, longitude, and altitude), a minimum of four operating satellites must be visible to the GPS receiver antenna.
- **Purpose of Terrain System:** The terrain system uses GPS altitude and position data to:
    - Create a 2-D image of the surrounding terrain and obstacles relative to the aircraft's position and altitude.
    - Calculate the aircraft's flight path in relation to surrounding terrain and obstacles.
    - Predict hazardous terrain conditions and issue alerts.

----

#### **2. GSL ALTITUDE & INDICATED ALTITUDE**

This section compares two different types of altitude measurements used in the aircraft.

- **GSL Altitude:** The unit converts the raw GPS altitude data into GSL (Geometric Sea Level) altitude, which is the geometric height above Mean Sea Level (MSL). This is the altitude used for all terrain functions and displayed on the Terrain page.
- **Indicated Altitude:** This is the aircraft's corrected barometric altitude, which is the standard altitude read from the altimeter.
- **Key Difference:** The page notes that variations between GSL altitude and indicated altitude are common. This means the altitude shown on the Terrain page may differ from the altimeter reading. While both represent height above MSL, they differ in their accuracy and reliability.

A table provides a direct comparison between the two altitude types:

| \*\*GSL ALTITUDE\*\*                                                    | \*\*INDICATED ALTITUDE\*\*                                                   |
| ----------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| Highly accurate and reliable geometric altitude source                  | Barometric altitude source corrected for pressure variations                 |
| Does not require local altimeter settings to determine height above MSL | Requires frequent altimeter setting adjustment to determine height above MSL |
| Not subject to pressure and temperature variations                      | Subject to local atmospheric conditions                                      |
| Affected primarily by satellite geometry                                | Affected by variations in pressure, temperature, and lapse rate              |



