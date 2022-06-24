

#' @title
#'   The sawmill Pipeline
#'
#' @description
#'  The \code{mill()} runs the sawmill pipeline with useful defaults.
#'
#' @export


mill <- function(timber_path, cuts, col_data_types, cedar_version, low_cell_threshold = 0, low_cell_correction = 0.5, insensible_p_lo = 99, insensible_p_hi = 101, log_base = exp(1)){

  sub_mill(timber1 <- debark2(timber_path = timber_path), "debark")
  sub_mill(timber2 <- check_grain(timber = timber1), "check_grain")
  sub_mill(timber4 <- build_table(timber = timber2,
                                  low_cell_correction = low_cell_correction,
                                  low_cell_threshold = low_cell_threshold), "build_table")
  sub_mill(timber5 <- polish_table(timber = timber4,
                                   cedar_version = cedar_version,
                                   insensible_p_lo = insensible_p_lo,
                                   insensible_p_hi = insensible_p_hi), "polish_table")
  sub_mill(timber6 <- add_CI(timber = timber5), "add_CI")
  sub_mill(timber7 <- build_chairs(timber = timber6, log_base = log_base), "build_chairs")
  sub_mill(timber8 <- build_horse(timber = timber7), "build_horse")
  sub_mill(timber9 <- do_MA(timber = timber8, log_base = log_base, cedar_version = cedar_version), "do_MA")
  sub_mill(timber10 <- add_URL(timber = timber9), "add_URL")
  sub_mill(timber11 <- add_HTMLink(timber = timber10), "add_HTMLink")
  sub_mill(timber12 <- add_ident(timber = timber11, cedar_version = cedar_version), "add_ident")
  sub_mill(planks <- reorder_fields(timber = timber12, cedar_version = cedar_version), "reorder_fields")

  return(planks)

}


