

#' @title
#'    Generate a suggested Analytica identifier
#'
#' @description
#'    \code{add_ident()} adds a column to the passed tibble of timber, containing an
#'    identifier for use in Analytica.
#'
#' @param timber
#'    a tibble of timber, with a table built by \code{\link{build_table}}.
#'
#' @param cedar_version
#'    numeric [1,2]: the version of CEDAR that created the export.
#'
#' @details
#'    Each node in an Analytica model requires an identifier - a unique string,
#'    of max 20 characters, with no spaces. \code{add_ident} generates the
#'    string, which includes the factor (or meta-analysis number), and is based
#'    on the title of the node.
#'
#'    The identifier is generated in the format "R00001_name_here" (or "M00001_name_here" if
#'    for a meta-analysis result).
#'
#' @return
#'    The passed tibble of timber with an additional column \emph{identifier} containing the
#'    generated identifiers.
#'
#' @export


add_ident <- function(timber, cedar_version = 2) {

  nameCol <- "ref_key"

  # Set prefix to M if the factor is a meta-analysis result
  prefix <- ifelse(timber[nameCol] == "Meta-analysis", "M", "R")

  # Function to get a zero-padded, 5-digit number where either the factor ID or the metaID serves
  # as the basis for the number
  getnum <- function(name, ID, metaID) {

    if (name == "Meta-analysis") {
      formatC(metaID, width = 5, format = "d", flag = "0")
    }
    else {
      formatC(ID, width = 5, format = "d", flag = "0")
    }

  }

  # Get number using the getnum function above
  number <- as.vector(mapply(getnum, timber[[nameCol]], as.numeric(timber[["ID"]]), as.numeric(timber[["ID_meta"]])))

  # Build the suffix from the factor title
  suffix <- substr(timber[["factor_title"]], start = 1, stop = 13)
  suffix <- gsub(pattern = " ", replacement = "_", x = suffix)

  # Combine prefix, number, and suffix
  iden <- as.vector(mapply(paste, prefix, number, "_", suffix, MoreArgs = list(sep = "")))

  if ( length(iden) == 0 ) {

    timber["identifier"] <- "NA"

  } else {
    # Add identifiers to the timber
    timber["identifier"] <- iden
  }


  return(timber)

}

