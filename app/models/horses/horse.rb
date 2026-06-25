module Horses
  class Horse < ApplicationRecord
    include PublicIdGenerator
    include FinalFurlong::Horses::Validation
    include FriendlyId
    include PgSearch::Model

    include Raceable
    include Breedable
    include Typeable

    friendly_id :name_and_foal_status, use: [:slugged, :finders, :history]

    multisearchable against: [:name], if: lambda { |record| %w[stillborn unborn].exclude?(record.status) }

    belongs_to :breeder, class_name: "Account::Stable"
    belongs_to :owner, class_name: "Account::Stable"
    belongs_to :manager, class_name: "Account::Stable", optional: true
    belongs_to :sire, class_name: "Horses::Horse::Stud", optional: true
    belongs_to :dam, class_name: "Horses::Horse::Broodmare", optional: true
    belongs_to :location_bred, class_name: "Location"
    has_many :slugs, class_name: "FriendlyId::Slug", inverse_of: :sluggable, dependent: :delete_all

    has_one :appearance, class_name: "Appearance", dependent: :delete
    has_many :comments, class_name: "Comment", dependent: :delete_all

    has_many :historical_injuries, class_name: "Horses::HistoricalInjury", inverse_of: :horse, dependent: :delete_all

    has_one :auction_horse, class_name: "Auctions::Horse", dependent: :destroy
    has_one :lease_offer, class_name: "Horses::LeaseOffer", inverse_of: :horse, dependent: :delete
    has_one :current_lease, -> { where(active: true) }, class_name: "Horses::Lease", inverse_of: :horse, dependent: :destroy
    has_one :leaser, through: :current_lease, source: :leaser
    has_many :past_leases, -> { where.not(active: true) }, class_name: "Horses::Lease", inverse_of: :horse, dependent: :destroy
    has_one :sale_offer, class_name: "Horses::SaleOffer", inverse_of: :horse, dependent: :delete
    has_many :sales, class_name: "Horses::Sale", inverse_of: :horse, dependent: :delete_all

    has_many :future_events, class_name: "Horses::FutureEvent", inverse_of: :horse, dependent: :delete_all

    enum :gender, Gender::VALUES
    enum :state, { active: "active", retired: "retired", deceased: "deceased", unborn: "unborn" }

    validates :date_of_birth, :age, :gender, :status, presence: true
    validates :date_of_death, comparison: { greater_than_or_equal_to: :date_of_birth }, if: :date_of_death
    validates :name, length: { maximum: Config::Horses.max_name_length }
    validates :age, numericality: { only_integer: true, greater_than_or_equal_to: -1, less_than_or_equal_to: 40 }
    validate :name_required, on: :update
    validates_horse_name :name, on: :update, if: :name_changed?

    before_validation :calculate_age

    scope :game_owned, -> { joins(:owner).where(owner: { name: Config::Game.stable }) }
    scope :not_game_owned, -> { game_owned.invert_where }

    scope :alive, -> { where.not(state: %w[unborn deceased]) }
    scope :retired, -> { where(state: "retired") }
    scope :not_retired, -> { retired.invert_where }
    scope :deceased, -> { where(status: "deceased") }
    scope :not_deceased, -> { where.not(status: "deceased") }
    scope :born, -> { where.not(state: "unborn") }
    scope :unborn, -> { born.invert_where }
    scope :stillborn, -> { deceased.where("date_of_birth = date_of_death") }
    scope :not_stillborn, -> { where(date_of_death: nil).or(where("#{table_name}.date_of_death > #{table_name}.date_of_birth")) }
    scope :created, -> { where(sire_id: nil, dam_id: nil) }
    scope :not_created, -> { created.invert_where }
    scope :female, -> { where(gender: Gender::FEMALE_GENDERS) }
    scope :not_female, -> { where.not(gender: Gender::FEMALE_GENDERS) }
    scope :min_age, ->(age) { where(age: age..) }
    scope :max_age, ->(age) { where(age: ..age) }
    scope :with_age, ->(age) { where(age:) }
    scope :with_yob, ->(year) { where("DATE_PART('Year', #{table_name}.date_of_birth) = ?", year) }
    scope :max_yob, ->(year) { where("DATE_PART('Year', #{table_name}.date_of_birth) <= ?", year) }
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
    scope :order_by_name, ->(dir = "asc") { order(name: dir.to_sym) }
    scope :with_owner, ->(stable) { where(owner: stable) }
    scope :without_lease, -> { where(leaser_id: nil) }
    scope :with_leaser, ->(stable) { where(leaser_id: stable&.id) }
    scope :managed_by, ->(stable) { born.where(manager_id: stable&.id) }
    scope :random_order, -> { order("RANDOM()") }

    alias_method :dead?, :deceased?

    def to_key = [slug]

    def created?
      sire.blank? && dam.blank?
    end

    def female?
      ::Horses::Gender::FEMALE_GENDERS.include?(gender)
    end

    def male?
      !female?
    end

    def unborn?
      state == "unborn"
    end

    def location_bred_name
      location = location_bred.state || location_bred.county
      [location, location_bred.country].join(", ")
    end

    def budget_name
      return name if name.present?

      foal_name = "#{I18n.t("horse.unnamed")} ("
      foal_name += sire_id ? sire.name : I18n.t("horse.created")
      foal_name += " x "
      foal_name += dam_id ? dam.name : I18n.t("horse.created")
      foal_name + ")"
    end

    def name_with_title
      return I18n.t("horse.unnamed") if name.blank?

      list = []
      list << title_abbr if title_abbr.present?
      list << name
      list.join(" ")
    end

    def name_with_boarding_info
      data = race_metadata
      return name if data.blank?

      location = data.racetrack.name
      "#{name} (#{[location, boarding_available_days].join(" - ")})"
    end

    def name_with_owner_fee
      return name_with_title unless stud?

      [name_with_title, manager.name, Game::MoneyFormatter.new(stud_options.stud_fee)].join(" - ")
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

    def calculate_age
      age = if date_of_birth.blank?
        0
      elsif date_of_death
        date_of_death.year - date_of_birth.year
      else
        Date.current.year - date_of_birth.year
      end
      self.age = age
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[id age breeder_id dam_id date_of_birth date_of_death foals_count gender location_bred_id name owner_id sire_id status unborn_foals_count]
    end

    def self.ransackable_associations(_auth_object = nil)
      %w[breeder dam location_bred owner sire race_stats race_metadata race_options race_qualification race_results latest_race_result latest_injury next_foal]
    end

    def self.ransackable_scopes(_auth_object = nil)
      %w[min_age max_age female not_female racehorse_status min_energy max_energy energy_in
        min_fitness max_fitness fitness_in runs_on injury_status min_days_since_last_race max_days_since_last_race
        min_days_since_last_shipment max_days_since_last_shipment min_workouts_since_last_race max_workouts_since_last_race
        location entry_status injury_status min_rest_days_since_last_race max_rest_days_since_last_race
        min_days_since_last_shipment max_days_since_last_shipment min_workouts_since_last_race max_workouts_since_last_race]
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

