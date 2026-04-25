# DALT/TAS/Wind Calculator

![DALT / TAS / Winds icon](page_217_image_1_v2.jpg)

Calculate density altitude, true airspeed, and winds.

## FEATURE REQUIREMENTS

* *Fuel/air data computer (pressure altitude)*
* *Valid sensor data*

## DALT/TAS/Wind Page

```mermaid
graph TD
    Home --> Utilities
    Utilities --> DALT/TAS/Winds
```

This feature indicates the theoretical altitude at which the aircraft performs based on several input variables.

## Editing Input Data

Available selections are dependent on sensor data use. TAT and HDG may also be available via an external data source.

```mermaid
graph TD
    subgraph Default
    D1[Indicated ALT]
    D2[BARO]
    D3[CAS]
    D4[TAT]
    D5[HDG]
    D6[TRK]
    D7[Ground Speed]
    end

    subgraph Use Sensor Data Active
    S1[Pressure ALT]
    S2[BARO]
    S3[CAS]
    S4[TAT]
    S5[HDG]
    S6[TRK]
    S7[Ground Speed]
    end
```

Not Selectable ![Grey box indicating not selectable](page_217_image_6_v2.jpg)