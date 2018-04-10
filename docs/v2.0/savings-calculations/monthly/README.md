## CalTRACK Site-level Billing Period Weather Normalized, Metered Energy Savings Estimation Technical Guideline

--------

### Methodological Overview

Site-level weather normalized, metered energy savings using billing period billing data (both electricity and gas) will use a two-stage estimation approach that closely follows methodological recommendations in the technical appendices of the Uniform Methods Project for Whole Home Building Analysis and the California Evaluation Project, with some modifications and more specific guidance developed through empirical testing to ensure consistency and replicability of results.

The idea behind two-stage site-level models is to model the energy use of each house before and after an energy efficiency retrofit.

More formally, the two-stage approach first fits **two** separate parametric models to daily average energy use, one on the pre-intervention (baseline) period and one on the post-intervention (reporting) period for a single site using a weighted least squares regression. Weights should be calculated by:

1) Summing all degree days in a billing period
2) Dividing by the number of days in the billing period 

The first stage regression will look as follows:


$$UPD_{mi} = \mu_i + \beta_{Hi}HDD_m + \beta_{Ci}CDD_m + \epsilon_{mi}$$


Where

\(UPD_{mi}\) is average use (gas in therms, electricity in kWh) per day during billing period m for site i.

\(\mu_i\) is the mean use for site \(i\), or intercept.

\(\beta_{Hi}\) is the coefficient site \(i\) on average heating degree days per day.

\(\beta_{Ci}\) is the coefficient or site \(i\) on average cooling degree days per day.

\(HDD_m\) is the average number of heating degree days per day in billing period \(m\), which is a function of a fixed base temperature, the average daily temperatures from the weather station matched to site \(i\) during the billing period \(m\), and the number of days in billing period \(m\) with matched usage and weather data for site \(i\).

\(CDD_m\) is the average number of cooling degree days per day in billing period \(m\), which is a function of a selected base temperature, the average daily temperatures from the weather station matched to site \(i\) during the billing period \(m\), and the number of days in billing period\(m\) with matched usage and weather data for site \(i\).

\(\epsilon_{mi}\) is the site specific error term for a given billing period.



In the second stage, using parameter estimates from the first stage equation, weather normalized savings for both the baseline period and reporting period can be computed by using corresponding temperature normals for the relevant time period (typical year weather normalized metered energy savings), or by using current-year weather to project forward baseline period use (current year weather normalized metered energy savings) and differencing between baseline and reporting period estimated or actual use, depending on the quantity of interest.

This site-level two-stage approach without the use of a comparison group was decided by the technical working group to be appropriate for the two main use cases for CalTRACK, which emphasize effects on the grid and feedback to software vendors, rather than causal programatic effects. In addition to its long history of use in the EM&V literature, it draws on a methodological foundation developed in the more general literature on piecewise linear regression or segmented regression for policy analysis and effect estimates that is used in fields as diverse as public health, medical research, and econometrics.

We now proceed with a detailed technical treatment of the steps for billing period savings estimation.

### Technical guidelines for implementing two-stage estimation on billing period electric and gas usage data for CalTRACK

CalTRACK savings estimation begins with gas and electric usage data, project data, and weather data that have been cleaned and combined according to the Data Cleaning and Integration technical specification. Starting with the prepared data, site-level billing period weather normalized metered energy savings analysis is performed by implementing the following steps:

#### 1. Generate Use Per Day values and separate usage data into a pre- and a post-intervention data series

The CalTRACK billing period weather normalized metered energy savings analysis uses average use per day (\(UPD\)) values for each billing period by taking the bill-period usage values, then dividing by the number of days in that bill period, as follows:

$$UPD_m = \frac{1}{n_{U_d}} * \sum{U_d}$$

Where

\(UPD_m\) is the average use per day for a given billing period \(m\)

\(\sum{U_d}\) is the sum of all daily use values \(U_d\) for a given billing period \(m\)

\(n_{U_d}\) is the total number of daily use values provided in the usage series between the first day of a billing period \(m\) and the last day of the billing period \(m\)

*Note: If daily use data for gas or electric is not available, billing period billing data can be used for the billing period billing analysis. However, modifications of the denominators for average use per day and for average HDD and CDD per day are necessary.*

Now split the series of \(UPD_m\) values into pre- and post-intervention periods according to the following rules:

*Pre-intervention period*: all UPDm values from the beginning of the series up to the the complete billing period prior to the `work_start_date`. The billing period containing `work_start_date` is excluded from this series.

*Post-intervention period*: all UPDm values from the first billing period after the `work_end_date` to the end of the series.

**Final data sufficiency qualification check**: All qualifying sites must have at least 365 days of contiguous UPDm values in the pre-intervention series and at least 365 days of contiguous post-intervention UPDm values starting with the billing period after `work_end_date`.

**All sites not meeting these minimum data requirements are thrown out of the analysis**

#### 2. Set variable degree day base temperature and calculated HDD and CDD

Next, calculate total HDD and CDD for the each billing period in the series. CalTRACK will use a variable degree day base for billing period billing analysis. A grid search procedure will be employed to determine balance points for HDD and CDD that result in best model fit. Search increments of up to 3 F will be permitted. The grid search for HDD and CDD will have the following ranges:

HDD temp range: 40-80 F

CDD temp range: 50-90 F

HDD and CDD values are calculated as follows

$$HDD_m = \frac{1}{n_{Ud}} * \sum{\max(HDD_b - \bar{T}, 0)}$$


Where

\(HDD_m\) = Average heating degree days per day for billing period \(m\)

\(HDD_b\) = the HDD balance point that provides best model fit

\(n_{U_d}\) = the number of days with both weather and usage data

\(\sum{}\) = the sum of the degree  over each day \(d\) in billing period \(m\)

\(\max{}\) = the maximum of the two values in ()

\(\bar{T}\) = the average temperature for day \(d\)


And

$$ CDD_m = \frac{1}{n_{Ud}} * \sum{\max(\bar{T_d} - CDD_b, 0)}$$

Where

\(CDD_m\) = Cooling degree days for billing period \(m\)

\(CDD_b|) = the CDD balance point that provides best model fit

\(n_{Ud}\) = the number of days with both weather and usage data

\(\sum{}\) = the sum of values in {} over each day \(d\) in billing period \(m\)

\(\max{}\) = the maximum of the two values in ()

\(\bar{T_d}\) = the average temperature for day \(d\)


*Daily average temperatures are taken from the GSOD average data temperature dataset provided by NOAA*

#### 3. Fit All Candidate Models and Apply Qualification Criteria

For each site, all allowable models will be run as candidate models and then have minimum fitness criteria set for qualification.

For CalTRACK electric billing period savings analysis, the following candidate models are fit:

$$UPD_{mi} = \mu_i + \beta_{Hi}HDD_m + \beta_{Ci}CDD_m +  \epsilon_{mi}$$

$$UPD_{mi} = \mu_i + \beta_{Hi}HDD_m + \epsilon_{mi}$$

$$UPD_{mi} = \mu_i + \beta_{Ci}CDD_m+ \epsilon_{mi}$$

$$UPD_{mi} = \mu_i + \epsilon_{mi}$$


with the constraints

$$\beta_H > 0$$

$$\beta_C > 0$$

$$\mu_i > 0$$

If parameter estimates are strictly positive, then the model qualifies for inclusion in model selection.


For CalTRACK gas billing period savings analysis, the following candidate models are fit:

$$UPD_{mi} = \mu_i + \beta_{Hi}HDD_m + \epsilon_{mi}$$

$$UPD_{mi} = \mu_i + \beta_{Ci}CDD_m+ \epsilon_{mi}$$

$$UPD_{mi} = \mu_i + \epsilon_{mi}$$

with the constraints

$$\beta_H > 0$$

$$\mu_i > 0$$

If each parameter estimate is strictly positive, then the model is a qualifying model for inclusion in model selection.

#### 4. Select the best for pre-intervenion and post-intervention periods for use in second-stage savings estimation


All qualifying pre-intervention models are compared to each other and among qualifying models, the model with the maximum adjusted R-squared will be selected for second-stage savings estimation.

For the billing period billing analysis, the adjusted R-squared will be defined as:


$$R^2_{adj} = 1 - \frac{(SS_{res}/df_e)}{(SS_{tot}/df_t)}$$


Where


\(SS_{res}\) is the sum of squares of residuals

\(df_e\) is the degrees of freedom of the estimate of the underlying population error variance, and is calculated using `n-p-1`, where `n` is the number of observations in the sample used to estimate the model and `p` is the number of explanatory variables, not including the constant term.

\(SS_{tot}\) is the total sum of squares

\(df_t\) is the degrees of freedom of the estimate of the population variance of the dependent variable, and is calculated as `n-1`, were `n` is the size of the sample use to estimate the model

All qualifying post-intervention models are compared to each other and among qualifying models, the model with the maximum adjusted R-squared will be selected for second-stage savings estimation.

#### 5. Estimate second-stage weather normalized metered energy savings quantities based on selected first stage pre- and post-intervention models

During the second stage, up to five savings quantities will be estimated for each site that meets the minimum data sufficiency criteria for that savings statistic.

1. Cumulative weather normalized metered energy savings over entire performance period
2. Year one annualized actual weather normalized metered energy savings in the the reporting (post-intervention) period
3. Year two annualized actual weather normalized metered energy savings in the the reporting (post-intervention) period
4. Year one annualized weather normalized metered energy savings in the normal year
5. Year two annualized weather normalized metered energy savings in the normal year

These site-level second stage quantities are calculated as follows:

#### Cumulative weather normalized metered energy savings over entire performance period (site-level)


1. Compute `predicted_baseline_use` for each complete billing period after `work_end_date` using parameter estimates from the stage one model from the pre-intervention (baseline) period model and the associated average degree days for each billing period in the post-intervention (reporting) period, ensuring that the same degree day values calculated for stage one model fits are use in stage two estimation.
2. Compute `billing_period_gross_savings` = `predicted_baseline_billing_period_use - actual_billing_period_use` for every complete billing periods after `work_end_date` for project
3. Sum  `billing_period_gross_savings` over every complete billing period since `work_end_date`.


#### Year one weather normalized metered energy savings from 1 to 12 billing periods after site visit. (site-level)


1. Compute `predicted_baseline_use` for each complete billing period after `work_end_date` until 12 billing periods after `work_end_date`  using parameter estimates from the stage one model from the pre-intervention (baseline) period model and the associated average degree days for each billing period in the post-intervention (reporting) period, ensuring that the same degree day values calculated for stage one model fits are use in stage two estimation.
2. Compute `billing_period_gross_savings` = `predicted_baseline_billing_period_use - actual_billing_period_use` for 12 complete billing periods after `work_end_date` for project
3. Sum  `billing_period_gross_savings` over the 12 billing periods since `work_end_date`.


#### Year two weather normalized metered energy savings from 13 to 24 billing periods after site visit. (site-level)


1. Compute `predicted_baseline_use` for each complete billing period starting 13 billing periods after `work_end_date` until 24 billing periods after `work_end_date`  using parameter estimates from the stage one model from the pre-intervention (baseline) period model and the associated average degree days for each billing period in the post-intervention (reporting) period, ensuring that the same degree day values calculated for stage one model fits are use in stage two estimation.
2. Compute `billing_period_gross_savings` = `predicted_baseline_billing_period_use - actual_billing_period_use` for billing period 13 to billing period 24 after `work_end_date` for project
3. Sum  `billing_period_gross_savings` over the 12 billing periods from billing period 13 after `work_end_date` to billing period 24.


#### Year one site-level annualized weather normalized metered energy savings in the normal year


1. Compute `predicted_baseline_billing_period_use` using the stage one model from the baseline period and average degree days from the CZ2010 normal weather year. Use the full billing period of available values when calculating the average degree days per billing period for the normal year.
2. Compute `predicted_reporting_billing_period_use` using a `stage one` model fit to only the first 12 billing periods of post-intervention values and degree days from the CZ2010 normal weather year file. Use all available billing period values when calculating the average degree days per billing period for the normal year.
3. Compute `billing_period_normal_year_gross_savings` = `predicted_baseline_billing_period_use - predicted_reporting_billing_period_use` for normal year billing periods
4. Sum  `billing_period_normal_year_gross_savings` over entire normal year.


#### Year two site-level annualized weather normalized metered energy savings in the normal year


1. Compute `predicted_baseline_billing_period_use` using the stage one model from the baseline period and degree days from the CZ2010 normal weather year.
2. Compute `predicted_reporting_billing_period_use` using a `stage one` model fit to only the 13th-24th billing periods of post-intervention values and degree days from the CZ2010 normal weather year file for the relevant billing periods.
3. Compute `billing_period_normal_year_gross_savings` = `predicted_baseline_billing_period_use - predicted_reporting_billing_period_use` for each normal year billing period.
4. Sum  `billing period_normal_year_gross_savings` over entire normal year.

### Post-estimation steps and portfolio aggregation

The goal of CalTRACK is to develop replicable, consistent, and methodologically defensible estimators of savings over **portfolios of homes**. In order to do that, the above site-level savings quantities must be aggregated to get portfolio-level totals, means, and variances. Taking the site-level estimates, CalTRACK then performs a set of aggregation steps that are specified [here](https://caltrack-2.github.io/caltrack/v1.0/aggregation/README/).

_________________________________________________________
