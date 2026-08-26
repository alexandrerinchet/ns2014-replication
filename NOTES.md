# Working notes

A running log of what broke, what I did about it, and where AI helped.
Newest entries at the bottom.


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

Plan: baseline instrument first (`statefiscal.dta`), Bartik in 02_robustness.R.

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
- [ ] Clustering: by state, by region, or two-way? --> state
- [ ] Confirm that `_bi` = Bartik instrument (check the ReadMe or the .do files)
  --> no, it means biannual



## Discrepancies vs. the paper

**2SLS regression:**

  1. number of obs = 1989 (same number)
  2. coefficient : 1.42636 (same value in my regression as in the paper)
  3. standard error : 0.36371 in my regression vs 0.35658 --> 2% gap (low),
  attributable to a small-sample correction applied differently by the two
  packages
  4. Root MSE : .04983 (same)
  5. F-test (1st stage) = 4.96 (4.83 in the paper) (low, mechanically so given 51 instruments)

Collinearity problems : R excludes Wyoming, Stata excludes 1967 and 2006



**Robustness tests results :**


```
                         baseline        m_bartik             m_oil
Dependent Var.:          Drcapout        Drcapout          Drcapout
                                                                   
Drcapspend      1.426*** (0.3637) 2.477* (0.9538) 1.320*** (0.3740)
Fixed-Effects:  ----------------- --------------- -----------------
state                         Yes             Yes               Yes
year                          Yes             Yes               Yes
_______________ _________________ _______________ _________________
S.E.: Clustered         by: state       by: state         by: state
Observations                1,989           1,989             1,989
R2                        0.36293         0.36455           0.42883
Within R2                 0.00667         0.00919           0.10941
---
Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

```
**Oil controls.** 1.320 vs 1.426 in the baseline. The multiplier barely moves and
stays significant at the 0.1% level, while within R² jumps from 0.7% to 10.9% —
the state-specific oil sensitivities explain a lot of variation without carrying
the coefficient. The estimate is not driven by the oil channel.


**Bartik instrument.** 2.477, SE 0.954. Higher point estimate, much less precise.
The confidence interval comfortably covers 1.426, so the two estimates are not
statistically distinguishable and the qualitative conclusion holds — the
multiplier exceeds 1. The gap in point estimates is real, though.


**Bartik first-stage** F = 108.6 (1 instrument, 1,949 DoF) vs 4.83 for the baseline
(51 instruments) : same identifying variation, concentrated rather than dispersed —
so the low baseline F is an artefact of instrument count, not weak identification.

--> matches the paper:

  Bartik : 2.476869 vs 2.477 here
  
  Oil controls : 1.320189 vs 1.320 here

