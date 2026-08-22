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

Likely explains the `_bi` suffix in the data files. Plan: baseline instrument
first (`statefiscal.dta`), Bartik in 03_robustness.R.

**AI use.** Worked through the Section II identification argument with AI
assistance; specifics checked against the paper text.


## Open questions

- [ ] Which exact sample years does the headline specification use?
- [ ] Are the headline results at state level, region level, or both?
- [ ] How are the instrument and exposure measure constructed, precisely?
- [ ] Clustering: by state, by region, or two-way?
- [ ] Deflator and per-capita normalisation choices
- [ ] Confirm that `_bi` = Bartik instrument (check the ReadMe or the .do files)

## Discrepancies vs. the paper

*Anything that does not reproduce goes here, with the size of the gap and my best
explanation. Empty for now.*
