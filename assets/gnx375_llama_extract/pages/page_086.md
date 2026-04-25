# Pilot Settings

```mermaid
graph TD
    System[System] --- Setup
    System --- PageShortcuts[Page Shortcuts]
    System --- AirspaceAlerts[Airspace Alerts]
    System --- Units
    System --- Backlight
    System --- ConnextSetup[Connext Setup]

    Setup --- CDIScale[CDI Scale]
    Setup --- CDIOnScreen[CDI On Screen <sup>3</sup>]
    Setup --- AirportRunwayCriteria[Airport Runway Criteria]
    Setup --- DateTime[Date/Time]
    Setup --- ReverseFrequencyLookup[Reverse Frequency Look-up <sup>1</sup>]
    Setup --- SidetoneVolume[Sidetone Volume <sup>1</sup>]
    Setup --- ChannelSpacing[Channel Spacing <sup>2</sup>]
    Setup --- Crossfill

    ConnextSetup --- DeviceName[Device Name]
    ConnextSetup --- PairedDevices[Paired Devices]
    ConnextSetup --- BluetoothEnabled[Bluetooth Enabled]
    ConnextSetup --- FlightPlanImport[Flight Plan Import]

    Utilities[Utilities] --- ClockTimers[Clock/Timers]
    Utilities --- ScheduledMessages[Scheduled Messages]
```

Unit customization options allow you to:

* Set the CDI scale
* Display the CDI on-screen<sup>3</sup>
* Specify runway criteria
* Set the date and time
* Specify COM radio settings <sup>1</sup>
* Create shortcuts
* Set the display units
* Adjust display brightness

Other setup options allow you to monitor time in flight and create custom reminder messages. These settings reside in the System Utilities.

For details about COM radio settings and Connext Setup options, refer to the respective section.

<sup>1</sup> GNC 355/355A only.
<sup>2</sup> GNC 355A only.
<sup>3</sup> GPS 175 and GNX 375 only.