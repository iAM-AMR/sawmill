

#                                              ___    ___
#                                          __ /\_ \  /\_ \
#   ____     __     __  __  __    ___ ___ /\_\\//\ \ \//\ \
#  /',__\  /'__`\  /\ \/\ \/\ \ /' __` __`\/\ \ \ \ \  \ \ \
# /\__, `\/\ \L\.\_\ \ \_/ \_/ \/\ \/\ \/\ \ \ \ \_\ \_ \_\ \_
# \/\____/\ \__/.\_\\ \___x___/'\ \_\ \_\ \_\ \_\/\____\/\____\
#  \/___/  \/__/\/_/ \/__//__/   \/_/\/_/\/_/\/_/\/____/\/____/

# Prepare queries from CEDAR (timber) for use in the iAM.AMR models.


# Bootstrap Installation and Use

# Run all of the code in this file to install sawmill and start an interactive session to
# process timber. This code installs a package from CRAN called "remotes" which allows us
# to install packages from GitHub, then installs sawmill from the master branch of the
# GitHub repo. Note, the devtools package can also install packages from GitHub.



# Setup ---------------------------------------------------------------------------------------

# The usePackage function installs the specified package (if not available), and loads it.

usePackage <- function(p) {
  if (!is.element(p, installed.packages()[,1])) install.packages(p, dep = TRUE)
  library(p, character.only = TRUE)
}

# The remotes package includes the functions we need to install sawmill from GitHub.

usePackage("remotes")



# Install sawmill -----------------------------------------------------------------------------

#remotes::install_github("iAM-AMR/sawmill")
remotes::install_github("iAM-AMR/sawmill", ref="dev-20201116")



# Start sawmill -------------------------------------------------------------------------------

# The start_mill() function starts a interactive session to run the main function, mill().
# If you need to re-run the interactive session, re-run the code in this section.

sawmill::start_mill()

# And you're done!



# Notes ---------------------------------------------------------------------------------------

# If you need to re-run the interactive session, re-run the code in the {# Start sawmill} section.


# sawmill is installed for your future use, but it's not loaded. If you need to load sawmill
# (e.g. because you want to access other functions), run:
#
# library(sawmill)


# If you need to run the pipeline with non-default parameters, load sawmill, and run the mill()
# function:
#
# library(sawmill)
#
# mill()


# To see the arguments of mill(), run:
#
# ?mill()


# To update sawmill, make sure the sawmill package isn't loaded -- either by restarting R, or by
# using the detach_package("sawmill", TRUE) command. Then, re-run the code in the
# {# Install sawmill} section. If the package fails to update, remove sawmill using the command
# below, and re-run the code in the {# Install sawmill} section.


# To remove sawmill, run:
#
# remove.packages("sawmill")




