

#' @title
#'   Generate a mapping of timber column names to their standardized names and expected data types
#'
#' @description
#'   \code{set_blade_depth()} generates a named vector, where the raw timber's column names are
#'   stored as values, and the names mapped to those values correspond to the standardized column
#'   names. It also generates a vector of the expected data type for each timber column.
#'
#'  @param cedar_version
#'    numeric [1,2]: the version of CEDAR that created the export.
#'
#'  @details
#'    The \code{set_blade_depth()} maps original, non-standardized timber column names to
#'    standardized timber column names -- for both versions of CEDAR. These column names are provided
#'    in an external .CSV: \code{/inst/raw_data/import_filter.csv}. The expected data types (i.e.
#'    "numeric", "text") are also provided by this external .CSV.
#'
#'  @return
#'    A list containing a named vector and a "value-only" vector.
#'
#'  @importFrom readr cols read_csv
#'  @importFrom tidyr drop_na
#'  @importFrom dplyr pull %>%
#'
#'  @export


set_blade_depth <- function(cedar_version = 2) {

  # Specify Cols to suppress warnings
  kerf_cols <- readr::cols(uniform  = readr::col_character(),
                           cedar_v1 = readr::col_character(),
                           cedar_v2 = readr::col_character(),
                           col_type = readr::col_character())

  # Read in the import_filter and drop rows not applicable to the current cedar version
  kerf      <- readr::read_csv(system.file("raw_Data", "import_filter.csv", package = "sawmill"),
                               col_types = kerf_cols) %>% tidyr::drop_na(paste0("cedar_v", cedar_version))

  # Extract the expected column data types from the import_filter
  timber_col_types <- kerf$col_type

  # Build the named vector which maps raw timber column names to standardized column names
  depth_guide        <- dplyr::pull(kerf[, paste0("cedar_v", cedar_version)])
  new_names          <- kerf$uniform

  names(depth_guide) <- new_names

  return(list(depth_guide, timber_col_types))

}



