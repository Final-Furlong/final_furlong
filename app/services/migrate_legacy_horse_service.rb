class MigrateLegacyHorseService # rubocop:disable Metrics/ClassLength
  attr_reader :legacy_horse

  def initialize(horse:)
    @legacy_horse = horse
  end

  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    return unless legacy_horse
    horse = Horses::Horse.find_or_initialize_by(legacy_id: legacy_horse.id)
    update_attrs = {
      age: calculate_age,
      date_of_death: dead? ? from_game_date(legacy_horse.DOD) : nil,
      gender: pick_gender,
      name: legacy_horse.name.presence,
      status: pick_status,
      owner_id: find_owner
    }
    unless horse.persisted?
      update_attrs.merge!(
        date_of_birth: from_game_date(legacy_horse.DOB),
        created_at: from_game_date(legacy_horse.DOB),
        legacy_id: legacy_horse.ID,
        location_bred_id: find_location,
        sire_id: find_sire,
        dam_id: find_dam,
        breeder_id: find_breeder
      )
    end

    horse.update!(update_attrs)
  rescue => e
    Rails.logger.error "Info: #{legacy_horse.inspect}"
    raise e
  end

  private

  def find_sire
    FinalFurlong::Benchmark.measure_execution_time("Find sire") do
      return unless legacy_horse.Sire

      Horses::Horse.where(legacy_id: legacy_horse.Sire).pick(:id)
    end
  end

  def find_dam
    FinalFurlong::Benchmark.measure_execution_time("Find dam") do
      return unless legacy_horse.Dam

      Horses::Horse.where(legacy_id: legacy_horse.Dam).pick(:id)
    end
  end

  def find_location
    FinalFurlong::Benchmark.measure_execution_time("Find location bred") do
      legacy_track = Legacy::Racetrack.find(legacy_horse.LocBred)
      Racing::Racetrack.where(name: legacy_track.Name).pick(:location_id)
    end
  end

  def find_breeder
    FinalFurlong::Benchmark.measure_execution_time("Find breeder") do
      return final_furlong unless legacy_horse.Breeder

      Account::Stable.where(legacy_id: legacy_horse.Breeder).pick(:id) || final_furlong
    end
  end

  def find_owner
    FinalFurlong::Benchmark.measure_execution_time("Find owner") do
      return final_furlong unless legacy_horse.Owner

      Account::Stable.where(legacy_id: legacy_horse.Owner).pick(:id) || final_furlong
    end
  end

  def final_furlong
    FinalFurlong::Benchmark.measure_execution_time("Find final furlong") do
      return @final_furlong if @final_furlong

      @final_furlong = Account::Stable.where(name: "Final Furlong").pick(:id)
    end
  end

  def pick_status # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
    FinalFurlong::Benchmark.measure_execution_time("Find status") do
      case legacy_horse.Status.to_i
      when 1
        Horses::Horse.statuses[:broodmare]
      when 2
        Horses::Horse.statuses[:deceased]
      when 3
        Horses::Horse.statuses[:racehorse]
      when 4
        Horses::Horse.statuses[:retired]
      when 5
        Horses::Horse.statuses[:retired_broodmare]
      when 6
        Horses::Horse.statuses[:retired_stud]
      when 7
        Horses::Horse.statuses[:stud]
      when 8
        Horses::Horse.statuses[:unborn]
      when 9
        Horses::Horse.statuses[:weanling]
      when 10
        Horses::Horse.statuses[:yearling]
      else
        raise StandardError, "Unexpected status: #{legacy_horse.status}"
      end
    end
  end

  def pick_gender # rubocop:disable Metrics/MethodLength
    FinalFurlong::Benchmark.measure_execution_time("Find gender") do
      case legacy_horse.Gender
      when "C"
        Horses::Horse.genders[:colt]
      when "F"
        Horses::Horse.genders[:filly]
      when "S"
        Horses::Horse.genders[:stallion]
      when "M"
        Horses::Horse.genders[:mare]
      when "G"
        Horses::Horse.genders[:gelding]
      else
        raise StandardError, "Unexpected gender: #{legacy_horse.Gender}"
      end
    end
  end

  def dead?
    FinalFurlong::Benchmark.measure_execution_time("Determine dead") do
      return true if legacy_horse.Status.to_i == 2
      return false unless legacy_horse.DOD

      legacy_horse.DOD >= legacy_horse.DOB
    end
  end

  def calculate_age
    FinalFurlong::Benchmark.measure_execution_time("Calculate age") do
      max_date = if dead?
        from_game_date(legacy_horse.DOD || legacy_horse.Die)
      else
        Date.current
      end

      max_date.year - from_game_date(legacy_horse.DOB).year
    end
  end

  def from_game_date(value)
    date_value = (value.is_a?(Date) || value.is_a?(DateTime)) ? value : Date.parse(value)
    date_value - 4.years
  end
end

