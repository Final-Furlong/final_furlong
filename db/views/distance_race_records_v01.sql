SELECT h.id                                            AS horse_id,
       COALESCE(sprint_starts.starts, 0)               AS sprint_starts,
       COALESCE(sprint_stakes_starts.starts, 0)        AS sprint_stakes_starts,
       COALESCE(sprint_wins.wins, 0)                   AS sprint_wins,
       COALESCE(sprint_stakes_wins.wins, 0)            AS sprint_stakes_wins,
       COALESCE(sprint_seconds.seconds, 0)             AS sprint_seconds,
       COALESCE(sprint_stakes_seconds.seconds, 0)      AS sprint_stakes_seconds,
       COALESCE(sprint_thirds.thirds, 0)               AS sprint_thirds,
       COALESCE(sprint_stakes_thirds.thirds, 0)        AS sprint_stakes_thirds,
       COALESCE(sprint_fourths.fourths, 0)             AS sprint_fourths,
       COALESCE(sprint_stakes_fourths.fourths, 0)      AS sprint_stakes_fourths,
       COALESCE(mid_starts.starts, 0)                  AS mid_starts,
       COALESCE(mid_stakes_starts.starts, 0)           AS mid_stakes_starts,
       COALESCE(mid_wins.wins, 0)                      AS mid_wins,
       COALESCE(mid_stakes_wins.wins, 0)               AS mid_stakes_wins,
       COALESCE(mid_seconds.seconds, 0)                AS mid_seconds,
       COALESCE(mid_stakes_seconds.seconds, 0)         AS mid_stakes_seconds,
       COALESCE(mid_thirds.thirds, 0)                  AS mid_thirds,
       COALESCE(mid_stakes_thirds.thirds, 0)           AS mid_stakes_thirds,
       COALESCE(mid_fourths.fourths, 0)                AS mid_fourths,
       COALESCE(mid_stakes_fourths.fourths, 0)         AS mid_stakes_fourths,
       COALESCE(long_starts.starts, 0)                 AS long_starts,
       COALESCE(long_stakes_starts.starts, 0)          AS long_stakes_starts,
       COALESCE(long_wins.wins, 0)                     AS long_wins,
       COALESCE(long_stakes_wins.wins, 0)              AS long_stakes_wins,
       COALESCE(long_seconds.seconds, 0)               AS long_seconds,
       COALESCE(long_stakes_seconds.seconds, 0)        AS long_stakes_seconds,
       COALESCE(long_thirds.thirds, 0)                 AS long_thirds,
       COALESCE(long_stakes_thirds.thirds, 0)          AS long_stakes_thirds,
       COALESCE(long_fourths.fourths, 0)               AS long_fourths,
       COALESCE(long_stakes_fourths.fourths, 0)        AS long_stakes_fourths,
       COALESCE(jump_sprint_starts.starts, 0)          AS jump_sprint_starts,
       COALESCE(jump_sprint_stakes_starts.starts, 0)   AS jump_sprint_stakes_starts,
       COALESCE(jump_sprint_wins.wins, 0)              AS jump_sprint_wins,
       COALESCE(jump_sprint_stakes_wins.wins, 0)       AS jump_sprint_stakes_wins,
       COALESCE(jump_sprint_seconds.seconds, 0)        AS jump_sprint_seconds,
       COALESCE(jump_sprint_stakes_seconds.seconds, 0) AS jump_sprint_stakes_seconds,
       COALESCE(jump_sprint_thirds.thirds, 0)          AS jump_sprint_thirds,
       COALESCE(jump_sprint_stakes_thirds.thirds, 0)   AS jump_sprint_stakes_thirds,
       COALESCE(jump_sprint_fourths.fourths, 0)        AS jump_sprint_fourths,
       COALESCE(jump_sprint_stakes_fourths.fourths, 0) AS jump_sprint_stakes_fourths,
       COALESCE(jump_mid_starts.starts, 0)             AS jump_mid_starts,
       COALESCE(jump_mid_stakes_starts.starts, 0)      AS jump_mid_stakes_starts,
       COALESCE(jump_mid_wins.wins, 0)                 AS jump_mid_wins,
       COALESCE(jump_mid_stakes_wins.wins, 0)          AS jump_mid_stakes_wins,
       COALESCE(jump_mid_seconds.seconds, 0)           AS jump_mid_seconds,
       COALESCE(jump_mid_stakes_seconds.seconds, 0)    AS jump_mid_stakes_seconds,
       COALESCE(jump_mid_thirds.thirds, 0)             AS jump_mid_thirds,
       COALESCE(jump_mid_stakes_thirds.thirds, 0)      AS jump_mid_stakes_thirds,
       COALESCE(jump_mid_fourths.fourths, 0)           AS jump_mid_fourths,
       COALESCE(jump_mid_stakes_fourths.fourths, 0)    AS jump_mid_stakes_fourths,
       COALESCE(jump_long_starts.starts, 0)            AS jump_long_starts,
       COALESCE(jump_long_stakes_starts.starts, 0)     AS jump_long_stakes_starts,
       COALESCE(jump_long_wins.wins, 0)                AS jump_long_wins,
       COALESCE(jump_long_stakes_wins.wins, 0)         AS jump_long_stakes_wins,
       COALESCE(jump_long_seconds.seconds, 0)          AS jump_long_seconds,
       COALESCE(jump_long_stakes_seconds.seconds, 0)   AS jump_long_stakes_seconds,
       COALESCE(jump_long_thirds.thirds, 0)            AS jump_long_thirds,
       COALESCE(jump_long_stakes_thirds.thirds, 0)     AS jump_long_stakes_thirds,
       COALESCE(jump_long_fourths.fourths, 0)          AS jump_long_fourths,
       COALESCE(jump_long_stakes_fourths.fourths, 0)   AS jump_long_stakes_fourths
FROM horses h
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE r.distance <= 7.5
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS sprint_starts ON h.id = sprint_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE r.distance <= 7.5
                      AND r.race_type = 'stakes'
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS sprint_stakes_starts ON h.id = sprint_stakes_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND r.distance <= 7.5
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS sprint_wins ON h.id = sprint_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND r.distance <= 7.5
                      AND r.race_type = 'stakes'
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS sprint_stakes_wins ON h.id = sprint_stakes_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND r.distance <= 7.5
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS sprint_seconds ON h.id = sprint_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND r.distance <= 7.5
                      AND r.race_type = 'stakes'
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS sprint_stakes_seconds ON h.id = sprint_stakes_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND r.distance <= 7.5
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS sprint_thirds ON h.id = sprint_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND r.distance <= 7.5
                      AND r.race_type = 'stakes'
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS sprint_stakes_thirds ON h.id = sprint_stakes_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND r.distance <= 7.5
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS sprint_fourths ON h.id = sprint_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND r.distance <= 7.5
                      AND r.race_type = 'stakes'
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS sprint_stakes_fourths ON h.id = sprint_stakes_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE r.distance BETWEEN 8.0 AND 10.0
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS mid_starts ON h.id = mid_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE r.distance BETWEEN 8.0 AND 10.0
                      AND r.race_type = 'stakes'
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS mid_stakes_starts ON h.id = mid_stakes_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND r.distance BETWEEN 8.0 AND 10.0
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS mid_wins ON h.id = mid_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND r.distance BETWEEN 8.0 AND 10.0
                      AND r.race_type = 'stakes'
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS mid_stakes_wins ON h.id = mid_stakes_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND r.distance BETWEEN 8.0 AND 10.0
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS mid_seconds ON h.id = mid_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND r.distance BETWEEN 8.0 AND 10.0
                      AND r.race_type = 'stakes'
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS mid_stakes_seconds ON h.id = mid_stakes_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND r.distance BETWEEN 8.0 AND 10.0
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS mid_thirds ON h.id = mid_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND r.distance BETWEEN 8.0 AND 10.0
                      AND r.race_type = 'stakes'
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS mid_stakes_thirds ON h.id = mid_stakes_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND r.distance BETWEEN 8.0 AND 10.0
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS mid_fourths ON h.id = mid_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND r.distance BETWEEN 8.0 AND 10.0
                      AND r.race_type = 'stakes'
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS mid_stakes_fourths ON h.id = mid_stakes_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE r.distance > 10.0
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS long_starts ON h.id = long_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE r.distance > 10.0
                      AND r.race_type = 'stakes'
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS long_stakes_starts ON h.id = long_stakes_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND r.distance > 10.0
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS long_wins ON h.id = long_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND r.distance > 10.0
                      AND r.race_type = 'stakes'
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS long_stakes_wins ON h.id = long_stakes_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND r.distance > 10.0
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS long_seconds ON h.id = long_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND r.distance > 10.0
                      AND r.race_type = 'stakes'
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS long_stakes_seconds ON h.id = long_stakes_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND r.distance > 10.0
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS long_thirds ON h.id = long_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND r.distance > 10.0
                      AND r.race_type = 'stakes'
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS long_stakes_thirds ON h.id = long_stakes_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND r.distance > 10.0
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS long_fourths ON h.id = long_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND r.distance > 10.0
                      AND r.race_type = 'stakes'
                      AND ts.surface != 'steeplechase'
                    GROUP BY rr.horse_id) AS long_stakes_fourths ON h.id = long_stakes_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE r.distance <= 12
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_sprint_starts ON h.id = jump_sprint_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE r.distance <= 12
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_sprint_stakes_starts ON h.id = jump_sprint_stakes_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND r.distance <= 12
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_sprint_wins ON h.id = jump_sprint_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND r.distance <= 12
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_sprint_stakes_wins ON h.id = jump_sprint_stakes_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND r.distance <= 12
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_sprint_seconds ON h.id = jump_sprint_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND r.distance <= 12
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_sprint_stakes_seconds ON h.id = jump_sprint_stakes_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND r.distance <= 12
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_sprint_thirds ON h.id = jump_sprint_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND r.distance <= 12
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_sprint_stakes_thirds ON h.id = jump_sprint_stakes_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND r.distance <= 12
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_sprint_fourths ON h.id = jump_sprint_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND r.distance <= 12
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_sprint_stakes_fourths ON h.id = jump_sprint_stakes_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE r.distance BETWEEN 12.5 AND 18.0
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_mid_starts ON h.id = jump_mid_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE r.distance BETWEEN 12.5 AND 18.0
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_mid_stakes_starts ON h.id = jump_mid_stakes_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND r.distance BETWEEN 12.5 AND 18.0
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_mid_wins ON h.id = jump_mid_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND r.distance BETWEEN 12.5 AND 18.0
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_mid_stakes_wins ON h.id = jump_mid_stakes_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND r.distance BETWEEN 12.5 AND 18.0
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_mid_seconds ON h.id = jump_mid_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND r.distance BETWEEN 12.5 AND 18.0
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_mid_stakes_seconds ON h.id = jump_mid_stakes_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND r.distance BETWEEN 12.5 AND 18.0
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_mid_thirds ON h.id = jump_mid_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND r.distance BETWEEN 12.5 AND 18.0
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_mid_stakes_thirds ON h.id = jump_mid_stakes_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND r.distance BETWEEN 12.5 AND 18.0
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_mid_fourths ON h.id = jump_mid_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND r.distance BETWEEN 12.5 AND 18.0
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_mid_stakes_fourths ON h.id = jump_mid_stakes_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE r.distance > 18.0
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_long_starts ON h.id = jump_long_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE r.distance > 18.0
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_long_stakes_starts ON h.id = jump_long_stakes_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND r.distance > 18.0
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_long_wins ON h.id = jump_long_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND r.distance > 18.0
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_long_stakes_wins ON h.id = jump_long_stakes_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND r.distance > 18.0
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_long_seconds ON h.id = jump_long_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND r.distance > 18.0
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_long_stakes_seconds ON h.id = jump_long_stakes_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND r.distance > 18.0
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_long_thirds ON h.id = jump_long_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND r.distance > 18.0
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_long_stakes_thirds ON h.id = jump_long_stakes_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND r.distance > 18.0
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_long_fourths ON h.id = jump_long_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND r.distance > 18.0
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_long_stakes_fourths ON h.id = jump_long_stakes_fourths.horse_id
