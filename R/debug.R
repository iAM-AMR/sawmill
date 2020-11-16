
# This must be commented out to build the package.

# library("tidyverse")
# library("readxl")
#
#
# file_path  <- file.choose()
# raw_timber <- readxl::read_excel(file_path)
#
# timber1 <- debark(timber = raw_timber, cedar_version = 2)
# timber2 <- check_grain(timber = timber1)
# # Timber 3 removed (trim_scraps)
# timber4 <- build_table(timber = timber2,
#                        low_cell_correction = 0.5,
#                        low_cell_threshold = 0)
# timber5 <- add_CI(timber4)
#
# timber5$oddsup <- as.numeric(timber5$oddsup)
#
# timber6 <- build_chairs(timber5, 10)
# timber7 <- build_horse(timber6)
# readr::write_csv(timber7, file.choose())
