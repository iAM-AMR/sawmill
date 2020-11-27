

#' @title
#'   Standardize column names and screen for data entry errors, or "debark" timber
#'
#' @description
#'   \code{debark()} standardizes the column names of timber for use in \code{sawmill}.
#'   It also reports the names of any missing required columns, as well as the row/column
#'   locations of any cells of an unexpected data type (i.e. a string of text in a
#'   column that is supposed to contain numeric values only), as per \code{col_data_types}.
#'   Finally, \code{debark()} adds the columns \emph{exclude_sawmill} and
#'   \emph{exclude_sawmill_reason}, to be filled in later by \code{sawmill} as it encounters
#'   unusable factors that need to be excluded from further processing steps.
#'
#' @param timber_path
#'   character: the file path to the raw timber
#'
#' @param cuts
#'   named vector: a mapping of the input raw timber names to their standardized column names,
#'   produced by \code{set_blade_depth()}
#'
#' @param col_data_types
#'   a vector containing the expected data type for each column in the raw timber (i.e. "text"),
#'   produced by \code{set_blade_depth()}
#'
#' @return
#'   A tibble of timber with standardized column names and additional columns
#'   \emph{exclude_sawmill} and \emph{exclude_sawmill_reason}. If columns are missing and/or if
#'   unexpected data types are present, a prompt and/or error message will be returned instead.
#'
#' @importFrom dplyr rename
#' @importFrom readxl read_excel
#'
#' @export



debark <- function(timber_path, cuts, col_data_types){

  raw_timber <- readxl::read_excel(timber_path)

  # Screen for missing columns (report which ones are missing)
  missing <- setdiff(as.vector(cuts), names(raw_timber))

  if(length(missing)>0) {
    stop(paste('ERROR: The following requisite columns are missing from your timber: ',
               paste(missing, collapse = ", ")
        )
    )
  }

  # Screen for cells that do not match the expected data type for their column(s)

  sub_mill(log_warnings(raw_timber <- readxl::read_excel(timber_path, col_types = col_data_types)), "log_warnings")

  tryCatch(raw_timber <- readxl::read_excel(timber_path, col_types = col_data_types),
    warning = function(w) {
      sub_mill(handle_col_warnings(), "handle_col_warnings")
    })


  timber <- dplyr::rename(raw_timber, cuts)


  # Add exclude_sawmill and exclude_sawmill_reason columns to indicate factors
  # to omit from further processing.

  timber$exclude_sawmill <- FALSE
  timber$exclude_sawmill_reason <- NA

  # Create Scrap Pile for unusable factors, and save it to the global environment

  scrap_pile <<- data.frame()

  return(timber)

}






