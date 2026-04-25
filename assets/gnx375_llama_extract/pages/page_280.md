### Points About Non-WGS84 Waypoints

* There are several types of geodetic datums that a waypoint can reference.

* TSO-C146 requires that all waypoints reference the WGS84 datum, but allows for navigation to coordinates not compliant with this standard as long as the pilot is notified of the potential difference in location.

* Not all waypoints in the navigation database reference the WGS84 datum. For some of these coordinates the reference datum is unknown. In such cases, the "Non-WGS84 Waypoint" advisory displays.

* Garmin cannot determine the exact proximity of a non-compliant waypoint to the WGS84 datum in use by the system. Typically, the distance is < 2 nm.

* Most non-WGS84 waypoints are outside of the United States.

## Pilot Specified Advisories

These advisories display when the associated timer expires or reaches a preset value. They are informational only. No action is necessary.


<table>
  <thead>
    <tr>
        <th>ADVISORY</th>
        <th>CONDITION</th>
        <th>CORRECTIVE ACTION</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>SCHEDULED MESSAGE - &lt;Text&gt;.</td>
        <td>The custom message timer expired.</td>
        <td>Acknowledge message.<br/>**Edit Message** key provides direct access to scheduled message options.</td>
    </tr>
    <tr>
        <td>Timer has expired.</td>
        <td>The generic timer is past its preset value.</td>
        <td>Acknowledge message.<br/>**Timers** key provides direct access to the generic clock/timer function.</td>
    </tr>
  </tbody>
</table>