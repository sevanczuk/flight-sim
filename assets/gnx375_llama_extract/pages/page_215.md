<table>
  <thead>
    <tr>
        <th>MODE</th>
        <th>SELECTION</th>
        <th>DESCRIPTION</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td rowspan="3">Point-to-Point</td>
        <td>P. Position</td>
        <td>* Enters the current aircraft coordinates as the departure location (or From waypoint)<br/>* Aircraft latitude and longitude fields replace the From waypoint key</td>
    </tr>
    <tr>
        <td>From</td>
        <td>* Specify a waypoint from the database as the departure location (or From waypoint)<br/>* Not available when P. Position is active</td>
    </tr>
    <tr>
        <td>To</td>
        <td>* Specify a waypoint from the database as the destination (or To waypoint)</td>
    </tr>
    <tr>
        <td rowspan="2">Flight Plan</td>
        <td>Flight Plan</td>
        <td>* Opens a list of available flight plans<br/>* Options include the active flight plan or one from the catalog<br/>* Defaults to the active flight plan if no selection is made</td>
    </tr>
    <tr>
        <td>Leg</td>
        <td>* Options dependent on flight plan selection<br/>* Defaults to cumulative leg option if no selection is made</td>
    </tr>
    <tr>
        <td rowspan="4">Both</td>
        <td>Fuel on Board</td>
        <td>* Specify the amount of fuel on board (gallons)<br/>* This amount decreases once per second based on the specified fuel flow value or sensor data</td>
    </tr>
    <tr>
        <td>Fuel Flow</td>
        <td>* Specify the current fuel flow rate (gallons per hour)</td>
    </tr>
    <tr>
        <td>Use Sensor Data</td>
        <td>* Toggle on to utilize current GPS ground speed data and fuel sensor data (if available)<br/>* When available, the unit displays fuel flow and fuel on board data from TXi, GI 275, or the fuel computer</td>
    </tr>
    <tr>
        <td>Ground Speed</td>
        <td>* Behavior based on state of **Use Sensor Data**<br/>**Use Sensor Data key inactive:**<br/>* Function selectable<br/>* Specify ground speed<br/>**Use Sensor Data key active:**<br/>* Function not selectable<br/>* Displays current GPS ground speed when the **Use Sensor Data** key is active<br/>* This value is used to calculate fuel statistics when you press the **Compute** key</td>
    </tr>
  </tbody>
</table>