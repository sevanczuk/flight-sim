# GPS Alerts

The following alert conditions can affect GPS accuracy.


<table>
  <thead>
    <tr>
        <th>INDICATIONS</th>
        <th>FAULT TYPE</th>
        <th>CONDITION</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Yellow “LOI” annunciation.</td>
        <td>Loss of Integrity</td>
        <td>Integrity of the GPS position does not meet the requirements for the current phase of flight. Occurs before the final approach fix (if an approach is active).</td>
    </tr>
    <tr>
        <td rowspan="4">Unit invalidates active course guidance. Annunciation is specific to cause.</td>
        <td rowspan="4">Loss of Navigation</td>
        <td>Aircraft is after the final approach fix and GPS integrity does not meet the active approach requirements.</td>
    </tr>
    <tr>
        <td>Insufficient number of satellites supporting aircraft position (i.e., more than 5 seconds pass without adequate satellites to compute a position).</td>
    </tr>
    <tr>
        <td>GPS sensor detects an excessive position error or failure that cannot be excluded within the time to alert.</td>
    </tr>
    <tr>
        <td>On-board hardware failure.</td>
    </tr>
    <tr>
        <td>Yellow “No GPS Position” annunciation. Ownship icon not present</td>
        <td>Loss of Position</td>
        <td>Unit cannot determine a GPS position solution.</td>
    </tr>
  </tbody>
</table>