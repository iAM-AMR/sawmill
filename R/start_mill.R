

#' @title
#'   Start the interactive sawmill pipeline
#'
#' @description
#'   The \code{start_mill()} function prompts the user to select a CEDAR query
#'   (raw timber) and runs the \code{mill()} pipeline with default values.
#'
#' @details
#'   The \code{start_mill()} function is the primary entry-point for users --
#'   it is a one-click-to-run function, and is automatically called during
#'   bootstrap installation of sawmill.
#'
#'   \code{start_mill()} also removes objects from previous runs.
#'
#' @param cedar_version
#'   numeric: a supported timber version number (1|2|3). Currently unsupported.
#'
#' @export


start_mill <- function(cedar_version = 2){

  # Remove existing objects from the global environment, from previous sawmill
  # runs. Suppress not found warnings (generated on first run in clean env).

  suppressWarnings(
    rm(scrap_pile, ma_results, ma_results_formatted, pos = globalenv())
  )

  # Prompt the user to press [Enter] to continue, and select a timber.
  # readline() is wrapped in invisible(), to avoid printing keys to console.

  invisible(readline(prompt=paste("Welcome to sawmill.",
                                  "Press the [Enter] key to start_mill; you will be asked to select a query (timber) from CEDAR.",
                                  sep = "\n")))
  # Select timber.

  file_path  <- file.choose()

  # Start the main pipeline

  sub_mill(planks  <- mill(timber_path = file_path, cedar_version = cedar_version), "mill")

  # Save the processed timber (planks), as well as the meta-analysis results and scrap_pile if they exist

  sub_mill(save_csv("processed timber", planks), "save_csv")

  if (exists("scrap_pile")) {sub_mill(save_csv("scrap pile", scrap_pile), "save_csv")}

  if (exists("ma_results_formatted")) {sub_mill(save_csv("meta-analysis results", ma_results_formatted), "save_csv")}

  invisible(readline(prompt = paste0("\nDone.\n",
                           "Press the [Enter] key to exit.")))

  return(planks)

}









