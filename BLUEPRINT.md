# MiningCostBench — Package Blueprint

A design blueprint for an R **data package** that encapsulates the expanded
mining-commodity cost workbook (all eight sheets, including Notes & Sources) as
tidy, queryable, documented, and citable R objects.

---

## 1. Purpose and scope

Turn a static multi-sheet spreadsheet into a programmable, version-controlled,
test-backed dataset so that costs and cost drivers can be queried, joined,
plotted, taught, and cited from R — and rebuilt cleanly when the underlying
figures are updated.

It is deliberately an **orientation / teaching dataset**, not a commercial
cost-curve product. That framing is baked into the documentation, the
`cost_sources` table, and every relevant docstring.

> **Caveats carried throughout the package.** (1) All cost figures are
> *indicative orientation values — not official, audited or authoritative
> numbers*, and not prices; they must not be the sole basis for investment,
> procurement, valuation, regulatory or policy decisions. (2) Four
> critical-mineral rows (Copper, Nickel, Tin, PGE) are *cross-reference* rows:
> the mineral is covered but its detailed six-stage driver breakdown lives in the
> Base/Precious Metals category, not the critical-minerals row. Both caveats
> appear in `README.md`, the package- and dataset-level roxygen docs, the
> `mcb_drivers()` help, the vignette, and the bundled `cost_sources` data
> (`mcb_sources("NOTES")`).

It is designed to sit **alongside `MiningAnalytics`**: same author, same
CamelCase house style, same `testthat` + GitHub Actions discipline. It could
later be merged in as a data module, but a standalone data package keeps the
heavy data payload out of the analytics package's build.

---

## 2. Design decisions (the "why")

| Decision | Rationale |
|---|---|
| **Data package, not function package** | The value is the curated data; functions are thin, stable accessors. Heavy logic lives upstream in `data-raw/`. |
| **One normalised table (`commodity_costs`)** instead of six sheet-shaped frames | Categories become a `category` column, so all six groups are filterable/joinable with one verb. The sheet split was a *presentation* choice, not a data model. |
| **Six driver stages as columns** (`driver_extraction` … `driver_structural`) | The workbook encoded drivers as labelled prose ("EXTRACTION: …; PROCESSING: …"). Parsing them into columns makes the breakdown analysable and pivots cleanly to long form via `mcb_drivers()`. The full prose is retained in `drivers_raw` for fidelity. |
| **`is_byproduct` logical flag** | The single most important analytical signal in the critical-minerals set: ~10 of 30 have no standalone mining cost. Promoting it to a typed column makes it a first-class query (`mcb_byproducts()`). |
| **Cost kept as `cost_text`, not parsed to numerics** | Units are deliberately heterogeneous (per t ore, per t product, per lb metal, per oz, per t LCE, per lb U3O8). A single numeric column would invent false comparability. `cost_basis` + `meaningful_metric` carry the unit context; numeric parsing is left to the user for a chosen, unit-consistent subset. |
| **Notes & Sources as data, not just a README** | Provenance is queryable (`mcb_sources()`), travels with the objects, and feeds the `CITATION`. A `section` column separates interpretation NOTES from SOURCES. |
| **Minimal hard dependencies** | Core accessors are base R returning `data.frame`; `tibble`, `dplyr`, `ggplot2`, `scales` are **Suggests** and used only when present. A data package should install anywhere. |
| **`data-raw/` is the single source of truth** | Canonical `usethis` workflow: edit CSV/xlsx → `source("data-raw/process_data.R")` → regenerated `data/*.rda`. Reproducible and reviewable in git diffs. |

---

## 3. Directory structure

```
MiningCostBench/
├── DESCRIPTION                 # metadata, deps (Suggests-heavy), VignetteBuilder
├── NAMESPACE                   # roxygen-generated; exports mcb_* functions
├── LICENSE                     # MIT
├── README.md                   # install + quick start + data model
├── NEWS.md                     # changelog
├── BLUEPRINT.md                # this document
├── _pkgdown.yml                # website reference index
├── .Rbuildignore               # excludes data-raw/, BLUEPRINT, .github, pkgdown
├── .gitignore
├── R/
│   ├── MiningCostBench-package.R   # package-level docs (@keywords internal "_PACKAGE")
│   ├── data.R                      # roxygen docs for the 3 datasets (@format, @source)
│   ├── costs.R                     # mcb_costs/commodities/categories/byproducts/search
│   ├── drivers.R                   # mcb_drivers (long pivot) + mcb_cross_cutting
│   ├── sources.R                   # mcb_sources
│   ├── viz.R                       # mcb_plot_overview (ggplot2, guarded)
│   └── utils.R                     # .mcb_match(), .mcb_frame(), globalVariables
├── data/                       # GENERATED — commodity_costs.rda, cost_drivers.rda,
│                               #   cost_sources.rda (built by process_data.R)
├── data-raw/
│   ├── Mining_Commodity_Cost_Benchmarks_Expanded.xlsx   # the source workbook
│   ├── csv/                    # tidy extracts (the editable source of truth)
│   │   ├── commodity_costs.csv
│   │   ├── cost_drivers.csv
│   │   └── cost_sources.csv
│   └── process_data.R          # rebuilds data/*.rda via usethis::use_data()
├── man/                        # GENERATED by roxygen2 (devtools::document())
├── tests/
│   ├── testthat.R
│   └── testthat/
│       ├── test-data-integrity.R   # structure, driver completeness, categories
│       ├── test-costs.R            # matching, filtering, byproduct, search
│       └── test-drivers.R          # tidy long form, cross-cutting, sources
├── vignettes/
│   └── mining-cost-benchmarks.Rmd
├── inst/
│   └── CITATION
└── .github/workflows/
    └── R-CMD-check.yaml         # multi-OS r-lib CI (matches MiningAnalytics)
```

`data/` and `man/` are intentionally empty in this scaffold — they are build
artefacts. See §6 to generate them.

---

## 4. Data model

### 4.1 `commodity_costs` (53 rows × 15 cols)

| Column | Type | Notes |
|---|---|---|
| `category` | chr | One of 6 categories |
| `commodity` | chr | Commodity / grade name |
| `source_method` | chr | Geological source + mining/processing method |
| `cost_basis` | chr | What the $ is per (ore vs product vs metal) |
| `cost_text` | chr | Indicative cash/production cost range |
| `meaningful_metric` | chr | Economically meaningful metric (C1/AISC per lb/oz) |
| `driver_extraction` … `driver_structural` | chr | The six driver stages |
| `is_byproduct` | lgl | TRUE = recovered as a by-product, no standalone cost |
| `drivers_raw` | chr | Full original six-stage prose (fidelity/fallback) |
| `vintage` | chr | Snapshot key (e.g. "2025-26"); year-keyed for time series |

### 4.2 `commodity_costs_numeric` (53 rows × 11 cols)
`category`, `commodity`, `vintage`, `cost_low`, `cost_high`, `cost_unit`,
`cost_currency`, `cost_basis`, `is_metal_basis` (lgl), `numeric_available`
(lgl), `parse_note`. Parsed from `cost_text`; **not unit-consistent across
rows** — filter to one `cost_unit` before aggregating. Surfaced via
`mcb_costs_numeric()`.

### 4.3 `critical_mineral_strategy` (30 rows × 11 cols)
`mineral` (joins to `commodity_costs$commodity`), `official_name`,
`strategic_group`, `criticality_score` (num, = mean of the next two),
`supply_risk` (int 1-5), `economic_importance` (int 1-5),
`import_dependence_pct` (num), `domestic_reserves`, `key_producers`,
`india_status`, `value_basis`. **Indicative starter values, not official.**
Surfaced via `mcb_strategy()` / `mcb_strategic_groups()`.

### 4.4 `cost_drivers` (23 rows × 3 cols)
`driver_category`, `specific_drivers`, `rationale` — the cross-cutting drivers
(energy, labour, strip ratio, comminution, water, tailings, royalties, FX,
by-product credits, supply concentration, etc.).

### 4.5 `cost_sources` (19 rows × 3 cols)
`section` ("NOTES" | "SOURCES"), `topic`, `detail` — interpretation guidance and
indicative provenance, carried as data and surfaced via `mcb_sources()` and
`inst/CITATION`.

---

## 5. Function API

| Function | Returns | Purpose |
|---|---|---|
| `mcb_categories()` | chr vector | The six category labels |
| `mcb_commodities(category = NULL)` | chr vector | Commodity names, optionally filtered |
| `mcb_costs(commodity, category, vintage)` | data.frame/tibble | Full cost record(s); exact-then-partial matching |
| `mcb_costs_numeric(commodity, category, available_only)` | data.frame | Parsed numeric cost bounds |
| `mcb_vintages()` | chr vector | Available snapshot vintages |
| `mcb_drivers(commodity, category)` | tidy long df | One row per commodity × driver stage |
| `mcb_byproducts()` | data.frame | Commodities with `is_byproduct == TRUE` |
| `mcb_search(pattern)` | data.frame | Regex search across all text fields |
| `mcb_cross_cutting(category = NULL)` | data.frame | Cross-cutting driver table |
| `mcb_strategy(mineral, group, min_criticality)` | data.frame | India strategic-framework records |
| `mcb_strategic_groups()` | chr vector | The four thematic groups |
| `mcb_sources(section = NULL)` | data.frame | Notes / sources |
| `mcb_plot_overview()` | ggplot | Coverage bar chart by category × mining basis |
| `mcb_plot_criticality()` | ggplot | Supply-risk vs economic-importance matrix |

Internal: `.mcb_match()` (matching strategy), `.mcb_frame()` (tibble-if-available).

Design principles: verbs are `mcb_*`-prefixed for namespace clarity; every
function works on `NULL` (returns everything) so they compose; matching is
forgiving (case-insensitive, partial); nothing errors on an empty match (returns
0-row frame) except `mcb_plot_overview()` when ggplot2 is absent.

---

## 6. Build & release workflow

```r
# 1. (Re)generate data objects from the editable CSVs
source("data-raw/process_data.R")     # writes data/*.rda

# 2. Generate man/ pages and NAMESPACE from roxygen comments
devtools::document()

# 3. Local checks
devtools::test()                       # testthat suite
devtools::check()                      # R CMD check (aim: 0 errors/warnings/notes)

# 4. Build the website (optional)
pkgdown::build_site()

# 5. Install / ship
devtools::install()
# or push to GitHub; remotes::install_github("imanojkumar/MiningCostBench")
```

CI (`.github/workflows/R-CMD-check.yaml`) runs `R CMD check` on macOS, Windows
and Ubuntu (release/devel/oldrel) on every push and PR — mirroring the
MiningAnalytics setup.

---

## 7. Quality gates (testthat)

- **Structure**: three data frames load; expected columns present; `is_byproduct`
  is logical; row count sane.
- **Driver completeness**: every commodity has ≥1 populated driver stage.
- **Category invariant**: exactly the six expected categories.
- **Behavioural**: exact + partial matching; category filtering; by-product set
  contains the known minor metals; free-text search hits.
- **Tidy contract**: `mcb_drivers()` returns the four long columns with only the
  six canonical stage labels and no empty `driver_text`.

---

## 8. Extension roadmap

**Delivered in v0.2.0:**

- [x] **Numeric cost layer** — `commodity_costs_numeric` with `cost_low`,
  `cost_high`, `cost_unit`, `is_metal_basis`, `numeric_available`. Parsed from
  `cost_text`; explicitly *not* unit-consistent across rows, so callers filter to
  one `cost_unit`. Accessor `mcb_costs_numeric()`.
- [x] **India strategic-framework columns** — `critical_mineral_strategy` (30
  rows): `strategic_group`, `criticality_score` (= mean of `supply_risk` and
  `economic_importance`), `import_dependence_pct`, `domestic_reserves`,
  `key_producers`, `india_status`. Indicative starter values, joinable to
  `commodity_costs` on the mineral name. Accessors `mcb_strategy()`,
  `mcb_strategic_groups()`; plot `mcb_plot_criticality()`.
- [x] **Time-series / vintage key** — `vintage` column on `commodity_costs` and
  `commodity_costs_numeric` (all "2025-26"); schema ready to append snapshots.
  `mcb_costs(vintage = )`, `mcb_vintages()`.
- [x] **Filled cross-reference rows** — Copper, Nickel, Tin, PGE now carry their
  own six-stage breakdown inside the critical category.

**Still open:**

1. **Replace starter strategy scores** with validated official values (GSI /
   Ministry of Mines / NCMM / USGS / IEA) and add a citation per field.
2. **Populate more of the numeric layer** — extract the metal-basis (C1/AISC)
   ranges as additional rows so each commodity can carry both an ore-basis and a
   metal-basis figure.
3. **Geometry / joins** — link to producing states/districts for mapping
   alongside MiningAnalytics. *(deferred)*
4. **Citable DOI** — archive a release on Zenodo; update `inst/CITATION`.
