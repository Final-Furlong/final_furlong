class MigrateLegacyHorseService # rubocop:disable Metrics/ClassLength
  attr_reader :legacy_horse, :locations

  def initialize(horse:, locations:)
    @legacy_horse = horse
    @locations = locations
  end

  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    return unless legacy_horse
    return if Horses::Horse.exists?(legacy_id: legacy_horse.id)

    Horses::Horse.create!(
      age: calculate_age,
      date_of_birth: from_game_date(legacy_horse.date_of_birth),
      date_of_death: dead? ? from_game_date(legacy_horse.date_of_death) : nil,
      gender: pick_gender,
      name: legacy_horse.name.presence,
      status: pick_status,
      created_at: from_game_date(legacy_horse.dob),
      legacy_id: legacy_horse.id,
      breeder_id: find_breeder,
      owner_id: find_owner,
      location_bred_id: find_location,
      sire_id: find_sire,
      dam_id: find_dam
    )
  rescue => e
    Rails.logger.error "Info: #{legacy_horse.inspect}"
    raise e
  end

  private

  def find_sire
    return unless legacy_horse.sire

    Horses::Horse.where(legacy_id: legacy_horse.sire).pick(:id)
  end

  def find_dam
    return unless legacy_horse.dam

    Horses::Horse.where(legacy_id: legacy_horse.dam).pick(:id)
  end

  def find_location
    locations[legacy_horse.loc_bred]
  end

  def find_breeder
    return final_furlong unless legacy_horse.breeder

    Account::Stable.where(legacy_id: legacy_horse.breeder).pick(:id) || final_furlong
  end

  def find_owner
    return final_furlong unless legacy_horse.owner

    Account::Stable.where(legacy_id: legacy_horse.owner).pick(:id) || final_furlong
  end

  def final_furlong
    return @final_furlong if @final_furlong

    @final_furlong = Account::Stable.where(name: "Final Furlong").pick(:id)
  end

  def pick_status # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
    case legacy_horse.status.to_i
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

  def pick_gender # rubocop:disable Metrics/MethodLength
    case legacy_horse.gender
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
    Date.parse(value) - 4.years
  end
end

