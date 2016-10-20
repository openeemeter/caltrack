# Aggregating Savings Over Groups of Homes and Quantifying Uncertainty in Aggregate Savings Statistics

The goal of CalTrack is to develop replicable, consistent, and methodologically defensible estimators of savings over portfolios of homes. 

For CalTrack, porfolio-level savings will use inverse variance weighted means. This requires an estimate of variance. 
     
## Monthly Savings Estimate Aggregation Procedure

#### Estimating uncertainty on monthly savings estimates

For simplicity, and keeping with convention in the industry, site-level variance estimates based on ordinary least squares regressions will use OLS prediction error for savings variance. Prediction error is calculated as follows:

Take the stage one regression model with N observations and k regressors:

`y=Xβ+u`

Given a vector x0 of reporting period, the predicted value for that observation would be

`E[y|x0]=ŷ 0=x0β.`

A consistent estimator of the variance of this prediction is

`V̂ p=s2⋅x0⋅(X′X)−1x′0,`

where

`s2=ΣNi=1û 2iN−k.`

The forecast error for a particular y0y0 is

`ê =y0 − ŷ0= x0β + u0 − ŷ0.`

The zero covariance between u0u0 and β̂ β^ implies that

`Var[ê]=Var[ŷ 0]+Var[u0],`

and a consistent estimator of that is

`V̂ f=s2⋅x0⋅(X′X)−1x′0+s2.`

The `1−α` confidence interval will be:

`y0±t1−α/2⋅V̂ p‾‾‾√.`

The 1−α prediction interval will be wider:

`y0±t1−α/2⋅V̂ f‾‾‾√.`


## Inverse-variance Weighted Portfolio Savings Means for Monthly Savings Analysis

Using `V̂`, CalTrack will calculate the inverse-variance weighted mean for each portfolio according to the following equation:

#### Estimating uncertainty on daily savings estimates

While sampling methods would actually be preferable for characterizing the posterior distribution of savings estimates using higher-frequency AMI data, due to lack of adoption of Bayesian methods in industry and increased computational complexity, we propose CalTrack use closed-form methods with a few caveats.

The two primary considerations for higher-frequency savings models are the need to take into account stronger autocorrelation and increased model specification error. 

M & V standards for industrial savings estimation, which has been dealing with AMI data longer, provides useful guidance for dealing with these two considerations. Following ASHRAE Guideline 14-2002, and augmenting work done by the NW SEM Collaborative, we propose the following method:

##### Fractional Savings uncertainty

CalTrack will compute the Fractional Savings Uncertainty at the site level based on the following equation:



##### Calculating 95% confidence intervals using frational savings uncertainty
  
To calculate confidence intervals using the following equation:

CI(95) = +/- (FSU * 1.96) * 100

