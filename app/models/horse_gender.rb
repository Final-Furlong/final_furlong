class HorseGender
  VALUES = { colt: "colt", filly: "filly", mare: "mare", stallion: "stallion", gelding: "gelding" }

  MALE_GENDERS = %w[colt stallion gelding]
  FEMALE_GENDERS = %w[filly mare]
  BREEDABLE_GENDERS = %w[mare stallion]
  FILTER_OPTIONS = {
    male: "colt,stallion",
    female: "filly,mare",
    gelding: "gelding"
  }

  def self.localised_filter_options
    result = []
    FILTER_OPTIONS.each do |key, values|
      result << [I18n.t("horses.genders.#{key}"), values]
    end
    result
  end

  def initialize(gender)
    @gender = gender.to_s
  end

  def to_s
    @gender.titleize
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

