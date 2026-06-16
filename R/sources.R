#' Interpretation notes and indicative sources
#'
#' @param section Optional: "NOTES" or "SOURCES" to filter.
#' @return A data frame of notes/sources.
#' @export
#' @examples
#' mcb_sources("SOURCES")
#' mcb_sources("NOTES")
mcb_sources <- function(section = NULL) {
  cs <- MiningCostBench::cost_sources
  if (!is.null(section)) cs <- cs[toupper(cs$section) %in% toupper(section), , drop = FALSE]
  .mcb_frame(cs)
}
