# CalTrack Monthly Gross Savings Estimation Technical Guidelines

=======

### Methodological Overview

Site-level Gross Savings using Monthly Billing Data (both electricity and gas) will use a two-stage estimation approach that closely follows the technical appendix of the Uniform Methods Project for Whole Home Building Analysis and the California Evaluation Project, while providing more specific guidance to ensure replicability.

The two-stage approach fits two separate parametric models to daily energy use data in both the pre-intervention (baseline) period and the post-intervention (reporting) period using the following first stage equation:

### First Stage Equation

![equation](http://latex.codecogs.com/gif.latex?E_%7Bim%7D%20%3D%20%5Cmu_i%20&plus;%5Cbeta_H*H_%7Bim%7D%28%5Ctau_H%29&plus;%5Cbeta_C*C_%7Bim%7D%28%5Ctau_C%29&plus;%5Cepsilon_%7Bim%7D)

In the second stage, using parameter estimates from the first stage, weather normalized savings for both the baseline period and reporting period can be computed by using corresponding temperature normals for the relevant time period (typical year weather normalized gross savings), or by using current-year weather to project forward baseline period use (current year weather normalized gross savings) and differencing between baseline and reporting period estimated use.  


### Technical guidelines for implementing two-stage estimation 

Monthly usage data used in the CalTrack Beta Test monthly analysis will be done on Use Per Day (UPD) values for monthly billing analysis by summing daily use to monthly by calendar month, then divide by the number of days in that month.

In order to ensure replicability of results, the following steps to two-stage modeling need clear and consistent rules:

`monthly_usage_quantity / (calendar_month_end_date - calendar_month_start_date)`

Stage one modeling will be done sequentially as a joint optimization problem using minimum model qualification criteria to constrain the space of candidate models, then using model selection criteria for choosing the "best" among candidate models for savings estimation.

#### Variable Degree Day Base Tempurature Space

CalTrack will use variable degree day base tempuratures. Balance point temperatures will be selected by doing a search over the two parameter HDD and CDD model separately using the following grid search criteria:

Search range for HDD base temp: `55 degrees F to 65 degrees F`
Search range for CDD base temp: `65 degrees F to 75 degrees F`
With the constraint `HDD Base Temp`<=`CDD Base Temp`

Grid search step size: `5 degrees`


#### Model Qualification

For each site, the choice must be made between using one of of the single parameter models (Just `HDD` or `CDD`) or combined `HDD` and `CDD` models. This choice is called *model selection*. For CalTrack, model selection will be done by sequential model fit in the following way:

1. Fit combined `HDD` + `CDD` model with the constraint `beta_HDD,beta_CDD >0`
2. If the parameter estimates for the combined model each meet minimum significance criteria (`p < 0.1`) and are strictly positive then the combined model is used. 
3. If only one of the degree day coefficients has `p < 0.1`, retain the significant term (heating or cooling) and refit the single-parameter model.
4. If neither the heating nor the cooling coefficient has a p-value of less than 10% in the respective model, drop both terms and use mean daily consumption for the month (or year) as the relevant stage-one statistic.



#### Model Selection

Among qualifying models, the model with the maximum adjusted R-squared will be selected for second-stage savings estimation.

### Second Stage Estimated Quantities
During the second stage, three savings quantities will be estimated for each site that meets the minimum data sufficiency criteria for that savings statistic.

1. Cumulative gross savings over entire performance period
2. Normal year annualized gross savings
3. Year one annualized gross savings in the the reporting (post-intervention) period
4. Year two annualized gross savings in the the reporting (post-intervention) period

These site-level second stage quantities are calculated as follows:

##### Cumulative gross savings over entire performance period (site-level)
    
    1. Compute `predicted_baseline_use` for each complete calendar month after `work_end_date` using the Stage One model from the baseline period and reporting period weather data. Be sure to use balance point tempuratures from the baseline model when calculating reporting period HDD and CDD values.
    2. Compute `monthly_gross_savings` = `predicted_baseline_monthly_use - actual_monthly_use` for every complete calendar months after `work_end_date` for project
    2. Sum  `monthly_gross_savings` over every complete calendar month since `work_end_date`. 

##### Normal year annualized gross savings (site-level)
    
    1. Compute `predicted_baseline_monthly_use` using the Stage One model from the baseline period and degree days from the CZ2010 normal weather year. Be sure to use balance point tempuratures from the baseline model when calculating baseline period HDD and CDD values.
    1. Compute `predicted_reporting_monthly_use` using the Stage One model from the baseline period and degree days from the CZ2010 normal weather year file. Be sure to use balance point tempuratures from the reporting period model when calculating reporting period HDD and CDD values.
    2. Compute `monthly_normalized_gross_savings` = `predicted_baseline_monthly_use - predicted_reporting_monthly_use` for every complete calendar months after `work_end_date` for project
    2. Sum  `monthly_gross_savings` over every complete calendar month since `work_end_date`. 

## Prepared Summary Statistics for Analysis Comparison

Site-level savings estimates will be run on 

To ensure that the CalTrack analysis specification can produce consistent results, each beta tester will generate a set of summary statistics on each of the above site-level savings estimates that can be shared with the larger group through csvs saved to this repository. 
There will be one savings summary file generated by each Beta Tester. Each file will be a .csv and will have the following general format:

| Summary Stat | Value |
| --- | --- |
| Number of Sites Included in Analysis | 4321 |
| Number of sites that met model fitnes criteria | 3800 |
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
- Min current year annualized gross savings
- Max current year annualized gross savings
- Average current year annualized gross savings
- 10th percentile value current year annualized gross savings
- 20th percentile value current year annualized gross savings
- 30th percentile value current year annualized gross savings
- 40th percentile value current year annualized gross savings
- 50th percentile value current year annualized gross savings
- 60th percentile value current year annualized gross savings
- 70th percentile value current year annualized gross savings
- 80th percentile value current year annualized gross savings
- 90th percentile value current year annualized gross savings
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