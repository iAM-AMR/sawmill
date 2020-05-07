



library("tidyverse")
library("readxl")


file_path  <- file.choose()
raw_timber <- readxl::read_excel(file_path)

timber1 <- debark(timber = raw_timber, cedar_version = 2)
timber2 <- check_grain(timber = timber1)
timber3 <- trim_scraps(timber = timber2, write_scrap = TRUE)
timber4 <- build_table(timber = timber3,
                       low_cell_correction = 0.5,
                       low_cell_threshold = 0)
timber5 <- add_CI(timber4)
timber6 <- build_chairs(timber5)
readr::write_csv(timber6, file.choose())
