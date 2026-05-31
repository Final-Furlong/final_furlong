SELECT
  h.id AS horse_id,
  COALESCE(jump.starts, 0) AS starts,
  COALESCE(jump.stakes_starts, 0) AS stakes_starts,
  COALESCE(jump.stakes_wins, 0) AS stakes_wins,
  COALESCE(jump.stakes_seconds, 0) AS stakes_seconds,
  COALESCE(jump.stakes_thirds, 0) AS stakes_thirds,
  COALESCE(allowance_wins.wins, 0) AS allowance_wins,
  COALESCE(jump.points, 0) AS points
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
      surface = 'steeplechase'
      AND year = DATE_PART('Year', CURRENT_DATE)
    GROUP BY
      horse_id
  ) AS jump ON h.id = jump.horse_id
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
      AND ts.surface = 'steeplechase'
      AND DATE_PART('Year', r.date) = DATE_PART('Year', CURRENT_DATE)
    GROUP BY
      rr.horse_id
  ) AS allowance_wins ON h.id = allowance_wins.horse_id
WHERE
  h.age >= 3
  AND h.status = 'racehorse'
  AND h.gender IN ('filly', 'mare')
  AND ro.racehorse_type = 'jump'
  AND (bn.year = DATE_PART('Year', CURRENT_DATE))
  AND COALESCE(jump.starts, 0) > 0
  AND (COALESCE(jump.stakes_wins, 0) + COALESCE(jump.stakes_seconds, 0) + COALESCE(jump.stakes_thirds, 0) +
  COALESCE(allowance_wins.wins, 0)) > 0
