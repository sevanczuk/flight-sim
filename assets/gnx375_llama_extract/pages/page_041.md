# Database Effective Cycles

Most databases expire at regular intervals. Exceptions include Basemap and Terrain, which neither expire nor update on a regular schedule.

![Screenshot of database status list showing Navigation, Basemap, OBST/Wire, SafeTaxi, and Terrain with cycle numbers and expiration dates.](page_41_image_2_v2.jpg)

![Screenshot showing database status with yellow text for "Database Not Found" and "Expired".](page_41_image_3_v2.jpg)

The start-up page lists all currently installed databases. Review this list for current database types, cycle numbers, and expiration dates.

Yellow text denotes when a database is:

* Not available
* Installed before its effective date
* Missing date information
* Past its expiration date

### DATABASE EFFECTIVE STATUS

**Databases with no effective date**

* Effective upon release
* Transfer occurs prior to database verification at system start-up
* No automatic transfer if Flight Stream 510 is present
* Includes Basemap and Terrain
* No pilot confirmation or restart required

**Databases with specified effective dates**

* Effective during a specific period
* Unit determines database status using the current date and time from GPS
* Automatic activation occurs on the effective date

### Overwriting SD card database files

When database files are loaded to the SD card, any previously loaded database files of the same type residing on the SD card will be overwritten. This includes loading a database of a different coverage area or data cycle than that currently residing on the SD card.