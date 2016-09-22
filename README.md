# Caltrack Betatest

A Shared repository for beta testers of Caltrack methods

====

The CalTrack Beta Test is intended to help test, refine and finalize the technical requirements and methods for CalTRACK. In it, the nitial draft requirements for CalTRACK developed by the technical working group will be tested in the field using data from PG&E to empirically verify assumptions made by the technical working group, identify areas of sensitivity, and agree on a first implementable system. Details about the Beta Test plan can can be found here. 

This repository is meant as a place for Beta Testers to share data, code, and outputs for comparison. The repository is structured in teh following way:

``/data-sources`` contains a README with links and descriptions of each of the required datasets for the beta test. It also contains the weather station mapping file.

``/data-prep`` contains a README that outlines CalTRACK data cleaning and integration proceedures. It is also the repository for sharing data preparation code and summary statistics on the prepared among Beta Testers for comparison.

``/analysis`` contains a README that outlines CalTRACK general data analysis proceedures. It also contains three subdirectories: `/monthly`, `/daily`, `/hourly`. These directories contain READMEs with detailed technical guidance for month, daily, and hourly savings analysis under CalTrack. Each of these directories will be used by Beta Testers to share data analysis code and testing outputs for the respective type of analysis performed.

``/aggregation`` contains a README that outlines CalTRACK aggregation proceedures. It is also the repository for sharing data aggregation code and outputs among from Beta Testers for comparison.
 
=========

Communication for the project will happen primarily on Slack. Any relevant changes to the technical specification outlined in the CalTrack Beta READMEs will be discussed and resolved as Github issues on this repository

Contributors:

1. [Impact Labs](www.impactlabs.com)
2. [EnergySavvy](www.energysavvy.com)
3. [DNV GL](www.dnvgl.com)





