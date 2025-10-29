SELECT horse_id,
       SUM(starts)         AS starts,
       SUM(stakes_starts)  AS stakes_starts,
       SUM(wins)           AS wins,
       SUM(stakes_wins)    AS stakes_wins,
       SUM(seconds)        AS seconds,
       SUM(stakes_seconds) AS stakes_seconds,
       SUM(thirds)         AS thirds,
       SUM(stakes_thirds)  AS stakes_thirds,
       SUM(fourths)        AS fourths,
       SUM(stakes_fourths) AS stakes_fourths,
       SUM(points)         AS points,
       SUM(earnings)       AS earnings
FROM race_records
GROUP BY horse_id
WITH DATA;
