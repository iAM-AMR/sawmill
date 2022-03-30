

#' @title
#'   Reorder the processed timber's fields
#'
#' @description
#'   \code{reorder_fields()} organizes the left-to-right placement of the fields (columns) to match
#'   the order in which they are arranged in the iAM.AMR Analytica model nodes. It also deletes the
#'   fields \code{exclude_sawmill} and \code{exclude_sawmill_reason} from the final output, as
#'   these are only needed internally, to filter out unusable factors into the \code{scrap_pile}.
#'
#' @param timber
#'    a tibble of timber, returned from \code{\link{add_ident}}.
#'
#' @param cedar_version
#'    numeric [1,2]: the version of CEDAR that created the export.
#'
#' @return
#'    The passed tibble of processed timber with reorganized columns, ready for Analytica.
#'
#' @importFrom dplyr select
#'
#' @export


reorder_fields <- function(timber, cedar_version) {

  # Only reorder v2 timber
  if(cedar_version == 1) {return(timber)}

  # Delete exclude_sawmill and exclude_sawmill_reason fields
  timber_del <- dplyr::select(timber, -c("exclude_sawmill", "exclude_sawmill_reason"))

  # Only include the logOR field if a meta-analysis was done
  if (exists("ma_results")) {field_names <- c("grdi", "ID", "RWID", "identifier", "factor_title",
                                              "factor_description", "ref_key", "year", "html_link",
                                              "group_exposed", "group_referent",
                                              "odds_ratio", "se_log_or", "pval", "logOR",
                                              "entered_3", "notes_3", "initials_3",
                                              "entered_2", "notes_2", "initials_2",
                                              "entered_1", "notes_1", "initials_1",
                                              "from_2020.05.05_v2", "from_2020.04.14_v1",
                                              "ID_meta", "meta_amr", "meta_type",
                                              "AMR", "am_class", "host_01", "host_02", "microbe_01",
                                              "microbe_02", "stage_allocate", "stage_observe",
                                              "res_unit", "res_format", "grain", "A", "B", "C", "D",
                                              "P", "R", "Q", "S", "nexp", "nref", "odds",
                                              "oddslo", "oddsup", "oddsig", "oddsci",
                                              "low_cell_count", "null_comparison",
                                              "insensible_prev_table", "doi", "pmid", "url",
                                              "last_name", "core_data_match", "moved_from_other_sheet")}

  else {field_names <- c("grdi", "ID", "RWID", "identifier", "factor_title",
                         "factor_description", "ref_key", "year", "html_link",
                         "group_exposed", "group_referent",
                         "odds_ratio", "se_log_or", "pval",
                         "entered_3", "notes_3", "initials_3",
                         "entered_2", "notes_2", "initials_2",
                         "entered_1", "notes_1", "initials_1",
                         "from_2020.05.05_v2", "from_2020.04.14_v1",
                         "ID_meta", "meta_amr", "meta_type",
                         "AMR", "am_class", "host_01", "host_02", "microbe_01",
                         "microbe_02", "stage_allocate", "stage_observe",
                         "res_unit", "res_format", "grain", "A", "B", "C", "D",
                         "P", "R", "Q", "S", "nexp", "nref", "odds",
                         "oddslo", "oddsup", "oddsig", "oddsci",
                         "low_cell_count", "null_comparison",
                         "insensible_prev_table", "doi", "pmid", "url",
                         "last_name", "core_data_match", "moved_from_other_sheet")}

  # Reorder the fields
  timber_reordered <- timber_del[field_names]

  return(timber_reordered)

}




