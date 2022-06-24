# typed: strict

class HorseStatus
  extend T::Sig

  STATUSES = T.let({
                     unborn: "unborn", weanling: "weanling", yearling: "yearling",
                     racehorse: "racehorse", broodmare: "broodmare", stud: "stud",
                     retired: "retired", retired_broodmare: "retired_broodmare",
                     retired_stud: "retired_stud", deceased: "deceased"
                   }, T::Hash[T.untyped, String])

  LIVING_STATUSES = T.let(
    %w[weanling yearling racehorse broodmare stud retired retired_broodmare retired_stud],
    T::Array[String]
  )
  ACTIVE_STATUSES = T.let(%w[racehorse broodmare stud], T::Array[String])
  ACTIVE_BREEDING_STATUSES = T.let(%w[broodmare stud], T::Array[String])
  BREEDING_STATUSES = T.let(%w[broodmare stud retired_broodmare retired_stud], T::Array[String])
  MALE_BREEDING_STATUSES = T.let(%w[stud retired_stud], T::Array[String])
  FEMALE_BREEDING_STATUSES = T.let(%w[broodmare retired_broodmare], T::Array[String])

  sig { params(status: T.any(String, Symbol)).void }
  def initialize(status)
    @status = T.let(status.to_s, String)
  end

  sig { returns(String) }
  def to_s
    @status
  end

  sig { returns(T::Boolean) }
  def living?
    LIVING_STATUSES.include?(@status)
  end

  sig { returns(T::Boolean) }
  def active?
    ACTIVE_STATUSES.include?(@status)
  end

  sig { returns(T::Boolean) }
  def active_breeding?
    ACTIVE_BREEDING_STATUSES.include?(@status)
  end

  sig { returns(T::Boolean) }
  def breeding?
    BREEDING_STATUSES.include?(@status)
  end
end
