class Horse < ApplicationRecord
  include FinalFurlong::Horses::Validation

  belongs_to :breeder, class_name: "Stable"
  belongs_to :owner, class_name: "Stable"
  belongs_to :sire, class_name: "Horse", optional: true
  belongs_to :dam, class_name: "Horse", optional: true
  belongs_to :location_bred, class_name: "Location"

  enum status: HorseStatus::STATUSES
  enum gender: HorseGender::VALUES

  validates :date_of_birth, presence: true
  validates :date_of_death, comparison: { greater_than_or_equal_to: :date_of_birth }, if: :date_of_death
  validate :name_required, on: :update
  validates_horse_name :name, on: :update

  scope :living, -> { where(status: HorseStatus::LIVING_STATUSES) }
  scope :ordered, -> { order(name: :asc) }
  scope :owned_by, ->(stable) { where(owner: stable) }

  # broadcasts_to ->(_horse) { "horses" }, inserts_by: :prepend

  def status
    return unless self[:status]

    HorseStatus.new(self[:status])
  end

  def gender
    return unless self[:gender]

    HorseGender.new(self[:gender])
  end

  def age
    max_date = dead? ? self[:date_of_death] : Date.current
    max_date.year - self[:date_of_birth].year
  end

  def stillborn?
    self[:date_of_birth] == self[:date_of_death]
  end

  private

    def dead?
      return false unless self[:date_of_death]

      self[:date_of_death] >= self[:date_of_birth]
    end

    def name_required
      return unless name_changed?

      errors.add(:name, :blank) if name.blank?
    end
end

# == Schema Information
#
# Table name: horses
#
#  id               :uuid             not null, primary key
#  age              :integer
#  date_of_birth    :date             not null, indexed
#  date_of_death    :date
#  gender           :enum             not null
#  name             :string
#  status           :enum             default("unborn"), not null, indexed
#  created_at       :datetime         not null, indexed
#  updated_at       :datetime         not null
#  breeder_id       :uuid             not null, indexed
#  dam_id           :uuid             indexed
#  location_bred_id :uuid             indexed
#  owner_id         :uuid             not null, indexed
#  sire_id          :uuid             indexed
#
# Indexes
#
#  index_horses_on_breeder_id        (breeder_id)
#  index_horses_on_created_at        (created_at)
#  index_horses_on_dam_id            (dam_id)
#  index_horses_on_date_of_birth     (date_of_birth)
#  index_horses_on_location_bred_id  (location_bred_id)
#  index_horses_on_owner_id          (owner_id)
#  index_horses_on_sire_id           (sire_id)
#  index_horses_on_status            (status)
#
# Foreign Keys
#
#  fk_rails_...  (breeder_id => stables.id)
#  fk_rails_...  (dam_id => horses.id)
#  fk_rails_...  (location_bred_id => locations.id)
#  fk_rails_...  (owner_id => stables.id)
#  fk_rails_...  (sire_id => horses.id)
#
