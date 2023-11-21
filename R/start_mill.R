

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
#' @export


start_mill <- function(){

  # Remove existing objects from the global environment, from previous sawmill
  # runs. Suppress not found warnings (generated on first run in clean env).

  suppressWarnings(
    rm(scrap_pile, ma_results, ma_results_formatted, pos = globalenv())
  )



  # Define Prompts ------------------------------------------------------------

  prompt_welcome <- glue::glue("


                               Hi! Welcome to sawmill.

                               This function will walk you through processing
                               'raw timber' (a query with a specific structure)
                               from CEDAR, for use in the iAM.AMR project.

                               ")

  prompt_start   <- glue::glue("
                               To start sawmill, press the [Enter] key to select
                               a local .CSV or .XLS/X file.

                               The file selection window may not appear in the
                               foreground - look carefully!

                               ")

  prompt_save    <- glue::glue("

                               Milling is complete.

                               You must now save your processed timber.

                               ")

  prompt_scraps  <- glue::glue("

                               Some outcomes could not be processed, and are in the 'scrap pile'.

                               You must now save the scrap pile to a different file.

                               ")

  prompt_meta    <- glue::glue("

                               The results of your meta-analyses are available.

                               You must now save these results to a different file.

                               ")

  prompt_exit    <- glue::glue("

                               Done.

                               Press [Enter] to Exit.
                               Timber will be printed to console.
                               Some warnings are expected. See documentation.

                               ")

  prompt_save_file <- glue::glue("

                               To save to a file, press the [Enter] key.

                               The file selection window may not appear in the
                               foreground - look carefully!

                               ")


  # Mill ----------------------------------------------------------------------

  print(prompt_welcome)

  invisible(readline(prompt = prompt_start))

  file_path  <- file.choose()

  sub_mill(timber_out  <- mill(timber_path = file_path),
                               "sawmill")

  print(prompt_save)

  message("You must save your timber with a '.csv' extension.")

  invisible(readline(prompt = prompt_save_file))

  readr::write_csv(timber_out, file.choose())



  # Write Extra Files ---------------------------------------------------------

  if (exists("scrap_pile")) {

    print(prompt_scraps)

    message("You must save your scrap pile with a '.csv' extension.")

    invisible(readline(prompt = prompt_save_file))

    readr::write_csv(scrap_pile, file.choose())

  }


  if (exists("ma_results_formatted")) {

    print(prompt_meta)

    message("You must save your meta-analysis results with a '.csv' extension.")

    invisible(readline(prompt = prompt_save_file))

    readr::write_csv(ma_results_formatted, file.choose())

  }


  invisible(readline(prompt = prompt_exit))

  return(timber_out)

}




