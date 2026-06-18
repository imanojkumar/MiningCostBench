<img src="https://img.shields.io/badge/data%20package-R-blue" align="left" alt="R data package"/>

# MiningCostBench 

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20722764.svg)](https://doi.org/10.5281/zenodo.20722764)

<!-- badges: start -->
[![R-CMD-check](https://github.com/imanojkumar/MiningCostBench/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/imanojkumar/MiningCostBench/actions/workflows/R-CMD-check.yaml)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

> Benchmark production costs and structured cost drivers for mining commodities.

## What this is

`MiningCostBench` is a curated, citable **R data package** of indicative
cash/production cost ranges and a six-stage cost-driver breakdown for mining and
mineral commodities. It turns a static multi-sheet cost workbook into tidy,
queryable, test-backed, version-controlled R objects, so costs and their drivers
can be looked up, joined, plotted, taught, and cited directly from R.

It is an **orientation and teaching dataset**, not a substitute for a commercial
cost-curve service (Wood Mackenzie, CRU, S&P Global). It is built to sit
alongside [`MiningAnalytics`](https://github.com/imanojkumar/MiningAnalytics).

## Coverage (53 commodities, 6 categories)

- **Coal & Lignite** by rank: peat → lignite → sub-bituminous → bituminous
  (thermal) → bituminous (coking) → anthracite
- **Base Metals**: copper, aluminium, lead, zinc, nickel, tin
- **Precious Metals**: gold, silver, platinum-group elements
- **Fuel & Atomic Minerals**: uranium, thorium
- **India's 30 Critical Minerals** (Ministry of Mines, 2023 list)
- **Bulk & Industrial Minerals**: iron ore, manganese, limestone, chromite,
  phosphate rock, aggregates / silica sand

Plus a **cross-cutting cost-driver** table and a **notes / sources** table so the
figures remain traceable.

## Installation

```r
# install.packages("remotes")
remotes::install_github("imanojkumar/MiningCostBench")
```

## Quick start

```r
library(MiningCostBench)

mcb_categories()
mcb_costs("copper")             # full cost record (case-insensitive, partial match)
mcb_drivers("gold")             # tidy long six-stage driver breakdown
mcb_byproducts()$commodity      # minerals with no standalone mining cost
mcb_search("tailings")          # free-text search across all fields
mcb_cross_cutting("Energy")     # cross-cutting cost drivers
mcb_sources("SOURCES")          # provenance

# India strategic framework (indicative starter)
mcb_strategy(group = "Energy & Electronics")
mcb_strategy(min_criticality = 4.5)
mcb_strategic_groups()

# Numeric layer + vintages (for charting / time series)
subset(mcb_costs_numeric(category = "Precious Metals"), cost_unit == "/oz")
mcb_vintages()

# Plots (require ggplot2)
mcb_plot_overview()             # coverage chart
mcb_plot_criticality()          # supply-risk vs economic-importance matrix
```

## Data model

| Object | Rows | Description |
|---|---|---|
| `commodity_costs` | 53 | One row per commodity; six driver-stage columns + `is_byproduct` flag + `drivers_raw` + `vintage` |
| `commodity_costs_numeric` | 53 | Parsed `cost_low`/`cost_high`/`cost_unit` bounds for charting (not unit-consistent) |
| `critical_mineral_strategy` | 30 | India strategic-framework attributes for the 30 critical minerals (indicative starter) |
| `cost_drivers` | 23 | Cross-cutting cost drivers grouped by category |
| `cost_sources` | 19 | Interpretation notes and indicative sources |

`commodity_costs` columns: `category`, `commodity`, `source_method`,
`cost_basis`, `cost_text`, `meaningful_metric`, `driver_extraction`,
`driver_processing`, `driver_energy_reagents`, `driver_logistics`,
`driver_fiscal_esg`, `driver_structural`, `is_byproduct`, `drivers_raw`.

## A note on the design

Costs are stored as **text**, not numbers, on purpose: units differ across
commodities (per tonne of ore, per tonne of product, per pound of metal, per
ounce, per tonne LCE, per pound U₃O₈), so a single numeric column would invent
false comparability. `cost_basis` and `meaningful_metric` carry the unit
context. The `is_byproduct` flag marks the ~13 minerals (gallium, germanium,
indium, rhenium, tellurium, selenium, cadmium, hafnium, bismuth, cobalt,
thorium, vanadium, zircon) that have **no standalone mining cost** — the single
most important signal in the critical-minerals set.

See [`BLUEPRINT.md`](BLUEPRINT.md) for the full design rationale and roadmap.

## India strategic framework

The `critical_mineral_strategy` table maps each of the 30 minerals to one of four
thematic groups — **Energy & Electronics**, **Clean Energy & Advanced Tech**,
**Specialty Metals & Alloys**, **Industrial & Agricultural** — and attaches
indicative criticality, supply-risk, economic-importance, import-dependence,
reserves, producer and India-status fields. It joins to `commodity_costs` on the
mineral name, so cost drivers and strategic posture can be analysed together:

```r
library(dplyr)
mcb_strategy() |>
  left_join(mcb_costs(category = "Critical Minerals (India 30)"),
            by = c("mineral" = "commodity")) |>
  filter(criticality_score >= 4.5) |>
  select(official_name, strategic_group, criticality_score, import_dependence_pct, cost_text)
```

These scores are a **starter** scaffold (see caveats) — the schema is the
deliverable; the numbers are placeholders to validate against official sources.

## Rebuilding the data

The editable source of truth is `data-raw/csv/`. After editing, regenerate the
`.rda` objects:

```r
source("data-raw/process_data.R")
```

## Caveats and terms of use

**Status of the figures.** All cost figures in this package are **indicative
orientation values — not official, audited, or authoritative numbers.** They were
compiled (June 2026) from public producer disclosures and industry cost studies
for teaching and orientation, are paraphrased rather than transcribed, and can
vary 3–5× with grade, method, depth, geography, currency and by-product credits.
They are **not prices** (cash/production cost sits well below market price). For
many critical minerals the **driver logic is more reliable than the dollar
figure**.

**Not a decision instrument.** This dataset must **not** be used as the sole
basis for investment, procurement, valuation, regulatory, or policy decisions.
Verify against current company guidance or a commercial cost-curve provider
(Wood Mackenzie, CRU, S&P Global) before any formal use. The package is provided
"as is" under the MIT licence, without warranty of accuracy, completeness, or
fitness for a particular purpose.

**Cross-reference rows.** Four minerals — **Copper, Nickel, Tin, and PGE
(Platinum-Group)** — appear in both their **Base/Precious Metals** category and
the `Critical Minerals (India 30)` category. As of v0.2.0 the critical-category
rows carry their **own** six-stage driver breakdown, so nothing is blank; a
fuller treatment still lives in the base/precious entry (noted inline), e.g.
`mcb_drivers("copper", category = "Base Metals")`.

**Strategic-framework scores are a starter.** `critical_mineral_strategy` holds
**indicative** scores (`criticality_score`, `supply_risk`, `economic_importance`
on a 1–5 scale, with `criticality_score = mean(supply_risk,
economic_importance)`) and indicative `import_dependence_pct`. They are
**illustrative, not official** Ministry of Mines / GSI figures, and must be
validated and replaced before any governance or policy use.

## Citation

```r
citation("MiningCostBench")
```

## License

MIT © Manoj Kumar
