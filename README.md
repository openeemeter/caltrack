# CalTRACK Methods Repository

A shared repository for the discussion, testing, and publication of CalTRACK methods

-----

The CalTRACK open source repository is intended to facilitate the discussion, testing, refining and final publication of the technical requirements and methods for CalTRACK. Initial draft requirements for CalTRACK developed by the technical working group are tested using data from PG&E to empirically verify assumptions made by the technical working group, identify areas of sensitivity, and agree on publishable versions of the methods. Details about the CalTRACK technical working group processes can be found [here](http://www.caltrack.org/methods-dev-process.html).

This repository is organized for sharing methods documentation as well as sharing data, code, and outputs from empirical tests of the methods.

The repository is structured as follows:

``/docs`` contains Markdown files for publishing the official CalTRACK technical specification, guidance, and methods, which are published at [docs.caltrack.org](http://docs.caltrack.org).

``/tests`` contains detailed documentation, code, and results from empirical test of various versions of the CalTRACK methods by CalTRACK methods testers.

---
**CalTRACK Methods Documentation**

The complete technical specification for CalTRACK is found at [docs.caltrack.org](http://docs.caltrack.org). The source files for this online documentation located in the `docs/` directory of this repository. If you notice problems with the online documentation or would like to raise a methodological issues for discussion by the community for inclusion in future versions of CalTRACK, please create an github issue and link to the relevant page in the documentation.

----

**CalTRACK Methods Empirical Testing**

One of the goals of CalTRACK is to do standard methods development along side empirical methods testing. This testing includes data preparation and cleaning, site-level analysis, and aggregation of site-level results.

Testers of the CalTRACK methods are encouraged to commit detailed documentation of their testing of both draft versions and official release version of the CalTRACK specification, along with aggregate results from these tests. Prior contributions by testers can be found in the 'tests/' directory. The directory is organized as follows:

1. `tests/data-sources/` includes descriptions of the data requirements for testing CalTRACK methods, with additional specificity about the official testing dataset provided by PG&E. Additionally, this directory includes some publicly available data for use by testers.
2. `tests/data-prep/` includes descriptions of the sequence of steps used by testers in preparing the official testing dataset for analysis as well as audited results of what projects dropped out as a result of tests.
3. `tests/analysis/monthly/` includes descriptions of the methods use for calculating site-level savings, suggestions for testing outputs that could be helpful for cross-tester comparisons, as well as aggregate output files by various testers
4. `tests/aggregation/` includes descriptions of the methods use for aggregating site-level savings to group or portfolio average and total savings, suggestions for aggregate outputs that could be helpful for comparative testing, as well as aggregate output files by various testers

### Supported Use Cases

The CalTRACK methods have been developed to produce a reliable estimate of basic, weather normalized gross savings at the site level and weighted average gross savings for groups (or portfolios) of projects.

This definition of gross savings was developed with two specific use cases in mind, and was not intended to extend to all potential uses of  savings estimation.

The two core use cases that CalTRACK is intended to support are:

1. Calculating *payable savings* in the PG&E Residential Third-Party Pay-for-Performance pilot program. In this program, selected third party aggregators (organizations providing services that may lead to energy savings) are paid  based on the measured energy use reductions for homes they submit to PG&E as having received their services. Payments to these aggregators will be based on CalTRACK methods. The savings that the utility can claim was delivered as a result of the program will be measured through a separate EM&V process.
2. Calculating *realized savings and realization rates* for third-party software used to predict savings for residential efficiency projects for the purposes of determining rebates. Average empirical realization rates by vendor may be used to adjust rebates on an ongoing basis and provide feedback to vendors and contractors on their relative performance.  

### Further Considerations

1. The purpose of CalTRACK is to provides an estimate of weather normalized gross savings and is not a replacement for net savings measurement arrived at through impact evaluations.

Both aggregator and utility users of CalTRACK should be aware that the CalTRACK methods do not apply corrections for exogenous changes such as economic conditions, energy costs, unobserved weather effects, and other factors that may impact consumption patterns and savings at a population level.

----

**Contributing**

All contributors to the CalTRACK specification are welcome. Communication among committers and community members happens primarily through github issues on this repository, as well as through a CalTRACK Slack organization. Any suggestions and modifications to the methods are handled through an open source development process.

Working Group Contributors:

Leif Magnuson - PG&E

Matt Golden - Open Energy Efficiency

Matt Gee - Open Energy Efficiency

McGee Young - Open Energy Efficiency

Andy Fessel - PG&E

Jarred Metoyer - DNVGL

Jonathan Farland - DNVGL

Ben Polly - NREL

Beth Reid - Olivine

Brian A. Smith - PG&E

Charlene Chi-Johnston - PG&E

Cynthia Swaim - Sempra Utilities

Denise Parker - SoCal Edison

Gamaliel Lodge - Optimiser Energy

Jake Oster -  Energysavvy

John Backus Mayes - Energysavvy

Lisa Schmidt - Home Energy Analyzer

Martha Brook - CEC

Richard Ridge, PhD - PG&E

Robert Hansen - CPUC

Ryan Bullard - SoCal Edison

Torsten Glidden - Buid it Green

Alfredo Gutierrez - ICF

CalTRACK Lead Technical Consultants

The [Open Energy Efficiency](http://www.openee.io) team has functioned as Lead Technical Consultants to PG&E through all phases of the CalTRACK process. A complete history of this process that began in 2012 can be found on the [CalTRACK website](http://www.caltrack.org/caltrack-history.html). Open Energy Efficiency is also the developer of the open source [OpenEEmeter](http://www.openeemeter.org) platform which was developed in part with funding from the California Energy Commission.
