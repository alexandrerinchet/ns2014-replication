source("code/00_setup.R")
library(haven); library(data.table); library(fixest)

d <- as.data.table(read_dta("data/raw/DataPrograms/for-regressions/statefiscal.dta"))

# Le panel est déjà construit par le preamble Stata des auteurs
# (Table-II_III-Row-1-preamble_states.do) : échantillon 1966-2006,
# US/Puerto Rico/Virgin Islands exclus, variables en variation sur 2 ans.

# Spécification Table II, ligne 1, colonne "State Output"
# Stata : ivregress 2sls Drcapout (Drcapspend = i.statenum*Drcapspend_nat)
#         i.year i.statenum, vce(cl statenum)str(d[, .(state, year, Drcapout, Drcapspend, Drcapspend_nat)])

m_iv <- feols(
  Drcapout ~ 1 | state + year | Drcapspend ~ i(state, Drcapspend_nat),
  data    = d,
  cluster = ~state
)

m_ols <- feols(Drcapout ~ Drcapspend | state + year, data = d, cluster = ~state)
summary(m_ols)

summary(m_iv)
