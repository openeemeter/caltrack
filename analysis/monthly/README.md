# CalTrack Monthly Gross Savings Estimation Technical Guidelines

=======

### Methodological Overview

Site-level gross savings using monthly billing data (both electricity and gas) will use a two-stage estimation approach that closely follows the technical appendix of the Uniform Methods Project for Whole Home Building Analysis and the California Evaluation Project, with some modifications and more specific guidance developed through empirical testing to ensure consistency and replicability of results.


The two-stage approach first fits two separate parametric models to daily energy use data in both the pre-intervention (baseline) period and the post-intervention (reporting) period for a single site using a linear regression model of the general form:

$$U_{mi} = \mu_i + \beta_{Hi}H_m + \beta_{Ci}C_m +  \epsilon_{mi} $$


Where 


$$U_{mi}$$ is average use per day in month `m` for site `i`
$$\mu_i$$ is the mean baseline use for site `i`, or intercept
$$\beta_{Hi}$$ is the coefficient site `i` on heating degree days
$$\beta_{Ci}$$ is the coefficient or site `i` on cooling degree days
$$H_m$$ is the number of heating degree days in month `m`, which is a function of a selected base temperature and average daily temperatures from the weather station matched to site `i`
$$C_m$$ is the number of cooling degree days in month `m`, which is a function of a selected base temperature and average daily temperatures from the weather station matched to site `i`
$$\epsilon_{mi}$$ is the site specific error term

In the second stage, using parameter estimates from the first stage equation, weather normalized savings for both the baseline period and reporting period can be computed by using corresponding temperature normals for the relevant time period (typical year weather normalized gross savings), or by using current-year weather to project forward baseline period use (current year weather normalized gross savings) and differencing between baseline and reporting period estimated or actual use, depending on the quantity of interest.

### General technical guidelines for implementing two-stage estimation on monthly electric and gas usage data 

#### 1. Generate Use Per Day values and separate usage data into a pre- and a post-intervention series

Monthly usage data used in the CalTrack Beta Test monthly analysis will be done on Use Per Day (UPD) values for monthly billing analysis by summing daily use to monthly by calendar month, then divide by the number of days in that month as follows:


`UPD_m = monthly_total_use_m / number_of_daily_use_values_m`


Where


`UPD_m` is the average use per day for a given month `m`
`monthly_total_use_m` is the sum of all daily use values for a given month `m’
`number_of_daily_use_values_m` is the total number of daily use values provided in the usage series that are between the first calendar day of month `m` and the last calendar day of month `m` 


You then split the series of `UPD_m` values into pre- and post-intervention periods according to the following rules:


**Pre-intervention period:** all full month (25 days of recorded use or more) UPD_m values from the beginning of the series up to the the complete calendar month prior to the `work_start_date`. The month containing `work_start_date` is excluded from this series.


**Post-intervention period:** all full month (25 days of recorded use or more) values from the first complete calendar month after the `work_end_date` to the end of the series. 


**Qualifying series:** All qualifying sites must have at least 12 months of `UPD_m` values in the pre-intervention series and at least 12 months of post-intervention `UPD_m` values.



#### 2. Set Fixed Variable Degree Day Base Temperature and calculated HDD and CDD

Next you calculate total HDD and CDD for the each calendar month in the series. CalTrack will use a fixed degree day base for monthly billing analysis. The following balance point temperatures will be use:


HDD base temp: 60 F 
CDD base temp: 70 F


HDD and CDD values are calculated as follows


`HDD_m = Sum_m{ max(60 - ave_temp_d, 0) }`


Where 


`HDD_m` = Heating degree days for calendar month `m`
`Sum_m` = the sum of values in {} over each day `d` in calendar month `m`
`max` = the maximum of the two values in ()
`ave_temp_d` = the average temperature for day `d`


And


`CDD_m = Sum_m{ max(ave_temp_d - 70, 0) }`


Where 


`CDD_m` = Cooling degree days for calendar month `m`
`Sum_m` = the sum of values in {} over each day `d` in calendar month `m`
`max` = the maximum of the two values in ()
`ave_temp_d` = the average temperature for day `d`



#### 3. Fit All Candidate Models and Apply Qualification Criteria

For each site, all allowable models will be run as candidate models and then have minimum fitness criteria set for qualification.


For CalTrack, qualifying candidate models for electricity will meet the following criteria:

- Fit intercept only, intercept + HDD, intercept + CDD, and combined intercept +HDD + CDD models with the constraints beta_HDD,beta_CDD >0,intercept>0
- If the parameter estimates for the combined model each meet minimum significance criteria (p < 0.1) and are strictly positive then the model is qualifying


For CalTrack, qualifying candidate models for gas will meet the following criteria:

- Fit intercept only and intercept + HDD models with the constraints `beta_HDD,intercept>0
- If the parameter estimates for the combined model each meet minimum significance criteria (p < 0.1) and are strictly positive then the model is qualifying


#### 4. Select Best Model for Use in Savings Estimation for Both Pre-period and Post-period

All qualifying pre-retrofit models are compared to each other and among qualifying models, the model with the maximum adjusted R-squared will be selected for second-stage savings estimation.


For the monthly billing analysis, because Caltrack, adjusted R-squared will be defined as 


$$ adjR^2 = 1 - \frac{SS_{res}/df_e}{SS_{tot}/df_t} $$


Where


$$ SS_{res} $$ is the sum of squares of residuals
$$ df_e $$ is the degrees of freedom of the estimate of the underlying population error variance, and is calculated using `n-p-1`, where `n` is the number of observations in the sample used to estimate the model and `p` is the number of explanatory variables, not including the constant term
$$ SS_{tot} $$ is the total sum of squares
$$ df_t $$ is the degrees of freedom of the estimate of the population variance of the dependent variable, and is calculated as `n-1`, were `n` is the size of the sample use to estimate the model


All qualifying post-retrofit models are compared to each other and among qualifying models, the model with the maximum adjusted R-squared will be selected for second-stage savings estimation.


### 5. Estimate Second-stage quantities Based on First Stage Model Estimates

During the second stage, three savings quantities will be estimated for each site that meets the minimum data sufficiency criteria for that savings statistic.


1. Cumulative gross savings over entire performance period
2. Normal year annualized gross savings
3. Year one annualized gross savings in the the reporting (post-intervention) period
4. Year two annualized gross savings in the the reporting (post-intervention) period


These site-level second stage quantities are calculated as follows:

#### Cumulative gross savings over entire performance period (site-level)


    1. Compute `predicted_baseline_use` for each complete calendar month after `work_end_date` using the stage one model from the baseline period and reporting period weather data. Be sure to use balance point temperatures from the baseline model when calculating reporting period HDD and CDD values.

    2. Compute `monthly_gross_savings` = `predicted_baseline_monthly_use - actual_monthly_use` for every complete calendar months after `work_end_date` for project


    3. Sum  `monthly_gross_savings` over every complete calendar month since `work_end_date`. 


#### Year one gross savings from 1 to 12 months after site visit. (site-level)


    1. Compute `predicted_baseline_use` for each complete calendar month after `work_end_date` until 12 calendar months after `work_end_date` using the stage one model from the baseline period and reporting period weather data. Be sure to use balance point temperatures from the baseline model when calculating reporting period HDD and CDD values.

    2. Compute `monthly_gross_savings` = `predicted_baseline_monthly_use - actual_monthly_use` for 12 complete calendar months after `work_end_date` for project


    3. Sum  `monthly_gross_savings` over the 12 calendar months since `work_end_date`. 


#### Year one gross savings from 13 to 24 months after site visit. (site-level)


    1. Compute `predicted_baseline_use` for each complete calendar month starting 13 months after `work_end_date` until 24 calendar months after `work_end_date` using the stage one model from the baseline period and reporting period weather data. Be sure to use balance point temperatures from the baseline model when calculating reporting period HDD and CDD values.


    2. Compute `monthly_gross_savings` = `predicted_baseline_monthly_use - actual_monthly_use` for month 13 to month 24 after `work_end_date` for project


    3. Sum  `monthly_gross_savings` over the 12 calendar months from 13 months after `work_end_date` to 24 months.


#### Normal year annualized gross savings (site-level) using year 1 use


    1. Compute `predicted_baseline_monthly_use` using the stage one model from the baseline period and degree days from the CZ2010 normal weather year. Be sure to use balance point temperatures from the baseline model when calculating baseline period HDD and CDD values.

    2. Compute `predicted_reporting_monthly_use` using a `stage one` model fit to only the first 12 months of post-intervention values and degree days from the CZ2010 normal weather year file. Be sure to use balance point temperatures from the reporting period model when calculating reporting period HDD and CDD values.

    3. Compute `monthly_normal_year_gross_savings` = `predicted_baseline_monthly_use - predicted_reporting_monthly_use` for normal year months

    4. Sum  `monthly_normal_year_gross_savings` over entire normal year. 


--------------------

## Prepared Summary Statistics for Analysis Comparison

To ensure that the CalTrack analysis specification can produce consistent results, each beta tester will generate a set of summary statistics on each of the above site-level savings estimates that can be shared with the larger group through csvs saved to this repository. 
There will be one savings summary file generated by each Beta Tester. Each file will be a .csv and will have the following general format:

| Summary Stat | Value |
| --- | --- |
| Number of Sites Included in Analysis | 4321 |
| Number of sites that met model fitness criteria | 3800 |
| Min cumulative gross savings | 123 |
| Max cumulative gross savings| 456| 


### Combined Project Data Summary File

**Output Filename: `monthly_billing_analysis_savings_summary_NAME_OF_TESTER.csv`**


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