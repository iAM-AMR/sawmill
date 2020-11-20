

#' @title
#'   Start the sawmill pipeline
#'
#' @description
#'   The \code{start_mill()} function prompts the user to select an exported
#'   CEDAR query (timber) and runs the \code{mill()} pipeline with default values.
#'
#' @details
#'   The \code{start_mill()} function is the primary entry-point for end users -
#'   it is a one-click-to-run function, and is automatically called during
#'   bootstrap installation of sawmill.
#'
#'   By default, cedar_version is set to 2; all modern timber was created in
#'   version 2.
#'
#' @param cedar_version
#'   numeric [1,2]: the version (1 or 2) of CEDAR, used to create timber.
#'
#' @importFrom readxl read_excel
#' @importFrom readr write_csv
#'
#' @export


start_mill <- function(cedar_version = 2){

  # Prompt the user to press [Enter] to continue, and select a timber.
  # readline() is wrapped in invisible(), to avoid printing keys to console.

  invisible(readline(prompt=paste("Welcome to sawmill.",
                                  "Press the [Enter] key to start_mill; you will be asked to select a query (timber) from CEDAR.",
                                  sep = "\n")))
  # Select timber.

  file_path  <- file.choose()





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









