

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

  readline(prompt="\nYou will now be asked to provide a CEDAR query. Press any key to continue.")

  file_path  <- file.choose()
  raw_timber <- readxl::read_excel(file_path)

  user_vers  <- readline(prompt="\nWhat version of CEDAR is this export from? Enter 1 or 2 to continue:  ")

  check_version(user_vers)

  furniture  <- mill(raw_timber, cedar_version = user_vers)

  readline(prompt = paste0("\n\nYou will now be asked to save the processed timber.\n",
                           "You MUST save the file with a .csv extension.\n",
                           "Press any key to continue."))

  readr::write_csv(furniture, file.choose())

  readline(prompt = paste0("\nDone.\n",
                           "Press any key to exit."))
  return(furniture)

}




