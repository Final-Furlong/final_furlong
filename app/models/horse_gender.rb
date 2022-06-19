# typed: false

class HorseGender
  VALUES = {
    colt: "colt", filly: "filly", mare: "mare", stallion: "stallion", gelding: "gelding"
  }.freeze

  MALE_GENDERS = %w[colt stallion gelding].freeze
  FEMALE_GENDERS = %w[filly mare].freeze
  BREEDABLE_GENDERS = %w[mare stallion].freeze

  def initialize(gender)
    @gender = gender
  end

  def to_s
    @gender
  end

  def male?
    MALE_GENDERS.include?(@gender)
  end

  def female?
    FEMALE_GENDERS.include?(@gender)
  end

  def breedable?
    BREEDABLE_GENDERS.include?(@gender)
  end
end
