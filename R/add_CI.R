

#' @title
#'   Fill in the Confidence Interval (CI) Column
#'
#' @description
#'   \code{add_CI} fills in empty cells in the confidence interval column with the
#'   value 95.
#'
#' @param timber
#'   a tibble of timber.
#'
#' @return
#'   A tibble of timber with a complete \emph{oddsci} column.
#'
#' @importFrom dplyr mutate if_else
#'
#' @export


add_CI <- function(timber){

  dplyr::mutate(timber, oddsci = dplyr::if_else(is.na(oddsci), 95, oddsci))

}








