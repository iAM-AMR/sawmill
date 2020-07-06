

#' @title
#'    Remove Duplicate Rows for Meta-Analysis
#'
#' @description
#'    \code{dedupe_MA()} removes duplicate rows to retain the largest available
#'    meta-analysis group. It was adapted from the now depreciated cedarr
#'    package for Sawmill.
#'
#' @param query
#'    a tibble of timber, with a table built by \code{\link{build_table}}.
#'
#' @details
#'    A factor may be included in more than one meta-analysis. For example, a
#'    factor describing resistance to a third-generation cephalosporin may be
#'    included in a meta-analysis across other third-generation cephalosporins,
#'    but may also be included in a larger meta-analysis across all
#'    cephalosporins. Where a factor is included in multiple meta-analyses
#'    applicable to a query, duplicate rows will be returned.

#'    The dedupeMA function removes these duplicate rows, retaining the largest
#'    meta-analysis group available. If the groups are of the same size, they are
#'    both retained.

#'    The dedupeMA function first separates those rows involved in meta-analysis
#'    from those uninvolved into two tibbles. It then searches for duplicate
#'    factors. If duplicates exist, the associated meta-analyses are identified
#'    for each duplicate, and the size of each meta-analysis is determined. Those
#'    which are not the largest are dropped from the 'involved' tibble, and the
#'    two tibbles are then reunited.
#'
#' @return
#'    A tibble of timber, with duplicate rows removed.
#'
#' @importFrom magrittr %<>% %>%
#' @importFrom dplyr filter count bind_rows
#'
#' @export


dedupe_MA <- function(query) {

  nonma <- dplyr::filter(query, is.na(ID_meta))
  yesma <- dplyr::filter(query, !(is.na(ID_meta)))

  dupno <- yesma %>% count(ID) %>% dplyr::filter(n > 1) %>% .$ID

  for (i in dupno) {

    entries <- dplyr::filter(yesma, ID == i)
    metas   <- unique(entries$ID_meta)
    lens    <- vector(mode = 'numeric', length = length(metas))

    for (k in 1:length(metas)) {
      lens[k] <- nrow(filter(yesma, ID_meta == metas[k]))
    }

    badmas <- metas[(which(lens != max(lens)))]
    yesma  <- dplyr::filter(yesma, !(ID_meta %in% badmas))

  }

  newqu <- dplyr::bind_rows(nonma, yesma)

  return(newqu)

}
