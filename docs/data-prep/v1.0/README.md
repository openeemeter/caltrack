Data Preparation for CalTRACK Methods
===
CalTRACK employs the following processes when preparing weather, project, and daily/hourly/monthly consumption data for performing the analysis specified in the CalTRACK v1.0 methods.

Overview
---
Below are guidelines and a general process for addressing the most common issues that arise during data cleaning efforts for analysis. It is recommended to conduct these steps in the order they appear because the final combined dataset is highly sensitive to the order of data preparation steps.

Guidelines on Project Data Preparation
---
The minimum field requirements for project data under the CalTRACK daily specification are outlined [here](https://github.com/impactlab/caltrack/tree/master/docs/data-sources/v1.0). Notably, a prepared project file should consist of one row per project, with a unique ID that can be used to link to gas and/or electric usage data, project start and stop dates, and zip code for the site.

The following data cleaning steps for project data are meant to ensure that the prepared project file meets these field requirements and uniqueness constraints.

### Creating Work Start and Work End dates from raw project data

Accurately identifying baseline and reporting periods is important for reducing the modeling error associated with a savings calculation. However, considerable variation may occur in database records identifying dates associated with project start and project completion. In general, users should try to identify the fields in a project record that most closely match the actual work start and work completion dates. In the absence of either of these fields (that is, if a project record only contains one or the other set of dates), it is recommended that users identify an average time to completion. CalTRACK implementations should use official work start date and work end date fields provided by aggregators rather than proxy fields when available.

### Dealing with miscoded dates

Implausible day values (>31) should be coded as the beginning of month if project start date and end of month if project end date so that the entire month is included in the intervention window. Implausible month and year values should be flagged and corrected or removed from the analysis.

### Deduplicate project records

If a building appears multiple times within a project database, and the project dates are the same, the most complete record for that building should be used. If a building appears multiple times within a project database and the project dates differ because there are multiple measures installed associated with the same incentive program, the start date of the intervention should be the earliest of the project start dates across projects and the end date for the intervention should be the latest of the project end dates.

Guidelines on Weather Data Preparation
---
Weather data is obtained from ftp.ncdc.noaa.gov for the NOAA weather station nearest each project site, however for California see section 4 below (use CZ 2010). Hourly ISD temperature readings are deduplicated, keeping the first reading for each hour, and then averaged for each day in the baseline, project, and reporting periods. Similarly, daily average TMY3 temperatures are used to characterize the normal year weather for each site. Daily averages are not subject to any minimum number of hourly readings per day. 

Hourly weather values correspond to the hour of their timestamp, not the previous hours’ weather.

Guidelines on Daily Electric and Gas Usage Preparation
---
Generally, the quality of your consumption data may vary substantially from sample to sample. You will need to clean your data so that it meets the following requirements:

1. Traces are clearly marked for interval frequency (e.g., 15-minute, hour, day)
2. Traces are clearly marked for direction (reverse if net-metered and net solar production is higher than gross consumption).
3. Where available, the presence of net-metering is clearly marked (CalTRACK excludes homes that are net-metered)
4. Traces are not duplicated in whole or in part

The dataset generated for the CalTRACK beta test originated from a pool of projects and consumption data provided by PG&E (see [Data Sources](https://github.com/impactlab/caltrack/tree/master/docs/data-sources/v1.0)). A smaller set of 1000 natural gas meters and 1000 electricity meters were selected from this larger pool for the purposes of testing. These meters were selected based on location (attempting to maximize coverage over each of the climate zones) and data sufficiency (each meter contains at least two years of historical usage data prior to the intervention period). 

### Roll up sub-daily interval data to daily totals

If using sub-daily interval data (hourly, 15-minute, etc intervals), roll it up to daily totals following this procedure:
* Check to make sure at least 50% of the intervals in the day have usage data.  For electricity, usage values of 0 should count as missing (for gas a usage value of 0 is valid and does not indicate missing data).  If more than 50% of the interval data is missing drop this day from the analysis.
* Calculate total daily usage: multiply the average usage for all intervals in the day by the number of intervals (i.e. for hourly data, 24 * average hourly usage)

### Link project records and usage files

Once project, consumption, and weather data have met all of their respective requirements, the data must be matched in order for a savings estimation to be performed. CalTRACK recommends using a key such as a utility account number that will clearly match a given project with a given meter. However, we also recognize that in certain cases, a project may encompass more than one meter or utility account. In these cases, CalTRACK does not offer specific guidance.

Unmatched data should be excluded from analysis.

### Deduplicate records based on combined attributes

* If two duplicate records have identical consumption traces and date ranges, drop one at random
* If two duplicate records have identical consumption traces but different date ranges, prioritize the record that overlaps the baseline period in its entirety and encompasses a greater portion of the reporting period. 
* If the dates are contiguous, or there are overlapping dates with the same usage values, combine the two traces into a single trace.
* If the records have the same date ranges, but different usage values, the project should be flagged and the record excluded from the sample.

### Drop records not meeting data sufficiency requirements

* 12 months consumption data prior to the date of the intervention recommended for all projects.
* Data is considered sufficient when it contains usage data for 90% of coverage period.
* 12 months consumption data after the date of the intervention is recommended for all projects. 
* Data is considered missing if it is clearly marked as NaN or similar by the data provider.
* Consumption records marked as “estimated” are rare when parsing AMI data, but if any should appear they should be discarded.

### Drop project records with unsupported characteristics

* Drop homes with known PV or EV added 12 months prior to or up to 12 months after the intervention. During the CalTRACK beta test, these homes were identified from the presence of reverse flow in the AMI data and/or indications of net metering in the cross reference tables. 
* Future efforts may provide the ability to access sub-meter data that may allow for backing out onsite generation and storage to arrive at savings.

Guidelines for Monthly Electric and Gas Usage Preparation
---
### Dealing with missing values in monthly usage data

Usage data generally undergoes significant cleaning prior to release to program administrators or the general public. There are generally three types of missing usage data. First, monthly billing data will be populated with “estimated” reads, when the utility has imputed a likely consumption amount for the month for the purposes of billing, but has not actually recorded a meter reading. Second, there are gaps in AMI meter data, where there may have been a hardware failure or another similar type of infrastructure breakdown where the data was not recorded. Finally, there is the issue of data that goes missing in the process of transferring to program evaluators (in the CalTrack Beta test, two of the zip files holding monthly billing data were corrupted and unreadable). Each of these issues represents a unique challenge and must be dealt with independently.

* For the case of missing values where the cumulative value is in the following period (as in an estimated read), the cumulative number of days between the two periods will be used to generate the use per day for that period.
* Missing usage values with no cumulative amount in the following period (such as missing AMI data) will be counted against data sufficiency requirements.
* CalTRACK does not offer firm guidance on auditing data sets for completeness, however, a data audit was conducted for the purposes of the Beta test and was found to have identified several missing data issues that would not have otherwise been identified. Thus, a data audit is generally recommended.
* If flags exist for estimated values, they are counted as missing and count against the site’s data sufficiency criteria detailed later in this guidance.

### Dealing with extreme values in usage data

Occasionally, the project or consumption data may contain extreme values that are likely the result of a data error, but may also be an indicator of another factor (such as the presence of solar panels) and should be handled based on the following guidance:

* Negative values for monthly use should be treated as missing and count against sufficiency criterion. Negative values in monthly data may also be a valid sign of possible solar/net metering and should be flagged for verification.

### Deduplicate records based on combined attributes

* If two duplicate records have identical consumption traces and date ranges, drop one at random.
* If two duplicate records have identical consumption traces but different date ranges select the more complete record having more dates. If the dates are contiguous, or there are overlapping dates with the same usage values, combine the two traces into a single trace.
* If the records have the same date ranges, but different usage values, the project should be flagged and the record excluded from the sample.

### Drop records not meeting data sufficiency requirements

Calculating energy efficiency savings requires a sufficient observation period of energy usage prior to and after an intervention. Generally, annualized models require at least 12 months of usage data on each side of an intervention in order to accurately calculate energy savings. Some models may be able to calculate energy savings with fewer than 12 months of data in the reporting period.

* 12 complete months pre-retrofit for monthly billing data to qualify for estimation or 24 months with up to 2 missing values from different, non-contiguous months.
* Total annual savings estimates will require 12 months post-retrofit.

### Drop project records with unsupported characteristics

* Drop homes with known PV or EV added 12 months prior to or up to 12 months after the intervention. During the CalTRACK beta test, these homes were identified from the presence of reverse flow in the AMI data and/or indications of net metering in the cross reference tables. However, if you only have access to billing data, CalTRACK recommends working with the utility to get flags for accounts that have net metering present so they can be excluded from the analysis.
* Future efforts may provide the ability to access sub-meter data that may allow for backing out onsite generation and storage to arrive at savings.

Guidelines for Linking Project and Usage Files
---
Once project, consumption, and weather data have met all of their respective requirements, the data must be matched in order for a savings estimation to be performed. CalTRACK recommends using a key such as a utility account number that will clearly match a given project with a given meter. However, we also recognize that in certain cases, a project may encompass more than one meter or utility account. In these cases, CalTRACK does not offer specific guidance.

Unmatched data should be excluded from analysis.

Guidelines for Linking Weather Data and Project Records
---
Weather station mapping requires locating the station nearest to the project. Each project file should contain a zip code that allows matching weather stations to projects
* For California, weather station mapping was done using the 86 station standard mapping of zip code to CZ2010 weather files. Clean versions of these files can be found [here](https://github.com/impactlab/caltrack/tree/master/resources/weather).

Guidelines for Final Combined Data Sufficiency Checks
---
It is recommended that you run a final audit of your data to evaluate the outputs of the data cleaning process. You should be able to match the number of projects eliminated from your analysis at each step listed above. Your final audit will also serve as a useful reference for further data analysis and aggregation.

* Billing periods (the period between bill start date and bill end date in the monthly usage data) with more than 10% missing days of weather data will be thrown out and count against the required number of billing period observations.
* Any projects with fewer than 12 months pre and 12 months post are not included in the analysis.

Detailed Data Preparation Instructions
===
What follows in an example of data prep steps that could be used to create files for analysis. These steps are one example implementation of the guidelines laid out above.

Overall, 3 types of files are generated during this process for use in the CalTRACK methods:
1. Project data
2. Trace data
3. Project to Trace mappings

The Project Data file should have the following fields:
1. *project_id*: A unique identifier for the project (should occur once in the file).
2. *zipcode*: Used for linking weather data for the project.
3. *baseline_period_end*: Date the project started - usage data prior to this is used to establish a baseline.
4. *reporting_period_start*: Date the project ended. Usage after this is used to determine savings against the baseline.

Trace Data files should have the following fields:
1. *trace_id*: A unique identifier for the trace (can occur more than once in the file to identify individual trace records).
2. *unit*: Unit of measurement for the trace record (“KWH” or “THERM”).
3. *estimated*: Whether this is an estimated reading (“True” or “False”).
4. *interpretation*: For purposes of this data, one of the following is always used:
    1. ELECTRICITY_CONSUMPTION_SUPPLIED - Represents the amount of utility-supplied electrical energy consumed on-site, as metered at a single usage point, such as a utility-owned electricity meter. Specifically does not include consumption of electricity generated on site, such as by locally installed solar photovoltaic panels.
    2. ELECTRICITY_ON_SITE_GENERATION_UNCONSUMED - Represents the amount of excess locally generated energy, which instead of being consumed on-site, is fed back into the grid or sold back a utility.
    3. NATURAL_GAS_CONSUMPTION_SUPPLIED - Represents the amount of energy supplied by a utility in the form of natural gas and used on site, as metered at a single usage point.
5. *start*: Starting date time for the trace record.
6. *value*: Value of the trace record (i.e. number of KWH/THERM)

Project to Trace mapping files contain just two fields:
1. *project_id*
2. *trace_id*

A fourth type of file containing weather data is also used, but is not generated by the data prep process - weather data is described in greater detail in the **Link weather data and project records** section below.

The CalTRACK data preparations guidelines for daily analysis consist of the following steps:
1. Cross Reference File Preparation
2. Project Data Preparation
3. 15 Minute Electric Use Preparation
4. Hourly Electric Use Preparation
5. Monthly Electric Use Preparation
6. Daily Gas Use Preparation
7. Monthly Gas Use Preparation
8. Linking Projects to Usage/Trace Data

File List
---
Cross Reference Files
1. EES25162_ELECINTV_XREF_CPUC.csv (Electricity Cross Reference)
2. EES25162_GASINTV_XREF_CPUC.csv (Gas Cross Reference 1 of 2)
3. EES25162_GASINTV2_XREF_CPUC.csv (Gas Cross Reference 2 of 2)

Project Files
1. CalTrack (AHU) from 1_1_14__6_30_15_v2_FINAL_090816.csv
2. CalTrack (AHU) from 7_1_15__6_30_16_v2_FINAL_090816.csv
3. CalTrack (AHUP) from 1_1_14__6_30_15_v2_FINAL_090816.csv

Usage Files
1. IDA.15MIN.SMY1.EES25162-EHUP.20160719161716.csv (15 minute electricity)
2. EES25162_gasdy_160720.csv (daily gas 1 of 2)
3. EES25162_gasdy_160920.csv (daily gas 2 of 2)
4. IDA.60MIN.SMY1.EES25162-EHUP.20160719161716.csv (hourly electricity)
5. EES25162.ERESBL12 (1).XPT (monthly electricity 1 of 4)
6. EES25162.ERESBL13.XPT (monthly electricity 2 of 4)
7. EES25162.ERESBL15.XPT (monthly electricity 3 of 4)
8. EES25162.ERESBL16.XPT (monthly electricity 4 of 4)
9. EES25162.G2RSBL12.XPT (monthly gas 1 of 11)
10. EES25162.G2RSBL13.XPT (monthly gas 2 of 11)
11. EES25162.G2RSBL14.XPT (monthly gas 3 of 11)
12. EES25162.G2RSBL15.XPT (monthly gas 4 of 11)
13. EES25162.G2RSBL16.XPT (monthly gas 5 of 11)
14. EES25162.GRESBL12.XPT (monthly gas 6 of 11)
15. EES25162.GRESBL13.XPT (monthly gas 7 of 11)
16. EES25162.GRESBL14.XPT (monthly gas 8 of 11)
17. EES25162.GRESBL15.XPT (monthly gas 9 of 11)
18. EES25162.GRESBL16.JANJUNE.XPT (monthly gas 10 of 11)
19. EES25162.GRESBL16.XPT (monthly gas 11 of 11)

Cross Reference File preparation
---
A series of cross reference files are provided that can be used to link projects to usage information. These are:
1. EES25162_ELECINTV_XREF_CPUC.csv (Electricity Cross Reference)
2. EES25162_GASINTV_XREF_CPUC.csv (Gas Cross Reference 1 of 2)
3. EES25162_GASINTV2_XREF_CPUC.csv (Gas Cross Reference 2 of 2)

It is recommended that cross reference (or “xref”) files be prepared first since they contain information that will be useful in formatting the project and usage data in later steps.

Also required for this cleaning step will be the following:
1. IDA.15MIN.SMY1.EES25162-EHUP.20160719161716.csv (15 minute electricity)
2. IDA.60MIN.SMY1.EES25162-EHUP.20160719161716.csv (hourly electricity)

With the electricity cross reference file, perform the following:
1. Obtain all net metered Service Account Ids from the 15 minute file electricity file.
    a. In the 15 minute and hourly electricity data, any record where *DIR* is *R* is net metered.
2. Obtain all net metered SA ids from the hourly electricity file, combine with those found in step 1.
3. Left pad with zeroes (or zfill) to 10 all *char_prem_id*s.
4. Using the Electricity Cross Reference file, build a map of *sa_id* to *char_prem_id*.
5. Using a combination of the Electricity Cross Reference file, the net metered SA id set from steps 1 and 2, and the map from 4, add the *is_net_metered* column to the Electricity Cross Reference file.
    a. Any row in the file that has *net_mtr_ind* set to *Y* is net metered
    b. Any row that has an *sa_id* in the set from steps 1 and 2 is net metered
5. Build a map of *sa_id* to *char_prem_id*.
6. Build a map of *sp_id* to *char_prem_id*.

Your Electricity Cross Reference file now has what is needed. In future steps, the map from step 5 will be used to help map projects, and any project that is net metered should be excluded from analysis.

Upon completion, your finalized Electricity Cross Reference file should contain 8004 records (not including header).

With the gas cross reference file, perform the following:
1. Combine the two files into a single CSV.
2. Left pad with zeroes (or zfill) the *char_prem_id*s.
3. Build a map of *sa_id* to *char_prem_id*.
4. Build a map of *sp_id* to *char_prem_id*.

You now have a single Gas Cross Reference file. In future steps, the map from step 3 will be used to help map projects, while the map in step 4 will be used to help map traces.

Upon completion, your finalized Gas Cross Reference file should contain 6928 records (not including header).

Project data preparation
---
In the beta test data, the following files were provided containing project information:
1. CalTrack (AHU) from 1_1_14__6_30_15_v2_FINAL_090816.csv
2. CalTrack (AHU) from 7_1_15__6_30_16_v2_FINAL_090816.csv
3. CalTrack (AHUP) from 1_1_14__6_30_15_v2_FINAL_090816.csv

You’ll also be using the *sa_id* to *char_prem_id* maps you created from the Electric and Gas Cross Reference Files in the **Cross Reference File Preparation** section above.

Perform the following:
1. Combine the 3 project files into a single file.
    a. The *CalTrack (AHUP) from 1_1_14__6_30_15_v2_FINAL_090816.csv* file has a column called *Application: Application No.* instead of simply *Application No.* like the other two files - the column should be treated the same when combining the files.
2. Estimate project dates using the combined file - each project should have a *Work Start Date* and a *Work Finish Date*.
    1. For each row, check if the *Notice to Proceed Issued* column is blank.
        1. If it is, this is a project from one of the AHU files. Set the *Work Start Date* to the *Initial Approval Date* and the *Work Finish Date* to the *Initial Submission Date*.
        2. If it is not, this is a project from the AHUP file. Set the *Work Start Date* to the *Notice to Proceed Issued*.
            1. If the *Full Application Returned* field is blank, set the *Work Finish Date* to *Full Application Submitted*.
            2. Otherwise set *Work Finish Date* to *Full Application Started*.
    2. If after completing step 2a above your *Work Finish Date* is still blank and your *Work Start Date* is not, set the *Work Finish Date* to 60 days after the *Work Start Date*.
3. Using the *sa_id* to *char_prem_id* maps you saved from **Cross Reference File Preparation**, add a *char_prem_id* column to your combined project file.
    1. For each row, check *Electric Service ID* against the *sa_id* in your electric map.
    2. For each row, check *Gas Service ID* against the *sa_id* in your gas map.
4. Merge duplicate projects into one project.
    1. There should only be one project per *char_prem_id*. Build a dictionary with *char_prem_id* as the key and a list of projects as the value.
    2. If there is more than one project for a *char_prem_id*, merge the projects.
        1. Set *Work Start Date* to the earliest available.
        2. Set *Work Finish Date* to the latest available.
5. Build a map of *char_prem_id* to *Application No.* for later use in mapping projects to traces.
6. Translate the file into the format required. If using the format laid out in **Overview**, map the following:
    1. *project_id* -> Application No.
    2. *zipcode* -> Building ZIP Code
    3. *baseline_period_end* -> Work Start Date
    4. reporting_period_start -> Work Finish Date

Upon completion you should have 4206 projects.

15 Minute Electric Use Preparation
---
The following file is cleaned and formatted in this section:
1. IDA.15MIN.SMY1.EES25162-EHUP.20160719161716.csv (15 minute electricity)

In this section we’ll also begin building a dictionary of projects to traces. This will be added to by subsequent usage data preparation steps.

Perform the following:
1. Adjust the dates in the *DATE* column to *yyyy-MM-dd* format for sorting purposes.
2. Sort the file by *DIR*, then *SPID*, then *DATE*.
3. Remove duplicate records.
    1. Since the file is now sorted, compare the previous row's *DATE* and *SPID*. If they are the same, check each of the interval columns. If all match, throw out one of the records. 566 duplicates should be removed this way across 163 unique SPIDs.
4. Format trace records.
    1. *trace_id* -> `elec-15min-[SA]-[SPID]-[DIR]`
    2. If *DIR* is *D*, the *interpretation* is *ELECTRICITY_CONSUMPTION_SUPPLIED*. If *R*, it is *ELECTRICITY_ON_SITE_GENERATION_UNCONSUMED*.
    3. *estimated* -> False
    4. *unit* -> KWH
    5. For *start*, it is necessary to unroll each trace in the file into a separate line/record per interval column. i.e. `00:15,00:30,00:45 ... 24:00` become separate lines with start of `DATE + 00:15, DATE + 00:30, etc.`
    6. For *value*, assign the value of the column in step 4.5.
    7. Using the map created in electricity step 6 of **Cross Reference File Preparation**, check the *SPID* to get a *char_prem_id*. Check the *char_prem_id* against the map you created in step 5 of **Project File Preparation** above. Using the project id (or *Application No.*) as the dictionary key with a list as the value, add the trace id from step a above to that list. You’ll be continuing to build this as you perform additional steps.

This step should yield 19,355,328 trace records and 400 traces.

Optionally, between step 3 and 4 you could split the file into multiple CSVs to make the files easier to work with.

Hourly Electric Use Preparation
---
The following file is cleaned and formatted in this section:
1. IDA.60MIN.SMY1.EES25162-EHUP.20160719161716.csv (hourly electricity)

Many of the steps performed here match those in **15 Minute Electric Use Preparation**, so it is possible to reuse some of what you have done already if desired.

Perform the following:
1. Adjust the dates in the *DATE* column to `yyyy-MM-dd` format for sorting purposes.
2. Sort the file by *DIR*, then *SPID*, then *DATE*.
3. Remove duplicate records.
    1. Since the file is now sorted, compare the previous row’s *DATE* and *SPID*. If they are the same, check each of the interval columns. If all match, throw out one of the records.
4. Format trace records.
    1. *trace_id* -> `elec-hourly-[SA]-[SPID]-[DIR]`
    2. If *DIR* is *D*, the *interpretation* is *ELECTRICITY_CONSUMPTION_SUPPLIED*. If *R*, it is *ELECTRICITY_ON_SITE_GENERATION_UNCONSUMED*.
    3. *estimated* -> False
    4. *unit* -> KWH
    5. For *start*, it is necessary to unroll each interval column into a separate line/record. i.e. `01:00,02:00,03:00 ... 24:00` become separate lines with *start* of `DATE + 01:00, DATE + 02:00`, etc.
    6. For *value*, assign the value of the column in step 4.5.
    7. Using the map created in electricity step 6 of **Cross Reference File Preparation**, check the *SPID* to get a *char_prem_id*. Check the *char_prem_id* against the map you created in step 5 of **Project File Preparation** above. Using the project id (or *Application No.*) as the dictionary key with a list as the value, add the trace id from step a above to that list. You’ll be continuing to build this as you perform additional steps.

Optionally, between step 3 and 4 you could split the file into multiple CSVs to make the files easier to work with. This is advisable for this file in particular since it is quite large.

This step should yield 161,755,296 trace records and 8,778 traces.

Monthly Electric Use Preparation
---
The following files are cleaned and formatted in this section:
1. EES25162.ERESBL12 (1).XPT (monthly electricity 1 of 4)
2. EES25162.ERESBL13.XPT (monthly electricity 2 of 4)
3. EES25162.ERESBL15.XPT (monthly electricity 3 of 4)
4. EES25162.ERESBL16.XPT (monthly electricity 4 of 4)

These files are in SAS XPORT format: http://support.sas.com/techsup/technote/ts140.pdf
Your first step will be to convert these into CSV files to perform operations that, by now, are likely becoming familiar. The Python xport library (https://pypi.python.org/pypi/xport/) is one option for doing this conversion easily.

For each file in the list above, perform the following:
1. Convert from XPORT to CSV format.
2. Sort the file by *SA_ID*.
3. Remove duplicate records.
    1. With the file sorted by *SA_ID*, you can simply check whether the previous *SA_ID* matches the current *SA_ID*. If it does, discard one of the records. There should be no duplicate records in this data.
4. Convert the SAS dates.
    1. SAS dates are represented as a number of days since 1960-Jan-01.
    2. The file has columns named `CDT__1, CDT__2...  CDT__12` for the months of the year (as well as `KWH__1, KWH__2... KWH__12` for the consumption values that correspond to those months). Each of the *CDT__x* dates needs to be converted.
5. Pad left with zeroes to 10 (zfill) the *PREM_ID*.
6. Format trace records.
    1. *trace_id* -> “elec_monthly_” + SA_ID 
    2. *interpretation* -> ELECTRICITY_CONSUMPTION_SUPPLIED
    3. For *start*, it is necessary to unroll each interval column into a separate line/record. i.e. the value in `CDT__1, CDT__2` (which should be a converted date value from step 4) should have its own record where it is the start.
    4. For *value*, it is necessary to match the *CDT__x* column in step 6.3 with a value column. i.e. *CDT__1* matches the value column *KWH__1*. As previously stated, these belong on their own line/record.
    5. *estimated* -> False
    6. *unit* -> KWH
    7. Check the *PREM_ID* against the map you created in step 5 of **Project File Preparation** above. Using the project id (or *Application No.*) as the dictionary key with a list as the value, add the trace id from step a above to that list. You’ll be continuing to build this as you perform additional steps.

This step should yield 164,129 trace records and 7,701 traces.

Daily Gas Use Preparation
---
The following files are cleaned and formatted in this section:
1. EES25162_gasdy_160720.csv (daily gas 1 of 2)
2. EES25162_gasdy_160920.csv (daily gas 2 of 2)

For each file in the above list, perform the following steps:
1. Remove the extraneous headers/first two lines of the file.
2. Convert the dates in the *Measurement Date* column to `yyyy-MM-dd` format for sorting purposes.
3. Sort by *Service Point*, then by *Measurement Date*.
4. Remove duplicate records.
    1. Since the file is now sorted, if *Service Point* and *Measurement Date* match the previous row, discard one of the rows.
5. Format trace records.
    1. *trace_id* -> Service Point
    2. *start* -> Measurement Date
    3. *value* -> Therms per Day
    4. *interpretation* -> NATURAL_GAS_CONSUMPTION_SUPPLIED
    5. *unit* -> THERM
    6. *estimated* -> False
    7. Using the map created in electricity step 6 of **Cross Reference File Preparation**, check the *Service Point* to get a *char_prem_id*. Check the *char_prem_id* against the map you created in step 5 of **Project File Preparation** above. Using the project id (or *Application No.*) as the dictionary key with a list as the value, add the trace id from step a above to that list. You’ll be continuing to build this as you perform additional steps.

Optionally, between step 4 and 5 you could split the file into multiple CSVs to make the files easier to work with.

This step should yield 6,892,834 trace records and 4,223 traces.

Monthly Gas Use Preparation
---
The following files are cleaned and formatted in this section:
1. EES25162.G2RSBL12.XPT (monthly gas 1 of 11)
2. EES25162.G2RSBL13.XPT (monthly gas 2 of 11)
3. EES25162.G2RSBL14.XPT (monthly gas 3 of 11)
4. EES25162.G2RSBL15.XPT (monthly gas 4 of 11)
5. EES25162.G2RSBL16.XPT (monthly gas 5 of 11)
6. EES25162.GRESBL12.XPT (monthly gas 6 of 11)
7. EES25162.GRESBL13.XPT (monthly gas 7 of 11)
8. EES25162.GRESBL14.XPT (monthly gas 8 of 11)
9. EES25162.GRESBL15.XPT (monthly gas 9 of 11)
10. EES25162.GRESBL16.JANJUNE.XPT (monthly gas 10 of 11)
11. EES25162.GRESBL16.XPT (monthly gas 11 of 11)

These files are in SAS XPORT format: http://support.sas.com/techsup/technote/ts140.pdf
Your first step will be to convert these into CSV files to perform operations that, by now, are likely becoming familiar. The Python xport library (https://pypi.python.org/pypi/xport/) is one option for doing this conversion easily.

For each file in the list above, perform the following:
1. Convert from XPORT to CSV format.
2. Sort the file by *SA_ID*, then by *CDT__1*.
3. Remove duplicate records.
    1. Since the file is now sorted, if *SA_ID* and *CDT__1* match the previous record, one of them should be discarded.
4. Convert the SAS dates.
    1. SAS dates are represented as a number of days since 1960-Jan-01.
    2. The file has columns named `CDT__1, CDT__2...  CDT__12` for the months of the year (as well as `THM__1, THM__2... THM__12` for the consumption values that correspond to those months). Each of the *CDT__x* dates needs to be converted.
5. Format trace records.
    1. *trace_id* -> “gas-monthly-” + SA_ID
    2. *interpretation* -> NATURAL_GAS_CONSUMPTION_SUPPLIED
    3. *unit* -> THERM
    4. *estimated* -> False
    5. For *start*, it is necessary to unroll each interval column into a separate line/record. i.e. the value in `CDT__1, CDT__2` (which should be a converted date value from step 4) should have its own record where it is the start.
    6. For *value*, it is necessary to match the *CDT__x* column in step 5.5 with a value column. i.e. *CDT__1* matches the value column *THM__1*. As previously stated, these belong on their own line/record.
    7. Check the *PREM_ID* against the map you created in step 5 of **Project File Preparation** above. Using the project id (or *Application No.*) as the dictionary key with a list as the value, add the trace id from step a above to that list. You’ll be continuing to build this as you perform additional steps.

This step should yield 233,053 trace records and 6,893 traces.

Linking Projects to Usage/Trace Data
---
Throughout the process above you've been building a dictionary of projects to traces or outputting files with project to trace mappings as you go. If the former, simply spin through your dictionary and write a single record for each project-trace mapping in a 2 column CSV file with `project_id` and `trace_id`. 

