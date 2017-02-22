
# Data Sources for CalTRACK Monthly Methods


Three types of data files are required to run the CalTRACK monthly methods: project data, energy consumption data, and weather data. These data must be linked with cross-reference files that define the mapping between ID columns in each of the data source types (Projects ID to Usage ID & Project ID to Weather Station ID).

This documentation is intended to provide general guidance on these three data sources for use in implementing CalTRACK methods. You can find a more detailed description of the specific project, usage, weather, and cross-reference files used in CalTRACK methods testing [here](https://github.com/impactlab/caltrack/tree/master/tests/data-sources)

**Project Data**

While project data can be incredibly rich and incredibly varied, the CalTRACK methods aim to define a minimal set of data fields on projects necessary to perform CalTRACK analysis. Thankfully, this set is comparatively small. To perform CalTRACK analysis, you need to be able to uniquely identify a project, identify the location of the project, and the timing of the efficiency investment or intervention We recommend your project data take on the general form:

| Column Name | Description |
| --- | --- |
| ProjectID | A unique identifier for projects in the aggregator's database that can be used to link with additional project-specific information if desired|
| Electric Account ID | ID used for uniquely matching with electric consumption files|
| Gas Account ID |  ID used for uniquely matching with gas consumption files |
| Work Start Date | Preferably the date actual work on the retrofit started, not the date that the application was made or approved|
| Work Finish Date | Preferably the date that actual work on the retrofit or intervention, not the date that the reimbursement was filed or approved|
| Building ZIP Code | The minimal geographic identifier for matching a site to a weather station |

**Consumption**

While consumption data comes in a variety of frequencies (15 minute, Hourly, Daily, or Billing Period) and formats depending on the utility, the CalTRACK v1 monthly methods are only for monthly billing data, which typically, but not always, represents cumulative usage over periods of around month in length. The ideal consumption data file will have the following minimal fields:

**Monthly Consumption**

_Electricity_

| Column Name | Description |
| --- | --- |
| Account ID | Unique ID for the customer that is also included in the cross-reference file for linking to projects |
| Current meter read or billing date | Current date the meter was read format|
| Past meter read or billing date | Previous date the meter was read |
| KWH  | Total Usage (KWH) for the period spanning the two meter read dates in the row |
| Estimated Flag | A flag for indicating whether the KHW value was an estimated value or actual meter read|


_Natural Gas_

| Column Name | Description |
| --- | --- |
| Account ID | Unique ID for the customer that is also included in the cross-reference file for linking to projects |
| Current meter read or billing date | Current date the meter was read format|
| Past meter read or billing date | Previous date the meter was read |
| THM  | Total Usage (Therms) for the period spanning the two meter read dates in the row |
| Estimated Flag | A flag for indicating whether the THM value was an estimated value or actual meter read|


Consumption files can, as was the case for the CalTRACK test data, also be formatted as cumulative values over the course of the year and require differencinfg between periods in order to create the dataset required for CalTRACK data-prep.


**Cross-reference files**

Both types of cross-reference files contain the same columns of interest.

| Column Name | Description |
| --- | --- |
| Project ID | A unique identifier for projects in the aggregators project database.  |
| Usage Record ID | This typically corresponds to a meter ID, account ID, or service point ID used to uniquely identify a usage trace with a customer in the utility's usage database. There are often separate IDs for gas and electric |
| Premise ID | (Optional) This typically corresponds to a unique premise can can be necessary for combining multiple usage records into a since premise-level record in the event that households have multiple meters for one fuel type, or usage IDs change when the same customer enters into a new service agreement with the utility |


### Weather
There are three weather source files necessary for the CalTRACK v1 Monthly Methods.

1. [CZ2010 weather normals for 86 stations in California](http://www.CalTRACK.org/weather.html)

While the TMY3 temperature normals are more commonly used in industry, for regulatory reasons, the CZ2010 dataset needs to be use for CalTRACK. This was a dataset developed for the CEC by White Box consulting.

2. [Mapping of zip codes to weather stations provided by the CEC as the canonical weather station mapping for California](https://raw.githubusercontent.com/impactlab/caltrack/master/tests/data-sources/weather/stationmapping_v2.csv)
This mapping was generated by White Box consulting for the CEC and was augmented my the team at DNV-GL to ensure coverage for missing zip codes.

3. [Daily Average Temperature Data taken from the Quality Controlled Local Climatological Data provided by NOAA](https://www.ncdc.noaa.gov/data-access/land-based-station-data/land-based-datasets/quality-controlled-local-climatological-data-qclcd)
This dataset consists of over 40 fields, but all the relevant fields for CalTRACK methods are in the first 8 fields.

WBAN|YearMonthDay|Tmax|TmaxFlag|Tmin|TminFlag|Tavg|TavgFlag|

For the purpose of CalTRACK analysis, we use the `Tavg` field to calculate average HDD and CDD for billing periods using a fixed degree day base. This is outlined in detail in the `data-prep` guidelines.

While there is a web-based data extraction tool, we recommend using their [FTP site](https://www.ncdc.noaa.gov/orders/qclcd/) for bulk download of the weather data by month. The relevant file used for CalTRACK is the `YYYYMMdaily.txt` file.
