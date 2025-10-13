class MigrateLegacyRacesService # rubocop:disable Metrics/ClassLength
  class InvalidAgeError < StandardError; end

  class InvalidGradeError < StandardError; end

  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    Legacy::Race.find_each do |race|
      legacy_racetrack = Legacy::Racetrack.find_by!(ID: race.Location)

      track_surface = Racing::TrackSurface.joins(:racetrack).find_by(surface: legacy_racetrack.DTSC.downcase, racetracks: { name: legacy_racetrack.Name })
      race_schedule = Racing::RaceSchedule.find_or_initialize_by(day_number: race.DayNum, number: race.Number)
      race_age = case race.Age.to_i
      when 1 then "2"
      when 2 then "2+"
      when 3 then "3"
      when 4 then "3+"
      when 5 then "4"
      when 6 then "4+"
      else
        raise InvalidAgeError, "Invalid Age for race #{race.ID}"
      end
      race_grade = case race.Grade.to_i
      when 1 then "Ungraded"
      when 2 then "Grade 3"
      when 3 then "Grade 2"
      when 4 then "Grade 1"
      end
      race_type = case race.Type.to_i
      when 1 then "maiden"
      when 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 then "claiming"
      when 12 then "starter_allowance"
      when 13 then "nw1_allowance"
      when 14 then "nw2_allowance"
      when 15 then "nw3_allowance"
      when 16 then "allowance"
      when 17 then "stakes"
      end
      claiming_price = if race_type == "claiming"
        case race.Type.to_i
        when 3 then 5_000
        when 4 then 10_000
        when 5 then 15_000
        when 6 then 20_000
        when 7 then 25_000
        when 8 then 30_000
        when 9 then 35_000
        when 10 then 40_000
        when 11 then 50_000
        end
      end
      race_schedule.update!(
        day_number: race.DayNum,
        number: race.Num,
        date: Date.parse(race.Date.to_s) - 4.years,
        age: race_age,
        distance: race.Distance,
        female_only: race.Gender == "F",
        race_type:,
        grade: race_grade,
        name: race.Name.presence,
        purse: race.Purse,
        claiming_price:,
        track_surface:
      )
    end
  rescue => e
    Rails.logger.error "Info: #{e.message}"
    raise e
  end
end

