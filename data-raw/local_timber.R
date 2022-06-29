

#' @title
#'   Refresh the local (cached) copy of timber
#'
#' @description
#'   \code{refresh_local_timber()} updates the local (cached) copy of timber,
#'   storing the object as 'data/local_timber.rda'. This requires access to
#'   CEDAR_forest, and therefore must be run locally at present.
#'
#' @return
#'   A tibble of timber with standardized column names and additional columns
#'   for exclusion and project filtering.
#'
#' @import RPostgres
#' @importFrom DBI dbConnect dbGetQuery
#' @importFrom readr read_csv
#' @importFrom dplyr rename
#' @importFrom rlang set_names
#' @importFrom usethis use_data
#'


refresh_local_timber <-  function(){

  # Connect to local database.
  dbcon <- DBI::dbConnect(RPostgres::Postgres(),
                        host = "10.10.0.10",
                        port = 5432,
                        dbname = "test_cedar_3",
                        user = "postgres",
                        password = "iCEDARwhatyoudidthere")

  # Use timber SQL from str(*.query()) in make_timber.py.
  # Modified to include:
  # "cedar_core_reference"."is_archived", "cedar_core_reference"."is_excluded_extract",
  # "cedar_core_reference"."capture_search_2019", "cedar_core_reference"."cedar_extract_esr"

  timber_sql           <- 'SELECT "cedar_core_res_outcome"."id", "cedar_core_res_outcome"."pid_ro", "cedar_core_factor"."reference_id", "cedar_core_reference"."pid_reference", "cedar_core_reference"."refwk", "cedar_core_reference"."publish_doi", "cedar_core_reference"."publish_pmid", "cedar_core_reference"."key_bibtex", "cedar_core_reference"."ref_title", "cedar_core_reference"."is_archived",  "cedar_core_reference"."is_excluded_extract", "cedar_core_reference"."capture_search_2019", "cedar_core_reference"."cedar_extract_esr", "cedar_core_location_01"."country", "cedar_core_study_design"."design", "cedar_core_res_outcome"."factor_id", "cedar_core_factor"."pid_factor", "cedar_core_factor"."factor_title", "cedar_core_factor"."factor_description", "cedar_core_factor"."group_factor", "cedar_core_factor"."group_comparator", "cedar_core_host_01"."host_name", "cedar_core_host_02"."host_subtype_name", "cedar_core_factor"."host_production_stream_id", "cedar_core_factor"."host_life_stage_id", "cedar_core_production_stage"."stage", T11."stage", "cedar_core_moa_type"."res_format", "cedar_core_moa_unit"."res_unit", "cedar_core_atc_vet"."levelname_4_coarse", "cedar_core_atc_vet"."levelname_5", "cedar_core_genetic_element"."element_name", "cedar_core_microbe_01"."microbe_name", "cedar_core_microbe_02"."microbe_subtype_name", "cedar_core_res_outcome"."is_figure_extract", "cedar_core_figure_extract_method"."method_name", "cedar_core_res_outcome"."figure_extract_reproducible", "cedar_core_res_outcome"."contable_a", "cedar_core_res_outcome"."contable_b", "cedar_core_res_outcome"."contable_c", "cedar_core_res_outcome"."contable_d", "cedar_core_res_outcome"."prevtable_a", "cedar_core_res_outcome"."prevtable_b", "cedar_core_res_outcome"."prevtable_c", "cedar_core_res_outcome"."prevtable_d", "cedar_core_res_outcome"."table_n_exp", "cedar_core_res_outcome"."table_n_ref", "cedar_core_res_outcome"."odds_ratio", "cedar_core_res_outcome"."odds_ratio_lo", "cedar_core_res_outcome"."odds_ratio_up", "cedar_core_res_outcome"."odds_ratio_sig", "cedar_core_res_outcome"."odds_ratio_confidence" FROM "cedar_core_res_outcome" LEFT OUTER JOIN "cedar_core_factor" ON ("cedar_core_res_outcome"."factor_id" = "cedar_core_factor"."id") LEFT OUTER JOIN "cedar_core_reference" ON ("cedar_core_factor"."reference_id" = "cedar_core_reference"."id") LEFT OUTER JOIN "cedar_core_location_01" ON ("cedar_core_reference"."ref_country_id" = "cedar_core_location_01"."id") LEFT OUTER JOIN "cedar_core_study_design" ON ("cedar_core_reference"."study_design_id" = "cedar_core_study_design"."id") LEFT OUTER JOIN "cedar_core_host_01" ON ("cedar_core_factor"."host_level_01_id" = "cedar_core_host_01"."id") LEFT OUTER JOIN "cedar_core_host_02" ON ("cedar_core_factor"."host_level_02_id" = "cedar_core_host_02"."id") LEFT OUTER JOIN "cedar_core_production_stage" ON ("cedar_core_factor"."group_allocate_production_stage_id" = "cedar_core_production_stage"."id") LEFT OUTER JOIN "cedar_core_production_stage" T11 ON ("cedar_core_res_outcome"."group_observe_production_stage_id" = T11."id") LEFT OUTER JOIN "cedar_core_moa_type" ON ("cedar_core_res_outcome"."moa_type_id" = "cedar_core_moa_type"."id") LEFT OUTER JOIN "cedar_core_moa_unit" ON ("cedar_core_res_outcome"."moa_unit_id" = "cedar_core_moa_unit"."id") LEFT OUTER JOIN "cedar_core_atc_vet" ON ("cedar_core_res_outcome"."resistance_id" = "cedar_core_atc_vet"."id") LEFT OUTER JOIN "cedar_core_genetic_element" ON ("cedar_core_res_outcome"."resistance_gene_id" = "cedar_core_genetic_element"."id") LEFT OUTER JOIN "cedar_core_microbe_01" ON ("cedar_core_res_outcome"."microbe_level_01_id" = "cedar_core_microbe_01"."id") LEFT OUTER JOIN "cedar_core_microbe_02" ON ("cedar_core_res_outcome"."microbe_level_02_id" = "cedar_core_microbe_02"."id") LEFT OUTER JOIN "cedar_core_figure_extract_method" ON ("cedar_core_res_outcome"."figure_extract_method_id" = "cedar_core_figure_extract_method"."id")'

  # Get timber from database.
  local_timber         <- DBI::dbGetQuery(dbcon, timber_sql)

  # Get timber specifications.
  raw_timber_specs     <- readr::read_csv(file = system.file("raw_timber_specs.csv", package = "sawmill", mustWork = TRUE))

  # Generate a timber column specification.
  local_timber_colspec <- rlang::set_names(raw_timber_specs$timber_field_name_r, raw_timber_specs$timber_col_name)

  # Rename per column specification.
  local_timber         <- dplyr::rename(local_timber, local_timber_colspec)

  # Update local cache.
  usethis::use_data(local_timber, overwrite = TRUE)

  return(local_timber)

}



