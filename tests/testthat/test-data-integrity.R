test_that("core datasets load with expected structure", {
  for (d in list(commodity_costs, commodity_costs_numeric,
                 critical_mineral_strategy, cost_drivers, cost_sources)) {
    expect_s3_class(d, "data.frame")
  }
  expect_gt(nrow(commodity_costs), 40)
  expect_true(all(c("category", "commodity", "cost_text", "is_byproduct",
                    "drivers_raw", "vintage") %in% names(commodity_costs)))
  expect_type(commodity_costs$is_byproduct, "logical")
})

test_that("every commodity now has a parsed driver breakdown", {
  expect_true(all(nzchar(commodity_costs$drivers_raw)))
  stages <- c("driver_extraction", "driver_processing", "driver_energy_reagents",
              "driver_logistics", "driver_fiscal_esg", "driver_structural")
  populated <- rowSums(commodity_costs[stages] != "" &
                         !is.na(commodity_costs[stages])) > 0
  expect_true(all(populated))   # includes the four formerly-blank cross-ref rows
})

test_that("the four cross-reference rows are now filled in the critical category", {
  xref <- subset(commodity_costs,
                 category == "Critical Minerals (India 30)" &
                   commodity %in% c("Copper", "Nickel", "Tin", "PGE (Platinum-Group)"))
  expect_equal(nrow(xref), 4)
  expect_true(all(nzchar(xref$driver_extraction)))
})

test_that("by-product flag marks only true by-product/co-product minerals", {
  bp <- commodity_costs$commodity[commodity_costs$is_byproduct]
  expect_true(all(c("Gallium", "Germanium", "Indium", "Rhenium",
                    "Tellurium", "Selenium", "Cadmium", "Hafnium") %in% bp))
  expect_false(any(c("Copper", "Gold", "Iron Ore (seaborne, hematite)") %in% bp))
})

test_that("categories and a single vintage are as expected", {
  expect_setequal(
    mcb_categories(),
    c("Coal & Lignite", "Base Metals", "Precious Metals", "Fuel & Atomic",
      "Critical Minerals (India 30)", "Bulk & Industrial"))
  expect_equal(mcb_vintages(), "2025-26")
})
