

#' @title
#'   Generate a Named Vector Mapping CEDAR Export Column Names to Standardized Timber Column Names
#'
#' @description
#'   \code{set_blade_depth()} generates a named vector, containing CEDAR export column names as
#'   values, and their equivalent standardized timber column names as names.
#'
#'  @param cedar_version
#'    numeric [1,2]: the version of CEDAR that created the export.
#'
#'  @details
#'    The \code{set_blade_depth()} maps original, non-standardized CEDAR export column names to
#'    standardized timber column names -- for both versions of CEDAR. These column names are provided
#'    in an external .CSV: \code{/inst/raw_data/import_filter.csv}.
#'
#'  @return
#'    A named vector.
#'
#'  @importFrom readr cols read_csv
#'  @importFrom tidyr drop_na
#'  @importFrom dplyr pull %>%
#'
#'  @export


set_blade_depth <- function(cedar_version = 2) {

  #sub_mill(check_version(cedar_version), "check_version")

  # Specify Cols to suppress warnings
  kerf_cols <- readr::cols(uniform  = readr::col_character(),
                           cedar_v1 = readr::col_character(),
                           cedar_v2 = readr::col_character(),
                           col_type = readr::col_character())

  #Read in the import_filter and drop rows not applicable to the current cedar version
  kerf      <- readr::read_csv(system.file("raw_Data", "import_filter.csv", package = "sawmill"),
                               col_types = kerf_cols) %>% tidyr::drop_na(paste0("cedar_v", cedar_version))
  timber_col_types <- kerf$col_type

  #Get info needed to rename columns
  depth_guide        <- dplyr::pull(kerf[, paste0("cedar_v", cedar_version)]) #old_names
  new_names          <- kerf$uniform

  #depth_guide        <- old_names[!is.na(old_names)]
  names(depth_guide) <- new_names

  return(list(depth_guide, timber_col_types))

}



