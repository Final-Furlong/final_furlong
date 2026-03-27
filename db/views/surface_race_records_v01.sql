SELECT h.id                                     AS horse_id,
       COALESCE(dirt_starts.starts, 0)          AS dirt_starts,
       COALESCE(dirt_stakes_starts.starts, 0)   AS dirt_stakes_starts,
       COALESCE(dirt_wins.wins, 0)              AS dirt_wins,
       COALESCE(dirt_stakes_wins.wins, 0)       AS dirt_stakes_wins,
       COALESCE(dirt_seconds.seconds, 0)        AS dirt_seconds,
       COALESCE(dirt_stakes_seconds.seconds, 0) AS dirt_stakes_seconds,
       COALESCE(dirt_thirds.thirds, 0)          AS dirt_thirds,
       COALESCE(dirt_stakes_thirds.thirds, 0)   AS dirt_stakes_thirds,
       COALESCE(dirt_fourths.fourths, 0)        AS dirt_fourths,
       COALESCE(dirt_stakes_fourths.fourths, 0) AS dirt_stakes_fourths,
       COALESCE(turf_starts.starts, 0)          AS turf_starts,
       COALESCE(turf_stakes_starts.starts, 0)   AS turf_stakes_starts,
       COALESCE(turf_wins.wins, 0)              AS turf_wins,
       COALESCE(turf_stakes_wins.wins, 0)       AS turf_stakes_wins,
       COALESCE(turf_seconds.seconds, 0)        AS turf_seconds,
       COALESCE(turf_stakes_seconds.seconds, 0) AS turf_stakes_seconds,
       COALESCE(turf_thirds.thirds, 0)          AS turf_thirds,
       COALESCE(turf_stakes_thirds.thirds, 0)   AS turf_stakes_thirds,
       COALESCE(turf_fourths.fourths, 0)        AS turf_fourths,
       COALESCE(turf_stakes_fourths.fourths, 0) AS turf_stakes_fourths,
       COALESCE(jump_starts.starts, 0)          AS jump_starts,
       COALESCE(jump_stakes_starts.starts, 0)   AS jump_stakes_starts,
       COALESCE(jump_wins.wins, 0)              AS jump_wins,
       COALESCE(jump_stakes_wins.wins, 0)       AS jump_stakes_wins,
       COALESCE(jump_seconds.seconds, 0)        AS jump_seconds,
       COALESCE(jump_stakes_seconds.seconds, 0) AS jump_stakes_seconds,
       COALESCE(jump_thirds.thirds, 0)          AS jump_thirds,
       COALESCE(jump_stakes_thirds.thirds, 0)   AS jump_stakes_thirds,
       COALESCE(jump_fourths.fourths, 0)        AS jump_fourths,
       COALESCE(jump_stakes_fourths.fourths, 0) AS jump_stakes_fourths
FROM horses h
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE ts.surface = 'dirt'
                    GROUP BY rr.horse_id) AS dirt_starts ON h.id = dirt_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE r.race_type = 'stakes'
                      AND ts.surface = 'dirt'
                    GROUP BY rr.horse_id) AS dirt_stakes_starts ON h.id = dirt_stakes_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND ts.surface = 'dirt'
                    GROUP BY rr.horse_id) AS dirt_wins ON h.id = dirt_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'dirt'
                    GROUP BY rr.horse_id) AS dirt_stakes_wins ON h.id = dirt_stakes_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND ts.surface = 'dirt'
                    GROUP BY rr.horse_id) AS dirt_seconds ON h.id = dirt_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'dirt'
                    GROUP BY rr.horse_id) AS dirt_stakes_seconds ON h.id = dirt_stakes_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND ts.surface = 'dirt'
                    GROUP BY rr.horse_id) AS dirt_thirds ON h.id = dirt_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'dirt'
                    GROUP BY rr.horse_id) AS dirt_stakes_thirds ON h.id = dirt_stakes_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND ts.surface = 'dirt'
                    GROUP BY rr.horse_id) AS dirt_fourths ON h.id = dirt_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'dirt'
                    GROUP BY rr.horse_id) AS dirt_stakes_fourths ON h.id = dirt_stakes_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE ts.surface = 'turf'
                    GROUP BY rr.horse_id) AS turf_starts ON h.id = turf_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE r.race_type = 'stakes'
                      AND ts.surface = 'turf'
                    GROUP BY rr.horse_id) AS turf_stakes_starts ON h.id = turf_stakes_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND ts.surface = 'turf'
                    GROUP BY rr.horse_id) AS turf_wins ON h.id = turf_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'turf'
                    GROUP BY rr.horse_id) AS turf_stakes_wins ON h.id = turf_stakes_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND ts.surface = 'turf'
                    GROUP BY rr.horse_id) AS turf_seconds ON h.id = turf_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'turf'
                    GROUP BY rr.horse_id) AS turf_stakes_seconds ON h.id = turf_stakes_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND ts.surface = 'turf'
                    GROUP BY rr.horse_id) AS turf_thirds ON h.id = turf_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'turf'
                    GROUP BY rr.horse_id) AS turf_stakes_thirds ON h.id = turf_stakes_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND ts.surface = 'turf'
                    GROUP BY rr.horse_id) AS turf_fourths ON h.id = turf_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'turf'
                    GROUP BY rr.horse_id) AS turf_stakes_fourths ON h.id = turf_stakes_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_starts ON h.id = jump_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_stakes_starts ON h.id = jump_stakes_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_wins ON h.id = jump_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 1
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_stakes_wins ON h.id = jump_stakes_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_seconds ON h.id = jump_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 2
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_stakes_seconds ON h.id = jump_stakes_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_thirds ON h.id = jump_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 3
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_stakes_thirds ON h.id = jump_stakes_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_fourths ON h.id = jump_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                             LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
                    WHERE rr.finish_position = 4
                      AND r.race_type = 'stakes'
                      AND ts.surface = 'steeplechase'
                    GROUP BY rr.horse_id) AS jump_stakes_fourths ON h.id = jump_stakes_fourths.horse_id
