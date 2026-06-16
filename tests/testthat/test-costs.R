test_that("mcb_costs matches exactly and partially", {
  expect_true(any(grepl("Copper", mcb_costs("copper")$commodity)))
  expect_gt(nrow(mcb_costs()), 0)        # NULL returns all
  expect_equal(nrow(mcb_costs("not_a_real_commodity")), 0)
})

test_that("category filtering works", {
  pm <- mcb_costs(category = "Precious Metals")
  expect_true(all(pm$category == "Precious Metals"))
  expect_true(any(grepl("Gold", pm$commodity)))
})

test_that("mcb_commodities respects category filter", {
  expect_true(length(mcb_commodities("Base Metals")) >= 5)
})

test_that("mcb_byproducts flags only by-product minerals", {
  bp <- mcb_byproducts()
  expect_true(all(bp$is_byproduct))
  expect_true(any(grepl("Gallium|Germanium|Indium|Rhenium", bp$commodity)))
})

test_that("mcb_search finds text across fields", {
  expect_gt(nrow(mcb_search("tailings")), 0)
  expect_gt(nrow(mcb_search("by-product")), 0)
})
