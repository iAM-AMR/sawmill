

#' @title
#'   Standardize Column Names or "Debark" Timber
#'
#' @description
#'   \code{debark()} standardizes the column names of timber for use in \code{sawmill}.
#'
#' @param timber
#'   a tibble of timber.
#'
#' @param cedar_version
#'   numeric [1,2]: the version of CEDAR that created the export..
#'
#' @return
#'   A tibble of timber with standardized column names.
#'
#' @importFrom dplyr rename
#'
#' @export



debark <- function(timber_path, cuts, col_data_types){

  raw_timber <- readxl::read_excel(timber_path)

  # Screen for missing columns (report which ones are missing)
  missing <- setdiff(as.vector(depth_guide), names(raw_timber))

  if(length(missing)>0) {
    stop(paste('ERROR: The following requisite columns are missing from your timber: ',
               paste(missing, collapse = ", ")
        )
    )
  }

  # Screen for cells that do not match the expected data type for their column

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

  # Create Scrap Pile for unusable factors.

  scrap_pile <<- data.frame()

  return(timber)

}






