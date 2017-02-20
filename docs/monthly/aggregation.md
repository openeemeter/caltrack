# Aggregating Site-level Gross Savings and Quantifying Uncertainty in Aggregate Savings Statistics

-----------

The goal of CalTRACK is to develop replicable, consistent, and methodologically defensible estimators of savings over **portfolios of residential single family buildings**.

Portfolio-level savings statistics are based on aggregations of site-level savings gross savings estimates created using the CalTRACK site-level monthly gross savings analysis methods.

Because all site-level savings quantities generated using CalTRACK's technical specifications are based on time series predictions, portfolio-level savings statistics primarily use prediction errors to estimate of site-level uncertainty, and calculate portfolio-level averages using inverse variance weighted means to get a consistent estimator of mean portfolio-level savings.

## Monthly Savings Estimate Aggregation Procedure

The main portfolio-level statistics of interest for CalTRACK are:

- Weighted mean annualized gross savings
- Variance annualized gross savings
- Annualized gross savings prediction intervals (+/- 95%)
- Unweighted total annualized gross savings
- Weighted mean cumulative gross savings
- Cumulative gross savings prediction intervals (+/-95%)
- Unweighted total cumulative gross savings
- Weighted mean year-one gross savings
- Year-one gross savings prediction intervals (+/-95%)
- Unweighted total year-one gross savings
- Weighted mean year-two gross savings
- Year-two gross savings prediction intervals (+/-95%)
- Unweighted total year-two gross savings

### Steps for calculating aggregate uncertainty and aggregate means.

While a detailed treatment of how to calculate each of these quantities is included below, the main formulations are below:

1. Calculate the site-level Mean Squared Error (MSE) as an unbias estimator of the variance of the model errors, $s^2$ :

$$s^2 = \sum{\frac{\hat{u}_i^2}{N−k}}$$

2. Calculate the site-level savings variance using in prediction error as an consistent estimator using the MSE, $s^2$, and variance in the out-of-sample data, $x_0$:

$$\hat{V}_s = s^2*x_0*(X'X)^{−1} * x_0' + s^2$$

3. Calculate portfolio site-level inverse variance weighted mean savings using the savings variance and the following equation:

![Equation for inverse variance weighting](https://www.dropbox.com/s/353ssd5u7725a7c/Screenshot%202016-10-20%2010.49.07.png?raw=true)

#### Included Summary statistics for Portfolios of Sites

- Weighted mean annualized gross savings
- Variance annualized gross savings
- Annualized gross savings prediction intervals (+/- 95%)
- Unweighted total annualized gross savings
- Weighted mean cumulative gross savings
- Cumulative gross savings prediction intervals (+/-95%)
- Unweighted total cumulative gross savings
- Weighted mean year-one gross savings
- Year-one gross savings prediction intervals (+/-95%)
- Unweighted total year-one gross savings
- Weighted mean year-two gross savings
- Year-two gross savings prediction intervals (+/-95%)
- Unweighted total year-two gross savings


#### Calculating site-level prediction intervals

For simplicity, and keeping with convention in the industry, site-level variance estimates based on ordinary least squares regressions will use OLS prediction error as the estimator for savings variance. Prediction error is calculated as follows:

Take the stage one regression model with N observations and k regressors:

$$y = X\beta + u$$

Given a vector (or matrix) $x_0$ of post-intervention (reporting) period degree day covariates, the predicted value for  observation would be

$$E[y|x_0] = \hat{y}_0 = x_0\beta$$

A consistent estimator of the variance of this prediction is

$$\hat{V}_p = s^2*x_0*(X'X)^{−1} * x_0$$

where

$$s^2 = \sum{\frac{\hat{u}_i^2}{(N-k)}}$$

and \(X\) is the matrix of stage one covariates.

The forecast error for a particular $y_0$ is

$$\hat{e} = y_0 − \hat{y}_0= x_0\beta + u_0 − \hat{y}_0$$

The zero covariance between $u_0$ and $\hat{β}$ implies that

$$Var[\hat{e}] = Var[\hat{y}_0] + Var[u_0]$$

and a consistent estimator of that is

$$\hat{V}_s=s^2*x_0*(X'X)^{−1} * x_0' + s^2$$

The \(1−\alpha\) site-level confidence interval will be:

$$y_0 ± t_(1−\alpha/2) * (\hat{V}_p)^.5$$

The \(1−α\) confidence interval on the savings will be wider, based on the estimated savings variance:

$$y_0 ± t_(1−\alpha/2) * (\hat{V}_s)^.5$$


#### Calculating Inverse-variance Weighted Portfolio Savings Means for Monthly Savings Analysis

Using site-level forecast variance as the consistent estimator of site-level gross savings estimation, CalTRACK calculates the inverse-variance weighted mean for each portfolio according to the following equation:

$$\hat{y} = \frac{\sum_i{y_i/ \sigma_i^2}}{\sum_i{1/ \sigma^2_i}}$$

#### Calculating uncertainty for daily and hourly methods

While sampling methods would actually be preferable for characterizing the posterior distribution of savings estimates using higher-frequency AMI data, due to lack of adoption of Bayesian methods in industry and increased computational complexity, CalTRACK use more frequently adopted.

The two primary considerations for higher-frequency savings models are the need to take into account stronger autocorrelation and increased model specification error.

M&V standards for industrial savings estimation, which has been dealing with AMI data longer, provides useful guidance for dealing with these two considerations. Following ASHRAE Guideline 14-2002, and augmenting work done by the NW SEM Collaborative, CalTRACK employs the following method:

##### Fractional Savings uncertainty calculation

Because variances are larger in larger homes, normalizing levels of uncertainty using fractional savings uncertainty is an important aggregate metric, both for model comparison and selection, as well as final output. CalTRACK will compute the Fractional Savings Uncertainty at the site level based on the following equation:

![Equation](https://www.dropbox.com/s/lca8colvkqgrtyd/Screenshot%202016-10-20%2010.28.22.png?raw=true)

Where

$CV$ is the coefficient of variance on the savings mean using prediction errors specified above
$t$ is the relevant t-statistic for the desired level of confidence
$F$ is the relevant F-statistic given degrees of freedom for the selected model

##### Calculating 95% confidence intervals using fractional savings uncertainty

To calculate confidence intervals using the following equation:

$$CI(95) = +/- (FSU * 1.96) * 100$$

#### Note on the lack of comparison group adjustments in CalTRACK technical specification

While the technical working group acknowledged the potential use of comparison groups in gross savings estimation to correct for population-wide exogenous effects on use, after extensive debate, it was decided that the CalTRACK use cases (pay-for-performance in particular) required the ability for non-utility actors to be able to estimate savings without access to comparison group data. While several ideas were developed through the technical working group process about how to address this issue, there were serious concern about feasbility.
