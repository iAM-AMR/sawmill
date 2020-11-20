



# dep_trim_scraps <- function(timber, write_scrap = TRUE) {
#
#   # GRAIN
#   good_grain <- c("odds_ratio",
#                   "con_table_pos_neg",
#                   "con_table_pos_tot",
#                   "rate_table_pos_tot")
#
#   exclude_grain_message <- paste0("one or more values required to calculate the odds ratio are ",
#                                   "missing -- check that the data were extracted correctly")
#
#   exclude_grain         <- dplyr::filter(timber,
#                                          !grain %in% good_grain)
#
#   exclude_grain         <- dplyr::mutate(exclude_grain,
#                                          scrap_because = exclude_grain_message)
#
#   # WRITE SCRAPS
#   if (write_scrap) {
#     scrap_pile <<- exclude_grain
#     message("Reminder, scrap_pile was written to global environment.")
#   }
#
#   # INCLUDE
#   timber                <- dplyr::filter(timber,  grain %in% good_grain)
#   return(timber)
#
# }




