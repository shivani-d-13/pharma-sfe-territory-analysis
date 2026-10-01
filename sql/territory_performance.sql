-- territory_performance.sql
-- Territory-level sales and performance

SELECT
    t.territory_id,
    t.territory_name,
    t.region,
    t.market_potential,

    -- Total modeled sales
    SUM(s.sales) AS total_sales,

    -- Average sales per date-product observation
    AVG(s.sales) AS avg_sales,

    -- Number of distinct products represented
    COUNT(DISTINCT s.product_code) AS products_sold,

    -- Number of dates with sales records
    COUNT(DISTINCT s.date) AS active_days

FROM fact_territory_sales AS s

JOIN dim_territory AS t
    ON s.territory_id = t.territory_id

GROUP BY
    t.territory_id,
    t.territory_name,
    t.region,
    t.market_potential

ORDER BY
    total_sales DESC;