

#' @title
#'   Standardize Column Names or "Debark" Timber
#'
#' @description
#'   \code{debark()} standardizes the column names of timber for use in \code{sawmill}.
#'
#' @param timber
#'   a tibble of timber.
#'
#' @param cedar_version
#'   numeric [1,2]: the version of CEDAR that created the export..
#'
#' @return
#'   A tibble of timber with standardized column names.
#'
#' @importFrom dplyr rename
#'
#' @export


debark <- function(timber, cedar_version = 2){

  sub_mill(check_version(cedar_version), "check_version")

  sub_mill(cuts   <- set_blade_depth(cedar_version), "set_blade_depth")

  if(!all((cuts) %in% names(timber))) {
    stop("There are requisite columns missing from your CEDAR export.")}

  timber <- dplyr::rename(timber, cuts)

  return(timber)

}






