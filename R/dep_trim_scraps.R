

#' @title
#'   Trim Unusable Factors from Timber
#'
#' @description
#'   \code{trim_scraps()} removes unusable factors from timber.
#'
#' @param timber
#'   a tibble of timber, with grain checked by \code{\link{check_grain}}.
#'
#' @param write_scrap
#'   logical: add tibble of unusable factors to the global \code{scrap_pile}.
#'
#' @details
#'   The \code{trim_scraps()} function removes unusable factors from timber. Generally, factors are
#'   unusable where they contain missing or invalid data, and their presence would otherwise cause
#'   errors in later processing. This acts as input sanitization for downstream functions.
#'
#'   Optionally, a tibble of the unusable factors is written to the \code{scrap_pile}
#'   in the global environment.
#'
#'   \subsection{Grain}{
#'     In \code{\link{check_grain}} we introduced the concept of \emph{grain} -- the set of numerical
#'     fields specifying the factor. Factors have \emph{bad grain} where they are specified by an
#'     uninformative combination of values (an unrecognized grain) or missing values.
#'
#'     The supported grains include:
#'
#'     \itemize{
#'       \item odds_ratio
#'       \item con_table_pos_neg
#'       \item con_table_pos_tot
#'       \item rate_table_pos_tot
#'     }
#'   }
#'
#' @return
#'   A tibble of timber without unusable factors.
#'
#' @importFrom dplyr filter mutate
#'
#' @export


dep_trim_scraps <- function(timber, write_scrap = TRUE) {

  # GRAIN
  good_grain <- c("odds_ratio",
                  "con_table_pos_neg",
                  "con_table_pos_tot",
                  "rate_table_pos_tot")

  exclude_grain_message <- paste0("one or more values required to calculate the odds ratio are ",
                                  "missing -- check that the data were extracted correctly")

  exclude_grain         <- dplyr::filter(timber,
                                         !grain %in% good_grain)

  exclude_grain         <- dplyr::mutate(exclude_grain,
                                         scrap_because = exclude_grain_message)

  # WRITE SCRAPS
  if (write_scrap) {
    scrap_pile <<- exclude_grain
    message("Reminder, scrap_pile was written to global environment.")
  }

  # INCLUDE
  timber                <- dplyr::filter(timber,  grain %in% good_grain)
  return(timber)

}




