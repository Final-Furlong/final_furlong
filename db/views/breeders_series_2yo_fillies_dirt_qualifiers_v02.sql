SELECT
  DISTINCT(h.id) AS horse_id,
  COALESCE(dirt.starts, 0) AS starts,
  COALESCE(dirt.stakes_starts, 0) AS stakes_starts,
  COALESCE(dirt.stakes_wins, 0) AS stakes_wins,
  COALESCE(dirt.stakes_seconds, 0) AS stakes_seconds,
  COALESCE(dirt.stakes_thirds, 0) AS stakes_thirds,
  COALESCE(allowance_wins.wins, 0) AS allowance_wins,
  COALESCE(dirt.points, 0) AS points
FROM
  horses h LEFT JOIN stables b ON h.breeder_id = b.id
  LEFT JOIN race_options ro ON h.id = ro.horse_id
  LEFT JOIN breeders_series_nominations bn ON b.id = bn.stable_id
  LEFT JOIN (
    SELECT
      horse_id,
      SUM(starts)::int AS starts,
      SUM(stakes_starts)::int AS stakes_starts,
      SUM(stakes_wins)::int AS stakes_wins,
      SUM(stakes_seconds)::int AS stakes_seconds,
      SUM(stakes_thirds)::int AS stakes_thirds,
      SUM(points)::bigint AS points
    FROM
      race_records
    WHERE
      surface = 'dirt'
      AND year = DATE_PART('Year', CURRENT_DATE)
    GROUP BY
      horse_id
  ) AS dirt ON h.id = dirt.horse_id
  LEFT JOIN (
    SELECT
      COUNT(r.id) AS wins,
      horse_id
    FROM
      race_result_horses rr
      LEFT JOIN race_results r ON rr.race_id = r.id
      LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
    WHERE
      rr.finish_position = 1
      AND r.race_type IN (
        'starter_allowance',
        'nw1_allowance',
        'nw2_allowance',
        'nw3_allowance',
        'allowance'
      )
      AND ts.surface = 'dirt'
      AND DATE_PART('Year', r.date) = DATE_PART('Year', CURRENT_DATE)
    GROUP BY
      rr.horse_id
  ) AS allowance_wins ON h.id = allowance_wins.horse_id
WHERE
  h.age = 2
  AND h.type = 'Horses::Horse::Racehorse'
  AND h.state = 'active'
  AND h.gender = 'filly'
  AND ro.racehorse_type = 'flat'
  AND (bn.year = DATE_PART('Year', CURRENT_DATE))
  AND COALESCE(dirt.starts, 0) > 0
  AND (COALESCE(dirt.stakes_wins, 0) + COALESCE(dirt.stakes_seconds, 0) + COALESCE(dirt.stakes_thirds, 0) +
  COALESCE(allowance_wins.wins, 0)) > 0
WITH DATA;
