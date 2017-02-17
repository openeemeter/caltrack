
Data Cleaning Steps
===

Projects
---

- Read in Project Data files
- Read in Electric xRef file
- Create work Start and work End dates for the Project datasets based on revised criteria
- Stack Project datasets on top of each other
- Inner join Project dataset and Electric xRef on Electric SA ID
- Create work End date for row that was missing it (work Start + 60 days)
- Pick minimum work Start and maximum work End dates for each SP ID
- Calculate summary statistics