SELECT
    h.breeder_id,
    s.name,
    DATE_PART('Year', r.date)::int AS year,
    count(rr.id)::int AS starts,
    SUM(
            CASE finish_position
                WHEN 1 THEN 1
                ELSE 0
                END
    )::int AS wins,
    SUM(
            CASE finish_position
                WHEN 2 THEN 1
                ELSE 0
                END
    )::int AS seconds,
    SUM(
            CASE finish_position
                WHEN 3 THEN 1
                ELSE 0
                END
    )::int AS thirds,
    SUM(
            CASE finish_position
                WHEN 4 THEN 1
                ELSE 0
                END
    )::int AS fourths,
    SUM(
            CASE finish_position
                WHEN 5 THEN 1
                ELSE 0
                END
    )::int AS fifths,
    SUM(rr.earnings)::bigint AS earnings,
    SUM(rr.points)::bigint AS points
FROM
    race_result_horses rr
        LEFT JOIN race_results r ON rr.race_id = r.id
  LEFT JOIN horses h ON rr.horse_id = h.id
  LEFT JOIN stables s ON h.breeder_id = s.id
WHERE r.race_type = 'stakes' AND r.name ILIKE '% Breeders'' Stakes'
  AND s.name != 'Final Furlong'
GROUP BY
    h.breeder_id,
    s.name,
    DATE_PART('Year', r.date)::int
ORDER BY DATE_PART('Year', r.date)::int, SUM(rr.points)::bigint DESC, s.name ASC
