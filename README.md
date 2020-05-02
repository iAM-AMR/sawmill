
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

These instructions will walk you through how to download and install `sawmill`, and run it's processing pipeline.

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
   - load the timber, and run the main function, `sawmill::mill()` with custom arguments.
   - run the interactive, default pipeline with `sawmill::start_mill()` to load the timber and run the main function, `sawmill::mill()` with default arguments.



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
