

#' @title
#'    Perform meta-analyses on specified factors in timber
#'
#' @description
#'    \code{do_MA()} performs a meta-analysis on pre-identified factors in a CEDAR timber.
#'
#' @param timber
#'    a tibble of timber, with a table built by \code{\link{build_table}}.
#'
#' @param log_base
#'   numeric: the logarithm base used in the calculation of the log(OR). It should
#'   match that used to calculate SE(log(OR)) in \code{\link{build_chairs}}
#'
#' @param cedar_version
#'   numeric [1,2]: the version of CEDAR that created the export.
#'
#' @details
#'    Similar factors are combined in the iAM.AMR models using random-effect
#'    meta-analysis. The \code{do_MA} function performs meta-analyses on
#'    groups of factors indicated as alike by their metaID.
#'
#' @return
#'    The results of the meta-analyses, appended to the passed timber.
#'
#' @importFrom metafor rma
#' @importFrom magrittr %<>%
#' @importFrom dplyr filter select
#' @importFrom tibble add_row
#'
#' @export

# Requires: ID_meta, logOR, se_log_OR




do_MA <- function(timber, log_base = exp(1), cedar_version = 2) {

  # Extract the set of all pods of meta-analyses specified in timber. Note,
  # unique() does not support igmore.na or rm.na, so we must use a more complex
  # function.

  pod_set <- unique(timber$ID_meta[!is.na(timber$ID_meta) & !(timber$ID_meta == "NA")])

  # If no meta-analyses are specified, return the timber unchanged.

  if (length(pod_set) == 0) {return(timber)}

  # Calculate the log(OR)

  timber$logOR <- log(timber$odds_ratio, base = log_base)

  # Create a list to record the results in the global environment.

  ma_results <<- list()

  # For each pod: extract the factors, run the meta-analysis, save a copy of the
  # results to the global environment,

  for (pod_num in pod_set) {

    # Subset factors.

    pod    <- dplyr::filter(timber, ID_meta == pod_num)

    # Run random-effects meta-analysis using REML as an estimation method.

    pod_ma <- metafor::rma(yi = logOR, sei = se_log_or, method = "REML", data = pod)

    # Save meta-analysis result objects in the global environment for review.

    ma_results[[paste0("ma_", pod_num)]] <<- pod_ma


    # Gather fields for the meta-analysis result rows that will be added to the timber

    pod_authors <- paste(unique(pod$ref_key), collapse = ", ")

    pod_title   <- pod[1,]$factor_title

    pod_resistance <- pod[1,]$meta_amr

    pod_microbe_01 <- pod[1,]$microbe_01

    pod_host_01    <- pod[1,]$host_01

    pod_desc    <- paste("A random effects meta-analysis of outcomes described in ", pod_authors, " related to ", pod_title,
                         ". The outcome of interest is ", pod_resistance, " resistance of ", pod_microbe_01, " in ", pod_host_01,
                         ".", sep = "")


    if (length(unique(pod$microbe_02)) > 1) {
      pod_microbe_02  <- "spp."
    } else {
      pod_microbe_02  <- pod[1,]$microbe_02
    }


    timber <- tibble::add_row(timber,
                              #status
                              ref_key            = "Meta-analysis",
                              #docID
                              host_01            = pod_host_01,
                              host_02            = pod[1,]$host_02,
                              microbe_01         = pod_microbe_01,
                              microbe_02         = pod_microbe_02,              #*
                              stage_allocate     = pod[1,]$stage_allocate,
                              AMR                = pod_resistance,
                              factor_title       = pod_title,
                              factor_description = pod_desc,
                              group_exposed      = paste(unique(pod$group_exposed), collapse = " or "),
                              group_referent     = paste(unique(pod$group_referent), collapse = " or "),
                              res_format         = "Odds Ratio",
                              ID_meta            = pod_num,
                              meta_amr          = pod_resistance,
                              meta_type         = pod[1,]$meta_type,
                              grain             = "oddsRatioSet",
                              #A
                              #B
                              #C
                              #D
                              low_cell_count    = any(pod$low_cell_count), #
                              null_comparison   = any(pod$null_comparison), #
                              odds_ratio        = log_base ^ (as.numeric(pod_ma$beta)),
                              se_log_or         = pod_ma$se,
                              pval              = as.character(pod_ma$pval)
                              #URL
                              #Link
                              )


  }

  return(timber)


}


