
Based on the provided image and OCR content, here is a corrected and complete transcription of the page.

----

**Navigation**

# Parallel Track

Create a parallel course offset relative to the current flight plan. Setup controls provide offset distance and direction setting (left of track or right of track).

## FEATURE REQUIREMENTS
- Active flight plan

## FEATURE LIMITATIONS
- Function not available when Direct-to is active
- Graphical editing of the active leg cancels the parallel track function
- Offset range: 1 nm to 99 nm
- Large offset values combined with certain leg types (e.g., approach) or leg geometries (i.e., changes in track >120°) do not support parallel track

| TRACK    | COLOR   |
| -------- | ------- |
| Offset   | Magenta |
| Original | Gray    |


Once activated, a new track line appears to the left or right of the original course line at the specified distance. The aircraft navigates to the offset track with external CDI/HSI guidance now driven from the parallel track.

A graphical depiction overlays on the map.

**Map**

Corresponding fix symbols on the flight plan indicate when the active leg is on a parallel track.

**GPS 175 & GNX 375:**
Active route identifiers also appear on the **GPS NAV Status** indicator key in the lower right corner of the display.

**GNC 355/355A:**
If configured, a user field shows active route identifiers on Map.

190-02488-01 Rev. C Pilot's Guide 3-37
