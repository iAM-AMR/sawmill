

#' @title
#'   Saves the passed tibble to a csv file
#'
#' @description
#'   \code{save_csv()} saves the passed tibble of data to a csv file, prompting the
#'   user for a file name, as well as the file path to a chosen save location along the way.
#'
#' @param result_name
#'    a description of the type of data being saved (i.e. the processed timber).
#'
#' @param tibble_save
#'    the tibble of data to be saved.
#'
#' @return
#'    a csv file, saved to a location of the user's choice.
#'
#' @importFrom readr write_csv
#'
#' @export


save_csv <- function(result_name, tibble_save) {

  invisible(readline(prompt = paste0("\n\nYou will now be asked to save the ", result_name, ".\n",
                                     "You MUST save the file with a .csv extension.\n",
                                     "Press the [Enter] key to continue.")))

  readr::write_csv(tibble_save, file.choose())


  invisible(readline(prompt = "Press the [Enter] key to continue."))

}
