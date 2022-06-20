# typed: false

class Horse < ApplicationRecord
  belongs_to :breeder, class_name: "Stable"
  belongs_to :owner, class_name: "Stable"
  belongs_to :sire, class_name: "Horse", optional: true
  belongs_to :dam, class_name: "Horse", optional: true
  belongs_to :location_bred, class_name: "Racetrack"

  enum status: HorseStatus::STATUSES
  enum gender: HorseGender::VALUES

  validates :date_of_birth, presence: true
  validates :date_of_death, comparison: { greater_than_or_equal_to: :date_of_birth }

  def status
    HorseStatus.new(read_attribute(:status))
  end

  def gender
    HorseGender.new(read_attribute(:gender))
  end

  def age
    max_date = status.living? ? Date.current : date_of_death
    max_date.year - date_of_birth.year
  end

  def stillborn?
    date_of_birth == date_of_death
  end
end

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: horses
#
#  id                                                                                                                         :bigint           not null, primary key
#  date_of_birth                                                                                                              :date             not null, indexed
#  date_of_death                                                                                                              :date
#  gender(colt, filly, mare, stallion, gelding)                                                                               :string           not null
#  name                                                                                                                       :string
#  status(unborn, weanling, yearling, racehorse, broodmare, stallion, retired, retired_broodmare, retired_stallion, deceased) :enum             default("unborn"), not null, indexed
#  created_at                                                                                                                 :datetime         not null
#  updated_at                                                                                                                 :datetime         not null
#  breeder_id                                                                                                                 :bigint           indexed
#  dam_id                                                                                                                     :bigint           indexed
#  location_bred_id                                                                                                           :bigint           indexed
#  owner_id                                                                                                                   :bigint           indexed
#  sire_id                                                                                                                    :bigint           indexed
#
# Indexes
#
#  index_horses_on_breeder_id        (breeder_id)
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
#  fk_rails_...  (location_bred_id => racetracks.id)
#  fk_rails_...  (owner_id => stables.id)
#  fk_rails_...  (sire_id => horses.id)
#
# rubocop:enable Metrics/LineLength
