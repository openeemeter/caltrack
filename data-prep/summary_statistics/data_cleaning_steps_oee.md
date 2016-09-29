
Data Cleaning Steps
===

Preprocessing
---

- Gather all SPIDs from hourly electricity consumption
- Gather all net metered SAIDs from hourly electricity consumption and crossref file
    - Any row with `DIR == 'R'`
    - Crossref column `net_mtr_ind == 'Y'`

Projects
---

- Load electric and gas cross reference tables
- Concatenate the three project files
- Count total number of projects
- Estimate project dates
    - No rows are missing start dates
    - One row is missing an end date: for this row fill the end date as `start date + 60 days`
- Try to assign electric SPID to each project using cross-reference files
    - Ignore crossrefs that don't have a corresponding SPID in consumption files
    - Map `Electric Service ID` to `sa_id`
    - 3 projects match multiple SPIDs, just use the first one (**What should actually be done here?**)
- Filter out projects with no SPIDs
- Filter out projects with SAIDs that correspond to net metered consumption traces
- Merge projects with identical SPIDs
    - Use the earliest start date and latest end date
- Compute the rest of the project summary stats

Hourly Electricity Consumption
---

- Filter any rows with net metered SAIDs
- Filter any rows with SPID that isn't in the cleaned project table
- Remove duplicate rows (identical SPID, DATE, and usage data)

Data Integration Summary Stats
---

- Percent matching defined as: `count cleaned projects` / `count raw projects`