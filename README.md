
# sawmill
An R package used to prepare queries from CEDAR (timber) for use in the iAM.AMR models.

## About sawmill
Each of the iAM.AMR models are informed by one or more queries to the CEDAR (*Collection of Epidemiologically Derived Factors Associated with Resistance*) database. The exported query results are called **timber**. Unfortunately, these raw timber are not usable, as they lack key calculated fields (such as the odds ratio), and have not been screened for simple errors.

The **sawmill** package processes CEDAR timber, performing quality control, and calculating measures of association.

## Installation and Use

### Bootstrap Installation

The bootstrap installation method is the quickest and easiest way of getting started with `sawmill`, and is best-suited for novice R users, or experienced R users who want to quickly process timber with default settings.

These instructions will walk you through how to download and install `sawmill`, and run it's processing pipeline.

#### You Will Need:

- timber
- the CEDAR version number (v1 or v2)
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
- the CEDAR version number (v1 or v2)
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

### FAQs

#### What is going on here? I'm new.

CEDAR is a database of factors along the agri-food production system that influence antimicrobial resistance. The iAM.AMR project aims to create integrated assessment models (IAMs) using these data. These data need to be processed after they are exported from the database, and before they can be used in the models. `sawmill` is the R package that does that processing.

#### What is an R Package?

[According to](http://r-pkgs.had.co.nz/intro.html) Hadley Wickham:

> In R, the fundamental unit of shareable code is the package. A package bundles together code, data, documentation, and tests, and is easy to share with others. As of January 2015, there were over 6,000 packages available on the Comprehensive R Archive Network, or CRAN, the public clearing house for R packages. This huge variety of packages is one of the reasons that R is so successful: the chances are that someone has already solved a problem that you’re working on, and you can benefit from their work by downloading their package.

#### I do not know my CEDAR version number. Can you help?

No, just try both.

#### Where can I find more information about the package?

Try accessing the individual function help files -- using R's `?function()` notation -- or consulting the iAM.AMR project's [documentation](https://docs.iam.amr.pub/en/latest/).

### Contact

`@chapb` is the creator and maintainer of `sawmill`.
