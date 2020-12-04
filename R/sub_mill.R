

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






# sub_mill_2 <- function(fun_run) {
#
#   call_set <- substitute(fun_run)
#
#   if("<-" %in% as.character(call_set)) {
#     fun_name <- as.character(call_set[[3]])
#   } else {
#     fun_name <- as.character(call_set[[1]])
#   }
#
#   tryCatch(
#     {eval(call_set)
#     },
#     error = function(cond) {message(paste("\n", "ERR @", fun_name, "function: \n", cond))}
#   )
#
#   return(fun_name)
#
# }

