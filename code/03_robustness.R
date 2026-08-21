# 03_robustness.R ------------------------------------------------------------
# One or two robustness checks, understood and defensible. Not a fishing trip.
#
# Pick the ones you can explain in a sentence each. Three good checks beat
# fifteen you cannot defend.

source(file.path("code", "00_setup.R"))

panel <- readRDS(file.path(PATH_PROCESSED, "panel.rds"))

baseline <- feols(
  y_growth ~ 1 | state + year | g_shock ~ z_instr,
  data = panel, cluster = ~state
)

## A. Clustering -------------------------------------------------------------
# Does inference depend on how errors are grouped? The point estimate should not
# move at all — only the standard errors.

r_cluster_region <- summary(baseline, cluster = ~region)
r_cluster_twoway <- summary(baseline, cluster = ~ state + year)

## B. Sample period ----------------------------------------------------------
# Is the result driven by one build-up? Drop the Vietnam years, then the
# Carter-Reagan years, and see what survives.

r_no_vietnam <- feols(
  y_growth ~ 1 | state + year | g_shock ~ z_instr,
  data = panel[!(year %in% 1966:1972)], cluster = ~state
)

## C. Influential states -----------------------------------------------------
# Military procurement is concentrated. Does one state carry the estimate?
# Leave-one-out over the largest recipients.

loo <- rbindlist(lapply(
  # FILL IN: the handful of largest procurement states, e.g. c("CA", "CT", "WA")
  character(0),
  function(s) {
    m <- feols(
      y_growth ~ 1 | state + year | g_shock ~ z_instr,
      data = panel[state != s], cluster = ~state
    )
    data.table(dropped = s, estimate = coef(m)["fit_g_shock"], se = se(m)["fit_g_shock"])
  }
))

## Collect -------------------------------------------------------------------

etable(
  baseline, r_no_vietnam,
  file = file.path(PATH_TABLES, "robustness.tex"),
  replace = TRUE
)

print(loo)
