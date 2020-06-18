

#' @title
#'    Perform Meta-analyses on Factors in a CEDAR Query
#'
#' @authors
#'    Brennan Chapman \email{chapmanb@@uoguelph.ca}
#'    Charly Phillips \email{charly.phillips@@canada.ca}
#'
#' @description
#'    \code{maquery} performs a meta-analysis on pre-identified factors in a CEDAR query.
#'    It was adapted from the now depreciated cedarr package for Sawmill.
#'
#' @param query
#'    a data frame containing a CEDAR query, with column names as per
#'    \code{\link{stdCol_name}}.
#'
#' @param dropRaw
#'    logical; where \code{dropRaw = TRUE} the individual studies used in the
#'    meta-analyses are dropped from the data frame.
#'
#' @details
#'    Similar factors are combined in the IAM.AMR models using random-effect
#'    meta-analysis. The \code{maquery} function performs meta-analyses on
#'    groups of factors indicated as alike by their metaID.
#'
#' @return
#'    The results of the meta-analyses, appended to the passed data frame.
#'
#' @importFrom metafor rma
#' @importFrom magrittr %<>%
#' @importFrom dplyr filter
#' @importFrom dplyr bind_rows
#' @importFrom dplyr count
#' @importFrom tibble add_row
#'
#' @export
#'
#'


do_MA <- function(query, cedar_version, dropRaw = TRUE, log_base = 10) {

  # Main changes from cedarr to Sawmill:
  #     1) Performs MA on both v1 and v2 inputs instead of just v1
  #     2) Conducts MA with the log(OR) and SE of the log(OR), with a default base of 10
  #        (to match the default base in build_chairs.R), instead of using the natural
  #        logarithm. MA rows in the output csv file will display the OR and SE of the
  #        log(OR), however.

  query %<>% dedupeMA()

  query$logOR <- log(query$odds_ratio, base = log_base)

  mas         <- unique(query$ID_meta[!is.na(query$ID_meta) & !(query$ID_meta == "NA")])

  for (x in mas) {

    g   <- dplyr::filter(query, ID_meta == x)
    mag <- metafor::rma(yi = logOR, sei = se_log_or, data = g)
    mag_OR <- log_base ^ (as.numeric(mag$beta)) #exponentiate the OR for display purposes
    mag_se_log_or <- mag$se
    mag_pval <- as.character(mag$pval)


    host_01 <- g[1,]$host_01
    microbe_01 <- g[1,]$microbe_01
    meta_resistance <- g[1,]$meta_amr

    if (length(unique(g$microbe_02)) > 1) {
      microbe_02  <- "spp."
    } else {
      microbe_02  <- g[1,]$microbe_02
    }

    if (cedar_version == 1) {
      authors <- paste(unique(g$name_short), collapse = ", ")
    }
    else {
      authors <- paste(unique(g$name_bibtex), collapse = ", ")
    }

    factor_title      <- g[1,]$factor_title

    factor_description <- paste("A random effects meta-analysis of outcomes described in ", authors, " related to ", factor_title,
                        ". The outcome of interest is ", meta_resistance, " resistance of ", microbe_01, " in ", host_01,
                        ".", sep = "")
    exposed    <- paste(unique(g$group_exposed), collapse = " or ")
    referent   <- paste(unique(g$group_referent), collapse = " or ")

    if (cedar_version == 1) {
      query <- tibble::add_row(query,
                               #status
                               name_short = "Meta-analysis", #different field names in v1 vs v2
                               #docID
                               host_01           = host_01, #same in v1 and v2
                               host_02           = g[1,]$host_02, #same
                               microbe_01        = microbe_01, #same
                               microbe_02        = microbe_02, #same
                               stage_allocate    = g[1,]$stage_allocate, #same
                               AMR               = meta_resistance, #same
                               factor_title      = factor_title, #same
                               factor_description = factor_description, #same
                               group_exposed     = exposed, #same
                               group_referent    = referent, #same
                               res_format        = "Odds Ratio", #same
                               exclude          = any(g$exclude), #doesn't exist in v2
                               ID_meta           = x, #same
                               #ma_resistance
                               meta_type         = g[1,]$meta_type, #same
                               grain             = "oddsRatioSet", #same
                               #A
                               #B
                               #C
                               #D
                               null_comparison       = any(g$null_comparison), #same
                               low_cell_count        = any(g$low_cell_count), #same
                               odds_ratio        = mag_OR, #same
                               se_log_or         = mag_se_log_or, #same
                               pval              = mag_pval #same
                               #URL
                               #Link
      )
    }
    else {
      query <- tibble::add_row(query,
                               #status
                               name_bibtex       = "Meta-analysis",
                               #docID
                               host_01           = host_01,
                               host_02           = g[1,]$host_02,
                               microbe_01        = microbe_01,
                               microbe_02        = microbe_02,
                               stage_allocate    = g[1,]$stage_allocate,
                               AMR               = meta_resistance,
                               factor_title      = factor_title,
                               factor_description = factor_description,
                               group_exposed     = exposed,
                               group_referent    = referent,
                               res_format        = "Odds Ratio",
                               ID_meta           = x,
                               #ma_resistance
                               meta_type         = g[1,]$meta_type,
                               grain             = "oddsRatioSet",
                               #A
                               #B
                               #C
                               #D
                               low_cell_count    = any(g$low_cell_count),
                               null_comparison   = any(g$null_comparison),
                               odds_ratio        = mag_OR,
                               se_log_or         = mag_se_log_or,
                               pval              = mag_pval
                               #URL
                               #Link
      )
    }

  }

  query %<>% select(-logOR, -meta_amr)

  if (dropRaw == TRUE) {
    dplyr::filter(query, is.na(ID_meta) | ifelse(cedar_version == 1, "name_short", "name_bibtex") == "Meta-analysis")
  }

  return(query)

}



dedupeMA <- function(query) {

  # A factor may be included in more than one meta-analysis. For example, a
  # factor describing resistance to a third-generation cephalosporin may be
  # included in a meta-analysis across other third-generation cephalosporins,
  # but may also be included in a larger meta-analysis across all
  # cephalosporins. Where a factor is included in multiple meta-analyses
  # applicable to a query, duplicate rows will be returned.

  # The dedupeMA function removes these duplicate rows, retaining the largest
  # meta-analysis group available. If the groups are of the same size, they are
  # both retained.

  # The dedupeMA function first separates those rows involved in meta-analysis
  # from those uninvolved into two tibbles. It then searches for duplicate
  # factors. If duplicates exist, the associated meta-analyses are identified
  # for each duplicate, and the size of each meta-analysis is determined. Those
  # which are not the largest are dropped from the 'involved' tibble, and the
  # two tibbles are then reunited.

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
