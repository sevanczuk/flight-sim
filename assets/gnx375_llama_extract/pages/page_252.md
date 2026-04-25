# Motion Vectors

**FEATURE LIMITATIONS**

* *Motion vectors display on the Traffic page only*

A motion vector is a line extending from the nose of an intruder icon. Its orientation represents the intruder’s direction and movement.

A yellow vector indicates when traffic meets intruding TA criteria (i.e., closing rate, distance, vertical separation).


<table>
  <thead>
    <tr>
        <th colspan="2">MOTION VECTOR TYPES</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td rowspan="5">Absolute</td>
        <td>* White vector</td>
    </tr>
    <tr>
        <td>* Depicts intruder ground track</td>
    </tr>
    <tr>
        <td>* Calculations based on intruder direction and ground speed</td>
    </tr>
    <tr>
        <td>* Endpoint depicts intruder’s position over the ground at the end of the selected duration</td>
    </tr>
    <tr>
        <td>* Airborne and ground functionality</td>
    </tr>
    <tr>
        <td rowspan="6">Relative</td>
        <td>* Green vector</td>
    </tr>
    <tr>
        <td>* Depicts intruder movement relative to the ownship</td>
    </tr>
    <tr>
        <td>* Calculations based on track and ground speed of both intruder and ownship</td>
    </tr>
    <tr>
        <td>* Endpoint depicts intruder’s location relative to the ownship at the end of the selected duration</td>
    </tr>
    <tr>
        <td>* Airborne functionality only</td>
    </tr>
    <tr>
        <td>* “Relative Motion - Unavailable” annunciates during ground operations</td>
    </tr>
  </tbody>
</table>

# Altitude Filtering

Pilot selectable filters limit the display of traffic to a specific altitude range relative to the altitude of the ownship.

Filter selections apply to both the Traffic page and the traffic overlay on Map.


<table>
  <thead>
    <tr>
        <th>SELECTION</th>
        <th>LABEL</th>
        <th>ALTITUDE RANGE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Normal</td>
        <td>NORM</td>
        <td>-2,700 ft to 2,700 ft</td>
    </tr>
    <tr>
        <td>Above</td>
        <td>ABV</td>
        <td>-2,700 ft to 9,900 ft</td>
    </tr>
    <tr>
        <td>Below</td>
        <td>BLW</td>
        <td>-9,900 ft to 2,700 ft</td>
    </tr>
    <tr>
        <td>Unrestricted</td>
        <td>UNR</td>
        <td>-9,900 ft to 9,900 ft</td>
    </tr>
  </tbody>
</table>