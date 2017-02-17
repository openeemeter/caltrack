#### The following data cleaning steps were performed to produce the final tables on which our summary statistics are based.

- Load electric and gas cross reference tables
- Check for duplicate SAIDs in xref tables:
    - There are no duplicates in the gas table
    - There are 10 duplicates in the electric table; 5 SAIDs, each of which corresponds to 2 SPIDs
	    - For each of these pairs of SPIDs, one of them doesn't correspond to 60 min usage data so remove that row (all 5 SAIDs remain in the table).


- Merge the three project data tables (choosing and renaming date fields in the AHUP file as specified in the readme)
- Check to make sure every row has a start and end date:
    - No rows are missing start dates
    - One row is missing an end date: for this row fill the end date as `start date + 60 days`


- Remove rows from the cross reference tables that are not associated with projects (because we don't have zip codes for those accounts).


- Remove rows from the projects table that we don't have cross reference data for (projects without SAID-SPID pairs).
    - 444 Electric SAIDs were removed
- Add SPID column to the projects table using electric and gas cross reference tables
- Check for duplicate SPIDs in projects table
    - 28 duplicates are found
- Merge these duplicates
    - After merge, 11 SPIDs have conflicts in their start/end dates (the other duplicates had the same dates)
    - One duplicate has a conflict in the Electric SAID (two SAIDs corresponding to a single SPID)
- For SPIDs with conflicting start dates, set the date range as instructed in the readme


- Load the 60 minute usage data (removing all the extra white space that bloated the file size)
- Remove net metered SAIDs - defined as SAIDs that are either specified as net metered in the electric cross reference table, or they are SAIDs for which there is a row in the usage data with `DIR == 'R'`
    - ** FOR DISCUSSION: should we go further and remove any rows for the corresponding SPID?**
    - There are 305 net metered SAIDs in the cross reference table
    - There are 1149 net metered SAIDs in the usage data (and these are dropped from the usage data)
    - 874 net metered SAIDs are missing flags in the cross reference table
- Add net metering flags to the 874 missing SAIDs in the electric cross reference table
- Remove rows from usage data with SPIDs that are not in the project table (because we don't have zip codes for them)
    - 560 SPIDs were dropped (1015 SAIDs)
- Usage data deduplication: there are some duplicate rows for SPID + DATE, all of which are exact duplicates (not distinct).  These duplicates are merged.
