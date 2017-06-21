# CalTRACK Methods Repository

A shared repository for the discussion, testing, and publication of CalTRACK methods

-----

The CalTRACK open source repository is intended to facilitate the discussion, testing, refining and publication of the technical requirements and methods for CalTRACK. 

This repository is organized for sharing methods documentation as well as sharing data, and outputs from empirical tests of the methods.

The repository is structured as follows:

``/docs`` contains Markdown files for publishing the official CalTRACK technical specification, guidance, and methods, which are published at [docs.caltrack.org](http://docs.caltrack.org).

``/tests`` contains detailed documentation and results from empirical tests of various versions of the CalTRACK methods by CalTRACK methods testers.

---
**CalTRACK Methods Documentation**

The complete technical specification for CalTRACK is found at [docs.caltrack.org](http://docs.caltrack.org). The source files for this online documentation located in the `docs/` directory of this repository. If you notice problems with the online documentation or would like to raise a methodological issues for discussion by the community for inclusion in future versions of CalTRACK, please create an github issue and link to the relevant page in the documentation.

----

**CalTRACK Methods Empirical Testing**

A goal of CalTRACK is to develop standard methods alongside empirical testing. This testing includes data preparation and cleaning, site-level analysis, and aggregation of site-level results.

Testers of the CalTRACK methods are encouraged to commit detailed documentation of their testing of both draft versions and official release versions of the CalTRACK specification, along with aggregate results from these tests. Prior contributions by testers can be found in the 'tests/' directory. The directory is organized as follows:

1. `tests/data-sources/` includes descriptions of the data requirements for testing CalTRACK methods, with additional specificity about the official testing dataset provided by PG&E. Additionally, this directory includes some publicly available data for use by testers.
2. `tests/data-prep/` includes descriptions of the sequence of steps used by testers in preparing the official testing dataset for analysis as well as audited results of what projects dropped out as a result of tests.
3. `tests/analysis/monthly/` includes descriptions of the methods use for calculating site-level savings, suggestions for testing outputs that could be helpful for cross-tester comparisons, as well as aggregate output files by various testers
4. `tests/aggregation/` includes descriptions of the methods use for aggregating site-level savings to group or portfolio average and total savings, suggestions for aggregate outputs that could be helpful for comparative testing, as well as aggregate output files by various testers


