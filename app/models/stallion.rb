# typed: false

class Stallion < Horse
  validates :status, inclusion: { in: HorseStatus::MALE_BREEDING_STATUSES }
  validates :gender, inclusion: { in: %w[stallion gelding] }

  has_many :foals, class_name: "Horse", foreign_key: "sire_id",
                   inverse_of: :sire, dependent: :restrict_with_exception
end
