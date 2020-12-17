

#' @title
#'    Format all meta-analyses results
#'
#' @description
#'    \code{format_ma_results()} converts the full meta-analysis results (all 100 parameters)
#'    into a tabular format, and organizes them by meta-analysis ID, so that they are ready to be
#'    written to a csv file. It then saves them to the global environment.
#'
#' @param ma_results
#'    list: the raw meta-analysis results provided by \code{\link{do_MA}}.
#'
#' @param ma_ids
#'    a vector containing each unique meta-analysis ID in the timber.
#'
#' @importFrom dplyr select
#' @importFrom stringr str_split
#'
#' @export


format_ma_results <- function(ma_results, ma_ids) {

  # Convert ma_results from an S3 object to a list
  ma_results_u <- unlist(ma_results)

  # Convert ma_results from a list into a data frame
  ma_results_df <- data.frame(matrix(ma_results_u, nrow=length(ma_results), byrow=T))

  # Get the names for each column in the data frame, and assign them to the data frame
  raw_names <- names(ma_results_u)
  for (i in 1:ncol(ma_results_df)) {

    current_raw_name = raw_names[i]

    # Remove the "ma_<id>" prefix from the column name
    col_name = stringr::str_split(current_raw_name, "[.]",2)[[1]][2]

    # Assign the name to the current column of the data frame
    names(ma_results_df)[i] <- col_name
  }

  # Delete the call column
  ma_results_df <- dplyr::select(ma_results_df, -"call")

  # Add a column for the meta-analysis IDs
  ma_results_df <- cbind(ID_meta = ma_ids, ma_results_df)

  # Unlist all list-columns in the data frame so that it can be written to a csv
  handle_list_cols <- function(data) {
    ListCols <- sapply(data, is.list)
    cbind(data[!ListCols], t(apply(data[ListCols], 1, unlist)))
  }

  # Save the final result to the global environment
  ma_results_formatted <<- handle_list_cols(ma_results_df)

}
