SELECT h.id AS horse_id,
       CASE
           (SELECT COUNT(*) FROM lifetime_race_records WHERE horse_id = h.id AND wins = 0)
           WHEN 1 then true
           ELSE false
           END maiden_qualified,
       CASE
           (SELECT count(r.id)
            FROM race_result_horses rr
                     LEFT JOIN race_results r ON r.id = rr.race_id
            WHERE rr.horse_id = h.id
              AND r.date > greatest(horse_sales.sale_date, h.date_of_birth))
           WHEN 3 then true
           ELSE false
           END claiming_qualified,
       CASE
           (SELECT COUNT(r.id)
            FROM race_result_horses rr
                     LEFT JOIN race_results r ON rr.race_id = r.id
            WHERE rr.horse_id = h.id
              AND r.date >= CURRENT_DATE - INTERVAL '1 year'
              AND r.race_type = 'claiming')
           WHEN 0 then false
           ELSE true
           END starter_allowance_qualified,
       CASE
           allowance_wins.wins
           WHEN 0 then true
           ELSE false
           END nw1_allowance_qualified,
       CASE
           allowance_wins.wins
           WHEN 0 then true
           WHEN 1 then true
           ELSE false
           END nw2_allowance_qualified,
       CASE
           allowance_wins.wins
           WHEN 0 then true
           WHEN 1 then true
           WHEN 2 then true
           ELSE false
           END nw3_allowance_qualified,
       CASE
           (SELECT COUNT(r.id)
            FROM race_result_horses rr
                     LEFT JOIN race_results r ON rr.race_id = r.id
            WHERE rr.horse_id = h.id
              AND rr.finish_position <= 3
              AND r.race_type = 'allowance')
           WHEN 0 then false
           ELSE true
           END allowance_placed,
       CASE
           (SELECT COUNT(r.id)
            FROM race_result_horses rr
                     LEFT JOIN race_results r ON rr.race_id = r.id
            WHERE rr.horse_id = h.id
              AND rr.finish_position <= 3
              AND r.race_type = 'stakes')
           WHEN 0 then false
           ELSE true
           END stakes_placed
FROM horses h
         LEFT JOIN (SELECT COUNT(r.id) AS wins, horse_id
                    FROM race_result_horses rr
                             LEFT JOIN race_results r ON rr.race_id = r.id
                    WHERE rr.finish_position = 1
                      AND r.race_type IN (
                                          'starter_allowance',
                                          'nw1_allowance',
                                          'nw2_allowance',
                                          'nw3_allowance',
                                          'allowance',
                                          'stakes'
                        )
                    GROUP BY rr.horse_id) AS allowance_wins ON h.id = allowance_wins.horse_id
         LEFT JOIN (SELECT MAX(date) AS sale_date, horse_id
                    FROM horse_sales hs
                    GROUP BY hs.horse_id) AS horse_sales ON h.id = horse_sales.horse_id
WHERE h.status = 'racehorse'
WITH DATA;
