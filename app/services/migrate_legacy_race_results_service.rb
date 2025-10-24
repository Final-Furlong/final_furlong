class MigrateLegacyRaceResultsService # rubocop:disable Metrics/ClassLength
  class InvalidAgeError < StandardError; end

  class InvalidGradeError < StandardError; end

  # rubocop:disable Rails/Output
  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    if Racing::RaceResult.count.positive?
      last_migrated = Racing::RaceResult.order(date: :desc, number: :desc).first
      min_date = (last_migrated.number == 50) ? last_migrated.date + 1.day : last_migrated.date
      min_number = (last_migrated.number == 50) ? 0 : last_migrated.number + 1
    else
      min_date = 50.years.ago
      min_number = 0
    end
    next_result = Legacy::RaceResult.where(Date: min_date..).where(Num: min_number..).order(Date: :asc, Num: :asc).pick(:ID)
    Legacy::RaceResult.where(ID: next_result..).limit(1000).find_each(cursor: [:Date, :Num], order: [:asc, :asc]) do |legacy_race|
      puts "Legacy Race: #{legacy_race.Date} ##{legacy_race.Num}"
      legacy_racetrack = Legacy::Racetrack.find_by!(ID: legacy_race.Location)

      track_surface = Racing::TrackSurface.joins(:racetrack).find_by(surface: legacy_racetrack.DTSC.downcase, racetracks: { name: legacy_racetrack.Name })
      race_date = Date.parse(legacy_race.Date.to_s) - 4.years
      race_result = Racing::RaceResult.find_or_initialize_by(date: race_date, number: legacy_race.Num)
      race_age = case legacy_race.Age.to_i
      when 1 then "2"
      when 2 then "2+"
      when 3 then "3"
      when 4 then "3+"
      when 5 then "4"
      when 6 then "4+"
      else
        raise InvalidAgeError, "Invalid Age for race #{race.ID}"
      end
      race_grade = case legacy_race.Grade.to_i
      when 1 then "Ungraded"
      when 2 then "Grade 3"
      when 3 then "Grade 2"
      when 4 then "Grade 1"
      end
      race_type = case legacy_race.Type.to_i
      when 1 then "maiden"
      when 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 then "claiming"
      when 12 then "starter_allowance"
      when 13 then "nw1_allowance"
      when 14 then "nw2_allowance"
      when 15 then "nw3_allowance"
      when 16 then "allowance"
      when 17 then "stakes"
      end
      race_condition = case legacy_race.Condition.to_i
      when 1 then "fast"
      when 3 then "good"
      when 5 then "wet"
      when 7 then "slow"
      end
      claiming_price = if race_type == "claiming"
        case legacy_race.Type.to_i
        when 3 then 5_000
        when 4 then 10_000
        when 5 then 15_000
        when 6 then 20_000
        when 7 then 25_000
        when 8 then 30_000
        when 9 then 35_000
        when 10 then 40_000
        when 11 then 50_000
        else 5_000
        end
      end
      finish_time_splits = legacy_race.Time.to_s.split(":")
      finish_time = if finish_time_splits.count == 3
        finish_time_splits.first.to_i * 60 + finish_time_splits[1].to_i + finish_time_splits[2].to_i.fdiv(1000)
      elsif finish_time_splits.count.positive?
        finish_time_seconds = finish_time_splits[1].split(".")
        finish_time_splits.first.to_i * 60 + finish_time_seconds[0].to_i + finish_time_seconds[1].to_i.fdiv(1000)
      else
        0
      end
      finish_time = legacy_race.Distance * rand(10, 20) if finish_time.zero?
      ActiveRecord::Base.transaction do
        attrs = {
          date: race_date,
          number: legacy_race.Num,
          age: race_age,
          distance: legacy_race.Distance,
          male_only: breeders_stakes_races.include?(legacy_race.Name),
          female_only: legacy_race.Gender == "F",
          race_type:,
          grade: race_grade,
          name: legacy_race.RaceName.presence,
          purse: legacy_race.Purse,
          claiming_price:,
          track_surface:,
          condition: race_condition,
          split: legacy_race.SplitType,
          time_in_seconds: finish_time,
          created_at: race_date.beginning_of_day
        }
        puts "Race Result: #{attrs.inspect}"
        race_result.update!(attrs)

        Legacy::RaceResultHorse.where(RaceID: legacy_race.ID).find_each do |legacy_horse|
          race_horse = Racing::RaceResultHorse.find_or_initialize_by(race: race_result, legacy_horse_id: legacy_horse.Horse)
          horse = Horses::Horse.find_by(legacy_id: legacy_horse.Horse)
          attrs = {
            horse:,
            post_parade: legacy_horse.PP,
            positions: legacy_horse.RL,
            margins: legacy_horse.MarL,
            speed_factor: legacy_horse.SF,
            finish_position: legacy_horse.Pos,
            weight: legacy_horse.Weight || 0,
            created_at: race_date.beginning_of_day
          }
          attrs[:fractions] = legacy_horse.Fractions if legacy_horse.Fractions.present?
          attrs[:jockey] = Racing::Jockey.find_by(legacy_id: legacy_horse.Jockey)
          if legacy_horse.Odd
            legacy_odd = Legacy::Odd.find(legacy_horse.Odd)
            attrs[:odd] = Racing::Odd.find_by(display: legacy_odd.Odds)
          end
          if legacy_horse.Equipment.present?
            equipment = Legacy::Equipment.find(legacy_horse.Equipment)&.Equipment.to_s.split(" ")
            attrs[:blinkers] = equipment.include?("B")
            attrs[:shadow_roll] = equipment.include?("SR")
            attrs[:figure_8] = equipment.include?("F8")
            attrs[:wraps] = equipment.include?("W")
            attrs[:no_whip] = equipment.include?("NW")
          end
          puts "Horse #{legacy_horse.Horse}: #{attrs.inspect}"
          race_horse.update!(attrs)
        end
      end
    end
  rescue => e
    Rails.logger.error "Info: #{e.message}"
    raise e
  end

  private

  def breeders_stakes_races
    [
      "Moonover Boy Breeders' Stakes",
      "Rainbow Quest Breeders' Stakes",
      "Cross Roads Breeders' Stakes",
      "Crimson Lad Breeders' Stakes",
      "Lucky Cigar Breeders' Stakes",
      "Secretariat Breeders' Stakes",
      "Valid Wager Breeders' Stakes",
      "Highland Rogue Breeders' Stakes",
      "Planet Hollywood Breeders' Stakes",
      "What's It Worth Breeders' Stakes",
      "Lonesome Glory Breeders' Stakes",
      "Seabiscuit Breeders' Stakes",
      "Bold Ruler Breeders' Stakes",
      "A.P. Indy Breeders' Stakes",
      "Townsend Prince Breeders' Stakes",
      "Highland Bandit Breeders' Stakes",
      "Spectacular Bid Breeders' Stakes",
      "The Black Breeders' Stakes",
      "Man O'War Breeders' Stakes",
      "Cigar Breeders' Stakes",
      "Omaha Breeders' Stakes"
    ]
  end

  # rubocop:enable Rails/Output
end

