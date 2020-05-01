

#' @title
#'   Complete Contingency Tables for Count and Rate-based Factors
#'
#' @description
#'   \code{build_table()} completes partially-specified contingency tables using simple arithmetic.
#'
#' @param timber
#'   a tibble of timber.
#'
#' @param low_cell_correction
#'   numeric: the value added to all cells when one or more is at or below the \code{low_cell_threshold}.
#'
#' @param low_cell_threshold
#'   numeric: the threshold at or below which the \code{low_cell_correction} is applied to all cells.
#'
#' @details
#'   A complete contingency table (counts in cells A, B, C, and D) is required to calculate
#'   measures of association for count or rate-based data. Depending on the factor's \code{grain},
#'   the set of fields used to complete the table differs. Simple arithmetic is used to complete the
#'   table. The fields included in each grain are described in \code{\link{check_grain}}.
#'
#'   When any cells in the table are less than or equal to the \code{low_cell_threshold}, a \code{low_cell_correction}
#'   is added to each cell, and the correction is noted in the \emph{low_cell_count} column.
#'
#'   Where both positive cells (A and C) are zero, the factor represents a \emph{null comparison}, and the
#'   null comparison is noted in the \emph{null_comparison} column.
#'
#' @return
#'   A tibble of timber, with complete A, B, C, and D columns for count and rate-based factors, and additional columns: \emph{low_cell_count}, and \emph{null_comparison}.
#'
#' @importFrom dplyr mutate case_when
#'
#' @export



build_table <- function(timber, low_cell_correction = 0.5, low_cell_threshold = 0) {

  table_grain <- c("con_table_pos_neg", "con_table_pos_tot", "rate_table_pos_tot")

  timber <- dplyr::mutate(timber,
                   A = dplyr::case_when(
                       grain == "con_table_pos_neg" ~ A,
                       grain == "con_table_pos_tot" ~ A,
                       grain == "rate_table_pos_tot" ~ round(P * nexp * 0.01),
                       TRUE ~ A),
                   B = dplyr::case_when(
                       grain == "con_table_pos_neg" ~ B,
                       grain == "con_table_pos_tot" ~ nexp - A,
                       grain == "rate_table_pos_tot" ~ nexp - A,
                       TRUE ~ B),
                   C = dplyr::case_when(
                       grain == "con_table_pos_neg" ~ C,
                       grain == "con_table_pos_tot" ~ C,
                       grain == "rate_table_pos_tot" ~ round(Q * nref * 0.01),
                       TRUE ~ C),
                   D = dplyr::case_when(
                       grain == "con_table_pos_neg" ~ D,
                       grain == "con_table_pos_tot" ~ nref - C,
                       grain == "rate_table_pos_tot" ~ nref - C,
                       TRUE ~ D),

                   low_cell_count  = ifelse((grain %in% table_grain) & (A <= low_cell_threshold |  B <= low_cell_threshold | C <= low_cell_threshold | D <= low_cell_threshold),
                                              yes = TRUE,
                                              no  = FALSE),
                   null_comparison = ifelse((grain %in% table_grain) & A == 0 & C == 0,
                                              yes = TRUE,
                                              no = FALSE))


  timber <- dplyr::mutate(timber,
                   A = ifelse(low_cell_count == TRUE,
                              yes = A + low_cell_correction,
                              no  = A),
                   B = ifelse(low_cell_count == TRUE,
                              yes = B + low_cell_correction,
                              no  = B),
                   C = ifelse(low_cell_count == TRUE,
                              yes = C + low_cell_correction,
                              no  = C),
                   D = ifelse(low_cell_count == TRUE,
                              yes = D + low_cell_correction,
                              no  = D))

  return(timber)

}




