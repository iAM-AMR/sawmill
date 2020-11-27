

#' @title
#'   Trim unusable factors from timber
#'
#' @description
#'   \code{trim_scraps()} removes unusable factors from timber, as marked in the \emph{exclude_sawmill}
#'   field, attaches a reason for exclusion using \emph{exclude_sawmill_reason}, and sends these factors to
#'   the \code{scrap_pile}.
#'
#' @param timber
#'   a tibble of timber, with grain checked by \code{\link{check_grain}}.
#'
#' @param reason
#'   string: a description of why a given factor is unusable.
#'
#' @return
#'   A tibble of timber without unusable factors.
#'
#' @importFrom dplyr filter
#'
#' @export



trim_scraps <- function(timber, reason) {

  # Select excluded factors
  new_scraps <- dplyr::filter(timber, exclude_sawmill)

  # Add reason for exclusion
  new_scraps$exclude_sawmill_reason <- reason

  # Write excluded factors to the scrap_pile
  scrap_pile <<- bind_rows(scrap_pile, new_scraps)

  # Return timber without exclusions
  return(dplyr::filter(timber, !exclude_sawmill))


}
