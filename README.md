# **CalTRACK Executive Summary**


**Definition**

 

CalTRACK is a set of methods for calculating site-based, weather-normalized, metered energy savings from an existing conditions baseline and applied to single family residential retrofits using data from utility meters.

 

**Scope**

 

CalTRACK can be used by Program Administrators or third party implementers for managing energy efficiency programs. CalTRACK also supports Pay-for-Performance programs by tracking metered savings using calculations that are transparent and replicable. When both parties - purchaser and vendor - use the same standardized set of methods for calculating energy savings, a mature and robust energy efficiency market is possible.

 

CalTRACK attempts to comply with[ AB-802](https://leginfo.legislature.ca.gov/faces/billNavClient.xhtml?bill_id=201520160AB802) (Williams, 2015) and[ SB-350](https://leginfo.legislature.ca.gov/faces/billNavClient.xhtml?bill_id=201520160SB350) (de León, 2015).

 

CalTRACK calculates the whole-building site-based savings that result from any mix of measures, building types, and consumer behavior. CalTRACK does not estimate the amount of savings that can be attributed to a particular measure.

 

CalTRACK does not take the place of program evaluation. Calculating site-based, weather normalized metered energy savings is often a first step in a program evaluation, but a full evaluation that seeks to control for other effects, such as exogenous factors like economic growth or technology adoption or endogenous factors like socioeconomic status would be expected to consider additional variables.

 

These methods focus specifically on calculating site-based, weather-normalized metered energy savings for determining payments under a Pay-for-Performance program, rather than the more evaluation oriented guidance that is found in ASHRAE Guideline 14 or the Uniform Methods Project (UMP). CalTRACK methods do not require energy consumption data from a population of energy users beyond the treatment group.

 

The CalTRACK technical working group’s empirical testing of these methods is archived in a Github repository. The repository contains the results of a variety of tests related to the methods choices. In general, the group limited its discussions to focus on specific technical issues rather than on broader, policy-oriented issues. These discussions can be found in the "[Issues](https://github.com/impactlab/caltrack/issues?utf8=%E2%9C%93&q=is%3Aissue)" section of the[ CalTRACK Github repository](https://github.com/impactlab/caltrack). While summary statistics are presented for both monthly and daily analysis, the intent was to use testing to inform methods guidance rather than to provide for a software equivalency testing process.

 

The CalTRACK methods were informed by and developed in concert with empirical testing by members of the CalTRACK technical Working Group listed below.

 

The empirical testing and refinement of the methods was performed using historical program data supplied by PG&E from an existing home upgrade program and included data from 4,777 homes that were retrofitted during 2014 and 2015. The CalTRACK methods include instructions for data cleaning and formatting as well as a two-stage model for calculating savings and aggregating site based savings into portfolios. The results of the methods testing as well as the deliberations of the working group are documented in GitHub.

 

CalTRACK allows third-party energy efficiency program implementers to conduct energy savings analysis on their own customers themselves, provided they are given access to their customers’ energy consumption data via Green Button or other means. This ability to track program performance in real time gives implementers an essential tool to monitor their performance and adjust their implementation practices. It also allows aggregators to quantify their expected yields for Pay-for-Performance programs.

 

**Methods**

 

The technical working group arrived at two sets of methods specifications, the first for calculating savings using monthly data, and the second for calculating savings using daily data. These methods are referred to as Monthly and Daily, respectively, and have each been tagged with a version number of 1.0.

 

The purpose of versioning the CalTRACK methods specification that informed the initial guidance is to lay the foundation for further efforts to refine and expand upon these methods. We invite collaboration from stakeholders to perform their own empirical tests of these methods and to offer suggestions for improvement, ideas for how to handle edge cases, or provide further tests to identify potential issues.

 

We have taken this first step towards an empirically-informed, professionally-tested, and transparent set of methods. We encourage others to work together to continue to make progress.

 

**CalTRACK Working Group**

 

●   *Leif Magnuson - PG&E Project Lead*

●  	*Matt Golden - Open Energy Efficiency**

●  	*Matt Gee - Open Energy Efficiency**

●  	*McGee Young - Open Energy Efficiency**

●  	*Ken Agnew – DNVGL**

●  	*Jarred Metoyer – DNVGL**

●  	*Jonathan Farland – DNVGL**

●  	*Ben Polly - NREL*

●  	*Brian A. Smith - PG&E*

●  	*Charlene Chi-Johnston - PG&E*

●  	*Cynthia Swaim - Sempra Utilities​*

●  	*Denise Parker - SoCal Edison*

●  	*Gamaliel Lodge - Optimiser Energy*

●  	*Jake Oster -  EnergySavvy**

●  	*John Backus Mayes – EnergySavvy**

●  	*Blake Hough – EnergySavvy**

●  	*Lisa Schmidt - Home Energy Analyzer*

●  	*Martha Brook - CEC*

●  	*Richard Ridge, PhD - PG&E*

●  	*Robert Hansen - CPUC*

●  	*Ryan Bullard - SoCal Edison*

●  	*Torsten Glidden - Build it Green*

●   *Alfredo Gutierrez - ICF*

●   *Able Gomez - RHA*



*Open Energy Efficiency, DNVGL, and EnergySavvy participated in methods development and testing for both monthly and daily methods.

 
