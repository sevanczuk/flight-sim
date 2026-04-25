# GPS Altitude for Terrain

## FEATURE REQUIREMENTS

*GPS altitude is derived from satellite measurements. To acquire an accurate 3-D fix (latitude, longitude, altitude), a minimum of four operating satellites must be in view of the GPS receiver antenna.*

The terrain system uses GPS altitude and position data to:

* Create a 2-D image of surrounding terrain and obstacles relative to the aircraft’s position and altitude
* Calculate the aircraft’s flight path in relation to surrounding terrain and obstacles
* Predict hazardous terrain conditions and issue alerts

## GSL ALTITUDE & INDICATED ALTITUDE

The unit converts GPS altitude data to GSL altitude (i.e., the geometric altitude relative to MSL) for use in terrain functions. All Terrain page depictions and elevation indications are in GSL.

Variations between GSL altitude and the aircraft’s corrected barometric altitude (or indicated altitude) are common. As a result, Terrain page altitude data may differ from current altimeter readings. Both GSL altitude and indicated altitude represent height above MSL, but differ in accuracy and reliability.


<table>
  <thead>
    <tr>
        <th>GSL ALTITUDE</th>
        <th>INDICATED ALTITUDE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>• Highly accurate and reliable geometric altitude source</td>
        <td>• Barometric altitude source corrected for pressure variations</td>
    </tr>
    <tr>
        <td>• Does not require local altimeter settings to determine height above MSL</td>
        <td>• Requires frequent altimeter setting adjustment to determine height above MSL</td>
    </tr>
    <tr>
        <td>• Not subject to pressure and temperature variations</td>
        <td>• Subject to local atmospheric conditions</td>
    </tr>
    <tr>
        <td>• Affected primarily by satellite geometry</td>
        <td>• Affected by variations in pressure, temperature, and lapse rate</td>
    </tr>
  </tbody>
</table>