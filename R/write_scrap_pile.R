



write_scrap_pile <- function(write_scrap_csv = FALSE, write_scrap_csv_path = file.choose()
){

  if(write_scrap_csv == TRUE) {
    readr::write_csv(theError, path = write_err_csv_path)
  }

}


#' @param write_scrap_csv
#'     logical: write the tibble of unusable factors to a .CSV.
#' @param write_scrap_csv_path
#'     string: the location to write the .CSV (default = ask).


#' @param write_err
#'     logical: write the table of factors with omitted data to the global namespace as \code{cedar_error_value_omitted}.
#' @param write_err_csv
#'     logical: write the table of factors with omitted data to a .csv.
#' @param write_err_csv_path
#'     string: the location to write the .csv.
