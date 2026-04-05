SELECT horse_id, year,
               SUM(starts)::int         AS starts,
               SUM(stakes_starts)::int  AS stakes_starts,
               SUM(wins)::int           AS wins,
               SUM(stakes_wins)::int    AS stakes_wins,
               SUM(seconds)::int        AS seconds,
               SUM(stakes_seconds)::int AS stakes_seconds,
               SUM(thirds)::int         AS thirds,
               SUM(stakes_thirds)::int  AS stakes_thirds,
               SUM(fourths)::int        AS fourths,
               SUM(stakes_fourths)::int AS stakes_fourths,
               SUM(points)::bigint         AS points,
               SUM(earnings)::bigint       AS earnings
FROM race_records
GROUP BY horse_id, year
WITH DATA;
