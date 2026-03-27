SELECT h.id                                   AS horse_id,
       COALESCE(maiden_starts.starts, 0)      AS maiden_starts,
       COALESCE(maiden_wins.wins, 0)          AS maiden_wins,
       COALESCE(maiden_seconds.seconds, 0)    AS maiden_seconds,
       COALESCE(maiden_thirds.thirds, 0)      AS maiden_thirds,
       COALESCE(maiden_fourths.fourths, 0)    AS maiden_fourths,
       COALESCE(claiming_starts.starts, 0)    AS claiming_starts,
       COALESCE(claiming_wins.wins, 0)        AS claiming_wins,
       COALESCE(claiming_seconds.seconds, 0)  AS claiming_seconds,
       COALESCE(claiming_thirds.thirds, 0)    AS claiming_thirds,
       COALESCE(claiming_fourths.fourths, 0)  AS claiming_fourths,
       COALESCE(allowance_starts.starts, 0)   AS allowance_starts,
       COALESCE(allowance_wins.wins, 0)       AS allowance_wins,
       COALESCE(allowance_seconds.seconds, 0) AS allowance_seconds,
       COALESCE(allowance_thirds.thirds, 0)   AS allowance_thirds,
       COALESCE(allowance_fourths.fourths, 0) AS allowance_fourths,
       COALESCE(ungraded_starts.starts, 0)    AS ungraded_starts,
       COALESCE(ungraded_wins.wins, 0)        AS ungraded_wins,
       COALESCE(ungraded_seconds.seconds, 0)  AS ungraded_seconds,
       COALESCE(ungraded_thirds.thirds, 0)    AS ungraded_thirds,
       COALESCE(ungraded_fourths.fourths, 0)  AS ungraded_fourths,
       COALESCE(grade_3_starts.starts, 0)     AS grade_3_starts,
       COALESCE(grade_3_wins.wins, 0)         AS grade_3_wins,
       COALESCE(grade_3_seconds.seconds, 0)   AS grade_3_seconds,
       COALESCE(grade_3_thirds.thirds, 0)     AS grade_3_thirds,
       COALESCE(grade_3_fourths.fourths, 0)   AS grade_3_fourths,
       COALESCE(grade_2_starts.starts, 0)     AS grade_2_starts,
       COALESCE(grade_2_wins.wins, 0)         AS grade_2_wins,
       COALESCE(grade_2_seconds.seconds, 0)   AS grade_2_seconds,
       COALESCE(grade_2_thirds.thirds, 0)     AS grade_2_thirds,
       COALESCE(grade_2_fourths.fourths, 0)   AS grade_2_fourths,
       COALESCE(grade_1_starts.starts, 0)     AS grade_1_starts,
       COALESCE(grade_1_wins.wins, 0)         AS grade_1_wins,
       COALESCE(grade_1_seconds.seconds, 0)   AS grade_1_seconds,
       COALESCE(grade_1_thirds.thirds, 0)     AS grade_1_thirds,
       COALESCE(grade_1_fourths.fourths, 0)   AS grade_1_fourths
FROM horses h
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE r.race_type = 'maiden'
                    GROUP BY rr.horse_id) AS maiden_starts ON h.id = maiden_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.race_type = 'maiden'
                    GROUP BY rr.horse_id) AS maiden_wins ON h.id = maiden_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 2
                      AND r.race_type = 'maiden'
                    GROUP BY rr.horse_id) AS maiden_seconds ON h.id = maiden_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 3
                      AND r.race_type = 'maiden'
                    GROUP BY rr.horse_id) AS maiden_thirds ON h.id = maiden_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 4
                      AND r.race_type = 'maiden'
                    GROUP BY rr.horse_id) AS maiden_fourths ON h.id = maiden_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE r.race_type = 'claiming'
                    GROUP BY rr.horse_id) AS claiming_starts ON h.id = claiming_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.race_type = 'claiming'
                    GROUP BY rr.horse_id) AS claiming_wins ON h.id = claiming_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 2
                      AND r.race_type = 'claiming'
                    GROUP BY rr.horse_id) AS claiming_seconds ON h.id = claiming_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 3
                      AND r.race_type = 'claiming'
                    GROUP BY rr.horse_id) AS claiming_thirds ON h.id = claiming_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 4
                      AND r.race_type = 'claiming'
                    GROUP BY rr.horse_id) AS claiming_fourths ON h.id = claiming_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE r.race_type IN
                          ('starter_allowance', 'nw1_allowance', 'nw2_allowance', 'nw3_allowance', 'allowance')
                    GROUP BY rr.horse_id) AS allowance_starts ON h.id = allowance_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.race_type IN ('starter_allowance',
                                          'nw1_allowance', 'nw2_allowance', 'nw3_allowance', 'allowance')
                    GROUP BY rr.horse_id) AS allowance_wins ON h.id = allowance_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 2
                      AND r.race_type IN ('starter_allowance',
                                          'nw1_allowance', 'nw2_allowance', 'nw3_allowance', 'allowance')
                    GROUP BY rr.horse_id) AS allowance_seconds ON h.id = allowance_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 3
                      AND r.race_type IN ('starter_allowance',
                                          'nw1_allowance', 'nw2_allowance', 'nw3_allowance', 'allowance')
                    GROUP BY rr.horse_id) AS allowance_thirds ON h.id = allowance_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 4
                      AND r.race_type IN ('starter_allowance',
                                          'nw1_allowance', 'nw2_allowance', 'nw3_allowance', 'allowance')
                    GROUP BY rr.horse_id) AS allowance_fourths ON h.id = allowance_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE r.race_type = 'stakes'
                      AND r.grade = 'Ungraded'
                    GROUP BY rr.horse_id) AS ungraded_starts ON h.id = ungraded_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Ungraded'
                    GROUP BY rr.horse_id) AS ungraded_wins ON h.id = ungraded_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 2
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Ungraded'
                    GROUP BY rr.horse_id) AS ungraded_seconds ON h.id = ungraded_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 3
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Ungraded'
                    GROUP BY rr.horse_id) AS ungraded_thirds ON h.id = ungraded_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 4
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Ungraded'
                    GROUP BY rr.horse_id) AS ungraded_fourths ON h.id = ungraded_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE r.race_type = 'stakes'
                      AND r.grade = 'Grade 3'
                    GROUP BY rr.horse_id) AS grade_3_starts ON h.id = grade_3_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Grade 3'
                    GROUP BY rr.horse_id) AS grade_3_wins ON h.id = grade_3_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 2
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Grade 3'
                    GROUP BY rr.horse_id) AS grade_3_seconds ON h.id = grade_3_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 3
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Grade 3'
                    GROUP BY rr.horse_id) AS grade_3_thirds ON h.id = grade_3_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 4
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Grade 3'
                    GROUP BY rr.horse_id) AS grade_3_fourths ON h.id = grade_3_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE r.race_type = 'stakes'
                      AND r.grade = 'Grade 2'
                    GROUP BY rr.horse_id) AS grade_2_starts ON h.id = grade_2_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Grade 2'
                    GROUP BY rr.horse_id) AS grade_2_wins ON h.id = grade_2_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 2
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Grade 2'
                    GROUP BY rr.horse_id) AS grade_2_seconds ON h.id = grade_2_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 3
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Grade 2'
                    GROUP BY rr.horse_id) AS grade_2_thirds ON h.id = grade_2_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 4
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Grade 2'
                    GROUP BY rr.horse_id) AS grade_2_fourths ON h.id = grade_2_fourths.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS starts,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE r.race_type = 'stakes'
                      AND r.grade = 'Grade 1'
                    GROUP BY rr.horse_id) AS grade_1_starts ON h.id = grade_1_starts.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS wins,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Grade 1'
                    GROUP BY rr.horse_id) AS grade_1_wins ON h.id = grade_1_wins.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS seconds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 2
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Grade 1'
                    GROUP BY rr.horse_id) AS grade_1_seconds ON h.id = grade_1_seconds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS thirds,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 3
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Grade 1'
                    GROUP BY rr.horse_id) AS grade_1_thirds ON h.id = grade_1_thirds.horse_id
         LEFT JOIN (SELECT COUNT(r.id) AS fourths,
                           horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 4
                      AND r.race_type = 'stakes'
                      AND r.grade = 'Grade 1'
                    GROUP BY rr.horse_id) AS grade_1_fourths ON h.id = grade_1_fourths.horse_id
