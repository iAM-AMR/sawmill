
#' @title
#'   The sawmill Pipeline
#'
#' @description
#'  The \code{mill()} runs the CEDAR pipeline with useful defaults.
#'
#' @export



mill <- function(timber, cedar_version = 2, write_scrap = TRUE, low_cell_correction = 0.5, low_cell_threshold = 0){

  timber1 <- debark(timber = timber, cedar_version = cedar_version)
  timber2 <- check_grain(timber = timber1)
  timber3 <- trim_scraps(timber = timber2, write_scrap = write_scrap)
  timber4 <- build_table(timber = timber3,
                         low_cell_correction = low_cell_correction,
                         low_cell_threshold = low_cell_threshold)
  timber5 <- add_CI(timber4)
  timber6 <- build_chairs(timber5)
  timber7 <- build_horse(timber6)
  timber8 <- do_MA(timber7, cedar_version = cedar_version)

  return(timber8)

}



