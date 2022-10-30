class MigrateLegacyHorseAppearanceService
  attr_reader :legacy_horse, :locations

  def initialize(horse:, locations:)
    @legacy_horse = horse
    @locations = locations
  end

  def call
    return unless Horse.exists?(legacy_id: legacy_horse.id)

    # horse = horse.find(legacy_id: legacy_horse.id)
    # Horse.create!
  rescue StandardError => e
    Rails.logger.error "Info: #{legacy_horse.inspect}"
    raise e
  end

  private

    def find_sire
      return unless legacy_horse.sire

      Horse.where(legacy_id: legacy_horse.sire).pick(:id)
    end

    def find_dam
      return unless legacy_horse.dam

      Horse.where(legacy_id: legacy_horse.dam).pick(:id)
    end

    def find_location
      locations[legacy_horse.loc_bred]
    end

    def find_breeder
      return final_furlong unless legacy_horse.breeder

      Stable.where(legacy_id: legacy_horse.breeder).pick(:id) || final_furlong
    end

    def find_owner
      return final_furlong unless legacy_horse.owner

      Stable.where(legacy_id: legacy_horse.owner).pick(:id) || final_furlong
    end

    def final_furlong
      return @final_furlong if @final_furlong

      @final_furlong = Stable.where(name: "Final Furlong").pick(:id)
    end

    def pick_status # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
      case legacy_horse.status.to_i
      when 1
        Horse.statuses[:broodmare]
      when 2
        Horse.statuses[:deceased]
      when 3
        Horse.statuses[:racehorse]
      when 4
        Horse.statuses[:retired]
      when 5
        Horse.statuses[:retired_broodmare]
      when 6
        Horse.statuses[:retired_stud]
      when 7
        Horse.statuses[:stud]
      when 8
        Horse.statuses[:unborn]
      when 9
        Horse.statuses[:weanling]
      when 10
        Horse.statuses[:yearling]
      else
        raise StandardError, "Unexpected status: #{legacy_horse.status}"
      end
    end

    def pick_gender # rubocop:disable Metrics/MethodLength
      case legacy_horse.gender
      when "C"
        Horse.genders[:colt]
      when "F"
        Horse.genders[:filly]
      when "S"
        Horse.genders[:stallion]
      when "M"
        Horse.genders[:mare]
      when "G"
        Horse.genders[:gelding]
      else
        raise StandardError, "Unexpected gender: #{legacy_horse.gender}"
      end
    end

    def dead?
      return true if legacy_horse.status.to_i == 2
      return false unless legacy_horse.date_of_death

      legacy_horse.date_of_death >= legacy_horse.date_of_birth
    end

    def calculate_age
      max_date = if dead?
                   from_game_date(legacy_horse.date_of_death || legacy_horse.die)
                 else
                   Date.current
                 end

      max_date.year - from_game_date(legacy_horse.date_of_birth).year
    end

    def from_game_date(value)
      case value
      when Date
        value.from_game_date
      when DateTime
        value.from_game_time.to_date
      else
        Date.parse_safely(value)&.from_game_date
      end
    end
end

