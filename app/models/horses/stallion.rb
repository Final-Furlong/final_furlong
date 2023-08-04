module Horses
  class Stallion < Horse
    validates :status, inclusion: { in: Status::MALE_BREEDING_STATUSES }
    validates :gender, inclusion: { in: %w[stallion gelding] }

    has_many :foals, class_name: "Horses::Horse", foreign_key: "sire_id",
      inverse_of: :sire, dependent: :restrict_with_exception
  end
end

# == Schema Information
#
# Table name: horses
#
#  id                 :uuid             not null, primary key
#  age                :integer
#  date_of_birth      :date             not null, indexed
#  date_of_death      :date
#  foals_count        :integer          default(0), not null
#  gender             :enum             not null
#  name               :string           indexed
#  status             :enum             default("unborn"), not null, indexed
#  unborn_foals_count :integer          default(0), not null
#  created_at         :datetime         not null, indexed
#  updated_at         :datetime         not null
#  breeder_id         :uuid             not null, indexed
#  dam_id             :uuid             indexed
#  legacy_id          :integer          indexed
#  location_bred_id   :uuid             indexed
#  owner_id           :uuid             not null, indexed
#  sire_id            :uuid             indexed
#
# Indexes
#
#  index_horses_on_breeder_id        (breeder_id)
#  index_horses_on_created_at        (created_at)
#  index_horses_on_dam_id            (dam_id)
#  index_horses_on_date_of_birth     (date_of_birth)
#  index_horses_on_legacy_id         (legacy_id) UNIQUE
#  index_horses_on_location_bred_id  (location_bred_id)
#  index_horses_on_name              (name)
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

