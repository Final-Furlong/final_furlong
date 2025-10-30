module Horses
  class Horse < ApplicationRecord
    include FinalFurlong::Horses::Validation
    include FriendlyId

    friendly_id :name_and_foal_status, use: [:slugged, :finders]

    belongs_to :breeder, class_name: "Account::Stable"
    belongs_to :owner, class_name: "Account::Stable"
    belongs_to :sire, class_name: "Horse", optional: true
    belongs_to :dam, class_name: "Horse", optional: true
    belongs_to :location_bred, class_name: "Location"

    has_one :horse_attributes, class_name: "Attributes", dependent: :delete
    has_one :appearance, class_name: "Appearance", dependent: :delete
    has_one :genetics, class_name: "Genetics", dependent: :delete

    has_one :auction_horse, class_name: "Auctions::Horse", dependent: :destroy

    has_one :training_schedules_horse, class_name: "Racing::TrainingScheduleHorse", dependent: :destroy
    has_one :training_schedule, class_name: "Racing::TrainingSchedule", through: :training_schedules_horse
    has_many :race_result_finishes, class_name: "Racing::RaceResultHorse", inverse_of: :horse, dependent: :delete_all
    has_many :race_results, class_name: "Racing::RaceResult", source: :race, through: :race_result_finishes
    has_many :race_records, class_name: "Racing::RaceRecord", inverse_of: :horse, dependent: :delete_all
    # rubocop:disable Rails/HasManyOrHasOneDependent
    has_many :annual_race_records, class_name: "Racing::AnnualRaceRecord", inverse_of: :horse
    has_one :lifetime_race_record, class_name: "Racing::LifetimeRaceRecord", inverse_of: :horse
    # rubocop:enable Rails/HasManyOrHasOneDependent

    has_many :foals, class_name: "Horses::Horse", inverse_of: :dam, dependent: :nullify
    has_many :stud_foals, class_name: "Horses::Horse", inverse_of: :sire, dependent: :nullify
    has_one :broodmare_foal_record, inverse_of: :mare, dependent: :delete

    enum :status, Status::STATUSES
    enum :gender, Gender::VALUES

    validates :date_of_birth, :gender, :status, presence: true
    validates :date_of_death, comparison: { greater_than_or_equal_to: :date_of_birth }, if: :date_of_death
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
    scope :order_by_yob, -> { order(Arel.sql("TO_CHAR(date_of_birth, 'YYYY') ASC")) }
    scope :order_by_dam, -> { includes(:dam).order("dams_horses.name ASC") }

    delegate :title, :breeding_record, :dosage_text, :track_record, to: :horse_attributes, allow_nil: true

    # broadcasts_to ->(_horse) { "horses" }, inserts_by: :prepend

    def age
      return 0 if stillborn?

      max_date = date_of_death || Date.current
      max_date.year - date_of_birth.year
    end

    def created?
      sire.blank? && dam.blank?
    end

    def female?
      Gender::FEMALE_GENDERS.include?(gender)
    end

    def male?
      !female?
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

    # :nocov:
    counter_culture :sire, column_name: proc { |model| model.unborn? ? "unborn_foals_count" : "foals_count" },
      column_names: {
        ["horses.status = ?", "unborn"] => "unborn_foals_count",
        ["horses.status != ?", "unborn"] => "foals_count"
      }
    counter_culture :dam, column_name: proc { |model| model.unborn? ? "unborn_foals_count" : "foals_count" },
      column_names: {
        ["horses.status = ?", "unborn"] => "unborn_foals_count",
        ["horses.status != ?", "unborn"] => "foals_count"
      }
    counter_culture :breeder, column_name: proc { |model| model.unborn? ? nil : "bred_horses_count" },
      column_names: {
        ["horses.status = ?", "unborn"] => nil,
        ["horses.status != ?", "unborn"] => "bred_horses_count"
      }
    counter_culture :owner, column_name: proc { |model| model.unborn? ? "unborn_horses_count" : "horses_count" },
      column_names: {
        ["horses.status = ?", "unborn"] => "unborn_horses_count",
        ["horses.status != ?", "unborn"] => "horses_count"
      }
    # :nocov:

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
#
#  id                                                                                                                 :uuid             not null, primary key
#  age                                                                                                                :integer
#  date_of_birth                                                                                                      :date             not null, indexed
#  date_of_death                                                                                                      :date
#  foals_count                                                                                                        :integer          default(0), not null
#  gender(colt, filly, stallion, mare, gelding)                                                                       :enum             not null
#  name                                                                                                               :string(18)       indexed
#  slug                                                                                                               :string           uniquely indexed
#  status(unborn, weanling, yearling, racehorse, broodmare, stud, retired, retired_broodmare, retired_stud, deceased) :enum             default("unborn"), not null, indexed
#  unborn_foals_count                                                                                                 :integer          default(0), not null
#  created_at                                                                                                         :datetime         not null, indexed
#  updated_at                                                                                                         :datetime         not null
#  breeder_id                                                                                                         :uuid             not null, indexed
#  dam_id                                                                                                             :uuid             indexed
#  legacy_id                                                                                                          :integer          uniquely indexed
#  location_bred_id                                                                                                   :uuid             not null, indexed
#  owner_id                                                                                                           :uuid             not null, indexed
#  sire_id                                                                                                            :uuid             indexed
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
#  index_horses_on_slug              (slug) UNIQUE
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

