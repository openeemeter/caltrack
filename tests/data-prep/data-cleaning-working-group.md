Caltrack Working Group Data Cleaning
===

The cleaned gas data set includes monthly and daily gas traces and projects.

Input files
---

Elec Monthly:

```
EES25162.ERESBL12 (1).csv
EES25162.ERESBL13.csv
EES25162.ERESBL15.csv
EES25162.ERESBL16.csv
```

The following monthly files fail to read using Python `xport`:

```
EES25162.ERESBL14.XPT
EES25162.ERESBL16.JANJUNE.XPT
```

Elec Hourly

```
IDA.60MIN.SMY1.EES25162-EHUP.20160719161716.csv
```

Elec 15 minutely

```
IDA.15MIN.SMY1.EES25162-EHUP.20160719161716.csv
```

Elec Xref:

```
EES25162_ELECINTV_XREF_CPUC.csv
```

Gas Monthly: 

```
EES25162.G2RSBL12.csv  
EES25162.G2RSBL14.csv  
EES25162.G2RSBL16.csv  
EES25162.GRESBL13.csv  
EES25162.GRESBL15.csv  
EES25162.GRESBL16.JANJUNE.csv
EES25162.G2RSBL13.csv  
EES25162.G2RSBL15.csv 
EES25162.GRESBL12.csv  
EES25162.GRESBL14.csv  
EES25162.GRESBL16.csv
```

Converted from `xpt` format to `csv` using the Python `xport` package.

Gas Daily:

```
EES25162_gasdy_160720.csv  
EES25162_gasdy_160920.csv
```

Gas Xref:

```
EES25162_GASINTV_XREF_CPUC.csv
EES25162_GASINTV2_XREF_CPUC.csv
```

Projects:

```
Updated Final BIG Date Files%2FCalTrack (AHU) from 1_1_14__6_30_15_v2_FINAL_090816.csv  
Updated Final BIG Date Files%2FCalTrack (AHUP) from 1_1_14__6_30_15_v2_FINAL_090816.csv
Updated Final BIG Date Files%2FCalTrack (AHU) from 7_1_15__6_30_16_v2_FINAL_090816.csv
```

Cleaning Steps
---

**Elec Traces**

* Remove duplicates
  
  * Map dates to YYYY-MM-DD format for sorting
  * Sort by [DIR, SPID, DATE]
  * Remove rows that match neighboring row (188 rows removed from hourly, 566 rows removed from 15min)
  * No duplicates in monthly data

* Add leading zeroes to `PREM_ID` where missing (length == 8 or 9) in monthly traces.

* 3970 elec hourly traces with unique SP_ID
* 163 elec 15min traces with unique SP_ID
* 7702 elec monthly traces with unique SA_ID

**Gas Traces**

* Remove first two lines of daily csvs (extraneous header info)

    tail -n +3 EES25162_gasdy_160720.csv > EES25162_gasdy_160720.csv

* Check for duplicate rows in daily and monthly traces
    
    * Sort files, comparing neighboring rows
    * No duplicates found

* Add leading zeroes to `PREM_ID` where missing (length == 8 or 9) in monthly traces.

* 4224 gas daily traces with unique SP_ID
* 6919 gas monthly traces with unique SA_ID

**Elec Xrefs**

* Add leading zeroes to `char_prem_id` where missing (length == 8 or 9). Appear to have been lost during PGE's export process 

* Add `is_net_metered` column
  * Collect all SAIDs from 15min and hourly traces that have `DIR==R`
  * Map these SAIDs to corresponding `char_prem_id`
  * Mark crossrefs that match any of the found `char_prem_id`s OR have `net_mtr_ind==Y` as `is_net_metered=Y`
  * 1905 crossrefs marked as net metered, (688 with unique `char_prem_id`)

**For Caltrack data analysis: traces with `is_net_metered=Y` should be excluded from analysis.**

**Gas Xrefs**

* Concatenate two gas xref files

* Add leading zeroes to `char_prem_id` where missing (length == 8 or 9). Appear to have been lost during PGE's export process

**Projects**

* Concatenate three project files together

* Estimate project dates using Caltrack procedure

* Assign each project a `char_prem_id` using both elec and gas xref file 

    * Both `Gas Service ID` and `Electric Service ID` always map to the same `char_prem_id`

* Remove any project that did not get a `char_prem_id`

    * 4220 of 4358 projects received a prem id.

* Merge projects with identical `char_prem_id`

    * Earliest Work Start Date in merged project
    * Latest Work Finish Date in merged project
    * 4220 projects before merging premids
    * 4206 projects after merging premids

* Remove `Gas Service ID` and `Electric Service ID` from output. (Misleading since matching should be done with `char_prem_id` after cleaning)

Audit of Results
---

The assumption that both Electric and Gas SAIDs always map to the same Prem ID was checked.

The assumption that xrefs with the same SAID always map to the same Prem ID was checked.

Matching between gas traces and projects was audited:

  4206 total projects
  3862 daily gas traces matched using project.char_prem_id and trace.Service Point

  6355 monthly gas traces matched by said, with a total of 3957 unique resulting premids

  3957 monthly gas traces matched by premid (trace.PREM_ID)

So, monthly gas traces can be matched either directly with `PREM_ID` or via crossref with `SA_ID`.

Matching between elec traces and projects was audited:

142 15-minutely elec traces matched projects (out of 159 unique premids)

3706 hourly elec traces matched projects (out of 3965 unique premids)

3809 monthly elec traces matched projects (out of 4084 unique premids)


