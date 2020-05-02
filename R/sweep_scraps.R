

#' @title
#'   Write Unusable Factors to a CSV
#'
#' @description
#'   \code{sweep_scraps()} writes unusable factors -- trimmed from timber
#'   to scrap_pile by \code{\link{trim_scraps}} -- to a .CSV.
#'
#' @param csv_path
#'   string: a path to write the .CSV.
#'
#' @return
#'   A .CSV.
#'
#' @importFrom readr write_csv
#'
#' @export



sweep_scraps <- function(csv_path = file.choose()) {

  readr::write_csv(scrap_pile, path = csv_path)

}




