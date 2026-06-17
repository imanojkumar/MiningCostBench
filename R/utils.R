# Internal helpers -----------------------------------------------------------

# Match a commodity query against commodity_costs$commodity.
# Strategy: exact (case-insensitive) first, then partial (grepl), then NULL.
.mcb_match <- function(commodity) {
  cc <- MiningCostBench::commodity_costs
  if (is.null(commodity)) return(cc)
  query <- tolower(trimws(commodity))
  nm <- tolower(cc$commodity)
  hit <- nm %in% query
  if (any(hit)) return(cc[hit, , drop = FALSE])
  hit <- vapply(query, function(q) grepl(q, nm, fixed = TRUE), logical(length(nm)))
  hit <- if (is.matrix(hit)) apply(hit, 1L, any) else hit
  if (any(hit)) return(cc[hit, , drop = FALSE])
  cc[0, , drop = FALSE]
}

# Return a tibble if the package is available, else a plain data.frame.
.mcb_frame <- function(df) {
  if (requireNamespace("tibble", quietly = TRUE)) tibble::as_tibble(df) else df
}

# Quiet R CMD check for non-standard evaluation in ggplot2 aes()
utils::globalVariables(c("category", "type"))

utils::globalVariables(c("jx", "jy", "strategic_group", "official_name"))
