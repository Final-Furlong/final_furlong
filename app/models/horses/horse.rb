module Horses
  class Horse < ApplicationRecord
    self.ignored_columns += ["old_id", "old_dam_id", "old_sire_id"]

    include PublicIdGenerator
    include FinalFurlong::Horses::Validation
    include FriendlyId

    NAME_LENGTH_MAX = 18

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
    has_many :race_records, class_name: "Racing::RaceRecord", inverse_of: :horse, dependent: :delete_all
    # rubocop:disable Rails/HasManyOrHasOneDependent
    has_many :annual_race_records, class_name: "Racing::AnnualRaceRecord", inverse_of: :horse
    has_one :lifetime_race_record, class_name: "Racing::LifetimeRaceRecord", inverse_of: :horse
    # rubocop:enable Rails/HasManyOrHasOneDependent

    # racehorse stuff
    has_one :training_schedules_horse, class_name: "Racing::TrainingScheduleHorse", dependent: :destroy
    has_one :training_schedule, class_name: "Racing::TrainingSchedule", through: :training_schedules_horse
    has_one :current_boarding, -> { where(end_date: nil) }, class_name: "Horses::Boarding", inverse_of: :horse, dependent: :delete
    has_many :boardings, -> { where.not(end_date: nil) }, class_name: "Horses::Boarding", inverse_of: :horse, dependent: :delete_all
    has_many :racing_shipments, class_name: "Shipping::RacehorseShipment", dependent: :delete_all

    has_many :foals, class_name: "Horses::Horse", inverse_of: :dam, dependent: :nullify
    has_many :broodmare_shipments, class_name: "Shipping::BroodmareShipment", dependent: :delete_all

    has_many :stud_foals, class_name: "Horses::Horse", inverse_of: :sire, dependent: :nullify

    enum :status, Status::STATUSES
    enum :gender, Gender::VALUES

    validates :date_of_birth, :age, :gender, :status, presence: true
    validates :date_of_death, comparison: { greater_than_or_equal_to: :date_of_birth }, if: :date_of_death
    validates :name, length: { maximum: NAME_LENGTH_MAX }
    validate :name_required, on: :update
    validates_horse_name :name, on: :update, if: :name_changed?

    scope :alive, -> { where(status: Status::LIVING_STATUSES) }
    scope :retired, -> { where(status: Status::RETIRED_STATUSES) }
    scope :born, -> { where(date_of_birth: ..Date.current) }
    scope :unborn, -> { where(date_of_birth: Date.current + 1.day..) }
    scope :stillborn, -> { where("date_of_birth = date_of_death") }
    scope :not_stillborn, -> { where(date_of_death: nil).or(where("date_of_death > date_of_birth")) }
    scope :female, -> { where(gender: Gender::FEMALE_GENDERS) }
    scope :not_female, -> { where.not(gender: Gender::FEMALE_GENDERS) }
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
      ids = born.with_owner(stable).without_lease.select(:id)
      ids += born.with_leaser(stable).select(:id)
      where(id: ids)
    }

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
      %w[breeder dam location_bred owner sire]
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
#  leaser_id                                                                                                          :bigint           indexed
#  legacy_id                                                                                                          :integer          indexed
#  location_bred_id                                                                                                   :bigint           not null, indexed
#  owner_id                                                                                                           :bigint           not null, indexed
#  public_id                                                                                                          :string(12)       indexed
#  sire_id                                                                                                            :bigint           indexed
#
# Indexes
#
#  index_horses_on_age               (age)
#  index_horses_on_breeder_id        (breeder_id)
#  index_horses_on_dam_id            (dam_id)
#  index_horses_on_date_of_birth     (date_of_birth)
#  index_horses_on_date_of_death     (date_of_death)
#  index_horses_on_gender            (gender)
#  index_horses_on_leaser_id         (leaser_id)
#  index_horses_on_legacy_id         (legacy_id)
#  index_horses_on_location_bred_id  (location_bred_id)
#  index_horses_on_name              (name)
#  index_horses_on_owner_id          (owner_id)
#  index_horses_on_public_id         (public_id)
#  index_horses_on_sire_id           (sire_id)
#  index_horses_on_slug              (slug)
#  index_horses_on_status            (status)
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

