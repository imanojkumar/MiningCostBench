## data-raw/process_data.R
## Rebuilds all package data objects (data/*.rda) from the tidy CSVs in
## data-raw/csv/, extracted from data-raw/Mining_Commodity_Cost_Benchmarks_Expanded.xlsx.
##
## Run from the package root after editing the CSVs:
##   source("data-raw/process_data.R")
##
## Requires: usethis.

stopifnot(file.exists("data-raw/csv/commodity_costs.csv"))

rd <- function(f) read.csv(file.path("data-raw/csv", f),
                           stringsAsFactors = FALSE, check.names = FALSE,
                           encoding = "UTF-8", na.strings = c("", "NA"))

commodity_costs         <- rd("commodity_costs.csv")
commodity_costs_numeric <- rd("commodity_costs_numeric.csv")
critical_mineral_strategy <- rd("critical_mineral_strategy.csv")
cost_drivers            <- rd("cost_drivers.csv")
cost_sources            <- rd("cost_sources.csv")

## ---- commodity_costs ----
commodity_costs$is_byproduct <- toupper(trimws(commodity_costs$is_byproduct)) == "TRUE"
char_cols <- setdiff(names(commodity_costs), "is_byproduct")
commodity_costs[char_cols] <- lapply(commodity_costs[char_cols],
                                     function(x) trimws(as.character(x)))
commodity_costs[is.na(commodity_costs)] <- ""

## ---- commodity_costs_numeric ----
num <- commodity_costs_numeric
num$cost_low  <- suppressWarnings(as.numeric(num$cost_low))
num$cost_high <- suppressWarnings(as.numeric(num$cost_high))
num$is_metal_basis    <- toupper(trimws(num$is_metal_basis)) == "TRUE"
num$numeric_available <- toupper(trimws(num$numeric_available)) == "TRUE"
chr <- setdiff(names(num), c("cost_low","cost_high","is_metal_basis","numeric_available"))
num[chr] <- lapply(num[chr], function(x) trimws(as.character(x)))
num[is.na(num)] <- NA  # keep numeric NAs; blank chars handled below
for (c in chr) num[[c]][is.na(num[[c]])] <- ""
commodity_costs_numeric <- num

## ---- critical_mineral_strategy ----
st <- critical_mineral_strategy
st$criticality_score     <- suppressWarnings(as.numeric(st$criticality_score))
st$supply_risk           <- suppressWarnings(as.integer(st$supply_risk))
st$economic_importance   <- suppressWarnings(as.integer(st$economic_importance))
st$import_dependence_pct <- suppressWarnings(as.numeric(st$import_dependence_pct))
chr <- setdiff(names(st), c("criticality_score","supply_risk",
                            "economic_importance","import_dependence_pct"))
st[chr] <- lapply(st[chr], function(x) trimws(as.character(x)))
critical_mineral_strategy <- st

cost_drivers[] <- lapply(cost_drivers, function(x) trimws(as.character(x)))
cost_sources[] <- lapply(cost_sources, function(x) trimws(as.character(x)))

## ---- integrity checks ----
stopifnot(
  nrow(commodity_costs) > 0,
  "vintage" %in% names(commodity_costs),
  nrow(critical_mineral_strategy) == 30,
  ## every strategy mineral joins to a critical-category commodity
  all(critical_mineral_strategy$mineral %in%
        commodity_costs$commodity[commodity_costs$category == "Critical Minerals (India 30)"]),
  ## criticality_score == mean(supply_risk, economic_importance)
  isTRUE(all.equal(critical_mineral_strategy$criticality_score,
                   round((critical_mineral_strategy$supply_risk +
                          critical_mineral_strategy$economic_importance) / 2, 1)))
)

usethis::use_data(commodity_costs, commodity_costs_numeric,
                  critical_mineral_strategy, cost_drivers, cost_sources,
                  overwrite = TRUE, compress = "xz")

message("Rebuilt: commodity_costs (", nrow(commodity_costs), "), ",
        "commodity_costs_numeric (", nrow(commodity_costs_numeric), "), ",
        "critical_mineral_strategy (", nrow(critical_mineral_strategy), "), ",
        "cost_drivers (", nrow(cost_drivers), "), ",
        "cost_sources (", nrow(cost_sources), ").")
