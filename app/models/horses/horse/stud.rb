module Horses
  class Horse::Stud < Horse
    has_one :famous_stud, class_name: "Horses::Stud::FamousStud", foreign_key: :horse_id, inverse_of: :horse, dependent: :delete
    has_many :foals, class_name: "Horses::Horse", inverse_of: :sire, dependent: :nullify
    has_many :breedings, class_name: "Horses::Breeding", inverse_of: :stud, dependent: :delete_all
    has_many :nominations, class_name: "Horses::Stud::BreedersCupNomination", inverse_of: :stud, dependent: :delete_all
    has_one :stud_options, class_name: "Horses::Stud::StallionOption", inverse_of: :stud, dependent: :delete
    # rubocop:disable Rails/HasManyOrHasOneDependent
    has_one :foal_record, class_name: "Horses::Stud::FoalRecord", inverse_of: :stud
    # rubocop:enable Rails/HasManyOrHasOneDependent

    scope :stud_available_for_stable, ->(stable) {
      joins(:stud_options).where("(manager_id = ? AND stallion_options.total_booked_count < ?) OR (outside_mares_allowed > outside_mares_count)", stable.id, Config::Breedings.max_mares_per_year)
    }
    scope :not_famous_stud, -> { where.missing(:famous_stud) }

    def breed_ranking_string
      foal_record&.breed_ranking_string
    end
  end
end

# == Schema Information
#
# Table name: horses
# Database name: primary
#
#  id                                                                                                                 :bigint           not null, primary key
#  age                                                                                                                :integer          default(0), not null, indexed, indexed => [status]
#  date_of_birth                                                                                                      :date             not null, indexed => [leaser_id], indexed => [manager_id], indexed => [owner_id]
#  date_of_death                                                                                                      :date             indexed
#  dosage_abbr                                                                                                        :string
#  gender(colt, filly, mare, stallion, gelding)                                                                       :enum             not null, indexed, indexed => [status]
#  name                                                                                                               :string(18)       indexed, indexed => [status]
#  slug                                                                                                               :string           indexed
#  state(active,retired,unborn,deceased)                                                                              :enum             default("active"), indexed
#  status(unborn, weanling, yearling, racehorse, broodmare, stud, retired, retired_broodmare, retired_stud, deceased) :enum             default("unborn"), not null, indexed => [owner_id], indexed => [age], indexed => [breeder_id], indexed => [dam_id], indexed => [gender], indexed => [leaser_id], indexed => [name], indexed => [owner_id], indexed => [sire_id]
#  title_abbr                                                                                                         :string
#  type(Racehorse,Broodmare,Stud,Foal)                                                                                :string           default("Horses::Horse::Foal"), indexed
#  created_at                                                                                                         :datetime         not null
#  updated_at                                                                                                         :datetime         not null
#  breeder_id                                                                                                         :bigint           not null, indexed, indexed => [status]
#  dam_id                                                                                                             :bigint           indexed, indexed => [status]
#  leaser_id                                                                                                          :bigint           indexed => [date_of_birth], indexed, indexed => [status]
#  legacy_id                                                                                                          :integer          indexed
#  location_bred_id                                                                                                   :bigint           not null, indexed
#  manager_id                                                                                                         :bigint           indexed => [date_of_birth], indexed
#  owner_id                                                                                                           :bigint           not null, indexed => [date_of_birth], indexed => [status], indexed => [status]
#  public_id                                                                                                          :string(12)       indexed
#  sire_id                                                                                                            :bigint           indexed, indexed => [status]
#
# Indexes
#
#  index_horses_on_age                           (age)
#  index_horses_on_breeder_id                    (breeder_id)
#  index_horses_on_dam_id                        (dam_id)
#  index_horses_on_date_of_birth_and_leaser_id   (date_of_birth,leaser_id) WHERE (leaser_id IS NOT NULL)
#  index_horses_on_date_of_birth_and_manager_id  (date_of_birth,manager_id)
#  index_horses_on_date_of_birth_and_owner_id    (date_of_birth,owner_id) WHERE (leaser_id IS NULL)
#  index_horses_on_date_of_death                 (date_of_death)
#  index_horses_on_gender                        (gender)
#  index_horses_on_leaser_id                     (leaser_id)
#  index_horses_on_legacy_id                     (legacy_id)
#  index_horses_on_location_bred_id              (location_bred_id)
#  index_horses_on_manager_id                    (manager_id)
#  index_horses_on_name                          (name)
#  index_horses_on_owner_id_and_status           (owner_id,status)
#  index_horses_on_public_id                     (public_id)
#  index_horses_on_sire_id                       (sire_id)
#  index_horses_on_slug                          (slug)
#  index_horses_on_state                         (state)
#  index_horses_on_status_and_age                (status,age)
#  index_horses_on_status_and_breeder_id         (status,breeder_id)
#  index_horses_on_status_and_dam_id             (status,dam_id)
#  index_horses_on_status_and_gender             (status,gender)
#  index_horses_on_status_and_leaser_id          (status,leaser_id)
#  index_horses_on_status_and_name               (status,name)
#  index_horses_on_status_and_owner_id           (status,owner_id)
#  index_horses_on_status_and_sire_id            (status,sire_id)
#  index_horses_on_type                          (type)
#
# Foreign Keys
#
#  fk_rails_...  (breeder_id => stables.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...  (dam_id => horses.id) ON DELETE => nullify ON UPDATE => cascade
#  fk_rails_...  (leaser_id => stables.id)
#  fk_rails_...  (location_bred_id => locations.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...  (manager_id => stables.id)
#  fk_rails_...  (owner_id => stables.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...  (sire_id => horses.id) ON DELETE => nullify ON UPDATE => cascade
#

