# Replication: Nakamura & Steinsson (2014) — *Fiscal Stimulus in a Monetary Union*

**Status:** Complete
**Author:** Alexandre Rinchet (Mines Paris – PSL)

---

## What this is

A from-scratch re-implementation in **R** of the empirical core of:

> Nakamura, Emi, and Jón Steinsson. 2014. "Fiscal Stimulus in a Monetary Union: Evidence from US Regions." *American Economic Review* 104 (3): 753–92.

The original replication package is distributed by the AEA
([openICPSR project 112744](https://www.openicpsr.org/openicpsr/project/112744/version/V1/view))
and its code is written in Stata. This repository uses **the authors' own data**
and reproduces the headline results with independently written R code.

## Scope

**In scope** — the reduced-form empirical results:
- The 2SLS "open economy relative multiplier" specification (Table II, Row 1, state output)
- First-stage diagnostics: F statistic and why the conventional threshold does not apply here
- Standard errors clustered by state
- Robustness: the paper's Bartik instrument, and state-specific oil-price controls

**Out of scope** — deliberately:
- The structural New Keynesian open-economy model (Sections III–IV of the paper).
  That is a calibration/solution exercise in a different toolchain, and reproducing
  it is not the point of this exercise.

## The specification, in words

US states share a single monetary and fiscal authority. Federal military build-ups
(Vietnam, the Carter–Reagan build-up) hit some states far harder than others for
reasons of geopolitics rather than local business cycles. Regressing state output
growth on state military procurement growth — instrumenting the latter with 
national military spending interacted with state dummies, and
absorbing anything national with time fixed effects — recovers what the authors call
the **open economy relative multiplier**, estimated at approximately 1.4.

Because time fixed effects difference out the common monetary and tax response, 
this estimate is not the closed-economy aggregate multiplier; the paper's 
structural sections discuss how the two relate.

## Repository layout

```
data/raw/          # AEA replication files, downloaded (not committed — see below)
code/
  00_setup.R       # packages, paths, options
  01_replicate.R   # main 2SLS specification (Table II)
  02_robustness.R  # Bartik instrument and oil-price controls
output/tables/     # regression output
NOTES.md           # running log: frictions, fixes, AI use, discrepancies
```

## How to run

```r
source("code/00_setup.R")
source("code/01_replicate.R")
source("code/02_robustness.R")
```

Requires R ≥ 4.2 with `fixest`, `data.table`, `haven`.

## Data

Raw data are **not committed** to this repository — they belong to the authors and
the AEA. Download the package from openICPSR project 112744 and unzip it into
`data/raw/`.

## Results

| Quantity | Paper (Table II, Row 1) | This replication | Notes |
|---|---|---|---|
| Open economy relative multiplier (state, 2SLS) | 1.42636 | 1.42636 | Exact match |
| Clustered SE (by state) | 0.35658 | 0.36371 | +2.0%; degrees-of-freedom conventions differ between Stata and `fixest`. Setting `ssc(adj = FALSE, cluster.adj = FALSE)` reproduces the paper's value |
| Observations | 1,989 | 1,989 | — |
| Root MSE | 0.04983 | 0.049833 | Match |
| First-stage F (51 instruments) | 4.828 | 4.959 | Same DoF conventions; Stock–Yogo critical values not tabulated at this instrument count |

### Additional diagnostics

`fixest` reports two tests the paper does not:

- **Wu–Hausman** (p = 0.0008) rejects exogeneity of state military spending,
  confirming that OLS would have been biased and that instrumenting was necessary.
- **Sargan** (p = 0.041) marginally rejects the overidentifying restrictions.
  With 51 instruments and effects likely heterogeneous across states, this test
  rejects frequently without necessarily invalidating the identification strategy.

## What replicates and what doesn't

The main result replicates exactly. The 2SLS estimate of the open economy
relative multiplier is 1.42636, identical to the paper's Table II, Row 1, down to
the last digit. Sample size (1,989) and Root MSE (0.04983) also match.

Two quantities differ slightly, both for the same reason. The clustered standard
error is 0.36371 here against 0.35658 in the paper, and the first-stage F is 4.959
against 4.828. Both gaps come from degrees-of-freedom conventions, which differ
between Stata's `ivregress` and `fixest`. Disabling both adjustments in `fixest`
(`ssc(adj = FALSE, cluster.adj = FALSE)`) reproduces the paper's standard error.


One implementation detail is worth noting. Stata and `fixest` handle collinearity
differently — Stata drops two year dummies (1967 and 2006), `fixest` drops one
interaction term (Wyoming). Both are dropping redundant columns, and neither
affects the estimate.

## Robustness

Both alternative specifications replicate the paper:

| Specification | Paper | This replication |
|---|---|---|
| Bartik instrument | 2.476869 | 2.477 |
| State-specific oil-price controls | 1.320189 | 1.320 |


## Method note

R code here was written with substantial AI assistance, including translating the
authors' Stata specifications into `fixest` syntax. Every estimate was checked by
hand against the authors' original Stata log files, and discrepancies are
documented in [`NOTES.md`](NOTES.md).

## License

Code: MIT. Data: see the AEA/openICPSR terms.
