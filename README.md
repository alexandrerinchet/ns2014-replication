# Replication: Nakamura & Steinsson (2014) — *Fiscal Stimulus in a Monetary Union*

**Status:** in progress — expected complete August 26, 2026
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
- The 2SLS "open economy relative multiplier" specification
- First-stage diagnostics and instrument strength
- Standard errors clustered by state / region
- Robustness: alternative samples, alternative clustering

**Out of scope** — deliberately:
- The structural New Keynesian open-economy model (Sections III–IV of the paper).
  That is a calibration/solution exercise in a different toolchain, and reproducing
  it is not the point of this exercise.

## The specification, in words

US states share a single monetary and fiscal authority. Federal military build-ups
(Vietnam, the Carter–Reagan build-up) hit some states far harder than others for
reasons of geopolitics rather than local business cycles. Regressing state output
growth on state military procurement growth — instrumenting the latter with
national military spending interacted with each state's historical exposure, and
absorbing anything national with time fixed effects — recovers what the authors call
the **open economy relative multiplier**, estimated at approximately 1.5.

Because time fixed effects difference out the common monetary and tax response,
this estimate is *not* the closed-economy aggregate multiplier: it is the effect of
spending when the central bank does not lean against it.

## Repository layout

```
data/raw/          # AEA replication files, downloaded (not committed — see below)
data/processed/    # analysis panel built by 01_build_panel.R
code/
  00_setup.R       # packages, paths, options
  01_build_panel.R # raw -> analysis panel
  02_replicate.R   # main 2SLS specifications, Table 1 equivalents
  03_robustness.R  # alternative samples and clustering
output/tables/     # regression output
output/figures/    # figures
NOTES.md           # running log: frictions, fixes, AI use, discrepancies
```

## How to run

```r
source("code/00_setup.R")
source("code/01_build_panel.R")
source("code/02_replicate.R")
source("code/03_robustness.R")
```

Requires R ≥ 4.2 with `fixest`, `data.table`, `haven`, `modelsummary`, `ggplot2`.

## Data

Raw data are **not committed** to this repository — they belong to the authors and
the AEA. Download the package from openICPSR project 112744 and unzip it into
`data/raw/`.

## Results

*To be filled in on completion:*

| Quantity | Paper | This replication | Notes |
|---|---|---|---|
| Open economy relative multiplier (state, 2SLS) | ~1.5 | — | — |
| First-stage F | — | — | — |

## What replicates and what doesn't

*To be filled in on completion — including anything that does not reproduce, and why.*

## Method note

R code here was written with AI assistance (debugging, syntax, translating Stata
idioms into `fixest`). Every specification was checked against the paper by hand,
and every non-trivial fix is logged in [`NOTES.md`](NOTES.md).

## License

Code: MIT. Data: see the AEA/openICPSR terms.
