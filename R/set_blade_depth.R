

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
#'    in an external .CSV: \code{/data/import_filter.csv}.
#'
#'  @return
#'    A named vector.
#'
#'  @importFrom readr cols read_csv
#'
#'  @export



set_blade_depth <- function(cedar_version = 2) {

  check_version(cedar_version)

  # Specify Cols to suppress warnings
  kerf_cols <- readr::cols(uniform  = readr::col_character(),
                           cedar_v1 = readr::col_character(),
                           cedar_v2 = readr::col_character())

  kerf      <- readr::read_csv(system.file("raw_Data", "import_filter.csv", package = "sawmill"),
                               col_types = kerf_cols)

  old_names          <- kerf[, paste0("cedar_v", cedar_version)]
  new_names          <- kerf$uniform[which(!is.na(old_names))]

  depth_guide        <- old_names[!is.na(old_names)]
  names(depth_guide) <- new_names

  return(depth_guide)

}




