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
