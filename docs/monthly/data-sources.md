
# Data Sources 


Two major types of data files required to run the CalTRACK Methods: project data and consumption data. This data is linked with "cross-reference" files that define the mapping between ID columns in the two types of files.

Consumption data is further broken down into five file types: 15 minutely electricity, hourly electricity, daily natural gas, monthly electricity, and monthly natural gas.

The columns of interest are as follows:

**Project **

| Column Name | Description |
| --- | --- |
| Application No. | Project identifier |
| Electric Service ID | ID used for matching with consumption files |
| Gas Service ID |  ID used for matching with consumption files |
| Full Application Submitted | Best proxy date for "Work Finished" |
| Full Application Returned | If populated, the project got returned for correction. |
| Work Start Date | Date retrofit started, *always empty* |
| Work Finish Date | Date retrofit ended, *always empty* |
| Building ZIP Code | |

**Consumption**

_Electricity_

| Column Name | Description |
| --- | --- |
| SPID | Service Point ID - identifies the physical meter |
| SA |  Service Agreement ID - generated when a customer signs a service agreement. Can be many SAs for a single SPID. Corresponds to `Electric Service ID` in project files. |
| UOM | Unit of Measure (KWH or THERM) |
| DIR | Direction of electricity flow (D=delivered, R=received) |
| DATE | Day for this row of consumption data |
| RS | Rate schedule of the associated SA_ID (ignored) |
| APCT | The actual percent of intervals are “Good” vs “Estimated”. (ignored) |
| NAICS | Associated with activity at the premise, only for non-residential (ignored) |
| 00:15, etc | Consumption data for that interval |

There may be rows with non-zero consumption in both the R and D direction at the same timestamp (e.g. the customer both consumed power from the grid and delivered power back to the grid over the time interval).

_Natural Gas_

| Column Name | Description |
| --- | --- |
| Service Point | Service Point ID - identifies the physical meter. Corresponds to `sp_id` in cross-reference table. |
| Measurement Date | |
| Therms per day | |

**Monthly Consumption**

_Electricity_

| Column Name | Description |
| --- | --- |
| SA_ID | Service Agreement ID for cross-reference |
| CDT__`i` (`i` [1,12]) | Current date the meter was read in SAS format|
| PDT__`i` (`i` [1,12]) | Previous date the meter was read |
| KWH__`i` (`i` [1,12]) | Usage (KWH) |

SAS formatted dates count the number of days since Jan 1, 1960.

_Natural Gas_

| Column Name | Description |
| --- | --- |
| SA_ID | Service Agreement ID for cross-reference |
| CDT__`i` (`i` [1,12]) | Current date the meter was read in SAS format |
| PDT__`i` (`i` [1,12]) | Previous date the meter was read |
| THM__`i` (`i` [1,12]) | Usage (THM) |

See notes for monthly electricity consumption above for further details.


**Cross-reference**

Both types of cross-reference files contain the same columns of interest.

| Column Name | Description |
| --- | --- |
| sa_id | Corresponds to `Electric Service ID` or `Gas Service ID` in projects file |
| sp_id | Corresponds to `SPID` in electricity consumption file and `Service Point` in natural gas file |


### Weather
There are three weather source files necessary for the CalTRACK Methods.

1. [CZ2010 weather normals for 86 stations in California](http://www.CalTRACK.org/weather.html)
2. [Mapping of zip codes to weather stations](https://raw.githubusercontent.com/impactlab/caltrack/master/data-sources/weather/ZipCodetoCZ2010WeatherStationMap.csv)
3. [Hourly weather station data pulled from the NOAA ISD weather data using USAF](http://www.ncdc.noaa.gov/cdo-web/)
