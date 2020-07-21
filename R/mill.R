

#' @title
#'   The sawmill Pipeline
#'
#' @description
#'  The \code{mill()} runs the CEDAR pipeline with useful defaults.
#'
#' @export


mill <- function(timber, cedar_version = 2, write_scrap = TRUE, low_cell_correction = 0.5, low_cell_threshold = 0, insensible_rt_lo = 99, insensible_rt_hi = 101, log_base = exp(1), dropRaw = FALSE){

  sub_mill(timber1 <- debark(timber = timber, cedar_version = cedar_version), "debark")
  sub_mill(timber2 <- check_grain(timber = timber1), "check_grain")
  sub_mill(timber3 <- trim_scraps(timber = timber2, write_scrap = write_scrap), "trim_scraps")
  sub_mill(timber4 <- build_table(timber = timber3,
                                  low_cell_correction = low_cell_correction,
                                  low_cell_threshold = low_cell_threshold), "build_table")
  sub_mill(timber5 <- polish_table(timber = timber4,
                                   cedar_version = cedar_version,
                                   insensible_rt_lo = insensible_rt_lo,
                                   insensible_rt_hi = insensible_rt_hi), "polish_table")
  sub_mill(timber6 <- add_CI(timber = timber5), "add_CI")
  sub_mill(timber7 <- build_chairs(timber = timber6, log_base = log_base), "build_chairs")
  sub_mill(timber8 <- build_horse(timber = timber7), "build_horse")
  sub_mill(timber9 <- do_MA(query = timber8,
                            cedar_version = cedar_version,
                            dropRaw = dropRaw,
                            log_base = log_base), "do_MA")
  sub_mill(timber10 <- add_URL(timber = timber9), "add_URL")
  sub_mill(timber11 <- add_HTMLink(timber = timber10), "add_HTMLink")
  sub_mill(timber12 <- add_ident(query = timber11, cedar_version = cedar_version), "add_ident")

  return(timber12)

}


