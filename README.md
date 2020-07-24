
# sawmill
An R package used to prepare queries from CEDAR (timber) for use in the iAM.AMR models.


```
 ______     ______     __     __     __    __     __     __         __        
/\  ___\   /\  __ \   /\ \  _ \ \   /\ "-./  \   /\ \   /\ \       /\ \       
\ \___  \  \ \  __ \  \ \ \/ ".\ \  \ \ \-./\ \  \ \ \  \ \ \____  \ \ \____  
 \/\_____\  \ \_\ \_\  \ \__/".~\_\  \ \_\ \ \_\  \ \_\  \ \_____\  \ \_____\ 
  \/_____/   \/_/\/_/   \/_/   \/_/   \/_/  \/_/   \/_/   \/_____/   \/_____/ 
```


## About sawmill
Each of the iAM.AMR models are informed by one or more queries to the CEDAR (*Collection of Epidemiologically Derived Factors Associated with Resistance*) database. The exported query results are called **timber**. Unfortunately, these raw timber are not usable, as they lack key calculated fields (such as the odds ratio), and have not been screened for simple errors.

The **sawmill** package processes CEDAR timber, performing quality control, and calculating measures of association.



## Installation and Use

### Bootstrap Installation

The bootstrap installation method is the quickest and easiest way of getting started with `sawmill`, and is best-suited for novice R users, or experienced R users who want to quickly process timber with default settings.

These instructions will walk you through how to download and install `sawmill`, and run its processing pipeline.

#### You Will Need:

- timber
- the CEDAR version number (version 1, or version 2)
- R and (optionally) RStudio
- the [bootstrap code](bootstrap/)

#### Instructions

1. Download or copy the [bootstrap code](bootstrap) and run it in R or RStudio
   to download and install `sawmill` and start the processing pipeline.
1. When prompted, supply the timber, CEDAR version number (1 or 2), and choose a save location for the output.
1. Enjoy.


### Standard Installation

The standard installation method is also quick and easy, but is best suited for more experienced users, those looking to run `sawmill` with non-default settings, and those looking to perform development tasks.

#### You Will Need:

- timber
- the CEDAR version number (version 1, or version 2)
- R and RStudio

#### Instructions

1. Download or clone the repository.
1. Either:
   - use RStudio's *Install and Restart* feature in the *Build* tab to install the package.
   - use devtools to load the package.
1. Either:
   - run the interactive, default pipeline with `sawmill::start_mill()`. This will allow you to load the timber and will automatically run the main function, `sawmill::mill()`, using default arguments.
   - run the pipeline with custom arguments:
        * open the main function, `sawmill::mill()`, by opening `mill.R` in RStudio
        * change the default values (for more information on what these mean, see **Default Arguments**)
        * use RStudio's *Install and Restart* feature in the *Build* tab to save your changes
        * run the pipeline with `sawmill::start_mill()`

### General Instructions for Both Installations

#### Warnings

### Default Arguments

#### `cedar_version` (default = `2`)

**Accepted values**: `1, 2`

Upon running `sawmill::start_mill()`, you will be prompted to enter the version of CEDAR used to produce your timber. Whatever you enter at this stage will overwrite this default value. This is the only argument 

#### `write_scrap` (default = `TRUE`)

**Accepted values**: `TRUE, FALSE`

When set to `TRUE`, `write_scrap` allows the `scrap_pile` to be written to the global environment. So what is the scrap pile, and what is the global environment?

- `scrap_pile` contains all of those factors for which inadequate data is available to calculate a measure of association; they are discarded at the "trimming" stage of the pipeline
- Once written to the global environment, `scrap_pile` is easily accessible from the console. After the pipeline is finished running, you can view the discarded factors by entering `scrap_pile` into the console

#### `low_cell_threshold` (default = `0`)

All four counts in the contingency table (# AMR+ individuals in the exposed group, # AMR- individuals in the referent group) should be greater than `low_cell_threshold`, as values of 0 will create divide by 0 error in the measure of association calculation. 

If any of the four counts for a given factor is not greater than this threshold, all four counts will be incremented by `low_cell_correction`, to prevent such errors.

#### `low_cell_correction` (default = `0.5`)

The amount which is added to each of the four counts for a given factor in the event that at least one of them does not meet `low_cell_threshold`.

#### `insensible_rt_lo` (default = `99`)

**Accepted values**: numeric values close to, but less than 100

Some factors defined by rate tables are considered to have "insensible rate tables". This is the case when the sum of the % AMR+ and % AMR- within the exposed group, and/or when the sum of the % AMR+ and % AMR- within the referent group do not add up to approximately 100. 

`insensible_rt_lo` specifies the lower bound of this range of acceptability surrounding 100.

#### `insensible_rt_hi` (default = `101`)

**Accepted values**: numeric values close to, but greater than 100

See `insensible_rt_lo`. 

`insensible_rt_hi` specifies the upper bound of this range of acceptability surrounding 100.

#### `log_base` (default = `exp(1)`, a.k.a. Euler's number)

This parameter provides the base with which the logarithm of the odds ratio (`log(OR)`), as well as the standard error of the log odds ratio (`SE(log(OR))`), are calculated. The former is used in meta-analysis and the latter is one of the key outputs of Sawmill.

With the default value, the natural logarithm is used. This is the recommended `log_base`.

#### `dropRaw` (default = `FALSE`)

**Accepted values**: `TRUE`, `FALSE`

Certain factors in the input timber may be flagged for meta-analysis with a unique meta-analysis ID: `ID_meta`. One meta-analysis calculation is performed for each unique meta-analysis ID, incorporating all factors with that specific meta-analysis ID. When set to TRUE, `dropRaw` deletes all individual factors with meta-analysis IDs from Sawmill's output, leaving only the results of the meta-analysis in the output.

## Notes

- For changes to any of Sawmill's functions to take effect, the package must be re-loaded using RStudio's *Install and Restart* feature in the *Build* tab
- 



## Getting Help

### General FAQs

#### What is going on here? I'm new.

CEDAR is a database of factors along the agri-food production system that influence antimicrobial resistance. The iAM.AMR project aims to create integrated assessment models (IAMs) using these data.

When queries from CEDAR are exported, we call the export *timber*. The data need to be processed after they are exported from the database, before they can be used in the models.

`sawmill` is the R package that does that processing.


#### So what does `sawmill` actually do (in a nutshell)?

`sawmill` looks at each factor in the timber, checks that the raw data required to calculate an odds ratio and standard error of the log(odds ratio) is available and usable, and then performs those calculations.  

#### I normally install packages using `install.packages()`, why doesn't this work for `sawmill`?

The `install.packages()` function only searches [CRAN](https://cran.r-project.org/), and `sawmill` is not currently available in CRAN.

#### Why is `sawmill` not available in CRAN?

Submitting to CRAN involves meeting submission requirements, which not yet been met by the project. Some of these requirements are time prohibitory, given the small user base and alternative download methods available here.

We may submit the package to CRAN in the future.

#### What is an R Package?

[According to](https://r-pkgs.org/intro.html) Hadley Wickham and Jennifer Bryan:

> In R, the fundamental unit of shareable code is the package. A package bundles together code, data, documentation, and tests, and is easy to share with others.

#### What is an R, an RStudio, and how do I get them?

I can tell I'm going to get an email... that's outside our scope here, but [see the official R homepage](https://www.r-project.org/), and [R for Data Science](https://r4ds.had.co.nz/).

#### Where can I find more information about the package?

Try accessing the individual function help files -- using R's `?function()` notation -- or consulting the iAM.AMR project's [documentation](https://docs.iam.amr.pub/en/latest/).


### Specific FAQs

#### I don't know my CEDAR version number. Can you help?

Nope, just try both.  


### Contact

`@chapb` is the creator and maintainer of `sawmill`.
