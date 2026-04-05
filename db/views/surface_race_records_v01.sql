
SELECT h.id                             AS horse_id,
       COALESCE(dirt.starts, 0)         AS dirt_starts,
       COALESCE(dirt.stakes_starts, 0)  AS dirt_stakes_starts,
       COALESCE(dirt.wins, 0)           AS dirt_wins,
       COALESCE(dirt.stakes_wins, 0)    AS dirt_stakes_wins,
       COALESCE(dirt.seconds, 0)        AS dirt_seconds,
       COALESCE(dirt.stakes_seconds, 0) AS dirt_stakes_seconds,
       COALESCE(dirt.thirds, 0)         AS dirt_thirds,
       COALESCE(dirt.stakes_thirds, 0)  AS dirt_stakes_thirds,
       COALESCE(dirt.fourths, 0)        AS dirt_fourths,
       COALESCE(dirt.stakes_fourths, 0) AS dirt_stakes_fourths,
       COALESCE(dirt.earnings, 0)       AS dirt_earnings,
       COALESCE(dirt.points, 0)         AS dirt_points,
       COALESCE(turf.starts, 0)         AS turf_starts,
       COALESCE(turf.stakes_starts, 0)  AS turf_stakes_starts,
       COALESCE(turf.wins, 0)           AS turf_wins,
       COALESCE(turf.stakes_wins, 0)    AS turf_stakes_wins,
       COALESCE(turf.seconds, 0)        AS turf_seconds,
       COALESCE(turf.stakes_seconds, 0) AS turf_stakes_seconds,
       COALESCE(turf.thirds, 0)         AS turf_thirds,
       COALESCE(turf.stakes_thirds, 0)  AS turf_stakes_thirds,
       COALESCE(turf.fourths, 0)        AS turf_fourths,
       COALESCE(turf.stakes_fourths, 0) AS turf_stakes_fourths,
       COALESCE(turf.earnings, 0)       AS turf_earnings,
       COALESCE(turf.points, 0)         AS turf_points,
       COALESCE(jump.starts, 0)         AS jump_starts,
       COALESCE(jump.stakes_starts, 0)  AS jump_stakes_starts,
       COALESCE(jump.wins, 0)           AS jump_wins,
       COALESCE(jump.stakes_wins, 0)    AS jump_stakes_wins,
       COALESCE(jump.seconds, 0)        AS jump_seconds,
       COALESCE(jump.stakes_seconds, 0) AS jump_stakes_seconds,
       COALESCE(jump.thirds, 0)         AS jump_thirds,
       COALESCE(jump.stakes_thirds, 0)  AS jump_stakes_thirds,
       COALESCE(jump.fourths, 0)        AS jump_fourths,
       COALESCE(jump.stakes_fourths, 0) AS jump_stakes_fourths,
       COALESCE(jump.earnings, 0)       AS jump_earnings,
       COALESCE(jump.points, 0)         AS jump_points
FROM horses h
         LEFT JOIN (SELECT horse_id,
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
                           SUM(earnings)::bigint       AS earnings,
                           SUM(points)::bigint         AS points
                    FROM race_records
                    WHERE surface = 'dirt'
                    GROUP BY horse_id) AS dirt ON h.id = dirt.horse_id
         LEFT JOIN (SELECT horse_id,
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
                           SUM(earnings)::bigint       AS earnings,
                           SUM(points)::bigint         AS points
                    FROM race_records
                    WHERE surface = 'turf'
                    GROUP BY horse_id) AS turf ON h.id = turf.horse_id
         LEFT JOIN (SELECT horse_id,
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
                           SUM(earnings)::bigint       AS earnings,
                           SUM(points)::bigint         AS points
                    FROM race_records
                    WHERE surface = 'steeplechase'
                    GROUP BY horse_id) AS jump ON h.id = jump.horse_id
WHERE COALESCE(dirt.starts, 0) > 0
   OR COALESCE(turf.starts, 0) > 0
   OR COALESCE(jump.starts, 0) > 0
