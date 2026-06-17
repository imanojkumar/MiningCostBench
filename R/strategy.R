#' India critical-mineral strategic framework
#'
#' Access the policy-oriented attributes for the 30 critical minerals
#' (see \code{\link{critical_mineral_strategy}}). Matching on \code{mineral} is
#' case-insensitive (exact then partial).
#'
#' \strong{Values are indicative starter figures, not official.} See the dataset
#' help and \code{mcb_sources("NOTES")}.
#'
#' @param mineral Optional mineral name(s); \code{NULL} returns all 30.
#' @param group Optional thematic group filter (see
#'   \code{\link{mcb_strategic_groups}}).
#' @param min_criticality Optional lower bound on \code{criticality_score}.
#' @return A data frame of strategic-framework records.
#' @export
#' @examples
#' mcb_strategy("lithium")
#' mcb_strategy(group = "Energy & Electronics")
#' mcb_strategy(min_criticality = 4.5)
mcb_strategy <- function(mineral = NULL, group = NULL, min_criticality = NULL) {
  st <- MiningCostBench::critical_mineral_strategy
  if (!is.null(mineral)) {
    q <- tolower(trimws(mineral))
    nm <- tolower(st$mineral); off <- tolower(st$official_name)
    hit <- nm %in% q | off %in% q
    if (!any(hit)) {
      hit <- vapply(q, function(x) grepl(x, nm, fixed = TRUE) |
                      grepl(x, off, fixed = TRUE), logical(length(nm)))
      hit <- if (is.matrix(hit)) apply(hit, 1L, any) else hit
    }
    st <- st[hit, , drop = FALSE]
  }
  if (!is.null(group)) st <- st[st$strategic_group %in% group, , drop = FALSE]
  if (!is.null(min_criticality))
    st <- st[!is.na(st$criticality_score) &
               st$criticality_score >= min_criticality, , drop = FALSE]
  .mcb_frame(st)
}

#' Strategic thematic groups
#'
#' @return A character vector of the four thematic groups.
#' @export
#' @examples
#' mcb_strategic_groups()
mcb_strategic_groups <- function() {
  unique(MiningCostBench::critical_mineral_strategy$strategic_group)
}
