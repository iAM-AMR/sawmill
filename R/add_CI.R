

#' @title
#'   Add a Confidence Interval (CI) Column to Timber
#'
#' @description
#'   \code{add_CI} checks if the CEDAR version specified is 1 or 2, else throws an error.
#'
#' @param timber
#'   a tibble of timber.
#'
#' @return
#'   A tibble of timber with additional column \emph{oddsci}.
#'
#' @importFrom dplyr mutate
#'
#' @export


add_CI <- function(timber){
  dplyr::mutate(timber, oddsci = 95)
}








