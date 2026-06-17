test_that("strategy table covers all 30 and joins to commodity_costs", {
  expect_equal(nrow(critical_mineral_strategy), 30)
  crit <- mcb_commodities("Critical Minerals (India 30)")
  expect_true(all(critical_mineral_strategy$mineral %in% crit))
})

test_that("criticality_score is the mean of its two components", {
  st <- critical_mineral_strategy
  expect_equal(st$criticality_score,
               round((st$supply_risk + st$economic_importance) / 2, 1))
})

test_that("four thematic groups are present", {
  expect_setequal(
    mcb_strategic_groups(),
    c("Energy & Electronics", "Clean Energy & Advanced Tech",
      "Specialty Metals & Alloys", "Industrial & Agricultural"))
})

test_that("mcb_strategy filters work", {
  expect_true(nrow(mcb_strategy("lithium")) >= 1)
  expect_true(all(mcb_strategy(group = "Energy & Electronics")$strategic_group ==
                    "Energy & Electronics"))
  expect_true(all(mcb_strategy(min_criticality = 4.5)$criticality_score >= 4.5))
})
