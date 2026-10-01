-- hcp_coverage.sql
-- HCP coverage analysis

WITH hcp_calls AS (

    SELECT
        hcp_id,
        COUNT(*) AS total_calls,

        SUM(
            CASE
                WHEN call_outcome = 'Successful'
                THEN 1
                ELSE 0
            END
        ) AS successful_calls

    FROM fact_calls

    GROUP BY hcp_id
)

SELECT
    h.hcp_id,
    h.territory_id,
    h.specialty,
    h.hcp_tier,
    h.potential_score,

    COALESCE(c.total_calls, 0) AS total_calls,

    COALESCE(c.successful_calls, 0) AS successful_calls,

    CASE
        WHEN COALESCE(c.total_calls, 0) > 0
        THEN 1
        ELSE 0
    END AS coverage_flag,

    CASE
        WHEN COALESCE(c.total_calls, 0) = 0
        THEN 'Uncovered'
        ELSE 'Covered'
    END AS coverage_status

FROM dim_hcp AS h

LEFT JOIN hcp_calls AS c
    ON h.hcp_id = c.hcp_id

ORDER BY
    h.potential_score DESC;