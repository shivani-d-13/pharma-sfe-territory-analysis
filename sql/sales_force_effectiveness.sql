-- sales_force_effectiveness.sql
-- Sales representative effectiveness

WITH rep_calls AS (

    SELECT
        rep_id,
        COUNT(*) AS total_calls,
        COUNT(DISTINCT hcp_id) AS hcps_covered

    FROM fact_calls

    GROUP BY rep_id
),

rep_sales AS (

    SELECT
        r.rep_id,
        SUM(s.sales) AS total_sales

    FROM dim_rep AS r

    JOIN fact_territory_sales AS s
        ON r.territory_id = s.territory_id

    GROUP BY r.rep_id
),

rep_hcp_potential AS (

    SELECT
        r.rep_id,
        SUM(h.potential_score) AS total_hcp_potential

    FROM dim_rep AS r

    JOIN dim_hcp AS h
        ON r.territory_id = h.territory_id

    GROUP BY r.rep_id
)

SELECT
    r.rep_id,
    r.rep_name,
    r.territory_id,

    COALESCE(rc.total_calls, 0) AS total_calls,

    COALESCE(rc.hcps_covered, 0) AS hcps_covered,

    COALESCE(rs.total_sales, 0) AS total_sales,

    COALESCE(rp.total_hcp_potential, 0) AS total_hcp_potential,

    CASE
        WHEN COALESCE(rc.hcps_covered, 0) > 0
        THEN
            rc.total_calls * 1.0 / rc.hcps_covered
        ELSE 0
    END AS calls_per_hcp,

    CASE
        WHEN COALESCE(rc.total_calls, 0) > 0
        THEN
            rs.total_sales * 1.0 / rc.total_calls
        ELSE 0
    END AS sales_per_call

FROM dim_rep AS r

LEFT JOIN rep_calls AS rc
    ON r.rep_id = rc.rep_id

LEFT JOIN rep_sales AS rs
    ON r.rep_id = rs.rep_id

LEFT JOIN rep_hcp_potential AS rp
    ON r.rep_id = rp.rep_id

ORDER BY
    total_sales DESC;