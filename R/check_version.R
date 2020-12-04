

#' @title
#'   Check that the CEDAR version specified is valid
#'
#' @description
#'   \code{check_version} checks if the CEDAR version specified is valid, and
#'   prompts the user to correct the input.
#'
#' @param cedar_version
#'   numeric [1, 2]: the CEDAR version.
#'
#' @return
#'   NULL


check_version <- function(cedar_version){

  allowed_versions <- c(1, 2)

  while (!(cedar_version %in% allowed_versions)) {

    cedar_version <- readline(prompt=paste("Error",
                              "Please enter a valid CEDAR version number, followed by the [Enter] key",
                              "Acceptable values are: ",
                              paste(allowed_versions, collapse = " or "),
                              "\n",
                              sep = "\n"))

  }
}


