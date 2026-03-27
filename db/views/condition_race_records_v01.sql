SELECT h.id                                     AS horse_id,
       COALESCE(fast_starts.starts, 0)          AS fast_starts,
       COALESCE(fast_stakes_starts.starts, 0)   AS fast_stakes_starts,
       COALESCE(fast_wins.wins, 0)              AS fast_wins,
       COALESCE(fast_stakes_wins.wins, 0)       AS fast_stakes_wins,
       COALESCE(fast_seconds.seconds, 0)        AS fast_seconds,
       COALESCE(fast_stakes_seconds.seconds, 0) AS fast_stakes_seconds,
       COALESCE(fast_thirds.thirds, 0)          AS fast_thirds,
       COALESCE(fast_stakes_thirds.thirds, 0)   AS fast_stakes_thirds,
       COALESCE(fast_fourths.fourths, 0)        AS fast_fourths,
       COALESCE(fast_stakes_fourths.fourths, 0) AS fast_stakes_fourths,
       COALESCE(good_starts.starts, 0)          AS good_starts,
       COALESCE(good_stakes_starts.starts, 0)   AS good_stakes_starts,
       COALESCE(good_wins.wins, 0)              AS good_wins,
       COALESCE(good_stakes_wins.wins, 0)       AS good_stakes_wins,
       COALESCE(good_seconds.seconds, 0)        AS good_seconds,
       COALESCE(good_stakes_seconds.seconds, 0) AS good_stakes_seconds,
       COALESCE(good_thirds.thirds, 0)          AS good_thirds,
       COALESCE(good_stakes_thirds.thirds, 0)   AS good_stakes_thirds,
       COALESCE(good_fourths.fourths, 0)        AS good_fourths,
       COALESCE(good_stakes_fourths.fourths, 0) AS good_stakes_fourths,
       COALESCE(wet_starts.starts, 0)           AS wet_starts,
       COALESCE(wet_stakes_starts.starts, 0)    AS wet_stakes_starts,
       COALESCE(wet_wins.wins, 0)               AS wet_wins,
       COALESCE(wet_stakes_wins.wins, 0)        AS wet_stakes_wins,
       COALESCE(wet_seconds.seconds, 0)         AS wet_seconds,
       COALESCE(wet_stakes_seconds.seconds, 0)  AS wet_stakes_seconds,
       COALESCE(wet_thirds.thirds, 0)           AS wet_thirds,
       COALESCE(wet_stakes_thirds.thirds, 0)    AS wet_stakes_thirds,
       COALESCE(wet_fourths.fourths, 0)         AS wet_fourths,
       COALESCE(wet_stakes_fourths.fourths, 0)  AS wet_stakes_fourths,
       COALESCE(slow_starts.starts, 0)          AS slow_starts,
       COALESCE(slow_stakes_starts.starts, 0)   AS slow_stakes_starts,
       COALESCE(slow_wins.wins, 0)              AS slow_wins,
       COALESCE(slow_stakes_wins.wins, 0)       AS slow_stakes_wins,
       COALESCE(slow_seconds.seconds, 0)        AS slow_seconds,
       COALESCE(slow_stakes_seconds.seconds, 0) AS slow_stakes_seconds,
       COALESCE(slow_thirds.thirds, 0)          AS slow_thirds,
       COALESCE(slow_stakes_thirds.thirds, 0)   AS slow_stakes_thirds,
       COALESCE(slow_fourths.fourths, 0)        AS slow_fourths,
       COALESCE(slow_stakes_fourths.fourths, 0) AS slow_stakes_fourths
FROM horses h
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE r.condition = 'fast'
                    GROUP BY rr.horse_id) AS fast_starts ON h.id = fast_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE r.race_type = 'stakes'
                      AND r.condition = 'fast'
                    GROUP BY rr.horse_id) AS fast_stakes_starts ON h.id = fast_stakes_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.condition = 'fast'
                    GROUP BY rr.horse_id) AS fast_wins ON h.id = fast_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.race_type = 'stakes'
                      AND r.condition = 'fast'
                    GROUP BY rr.horse_id) AS fast_stakes_wins ON h.id = fast_stakes_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 2
                      AND r.condition = 'fast'
                    GROUP BY rr.horse_id) AS fast_seconds ON h.id = fast_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 2
                      AND r.race_type = 'stakes'
                      AND r.condition = 'fast'
                    GROUP BY rr.horse_id) AS fast_stakes_seconds ON h.id = fast_stakes_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 3
                      AND r.condition = 'fast'
                    GROUP BY rr.horse_id) AS fast_thirds ON h.id = fast_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 3
                      AND r.race_type = 'stakes'
                      AND r.condition = 'fast'
                    GROUP BY rr.horse_id) AS fast_stakes_thirds ON h.id = fast_stakes_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 4
                      AND r.condition = 'fast'
                    GROUP BY rr.horse_id) AS fast_fourths ON h.id = fast_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 4
                      AND r.race_type = 'stakes'
                      AND r.condition = 'fast'
                    GROUP BY rr.horse_id) AS fast_stakes_fourths ON h.id = fast_stakes_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE r.condition = 'good'
                    GROUP BY rr.horse_id) AS good_starts ON h.id = good_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE r.race_type = 'stakes'
                      AND r.condition = 'good'
                    GROUP BY rr.horse_id) AS good_stakes_starts ON h.id = good_stakes_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.condition = 'good'
                    GROUP BY rr.horse_id) AS good_wins ON h.id = good_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.race_type = 'stakes'
                      AND r.condition = 'good'
                    GROUP BY rr.horse_id) AS good_stakes_wins ON h.id = good_stakes_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 2
                      AND r.condition = 'good'
                    GROUP BY rr.horse_id) AS good_seconds ON h.id = good_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 2
                      AND r.race_type = 'stakes'
                      AND r.condition = 'good'
                    GROUP BY rr.horse_id) AS good_stakes_seconds ON h.id = good_stakes_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 3
                      AND r.condition = 'good'
                    GROUP BY rr.horse_id) AS good_thirds ON h.id = good_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 3
                      AND r.race_type = 'stakes'
                      AND r.condition = 'good'
                    GROUP BY rr.horse_id) AS good_stakes_thirds ON h.id = good_stakes_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 4
                      AND r.condition = 'good'
                    GROUP BY rr.horse_id) AS good_fourths ON h.id = good_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 4
                      AND r.race_type = 'stakes'
                      AND r.condition = 'good'
                    GROUP BY rr.horse_id) AS good_stakes_fourths ON h.id = good_stakes_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE r.condition = 'wet'
                    GROUP BY rr.horse_id) AS wet_starts ON h.id = wet_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE r.race_type = 'stakes'
                      AND r.condition = 'wet'
                    GROUP BY rr.horse_id) AS wet_stakes_starts ON h.id = wet_stakes_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.condition = 'wet'
                    GROUP BY rr.horse_id) AS wet_wins ON h.id = wet_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.race_type = 'stakes'
                      AND r.condition = 'wet'
                    GROUP BY rr.horse_id) AS wet_stakes_wins ON h.id = wet_stakes_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 2
                      AND r.condition = 'wet'
                    GROUP BY rr.horse_id) AS wet_seconds ON h.id = wet_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 2
                      AND r.race_type = 'stakes'
                      AND r.condition = 'wet'
                    GROUP BY rr.horse_id) AS wet_stakes_seconds ON h.id = wet_stakes_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 3
                      AND r.condition = 'wet'
                    GROUP BY rr.horse_id) AS wet_thirds ON h.id = wet_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 3
                      AND r.race_type = 'stakes'
                      AND r.condition = 'wet'
                    GROUP BY rr.horse_id) AS wet_stakes_thirds ON h.id = wet_stakes_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 4
                      AND r.condition = 'wet'
                    GROUP BY rr.horse_id) AS wet_fourths ON h.id = wet_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 4
                      AND r.race_type = 'stakes'
                      AND r.condition = 'wet'
                    GROUP BY rr.horse_id) AS wet_stakes_fourths ON h.id = wet_stakes_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE r.condition = 'slow'
                    GROUP BY rr.horse_id) AS slow_starts ON h.id = slow_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE r.race_type = 'stakes'
                      AND r.condition = 'slow'
                    GROUP BY rr.horse_id) AS slow_stakes_starts ON h.id = slow_stakes_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.condition = 'slow'
                    GROUP BY rr.horse_id) AS slow_wins ON h.id = slow_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.race_type = 'stakes'
                      AND r.condition = 'slow'
                    GROUP BY rr.horse_id) AS slow_stakes_wins ON h.id = slow_stakes_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 2
                      AND r.condition = 'slow'
                    GROUP BY rr.horse_id) AS slow_seconds ON h.id = slow_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 2
                      AND r.race_type = 'stakes'
                      AND r.condition = 'slow'
                    GROUP BY rr.horse_id) AS slow_stakes_seconds ON h.id = slow_stakes_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 3
                      AND r.condition = 'slow'
                    GROUP BY rr.horse_id) AS slow_thirds ON h.id = slow_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 3
                      AND r.race_type = 'stakes'
                      AND r.condition = 'slow'
                    GROUP BY rr.horse_id) AS slow_stakes_thirds ON h.id = slow_stakes_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 4
                      AND r.condition = 'slow'
                    GROUP BY rr.horse_id) AS slow_fourths ON h.id = slow_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 4
                      AND r.race_type = 'stakes'
                      AND r.condition = 'slow'
                    GROUP BY rr.horse_id) AS slow_stakes_fourths ON h.id = slow_stakes_fourths.horse_id
