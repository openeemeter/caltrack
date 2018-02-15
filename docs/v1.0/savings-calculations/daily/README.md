## **CalTRACK Site-level Daily Weather Normalized, Metered Energy Savings Estimation Technical Guidelines**

* * *


### **Methodological Overview**

Site-level Weather Normalized, Metered Energy Savings using daily billing data (both electricity and gas) will use a two-stage estimation approach that builds on the technical appendix of the Uniform Methods Project for Whole Home Building Analysis and the California Evaluation Project, while providing more specific guidance to ensure replicability and address specific methodological issues related to both the data sources and the CalTRACK-specific use cases that are not addressed in prior standards.

The two-stage approach fits two separate parametric models to daily energy use data in both the pre-intervention (baseline) period and the post-intervention (reporting) period using ordinary least squares with the following first stage equation:


$$UPD_{di} = \mu_i + \beta_{Hi}HDD_d + \beta_{Ci}CDD_d + \epsilon_{di}$$

Where:

\(UPD_{di}\) is the total use (therms for gas, kWh for electricity) per day on day, \(d\), for site, \(i\)

\(\mu_i\) is the mean use for site, \(i\)

\(\beta_{Hi}\) is the coefficient for site, \(i\), of heating degree days

\(\beta_{Ci}\) is the coefficient for site, \(i\), of cooling degree days

\(HDD_d\) is the number of heating degree days on day, \(d\), calculated as `max(heating balance point - average daily temperature at site i, 0)`

\(CDD_d\) is the number of cooling degree days on day, \(d\), calculated as `max(average daily temperature at site i - cooling balance point, 0)`

\(\epsilon_{di}\) is the error term at site, \(i\), for day, \(d\)

**Note**: during the beta test we explored the use of robust linear regression instead of ordinary least squares but ultimately decided to use ordinary least squares for the initial CalTRACK use case.  A robust regression may offer some significant advantages, as described [here](https://github.com/impactlab/caltrack/issues/56) along with our reasons for sticking with ordinary least squares, and is worth considering as a future improvement to these methods.

In the second stage, using parameter estimates from the first stage equation, weather normalized savings for both the baseline period and reporting period can be computed by using corresponding temperature normals for the relevant time period (typical year weather normalized metered energy savings), or by using current-year weather to project forward baseline period use (current year weather normalized metered energy savings) and differencing between baseline and reporting period estimated or actual use, depending on the quantity of interest.

We now proceed with a detailed technical treatment of the steps for daily savings estimation.

### **Technical guidelines for implementing two-stage estimation on daily electric and gas usage data for CalTRACK**

CalTRACK savings estimation begins with gas and electric usage data, project data, and weather data that have been cleaned and combined according to the Data Preparation technical specification. Starting with the prepared data, site-level daily metered energy savings analysis is performed by implementing the following steps:

1. Usage data used in the CalTRACK daily analysis will be done on Use Per Day (\(UPD\)) values from daily AMI usage data.

2. Stage one modeling will be done sequentially as a joint optimization problem using minimum model qualification criteria to constrain the space of candidate models, then using model selection criteria for choosing the "best" among candidate models for savings estimation.

**Variable Degree Day Base Temperature Search and Optimization**

CalTRACK daily methods will use variable degree day base temperatures. Balance point temperatures will be selected by doing a search over the one or two parameter HDD and CDD models separately using the following grid search criteria:

1) Search range for HDD base temp: `55 degrees F to 65 degrees F`

2) Search range for CDD base temp: `65 degrees F to 75 degrees F`

3) With the constraint `HDD Base Temp`<=`CDD Base Temp`

4) Grid search step size: `1 degree`

**Grid Search Data Sufficiency**

When searching across balance points, only model those balance points for which there are either: 

* at least 10 non-zero degree days

* a sum of at least 20 degree days

This avoids overfitting in the case where only a few days exist with usage and nonzero degree-days, and the usage happens by chance to be unusually high on those days.

**Model Qualification**
 

For each site, the choice must be made between using one of the single parameter models (just `HDD` or `CDD`) or combined models (`HDD` and `CDD`), or the intercept-only model.  This choice is called *model selection*.  Before model selection, choose qualifying models in the following way:

 

1. For each set of balance points in the grid search, fit the single parameter and combined models.

2. Qualifying models are those meeting the following constraints:

3. \( \beta_{Hi}, \beta_{Ci} >= 0 \)

4. p-values for \(\beta_{Hi}\) and  \(\beta_{Ci}\) are \(< 0.1\)

 

**Model Selection/Optimization**

 

Among qualifying models, the model with the maximum adjusted R-squared will be selected as the best fit model for second-stage savings estimation.  If there are no qualifying models, fit the intercept-only model and use that for second-stage savings estimation.




**Second Stage Estimated Quantities**

During the second stage, four savings quantities will be estimated for each site that meets the minimum data sufficiency criteria for that savings statistic.

1. Cumulative weather normalized metered energy savings over entire performance period
2. Normal year annualized weather normalized metered energy savings
3. Year one annualized weather normalized metered energy savings in the the reporting (post-intervention) period
4. Year two annualized weather normalized metered energy savings in the the reporting (post-intervention) period

These site-level second stage quantities are calculated as follows:

**Cumulative weather normalized metered energy savings over entire performance period (site-level)**

1. Compute `predicted_baseline_use` for each day after `work_end_date` using the Stage One model with the reporting period weather data. Be sure to use balance point temperatures from the baseline model when calculating reporting period HDD and CDD values.
2. Compute `daily_gross_savings` = `predicted_baseline_use - actual_use` for every day after `work_end_date`.
3. Sum  `daily_gross_savings` over every day since `work_end_date`.

**Normal year annualized weather normalized metered energy savings (site-level)**
   
1. Compute `predicted_baseline_use` using the Stage One model from the baseline period and degree days from the CZ2010 normal weather year. Be sure to use balance point temperatures from the baseline model when calculating baseline period HDD and CDD values.
2. Compute `predicted_reporting_use` using the Stage One model from the reporting period and degree days from the CZ2010 normal weather year file. Be sure to use balance point temperatures from the reporting period model when calculating reporting period HDD and CDD values.
3. Compute `daily_normal_year_gross_savings` = `predicted_baseline_use - predicted_reporting_use` for normal year days
4. Sum  `daily_normal_year_gross_savings` over entire normal year.

**Year one weather normalized metered energy savings from 1 to 12 months after work-end-date.  (site-level)**
   
1. Compute `predicted_baseline_use` for each day after `work_end_date` until 12 calendar months after `work_end_date` using the Stage One model from the baseline period and reporting period weather data. Be sure to use balance point temperatures from the baseline model when calculating reporting period HDD and CDD values.
2. Compute `daily_gross_savings` = `predicted_baseline_use - actual_daily_use` for 12 complete calendar months after `work_end_date` for project. For days missing consumption data after the date of the intervention, a baseline mask should exclude those days from consideration as part of a savings calculation.
3. Sum  `daily_gross_savings` over the 12 calendar months since `work_end_date`.

**Year two weather normalized metered energy savings from 13 to 24 months after work-end-date.  (site-level)**

1. Compute `predicted_baseline_use` for each day starting 13 months after `work_end_date` until 24 calendar months after `work_end_date` using the Stage One model from the baseline period and reporting period weather data. Be sure to use balance point temperatures from the baseline model when calculating reporting period HDD and CDD values.
2. Compute `daily_gross_savings` = `predicted_baseline_use - actual_daily_use` for month 13 to month 24 after `work_end_date` for project. For days missing consumption data after the date of the intervention, a baseline mask should exclude those days from consideration as part of a savings calculation.
3. Sum  `daily_gross_savings` over the 12 calendar months from 13 months after `work_end_date` to 24 months.

### **Post-estimation steps and portfolio aggregation**

The goal of CalTRACK is to develop replicable, consistent, and methodologically defensible estimators of savings over portfolios of homes. In order to do that, the above site-level savings quantities must be aggregated to get portfolio-level totals, means, and variances. Taking the site-level estimates, CalTRACK then performs a set of aggregation steps that are specified [here](https://github.com/impactlab/caltrack/tree/master/aggregation).


