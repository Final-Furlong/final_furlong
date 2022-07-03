# typed: true

class HorseGender
  extend T::Sig

  VALUES = T.let({
                   colt: "colt", filly: "filly", mare: "mare", stallion: "stallion", gelding: "gelding"
                 }, T::Hash[T.untyped, String])

  MALE_GENDERS = T.let(%w[colt stallion gelding], T::Array[String])
  FEMALE_GENDERS = T.let(%w[filly mare], T::Array[String])
  BREEDABLE_GENDERS = T.let(%w[mare stallion], T::Array[String])

  sig { params(gender: T.any(Symbol, String)).void }
  def initialize(gender)
    @gender = gender.to_s
  end

  sig { returns(String) }
  def to_s
    @gender
  end

  sig { returns(T::Boolean) }
  def male?
    MALE_GENDERS.include?(@gender)
  end

  sig { returns(T::Boolean) }
  def female?
    FEMALE_GENDERS.include?(@gender)
  end

  sig { returns(T::Boolean) }
  def breedable?
    BREEDABLE_GENDERS.include?(@gender)
  end
end
