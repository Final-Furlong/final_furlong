class Racing::WeatherForecastJob < ApplicationJob
  queue_as :default

  def perform
    return if run_today?

    tracks = 0
    Racing::Racetrack.where.not(name: Config::Game.stable).find_each do |track|
      track.surfaces.each do |surface|
        ActiveRecord::Base.transaction do
          today_forecast = surface.weather_forecasts.by_date(Date.current).first
          if today_forecast
            surface.update(condition: today_forecast.condition)
            today_forecast.destroy
            extra_days = 0
          else
            extra_days = 1
          end

          (6 + extra_days).times do |n|
            days_out = n + extra_days

            forecast = surface.weather_forecasts.find_or_initialize_by(date: Date.current + days_out.days)
            if forecast.condition
              rain_percent = case forecast.condition.to_s.downcase
              when "fast"
                5
              when "good"
                15
              when "wet"
                50
              when "slow"
                75
              end
              rain_chance = rain_percent + rand(5..10) - 5
              rain_chance = rain_chance.clamp(0, 100)
              attrs = { rain_chance: }
            else
              season = pick_season
              random_chance = rand(1..100)
              season_info = Racing::TrackSeasonInfo.find_by(location: track.location, season:)
              rain_chance = if random_chance <= season_info.fast_chance
                condition = "fast"
                5
              elsif random_chance <= season_info.fast_chance + season_info.good_chance
                condition = "good"
                15
              elsif random_chance <= season_info.fast_chance + season_info.good_chance + season_info.wet_chance
                condition = "wet"
                50
              else
                condition = "slow"
                75
              end
              attrs = { rain_chance:, condition: }
            end
            forecast.update!(attrs)
          end
        end
      end
      tracks += 1
    end
    store_job_info(outcome: { tracks: })
  end

  private

  def pick_season
    return "winter" if Date.current.month < 3
    return "winter" if Date.current.month == 3 && Date.current.day < 21
    return "winter" if Date.current.month == 12 && Date.current.day > 21
    return "spring" if Date.current.month < 6
    return "spring" if Date.current.month == 6 && Date.current.day < 21
    return "summer" if Date.current.month < 9
    return "summer" if Date.current.month == 9 && Date.current.day < 21

    "fall"
  end
end

