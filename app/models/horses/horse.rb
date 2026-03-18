module Horses
  class Horse < ApplicationRecord
    include PublicIdGenerator
    include FinalFurlong::Horses::Validation
    include FriendlyId

    friendly_id :name_and_foal_status, use: [:slugged, :finders]

    belongs_to :breeder, class_name: "Account::Stable"
    belongs_to :owner, class_name: "Account::Stable"
    belongs_to :sire, class_name: "Horse", optional: true
    belongs_to :dam, class_name: "Horse", optional: true
    belongs_to :location_bred, class_name: "Location"

    has_object :racing
    has_object :broodmare
    has_object :stud

    has_one :horse_attributes, class_name: "Attributes", dependent: :delete
    has_one :appearance, class_name: "Appearance", dependent: :delete
    has_one :genetics, class_name: "Genetics", dependent: :delete

    has_one :auction_horse, class_name: "Auctions::Horse", dependent: :destroy
    has_one :lease_offer, class_name: "Horses::LeaseOffer", inverse_of: :horse, dependent: :delete
    has_one :current_lease, -> { where(active: true) }, class_name: "Horses::Lease", inverse_of: :horse, dependent: :destroy
    has_one :leaser, through: :current_lease, source: :leaser
    has_many :past_leases, -> { where.not(active: true) }, class_name: "Horses::Lease", inverse_of: :horse, dependent: :destroy
    has_one :sale_offer, class_name: "Horses::SaleOffer", inverse_of: :horse, dependent: :delete
    has_many :sales, class_name: "Horses::Sale", inverse_of: :horse, dependent: :delete_all

    has_many :race_result_finishes, class_name: "Racing::RaceResultHorse", inverse_of: :horse, dependent: :delete_all
    has_many :race_results, class_name: "Racing::RaceResult", source: :race, through: :race_result_finishes
    has_one :latest_race_result_finish, -> { order id: :desc }, class_name:
      "Racing::RaceResultHorse", inverse_of: :horse, dependent: :delete
    has_one :latest_race_result, class_name: "Racing::RaceResult", through: :latest_race_result_finish, source: :race
    has_many :race_records, class_name: "Racing::RaceRecord", inverse_of: :horse, dependent: :delete_all
    has_many :workouts, class_name: "Workouts::Workout", inverse_of: :horse, dependent: :destroy
    # rubocop:disable Rails/HasManyOrHasOneDependent
    has_many :annual_race_records, class_name: "Racing::AnnualRaceRecord", inverse_of: :horse
    has_one :lifetime_race_record, class_name: "Racing::LifetimeRaceRecord", inverse_of: :horse
    has_one :race_qualification, class_name: "Racing::RaceQualification"
    # rubocop:enable Rails/HasManyOrHasOneDependent

    # racehorse stuff
    has_one :training_schedules_horse, class_name: "Racing::TrainingScheduleHorse", dependent: :destroy
    has_one :training_schedule, class_name: "Racing::TrainingSchedule", through: :training_schedules_horse
    has_one :current_boarding, -> { where(end_date: nil) }, class_name: "Horses::Boarding", inverse_of: :horse, dependent: :delete
    has_many :boardings, -> { where.not(end_date: nil) }, class_name: "Horses::Boarding", inverse_of: :horse, dependent: :delete_all
    has_many :race_entries, class_name: "Racing::RaceEntry", inverse_of: :horse, dependent: :destroy
    has_many :future_race_entries, class_name: "Racing::FutureRaceEntry", inverse_of: :horse, dependent: :delete_all
    has_many :racing_shipments, class_name: "Shipping::RacehorseShipment", dependent: :delete_all
    has_many :current_injuries, class_name: "Horses::Injury", inverse_of: :horse, dependent: :delete_all
    has_many :historical_injuries, class_name: "Horses::HistoricalInjury", inverse_of: :horse, dependent: :delete_all
    has_one :latest_injury, -> { order date: :desc }, class_name:
      "Horses::HistoricalInjury", inverse_of: :horse, dependent: :delete
    has_many :jockey_relationships, class_name: "Racing::HorseJockeyRelationship", dependent: :delete_all
    has_one :race_metadata, class_name: "Racing::RacehorseMetadata", dependent: :delete

    has_many :foals, class_name: "Horses::Horse", inverse_of: :dam, dependent: :nullify
    has_many :broodmare_shipments, class_name: "Shipping::BroodmareShipment", dependent: :delete_all
    has_many :due_dates, -> { where.not(status: "denied") }, class_name: "Horses::Breeding", dependent: :delete_all, inverse_of: :mare
    has_one :next_foal, -> { where(status: "bred") }, class_name: "Horses::Breeding", dependent: :delete, inverse_of: :mare

    has_many :stud_foals, class_name: "Horses::Horse", inverse_of: :sire, dependent: :nullify
    has_many :breedings, class_name: "Horses::Breeding", dependent: :delete_all, inverse_of: :stud

    has_one :breeding_stats, class_name: "Horses::BreedingStats", dependent: :delete, inverse_of: :horse

    has_many :future_events, class_name: "Horses::FutureEvent", inverse_of: :horse, dependent: :delete_all

    enum :status, Status::STATUSES
    enum :gender, Gender::VALUES

    validates :date_of_birth, :age, :gender, :status, presence: true
    validates :date_of_death, comparison: { greater_than_or_equal_to: :date_of_birth }, if: :date_of_death
    validates :name, length: { maximum: Config::Horses.max_name_length }
    validate :name_required, on: :update
    validates_horse_name :name, on: :update, if: :name_changed?

    scope :alive, -> { where(status: Status::LIVING_STATUSES) }
    scope :retired, -> { where(status: Status::RETIRED_STATUSES) }
    scope :born, -> { where(date_of_birth: ..Date.current) }
    scope :unborn, -> { where(date_of_birth: Date.current + 1.day..) }
    scope :stillborn, -> { where("date_of_birth = date_of_death") }
    scope :not_stillborn, -> { where(date_of_death: nil).or(where("date_of_death > date_of_birth")) }
    scope :created, -> { where(sire_id: nil, dam_id: nil) }
    scope :not_created, -> { where("sire_id IS NULL AND dam_id IS NULL") }
    scope :female, -> { where(gender: Gender::FEMALE_GENDERS) }
    scope :not_female, -> { where.not(gender: Gender::FEMALE_GENDERS) }
    scope :max_yob, ->(year) { where("DATE_PART('Year', date_of_birth) <= ?", year) }
    scope :min_age, ->(age) { where("DATE_PART('Year', date_of_birth) <= ?", Date.current.year - age.to_i) }
    scope :max_age, ->(age) { where("DATE_PART('Year', date_of_birth) >= ?", Date.current.year - age.to_i) }
    scope :with_yob, ->(year) { where("DATE_PART('Year', date_of_birth) = ?", year) }
    scope :with_sire, -> { where.associated(:sire) }
    scope :with_dam, -> { where.associated(:dam) }
    scope :order_by_yob, ->(dir = "asc") do
      dir = "ASC" unless %w[asc desc].include?(dir.downcase)
      order(Arel.sql("DATE_PART('Year', date_of_birth) #{dir.upcase}"))
    end
    scope :order_by_dam, ->(dir = "asc") do
      dir = "ASC" unless %w[asc desc].include?(dir.downcase)
      includes(:dam).order("dams_horses.name #{dir.upcase}")
    end
    scope :with_owner, ->(stable) { where(owner: stable) }
    scope :without_lease, -> { where.missing(:current_lease) }
    scope :with_leaser, ->(stable) { joins(:current_lease).where(current_lease: { leaser: stable }) }
    scope :managed_by, ->(stable) {
      born.where(
        "(#{arel_table.name}.owner_id = :id AND #{arel_table.name}.leaser_id IS NULL) OR #{arel_table.name}.leaser_id = :id",
        id: stable
      )
    }
    scope :racehorse_status, ->(status) {
      joins(:race_qualification).merge(::Racing::RaceQualification.send(:qualified_for, status))
    }
    scope :sort_by_race_qualification_asc, -> { joins(:race_qualification).merge(::Racing::RaceQualification.sort_by_qualified_asc) }
    scope :sort_by_race_qualification_desc, -> { joins(:race_qualification).merge(::Racing::RaceQualification.sort_by_qualified_desc) }
    scope :sort_by_race_metadata_race_nulls_last_asc, -> { joins(:race_metadata).order("race_metadata.last_raced_at ASC NULLS LAST") }
    scope :sort_by_race_metadata_race_nulls_last_desc, -> { joins(:race_metadata).order("race_metadata.last_raced_at DESC NULLS LAST") }
    scope :sort_by_race_metadata_injury_nulls_last_asc, -> { joins(:race_metadata).order("race_metadata.last_injured_at ASC NULLS LAST") }
    scope :sort_by_race_metadata_injury_nulls_last_desc, -> { joins(:race_metadata).order("race_metadata.last_injured_at DESC NULLS LAST") }
    scope :min_energy, ->(value) { joins(:race_metadata).merge(::Racing::RacehorseMetadata.min_energy(value)) }
    scope :max_energy, ->(value) { joins(:race_metadata).merge(::Racing::RacehorseMetadata.max_energy(value)) }
    scope :energy_in, ->(max_value, min_value) { joins(:race_metadata).merge(::Racing::RacehorseMetadata.energy_within(max_value, min_value)) }
    scope :min_fitness, ->(value) { joins(:race_metadata).merge(::Racing::RacehorseMetadata.min_fitness(value)) }
    scope :max_fitness, ->(value) { joins(:race_metadata).merge(::Racing::RacehorseMetadata.max_fitness(value)) }
    scope :fitness_in, ->(max_value, min_value) { joins(:race_metadata).merge(::Racing::RacehorseMetadata.fitness_within(max_value, min_value)) }
    scope :race_entry, -> { where.associated(:race_entries) }
    scope :no_race_entry, -> { where.missing(:race_entries) }
    scope :injury_status, ->(value) {
      case value.to_s.downcase
      when "past"
        where.associated(:historical_injuries).where.missing(:current_injuries)
      when "present"
        where.associated(:current_injuries)
      else
        where.missing(:historical_injuries)
      end
    }
    scope :min_rest_days_since_last_race, ->(value) { joins(:race_metadata).merge(::Racing::RacehorseMetadata.min_rest_days(value)) }
    scope :max_rest_days_since_last_race, ->(value) { joins(:race_metadata).merge(::Racing::RacehorseMetadata.max_rest_days(value)) }
    scope :min_days_since_last_shipment, ->(value) { joins(:race_metadata).merge(::Racing::RacehorseMetadata.shipped_before(value)) }
    scope :max_days_since_last_shipment, ->(value) { joins(:race_metadata).merge(::Racing::RacehorseMetadata.shipped_since(value)) }
    scope :min_workouts_since_last_race, ->(value) { joins(:race_metadata).merge(::Racing::RacehorseMetadata.min_workouts(value)) }
    scope :max_workouts_since_last_race, ->(value) { joins(:race_metadata).merge(::Racing::RacehorseMetadata.max_workouts(value)) }

    delegate :title, :breeding_record, :dosage_text, :track_record, to: :horse_attributes, allow_nil: true

    # broadcasts_to ->(_horse) { "horses" }, inserts_by: :prepend

    def to_key = [slug]

    def age
      return 0 if stillborn?

      max_date = date_of_death || Date.current
      max_date.year - date_of_birth.year
    end

    def created?
      sire.blank? && dam.blank?
    end

    def female?
      ::Horses::Gender::FEMALE_GENDERS.include?(gender)
    end

    def male?
      !female?
    end

    def manager
      current_lease&.persisted? ? current_lease.leaser : owner
    end

    def location_bred_name
      location = location_bred.state || location_bred.county
      [location, location_bred.country].join(", ")
    end

    def budget_name
      return name if name.present?

      foal_name = "Unnamed ("
      foal_name += sire_id ? sire.name : "Created"
      foal_name += " x "
      foal_name += dam_id ? dam.name : "Created"
      foal_name + ")"
    end

    def stillborn?
      self[:date_of_birth] == self[:date_of_death]
    end

    def dead?
      return false unless self[:date_of_death]

      self[:date_of_death] >= self[:date_of_birth]
    end

    def name_and_foal_status
      return name if name.present?

      if dam.blank?
        if Horses::Horse.where(name: nil, date_of_birth:, dam: nil).where.not(id:).exists?
          if Horses::Horse.where(name: nil, date_of_birth:, dam: nil).where.not(id:).count == 1
            "created-#{date_of_birth}-2"
          else
            slugs = Horses::Horse.where(name: nil, date_of_birth:, dam: nil).pluck(:slug)
            slugs.map! { |slug| slug.gsub("created-#{date_of_birth}", "").split("-").last.to_s }
            max_slug = slugs.map(&:to_i).max
            "created-#{date_of_birth}-#{max_slug + 1}"
          end
        else
          "created-#{date_of_birth}"
        end
      else
        return "stillborn-#{year_of_birth}-#{dam.name}" if stillborn?

        has_twin = Horses::Horse.where(date_of_birth:, dam:).where.not(id:).exists?
        return "foal-#{year_of_birth}-#{dam.name}" unless has_twin

        "foal-#{year_of_birth}-#{dam.name}-2"
      end
    end

    def should_generate_new_friendly_id?
      name_changed? || super
    end

    def year_of_birth
      date_of_birth&.year
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[age breeder_id dam_id date_of_birth date_of_death foals_count gender location_bred_id name owner_id sire_id status unborn_foals_count]
    end

    def self.ransackable_associations(_auth_object = nil)
      %w[breeder dam location_bred owner sire race_stats race_metadata race_options race_qualification race_results latest_race_result latest_injury]
    end

    def self.ransackable_scopes(_auth_object = nil)
      %w[min_age max_age female not_female racehorse_status min_energy max_energy energy_in min_fitness max_fitness fitness_in
        runs_on_dirt runs_on_turf runs_on_steeplechase injury_status min_days_since_last_race max_days_since_last_race
        min_days_since_last_shipment max_days_since_last_shipment min_workouts_since_last_race max_workouts_since_last_race
        race_entry no_race_entry injury_status min_rest_days_since_last_race max_rest_days_since_last_race min_days_since_last_shipment
        max_days_since_last_shipment min_workouts_since_last_race max_workouts_since_last_race]
    end

    def self.ransackable_scopes_skip_sanitize_args
      %i[min_energy max_energy energy_in min_fitness max_fitness fitness_in]
    end

    private

    def name_required
      return unless name_changed?
      return if name.present?

      errors.add(:name, :blank)
    end
  end
end
# == Schema Information
#
# Table name: horses
# Database name: primary
#
#  id                                                                                                                 :bigint           not null, primary key
#  age                                                                                                                :integer          default(0), not null, indexed
#  date_of_birth                                                                                                      :date             not null, indexed, indexed => [leaser_id], indexed => [owner_id]
#  date_of_death                                                                                                      :date             indexed
#  gender(colt, filly, mare, stallion, gelding)                                                                       :enum             not null, indexed
#  name                                                                                                               :string(18)       indexed
#  slug                                                                                                               :string           indexed
#  status(unborn, weanling, yearling, racehorse, broodmare, stud, retired, retired_broodmare, retired_stud, deceased) :enum             default("unborn"), not null, indexed
#  created_at                                                                                                         :datetime         not null
#  updated_at                                                                                                         :datetime         not null
#  breeder_id                                                                                                         :bigint           not null, indexed
#  dam_id                                                                                                             :bigint           indexed
#  leaser_id                                                                                                          :bigint           indexed => [date_of_birth], indexed
#  legacy_id                                                                                                          :integer          indexed
#  location_bred_id                                                                                                   :bigint           not null, indexed
#  owner_id                                                                                                           :bigint           not null, indexed => [date_of_birth], indexed
#  public_id                                                                                                          :string(12)       indexed
#  sire_id                                                                                                            :bigint           indexed
#
# Indexes
#
#  index_horses_on_age                          (age)
#  index_horses_on_breeder_id                   (breeder_id)
#  index_horses_on_dam_id                       (dam_id)
#  index_horses_on_date_of_birth                (date_of_birth)
#  index_horses_on_date_of_birth_and_leaser_id  (date_of_birth,leaser_id) WHERE (leaser_id IS NOT NULL)
#  index_horses_on_date_of_birth_and_owner_id   (date_of_birth,owner_id) WHERE (leaser_id IS NULL)
#  index_horses_on_date_of_death                (date_of_death)
#  index_horses_on_gender                       (gender)
#  index_horses_on_leaser_id                    (leaser_id)
#  index_horses_on_legacy_id                    (legacy_id)
#  index_horses_on_location_bred_id             (location_bred_id)
#  index_horses_on_name                         (name)
#  index_horses_on_owner_id                     (owner_id)
#  index_horses_on_public_id                    (public_id)
#  index_horses_on_sire_id                      (sire_id)
#  index_horses_on_slug                         (slug)
#  index_horses_on_status                       (status)
#
# Foreign Keys
#
#  fk_rails_...  (breeder_id => stables.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...  (dam_id => horses.id) ON DELETE => nullify ON UPDATE => cascade
#  fk_rails_...  (leaser_id => stables.id)
#  fk_rails_...  (location_bred_id => locations.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...  (owner_id => stables.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...  (sire_id => horses.id) ON DELETE => nullify ON UPDATE => cascade
#

