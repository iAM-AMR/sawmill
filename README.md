
[![TLP White Level Badge](https://img.shields.io/badge/TLP-WHITE-lightgrey)](https://github.com/iAM-AMR/start_here/blob/main/sharing.md)
[![Version Badge](https://img.shields.io/badge/VERSION-3.0.2-blue)](https://github.com/iAM-AMR/sawmill/releases) 

```
 ______     ______     __     __     __    __     __     __         __        
/\  ___\   /\  __ \   /\ \  _ \ \   /\ "-./  \   /\ \   /\ \       /\ \       
\ \___  \  \ \  __ \  \ \ \/ ".\ \  \ \ \-./\ \  \ \ \  \ \ \____  \ \ \____  
 \/\_____\  \ \_\ \_\  \ \__/".~\_\  \ \_\ \ \_\  \ \_\  \ \_____\  \ \_____\ 
  \/_____/   \/_/\/_/   \/_/   \/_/   \/_/  \/_/   \/_/   \/_____/   \/_____/ 
```

# sawmill: an R package to use CEDAR data for an iAM.AMR model

The [iAM.AMR](https://github.com/iAM-AMR) models are informed by one or more queries (*timber*) from the CEDAR (*Collection of Epidemiologically Derived Associations with Resistance*) database. The **sawmill** package processes timber by performing basic quality control, calculating model parameters (e.g., odds ratios), and performing meta-analyses. 

- [sawmill: an R package to use CEDAR data for an iAM.AMR model](#sawmill-an-r-package-to-use-cedar-data-for-an-iamamr-model)
  - [Installation and Use](#installation-and-use)
    - [Before You Start](#before-you-start)
    - [Install sawmill](#install-sawmill)
    - [Install sawmill for Developers](#install-sawmill-for-developers)
    - [Use sawmill](#use-sawmill)
    - [Use sawmill with a cached copy of timber](#use-sawmill-with-a-cached-copy-of-timber)
    - [Update sawmill](#update-sawmill)
      - [v3.0.0 and later](#v300-and-later)
      - [v2.4.0 or earlier](#v240-or-earlier)
  - [Get Help](#get-help)
    - [FAQ](#faq)
      - [What is CEDAR? iAM.AMR?](#what-is-cedar-iamamr)
      - [Why is an R package, and why do I need this one?](#why-is-an-r-package-and-why-do-i-need-this-one)
      - [I normally install packages from CRAN using `install.packages()`; why doesn't this work for `sawmill`?](#i-normally-install-packages-from-cran-using-installpackages-why-doesnt-this-work-for-sawmill)
      - [Where can I find more information about the package or individual functions?](#where-can-i-find-more-information-about-the-package-or-individual-functions)
    - [Contact](#contact)


## Installation and Use

### Before You Start

Before you start, we reccomend you install a modern (v4+) version of [R](https://cran.r-project.org/) and the latest version of [RStudio](https://www.rstudio.com/).

See the documentation for instructions on installing R and RStudio [without administrative privileges](https://docs.iam.amr.pub/en/latest/09_technology/software.html).


### Install sawmill

To install **sawmill** using the bootstrap method (recommended), follow [the instructions](bootstrap/) to download and execute the [bootstrap.R](bootstrap/bootstrap.R) script. 


### Install sawmill for Developers

To build **sawmill** locally:

1. Use the ![Code Badge](https://img.shields.io/badge/-Code-brightgreen) button above to clone or download the repo. 
1. Launch the `sawmill.Rproj` in RStudio
1. Use *Install and Restart* in the *Buid* tab to build and attach the package locally.


### Use sawmill

- Obtain a *timber* file in .xlsx format.
  - **sawmill** currently **does not support .CSVs**.
  - [How to convert a .csv to a .xlsx.](https://www.howtogeek.com/770734/how-to-convert-a-csv-file-to-microsoft-excel/).
  - The column specification is given in [raw_timber_specs.csv](inst/raw_timber_specs.csv).  
- To run the interactive pipeline with default settings, use: `sawmill::start_mill()`.
- To specify custom settings, use: `sawmill::mill()`. 
  - To see the supported arguements, use: `?sawmill::mill()`.

### Use sawmill with a cached copy of timber

A cached copy of a timber object with all resistance-outcomes in CEDAR is included as  `local_timber`. To use this cached copy, first filter as necessary, then write to a .CSV. Open this file in Excel or another editor to make any required changes (e.g., add meta-analysis groupings), and save as a .XLSX. Then, use **sawmill** as instructed above. An exmaple of the R code:

```
library(tidyverse)

local_timber %>% 
  dplyr::filter(is_archived == FALSE,                     # Filter out archived references
                is_excluded_extract == FALSE,             # Filter out excluded references
                capture_search_2019 == TRUE) %>%          # Select only the iAM.AMR.SEARCH project references
  dplyr::select(-is_archived, -is_excluded_extract, -capture_search_2019, -cedar_extract_esr) %>%
  readr::write_csv(file.choose())
```

### Update sawmill

#### v3.0.0 and later

To update to the latest release, run `sawmill::update_sawmill()`.

#### v2.4.0 or earlier

To update to the latest release, navigate to [update_sawmill()](https://github.com/iAM-AMR/sawmill/blob/main/R/update_sawmill.R), and download/copy and run the script. 

Then run `update_sawmill()`.



## Get Help

### FAQ

#### What is CEDAR? iAM.AMR?

- CEDAR (*Collection of Epidemiologically Derived Associations with Resistance*) is a database of factors associated with antimicrobial resistance in the argi-food production system. 
  - See [the documentation](https://docs.iam.amr.pub/en/latest/cedar_database/cedar_database.html).
- iAM.AMR is the Integrated Assessment Model for Antimicrobial Resistance project.
  - See [the documentation](https://docs.iam.amr.pub/).
  - See [the GitHub Organization](https://github.com/iAM-AMR).


#### Why is an R package, and why do I need this one?

[According to Hadley Wickham and Jennifer Bryan](https://r-pkgs.org/intro.html):

> In R, the fundamental unit of shareable code is the package. A package bundles together code, data, documentation, and tests, and is easy to share with others.

When we export queries from CEDAR (which we call *timber*), they lack important information for modelling. The **sawmill** package is a collection of functions that prepare the queries for use in the iAM.AMR models.


#### I normally install packages from CRAN using `install.packages()`; why doesn't this work for `sawmill`?

`sawmill` is not currently available in CRAN.


#### Where can I find more information about the package or individual functions?

Try accessing the individual function help files -- using R's `?function()` notation -- or consulting the iAM.AMR project's [documentation](https://docs.iam.amr.pub). 

`sawmill` is set up so that its main functions (a.k.a. main steps in the processing pipeline) exist within their own `.R` files, found in the [R](R) directory of this repository. For example, the function `sawmill::debark()` is found in [debark.R](R/debark.R). To access the help file for this function, enter `?debark()` or `?sawmill::debark()` into the RStudio console. M


### Contact

Created by @chapb and @phillipsclynn.
Maintained by [@chapb](https://chapmanb.com/).
