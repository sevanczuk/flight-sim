# SIGNAL STRENGTH INDICATIONS

## Satellite SVIDs

Each bar is labeled with the SVID of the corresponding satellite. Numbers vary according to satellite type.

* GPS: 1 to 31

* SBAS: 120 to 138

A graph shows GPS signal strength for up to 15 satellites. As the GPS receiver locks onto satellites, a signal strength bar appears for each satellite in view.

Graph symbols depict the progress of satellite acquisition. Some data may not display until the unit has acquired enough satellites for a fix.

![GPS signal strength bar graph showing various satellite SVIDs and signal levels with 'D' indicators for differential corrections.](page_103_image_1_v2.jpg)


<table>
  <thead>
    <tr>
        <th>SYMBOL</th>
        <th>CONDITION</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Not present</td>
        <td>Receiver is searching for the indicated satellites.</td>
    </tr>
    <tr>
        <td>Gray bar, empty</td>
        <td>Satellite located.</td>
    </tr>
    <tr>
        <td>Gray bar, solid</td>
        <td>Satellite located, receiver is collecting data.</td>
    </tr>
    <tr>
        <td>Yellow bar, solid</td>
        <td>Data collected, but satellite is excluded from position solution (i.e., it is not in use).</td>
    </tr>
    <tr>
        <td>Cyan bar, cross-hatch</td>
        <td>Satellite located, but FDE excludes it for being a faulty satellite.</td>
    </tr>
    <tr>
        <td>Cyan bar, solid</td>
        <td>Data collected, but receiver is not using satellite in the position solution.</td>
    </tr>
    <tr>
        <td>Green bar, solid</td>
        <td>Data collected, satellite in use in the current position solution.</td>
    </tr>
    <tr>
        <td>D (inside bar)</td>
        <td>Differential corrections are in use (e.g., SBAS, WAAS).</td>
    </tr>
  </tbody>
</table>

<mark>If the unit has not been in operation for more than six months, acquiring satellite data to establish almanac and satellite orbit information may take 5 to 10 minutes.</mark>