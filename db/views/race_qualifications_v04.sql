SELECT
  h.id AS horse_id,
  CASE (
      SELECT
        COUNT(*)
      FROM
        lifetime_race_records
      WHERE
        horse_id = h.id
        AND wins = 0
    )
    WHEN 1 THEN TRUE
    ELSE CASE (
        SELECT
          COUNT(*)
        FROM
          lifetime_race_records
        WHERE
          horse_id = h.id
      )
      WHEN 1 THEN FALSE
      ELSE TRUE
    END
  END maiden_qualified,
  CASE
    WHEN claiming_races.starts >= 3 THEN TRUE
    ELSE FALSE
  END claiming_qualified,
  CASE (
      SELECT
        COUNT(r.id)
      FROM
        race_result_horses rr
        LEFT JOIN race_results r ON rr.race_id = r.id
      WHERE
        rr.horse_id = h.id
        AND r.date >= CURRENT_DATE - interval '1 year'
        AND r.race_type = 'claiming'
    )
    WHEN 0 THEN FALSE
    ELSE TRUE
  END starter_allowance_qualified,
  CASE
    WHEN allowance_wins.wins >= 1 THEN FALSE
    ELSE TRUE
  END nw1_allowance_qualified,
  CASE
    WHEN allowance_wins.wins >= 2 THEN FALSE
    ELSE TRUE
  END nw2_allowance_qualified,
  CASE
    WHEN allowance_wins.wins >= 3 THEN FALSE
    ELSE TRUE
  END nw3_allowance_qualified,
  CASE (
      SELECT
        COUNT(r.id)
      FROM
        race_result_horses rr
        LEFT JOIN race_results r ON rr.race_id = r.id
      WHERE
        rr.horse_id = h.id
        AND rr.finish_position <= 3
        AND r.race_type = 'allowance'
    )
    WHEN 0 THEN FALSE
    ELSE TRUE
  END allowance_placed,
  CASE (
      SELECT
        COUNT(r.id)
      FROM
        race_result_horses rr
        LEFT JOIN race_results r ON rr.race_id = r.id
      WHERE
        rr.horse_id = h.id
        AND rr.finish_position <= 3
        AND r.race_type = 'stakes'
    )
    WHEN 0 THEN FALSE
    ELSE TRUE
  END stakes_placed
FROM
  horses h
  LEFT JOIN (
    SELECT
      COUNT(r.id) AS wins,
      horse_id
    FROM
      race_result_horses rr
      LEFT JOIN race_results r ON rr.race_id = r.id
    WHERE
      rr.finish_position = 1
      AND r.race_type IN (
        'starter_allowance',
        'nw1_allowance',
        'nw2_allowance',
        'nw3_allowance',
        'allowance',
        'stakes'
      )
    GROUP BY
      rr.horse_id
  ) AS allowance_wins ON h.id = allowance_wins.horse_id
  LEFT JOIN (
    SELECT
      count(r.id) AS starts,
      rr.horse_id
    FROM
      race_result_horses rr
      LEFT JOIN race_results r ON r.id = rr.race_id
    WHERE
      r.date > greatest(
        (
          SELECT
            MAX(date) AS sale_date
          FROM
            horse_sales hs
          WHERE
            hs.horse_id = rr.horse_id
        ),
        (
          SELECT
            date_of_birth
          FROM
            horses
          WHERE
            id = rr.horse_id
        )
      )
    GROUP BY
      rr.horse_id
  ) AS claiming_races ON h.id = claiming_races.horse_id
WHERE
  h.status = 'racehorse'
WITH DATA;
