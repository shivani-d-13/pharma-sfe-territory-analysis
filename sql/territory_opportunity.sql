-- territory_opportunity.sql
-- Territory opportunity analysis

WITH territory_sales AS (

    SELECT
        territory_id,
        SUM(sales) AS total_sales

    FROM fact_territory_sales

    GROUP BY territory_id
),

territory_base AS (

    SELECT
        t.territory_id,
        t.territory_name,
        t.region,
        t.market_potential,
        s.total_sales

    FROM dim_territory AS t

    JOIN territory_sales AS s
        ON t.territory_id = s.territory_id
),

network_max AS (

    SELECT
        MAX(total_sales) AS max_sales,
        MAX(market_potential) AS max_potential

    FROM territory_base
)

SELECT
    tb.territory_id,
    tb.territory_name,
    tb.region,

    tb.market_potential,
    tb.total_sales,

    -- Relative indices
    tb.total_sales / nm.max_sales AS sales_index,

    tb.market_potential / nm.max_potential AS potential_index,

    -- Relative realization
    (
        tb.total_sales / nm.max_sales
    )
    /
    NULLIF(
        tb.market_potential / nm.max_potential,
        0
    ) AS realization_index,

    -- Relative opportunity gap
    (
        tb.market_potential / nm.max_potential
    )
    -
    (
        tb.total_sales / nm.max_sales
    ) AS opportunity_gap

FROM territory_base AS tb

CROSS JOIN network_max AS nm

ORDER BY
    opportunity_gap DESC;