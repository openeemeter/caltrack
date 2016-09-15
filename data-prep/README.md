
# CalTrack Beta Test Data Preparation Guidelines

Data Cleaning and Quality Checks for the CalTrack Beta Test will consist of three main tasks

1. Explore raw data sources with non-standard summary statistics
2. Perform data cleaning and integration procedures on raw data
3. Calculate and report prepared data summary statistics

=======



Data Cleaning and Munging
---

A number of cleaning steps are necessary to use the raw data.

* Deduplication

	- If a home appears multiple times within a project database, and the project dates are the same the most complete record for that home will be the record used in CalTRACK
	- If a home appears multiple times within a project database and the project dates differ because there are multiple measures installed associated with the same incentive program, the start date of the intervention will be the earliest of the project start dates across projects and the end date for the intervention will be the latest of the project end dates
	- There are a small number of duplicate traces – consumption traces with unique SAs (though identical SPIDs) and identical consumption data over the time interval.

* Creating Work Start and Work End dates from raw project data

The dates for CalTrack Beta Test come from the following Final CalTrack (AUH) files provided by Build it Green:

`CalTrack (AHU) from 1_1_14__6_30_15_v2_FINAL_090816.csv`
`CalTrack (AHU) from 7_1_15__6_30_16_v2_FINAL_090816.csv`
`CalTrack (AHUP) from 1_1_14__6_30_15_v2_FINAL_090816.csv`

The following rules are used for determining `work start dates` and `work end date` for every record.

`initial submission data` will be used as `work start date`
`initial submission date` will be used as `work end date`

For records where `initial application date` is missing, `work start date` will be imputed by calculating `initial sumbission date - 60 days`

For records where `initial submission date is missing, `work end date` will be imputed by calculating `initial application date + 60 days`

Missing Values & Imputation

Weather

- Hourly

    - Hourly weather data from GSOD will not be imputed

    - Days with more than 5 contiguous hours of missing data will be thrown out

- Daily

    - GSOD daily averages will not be imputed

    - Months with more than than 3 missing days will be thrown out

Usage

- Missing values where the cumulative value is in the following period, the cumulative number of days between the two periods will be used to generate the UPD for that period

- Missing usage values with no cumulative amount in the following period will be counted against data sufficiency requirements

- Homes with Net Metering will be dropped from the analysis

Estimated values & deletion

Estimated usage data will be used for estimation, but estimation flags will be added to the post-estimation

Estimated data will enter the same way missing cumulative values do (see above)

Extreme values

Usage

- Negative values or values with reverse direction of flow will be treated as missing and count against sufficiency criterion. The account will also be flag within CalTRACK for possible net metering if it does not currently contain a net metering flag

- It is assumed at all IOUs comply with DASMMD.

- AMI data will have the DASMMD pass/fail criterion rerun, with failing values coded as missing. ((highest peak - third highest peak)/third highest peak) <= 1.8

Project Data

- Extreme project lengths (gap between project start date and project end date longer than 3 months) will be treated as true and impact estimation only through data sufficiency requirements.

- Files without project start dates are thrown out

Sum Check

If both monthly and AMI data are available for a home, CalTRACK will run a sumcheck and use the DASMMD criterion for pass/fail. If it fails, the home is flagged and treated as having missing usage data so no estimation is run on it.

Miscoded values

Miscoded strings in project data will be deduplicated and matched (fuzzily) to closest value

Miscoded dates

- Implausible day values (>31) will be coded as the beginning of month if project start date and end of month if project end date so that the entire month included in the intervention window

- Implausible month and year values will be flagged and that home not included in estimation.

Data sufficiency

Usage (Monthly)

- 12 complete months pre-retrofit for monthly billing data to qualify for estimation or 24 months with up to 2 missing values from different, non-contiguous months

- Post retrofit data sufficiency for estimation will be dealt with in post-estimation model fit criterion

- Total annual savings estimates will require 12 months post-retrofit

- Do we include homes that have changed tenants

Usage (AMI)

- 12 months pre-retrofit

- Post retrofit data sufficiency for estimation will be dealt with in post-estimation model fit criterion

- Total annual savings estimates will require 12 months post-retrofit

Weather

- There should not be problems with data sufficiency for weather

Project or Home Characteristics

Exclude homes with PV for whom production data is not available

Value Adjustments (if values change during performance period)

Usage

- Use most up-to-date meter read for

- Log prior values and prior estimates

Project data

- Use most up to date values for estimation

Weather data

- Use most recent daily weather value for estimation

# Data Integration

- Matching project data
	- Matching will be done using the cross-reference files contain the sa_id and sp_id mapping between the project data id fields and the consumpution data id fields.

| Column Name | Description |
| --- | --- |
| sa_id | Corresponds to `Electric Service ID` or `Gas Service ID` in projects file |
| sp_id | Corresponds to `SPID` in electricity consumption file and `Service Point` in natural gas file |


- Matching weather stations to projects
	- Weather station mapping will be done using the 86 station standard mapping of zip code to CZ2010 weather files provided in the `/data-source` directory



- Unmatched data
	- Projects that are unmatched to usage data will be listed in CalTRACK for data integrity reporting, but will not be included in any estimation procedures and will not have estimated savings 


## Prepared Data Summary Statistics for Comparison


To ensure that beta testers are working with the same datasets and that we are characterizing the datasets in a way that is helpful for other members of the technical working group as well as the general public, each beta tester will generate a set of summary statistics and perform a set of data quality checks that can be shared with the larger group through csvs saved to this repository. There will be three cleaned data reports generated by each beta tester: a project data summary file, a monthly electic summary file, monthly gas summary file, hourly electric summary file, daily gas summary file, and data integration summary file. Each file will be a .csv and will have the following general format:

| Summary Stat | Value |
| --- | --- |
| Number of Observations | 4321 |
| Number of Fields | 4 |
| Min Work Start Date | Jan, 21, 2014 |
| Max Work Start Date| June 23, 2015| 

The specifics for each summary file are below:

### Prepared Project Data Summary File

**Output Filename: `project_data_summary_NAME_OF_TESTER.csv`**
 
#### Included Summary statistics

-  

### Prepared Project Data Summary File

**Output Filename: `project_data_summary_NAME_OF_TESTER.csv`**
 
#### Included Summary statistics

-  






