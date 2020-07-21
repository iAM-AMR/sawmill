

#' @title
#'   Calculate the Significance of a Factor
#'
#' @description
#'   \code{build_horse()} calculates the significance of the OR of a factor.
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

  dplyr::mutate(timber, pval = ifelse(grain %in% c("con_table_pos_neg", "con_table_pos_tot", "rate_table_pos_tot"),
                                      apply(timber, 1, fisher_p),
                                      oddsig))

}



fisher_p <- function(x) {

  try(fisher.test(matrix(as.numeric(c(x[["A"]], x[["B"]], x[["C"]], x[["D"]])), nrow=2))$p.value,
      silent = TRUE)

}
