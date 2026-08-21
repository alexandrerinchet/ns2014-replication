# 00_setup.R -----------------------------------------------------------------
# Packages, paths, global options. Run this first.

## Packages ------------------------------------------------------------------
# install.packages(c("fixest", "data.table", "haven", "modelsummary", "ggplot2"))

library(fixest)       # feols(): fixed effects + IV + clustered SE in one call
library(data.table)   # fast data manipulation
library(haven)        # read_dta(): the AEA package ships Stata .dta files
library(modelsummary) # regression tables
library(ggplot2)

## Paths ---------------------------------------------------------------------
# Everything is relative to the repo root. Open the .Rproj file, or setwd() here.

PATH_RAW       <- file.path("data", "raw")
PATH_PROCESSED <- file.path("data", "processed")
PATH_TABLES    <- file.path("output", "tables")
PATH_FIGURES   <- file.path("output", "figures")

for (p in c(PATH_PROCESSED, PATH_TABLES, PATH_FIGURES)) {
  if (!dir.exists(p)) dir.create(p, recursive = TRUE)
}

## Options -------------------------------------------------------------------
setFixest_notes(FALSE)     # quiet fixest's console chatter
options(scipen = 999)      # no scientific notation in printed output

## Session info --------------------------------------------------------------
# Uncomment when finalising, and paste the output into the README.
# sessionInfo()
