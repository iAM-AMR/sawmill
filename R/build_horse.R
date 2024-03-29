

#' @title
#'   Calculate the significance of a resistance outcome
#'
#' @description
#'   \code{build_horse()} calculates the significance of the OR of a count or prevalence-based factor, using
#'   the Fisher's Exact Test. It does not calculate the significance of the OR if the factor has an
#'   \emph{odds_ratio} grain.
#'
#' @param timber
#'   a tibble of timber, with a table built by \code{\link{build_table}}.
#'
#' @return
#'   A tibble of timber with additional columns: \emph{pval}.
#'
#' @importFrom dplyr mutate
#'
#' @export


build_horse <- function(timber) {

  dplyr::mutate(timber, pval = ifelse(grain %in% c("con_table_pos_neg", "con_table_pos_tot", "prev_table_pos_tot"),
                                      as.character(apply(timber, 1, fisher_p)),
                                      oddsig))

  #timber$pval <- as.character(timber$pval)
}



fisher_p <- function(x) {

  try(fisher.test(matrix(as.numeric(c(x[["A"]], x[["B"]], x[["C"]], x[["D"]])), nrow=2))$p.value,
      silent = TRUE)

}
