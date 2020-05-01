

#                                              ___    ___
#                                          __ /\_ \  /\_ \
#   ____     __     __  __  __    ___ ___ /\_\\//\ \ \//\ \
#  /',__\  /'__`\  /\ \/\ \/\ \ /' __` __`\/\ \ \ \ \  \ \ \
# /\__, `\/\ \L\.\_\ \ \_/ \_/ \/\ \/\ \/\ \ \ \ \_\ \_ \_\ \_
# \/\____/\ \__/.\_\\ \___x___/'\ \_\ \_\ \_\ \_\/\____\/\____\
#  \/___/  \/__/\/_/ \/__//__/   \/_/\/_/\/_/\/_/\/____/\/____/



usePackage <- function(p) {
  if (!is.element(p, installed.packages()[,1])) install.packages(p, dep = TRUE)
  library(p, character.only = TRUE)
}

usePackage("remotes")

remotes::install_github("iAM-AMR/sawmill")

sawmill::start_mill()




