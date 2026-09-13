class Game::EclipseAwards::ContenderSelectionJob < ApplicationJob
  queue_as :latency_5m

  retry_on ActiveRecord::RecordInvalid

  def perform(category:, year: Date.current.year - 1)
    records = pick_winners(category:, year:)
    existing_contenders = Game::EclipseAwardContender.where(category:, year:).count
    voting_ends_at = (Time.current + Config::Game.eclipse_award_voting_days.days).end_of_day
    contenders = 0
    records.each do |record|
      break if contenders >= 10

      type = %w[stable breeder].include?(category) ? "Account::Stable" : "Horses::Horse"
      contender = Game::EclipseAwardContender.find_or_initialize_by(awardable_type: type, awardable_id: record[:id], category:, year:)
      contender.record = record[:record]
      contender.voting_starts_at = Time.current
      contender.voting_ends_at = voting_ends_at
      contender.save
      contenders += 1
    end
    current_contenders = Game::EclipseAwardContender.where(category:, year:).count
    send_notifications(category:, year:, end_time: voting_ends_at) if current_contenders > existing_contenders
    store_job_info(outcome: { year:, contenders: records.count })
  end

  private

  def send_notifications(category:, year:, end_time:)
    category_name = I18n.t("eclipse_awards.award.category_#{category}")
    Account::User.active.find_each do |user|
      Game::NotificationCreator.new.create_notification(
        type: ::EclipseAwardVotingNotification,
        user:,
        params: { category:, category_name:, year:, deadline: end_time }
      )
    end
  end

  def pick_winners(category:, year:)
    case category.downcase
    when "sprinter"
      pick_top_sprinter(year:)
    when "classic"
      pick_top_classic(year:)
    when "endurance"
      pick_top_endurance(year:)
    when "turf_horse", "turf_mare"
      pick_top_turf(year:, gender: category.split("_").last)
    when "sc_colt", "sc_filly"
      pick_top_jumper(year:, gender: category.split("_").last, age: 3)
    when "sc_horse", "sc_mare"
      pick_top_jumper(year:, gender: category.split("_").last, age: 4)
    when "stable"
      pick_top_stable(year:)
    when "breeder"
      pick_top_breeder(year:)
    when "sire"
      pick_top_sire(year:)
    else
      pick_top_age(year:, age: category.split("_").first, gender: category.split("_").last)
    end
  end

  def pick_top_age(year:, age:, gender:)
    # 2yo_colt 2yo_filly 3yo_colt 3yo_filly older_horse older_mare
    query = Racing::AnnualRaceRecord.where(year:).joins(:horse).where(stakes_wins: 2..)
    query = if age != "older"
      query.where(horse: Horses::Horse.with_yob(year - age.to_i))
    else
      query.where(horse: Horses::Horse.max_yob(year - 4))
    end
    query = if %w[filly mare].exclude?(gender)
      query.where(horse: Horses::Horse.not_female)
    else
      query.where(horse: Horses::Horse.female)
    end
    query.order(stakes_wins: :desc, stakes_starts: :desc, points: :desc).order("RANDOM()").limit(10)
    results = []
    query.each do |record|
      results << { id: record.horse_id, record: record.overall_string }
    end
    results
  end

  def pick_top_sprinter(year:)
    horses = distance_sql(year:, flat_max: 7.5, jump_max: 12.0)
    results = []
    horses.each do |horse|
      results << { id: horse["horse_id"], record: record_string(horse) }
    end
    results
  end

  def distance_sql(year:, flat_min: 0.0, flat_max: 100.0, jump_min: 0.0, jump_max: 100.0)
    ActiveRecord::Base.connection.execute(
      <<~SQL.squish
          SELECT horse_id, COUNT(rr.id) AS starts,
          SUM(
            CASE
              WHEN r.race_type = 'stakes' THEN 1
              ELSE 0
            END
          ) AS stakes_starts,
          SUM(
            CASE
              WHEN rr.finish_position = 1 THEN 1
              ELSE 0
            END
          ) AS wins,
          SUM(
            CASE
              WHEN r.race_type = 'stakes'
              AND rr.finish_position = 1 THEN 1
              ELSE 0
            END
          ) AS stakes_wins,
          SUM(
            CASE
              WHEN rr.finish_position = 2 THEN 1
              ELSE 0
            END
          ) AS seconds,
          SUM(
            CASE
              WHEN r.race_type = 'stakes'
              AND rr.finish_position = 2 THEN 1
              ELSE 0
            END
          ) AS stakes_seconds,
          SUM(
            CASE
              WHEN rr.finish_position = 3 THEN 1
              ELSE 0
            END
          ) AS thirds,
          SUM(
            CASE
              WHEN r.race_type = 'stakes'
              AND rr.finish_position = 3 THEN 1
              ELSE 0
            END
          ) AS stakes_thirds,
          SUM(
            CASE
              WHEN rr.finish_position = 4 THEN 1
              ELSE 0
            END
          ) AS fourths,
          SUM(
            CASE
              WHEN r.race_type = 'stakes'
              AND rr.finish_position = 4 THEN 1
              ELSE 0
            END
          ) AS stakes_fourths,
          SUM(earnings) AS earnings,
          SUM(points) AS points
        FROM
          race_result_horses rr
          LEFT JOIN race_results r ON rr.race_id = r.id
          LEFT JOIN track_surfaces ts ON r.surface_id = ts.id
        WHERE
          DATE_PART('Year', r.date) = '#{year}'
          AND ((r.distance >= '#{flat_min}'::float AND r.distance <= '#{flat_max}'::float AND ts.surface != 'steeplechase') OR
            (r.distance >= '#{jump_min}'::float AND r.distance <= '#{jump_max}'::float AND ts.surface = 'steeplechase'))
        GROUP BY
          rr.horse_id
        ORDER BY
          SUM(
            CASE
              WHEN r.race_type = 'stakes'
              AND rr.finish_position = 1 THEN 1
              ELSE 0
            END
          ) DESC,
          SUM(
            CASE
              WHEN r.race_type = 'stakes' THEN 1
              ELSE 0
            END
          ) DESC,
          SUM(points) DESC,
          RANDOM()
          LIMIT 10
      SQL
    )
  end

  def pick_top_classic(year:)
    horses = distance_sql(year:, flat_min: 8.0, flat_max: 10.0, jump_min: 12.5, jump_max: 18.0)
    results = []
    horses.each do |horse|
      results << { id: horse["horse_id"], record: record_string(horse) }
    end
    results
  end

  def pick_top_endurance(year:)
    horses = distance_sql(year:, flat_min: 10.5, jump_min: 18.5)
    results = []
    horses.each do |horse|
      results << { id: horse["horse_id"], record: record_string(horse) }
    end
    results
  end

  def pick_top_turf(year:, gender:)
    query = Racing::RaceRecord.where(year:, surface: "turf").joins(:horse).where(stakes_wins: 2..)
    query = if gender != "mare"
      query.where(horse: Horses::Horse.not_female)
    else
      query.where(horse: Horses::Horse.female)
    end
    query.order(stakes_wins: :desc, stakes_starts: :desc, points: :desc).order("RANDOM()").limit(10)
    results = []
    query.each do |record|
      results << { id: record.horse_id, record: record.overall_string }
    end
    results
  end

  def pick_top_jumper(year:, gender:)
    query = Racing::RaceRecord.where(year:, surface: "steeplechase").joins(:horse).where(stakes_wins: 2..)
    query = if %w[filly mare].exclude?(gender)
      query.where(horse: Horses::Horse.not_female)
    else
      query.where(horse: Horses::Horse.female)
    end
    query = if %w[colt filly].exclude?(gender)
      query.where(horse: Horses::Horse.max_yob(year - 4))
    else
      query.where(horse: Horses::Horse.with_yob(year - 3))
    end
    query.order(stakes_wins: :desc, stakes_starts: :desc, points: :desc).order("RANDOM()").limit(10)
    results = []
    query.each do |record|
      results << { id: record.horse_id, record: record.overall_string }
    end
    results
  end

  def pick_top_stable(year:)
    query = Racing::StableAnnualRaceRecord.where(year:).joins(:stable).where(stakes_wins: 10..).where.not(stable: { name: Config::Game.stable })
    query.order(stakes_wins: :desc, stakes_starts: :desc, points: :desc).order("RANDOM()").limit(10)
    results = []
    query.each do |record|
      results << { id: record.stable_id, record: record.overall_string }
    end
    results
  end

  def pick_top_breeder(year:)
    records = ActiveRecord::Base.connection.execute(
      <<~SQL.squish
        SELECT b.id, b.name, COUNT(rr.id) AS starts,
                  SUM(
                    CASE
                      WHEN r.race_type = 'stakes' THEN 1
                      ELSE 0
                    END
                  ) AS stakes_starts,
                  SUM(
                    CASE
                      WHEN rr.finish_position = 1 THEN 1
                      ELSE 0
                    END
                  ) AS wins,
                  SUM(
                    CASE
                      WHEN r.race_type = 'stakes'
                      AND rr.finish_position = 1 THEN 1
                      ELSE 0
                    END
                  ) AS stakes_wins,
                  SUM(
                    CASE
                      WHEN rr.finish_position = 2 THEN 1
                      ELSE 0
                    END
                  ) AS seconds,
                  SUM(
                    CASE
                      WHEN r.race_type = 'stakes'
                      AND rr.finish_position = 2 THEN 1
                      ELSE 0
                    END
                  ) AS stakes_seconds,
                  SUM(
                    CASE
                      WHEN rr.finish_position = 3 THEN 1
                      ELSE 0
                    END
                  ) AS thirds,
                  SUM(
                    CASE
                      WHEN r.race_type = 'stakes'
                      AND rr.finish_position = 3 THEN 1
                      ELSE 0
                    END
                  ) AS stakes_thirds,
                  SUM(
                    CASE
                      WHEN rr.finish_position = 4 THEN 1
                      ELSE 0
                    END
                  ) AS fourths,
                  SUM(
                    CASE
                      WHEN r.race_type = 'stakes'
                      AND rr.finish_position = 4 THEN 1
                      ELSE 0
                    END
                  ) AS stakes_fourths,
                  SUM(earnings) AS earnings,
                  SUM(points) AS points
                FROM
                  race_result_horses rr
                  LEFT JOIN race_results r ON rr.race_id = r.id
                  LEFT JOIN horses h ON rr.horse_id = h.id
                  LEFT JOIN stables b ON h.breeder_id = b.id
                WHERE
                  DATE_PART('Year', r.date) = '#{year}' AND b.name != 'Final Furlong'
                GROUP BY
                  b.id
                ORDER BY
                  SUM(
                    CASE
                      WHEN r.race_type = 'stakes'
                      AND rr.finish_position = 1 THEN 1
                      ELSE 0
                    END
                  ) DESC,
                  SUM(points) DESC,
          SUM(earnings) DESC,
                  RANDOM()
                  LIMIT 10
      SQL
    )
    results = []
    records.each do |record|
      results << { id: record["id"], record: pick_top_bred(year:, breeder_id: record["id"]) }
    end
    results
  end

  def pick_top_bred(year:, breeder_id:)
    records = ActiveRecord::Base.connection.execute(
      <<~SQL.squish
        SELECT h.id, h.name
                      FROM
                        race_result_horses rr
                        LEFT JOIN race_results r ON rr.race_id = r.id
                        LEFT JOIN horses h ON rr.horse_id = h.id
                      WHERE
                        DATE_PART('Year', r.date) = '#{year}' AND h.breeder_id = '#{breeder_id}'::bigint
                      GROUP BY
                        h.id
                      ORDER BY
                        SUM(
                          CASE
                            WHEN r.race_type = 'stakes'
                            AND rr.finish_position = 1 THEN 1
                            ELSE 0
                          END
                        ) DESC,
          SUM(earnings) DESC,
                        SUM(points) DESC
                        LIMIT 5
      SQL
    )
    results = []
    records.each do |record|
      results << record["id"]
    end
    results.join(",")
  end

  def pick_top_sire(year:)
    records = ActiveRecord::Base.connection.execute(
      <<~SQL.squish
        SELECT s.id, s.name, COUNT(rr.id) AS starts,
                  SUM(
                    CASE
                      WHEN r.race_type = 'stakes' THEN 1
                      ELSE 0
                    END
                  ) AS stakes_starts,
                  SUM(
                    CASE
                      WHEN rr.finish_position = 1 THEN 1
                      ELSE 0
                    END
                  ) AS wins,
                  SUM(
                    CASE
                      WHEN r.race_type = 'stakes'
                      AND rr.finish_position = 1 THEN 1
                      ELSE 0
                    END
                  ) AS stakes_wins,
                  SUM(
                    CASE
                      WHEN rr.finish_position = 2 THEN 1
                      ELSE 0
                    END
                  ) AS seconds,
                  SUM(
                    CASE
                      WHEN r.race_type = 'stakes'
                      AND rr.finish_position = 2 THEN 1
                      ELSE 0
                    END
                  ) AS stakes_seconds,
                  SUM(
                    CASE
                      WHEN rr.finish_position = 3 THEN 1
                      ELSE 0
                    END
                  ) AS thirds,
                  SUM(
                    CASE
                      WHEN r.race_type = 'stakes'
                      AND rr.finish_position = 3 THEN 1
                      ELSE 0
                    END
                  ) AS stakes_thirds,
                  SUM(
                    CASE
                      WHEN rr.finish_position = 4 THEN 1
                      ELSE 0
                    END
                  ) AS fourths,
                  SUM(
                    CASE
                      WHEN r.race_type = 'stakes'
                      AND rr.finish_position = 4 THEN 1
                      ELSE 0
                    END
                  ) AS stakes_fourths,
                  SUM(earnings) AS earnings,
                  SUM(points) AS points
                FROM
                  race_result_horses rr
                  LEFT JOIN race_results r ON rr.race_id = r.id
                  LEFT JOIN horses h ON rr.horse_id = h.id
                  LEFT JOIN horses s ON h.sire_id = s.id
                WHERE
                  DATE_PART('Year', r.date) = '#{year}'
                GROUP BY
                  s.id
                ORDER BY
                  SUM(
                    CASE
                      WHEN r.race_type = 'stakes'
                      AND rr.finish_position = 1 THEN 1
                      ELSE 0
                    END
                  ) DESC,
                  SUM(points) DESC,
          SUM(earnings) DESC,
                  RANDOM()
                  LIMIT 10
      SQL
    )
    results = []
    records.each do |record|
      results << { id: record["id"], record: pick_top_sired(year:, sire_id: record["id"]) }
    end
    results
  end

  def pick_top_sired(year:, sire_id:)
    records = ActiveRecord::Base.connection.execute(
      <<~SQL.squish
        SELECT h.id, h.name
                      FROM
                        race_result_horses rr
                        LEFT JOIN race_results r ON rr.race_id = r.id
                        LEFT JOIN horses h ON rr.horse_id = h.id
                      WHERE
                        DATE_PART('Year', r.date) = '#{year}' AND h.sire_id = '#{sire_id}'::bigint
                      GROUP BY
                        h.id
                      ORDER BY
                        SUM(
                          CASE
                            WHEN r.race_type = 'stakes'
                            AND rr.finish_position = 1 THEN 1
                            ELSE 0
                          END
                        ) DESC,
          SUM(earnings) DESC,
                        SUM(points) DESC
                        LIMIT 5
      SQL
    )
    results = []
    records.each do |record|
      results << record["id"]
    end
    results.join(",")
  end

  def record_string(hash)
    races = [
      stakes_string(hash["starts"], hash["stakes_starts"]),
      stakes_string(hash["wins"], hash["stakes_wins"]),
      stakes_string(hash["seconds"], hash["stakes_seconds"]),
      stakes_string(hash["thirds"], hash["stakes_thirds"]),
      stakes_string(hash["fourths"], hash["stakes_fourths"])
    ].join("-")
    earnings = Game::MoneyFormatter.new(hash["earnings"].to_i)
    points = "#{number_to_delimited(hash["points"])}pts"
    [races, earnings, points].join(" - ")
  end

  def stakes_string(basic, stakes)
    value = number_to_delimited(basic)
    value += "(#{number_to_delimited(stakes)})" if stakes.positive?
    value
  end

  def number_to_delimited(value)
    ActiveSupport::NumberHelper.number_to_delimited(value)
  end
end

