

#' @title
#'   Append the Scrap Pile to the Processed Timber
#'
#' @description
#'   \code{append_scraps()} adds the unusable factors in the scrap pile to the end of the
#'   processed timber.
#'
#' @param timber
#'    a tibble of timber, returned from \code{\link{add_ident}}.
#'
#' @return
#'    The passed tibble of processed timber with additional rows containing the unusable
#'    factors from the scrap pile.
#'
#' @importFrom dplyr bind_rows
#'
#' @export


append_scraps <- function(timber) {

  timber <- dplyr::bind_rows(timber, scrap_pile)

  return(timber)

}
