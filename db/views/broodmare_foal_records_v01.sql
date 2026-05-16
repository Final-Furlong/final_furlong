SELECT
  h.id AS horse_id,
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
    WHEN (SUM(foals.points) / SUM(foals.races)) >= 10.1
    AND SUM(foals.races) >= 50 THEN 'platinum'
    WHEN (SUM(foals.points) / SUM(foals.races)) >= 6.1
    AND SUM(foals.races) >= 30 THEN 'gold'
    WHEN (SUM(foals.points) / SUM(foals.races)) >= 3.1 THEN 'silver'
    WHEN (SUM(foals.points) / SUM(foals.races)) >= 0.1 THEN 'bronze'
    ELSE NULL
  END AS breed_ranking,
  ROUND((SUM(foals.points) / SUM(foals.races)), 1) AS breed_ranking_points,
  MIN(b.due_date) AS next_due_date,
  MIN(b.stud_id) AS in_foal_stud_id
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
      dam_id
    FROM
      horses h2
      LEFT JOIN lifetime_race_records lrr ON h2.id = lrr.horse_id
  ) AS foals ON h.id = foals.dam_id
  LEFT OUTER JOIN breedings b ON b.mare_id = h.id
WHERE
  h.status IN ('broodmare', 'retired_broodmare', 'deceased')
  AND h.gender in ('filly', 'mare')
  AND (
    h.date_of_death IS NULL
    OR h.date_of_birth != h.date_of_death
  )
  AND (
    b.id IS NULL
    OR b.status = 'bred'
  )
GROUP BY
  h.id
HAVING
  (
    (
      coalesce(SUM(foals.born), 0) + coalesce(SUM(foals.unborn), 0)
    ) > 0
  )
  OR COUNT(b.id) > 0
WITH DATA;
