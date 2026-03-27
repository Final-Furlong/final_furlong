SELECT rr.horse_id,
       rt.name,
       count(rr.id) AS starts,
       SUM(
               CASE
                   WHEN r.race_type = 'stakes' THEN 1
                   ELSE 0
                   END
       )            AS stakes_starts,
       SUM(
               CASE finish_position
                   WHEN 1 THEN 1
                   ELSE 0
                   END
       )            AS wins,
       SUM(
               CASE
                   WHEN r.race_type = 'stakes'
                       AND finish_position = 1 THEN 1
                   ELSE 0
                   END
       )            AS stakes_wins,
       SUM(
               CASE finish_position
                   WHEN 2 THEN 1
                   ELSE 0
                   END
       )            AS seconds,
       SUM(
               CASE
                   WHEN r.race_type = 'stakes'
                       AND finish_position = 2 THEN 1
                   ELSE 0
                   END
       )            AS stakes_seconds,
       SUM(
               CASE finish_position
                   WHEN 3 THEN 1
                   ELSE 0
                   END
       )            AS thirds,
       SUM(
               CASE
                   WHEN r.race_type = 'stakes'
                       AND finish_position = 3 THEN 1
                   ELSE 0
                   END
       )            AS stakes_thirds,
       SUM(
               CASE finish_position
                   WHEN 4 THEN 1
                   ELSE 0
                   END
       )            AS fourths,
       SUM(
               CASE
                   WHEN r.race_type = 'stakes'
                       AND finish_position = 4 THEN 1
                   ELSE 0
                   END
       )            AS stakes_fourths
FROM race_result_horses rr
         LEFT JOIN race_results r ON rr.race_id = r.id
         LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
         LEFT JOIN racetracks rt ON ts.racetrack_id = rt.id
GROUP BY rr.horse_id, rt.name;
