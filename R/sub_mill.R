

#' @title
#'   Run a Substep of the sawmill Pipeline, with Error Handling
#'
#' @description
#'  The \code{sub_mill()} runs a substep in the sawmill pipeline, providing a message to
#'  the user in the event of an error. This message will specify which function caused
#'  the error.
#'
#' @param mill_step
#'   an expression that calls a function that represents a main step in the
#'   sawmill pipeline
#'
#' @param step_name
#'   string: the name of the function being called in the \code{mill_step} parameter
#'
#' @export


sub_mill <- function(mill_step, step_name) {
  tryCatch(mill_step,
           error = function(e) {
             stop(paste("ERROR in ", step_name, "function: \n", e))
           },
           finally = message(paste("Processed function: ", step_name))
  )
}
