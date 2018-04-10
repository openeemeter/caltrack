# **Data Sources for CalTRACK Methods**

Three types of data files are required to run the CalTRACK methods: project data, energy consumption data, and weather data. These data must be linked with cross-reference files that define the mapping between ID columns in each of the data source types (Projects ID to Usage ID & Project ID to Weather Station ID).

This documentation is intended to provide general guidance on these three data sources for use in implementing CalTRACK methods.

## Project Data

While project data can be incredibly rich and incredibly varied, the CalTRACK methods aim to define a minimal set of data fields on projects necessary to perform CalTRACK analysis. Thankfully, this set is comparatively small. To perform CalTRACK analysis, you need to be able to uniquely identify a project, identify the location of the project, and the timing of the efficiency investment or intervention. We recommend your project data take on the general form:

<table>
  <tr>
    <td>Column Name</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>ProjectID</td>
    <td>A unique identifier for projects in the aggregator's database that can be used to link with additional project-specific information if desired</td>
  </tr>
  <tr>
    <td>Electric Account ID</td>
    <td>ID used for uniquely matching with electric consumption files</td>
  </tr>
  <tr>
    <td>Gas Account ID</td>
    <td>ID used for uniquely matching with gas consumption files</td>
  </tr>
  <tr>
    <td>Work Start Date</td>
    <td>Preferably the date actual work on the retrofit started, not the date that the application was made or approved</td>
  </tr>
  <tr>
    <td>Work End Date</td>
    <td>Preferably the date that actual work on the retrofit or intervention was finished, not the date that the reimbursement was filed or approved</td>
  </tr>
  <tr>
    <td>Building ZIP Code</td>
    <td>The minimal geographic identifier for matching a site to a weather station</td>
  </tr>
</table>


## Consumption Data

Consumption data for this project took the form of 15-minute and hourly electricity data and daily natural gas data. The raw files were provided by PG&E in a file format typically associated with the SAS statistical package (.XPT). You will need to find a parser that can output this data into the format that you need. Consider the unique date format associated with .XPT to make sure you are formatting your dates correctly. The following table reflects the data that were provided.

<table>
  <tr>
    <td>Column Name</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>SPID</td>
    <td>Service Point ID to be used to link to project records</td>
  </tr>
  <tr>
    <td>SA</td>
    <td>Account ID to be used to link to project records</td>
  </tr>
  <tr>
    <td>UOM</td>
    <td>Unit of Measurement (kWh or Therms)</td>
  </tr>
  <tr>
    <td>DIR</td>
    <td>Used for Net Metering. R indicates presence of solar production</td>
  </tr>
  <tr>
    <td>DATE</td>
    <td>Date of usage readings</td>
  </tr>
  <tr>
    <td>RS</td>
    <td>Rate code classification. Also useful for indicating presence of solar production and other DR programs.</td>
  </tr>
  <tr>
    <td>Usage Columns</td>
    <td>Total usage for time period specified measured in total consumption for the time interval preceding the column header</td>
  </tr>
</table>


## Cross-reference files

Both *electric and gas* cross-reference files contain the same columns of interest. These files were used to obtain a mapping between project files and consumption files.

<table>
  <tr>
    <td>Column Name</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>Project ID</td>
    <td>A unique identifier for projects in the aggregators project database.</td>
  </tr>
  <tr>
    <td>Usage Record ID</td>
    <td>This typically corresponds to a meter ID, account ID, or service point ID used to uniquely identify a usage trace with a customer in the utility's usage database. There are often separate IDs for gas and electric</td>
  </tr>
  <tr>
    <td>Premise ID</td>
    <td>(Optional) This typically corresponds to a unique premise can be necessary for combining multiple usage records into a single premise-level record in the event that households have multiple meters for one fuel type, or usage IDs change when the same customer enters into a new service agreement with the utility</td>
  </tr>
</table>


## Weather

Both actual observed weather data and normal year weather data are used in the CalTRACK analysis. The appropriate observed weather and normal year weather for each project are determined using the site’s ZIP code, which is mapped to weather stations using [the mapping file](https://github.com/caltrack-2/caltrack/tree/master/resources/weather), which has five fields for each ZIP code in California:

<table>
  <tr>
    <td>ZipCode</td>
    <td>5-digit ZIP code for the project site</td>
  </tr>
  <tr>
    <td>ClimateZone</td>
    <td>The climate zone number; not used.</td>
  </tr>
  <tr>
    <td>WeatherFile</td>
    <td>The file name for the CZ2010 normal year temperatues</td>
  </tr>
  <tr>
    <td>WthrStationNum</td>
    <td>The weather station identifier in the ISD data set.</td>
  </tr>
  <tr>
    <td>IsValid</td>
    <td>1 for valid, 0 for invalid.</td>
  </tr>
</table>

The preferred method for assigning a site's weather station is to choose the closest proximity weather station that belongs to the site's climate zone. If data sufficiency requirements are not met by the first choice weather station, a secondary weather station that fulfills data sufficiency requirements can be assigned strictly by closest proximity without accounting for climate zone. 

Once the appropriate WthrStationNum is identified, the observed temperatures can be downloaded from the ISD data set at ftp.ncdc.noaa.gov/pub/data/noaa/, in the format described [here](https://www1.ncdc.noaa.gov/pub/data/ish/ish-format-document.pdf). Two fields on each line of the relevant weather station’s file are used: the date/time (YYYYmmddHHMM, from characters 16-27) and the hourly dry bulb temperature in degrees Celsius (characters 88-92). 

The available hourly temperatures for each day (where day is defined by dropping the HHMM fields from the date/time field) are averaged together and converted to degrees Fahrenheit to produce the daily temperature, which is then used to calculate heating and cooling degree days. Missing data points are ignored as long as at least one hourly temperature reading for a given day is available. 

Normal year temperatures are determined using the CZ2010 files available [here](https://github.com/caltrack-2/caltrack/tree/master/resources/weather); the particular file for each ZIP code is identified by the WeatherFile field in the mapping file described above. Again, the only relevant columns are Date (MM/DD/YYYY),Time (HH:MM), and Dry-bulb (C), where the year is ignored. The normal year temperatures are averaged over days as with the ISD observed temperature data.

