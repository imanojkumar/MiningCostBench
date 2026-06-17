# MiningCostBench 1.0.0

* First stable release.
* The public API for data accessors (`mcb_costs`, `mcb_drivers`, `mcb_strategy`, etc.) is now considered stable.

# MiningCostBench 0.2.0

Adds the India strategic-framework layer, a numeric cost layer, a vintage key,
and fills the four cross-reference rows.

* New dataset `critical_mineral_strategy` (30 rows): thematic group, indicative
  `criticality_score` / `supply_risk` / `economic_importance`,
  `import_dependence_pct`, and qualitative `domestic_reserves` / `key_producers`
  / `india_status`. Values are indicative starter figures, not official.
* New dataset `commodity_costs_numeric`: parsed `cost_low` / `cost_high` /
  `cost_unit` bounds for charting (not unit-consistent across rows).
* New `vintage` column on `commodity_costs` (all rows "2025-26"); schema is
  year-keyed for future snapshots.
* The four cross-reference rows (Copper, Nickel, Tin, PGE) in the critical
  category now carry their own six-stage driver breakdown.
* New accessors: `mcb_strategy()`, `mcb_strategic_groups()`,
  `mcb_costs_numeric()`, `mcb_vintages()`; `mcb_costs()` gains a `vintage`
  argument; new plot `mcb_plot_criticality()` (supply-risk vs economic-importance
  matrix).

# MiningCostBench 0.1.0

* Initial release.
* Datasets: `commodity_costs` (53 commodities across 6 categories with a
  six-stage cost-driver breakdown and an `is_byproduct` flag), `cost_drivers`
  (cross-cutting drivers) and `cost_sources` (notes and indicative sources).
* Accessors: `mcb_costs()`, `mcb_commodities()`, `mcb_categories()`,
  `mcb_drivers()`, `mcb_byproducts()`, `mcb_search()`, `mcb_cross_cutting()`,
  `mcb_sources()`, and `mcb_plot_overview()`.
