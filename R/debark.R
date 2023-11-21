

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



debark <- function(timber_path){

  # CHECK: File Type Supported ------------------------------------------------

  # Get file extension (lower case for later string comparisons).
  timber_file_ext <- tolower(tools::file_ext(timber_path))

  # Set supported extensions.
  supported_file_exts  <- c("csv", "xls", "xlsx")

  # Abort run if timber file extension is not supported.
  if (! timber_file_ext %in% supported_file_exts) {
    errmsg <- glue::glue("'.{timber_file_ext}' files are not supported by",
                         "sawmill. Please specify one of the following file types:",
                         paste(supported_file_exts, collapse = ", "),
                         ".")
    rlang::abort(message = errmsg)
  }

  # This abort was previously doubled; asses impact of refactor.
  # rlang::abort(message = errmsg, rlang::abort(message = errmsg))



  # READ: Raw Timber Specifications -------------------------------------------
  # The raw timber format (column names and data types) is specified in an
  # external file ("raw_timber_specs.csv"). This file is sparse; read with
  # column specifications to avoid guessing.

  # Column types for reading raw_timber_specs
  raw_timber_specs_col_types <- readr::cols(
                                  timber_col_name     = readr::col_character(),
                                  timber_col_required = readr::col_logical(),
                                  sawmill_col_name    = readr::col_character(),
                                  col_spec_csv        = readr::col_character(),
                                  col_spec_xlsx       = readr::col_character(),
                                  timber_obj_name     = readr::col_character(),
                                  timber_field_name   = readr::col_character(),
                                  timber_field_name_r = readr::col_character())

  # Read raw_timber_specs
  raw_timber_specs <- readr::read_csv(file      = system.file("raw_timber_specs.csv",
                                                              package = "sawmill"),
                                      col_types = raw_timber_specs_col_types)



  # CHECK: Required Columns Exist ---------------------------------------------
  # Check if requisite columns exist, abort if requisite columns are missing.

  # Get the names of required columns.
  raw_timber_req_col_names <- raw_timber_specs$timber_col_name[raw_timber_specs$timber_col_required]

  # Read the header of the raw timber to get passed column names.
  if (timber_file_ext == 'csv') {

    timber_passed_col_names <- names(readr::read_csv(file           = timber_path,
                                                     n_max          = 0,
                                                     show_col_types = FALSE))

  } else if (timber_file_ext %in% c("xls", "xlsx")) {

    timber_passed_col_names <- names(readxl::read_excel(path        = timber_path,
                                                        n_max       = 0))

  }

  # Are required columns present?
  raw_timber_req_cols_here  <- raw_timber_req_col_names %in% timber_passed_col_names

  # Abort run if required columns are missing.
  if(any(!raw_timber_req_cols_here)){
    rlang::abort(message = glue::glue("Columns '{raw_timber_req_col_names[!raw_timber_req_cols_here]}' is missing or improperly named."))
  }



  # READ: Timber --------------------------------------------------------------
  # Create a named vector of column specifications for known columns.
  # Timber may contain unknown columns; create a named vector of default (guess)
  # specifications for passed timber. Then, replace guess for known columns.

  if (timber_file_ext == 'csv') {

    # Create a named vector of column specifications (CSV) for raw timber.
    raw_timber_colspec           <- rlang::set_names(raw_timber_specs$col_spec_csv,
                                                     raw_timber_specs$timber_col_name)

    # Create a column specification for the input timber. Default = "?".
    timber_in_colspec            <- rlang::set_names(rep("?", length(timber_passed_col_names)),
                                                     timber_passed_col_names)

    # Replace the column specification for the input timber for the required fields in raw timber.
    timber_in_colspec[intersect(names(raw_timber_colspec), names(timber_in_colspec))] <- raw_timber_colspec[intersect(names(raw_timber_colspec), names(timber_in_colspec))]

    # Re-read the timber with column specification.
    timber_in                    <- readr::read_csv(file      = timber_path,
                                                    col_types = timber_in_colspec,
                                                    show_col_types = FALSE)

  } else if (timber_file_ext %in% c("xls", "xlsx")) {

    # Create a named vector of column specifications (XLS/X) for raw timber.
    raw_timber_colspec           <- rlang::set_names(raw_timber_specs$col_spec_xlsx,
                                                     raw_timber_specs$timber_col_name)

    # Create a column specification for the input timber. Default = "guess".
    timber_in_colspec            <- rlang::set_names(rep("guess", length(timber_passed_col_names)),
                                                     timber_passed_col_names)

    # Replace the column specification for the input timber for the required fields in raw timber.
    timber_in_colspec[intersect(names(raw_timber_colspec), names(timber_in_colspec))] <- raw_timber_colspec[intersect(names(raw_timber_colspec), names(timber_in_colspec))]

    # Re-read the timber with column specification.
    timber_in                    <- readxl::read_excel(path      = timber_path,
                                                       col_types = timber_in_colspec)

  }



  # Remap Names ---------------------------------------------------------------

  # Get the old column names (sawmill).
  raw_timber_req_col_names_old <- raw_timber_specs$sawmill_col_name[raw_timber_specs$timber_col_required]

  # Map the old names onto the new names.
  names(raw_timber_req_col_names) <- raw_timber_req_col_names_old

  # Rename required columns.
  timber_in <- dplyr::rename(timber_in, dplyr::all_of(raw_timber_req_col_names))



  # Add Extra Columns ---------------------------------------------------------

  if(!"ID_meta" %in% timber_passed_col_names){timber_in$ID_meta <- NA_integer_}
  if(!"exclude_sawmill" %in% timber_passed_col_names){timber_in$exclude_sawmill <- FALSE}
  if(!"exclude_sawmill_reason" %in% timber_passed_col_names){timber_in$exclude_sawmill_reason <- NA}



  return(timber_in)

}


