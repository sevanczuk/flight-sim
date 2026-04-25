# Parallel Track

![Parallel Track button](page_147_image_2_v2.jpg)

Create a parallel course offset relative to the current flight plan. Setup controls provide offset distance and direction setting (left of track or right of track).

### FEATURE REQUIREMENTS
* Active flight plan

### FEATURE LIMITATIONS
* Function not available when Direct-to is active
* Graphical editing of the active leg cancels the parallel track function
* Offset range: 1 nm to 99 nm
* Large offset values combined with certain leg types (e.g., approach) or leg geometries (i.e., changes in track >120º) do not support parallel track


<table>
  <thead>
    <tr>
        <th>TRACK</th>
        <th>COLOR</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Offset</td>
        <td>Magenta</td>
    </tr>
    <tr>
        <td>Original</td>
        <td>Gray</td>
    </tr>
  </tbody>
</table>

Once activated, a new track line appears to the left or right of the original course line at the specified distance. The aircraft navigates to the offset track with external CDI/HSI guidance now driven from the parallel track.

![Map display showing parallel track offset](page_147_image_4_v2.jpg)

A graphical depiction overlays on the map.

Map

![Flight plan display showing parallel track symbols](page_147_image_1_v2.jpg)

Corresponding fix symbols on the flight plan indicate when the active leg is on a parallel track.

![GPS NAV Status indicator](page_147_image_3_v2.jpg)

### GPS 175 & GNX 375:
Active route identifiers also appear on the **GPS NAV Status** indicator key in the lower right corner of the display.

### GNC 355/355A:
If configured, a user field shows active route identifiers on Map.