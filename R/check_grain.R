
#' @title
#'   Check the Grain (Set of Numeric Fields) of Each Factor in Timber
#'
#' @description
#'   \code{check_grain()} determines which set of numeric fields are used to specify each factor in timber (i.e. the factor's \emph{grain}).
#'
#' @param timber
#'   a tibble of timber.
#'
#' @details
#'   Every factor in CEDAR is described quantitatively using a different set (or collection) of fields.
#'   The set of fields chosen depends on the type and format of the data available in the literature. We refer
#'   to the set of fields specified for each factor as the factor's \strong{grain}.
#'
#'   There are several common sets of fields (i.e. \emph{grains}) in CEDAR that are \emph{recognized} by
#'   \code{check_grain()}. However, not all of these are necessarily \emph{usable}; only some \emph{grains}
#'   contain the fields required to calculate the parameters of a distribution describing a measure of association.
#'
#'   \subsection{Raw Data Formats}{
#'      There are two types of two-by-two tables that can be populated in CEDAR: contingency
#'      tables, containing count data, and rate tables, containing rate data. The odds ratio may
#'      also be specified directly, provided the confidence intervals (CIs) are available.
#'
#'      \emph{A Contingency Table}
#'
#'      \tabular{lccc}{
#'                 \tab AMR+ \tab AMR- \tab Total \cr
#'        Exposed  \tab A    \tab B    \tab M1    \cr
#'        Referent \tab C    \tab D    \tab M2    \cr
#'      }
#'
#'      \emph{A Rate Table}
#'
#'      \tabular{lccc}{
#'                 \tab AMR+ \tab AMR- \tab Total \cr
#'        Exposed  \tab P\%  \tab R\%  \tab M1    \cr
#'        Referent \tab Q\%  \tab S\%  \tab M2    \cr
#'      }
#'
#'      \emph{Odds Ratio}
#'
#'      \tabular{lccc}{
#'        \tab Lower CI \tab Odds Ratio \tab Upper CI \cr
#'        \tab oddslo   \tab odds       \tab oddsup   \cr
#'      }
#'
#'   }
#'
#'   \subsection{Recognized Grains}{
#'     There are currently four recognized grains:
#'
#'     \itemize{
#'            \item{con_table_pos_neg: A, B, C, D}
#'            \item{con_table_pos_tot: A, C, M1, M2}
#'            \item{rate_table_pos_tot: P, Q, M1, M2}
#'            \item{rate_table_pos_neg: P, R, Q, S}
#'            \item{odds_ratio: oddslo, odds, oddsup}
#'     }
#'   }
#'
#'   \subsection{Unrecognized Grains}{
#'     If \code{check_grain()} fails to recognize the grain, it returns \code{NA}.
#'
#'  }
#'
#' @return
#'   A tible of timber with additional column \emph{grain}.
#'
#' @importFrom dplyr mutate case_when
#'
#' @export



check_grain <- function(timber) {

  # Charly: fixed error in rate_table_pos_neg condition for v1 inputs, by allowing for
  #         cases when R and S columns do not exist

  dplyr::mutate(timber,
                grain = dplyr::case_when(
                  res_format == "Odds Ratio"        & !is.na(odds) & !is.na(oddslo) & !is.na(oddsup)                ~ "odds_ratio",
                  res_format == "Contingency Table" & !is.na(A)    & !is.na(B)      & !is.na(C)      & !is.na(D)    ~ "con_table_pos_neg",
                  res_format == "Contingency Table" & !is.na(A)    & !is.na(nexp)   & !is.na(C)      & !is.na(nref) ~ "con_table_pos_tot",
                  res_format == "Rate Table"        & !is.na(P)    & ("R" %in% names(timber) && !is.na(R))      & !is.na(Q)      & ("S" %in% names(timber) && !is.na(S))    ~ "rate_table_pos_neg",
                  res_format == "Rate Table"        & !is.na(P)    & !is.na(nexp)   & !is.na(Q)      & !is.na(nref) ~ "rate_table_pos_tot",
                  TRUE ~ NA_character_))

}



