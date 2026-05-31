SELECT
  h.id AS horse_id,
  COALESCE(turf.starts, 0) AS starts,
  COALESCE(turf.stakes_starts, 0) AS stakes_starts,
  COALESCE(turf.stakes_wins, 0) AS stakes_wins,
  COALESCE(turf.stakes_seconds, 0) AS stakes_seconds,
  COALESCE(turf.stakes_thirds, 0) AS stakes_thirds,
  COALESCE(allowance_wins.wins, 0) AS allowance_wins,
  COALESCE(turf.points, 0) AS points,
  CASE WHEN sbn.id IS NOT NULL OR bn.id IS NOT NULL THEN true
  ELSE false
  END AS nominated
FROM
  horses h
  LEFT OUTER JOIN breeders_cup_nominations bn ON h.id = bn.horse_id
  LEFT OUTER JOIN supplemental_breeders_cup_nominations sbn ON h.id = sbn.horse_id
  LEFT JOIN race_schedules rs ON sbn.race_id = rs.id
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
      surface = 'turf'
      AND year = DATE_PART('Year', CURRENT_DATE)
    GROUP BY
      horse_id
  ) AS turf ON h.id = turf.horse_id
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
      AND ts.surface = 'turf'
      AND DATE_PART('Year', r.date) = DATE_PART('Year', CURRENT_DATE)
    GROUP BY
      rr.horse_id
  ) AS allowance_wins ON h.id = allowance_wins.horse_id
WHERE
  h.age = 2
  AND h.status = 'racehorse'
  AND h.gender IN ('colt', 'gelding')
  AND (bn.effective_year IS NULL OR bn.effective_year <= DATE_PART('Year', CURRENT_DATE))
  AND (sbn.id IS NULL OR (sbn.year = DATE_PART('Year', CURRENT_DATE) AND rs.name = 'Breeders'' Cup Juvenile Turf'))
  AND COALESCE(turf.starts, 0) > 0
  AND (COALESCE(turf.stakes_wins, 0) + COALESCE(turf.stakes_seconds, 0) + COALESCE(turf.stakes_thirds, 0) +
  COALESCE(allowance_wins.wins, 0)) > 0
WITH DATA;
