## data-raw/process_data.R
## Rebuilds the package data objects (data/*.rda) from the tidy CSVs in
## data-raw/csv/, which are themselves extracted from the source workbook
## data-raw/Mining_Commodity_Cost_Benchmarks_Expanded.xlsx.
##
## Run from the package root after editing the CSVs:
##   source("data-raw/process_data.R")
##
## Requires: usethis (and optionally readr).

stopifnot(file.exists("data-raw/csv/commodity_costs.csv"))

rd <- function(f) read.csv(file.path("data-raw/csv", f),
                           stringsAsFactors = FALSE,
                           check.names = FALSE,
                           encoding = "UTF-8",
                           na.strings = c("", "NA"))

commodity_costs <- rd("commodity_costs.csv")
cost_drivers    <- rd("cost_drivers.csv")
cost_sources    <- rd("cost_sources.csv")

## Type coercion / tidying
commodity_costs$is_byproduct <- toupper(trimws(commodity_costs$is_byproduct)) == "TRUE"
char_cols <- setdiff(names(commodity_costs), "is_byproduct")
commodity_costs[char_cols] <- lapply(commodity_costs[char_cols],
                                     function(x) trimws(as.character(x)))
commodity_costs[is.na(commodity_costs)] <- ""
commodity_costs$is_byproduct <- as.logical(commodity_costs$is_byproduct)

cost_drivers[]  <- lapply(cost_drivers, function(x) trimws(as.character(x)))
cost_sources[]  <- lapply(cost_sources, function(x) trimws(as.character(x)))

## Light integrity checks
stopifnot(
  nrow(commodity_costs) > 0,
  !any(duplicated(commodity_costs$commodity[commodity_costs$category != "Critical Minerals (India 30)"])),
  all(c("category","commodity","cost_text","is_byproduct") %in% names(commodity_costs))
)

## Write to data/ (LazyData)
usethis::use_data(commodity_costs, cost_drivers, cost_sources,
                  overwrite = TRUE, compress = "xz")

message("Rebuilt: commodity_costs (", nrow(commodity_costs), " rows), ",
        "cost_drivers (", nrow(cost_drivers), "), ",
        "cost_sources (", nrow(cost_sources), ").")
