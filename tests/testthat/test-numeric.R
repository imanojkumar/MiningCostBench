test_that("numeric layer is structured and typed", {
  expect_true(all(c("cost_low", "cost_high", "cost_unit", "is_metal_basis",
                    "numeric_available") %in% names(commodity_costs_numeric)))
  expect_type(commodity_costs_numeric$cost_low, "double")
  expect_type(commodity_costs_numeric$is_metal_basis, "logical")
})

test_that("mcb_costs_numeric returns parsed rows with low <= high", {
  g <- mcb_costs_numeric("gold")
  expect_gt(nrow(g), 0)
  expect_true(all(g$cost_low <= g$cost_high))
  # available_only default drops unparsed rows
  expect_true(all(mcb_costs_numeric(category = "Precious Metals")$numeric_available))
})

test_that("filtering to one unit gives a coherent set", {
  oz <- subset(mcb_costs_numeric(), cost_unit == "/oz")
  expect_true(all(oz$is_metal_basis))
})
