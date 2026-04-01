class UpdateRaceResultHorseEarningsPointsJob < ApplicationJob
  queue_as :low_priority

  def perform
    Racing::RaceResultHorse.joins(:race)
      .where("(finish_position <= 3 AND earnings = 0) OR (finish_position <= 3 AND points = 0)")
      .merge(Racing::RaceResult.before_date("2004-01-01")).order(id: :asc).limit(100).each do |rr_horse|
      race = rr_horse.race
      earnings = case rr_horse.finish_position
      when 1
        race.purse * 0.5
      when 2
        race.purse * 0.4
      when 3
        race.purse * 0.1
      else
        0
      end
      points = if race.stakes?
        case rr_horse.finish_position
        when 1
          84
        when 2
          42
        when 3
          21
        when 4
          14
        end
      elsif race.allowance?
        case rr_horse.finish_position
        when 1
          21
        when 2
          14
        when 3
          7
        end
      else
        case rr_horse.finish_position
        when 1
          4
        when 2
          2
        when 3
          1
        end
      end
      rr_horse.assign_attributes(earnings: earnings.to_i, points: points.to_i)
      rr_horse.save(validate: false)
    end
    Racing::RaceResultHorse.joins(:race)
      .where("(finish_position <= 3 AND earnings = 0) OR (finish_position <= 4 AND points = 0)")
      .merge(Racing::RaceResult.before_date("2004-01-01").by_type("stakes")).order(id: :asc).limit(100).each do |rr_horse|
      race = rr_horse.race
      earnings = case rr_horse.finish_position
      when 1
        race.purse * 0.75
      when 2
        race.purse * 0.2
      when 3
        race.purse * 0.05
      else
        0
      end
      points = if race.stakes?
        case rr_horse.finish_position
        when 1
          84
        when 2
          42
        when 3
          21
        when 4
          14
        end
      elsif race.allowance?
        case rr_horse.finish_position
        when 1
          21
        when 2
          14
        when 3
          7
        end
      else
        case rr_horse.finish_position
        when 1
          4
        when 2
          2
        when 3
          1
        end
      end
      rr_horse.assign_attributes(earnings: earnings.to_i, points: points.to_i)
      rr_horse.save(validate: false)
    end
    Racing::RaceResultHorse.joins(:race)
      .where("(finish_position <= 5 AND earnings = 0) OR (finish_position <= 3 AND points = 0)")
      .merge(Racing::RaceResult.since_date("2004-01-01")).order(id: :asc).limit(100).each do |rr_horse|
      race = rr_horse.race
      earnings = race.purse * Config::Racing.purses[rr_horse.finish_position - 1]
      points = if race.stakes?
        Config::Racing.points[:stakes][rr_horse.finish_position - 1]
      elsif race.allowance?
        Config::Racing.points[:allowance][rr_horse.finish_position - 1]
      elsif race.claiming?
        Config::Racing.points[:claiming][rr_horse.finish_position - 1]
      elsif race.maiden?
        Config::Racing.points[:maiden][rr_horse.finish_position - 1]
      end
      rr_horse.assign_attributes(earnings: earnings.to_i, points: points.to_i)
      rr_horse.save(validate: false)
    end
    Racing::RaceResultHorse.joins(:race)
      .where("(finish_position <= 5 AND earnings = 0) OR (finish_position <= 4 AND points = 0)")
      .merge(Racing::RaceResult.since_date("2004-01-01").by_type("stakes")).order(id: :asc).limit(100).each do |rr_horse|
      race = rr_horse.race
      earnings = race.purse * Config::Racing.purses[rr_horse.finish_position - 1]
      points = if race.stakes?
        Config::Racing.points[:stakes][rr_horse.finish_position - 1]
      elsif race.allowance?
        Config::Racing.points[:allowance][rr_horse.finish_position - 1]
      elsif race.claiming?
        Config::Racing.points[:claiming][rr_horse.finish_position - 1]
      elsif race.maiden?
        Config::Racing.points[:maiden][rr_horse.finish_position - 1]
      end
      rr_horse.assign_attributes(earnings: earnings.to_i, points: points.to_i)
      rr_horse.save(validate: false)
    end
    remaining_count = Racing::RaceResultHorse.joins(:race)
      .where("(finish_position <= 3 AND earnings = 0) OR (finish_position <= 3 AND points = 0)")
      .merge(Racing::RaceResult.before_date("2004-01-01")).count
    if remaining_count.zero?
      remaining_count += Racing::RaceResultHorse.joins(:race)
        .where("(finish_position <= 3 AND earnings = 0) OR (finish_position <= 4 AND points = 0)")
        .merge(Racing::RaceResult.before_date("2004-01-01").by_type("stakes")).count
    end
    if remaining_count.zero?
      remaining_count += Racing::RaceResultHorse.joins(:race)
        .where("(finish_position <= 5 AND earnings = 0) OR (finish_position <= 3 AND points = 0)")
        .merge(Racing::RaceResult.since_date("2004-01-01")).count
    end
    if remaining_count.zero?
      remaining_count += Racing::RaceResultHorse.joins(:race)
        .where("(finish_position <= 5 AND earnings = 0) OR (finish_position <= 4 AND points = 0)")
        .merge(Racing::RaceResult.since_date("2004-01-01").by_type("stakes")).count
    end
    UpdateRaceResultHorseEarningsPointsJob.set(wait: 5.seconds).perform_later if remaining_count.positive?
  end
end

