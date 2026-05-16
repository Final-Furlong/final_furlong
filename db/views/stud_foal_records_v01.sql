SELECT
  h.id AS horse_id,
  (
    SELECT
      COUNT(DISTINCT(DATE_PART('Year', date_of_birth))) AS crops
    FROM
      horses WHERE date_of_birth < current_date AND sire_id = h.id GROUP BY sire_id
  ) AS crops_count,
  coalesce(SUM(foals.born), 0)::int AS born_foals_count,
  coalesce(SUM(foals.unborn), 0)::int AS unborn_foals_count,
  CASE
      WHEN coalesce(SUM(foals.born), 0) > 0 THEN coalesce(SUM(foals.stillborn), 0)::int
    ELSE 0
  END AS stillborn_foals_count,
  CASE
      WHEN coalesce(SUM(foals.born), 0) > 0 THEN coalesce(SUM(foals.raced), 0)::int
    ELSE 0
  END AS raced_foals_count,
  CASE
      WHEN coalesce(SUM(foals.born), 0) > 0 THEN coalesce(SUM(foals.winners), 0)::int
    ELSE 0
  END AS winning_foals_count,
  CASE
      WHEN coalesce(SUM(foals.winners), 0) > 0 THEN coalesce(SUM(foals.stakes_winners), 0)::int
    ELSE 0
  END AS stakes_winning_foals_count,
  CASE
      WHEN coalesce(SUM(foals.winners), 0) > 0 THEN coalesce(SUM(foals.multi_stakes_winners), 0)::int
    ELSE 0
  END AS multi_stakes_winning_foals_count,
  CASE
      WHEN coalesce(SUM(foals.raced), 0) > 0 THEN coalesce(SUM(foals.millionaires), 0)::int
    ELSE 0
  END AS millionaire_foals_count,
  CASE
      WHEN coalesce(SUM(foals.raced), 0) > 0 THEN coalesce(SUM(foals.multi_millionaires), 0)::int
    ELSE 0
  END AS multi_millionaire_foals_count,
  coalesce(SUM(foals.races), 0)::int AS total_foal_races,
  coalesce(SUM(foals.earnings), 0)::bigint AS total_foal_earnings,
  coalesce(SUM(foals.points), 0)::int AS total_foal_points,
  FLOOR(SUM(foals.earnings) / SUM(foals.raced)) AS average_earnings,
  CASE
    WHEN (SUM(foals.points) / SUM(foals.races)) >= 8.1
    AND SUM(foals.races) >= 500 THEN 'platinum'
    WHEN (SUM(foals.points) / SUM(foals.races)) >= 5.1
    AND SUM(foals.races) >= 300 THEN 'gold'
    WHEN (SUM(foals.points) / SUM(foals.races)) >= 3.1 THEN 'silver'
    WHEN (SUM(foals.points) / SUM(foals.races)) >= 0.1 THEN 'bronze'
    ELSE NULL
  END AS breed_ranking,
  ROUND((SUM(foals.points) / SUM(foals.races)), 1) AS breed_ranking_points
FROM
  horses h
  LEFT JOIN (
    SELECT
      CASE
        WHEN date_of_birth > current_date THEN 1
        ELSE 0
      END AS unborn,
      CASE
        WHEN date_of_birth <= current_date THEN 1
        ELSE 0
      END AS born,
      CASE
        WHEN date_of_birth <= current_date
        AND date_of_birth = date_of_death THEN 1
        ELSE 0
      END AS stillborn,
      CASE
        WHEN lrr.starts > 0 THEN 1
        ELSE 0
      END AS raced,
      CASE
        WHEN lrr.wins > 0 THEN 1
        ELSE 0
      END AS winners,
      CASE
        WHEN lrr.stakes_wins >= 1 THEN 1
        ELSE 0
      END AS stakes_winners,
      CASE
        WHEN lrr.stakes_wins > 1 THEN 1
        ELSE 0
      END AS multi_stakes_winners,
      CASE
        WHEN lrr.earnings >= 1000000 THEN 1
        ELSE 0
      END AS millionaires,
      CASE
        WHEN lrr.earnings >= 2000000 THEN 1
        ELSE 0
      END AS multi_millionaires,
      lrr.starts AS races,
      lrr.earnings AS earnings,
      lrr.points AS points,
      sire_id
    FROM
      horses h2
      LEFT JOIN lifetime_race_records lrr ON h2.id = lrr.horse_id
  ) AS foals ON h.id = foals.sire_id
WHERE
  h.status IN ('stud', 'retired_stud', 'deceased')
  AND h.gender in ('stallion', 'gelding')
  AND (
    h.date_of_death IS NULL
    OR h.date_of_birth != h.date_of_death
  )
GROUP BY
  h.id
HAVING
  (
    (
      coalesce(SUM(foals.born), 0) + coalesce(SUM(foals.unborn), 0)
    ) > 0
  )
WITH DATA;
