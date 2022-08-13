class HorseStatus
  STATUSES = {
    racehorse: "racehorse", broodmare: "broodmare", stud: "stud",
    yearling: "yearling", weanling: "weanling", retired: "retired",
    retired_broodmare: "retired_broodmare", retired_stud: "retired_stud",
    deceased: "deceased", unborn: "unborn"
  }

  LIVING_STATUSES = %w[weanling yearling racehorse broodmare stud retired retired_broodmare retired_stud]
  ACTIVE_STATUSES = %w[racehorse broodmare stud]
  ACTIVE_BREEDING_STATUSES = %w[broodmare stud]
  BREEDING_STATUSES = %w[broodmare stud retired_broodmare retired_stud]
  MALE_BREEDING_STATUSES = %w[stud retired_stud]
  FEMALE_BREEDING_STATUSES = %w[broodmare retired_broodmare]
  RETIRED_STATUSES = %w[retired retired_broodmare retired_stud]

  def initialize(status)
    @status = status.to_s
  end

  def to_s
    @status
  end

  def living?
    LIVING_STATUSES.include?(@status)
  end

  def active?
    ACTIVE_STATUSES.include?(@status)
  end

  def active_breeding?
    ACTIVE_BREEDING_STATUSES.include?(@status)
  end

  def breeding?
    BREEDING_STATUSES.include?(@status)
  end
end

