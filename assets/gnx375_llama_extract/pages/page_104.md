# POSITION ACCURACY FIELDS

Information fields indicate the accuracy of the position fix.

HFOM and VFOM values represent 95% confidence levels in horizontal and vertical accuracy.

Lower values mean higher accuracy. Higher values are the least accurate.


<table>
  <thead>
    <tr>
        <th>LABEL</th>
        <th>POSITION DATA</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>EPU</td>
        <td>Estimated Position Uncertainty</td>
    </tr>
    <tr>
        <td>HDOP</td>
        <td>Horizontal Dilution of Precision</td>
    </tr>
    <tr>
        <td>HFOM</td>
        <td>Horizontal Figure of Merit</td>
    </tr>
    <tr>
        <td>VFOM</td>
        <td>Vertical Figure of Merit</td>
    </tr>
  </tbody>
</table>

EPU is the horizontal position error estimated by the fault detection and exclusion (FDE) algorithm, in feet or meters.

### ![Note Icon](page_104_image_2_v2.jpg) NOTE
> *Under 14 CFR parts 91, 121, 125, and 135, the FDE availability prediction program must be used prior to all oceanic or remote area flights using GPS 175/GNX 375/GNC 355 as a primary means of navigation.*

# Circle of Uncertainty

## FEATURE LIMITATIONS

* Available only when the aircraft is on ground
* Displays only on the Map page

Circle of Uncertainty

![Map view showing the Circle of Uncertainty around the aircraft icon](page_104_image_1_v2.jpg)

* Depicts area surrounding the ownship when GPS cannot accurately determine aircraft location
* Expands as GPS horizontal accuracy degrades
* Shrinks as accuracy improves
* Translucent with minor shading so as not to obstruct other features