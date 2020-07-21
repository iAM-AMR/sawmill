

#' @title
#'   Get the Expected Column Types for an Input CEDAR Query
#'
#' @description
#'  The \code{get_col_types()} function gets the expected data types for each column in the
#'  CEDAR query version.
#'
#' @param cedar_version
#'    numeric [1,2]: the version of CEDAR that created the export.
#'
#' @return
#'   A vector the size of the number of columns in the export version, indicating
#'   either "text" or "numeric" for the expected data type of each column
#'
#' @export


get_col_types <- function(cedar_version){

  if (cedar_version == 2) {
    raw_col_types <- rep("text", times = 35)
    raw_col_types[c(1,3,5,19:31,33)] <- "numeric"
  }

  else if (cedar_version == 1) {
    raw_col_types <- rep("text", times = 31)
    raw_col_types[c(1,16:26,29)] <- "numeric"
  }

  return(raw_col_types)

}
