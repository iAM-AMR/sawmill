

#' @title
#'    Generate HTML links using a document identifier
#'
#' @description
#'    \code{add_HTMLink()} adds a column to the passed tibble, containing the HTML Link
#'    corresponding to the document identifier provided.
#'
#' @param timber
#'    a tibble of timber, with a table built by \code{\link{build_table}}.
#'
#' @details
#'    A document identifier is a unique sequence of letters and/or numbers
#'    assigned to a published work to facilitate its unambiguous reference.
#'    Generally, these identifiers allow for a given work to be assigned a
#'    standardized URL. The \code{add_HTMLink} function generates the HTML
#'    link for the following supported document identifier standards:
#'
#'    \itemize{
#'        \item DOI (Digital Object Identifier)
#'        \item PMID (PubMed ID)
#'    }
#'
#'    The \code{add_HTMLink} function works by detecting the appropriate
#'    document identifier type, using regular expressions. The DOI is identified
#'    as beginning with two numerical digits, followed by a period, four or five numerical
#'    digits, and a forward slash. The PMID is a series of eight numerical digits.
#'    There is no additional validation done; while a non-DOI is unlikely to be
#'    inadvertently recognized as a DOI, a non-PMID string of eight numbers could
#'    easily be mistaken.
#'
#' @return
#'    The passed tibble of timber with an additional column containing HTML Link(s).
#'
#' @importFrom dplyr rowwise ungroup mutate case_when
#' @importFrom stringr str_detect
#'
#' @export


add_HTMLink <- function(timber) {

  # Check for a doi first, then for a pmid in the pmid column (only exists in v2), then for a pmid
  # in the doi column. Otherwise, set the url to NA.

  timber <- timber %>%
    dplyr::rowwise() %>%
    dplyr::mutate(html_link = dplyr::case_when(
                    str_detect(doi, "^\\d{2}\\.\\d{4}\\/") | str_detect(doi, "^\\d{2}\\.\\d{5}\\/") ~ paste("<a href=\"http://dx.doi.org/", doi, "\">Click Here</a>", sep = ""),
                    ifelse("pmid" %in% names(timber), str_detect(pmid, "\\d{8}"), FALSE) ~ ifelse("pmid" %in% names(timber), paste("<a href=\"https://www.ncbi.nlm.nih.gov/pubmed/", pmid, "\">Click Here</a>", sep = ""), ""),
                    str_detect(doi, "\\d{8}") ~ paste("<a href=\"https://www.ncbi.nlm.nih.gov/pubmed/", doi, "\">Click Here</a>", sep = ""),
                    TRUE ~ NA_character_)) %>%
    dplyr::ungroup()

  return(timber)

}

# Regular Expression Notes ------------------------------------------------

# ^\\d{2}\\.\\d{4}\\/

# ^       [Anchor Search to Start]
# \\d{2}  [Two Consecutive Digits]
# \\.     [A Period]
# \\d{4}  [Four Consecutive Digits]
#\\/      [Forward Slash]
