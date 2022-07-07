

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



# This function reads the XLSX. Then, it converts cols to standard. Then it sees which are missing.

test_path_csv <- "C:/Users/test/timber.csv"
test_path_xls <- "C:/Users/test/timber.xls"
test_path_xlsx <- "C:/Users/test/timber.xlsx"


# timber_path <- here::here("timber_test.xlsx")



debark2 <- function(timber_path){

  # Check file type compatibility.
  # Future use for import of CSV.
  timber_file_type <- get_supported_file_type(timber_path)

  # Read in timber without column specification.
  timber_in           <- readxl::read_excel(timber_path)
  timber_in_col_names <- colnames(timber_in)

  # Column types for reading raw_timber_specs
  raw_timber_specs_col_types <- cols(timber_col_name     = readr::col_character(),
                                     timber_col_required = readr::col_logical(),
                                     sawmill_col_name    = readr::col_character(),
                                     col_spec_csv        = readr::col_character(),
                                     col_spec_xlsx       = readr::col_character(),
                                     timber_obj_name     = readr::col_character(),
                                     timber_field_name   = readr::col_character(),
                                     timber_field_name_r = readr::col_character())

  # Read raw_timber_specs
  raw_timber_specs <- readr::read_csv(file      = system.file("raw_timber_specs.csv", package = "sawmill"),
                                      col_types = raw_timber_specs_col_types)

  # Get the names of required columns.
  raw_timber_req_col_names     <- raw_timber_specs$timber_col_name[raw_timber_specs$timber_col_required]

  # Are required columns present in the input timber?
  raw_timber_req_cols_here     <- raw_timber_req_col_names %in% timber_in_col_names

  # If any required columns are missing, abort.
  if(any(!raw_timber_req_cols_here)){
    rlang::abort(message = glue::glue("Column '{raw_timber_req_col_names[!raw_timber_req_cols_here]}' is missing or improperly named."))
  }

  # Create a column specification for raw timber.
  raw_timber_colspec           <- set_names(raw_timber_specs$col_spec_xlsx, raw_timber_specs$timber_col_name)

  # Create a column specification for the input timber. Default = "guess".
  timber_in_colspec            <- set_names(rep("guess", length(timber_in_col_names)), timber_in_col_names)

  # Replace the column specification for the input timber for the required fields in raw timber.
  timber_in_colspec[intersect(names(raw_timber_colspec), names(timber_in_colspec))] <- raw_timber_colspec[intersect(names(raw_timber_colspec), names(timber_in_colspec))]

  # Re-read the timber with column specification.
  timber_in                    <- readxl::read_excel(timber_path, col_types = timber_in_colspec)


  # Get the old column names (sawmill).
  raw_timber_req_col_names_old <- raw_timber_specs$sawmill_col_name[raw_timber_specs$timber_col_required]

  # Map the old names onto the new names.
  names(raw_timber_req_col_names) <- raw_timber_req_col_names_old

  # Rename required columns.
  timber_in <- rename(timber_in, raw_timber_req_col_names)

  if(!"exclude_sawmill" %in% timber_in_col_names){timber_in$exclude_sawmill <- FALSE}
  if(!"exclude_sawmill_reason" %in% timber_in_col_names){timber_in$exclude_sawmill_reason <- NA}

  return(timber_in)

}


get_supported_file_type <- function(path){

  extn   <- tools::file_ext(path)
  errmsg <- glue::glue("Filetype '.{extn}' is not supported. Please use .xlsx.")

  ifelse(extn %in% c("xls", "xlsx"), "xlsx",
    ifelse(extn == "csv", rlang::abort(message = errmsg, rlang::abort(message = errmsg))))

}

#get_supported_file_type(test_path_xlsx)
#get_supported_file_type(test_path_csv)

#timber_col_name	timber_col_required	sawmill_col_name	col_spec_csv	col_spec_xlsx








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

  return(timber)

}






