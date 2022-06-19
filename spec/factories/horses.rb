FactoryBot.define do
  factory :horse do
    name { "MyString" }
    gender { "MyString" }
    status { "MyString" }
  end
end

# == Schema Information
#
# Table name: horses
#
#  id                                                                                                                         :bigint           not null, primary key
#  date_of_birth                                                                                                              :date             not null
#  date_of_death                                                                                                              :date
#  gender(colt, filly, mare, stallion, gelding)                                                                               :string           not null
#  name                                                                                                                       :string
#  status(unborn, weanling, yearling, racehorse, broodmare, stallion, retired, retired_broodmare, retired_stallion, deceased) :enum             default("unborn"), not null
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
#  index_horses_on_location_bred_id  (location_bred_id)
#  index_horses_on_owner_id          (owner_id)
#  index_horses_on_sire_id           (sire_id)
#
# Foreign Keys
#
#  fk_rails_...  (breeder_id => stables.id)
#  fk_rails_...  (dam_id => horses.id)
#  fk_rails_...  (location_bred_id => racetracks.id)
#  fk_rails_...  (owner_id => stables.id)
#  fk_rails_...  (sire_id => horses.id)
#
