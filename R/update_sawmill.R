

# Update sawmill

#' @title
#'   Update sawmill
#'
#' @description
#'
#' @return
#'
#' @export



update_sawmill <- function(){

  try(detach("package:sawmill"))

  usePackage <- function(p) {
    if (!is.element(p, installed.packages()[,1])) install.packages(p, dep = TRUE)
    library(p, character.only = TRUE)
  }

  usePackage("remotes")

  remotes::install_github("iAM-AMR/sawmill@*release")


}


