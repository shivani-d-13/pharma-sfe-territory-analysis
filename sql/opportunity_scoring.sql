-- opportunity_scoring.sql
-- HCP opportunity scoring

WITH hcp_activity AS (

    SELECT
        hcp_id,
        COUNT(*) AS total_calls

    FROM fact_calls

    GROUP BY hcp_id
),

hcp_base AS (

    SELECT
        h.hcp_id,
        h.territory_id,
        h.specialty,
        h.hcp_tier,
        h.potential_score,

        COALESCE(a.total_calls, 0) AS total_calls

    FROM dim_hcp AS h

    LEFT JOIN hcp_activity AS a
        ON h.hcp_id = a.hcp_id
),

scored AS (

    SELECT
        *,

        CASE
            WHEN total_calls = 0
            THEN 1
            ELSE 0
        END AS uncovered_flag,

        CASE hcp_tier
            WHEN 'A' THEN 3
            WHEN 'B' THEN 2
            WHEN 'C' THEN 1
        END AS tier_score

    FROM hcp_base
)

SELECT
    hcp_id,
    territory_id,
    specialty,
    hcp_tier,
    potential_score,
    total_calls,
    uncovered_flag,
    tier_score,

    (
        potential_score * 0.60
        +
        tier_score * 10 * 0.20
        +
        uncovered_flag * 100 * 0.20
    ) AS opportunity_score

FROM scored

ORDER BY
    opportunity_score DESC;