SELECT
  horse_id,
  SUM(starts)::int AS starts,
  SUM(stakes_starts)::int AS stakes_starts,
  SUM(wins)::int AS wins,
  SUM(stakes_wins)::int AS stakes_wins,
  SUM(seconds)::int AS seconds,
  SUM(stakes_seconds)::int AS stakes_seconds,
  SUM(thirds)::int AS thirds,
  SUM(stakes_thirds)::int AS stakes_thirds,
  SUM(fourths)::int AS fourths,
  SUM(stakes_fourths)::int AS stakes_fourths,
  SUM(points)::bigint AS points,
  SUM(earnings)::bigint AS earnings,
  CASE
    WHEN SUM(points)::bigint >= 1500 THEN 'FFCh.'
    WHEN SUM(points)::bigint >= 1000 THEN 'WCh.'
    WHEN SUM(points)::bigint >= 750 THEN 'ICh.'
    WHEN SUM(points)::bigint >= 500 THEN 'NCh.'
    WHEN SUM(points)::bigint >= 300 THEN 'GCh.'
    WHEN SUM(points)::bigint >= 100 THEN 'Ch.'
    ELSE ''
  END AS title_abbreviation,
  concat(
    CASE
      WHEN SUM(starts)::int = 0 THEN 'Unraced'
      ELSE CASE
        WHEN SUM(stakes_wins) > 1
        AND (SUM(stakes_seconds) + SUM(stakes_thirds)) > 1 THEN 'Mult. Stakes Winner, Mult. Stakes Placed'
        WHEN SUM(stakes_wins) > 1
        AND (SUM(stakes_seconds) + SUM(stakes_thirds)) = 1 THEN 'Mult. Stakes Winner, Stakes Placed'
        WHEN SUM(stakes_wins) = 1
        AND (SUM(stakes_seconds) + SUM(stakes_thirds)) > 1 THEN 'Stakes Winner, Mult. Stakes Placed'
        WHEN SUM(stakes_wins) = 1
        AND (SUM(stakes_seconds) + SUM(stakes_thirds)) = 1 THEN 'Stakes Winner, Stakes Placed'
        WHEN SUM(stakes_wins) > 1
        AND (SUM(stakes_seconds) + SUM(stakes_thirds)) = 0 THEN 'Mult. Stakes Winner'
        WHEN SUM(stakes_wins) = 1
        AND (SUM(stakes_seconds) + SUM(stakes_thirds)) = 0 THEN 'Stakes Winner'
        WHEN SUM(stakes_wins) = 0
        AND (SUM(stakes_seconds) + SUM(stakes_thirds)) > 1 THEN 'Mult. Stakes Placed'
        WHEN SUM(stakes_wins) = 0
        AND (SUM(stakes_seconds) + SUM(stakes_thirds)) = 1 THEN 'Stakes Placed'
        WHEN SUM(wins) > 1
        AND (SUM(seconds) + SUM(thirds)) > 1 THEN 'Mult. Winner, Mult. Placed'
        WHEN SUM(wins) > 1
        AND (SUM(seconds) + SUM(thirds)) = 1 THEN 'Mult. Winner, Placed'
        WHEN SUM(wins) = 1
        AND (SUM(seconds) + SUM(thirds)) > 1 THEN 'Winner, Mult. Placed'
        WHEN SUM(wins) = 1
        AND (SUM(seconds) + SUM(thirds)) = 1 THEN 'Winner, Placed'
        WHEN SUM(wins) > 1
        AND (SUM(seconds) + SUM(thirds)) = 1 THEN 'Mult. Winner'
        WHEN SUM(wins) = 1
        AND (SUM(seconds) + SUM(thirds)) = 0 THEN 'Winner'
        WHEN SUM(wins) = 0
        AND (SUM(seconds) + SUM(thirds)) > 1 THEN 'Mult. Placed'
        WHEN SUM(wins) = 0
        AND (SUM(seconds) + SUM(thirds)) = 1 THEN 'Placed'
        ELSE 'Unplaced'
      END
    END,
    CASE
      WHEN SUM(earnings) > 2000000 THEN ', Multi-Millionaire'
      WHEN SUM(earnings) >= 1000000 THEN ', Millionaire'
      ELSE ''
    END
  ) AS description
FROM
  race_records
GROUP BY
  horse_id
WITH DATA;
