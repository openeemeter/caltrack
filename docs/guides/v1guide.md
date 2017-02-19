# Using the CalTRACK v1.0 Normalized Metered Monthly Gross Savings Methods

The CalTRACK Version 1.0 specification provides guidance for performing monthly billing analysis for whole home weather normalized gross savings for groups of residential energy efficiency projects.

It includes data requirements and technical specifications for data preparation and cleaning, site-level billing analysis, and aggregation of site-level results.

The complete technical specification for v1 monthly methods is found in four documents

1. `/monthly/data-sources.md` describes the necessary data requirements for running CalTRACK v1
2. `/monthly/data-prep.md` describes the sequence of steps required for preparing data for analysis
3. `/monthly/analysis.md` describes the methods use for calculating site-level savings using monthly data
4. `/monthly/aggregation.md` describes the methods use for aggregating site-level savings to group or portfolio average and total savings

The specification is intended to be done in order to ensure consistency and replicability.

### Supported Use Cases

The CalTRACK v1 monthly billing analysis methods have been developed to produce a reliable estimate of basic, weather normalized metered gross savings at the site level and weighted average gross savings for groups (or portfolios) of projects.

This definition of gross savings was developed with two specific use cases in mind, and was not intended to extend to all potential uses of monthly billing analysis.

The two use cases that CalTRACK v1 is intended to support are:

1. Calculating *payable savings* in the PG&E Residential Third-Party Pay-for-Performance pilot program. In this program, selected third party aggregators (organization providing services that may lead to energy savings) are paid based on the Normalized Metered Savings for homes they submit to PG&E as having received their services. Payments to these aggregators will be based on CalTRACK methods. The savings that the utility can claim was delivered as a result of the program will be measured through a separate EM&V process.

2. Calculating *realized savings and realization rates* for third-party software used to predict savings for residential efficiency project for the purposes of determining rebates. Average empirical realization rates by vendor may be used to adjust rebates on an ongoing basis and provide feedback to vendors and contractors on their relative performance.  

### Notes on key CalTRACK v1 decisions and their implications

1. Fixed Degree Day Base. While it is more common in industry to use a variable degree day base temperatures in monthly billing analysis, the CalTRACK technical working group decided to use fixed degree day base temperatures. This decision was made after empirical testing of both fixed and variable degree day basis showed that, for a sample of 3000 projects done from 2014-2016 in PG&E territory there was little difference in average savings between the two methods, the use of variable degree days contributed to significant differences in savings among testers. The technical working group made the determination that, since replicability was a priority for the two supported use cases, the added replicability of the fixed degree day approach made it the better choice for CalTRACK v1 methods.

2. Inverse Variance Weighted Means for determining aggregate savings. In determining the average savings over groups of homes, inverse variance weighted means offers a way of dealing with the important consideration that not all site-level savings estimates are equally confident. IVWM emphasizes the savings of homes with good site-level model fits, while deemphasizing sites with poor model fits. This approach comes from meta analysis and is the minimum-variance estimator of a group mean under assumptions of conditional independence. However, two challenges arise in applying IVWMs to group savings. 1) The independence assumption may not hold over areas or time periods because of structural correlation in savings. This means it may be underestimating variances due to correlation structure in the errors. Practically, this may introduce bias in the group mean depending on the correlation structure 2) larger homes will tend to have large variances and smaller homes (and gas use which is closer to 0 in many homes), leading to a potential structural underestimate of group average savings because smaller savings will have smaller variances. 3) sites with very low variances (very close to zero) can lead blow up mean savings estimates (dividing by very small numbers) and require addition checks on the final number used for programmatic purposes. Alternative weighting schemes were discussed by the technical working group, but none were ultimately selected due to similar tradeoffs faced by each weighting scheme. Users of the v1 methods should be aware of the ways that IVWMs both solves for and also creates risks to program implementation and chose the right approach and risk mitigation procedures for the program accordingly.

### Important Caveat

1. The purpose of CalTRACK is to provide estimates of Normalized Metered Gross Savings and does not replace EM&V to arrive at net savings measurement. 

### Discussions

1. [Project Plan and Technical Requirements Working Group Document] (https://docs.google.com/document/d/1mfNgJwzHUrp8SKNVeK8PH0Sjbt8xDb_s3FLblG9A2Qw/edit#heading=h.56f2ui64an9j)
2. [Homes with Solar, EVs, etc.] (https://github.com/impactlab/caltrack/issues/36)
3. [Missing and anomalous data] (https://github.com/impactlab/caltrack/issues/35)
4. [Zip Code Weather Station mapping] (https://github.com/impactlab/caltrack/issues/25)
5. [Data prep] (https://github.com/impactlab/caltrack/issues/12)
6. [Monthly Data Requirements Specification] (https://github.com/impactlab/caltrack/issues/49)
7. [Aggregation rules] (https://github.com/impactlab/caltrack/issues/32)
8. [Future Participant Adjustments] (https://github.com/impactlab/caltrack/issues/20)
9. [Fixed or variable degree days] (https://github.com/impactlab/caltrack/issues/37)
