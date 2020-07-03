

#' @title
#'   Calculate the Odds Ratio (OR) and the SE(log(OR))
#'
#' @description
#'   \code{build_chairs()} calculates the odds ratio [OR] and standard error of the log(odds ratio)
#'   or SE(log(OR)).
#'
#' @param timber
#'   a tibble of timber, with a table built by \code{\link{build_table}}.
#'
#' @param log_base
#'   numeric: the logarithm base used in the calculation of the SE(log(OR)) from CIs.
#'
#' @details
#'   The odds ratio and the standard error of the log(odds ratio) can be calculated using a complete
#'   contingency table, or the odds ratio and the confidence intervals (CIs).
#'
#'   \subsection{Contingency Table}{
#'     The formula to calculate the odds ratio from a contingency table is:
#'
#'     \eqn{OR = (A/B) / (C/D)}
#'
#'     The formula to calculate the standard error of the log(odds ratio) from a contingency table is:
#'
#'     \eqn{SE(log(OR)) = sqrt((1/A) + (1/B) + (1/C) + (1/D))}
#'
#'   }
#'
#'   \subsection{Odds Ratio and CIs}{
#'     The formula to calculate the standard error of the log(odds ratio) from the CIs is:
#'
#'     \eqn{SE(log(OR)) = (log(oddsup) - log(oddslo)) / (2 * Z)}
#'
#'     \emph{where Z is the Z value corresponding to 1/2 alpha, and alpha = 1 - confidence level}.
#'
#'     Note, the the choice of logarithm base for this calculation may be specified by the user as
#'     \code{log_base} (default = 10).
#'
#'   }
#'
#' @return
#'   A tibble of timber with additional columns: \emph{odds_ratio} and \emph{se_log_or}.
#'
#' @importFrom dplyr mutate case_when
#'
#' @export


build_chairs <- function(timber, log_base = 10) {

  dplyr::mutate(timber,
                odds_ratio = dplyr::case_when(
                  grain == "odds_ratio" ~ odds,
                  grain == "con_table_pos_neg" | grain == "con_table_pos_tot" | grain == "rate_table_pos_tot" ~ (A/B) / (C/D),
                  TRUE ~ NA_real_),
                se_log_or  = dplyr::case_when(
                  grain == "odds_ratio" ~ (log(oddsup, base = log_base) - log(oddslo, base = log_base)) / (2 * -qnorm((100 - oddsci)/200, mean = 0, sd = 1)),
                  grain == "con_table_pos_neg" | grain == "con_table_pos_tot" | grain == "rate_table_pos_tot" ~ sqrt((1/A) + (1/B) + (1/C) + (1/D)),
                  TRUE ~ NA_real_))

}









