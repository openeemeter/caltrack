## CalTRACK Site-level Monthly Gross Savings Estimation Technical Guideline

====

### Methodological Overview

Site-level gross savings using monthly billing data (both electricity and gas) will use a two-stage estimation approach that closely follows the technical appendix of the Uniform Methods Project for Whole Home Building Analysis and the California Evaluation Project, with some modifications and more specific guidance developed through empirical testing to ensure consistency and replicability of results.

The two-stage approach first fits **two** separate parametric models to daily average energy use, on the pre-intervention (baseline) period and one in the post-intervention (reporting) period for a single site using an ordinary least squares regression of the form:

$$UPD_{mi} = \mu_i + \beta_{Hi}H_m + \beta_{Ci}C_m +  \epsilon_{mi} $$

Where 

$UPD_{mi}$ is average use (gas in therms, electricity in kWh) per day in month `m` for site `i`.

$\mu_i$ is the mean use for site `i`, or intercept.

$\beta_{Hi}$ is the coefficient site `i` on average heating degree days per day.

$\beta_{Ci}$ is the coefficient or site `i` on average cooling degree days per day.

$H_m$ is the average number of heating degree days per day in month `m`, which is a function of a fixed base temperature, the average daily temperatures from the weather station matched to site `i` during month `m`, and the number of days in month `m` with matched usage and weather data for site `i`.

$C_m$ is the average number of cooling degree days per day in month `m`, which is a function of a selected base temperature, the average daily temperatures from the weather station matched to site `i` during month `m`, and the number of days in month `m` with matched usage and weather data for site `i`.

$\epsilon_{mi}$ is the site specific error term for a given month.

In the second stage, using parameter estimates from the first stage equation, weather normalized savings for both the baseline period and reporting period can be computed by using corresponding temperature normals for the relevant time period (typical year weather normalized gross savings), or by using current-year weather to project forward baseline period use (current year weather normalized gross savings) and differencing between baseline and reporting period estimated or actual use, depending on the quantity of interest.

This site-level two-stage approach without the use of a comparison group, while having significant limitations and tradeoffs, was decided by the technical working group to be appropriate for the two main use cases for CalTRACK, which emphasize effects on the grid and feedback to software vendors, rather than causal programatic effects. In addition to its long history of use in the EM&V liturature, it draws on a methodological foundation developed in the more general liturature on piecewise linear regression or segmented regression for policy analysis and effect estimates that is used in fields as divers as public health, medical research, and econometrics.

We now proceed with a detailed technical treatment of the steps for monthly savings estimation.

###Technical guidelines for implementing two-stage estimation on monthly electric and gas usage data for CalTRACK

CalTRACK savings estimation begins with gas and electric usage data, project data, and weather data that have been cleaned and combined according to the Data Cleaning and Integration tecnical specification. Starting with the prepared data, site-level monthly gross savings analysis is performed by implmenting the following steps:

#### 1. Generate Use Per Day values and separate usage data into a pre- and a post-intervention data series

The CalTRACK monthly gross savings analysis uses average use per day ($UPD$) values for each month  by either using mon**summing daily use to monthly total use** by **calendar month**, then divide by the number of days in that month that had usage values, as follows:

$UPD_m = \frac{1}{n_{U_d}}*\sum{U_d}$

Where

$UPD_m$ is the average use per day for a given month `m`

$\sum{U_d}$ is the sum of all daily use values $U_d$ for a given month `m’

$n_{U_d}$ is the total number of daily use values provided in the usage series that are between the first calendar day of month `m` and the last calendar day of month `m` 

*Note: If daily use data for gas or electric is not available, monthly billing data can be used for the monthly billing analysis. However, modifications of the denominators for avergage use per day and for average HDD and CDD per day are necessary.

Now split the series of $UPD_m$ values into pre- and post-intervention periods according to the following rules:

*Pre-intervention period*: all full month (15 days of recorded use or more) $UPD_m$ values from the beginning of the series up to the the complete calendar month prior to the `work_start_date`. The month containing `work_start_date` is excluded from this series.

*Post-intervention period*: all full month (15 days of recorded use or more) values from the first complete calendar month after the `work_end_date` to the end of the series. 

**Final data sufficiency qualification check**: All qualifying sites must have at least 12 months of contiguous $UPD_m$ values in the pre-intervention series and at least 12 months of contiguous post-intervention $UPD_m$ values starting with the month after `work_end_date`. 

**All sites not meeting these minimum data requirements are thrown out of the analysis**

#### 2. Set fixed degree day base temperature and calculated HDD and CDD

Next you calculate total HDD and CDD for the each calendar month in the series. CalTRACK will use a fixed degree day base for monthly billing analysis. The following balance point temperatures will be use:

HDD base temp: 60 F 

CDD base temp: 70 F

HDD and CDD values are calculated as follows

$HDD_m = \frac{1}{n_{U_d}}*\sum{ \max(60 - T_{ave}, 0) }$


Where 

$HDD_m$ = Average heating degree days per day for calendar month `m`

$n_{U_d}$ = the number of days with both weather and usage data

$\sum$ = the sum of the degree  over each day `d` in calendar month `m`

$\max$ = the maximum of the two values in ()

$T_{ave}$ = the average temperature for day `d`


And

$CDD_m = \frac{1}{n_{U_d}}*\sum{ max(ave_temp_d - 70, 0) }$

Where 

&CDD_m$ = Cooling degree days for calendar month `m`

$n_{U_d}$ = the number of days with both weather and usage data

$\sum$ = the sum of values in {} over each day `d` in calendar month `m`

$\max$ = the maximum of the two values in ()

$T_{ave}$ = the average temperature for day `d`


**Daily average tempuratures are taken from the GSOD average data tempurature dataset provided by NOAA

#### 3. Fit All Candidate Models and Apply Qualification Criteria

For each site, all allowable models will be run as candidate models and then have minimum fitness criteria set for qualification.

For CalTRACK electric monthly savings analysis, the following candidate models are fit:

1. $UPD_{mi} = \mu_i + \beta_{Hi}H_m + \beta_{Ci}C_m +  \epsilon_{mi} $

2. $UPD_{mi} = \mu_i + \beta_{Hi}H_m +  \epsilon_{mi} $

3. $UPD_{mi} = \mu_i + \beta_{Ci}C_m +  \epsilon_{mi} $

4. $UPD_{mi} = \mu_i + \epsilon_{mi} $


with the constraints 

$\beta_{H} > 0$

$\beta_{C} > 0$

$\mu_i > 0$

For electric, qualifying models for selection must have each parameter estimate meet the minimum significance criteria of $p < 0.1$ and are strictly positive. All qualifying models are considered for final model selection.

For CalTRACK gas monthly savings analysis, the following candidate models are fit:

1. $UPD_{mi} = \mu_i + \beta_{Hi}H_m +  \epsilon_{mi} $

2. $UPD_{mi} = \mu_i + \beta_{Ci}C_m +  \epsilon_{mi} $

3. $UPD_{mi} = \mu_i + \epsilon_{mi} $

with the constraints

$\beta_{H} > 0$

$\mu_i > 0$

If each parameter estimate meets minimum significance criteria (p < 0.1) and are strictly positive, then the model is a qualifying model for inclusion in model selection.

#### 4. Select the best for pre-intervenion and post-intervention periods for use in second-stage savings estimation 


All qualifying pre-intervention models are compared to each other and among qualifying models, the model with the maximum adjusted R-squared will be selected for second-stage savings estimation.

For the monthly billing analysis, because we are using fixed degree days instead of variable degree days, adjusted R-squared will be defined as


$$ adjR^2 = 1 - \frac{SS_{res}/df_e}{SS_{tot}/df_t} $$


Where


$ SS_{res} $ is the sum of squares of residuals

$ df_e $ is the degrees of freedom of the estimate of the underlying population error variance, and is calculated using `n-p-1`, where `n` is the number of observations in the sample used to estimate the model and `p` is the number of explanatory variables, not including the constant term and not including degree day base temperature as a parameter because it’s fixed

$ SS_{tot} $ is the total sum of squares

$ df_t $ is the degrees of freedom of the estimate of the population variance of the dependent variable, and is calculated as `n-1`, were `n` is the size of the sample use to estimate the model

All qualifying post-intervention models are compared to each other and among qualifying models, the model with the maximum adjusted R-squared will be selected for second-stage savings estimation.

#### 5. Estimate second-stage gross savings quantities based on selected first stage pre- and post-intervention models

During the second stage, up to five savings quantities will be estimated for each site that meets the minimum data sufficiency criteria for that savings statistic.

Cumulative gross savings over entire performance period
Year one annualized actual gross savings in the the reporting (post-intervention) period
Year two annualized actual gross savings in the the reporting (post-intervention) period
Year one annualized gross savings in the normal year
Year two annualized gross savings in the normal year

These site-level second stage quantities are calculated as follows:

#### Cumulative gross savings over entire performance period (site-level)


1. Compute `predicted_baseline_use` for each complete calendar month after `work_end_date` using parameter estimates from the stage one model from the pre-intervention (baseline) period model and the associated average degree days for each month in the post-intervention (reporting) period, ensuring that the same degree day values calculated for stage one model fits are use in stage two estimation.
2. Compute `monthly_gross_savings` = `predicted_baseline_monthly_use - actual_monthly_use` for every complete calendar months after `work_end_date` for project
3. Sum  `monthly_gross_savings` over every complete calendar month since `work_end_date`. 


#### Year one gross savings from 1 to 12 months after site visit. (site-level)


1. Compute `predicted_baseline_use` for each complete calendar month after `work_end_date` until 12 calendar months after `work_end_date`  using parameter estimates from the stage one model from the pre-intervention (baseline) period model and the associated average degree days for each month in the post-intervention (reporting) period, ensuring that the same degree day values calculated for stage one model fits are use in stage two estimation.
2. Compute `monthly_gross_savings` = `predicted_baseline_monthly_use - actual_monthly_use` for 12 complete calendar months after `work_end_date` for project
3. Sum  `monthly_gross_savings` over the 12 calendar months since `work_end_date`. 


#### Year two gross savings from 13 to 24 months after site visit. (site-level)


1. Compute `predicted_baseline_use` for each complete calendar month starting 13 months after `work_end_date` until 24 calendar months after `work_end_date`  using parameter estimates from the stage one model from the pre-intervention (baseline) period model and the associated average degree days for each month in the post-intervention (reporting) period, ensuring that the same degree day values calculated for stage one model fits are use in stage two estimation.
2. Compute `monthly_gross_savings` = `predicted_baseline_monthly_use - actual_monthly_use` for month 13 to month 24 after `work_end_date` for project
3. Sum  `monthly_gross_savings` over the 12 calendar months from 13 months after `work_end_date` to 24 months.


#### Year one site-level annualized gross savings in the normal year


1. Compute `predicted_baseline_monthly_use` using the stage one model from the baseline period and average degree days from the CZ2010 normal weather year. Use the full month of available values when calculating the average degree days per calendar month for the normal year.
2. Compute `predicted_reporting_monthly_use` using a `stage one` model fit to only the first 12 months of post-intervention values and degree days from the CZ2010 normal weather year file. Use the full month of available values when calculating the average degree days per calendar month for the normal year.
3. Compute `monthly_normal_year_gross_savings` = `predicted_baseline_monthly_use - predicted_reporting_monthly_use` for normal year months
4. Sum  `monthly_normal_year_gross_savings` over entire normal year. 


#### Year two site-level annualized gross savings in the normal year


1. Compute `predicted_baseline_monthly_use` using the stage one model from the baseline period and degree days from the CZ2010 normal weather year.
2. Compute `predicted_reporting_monthly_use` using a `stage one` model fit to only the 13th-24th months of post-intervention values and degree days from the CZ2010 normal weather year file for the relevant months.
3. Compute `monthly_normal_year_gross_savings` = `predicted_baseline_monthly_use - predicted_reporting_monthly_use` for each normal year month.
4. Sum  `monthly_normal_year_gross_savings` over entire normal year. 

### Post-estimation steps and portfolio aggregation

The goal of CalTRACK is to develop replicable, consistent, and methodologically defensible estimators of savings over **portfolios of homes**. In order to do that, the above site-level savings quantities must be aggregated to get portfolio-level totals, means, and varainces. Taking the site-level estimates, CalTRACK then performs a set of aggregation steps that are specified [here](https://github.com/impactlab/CalTRACK-betatest/tree/master/aggregation).

_________________________________________________________


#### Monthly Savings Estimation Summary Statistics for Analysis Comparison

To ensure that the CalTRACK analysis specification can produce consistent results, each beta tester will generate a set of summary statistics on each of the above site-level savings estimates that can be shared with the larger group through csvs saved to this repository. There will be one savings summary file generated by each Beta Tester. Each file will be a .csv and will have the following general format:


| Summary Stat | Value | 
| --- | --- | 
| Number of Sites Included in Analysis | 4321 | 
| Number of sites that met model fitness criteria | 3800 | 
| Min cumulative gross savings | 123 | 
| Max cumulative gross savings| 456 |


**Combined Project Data Summary File**
Output Filename: `monthly_billing_analysis_savings_summary_NAME_OF_TESTER.csv`

#### Included Summary statistics

- Total number of sites included in first-stage estimation
- Total number of sites with cumulative gross savings estimates
- Total number of sites with normal year annualized gross savings 
- Total number of sites with year one annualized gross savings 
- Total number of sites with year two annualized gross savings 
- Min cumulative gross savings
- Max cumulative gross savings
- Average cumulative gross savings
- 10th percentile value cumulative gross savings
- 20th percentile value cumulative gross savings
- 30th percentile value cumulative gross savings
- 40th percentile value cumulative gross savings
- 50th percentile value cumulative gross savings
- 60th percentile value cumulative gross savings
- 70th percentile value cumulative gross savings
- 80th percentile value cumulative gross savings
- 90th percentile value cumulative gross savings
- Cumulative gross savings average MSE
- Cumulative gross savings average prediction error
- Min normal year annualized savings
- Max normal year annualized savings
- Average normal year annualized savings
- 10th percentile value normal year annualized savings 
- 20th percentile value normal year annualized savings
- 30th percentile value normal year annualized savings
- 40th percentile value normal year annualized savings
- 50th percentile value normal year annualized savings
- 60th percentile value normal year annualized savings
- 70th percentile value normal year annualized savings
- 80th percentile value normal year annualized savings
- 90th percentile value normal year annualized savings
- Normal year annualized savings average MSE
- Normal year annualized savings average prediction error
- Min year one annualized gross savings
- Max year one annualized gross savings
- Average year one annualized gross savings
- 10th percentile value year one annualized gross savings
- 20th percentile value year one annualized gross savings
- 30th percentile value year one annualized gross savings
- 40th percentile value year one annualized gross savings
- 50th percentile value year one annualized gross savings
- 60th percentile value year one annualized gross savings
- 70th percentile value year one annualized gross savings
- 80th percentile value year one annualized gross savings
- 90th percentile value year one annualized gross savings
- Year one annualized gross savings average MSE
- Year one annualized gross savings average prediction error
- Min year two annualized gross savings
- Max year two annualized gross savings
- Average year two annualized gross savings
- 10th percentile value year two annualized gross savings
- 20th percentile value year two annualized gross savings
- 30th percentile value year two annualized gross savings
- 40th percentile value year two annualized gross savings
- 50th percentile value year two annualized gross savings
- 60th percentile value year two annualized gross savings
- 70th percentile value year two annualized gross savings
- 80th percentile value year two annualized gross savings
- 90th percentile value year two annualized gross savings
- Year two annualized gross savings average MSE
- Year two annualized gross savings average prediction error
- Min heating balance point temp baseline period
- Max heating balance point temp baseline period
- Average heating balance point temp baseline period
- 10th percentile value heating balance point temp baseline period
- 20th percentile value heating balance point temp baseline period
- 30th percentile value heating balance point temp baseline period
- 40th percentile value heating balance point temp baseline period
- 50th percentile value heating balance point temp baseline period
- 60th percentile value heating balance point temp baseline period
- 70th percentile value heating balance point temp baseline period
- 80th percentile value heating balance point temp baseline period
- 90th percentile value heating balance point temp baseline period
- Min cooling balance point temp baseline period
- Max cooling balance point temp baseline period
- Average cooling balance point temp baseline period
- 10th percentile value cooling balance point temp baseline period
- 20th percentile value cooling balance point temp baseline period
- 30th percentile value cooling balance point temp baseline period
- 40th percentile value cooling balance point temp baseline period
- 50th percentile value cooling balance point temp baseline period
- 60th percentile value cooling balance point temp baseline period
- 70th percentile value cooling balance point temp baseline period
- 80th percentile value cooling balance point temp baseline period
- 90th percentile value cooling balance point temp baseline period
- Count of Heating + Cooling models baseline period
- Count of Heating only models baseline period
- Count of Cooling only models baseline period
- Mean Heating coefficient value across all baseline period models 
- Min Heating coefficient value across all baseline period models 
- Max Heating coefficient value across all baseline period models 
- Mean Cooling coefficient value across all baseline period models
- Min Cooling coefficient value across all baseline period models 
- Max Cooling coefficient value across all baseline period models 
- Count of sites where model selection changes between baseline and reporting (from `N` parameters to `M` parameters where `N != M`)
- Min cooling balance point temp reporting period
- Max cooling balance point temp reporting period
- Average cooling balance point temp reporting period
- Min heating balance point temp reporting period
- Max heating balance point temp reporting period
- Average heating balance point temp reporting period