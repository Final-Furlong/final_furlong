class UpdateRaceResultHorseEarningsPointsJob < ApplicationJob
  queue_as :low_priority

  def perform
    Racing::RaceResultHorse.joins(:race)
      .where("(finish_position <= 5 AND earnings = 0) OR (finish_position <= 3 AND points = 0)")
      .merge(Racing::RaceResult.since_date("2004-01-01").not_types(["maiden", "claiming"]))
      .order(id: :asc)
      .limit(100).each do |rr_horse|
      race = rr_horse.race
      earnings = race.purse * Config::Racing.purses[rr_horse.finish_position - 1]
      points = if race.stakes?
        Config::Racing.points[:stakes][rr_horse.finish_position - 1]
      elsif race.allowance?
        Config::Racing.points[:allowance][rr_horse.finish_position - 1]
      end
      rr_horse.assign_attributes(earnings: earnings.to_i, points: points.to_i)
      rr_horse.save(validate: false)
    end
    remaining_count = Racing::RaceResultHorse.joins(:race)
      .where("(finish_position <= 5 AND earnings = 0) OR (finish_position <= 3 AND points = 0)")
      .merge(Racing::RaceResult.since_date("2004-01-01").not_types(["maiden", "claiming"])).count

    UpdateRaceResultHorseEarningsPointsJob.set(wait: 5.seconds).perform_later if remaining_count.positive?
  end
end

