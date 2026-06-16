#' Commodity production costs and cost-driver breakdowns
#'
#' Indicative cash/production cost ranges and a structured six-stage cost-driver
#' decomposition for mining and mineral commodities, across six categories.
#'
#' @format A data frame with one row per commodity and the following columns:
#' \describe{
#'   \item{category}{Commodity grouping: "Coal & Lignite", "Base Metals",
#'     "Precious Metals", "Fuel & Atomic", "Critical Minerals (India 30)",
#'     "Bulk & Industrial".}
#'   \item{commodity}{Commodity or grade name.}
#'   \item{source_method}{Typical geological source and mining/processing method.}
#'   \item{cost_basis}{What the cost figure is expressed per (e.g. per tonne of
#'     saleable product, per tonne of ore milled, per pound/ounce of metal).}
#'   \item{cost_text}{Indicative production / cash cost range (2025-26), as text
#'     because units differ across commodities.}
#'   \item{meaningful_metric}{The economically meaningful cost metric for the
#'     commodity (e.g. C1/AISC per lb or oz).}
#'   \item{driver_extraction}{Cost drivers at the extraction/geology stage.}
#'   \item{driver_processing}{Cost drivers at the processing/beneficiation stage.}
#'   \item{driver_energy_reagents}{Energy and reagent cost drivers.}
#'   \item{driver_logistics}{Logistics and freight cost drivers.}
#'   \item{driver_fiscal_esg}{Fiscal, regulatory and ESG cost drivers.}
#'   \item{driver_structural}{Structural / market cost drivers (by-product
#'     credits, scale, supply concentration).}
#'   \item{is_byproduct}{Logical; \code{TRUE} where the commodity has no
#'     standalone mining cost and is recovered as a by-product of a host metal.}
#'   \item{drivers_raw}{The full original cost-driver text (all six stages).}
#' }
#' @source Compiled June 2026 from public producer disclosures and industry
#'   cost studies; see \code{\link{cost_sources}}.
#' @examples
#' head(commodity_costs)
#' subset(commodity_costs, category == "Base Metals")$commodity
"commodity_costs"

#' Cross-cutting cost drivers
#'
#' Cost drivers that apply across many or all commodities, grouped by category.
#'
#' @format A data frame with the following columns:
#' \describe{
#'   \item{driver_category}{High-level driver category (e.g. Energy, Labour).}
#'   \item{specific_drivers}{Specific cost drivers within the category.}
#'   \item{rationale}{Why the driver matters and its typical magnitude.}
#' }
#' @source Compiled June 2026; see \code{\link{cost_sources}}.
#' @examples
#' cost_drivers$driver_category
"cost_drivers"

#' Interpretation notes and indicative sources
#'
#' Notes on how to read the cost figures and the indicative sources behind them.
#'
#' @format A data frame with the following columns:
#' \describe{
#'   \item{section}{Either "NOTES" (how to interpret) or "SOURCES".}
#'   \item{topic}{Short topic label.}
#'   \item{detail}{Explanatory text or source description.}
#' }
#' @source Compiled June 2026.
#' @examples
#' subset(cost_sources, section == "SOURCES")
"cost_sources"
