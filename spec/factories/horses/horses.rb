FactoryBot.define do
  factory :horse, class: "Horses::Horse" do
    sequence(:name) { Faker::Creature::Horse.name }
    gender { %w[colt filly gelding].sample }
    status { "racehorse" }
    date_of_birth { Date.current - 3.years }
    owner factory: :stable
    breeder { owner }
    location_bred factory: :location
    appearance { association :horse_appearance, horse: instance }

    trait :with_sire do
      sire
    end

    trait :with_dam do
      dam
    end

    factory :sire do
      stallion
    end

    factory :dam do
      broodmare
    end

    trait :weanling do
      status { "weanling" }
      date_of_birth { Date.current - (6 - Date.current.month).months }
      gender { %w[colt filly].sample }
    end

    trait :yearling do
      status { "yearling" }
      date_of_birth { Date.current - 1.year }
      gender { %w[colt filly].sample }
    end

    trait :stallion do
      status { "stud" }
      date_of_birth { Date.current - 7.years }
      gender { "stallion" }
    end

    trait :broodmare do
      status { "broodmare" }
      date_of_birth { Date.current - 6.years }
      gender { "mare" }
    end

    trait :retired do
      status { "retired" }
      date_of_birth { Date.current - 5.years }
      gender { %w[mare stallion gelding].sample }
    end

    trait :retired_stud do
      status { "retired_stud" }
      date_of_birth { Date.current - 5.years }
      gender { "stallion" }
    end

    trait :retired_broodmare do
      status { "retired_broodmare" }
      date_of_birth { Date.current - 5.years }
      gender { "mare" }
    end

    trait :stillborn do
      status { "deceased" }
      date_of_birth { Date.current - (6 - Date.current.month).months }
      date_of_death { date_of_birth }
      gender { %w[colt filly].sample }
    end

    trait :dead do
      status { "deceased" }
      date_of_death { Date.current }
    end
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
#  name               :string(18)       indexed
#  status             :enum             default("unborn"), not null, indexed
#  unborn_foals_count :integer          default(0), not null
#  created_at         :datetime         not null, indexed
#  updated_at         :datetime         not null
#  breeder_id         :uuid             not null, indexed
#  dam_id             :uuid             indexed
#  legacy_id          :integer          indexed
#  location_bred_id   :uuid             not null, indexed
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

