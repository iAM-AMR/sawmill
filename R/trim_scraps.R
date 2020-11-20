

#' @title
#'   Trim Unusable Factors from Timber
#'
#' @description
#'   \code{trim_scraps()} removes unusable factors from timber, as marked in exclude_sawmill.
#'
#' @param timber
#'   a tibble of timber, with grain checked by \code{\link{check_grain}}.
#'
#' @param reason
#'   string: a description of why this factor was removed from the models? \code{scrap_pile}.
#'
#' @details
#'
#'
#' @return
#'   A tibble of timber without unusable factors.
#'
#' @importFrom dplyr filter mutate
#'
#' @export



trim_scraps <- function(timber, reason) {

  # Select excluded factors
  new_scraps <- filter(timber, exclude_sawmill)

  # Add reason for exclusion
  new_scraps$exclude_sawmill_reason <- reason

  # Write to scrap_pile
  scrap_pile <<- bind_rows(scrap_pile, new_scraps)

  # Return timber without exclusions
  return(filter(timber, !exclude_sawmill))


}
