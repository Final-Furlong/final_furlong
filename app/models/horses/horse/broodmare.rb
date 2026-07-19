module Horses
  class Horse::Broodmare < Horse
    friendly_id :name_and_foal_status, use: [:slugged, :finders, :history]

    has_many :foals, class_name: "Horses::Horse", inverse_of: :dam, dependent: :nullify
    has_one :last_broodmare_shipment, -> { order(departure_date: :desc) }, class_name: "Horses::Broodmare::Shipment", inverse_of: :horse, dependent: :delete
    has_many :shipments, class_name: "Horses::Broodmare::Shipment", inverse_of: :horse, dependent: :delete_all
    has_many :due_dates, -> { where.not(status: "denied") }, class_name: "Horses::Breeding", inverse_of: :mare, dependent: :delete_all
    has_one :next_foal, -> { where(status: "bred").where(year: (Date.current.year - 1)..).order(year: :asc) }, class_name: "Horses::Breeding", inverse_of: :mare, dependent: :delete
    # rubocop:disable Rails/HasManyOrHasOneDependent
    has_one :foal_record, class_name: "Horses::Broodmare::FoalRecord", inverse_of: :mare
    # rubocop:enable Rails/HasManyOrHasOneDependent

    def status
      return I18n.t("horses.statuses.deceased") if deceased?

      key = retired? ? "retired_broodmare" : "broodmare"
      I18n.t("horses.statuses.#{key}")
    end

    def retire
      Horses::Broodmare::Retirement.new(horse: self).run
    end

    def die(date: Date.current)
      Horses::Broodmare::Death.new(horse: self, date:).run
    end

    def breed_ranking_string
      foal_record&.breed_ranking_string
    end

    def current_location
      if last_shipment.nil?
        manager
      else
        last_shipment.ending_farm
      end
    end

    def current_location_name
      return manager.name if last_shipment.nil?

      last_shipment.ending_farm.name
    end

    def in_transit?
      return false if last_shipment.nil?

      last_shipment.arrival_date > Date.current
    end

    def last_shipment
      shipments.includes(:ending_farm).current.order(arrival_date: :desc).first
    end
  end
end

# == Schema Information
#
# Table name: horses
# Database name: primary
#
#  id                                           :bigint           not null, primary key
#  age                                          :integer          default(0), not null, indexed
#  date_of_birth                                :date             not null, indexed => [leaser_id], indexed => [manager_id], indexed => [owner_id]
#  date_of_death                                :date             indexed
#  dosage_abbr                                  :string
#  gender(colt, filly, mare, stallion, gelding) :enum             not null, indexed
#  name                                         :string(18)       indexed
#  slug                                         :string           indexed
#  state(active,retired,unborn,deceased)        :enum             default("active"), indexed
#  title_abbr                                   :string
#  type(Racehorse,Broodmare,Stud,Foal)          :string           default("Horses::Horse::Foal"), indexed
#  created_at                                   :datetime         not null
#  updated_at                                   :datetime         not null
#  breeder_id                                   :bigint           not null, indexed
#  dam_id                                       :bigint           indexed
#  leaser_id                                    :bigint           indexed => [date_of_birth], indexed
#  legacy_id                                    :integer          indexed
#  location_bred_id                             :bigint           not null, indexed
#  manager_id                                   :bigint           indexed => [date_of_birth], indexed
#  owner_id                                     :bigint           not null, indexed => [date_of_birth], indexed
#  public_id                                    :string(12)       indexed
#  sire_id                                      :bigint           indexed
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
#  index_horses_on_owner_id                      (owner_id)
#  index_horses_on_public_id                     (public_id)
#  index_horses_on_sire_id                       (sire_id)
#  index_horses_on_slug                          (slug)
#  index_horses_on_state                         (state)
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

