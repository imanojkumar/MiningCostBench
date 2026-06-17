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
#' @param vintage Optional snapshot filter (e.g. "2025-26").
#' @return A data frame (tibble if \pkg{tibble} is installed) of cost records.
#' @export
#' @examples
#' mcb_costs("copper")
#' mcb_costs(category = "Fuel & Atomic")
#' mcb_costs(c("gold", "silver"))
mcb_costs <- function(commodity = NULL, category = NULL, vintage = NULL) {
  out <- .mcb_match(commodity)
  if (!is.null(category)) out <- out[out$category %in% category, , drop = FALSE]
  if (!is.null(vintage))  out <- out[out$vintage %in% vintage, , drop = FALSE]
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

#' Numeric cost layer
#'
#' Returns parsed numeric cost bounds (see \code{\link{commodity_costs_numeric}}).
#' Units are not consistent across rows - filter to a single \code{cost_unit}
#' before aggregating or plotting.
#'
#' @param commodity Optional commodity name(s); \code{NULL} returns all.
#' @param category Optional category filter.
#' @param available_only If \code{TRUE} (default), drop rows with no parsed range.
#' @return A data frame of numeric cost records.
#' @export
#' @examples
#' mcb_costs_numeric("gold")
#' subset(mcb_costs_numeric(category = "Precious Metals"), cost_unit == "/oz")
mcb_costs_numeric <- function(commodity = NULL, category = NULL,
                              available_only = TRUE) {
  ccn <- MiningCostBench::commodity_costs_numeric
  if (!is.null(commodity)) {
    q <- tolower(trimws(commodity)); nm <- tolower(ccn$commodity)
    hit <- nm %in% q
    if (!any(hit)) {
      hit <- vapply(q, function(x) grepl(x, nm, fixed = TRUE), logical(length(nm)))
      hit <- if (is.matrix(hit)) apply(hit, 1L, any) else hit
    }
    ccn <- ccn[hit, , drop = FALSE]
  }
  if (!is.null(category)) ccn <- ccn[ccn$category %in% category, , drop = FALSE]
  if (isTRUE(available_only)) ccn <- ccn[ccn$numeric_available %in% TRUE, , drop = FALSE]
  .mcb_frame(ccn)
}

#' Available cost vintages
#'
#' @return A character vector of the snapshot vintages present in the data.
#' @export
#' @examples
#' mcb_vintages()
mcb_vintages <- function() {
  sort(unique(MiningCostBench::commodity_costs$vintage))
}
