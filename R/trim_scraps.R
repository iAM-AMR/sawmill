
# HEW WOOD







trim_scraps <- function(timber, reason) {

  # Select excluded factors
  new_scraps <- filter(timbr, exclude_sawmill)

  # Add reason for exclusion
  new_scraps$exclude_sawmill_reason <- reason

  # Write to scrap_pile
  scrap_pile <<- bind_rows(scrap_pile, new_scraps)

  # Return timber without exclusions
  return(filter(timber, !exclude_sawmill))


}
