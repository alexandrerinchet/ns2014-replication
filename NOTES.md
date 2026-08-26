# Working notes

A running log of what broke, what I did about it, and where AI helped.
Newest entries at the bottom. Honest by design: failures stay in.

Format for each entry:

```
### [date] — short title
**Problem.** what happened
**Diagnosis.** what was actually wrong
**Fix.** what I changed
**AI use.** what I asked, what I checked by hand
```

---

### 2026-08-22 — Reading Section II: the instruments

NS2014 use two distinct instruments:

1. *Baseline* — national military procurement interacted with state dummies.
   State-specific sensitivities are estimated in the first stage, not imposed.
   Table 1 lists the most sensitive states (CA, CT, ...).
2. *Bartik (shift-share)* — national spending scaled by each state's average
   military spending relative to state output over the first five years of the
   sample. The weight is fixed ex ante rather than estimated.

The two work as a built-in robustness check: if both give similar estimates, the
result doesn't hinge on how the variation was constructed.

Plan: baseline instrument first (`statefiscal.dta`), Bartik in 03_robustness.R.

**AI use.** Worked through the Section II identification argument with AI
assistance; specifics checked against the paper text.



### 2026-08-26 — 2SLS regression : standard errors

**Problem.** The standard errors I obtain differ from those reported in the
paper (0.36371 vs 0.35658 respectively)

**Diagnosis.** Maybe due to a small-sample correction applied differently by the
two packages

**Fix.** I run : summary(m_iv, ssc = ssc(adj = FALSE, cluster.adj = FALSE)).
This disables both degrees-of-freedom adjustments (the one for the number of
parameters and the one for the number of clusters)

**Output** Same standard error as in the paper (0.356579)

**AI use.** AI-assisted diagnosis and drafting of the verification command;
output verified against the Stata log.


## Open questions

- [ ] Which exact sample years does the headline specification use? --> 1966-2006
- [ ] Are the headline results at state level, region level, or both?
- [ ] How are the instrument and exposure measure constructed, precisely?
- [ ] Clustering: by state, by region, or two-way?
- [ ] Deflator and per-capita normalisation choices
- [ ] Confirm that `_bi` = Bartik instrument (check the ReadMe or the .do files)
  --> no, it means biannual



## Discrepancies vs. the paper

2SLS regression: 
  1. number of obs = 1989 (same number)
  2. coefficient : 1.42636 (same value in my regression as in the paper)
  3. standard error : 0.36371 in my regression vs 0.35658 --> 2% gap (low),
  attributable to a small-sample correction applied differently by the two
  packages
  4. R² : 0.3299 (same value as in the paper)
  5. Root MSE : .04983 (same)
  6. F-test (1st stage) = 4.96 (4.83 in the paper)
  6. Sargan test : p = 0.04

Colinearity problems : R excludes Wyoming, Stata excludes 1967 and 2006



*Anything that does not reproduce goes here, with the size of the gap and my best
explanation. Empty for now.*
