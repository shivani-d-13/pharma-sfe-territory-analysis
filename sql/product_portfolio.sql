-- 05_product_portfolio.sql
-- Product portfolio performance

WITH product_sales AS (
    SELECT
        product_code,
        SUM(sales) AS total_sales
    FROM fact_territory_sales
    GROUP BY product_code
),

portfolio_total AS (
    SELECT
        SUM(total_sales) AS portfolio_sales
    FROM product_sales
)

SELECT
    p.product_code,
    p.therapeutic_area,
    ps.total_sales,
    ps.total_sales / NULLIF(pt.portfolio_sales, 0) AS sales_share

FROM product_sales AS ps

JOIN dim_product AS p
    ON ps.product_code = p.product_code

CROSS JOIN portfolio_total AS pt

ORDER BY total_sales DESC;