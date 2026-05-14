SELECT
  h.id AS horse_id,
  COALESCE(starts.races, 0) AS starts,
  COALESCE(stakes.races, 0) AS stakes_starts,
  COALESCE(stakes_win.races, 0) AS stakes_wins,
  COALESCE(stakes_second.races, 0) AS stakes_seconds,
  COALESCE(stakes_third.races, 0) AS stakes_thirds,
  COALESCE(allowance.races, 0) AS allowance_wins,
  COALESCE(starts.points, 0) AS points,
  CASE WHEN bn.id IS NULL THEN false
  ELSE true
  END AS nominated
FROM
  horses h
  LEFT JOIN race_options ro ON h.id = ro.horse_id
  LEFT OUTER JOIN breeders_cup_nominations bn ON h.id = bn.horse_id
  LEFT JOIN (
    SELECT
      COUNT(r.id) AS races,
      SUM(rr.points) AS points,
      horse_id
    FROM
      race_result_horses rr
      LEFT JOIN race_results r ON rr.race_id = r.id
      LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
    WHERE
      ts.surface = 'steeplechase'
      AND r.distance BETWEEN 7.0 AND 16.0
      AND DATE_PART('Year', r.date) = DATE_PART('Year', CURRENT_DATE)
    GROUP BY
      rr.horse_id
  ) AS starts ON h.id = starts.horse_id
  LEFT JOIN (
    SELECT
      COUNT(r.id) AS races,
      horse_id
    FROM
      race_result_horses rr
      LEFT JOIN race_results r ON rr.race_id = r.id
      LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
    WHERE
      r.race_type = 'stakes'
      AND ts.surface = 'steeplechase'
      AND r.distance BETWEEN 7.0 AND 16.0
      AND DATE_PART('Year', r.date) = DATE_PART('Year', CURRENT_DATE)
    GROUP BY
      rr.horse_id
  ) AS stakes ON h.id = stakes.horse_id
  LEFT JOIN (
    SELECT
      COUNT(r.id) AS races,
      horse_id
    FROM
      race_result_horses rr
      LEFT JOIN race_results r ON rr.race_id = r.id
      LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
    WHERE
      rr.finish_position = 1
      AND r.race_type = 'stakes'
      AND ts.surface = 'steeplechase'
      AND r.distance BETWEEN 7.0 AND 16.0
      AND DATE_PART('Year', r.date) = DATE_PART('Year', CURRENT_DATE)
    GROUP BY
      rr.horse_id
  ) AS stakes_win ON h.id = stakes_win.horse_id
  LEFT JOIN (
    SELECT
      COUNT(r.id) AS races,
      horse_id
    FROM
      race_result_horses rr
      LEFT JOIN race_results r ON rr.race_id = r.id
      LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
    WHERE
      rr.finish_position = 2
      AND r.race_type = 'stakes'
      AND ts.surface = 'steeplechase'
      AND r.distance BETWEEN 7.0 AND 16.0
      AND DATE_PART('Year', r.date) = DATE_PART('Year', CURRENT_DATE)
    GROUP BY
      rr.horse_id
  ) AS stakes_second ON h.id = stakes_second.horse_id
  LEFT JOIN (
    SELECT
      COUNT(r.id) AS races,
      horse_id
    FROM
      race_result_horses rr
      LEFT JOIN race_results r ON rr.race_id = r.id
      LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
    WHERE
      rr.finish_position = 3
      AND r.race_type = 'stakes'
      AND ts.surface = 'steeplechase'
      AND r.distance BETWEEN 7.0 AND 16.0
      AND DATE_PART('Year', r.date) = DATE_PART('Year', CURRENT_DATE)
    GROUP BY
      rr.horse_id
  ) AS stakes_third ON h.id = stakes_third.horse_id
  LEFT JOIN (
    SELECT
      COUNT(r.id) AS races,
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
      AND r.distance BETWEEN 7.0 AND 16.0
      AND DATE_PART('Year', r.date) = DATE_PART('Year', CURRENT_DATE)
    GROUP BY
      rr.horse_id
  ) AS allowance ON h.id = allowance.horse_id
WHERE
  h.age > 2
  AND h.gender IN ('filly', 'mare')
  AND (bn.effective_year IS NULL OR bn.effective_year <= DATE_PART('Year', CURRENT_DATE))
  AND ro.racehorse_type = 'jump'
  AND COALESCE(starts.races, 0) > 0
  AND (COALESCE(stakes_win.races, 0) + COALESCE(stakes_second.races, 0) + COALESCE(stakes_third.races, 0) +
  COALESCE(allowance.races, 0)) > 0
