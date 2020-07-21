

#' @title
#'    Generate a Suggested Analytica Identifier
#'
#' @description
#'    \code{add_ident()} adds a column to the passed tibble of timber, containing an
#'    identifier for use in Analytica.
#'
#' @param query
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
#'    The identifier is generated in the format "R00001_name_here".
#'
#' @return
#'    The passed tibble of timber with an additional column containing the generated
#'    identifiers.
#'
#' @export


add_ident <- function(query, cedar_version = 2) {

  if (cedar_version == 1) {
    nameCol <- "name_short"
  }
  else {
    nameCol <- "name_bibtex"
  }

  prefix <- ifelse(query[nameCol] == "Meta-analysis", "M", "R")

  getnum <- function(name, ID, metaID) {

    if (cedar_version == 1) {
      if (name == "Meta-analysis") {
        formatC(metaID, width = 5, flag = 0)
      } else {
        formatC(ID, width = 5, flag = 0)
      }
    }
    else {
      formatC(ID, width = 5, digits = 0, format = "f")
    }

  }

  number <- as.vector(mapply(getnum, query[[nameCol]], query[["ID"]], query[["ID_meta"]]))

  suffix <- substr(query[["factor_title"]], start = 1, stop = 13)
  suffix <- gsub(pattern = " ", replacement = "_", x = suffix)

  iden <- as.vector(mapply(paste, prefix, number, "_", suffix, MoreArgs = list(sep = "")))

  query["identifier"] <- iden

  return(query)

}

