# A few robustness checks

source(file.path("code", "00_setup.R"))
library(haven); library(data.table); library(fixest)

d <- as.data.table(read_dta(file.path(PATH_RAW, "DataPrograms", "for-regressions",
                                      "statefiscal.dta")))

# Baseline, for reference (Table II, Row 1, State Output)
baseline <- feols(
  Drcapout ~ 1 | state + year | Drcapspend ~ i(state, Drcapspend_nat),
  data = d, cluster = ~state
)

## A. Bartik instrument ------------------------------------------------------
# The paper's alternative instrument: national spending scaled by each state's
# average military share over 1966-1971 (fracmil2), rather than letting the
# first stage estimate state-specific sensitivities. One instrument instead of
# 51, so the first-stage F is interpretable in the conventional sense.

m_bartik <- feols(
  Drcapout ~ 1 | state + year | Drcapspend ~ Dpredict_spend2,
  data = d, cluster = ~state
)

## B. Oil prices -------------------------------------------------------------
# Time fixed effects absorb the oil price as a national shock, but not the fact
# that states respond to it differently. Adding state-specific oil sensitivities
# tests whether the multiplier survives that channel.

m_oil <- feols(
  Drcapout ~ i(state, Doilprice) | state + year | Drcapspend ~ i(state, Drcapspend_nat),
  data = d, cluster = ~state
)

## Collect -------------------------------------------------------------------

etable(baseline, m_bartik, m_oil, keep = "Drcapspend")
