

#' @title
#'   The sawmill Pipeline
#'
#' @description
#'  The \code{mill()} runs the sawmill pipeline with useful defaults.
#'
#' @param timber_path
#'   string: a path to a timber file.
#'
#' @param timber_version
#'   numeric: a supported timber version number (1|2|3). Currently unsupported.
#'
#' @param low_cell_threshold
#'   numeric: the two-by-two (contingency) table cell count at which (or lower)
#'            the Haldane correction (alt: Woolf-Haldane correction, Haldane-Anscombe correction)
#'            should apply.
#'
#' @param low_cell_correction
#'    numeric: the value of the Haldane correction to apply; must be > 0.
#'
#' @param log_base
#'    numeric: the logarithmic base to use when calculating the log(Odds Ratio),
#'             and the standard error of the log(Odds Ratio).
#'
#' @export

# To Document




# `insensible_p_lo` (default = `99`)
#
# **Accepted values:** numeric values close to, but less than 100
#
# **Passed to functions:** [`sawmill::polish_table()`](R/polish_table.R)
#
# Some factors are defined by "insensible prevalence tables". This is the case when the sum of the % AMR+ and % AMR- within the exposed group, and/or when the sum of the % AMR+ and % AMR- within the referent group do not add up to approximately 100.
#
# `insensible_p_lo` specifies the lower bound of this range of acceptability surrounding 100.
#
#
# `insensible_p_hi` (default = `101`)
# **Accepted values:** numeric values close to, but greater than 100
#   **Passed to functions:** [`sawmill::polish_table()`](R/polish_table.R)
#
# See `insensible_p_lo`.
#
# `insensible_p_hi` specifies the upper bound of this range of acceptability surrounding 100.



mill <- function(timber_path, cedar_version = 2, low_cell_threshold = 0, low_cell_correction = 0.5, insensible_p_lo = 99, insensible_p_hi = 101, log_base = exp(1)){

  sub_mill(timber1  <- debark(timber_path = timber_path),
                       "Debark: read timber and rename columns.")


  sub_mill(timber2  <- check_grain(timber = timber1),
                       "Check Grain: detect fields that specify each outcome.")


  sub_mill(timber4  <- build_table(timber              = timber2,
                                   low_cell_correction = low_cell_correction,
                                   low_cell_threshold  = low_cell_threshold),
                       "Build Table: complete contingency tables for count and prevalence-based outcomes.")


  sub_mill(timber5  <- polish_table(timber             = timber4,
                                    cedar_version      = cedar_version,
                                    insensible_p_lo    = insensible_p_lo,
                                    insensible_p_hi    = insensible_p_hi),
                       "Polish Table: check for logical inconsistencies in completed contingency tables.")


  sub_mill(timber6  <- add_CI(timber         = timber5),
                       "Add CI: set the confidence level (if not provided).")


  sub_mill(timber7  <- build_chairs(timber   = timber6,
                                    log_base = log_base),
                       "Build Chair: calculate the odds ratio (OR) and the SE(log(OR)) for each outcome.")


  sub_mill(timber8  <- build_horse(timber    = timber7),
                       "Build Horse: calculate the significance of the OR for count and prevalence-based outcomes.")


  sub_mill(timber9  <- do_MA(timber          = timber8,
                             log_base        = log_base,
                             cedar_version   = cedar_version),
                       "Do MA: run any meta-analyses specified by the user.")


  sub_mill(timber10 <- add_URL(timber     = timber9),
                       "Add URL: create a URL from identifiers (e.g., DOI).")


  sub_mill(timber11 <- add_HTMLink(timber = timber10),
                       "Add a HTML Link: create an <a> object from each URL.")


  sub_mill(timber12 <- add_ident(timber   = timber11, cedar_version = cedar_version),
                       "Add an ANA Identifier: add a suggested ID for objects in Analytica.")


  sub_mill(planks   <- reorder_fields(timber = timber12, cedar_version = cedar_version),
                       "Reorder Fields: reorder processed timber output columns.")

  return(planks)

}


