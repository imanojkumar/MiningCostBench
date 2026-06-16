#' Commodity categories
#'
#' @return A character vector of the commodity category labels.
#' @export
#' @examples
#' mcb_categories()
mcb_categories <- function() {
  unique(MiningCostBench::commodity_costs$category)
}

#' List commodities
#'
#' @param category Optional character vector of categories to filter by
#'   (see \code{\link{mcb_categories}}).
#' @return A character vector of commodity names.
#' @export
#' @examples
#' mcb_commodities()
#' mcb_commodities("Precious Metals")
mcb_commodities <- function(category = NULL) {
  cc <- MiningCostBench::commodity_costs
  if (!is.null(category)) cc <- cc[cc$category %in% category, , drop = FALSE]
  cc$commodity
}

#' Get cost rows for one or more commodities
#'
#' Returns the full cost record(s). Matching is case-insensitive: exact name
#' first, then partial (substring) match.
#'
#' @param commodity Optional commodity name(s); \code{NULL} returns all rows.
#' @param category Optional category filter applied after matching.
#' @return A data frame (tibble if \pkg{tibble} is installed) of cost records.
#' @export
#' @examples
#' mcb_costs("copper")
#' mcb_costs(category = "Fuel & Atomic")
#' mcb_costs(c("gold", "silver"))
mcb_costs <- function(commodity = NULL, category = NULL) {
  out <- .mcb_match(commodity)
  if (!is.null(category)) out <- out[out$category %in% category, , drop = FALSE]
  .mcb_frame(out)
}

#' By-product commodities
#'
#' Commodities with no standalone mining cost, recovered as a by-product of a
#' host metal (e.g. gallium, germanium, indium, rhenium, tellurium, selenium,
#' cadmium, hafnium).
#'
#' @return A data frame of the by-product commodities.
#' @export
#' @examples
#' mcb_byproducts()$commodity
mcb_byproducts <- function() {
  cc <- MiningCostBench::commodity_costs
  .mcb_frame(cc[cc$is_byproduct %in% TRUE, , drop = FALSE])
}

#' Free-text search across all commodity fields
#'
#' @param pattern A regular expression searched (case-insensitive) across all
#'   text columns of \code{\link{commodity_costs}}.
#' @return A data frame of matching commodity records.
#' @export
#' @examples
#' mcb_search("by-product")
#' mcb_search("tailings")
#' mcb_search("India")
mcb_search <- function(pattern) {
  stopifnot(is.character(pattern), length(pattern) == 1L)
  cc <- MiningCostBench::commodity_costs
  txt <- apply(cc[vapply(cc, is.character, logical(1))], 1L, paste, collapse = " ")
  hit <- grepl(pattern, txt, ignore.case = TRUE)
  .mcb_frame(cc[hit, , drop = FALSE])
}
