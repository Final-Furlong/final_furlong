SELECT
    rr.horse_id,
    DATE_PART('Year', r.date)::int AS year,
    ts.surface,
    count(rr.id)::int AS starts,
    SUM(
            CASE
                WHEN r.race_type = 'stakes' THEN 1
                ELSE 0
                END
    )::int AS stakes_starts,
    SUM(
            CASE finish_position
                WHEN 1 THEN 1
                ELSE 0
                END
    )::int AS wins,
    SUM(
            CASE
                WHEN r.race_type = 'stakes'
                    AND finish_position = 1 THEN 1
                ELSE 0
                END
    )::int AS stakes_wins,
    SUM(
            CASE finish_position
                WHEN 2 THEN 1
                ELSE 0
                END
    )::int AS seconds,
    SUM(
            CASE
                WHEN r.race_type = 'stakes'
                    AND finish_position = 2 THEN 1
                ELSE 0
                END
    )::int AS stakes_seconds,
    SUM(
            CASE finish_position
                WHEN 3 THEN 1
                ELSE 0
                END
    )::int AS thirds,
    SUM(
            CASE
                WHEN r.race_type = 'stakes'
                    AND finish_position = 3 THEN 1
                ELSE 0
                END
    )::int AS stakes_thirds,
    SUM(
            CASE finish_position
                WHEN 4 THEN 1
                ELSE 0
                END
    )::int AS fourths,
    SUM(
            CASE
                WHEN r.race_type = 'stakes'
                    AND finish_position = 4 THEN 1
                ELSE 0
                END
    )::int AS stakes_fourths,
    SUM(rr.earnings)::bigint AS earnings,
    SUM(rr.points)::int AS points
FROM
    race_result_horses rr
        LEFT JOIN race_results r ON rr.race_id = r.id
        LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
GROUP BY
    rr.horse_id,
    DATE_PART('Year', r.date),
    ts.surface
WITH DATA;
