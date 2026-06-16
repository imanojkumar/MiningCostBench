#' Tidy long cost-driver breakdown
#'
#' Pivots the six driver-stage columns of \code{\link{commodity_costs}} into a
#' long, tidy form: one row per commodity and driver stage.
#'
#' @param commodity Optional commodity name(s); \code{NULL} returns all.
#' @param category Optional category filter.
#' @return A data frame with columns \code{category}, \code{commodity},
#'   \code{driver_stage} and \code{driver_text}.
#' @export
#' @examples
#' mcb_drivers("copper")
#' head(mcb_drivers(category = "Critical Minerals (India 30)"))
mcb_drivers <- function(commodity = NULL, category = NULL) {
  cc <- mcb_costs(commodity, category)
  stages <- c(
    Extraction      = "driver_extraction",
    Processing      = "driver_processing",
    `Energy/Reagents` = "driver_energy_reagents",
    Logistics       = "driver_logistics",
    `Fiscal/ESG`    = "driver_fiscal_esg",
    Structural      = "driver_structural"
  )
  out <- do.call(rbind, lapply(seq_len(nrow(cc)), function(i) {
    data.frame(
      category    = cc$category[i],
      commodity   = cc$commodity[i],
      driver_stage = names(stages),
      driver_text = unlist(cc[i, stages], use.names = FALSE),
      stringsAsFactors = FALSE
    )
  }))
  if (is.null(out)) out <- data.frame(
    category = character(), commodity = character(),
    driver_stage = character(), driver_text = character(),
    stringsAsFactors = FALSE)
  out <- out[nzchar(out$driver_text), , drop = FALSE]
  .mcb_frame(out)
}

#' Cross-cutting cost drivers
#'
#' @param category Optional character vector to filter \code{driver_category}.
#' @return A data frame of cross-cutting cost drivers.
#' @export
#' @examples
#' mcb_cross_cutting()
#' mcb_cross_cutting("Energy")
mcb_cross_cutting <- function(category = NULL) {
  cd <- MiningCostBench::cost_drivers
  if (!is.null(category)) cd <- cd[cd$driver_category %in% category, , drop = FALSE]
  .mcb_frame(cd)
}
