# SBAS Providers

> ![Note Icon](page_105_image_3_v2.jpg) **NOTE**
>
> > *Operating with SBAS active outside of the service area may cause elevated EPU values to display on the status page. Regardless of the EPU value displayed, the LOI annunciation is the controlling indication for determining the integrity of the GPS navigation solution.*

![SBAS Key Icon](page_105_image_1_v2.jpg)

SBAS supports wide area or regional augmentation through the use of additional satellite broadcast messages.

Tap this key and select from the list of providers.


<table>
  <thead>
    <tr>
        <th>PROVIDER</th>
        <th>SERVICE AREAS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>EGNOS</td>
        <td>Most of Europe and parts of North Africa.</td>
    </tr>
    <tr>
        <td>GAGAN</td>
        <td>India only.</td>
    </tr>
    <tr>
        <td>MSAS</td>
        <td>Japan only.</td>
    </tr>
    <tr>
        <td>WAAS</td>
        <td>Alaska, Canada, the 48 contiguous states, and most of Central America.</td>
    </tr>
  </tbody>
</table>

# GPS Status Annunciations

Once the GPS receiver determines the aircraft’s position, the unit displays position, altitude, track, and ground speed data. GPS status annunciates under the following conditions.


<table>
  <thead>
    <tr>
        <th>ANNUNCIATION</th>
        <th>CONDITION</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Acquiring</td>
        <td>GPS receiver uses last known position and satellite orbital data (collected continuously from satellites) to determine which satellites should be in view.</td>
    </tr>
    <tr>
        <td>3D Nav</td>
        <td>3-D navigation mode. GPS receiver computes altitude using satellite data.</td>
    </tr>
    <tr>
        <td>3D Diff Nav</td>
        <td>3-D navigation mode. Differential corrections from SBAS provider are in use.</td>
    </tr>
    <tr>
        <td>LOI</td>
        <td>Satellite coverage is insufficient to pass built-in integrity monitoring tests.</td>
    </tr>
  </tbody>
</table>