

#' @title
#'   Flag Rate Tables as Sensible or Not
#'
#' @description
#'    \code{polish_table()} identifies factors with rate tables that do not sum to approximately 100%
#'
#' @param timber
#'    a tibble of timber.
#'
#' @param cedar_version
#'    numeric [1,2]: the version of CEDAR that created the export.
#'
#' @param insensible_rt_lo
#'    numeric: the lower bound of the range which rate table sums should fall within to be
#'    considered "sensible", i.e. close to 100\%.
#'
#' @param insensible_rt_hi
#'    numeric: the upper bound of the range which rate table sums should fall within to be
#'    considered "sensible", i.e. close to 100\%.
#'
#' @details
#'    For factors with a rate_table_pos_tot grain (see \code{\link{check_grain}} for more information),
#'    for which R and S (% AMR- individuals within the exposed and referent groups, respectively)
#'    are also available, the resulting rate table may or not be sensible, i.e. each of P% + R%
#'    and Q% + S% may or may not sum to approximately 100%. Where these sums do not fall within
#'    an acceptable range surrounding 100%, bounded by \code{insensible_rt_lo} and
#'    \code{insensible_rt_hi}, the \emph{insensible_rate_table} column will be TRUE. Where the
#'    sums do fall within the acceptable range, this column will have a value of FALSE. For other
#'    grains, or for factors of this grain where R and S are not available, this column will
#'    have a value of NA.
#'
#'    Since inputs produced by CEDAR v2 are the only ones to contain R and S columns, this
#'    new \emph{insensible_rate_table} column is only added to v2 inputs. If a CEDAR v1
#'    query is provided as the input to the pipeline, the tibble produced by the
#'    \code{polish_table} function will be exactly the same as the tibble passed into the
#'    function.
#'
#' @return
#'    A tibble of timber, with an additional column added to inputs produced by CEDAR
#'    v2: \emph{insensible_rate_table}.
#'
#' @importFrom dplyr mutate case_when
#'
#' @export


polish_table <- function(timber, cedar_version = 2, insensible_rt_lo = 99, insensible_rt_hi = 101) {

  if (cedar_version == 2) {
    timber <- dplyr::mutate(timber,
                            insensible_rate_table = dplyr::case_when(
                              grain == "rate_table_pos_tot" & !is.na(R) & !is.na(S)
                                       & !((P + R) >= insensible_rt_lo & (P + R) <= insensible_rt_hi)
                                       & !((Q + S) >= insensible_rt_lo & (Q + S) <= insensible_rt_hi)
                                    ~ "TRUE",
                              grain == "con_table_pos_neg" | grain == "con_table_pos_tot" | grain == "odds_ratio"
                                       | is.na(R) | is.na(S)
                                    ~ NA_character_,
                              TRUE ~ "FALSE"))
  }


  return(timber)

}




