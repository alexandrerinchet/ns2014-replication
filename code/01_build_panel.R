# 01_build_panel.R -----------------------------------------------------------
# Raw AEA replication files -> analysis panel.
#
# NOTE TO SELF: do not write this script from imagination. First inspect what is
# actually in data/raw/, then fill in the real file and variable names below.
# The scaffolding is here so you edit rather than invent.

source(file.path("code", "00_setup.R"))

## Step 1 — inventory the raw files ------------------------------------------
# Run this interactively before anything else.

list.files(PATH_RAW, recursive = TRUE)

# Then, for each candidate .dta file:
#   d <- haven::read_dta(file.path(PATH_RAW, "<file>.dta"))
#   str(d)                       # variable names and types
#   attr(d$<var>, "label")       # Stata variable labels — often the only docs
#   summary(d)
#
# Record what you find in NOTES.md under "Open questions".

## Step 2 — load ------------------------------------------------------------

# raw <- as.data.table(haven::read_dta(file.path(PATH_RAW, "<FILL IN>.dta")))

## Step 3 — build the analysis variables -------------------------------------
# The paper's specification is, in words:
#
#   (Y_it - Y_it-2) / Y_it-2  ~  (G_it - G_it-2) / Y_it-2
#
# i.e. output growth on the change in military procurement, both scaled by
# lagged output, with state and time fixed effects, instrumented by national
# military spending interacted with state exposure.
#
# Confirm the exact horizon, deflator and normalisation against the paper before
# committing to the definitions below.

# panel <- raw[, .(
#   state,
#   year,
#   y_growth   = NA_real_,   # FILL IN
#   g_shock    = NA_real_,   # FILL IN: scaled change in procurement
#   z_instr    = NA_real_,   # FILL IN: national spending x state exposure
#   pop        = NA_real_    # for weighting, if the paper weights
# )]

## Step 4 — sanity checks ----------------------------------------------------
# Cheap, and they catch most silent errors.

# stopifnot(!anyDuplicated(panel[, .(state, year)]))   # one row per state-year
# panel[, .N, by = year][order(year)]                  # balanced-ish?
# summary(panel)                                       # implausible extremes?

## Step 5 — save -------------------------------------------------------------

# saveRDS(panel, file.path(PATH_PROCESSED, "panel.rds"))
