# 02_replicate.R -------------------------------------------------------------
# The headline result: the open economy relative multiplier.
#
# fixest syntax for IV with fixed effects:
#
#   feols(y ~ exogenous_controls | fixed_effects | endogenous ~ instrument, data)
#          ^                       ^                ^
#          |                       |                └── first stage
#          |                       └── absorbed
#          └── second-stage controls (may be empty: use "1")
#
# So the paper's baseline is roughly:
#
#   feols(y_growth ~ 1 | state + year | g_shock ~ z_instr, cluster = ~state)

source(file.path("code", "00_setup.R"))

panel <- readRDS(file.path(PATH_PROCESSED, "panel.rds"))

## 1. OLS, for reference -----------------------------------------------------
# Not the paper's estimate — it is the biased benchmark the IV is there to fix.
# Worth reporting anyway: the gap between OLS and 2SLS is informative.

m_ols <- feols(
  y_growth ~ g_shock | state + year,
  data    = panel,
  cluster = ~state
)

## 2. First stage ------------------------------------------------------------
# Does the instrument actually move procurement? Report the F statistic.

m_first <- feols(
  g_shock ~ z_instr | state + year,
  data    = panel,
  cluster = ~state
)

## 3. 2SLS — the headline specification --------------------------------------

m_iv <- feols(
  y_growth ~ 1 | state + year | g_shock ~ z_instr,
  data    = panel,
  cluster = ~state
)

# The coefficient on g_shock here is the open economy relative multiplier.
# Target: approximately 1.5.

summary(m_iv)
fitstat(m_iv, ~ ivf + ivwald)   # instrument strength diagnostics

## 4. Table ------------------------------------------------------------------

modelsummary(
  list("OLS" = m_ols, "First stage" = m_first, "2SLS" = m_iv),
  stars  = TRUE,
  gof_map = c("nobs", "r.squared"),
  output = file.path(PATH_TABLES, "table1_multiplier.md")
)

## 5. Compare to the paper ---------------------------------------------------
# Fill these in by hand from the published tables, then commit the comparison.
# If a number does not match, that goes in NOTES.md — it does not get quietly
# dropped.

comparison <- data.frame(
  quantity    = c("Relative multiplier (2SLS)", "First-stage F", "N"),
  paper       = c(NA, NA, NA),          # FILL IN from the AER tables
  replication = c(
    coef(m_iv)["fit_g_shock"],
    fitstat(m_first, "f")$f$stat,
    nobs(m_iv)
  )
)

print(comparison)
write.csv(comparison, file.path(PATH_TABLES, "comparison.csv"), row.names = FALSE)
