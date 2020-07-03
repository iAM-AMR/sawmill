

#' @title
#'   Check that the CEDAR version specified is valid.
#'
#' @description
#'   \code{check_version} checks if the CEDAR version specified is 1 or 2, else throws an error.
#'
#' @param cedar_version
#'   numeric [1, 2]: the CEDAR version.
#'
#' @return
#'   NULL or stop().


check_version <- function(cedar_version){

  if(cedar_version != 1 & cedar_version != 2){
    stop("The CEDAR query version specified is invalid.")
  }

}









