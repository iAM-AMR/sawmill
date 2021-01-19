

#' @title
#'   Start the sawmill pipeline
#'
#' @description
#'   The \code{start_mill()} function prompts the user to select an exported
#'   CEDAR query (raw timber) and runs the \code{mill()} pipeline with default values.
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

  # Verify that the version is valid

  sub_mill(check_version(cedar_version), "check_version")

  # Calibrate processing tools to the cedar version

  sub_mill(tools   <- set_blade_depth(cedar_version), "set_blade_depth")
  depth_guide <- tools[[1]]
  timber_col_types <- tools[[2]]

  # Start the main pipeline

  sub_mill(planks  <- mill(timber_path = file_path, cuts = depth_guide, col_data_types = timber_col_types, cedar_version = cedar_version), "mill")

  # Save the processed timber (planks), as well as the meta-analysis results and scrap_pile if they exist

  sub_mill(save_csv("processed timber", planks), "save_csv")

  if (exists("scrap_pile")) {sub_mill(save_csv("scrap pile", scrap_pile), "save_csv")}

  if (exists("ma_results_formatted")) {sub_mill(save_csv("meta-analysis results", ma_results_formatted), "save_csv")}

  invisible(readline(prompt = paste0("\nDone.\n",
                           "Press the [Enter] key to exit.")))

  return(planks)

}









