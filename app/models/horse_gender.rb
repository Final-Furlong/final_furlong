class HorseGender
  VALUES = { colt: "colt", filly: "filly", mare: "mare", stallion: "stallion", gelding: "gelding" }

  MALE_GENDERS = %w[colt stallion gelding]
  FEMALE_GENDERS = %w[filly mare]
  BREEDABLE_GENDERS = %w[mare stallion]

  def initialize(gender)
    @gender = gender.to_s
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
