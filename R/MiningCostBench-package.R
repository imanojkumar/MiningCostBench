#' MiningCostBench: benchmark production costs and cost drivers for mining commodities
#'
#' A curated, citable dataset of indicative cash/production cost ranges and
#' structured cost-driver breakdowns for mining and mineral commodities,
#' grouped into six categories plus a cross-cutting driver table and a
#' notes/sources table.
#'
#' @section Data:
#' \itemize{
#'   \item \code{\link{commodity_costs}} - one row per commodity, with a
#'         six-stage cost-driver decomposition and a by-product flag.
#'   \item \code{\link{cost_drivers}} - cross-cutting cost drivers that apply
#'         across commodities.
#'   \item \code{\link{cost_sources}} - interpretation notes and indicative
#'         sources behind the figures.
#' }
#'
#' @section Key accessors:
#' \itemize{
#'   \item \code{\link{mcb_costs}}, \code{\link{mcb_commodities}},
#'         \code{\link{mcb_categories}}
#'   \item \code{\link{mcb_drivers}} (tidy long driver breakdown)
#'   \item \code{\link{mcb_byproducts}}, \code{\link{mcb_search}}
#'   \item \code{\link{mcb_cross_cutting}}, \code{\link{mcb_sources}}
#'   \item \code{\link{mcb_plot_overview}}
#' }
#'
#' @section Caveat:
#' Figures are indicative cash/production costs (not prices) and vary 3-5x with
#' grade, method, depth, geography, currency and by-product credits. For many
#' critical minerals the driver logic is far more reliable than the dollar
#' figure. Verify against current company guidance or a commercial cost-curve
#' provider before publication.
#'
#' @keywords internal
"_PACKAGE"
