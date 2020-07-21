

#' @title
#'   Start the sawmill Pipeline
#'
#' @description
#'  The \code{start_mill()} function prompts the user for a CEDAR query, the CEDAR query version,
#'  and runs the CEDAR pipeline with useful defaults.
#'
#' @importFrom readxl read_excel
#' @importFrom readr write_csv
#'
#' @export


start_mill <- function(){

  readline(prompt="\nYou will now be asked to provide a CEDAR query. Press any key, followed by the Enter key, to continue.")

  file_path  <- file.choose()

  user_vers  <- readline(prompt="\nWhat version of CEDAR is this export from? Enter 1 or 2, followed by the Enter key, to continue:  ")

  sub_mill(check_version(user_vers), "check_version")

  sub_mill(timber_col_types <- get_col_types(user_vers), "get_col_types")

  sub_mill(log_warnings(raw_timber <- readxl::read_excel(file_path, col_types = timber_col_types)), "log_warnings")

  tryCatch(raw_timber <- readxl::read_excel(file_path, col_types = timber_col_types),
           warning = function(w) {
             sub_mill(handle_col_warnings(), "handle_col_warnings")
           })

  sub_mill(furniture  <- mill(raw_timber, cedar_version = user_vers), "mill")

  readline(prompt = paste0("\n\nYou will now be asked to save the processed timber.\n",
                           "You MUST save the file with a .csv extension.\n",
                           "Press any key, followed by the Enter key, to continue."))

  readr::write_csv(furniture, file.choose())

  readline(prompt = paste0("\nDone.\n",
                           "Press any key, followed by the Enter key, to exit."))
  return(furniture)

}









