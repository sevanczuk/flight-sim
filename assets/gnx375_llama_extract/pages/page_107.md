# ADS-B Status

## FEATURE REQUIREMENTS

* *GDL 88 or GTX 345 ADS-B transceiver (GPS 175 and GNC 355/355A only)*

OR

* *GNX 375*

## STATUS PAGE ACCESS KEY

Tap this key to view last uplink time and GPS source information.

**GPS 175/GNC 355/355A:** Key label reflects the configured ADS-B source.

**ADS-B Source: GDL 88**

**ADS-B Source: GTX 345**

![GDL 88 Status button screenshot](page_107_image_2_v2.jpg)

![ADS-B Status button screenshot](page_107_image_1_v2.jpg)

**GNX 375:** Key label reads "ADS-B Status."

## UPLINK TIME


<table>
  <thead>
    <tr>
        <th>TEXT COLOR</th>
        <th>MINUTES SINCE LAST UPLINK</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Green</td>
        <td>&lt; 5</td>
    </tr>
    <tr>
        <td rowspan="2">Yellow</td>
        <td>5 to 15</td>
    </tr>
    <tr>
        <td>&gt; 15</td>
    </tr>
  </tbody>
</table>

This field displays the number of minutes since last uplink. Digital values may change color depending on duration.

"> 15" displays when the time exceeds 15 minutes.

Dashes indicate when valid uplink data is unavailable (e.g., the device is offline).