# MiningCostBench
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20722764.svg)](https://doi.org/10.5281/zenodo.20722764)

> Benchmark production costs and structured cost drivers for mining commodities.

`MiningCostBench` is a curated, citable **R data package** of indicative
cash/production cost ranges and a six-stage cost-driver breakdown for mining and
mineral commodities, organised into six categories:

- **Coal & Lignite** by rank (peat → lignite → sub-bituminous → bituminous
  thermal → bituminous coking → anthracite)
- **Base Metals** (copper, aluminium, lead, zinc, nickel, tin)
- **Precious Metals** (gold, silver, PGE)
- **Fuel & Atomic Minerals** (uranium, thorium)
- **India's 30 Critical Minerals** (Ministry of Mines, 2023 list)
- **Bulk & Industrial Minerals** (iron ore, manganese, limestone, chromite,
  phosphate rock, aggregates/silica sand)

Plus a **cross-cutting cost-driver** table and a **notes/sources** table so the
figures stay traceable.

## Installation

```r
# install.packages("remotes")
remotes::install_github("imanojkumar/MiningCostBench")
```

## Quick start

```r
library(MiningCostBench)

mcb_categories()
mcb_costs("copper")
mcb_drivers("gold")            # tidy long six-stage breakdown
mcb_byproducts()$commodity     # minerals with no standalone mining cost
mcb_cross_cutting("Energy")
mcb_sources("SOURCES")
mcb_plot_overview()            # requires ggplot2
```

## Data model

| Object | Rows | Description |
|---|---|---|
| `commodity_costs` | 53 | One row per commodity; six driver-stage columns + `is_byproduct` |
| `cost_drivers` | 23 | Cross-cutting cost drivers, grouped by category |
| `cost_sources` | 13 | Interpretation notes and indicative sources |

## Rebuilding the data

Source data lives in `data-raw/`. Edit the CSVs (or the workbook) and run:

```r
source("data-raw/process_data.R")   # regenerates data/*.rda
```

## Caveat

Figures are **indicative cash/production costs, not prices**, and vary 3–5x with
grade, method, depth, geography, currency and by-product credits. For many
critical minerals the **driver logic is more reliable than the dollar figure**.
Verify against current company guidance or a commercial cost-curve provider
before publication. See `BLUEPRINT.md` for the full design rationale.

## License

MIT © Manoj Kumar
