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
#'   \item{vintage}{The snapshot the row belongs to (e.g. "2025-26"). The
#'     schema is year-keyed so future snapshots can be appended.}
#' }
#' @section Caveats:
#' Cost figures are indicative orientation values - NOT official, audited or
#' authoritative numbers - and are not prices. They vary 3-5x with grade,
#' method, depth, geography, currency and by-product credits, and should not be
#' the sole basis for investment, procurement, valuation, regulatory or policy
#' decisions.
#'
#' Copper, Nickel, Tin and PGE (Platinum-Group) appear in both their base/precious
#' category and the "Critical Minerals (India 30)" category. As of v0.2.0 the
#' critical-category rows carry their own six-stage driver breakdown; a fuller
#' treatment still lives in the Base/Precious Metals entry (noted inline).
#'
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

#' Numeric cost layer (parsed)
#'
#' Machine-readable low/high cost bounds parsed from
#' \code{commodity_costs$cost_text}. A convenience layer for charting and
#' filtering. \strong{Not unit-consistent across rows}: units differ (per tonne
#' of ore, per tonne of product, per lb, per oz, per tonne LCE, per kg), so you
#' must filter to a single \code{cost_unit} before aggregating.
#'
#' @format A data frame with the following columns:
#' \describe{
#'   \item{category}{Commodity grouping.}
#'   \item{commodity}{Commodity / grade name (joins to \code{commodity_costs}).}
#'   \item{vintage}{Snapshot the figure belongs to (e.g. "2025-26").}
#'   \item{cost_low}{Numeric lower bound (NA if not parseable).}
#'   \item{cost_high}{Numeric upper bound (NA if not parseable).}
#'   \item{cost_unit}{Unit string for the bounds (e.g. "/t ore", "/oz", "/lb").}
#'   \item{cost_currency}{Currency of the bounds (USD).}
#'   \item{cost_basis}{Carried over from \code{commodity_costs} for context.}
#'   \item{is_metal_basis}{Logical; TRUE where the unit is per unit of metal.}
#'   \item{numeric_available}{Logical; TRUE where a numeric range was parsed.}
#'   \item{parse_note}{How the value was obtained.}
#' }
#' @source Parsed from \code{\link{commodity_costs}}; see \code{\link{cost_sources}}.
#' @seealso \code{\link{mcb_costs_numeric}}
#' @examples
#' subset(commodity_costs_numeric, cost_unit == "/oz")
"commodity_costs_numeric"

#' India critical-mineral strategic framework (indicative starter)
#'
#' Policy-oriented attributes for the 30 critical minerals on the Ministry of
#' Mines (2023) list: thematic group, an indicative criticality score and its
#' supply-risk / economic-importance components, indicative import dependence,
#' and qualitative reserves / producer / India-status notes.
#'
#' \strong{These are indicative STARTER values, not official figures.} Scores use
#' a 1-5 scale and \code{criticality_score = mean(supply_risk,
#' economic_importance)}. Validate and replace against official sources (GSI,
#' Ministry of Mines, NCMM, USGS, IEA) before any governance or policy use.
#'
#' @format A data frame with one row per critical mineral and the following columns:
#' \describe{
#'   \item{mineral}{Mineral key; joins to \code{commodity_costs$commodity}.}
#'   \item{official_name}{Short official name from the Ministry list.}
#'   \item{strategic_group}{Thematic group: "Energy & Electronics",
#'     "Clean Energy & Advanced Tech", "Specialty Metals & Alloys",
#'     "Industrial & Agricultural".}
#'   \item{criticality_score}{Indicative composite (1-5); mean of the two below.}
#'   \item{supply_risk}{Indicative supply-risk score (1-5).}
#'   \item{economic_importance}{Indicative economic-importance score (1-5).}
#'   \item{import_dependence_pct}{Indicative India import dependence (percent).}
#'   \item{domestic_reserves}{Qualitative reserve position in India.}
#'   \item{key_producers}{Leading global producing countries.}
#'   \item{india_status}{Short note on Indian production / projects.}
#'   \item{value_basis}{Provenance flag (all rows: indicative starter).}
#' }
#' @source Thematic framing after Ministry of Mines (2023) and the National
#'   Critical Mineral Mission (2025); scores indicative. See \code{\link{cost_sources}}.
#' @seealso \code{\link{mcb_strategy}}, \code{\link{mcb_strategic_groups}}
#' @examples
#' critical_mineral_strategy[order(-critical_mineral_strategy$criticality_score),
#'                           c("official_name", "strategic_group", "criticality_score")]
"critical_mineral_strategy"
