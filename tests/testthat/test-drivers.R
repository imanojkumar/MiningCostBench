test_that("mcb_drivers returns tidy long form", {
  d <- mcb_drivers("copper", category = "Base Metals")
  expect_true(all(c("category", "commodity", "driver_stage", "driver_text") %in% names(d)))
  expect_true(all(nzchar(d$driver_text)))
  expect_true(all(d$driver_stage %in%
    c("Extraction", "Processing", "Energy/Reagents",
      "Logistics", "Fiscal/ESG", "Structural")))
})

test_that("formerly-blank cross-ref rows now yield drivers in the critical category", {
  d <- mcb_drivers("copper", category = "Critical Minerals (India 30)")
  expect_equal(nrow(d), 6)
})

test_that("cross-cutting and sources accessors work", {
  expect_gt(nrow(mcb_cross_cutting()), 10)
  expect_gt(nrow(mcb_sources("SOURCES")), 0)
  expect_gt(nrow(mcb_sources("NOTES")), 0)
})
