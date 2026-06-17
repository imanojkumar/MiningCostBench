#' Overview plot of the commodity coverage
#'
#' A simple bar chart of the number of commodities per category, shaded by
#' whether they are standalone-mined or recovered as a by-product. Cost figures
#' are intentionally not plotted on a single axis because their units differ
#' across commodities (per tonne of ore, per pound of metal, per ounce, etc.).
#'
#' @return A \pkg{ggplot2} object. Requires \pkg{ggplot2}.
#' @export
#' @examples
#' \dontrun{
#' mcb_plot_overview()
#' }
mcb_plot_overview <- function() {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required for mcb_plot_overview(). ",
         "Install it with install.packages('ggplot2').", call. = FALSE)
  }
  cc <- MiningCostBench::commodity_costs
  cc$type <- ifelse(cc$is_byproduct %in% TRUE, "By-product", "Primary / standalone")
  ggplot2::ggplot(cc, ggplot2::aes(x = category, fill = type)) +
    ggplot2::geom_bar() +
    ggplot2::coord_flip() +
    ggplot2::labs(
      title = "MiningCostBench coverage",
      subtitle = "Commodities per category, by mining basis",
      x = NULL, y = "Number of commodities", fill = NULL) +
    ggplot2::theme_minimal()
}

#' Criticality matrix plot
#'
#' A supply-risk vs economic-importance scatter of the 30 critical minerals,
#' coloured by thematic group - the classic "criticality matrix" view. Uses the
#' indicative starter scores in \code{\link{critical_mineral_strategy}}.
#'
#' @return A \pkg{ggplot2} object. Requires \pkg{ggplot2}.
#' @export
#' @examples
#' \dontrun{
#' mcb_plot_criticality()
#' }
mcb_plot_criticality <- function() {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required for mcb_plot_criticality(). ",
         "Install it with install.packages('ggplot2').", call. = FALSE)
  }
  st <- MiningCostBench::critical_mineral_strategy
  st$jx <- st$supply_risk + stats::runif(nrow(st), -0.12, 0.12)
  st$jy <- st$economic_importance + stats::runif(nrow(st), -0.12, 0.12)
  ggplot2::ggplot(st, ggplot2::aes(x = jx, y = jy, colour = strategic_group)) +
    ggplot2::geom_point(size = 3, alpha = 0.85) +
    ggplot2::geom_text(ggplot2::aes(label = official_name),
                       size = 2.6, vjust = -0.9, show.legend = FALSE) +
    ggplot2::scale_x_continuous(limits = c(1, 5.5), breaks = 1:5) +
    ggplot2::scale_y_continuous(limits = c(1, 5.5), breaks = 1:5) +
    ggplot2::labs(
      title = "India critical minerals - indicative criticality matrix",
      subtitle = "Indicative starter scores; not official",
      x = "Supply risk (1-5)", y = "Economic importance (1-5)",
      colour = "Strategic group") +
    ggplot2::theme_minimal()
}
