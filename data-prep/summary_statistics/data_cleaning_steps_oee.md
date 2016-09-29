
Data Cleaning Steps
===

Projects
---

- Load electric and gas cross reference tables
- Concatenate the three project files
- Count total number of projects
- Estimate project dates
    - No rows are missing start dates
    - One row is missing an end date: for this row fill the end date as `start date + 60 days`
- Try to assign electric SPID to each project using cross-reference files
    - Map `Electric Service ID` to `sa_id`
    - 3 projects match multiple SPIDs, just use the first one (**What should actually be done here?**)
- Filter out projects with no SPIDs
- Merge projects with identical SPIDs
    - Use the earliest start date and latest end date
- Compute the rest of the project summary stats

Hourly Electricity Consumption
---

- Build list of net metered SAIDs
    - Any row with `DIR == 'R'`
    - Crossref column `net_mtr_ind == 'Y'`

- Filter any rows with SPID that isn't in the cleaned project table

- Remove duplicate rows (identical SPID, DATE, and usage data)