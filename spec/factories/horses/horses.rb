FactoryBot.define do
  factory :horse, class: "Horses::Horse" do
    name { "Horse #{SecureRandom.alphanumeric(12)}" }
    gender { %w[colt filly gelding].sample }
    status { "racehorse" }
    date_of_birth { Date.current - 3.years }
    owner factory: :stable
    breeder { owner }
    location_bred factory: :location

    trait :plain do
      appearance { association :horse_appearance, :plain, horse: instance }
    end

    trait :with_appearance do
      appearance { association :horse_appearance, horse: instance }
    end

    trait :with_sire do
      sire { association :sire }
    end

    trait :with_dam do
      dam { association :dam }
    end

    factory :sire do
      stallion
    end

    factory :dam do
      broodmare
    end

    trait :weanling do
      name { nil }
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

    trait :unborn do
      name { nil }
      status { "unborn" }
      date_of_birth { Date.current + 6.months }
      gender { %w[colt filly].sample }
    end
  end
end

# == Schema Information
#
# Table name: horses
#
#  id                                                                                                                 :bigint           not null, primary key
#  age                                                                                                                :integer          default(0), not null, indexed
#  date_of_birth                                                                                                      :date             not null, indexed
#  date_of_death                                                                                                      :date             indexed
#  gender(colt, filly, mare, stallion, gelding)                                                                       :enum             not null, indexed
#  name                                                                                                               :string(18)       indexed
#  slug                                                                                                               :string           indexed
#  status(unborn, weanling, yearling, racehorse, broodmare, stud, retired, retired_broodmare, retired_stud, deceased) :enum             default("unborn"), not null, indexed
#  created_at                                                                                                         :datetime         not null
#  updated_at                                                                                                         :datetime         not null
#  breeder_id                                                                                                         :bigint           not null, indexed
#  dam_id                                                                                                             :bigint           indexed
#  legacy_id                                                                                                          :integer          indexed
#  location_bred_id                                                                                                   :bigint           not null, indexed
#  old_breeder_id                                                                                                     :uuid             not null, indexed
#  old_dam_id                                                                                                         :uuid             indexed
#  old_id                                                                                                             :uuid             indexed
#  old_location_bred_id                                                                                               :uuid             not null, indexed
#  old_owner_id                                                                                                       :uuid             not null, indexed
#  old_sire_id                                                                                                        :uuid             indexed
#  owner_id                                                                                                           :bigint           not null, indexed
#  public_id                                                                                                          :string(12)       indexed
#  sire_id                                                                                                            :bigint           indexed
#
# Indexes
#
#  index_horses_on_age                   (age)
#  index_horses_on_breeder_id            (breeder_id)
#  index_horses_on_dam_id                (dam_id)
#  index_horses_on_date_of_birth         (date_of_birth)
#  index_horses_on_date_of_death         (date_of_death)
#  index_horses_on_gender                (gender)
#  index_horses_on_legacy_id             (legacy_id)
#  index_horses_on_location_bred_id      (location_bred_id)
#  index_horses_on_name                  (name)
#  index_horses_on_old_breeder_id        (old_breeder_id)
#  index_horses_on_old_dam_id            (old_dam_id)
#  index_horses_on_old_id                (old_id)
#  index_horses_on_old_location_bred_id  (old_location_bred_id)
#  index_horses_on_old_owner_id          (old_owner_id)
#  index_horses_on_old_sire_id           (old_sire_id)
#  index_horses_on_owner_id              (owner_id)
#  index_horses_on_public_id             (public_id)
#  index_horses_on_sire_id               (sire_id)
#  index_horses_on_slug                  (slug)
#  index_horses_on_status                (status)
#
# Foreign Keys
#
#  fk_rails_...  (breeder_id => stables.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...  (dam_id => horses.id) ON DELETE => nullify ON UPDATE => cascade
#  fk_rails_...  (location_bred_id => locations.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...  (owner_id => stables.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...  (sire_id => horses.id) ON DELETE => nullify ON UPDATE => cascade
#

