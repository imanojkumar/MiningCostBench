test_that("datasets load with expected structure", {
  expect_s3_class(commodity_costs, "data.frame")
  expect_s3_class(cost_drivers, "data.frame")
  expect_s3_class(cost_sources, "data.frame")
  expect_gt(nrow(commodity_costs), 40)
  expect_true(all(c("category", "commodity", "cost_text",
                    "is_byproduct", "drivers_raw") %in% names(commodity_costs)))
  expect_type(commodity_costs$is_byproduct, "logical")
})

test_that("every commodity carries driver content", {
  # All rows have the full prose in drivers_raw ...
  expect_true(all(nzchar(commodity_costs$drivers_raw)))

  # ... and every non-cross-reference row has >= 1 parsed driver stage.
  stages <- c("driver_extraction", "driver_processing", "driver_energy_reagents",
              "driver_logistics", "driver_fiscal_esg", "driver_structural")
  is_xref <- grepl("^Cross-reference", commodity_costs$drivers_raw)
  populated <- rowSums(commodity_costs[stages] != "" &
                         !is.na(commodity_costs[stages])) > 0
  expect_true(all(populated[!is_xref]))
})

test_that("by-product flag marks only true by-product/co-product minerals", {
  bp <- commodity_costs$commodity[commodity_costs$is_byproduct]
  expect_true(all(c("Gallium", "Germanium", "Indium", "Rhenium",
                    "Tellurium", "Selenium", "Cadmium", "Hafnium") %in% bp))
  # primary-mined commodities must NOT be flagged
  expect_false(any(c("Copper", "Gold", "Iron Ore (seaborne, hematite)") %in% bp))
})

test_that("categories are the expected six", {
  expect_setequal(
    mcb_categories(),
    c("Coal & Lignite", "Base Metals", "Precious Metals", "Fuel & Atomic",
      "Critical Minerals (India 30)", "Bulk & Industrial")
  )
})
