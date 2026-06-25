module Horses::Horse::Raceable
  extend ActiveSupport::Concern

  included do
    has_many :race_result_finishes, class_name: "Racing::RaceResultHorse", inverse_of: :horse, dependent: :destroy
    has_many :race_results, class_name: "Racing::RaceResult", source: :race, through: :race_result_finishes
    has_one :latest_race_result_finish, -> { order id: :desc }, class_name:
      "Racing::RaceResultHorse", inverse_of: :horse, dependent: :destroy
    has_one :latest_race_result, class_name: "Racing::RaceResult", through: :latest_race_result_finish, source: :race
    has_many :workouts, class_name: "Workouts::Workout", inverse_of: :horse, dependent: :destroy
    has_many :workout_stats, class_name: "Workouts::Stat", dependent: :delete_all
    has_many :jump_trials, class_name: "Workouts::JumpTrial", inverse_of: :horse, dependent: :delete_all
    has_one :race_options, class_name: "Racing::RaceOption", dependent: :delete
    has_one :racing_stats, class_name: "Racing::RacingStats", dependent: :delete
    # rubocop:disable Rails/HasManyOrHasOneDependent
    has_many :race_records, class_name: "Racing::RaceRecord", inverse_of: :horse
    has_many :annual_race_records, class_name: "Racing::AnnualRaceRecord", inverse_of: :horse
    has_one :lifetime_race_record, class_name: "Racing::LifetimeRaceRecord", inverse_of: :horse
    has_one :condition_race_record, class_name: "Racing::ConditionRaceRecord", inverse_of: :horse
    has_one :distance_race_record, class_name: "Racing::DistanceRaceRecord", inverse_of: :horse
    has_many :equipment_race_records, class_name: "Racing::EquipmentRaceRecord", inverse_of: :horse
    has_many :location_race_records, class_name: "Racing::LocationRaceRecord", inverse_of: :horse
    has_one :race_type_race_record, class_name: "Racing::RaceTypeRaceRecord", inverse_of: :horse
    has_one :surface_race_record, class_name: "Racing::SurfaceRaceRecord", inverse_of: :horse
    has_one :race_qualification, class_name: "Racing::RaceQualification"
    # rubocop:enable Rails/HasManyOrHasOneDependent

    has_one :training_schedules_horse, class_name: "Racing::TrainingScheduleHorse", dependent: :destroy
    has_one :training_schedule, class_name: "Racing::TrainingSchedule", through: :training_schedules_horse
    has_one :current_boarding, -> { where(end_date: nil) }, class_name: "Horses::Boarding", inverse_of: :horse, dependent: :delete
    has_many :boardings, -> { where.not(end_date: nil) }, class_name: "Horses::Boarding", inverse_of: :horse, dependent: :delete_all
    has_one :next_race_entry, -> { order date: :asc }, class_name: "Racing::RaceEntry", inverse_of: :horse, dependent: :destroy
    has_many :race_entries, class_name: "Racing::RaceEntry", inverse_of: :horse, dependent: :destroy
    has_many :future_race_entries, class_name: "Racing::FutureRaceEntry", inverse_of: :horse, dependent: :delete_all
    has_many :racing_shipments, class_name: "Shipping::RacehorseShipment", dependent: :delete_all
    has_many :jockey_relationships, class_name: "Racing::HorseJockeyRelationship", dependent: :delete_all
    has_one :race_metadata, class_name: "Racing::RacehorseMetadata", dependent: :delete
    has_one :breeders_cup_nomination, class_name: "Racing::BreedersCupNomination", inverse_of: :horse, dependent: :delete
    has_one :supplemental_breeders_cup_nomination, class_name: "Racing::SupplementalBreedersCupNomination", inverse_of: :horse, dependent: :delete
    has_many :eclipse_awards, class_name: "Game::EclipseAward", inverse_of: :awardable, dependent: :delete_all
    has_many :race_series_wins, class_name: "Racing::RaceSeriesWinner", inverse_of: :horse, dependent: :delete_all
    # rubocop:disable Rails/HasManyOrHasOneDependent
    has_one :breeders_cup_juvenile_qualification, class_name: "Racing::Qualifications::BreedersCupJuvenile", inverse_of: :horse
    has_one :breeders_cup_juvenile_fillies_qualification, class_name: "Racing::Qualifications::BreedersCupJuvenileFilly", inverse_of: :horse
    has_one :breeders_cup_juvenile_turf_qualification, class_name: "Racing::Qualifications::BreedersCupJuvenileTurf", inverse_of: :horse
    has_one :breeders_cup_juvenile_turf_fillies_qualification, class_name: "Racing::Qualifications::BreedersCupJuvenileTurfFilly", inverse_of: :horse
    has_one :breeders_cup_sprint_qualification, class_name: "Racing::Qualifications::BreedersCupSprint", inverse_of: :horse
    has_one :breeders_cup_turf_sprint_qualification, class_name: "Racing::Qualifications::BreedersCupTurfSprint", inverse_of: :horse
    has_one :breeders_cup_mile_qualification, class_name: "Racing::Qualifications::BreedersCupMile", inverse_of: :horse
    has_one :breeders_cup_dirt_mile_qualification, class_name: "Racing::Qualifications::BreedersCupDirtMile", inverse_of: :horse
    has_one :breeders_cup_turf_qualification, class_name: "Racing::Qualifications::BreedersCupTurf", inverse_of: :horse
    has_one :breeders_cup_classic_qualification, class_name: "Racing::Qualifications::BreedersCupClassic", inverse_of: :horse
    has_one :breeders_cup_filly_and_mare_sprint_qualification, class_name: "Racing::Qualifications::BreedersCupFillyAndMareSprint", inverse_of: :horse
    has_one :breeders_cup_filly_and_mare_turf_qualification, class_name: "Racing::Qualifications::BreedersCupFillyAndMareTurf", inverse_of: :horse
    has_one :breeders_cup_distaff_qualification, class_name: "Racing::Qualifications::BreedersCupDistaff", inverse_of: :horse
    has_one :breeders_cup_sc_sprint_qualification, class_name: "Racing::Qualifications::BreedersCupSteeplechaseSprint", inverse_of: :horse
    has_one :breeders_cup_sc_classic_qualification, class_name: "Racing::Qualifications::BreedersCupSteeplechaseClassic", inverse_of: :horse
    has_one :breeders_cup_sc_endurance_qualification, class_name: "Racing::Qualifications::BreedersCupSteeplechaseEndurance", inverse_of: :horse
    has_one :breeders_cup_sc_distaff_qualification, class_name: "Racing::Qualifications::BreedersCupSteeplechaseDistaff", inverse_of: :horse
    has_one :breeders_cup_sc_distaff_endurance_qualification, class_name: "Racing::Qualifications::BreedersCupSteeplechaseDistaffEndurance", inverse_of: :horse
    has_one :breeders_series_2yo_dirt_qualification, class_name: "Racing::Qualifications::BreedersSeries2yoDirt", inverse_of: :horse
    has_one :breeders_series_2yo_filly_dirt_qualification, class_name: "Racing::Qualifications::BreedersSeries2yoFilliesDirt", inverse_of: :horse
    has_one :breeders_series_2yo_turf_qualification, class_name: "Racing::Qualifications::BreedersSeries2yoTurf", inverse_of: :horse
    has_one :breeders_series_2yo_filly_turf_qualification, class_name: "Racing::Qualifications::BreedersSeries2yoFilliesTurf", inverse_of: :horse
    has_one :breeders_series_3yo_dirt_qualification, class_name: "Racing::Qualifications::BreedersSeries3yoDirt", inverse_of: :horse
    has_one :breeders_series_3yo_filly_dirt_qualification, class_name: "Racing::Qualifications::BreedersSeries3yoFilliesDirt", inverse_of: :horse
    has_one :breeders_series_3yo_turf_qualification, class_name: "Racing::Qualifications::BreedersSeries3yoTurf", inverse_of: :horse
    has_one :breeders_series_3yo_filly_turf_qualification, class_name: "Racing::Qualifications::BreedersSeries3yoFilliesTurf", inverse_of: :horse
    has_one :breeders_series_4yo_dirt_qualification, class_name: "Racing::Qualifications::BreedersSeries4yoDirt", inverse_of: :horse
    has_one :breeders_series_4yo_mare_dirt_qualification, class_name: "Racing::Qualifications::BreedersSeries4yoMaresDirt", inverse_of: :horse
    has_one :breeders_series_4yo_turf_qualification, class_name: "Racing::Qualifications::BreedersSeries4yoTurf", inverse_of: :horse
    has_one :breeders_series_4yo_mare_turf_qualification, class_name: "Racing::Qualifications::BreedersSeries4yoMaresTurf", inverse_of: :horse
    has_one :breeders_series_steeplechase_qualification, class_name: "Racing::Qualifications::BreedersSeriesSteeplechase", inverse_of: :horse
    has_one :breeders_series_filly_steeplechase_qualification, class_name: "Racing::Qualifications::BreedersSeriesFilliesSteeplechase", inverse_of: :horse
    # rubocop:enable Rails/HasManyOrHasOneDependent

    scope :racehorse_status, ->(status) {
      joins(:race_qualification).merge(::Racing::RaceQualification.send(:qualified_for, status))
    }
    scope :sort_by_race_qualification_asc, -> { joins(:race_qualification).merge(::Racing::RaceQualification.sort_by_qualified_asc) }
    scope :sort_by_race_qualification_desc, -> { joins(:race_qualification).merge(::Racing::RaceQualification.sort_by_qualified_desc) }
    scope :sort_by_race_metadata_race_nulls_last_asc, -> { joins(:race_metadata).order("race_metadata.last_raced_at ASC NULLS LAST") }
    scope :sort_by_race_metadata_race_nulls_last_desc, -> { joins(:race_metadata).order("race_metadata.last_raced_at DESC NULLS LAST") }
    scope :sort_by_race_metadata_injury_nulls_last_asc, -> { joins(:race_metadata).order("race_metadata.last_injured_at ASC NULLS LAST") }
    scope :sort_by_race_metadata_injury_nulls_last_desc, -> { joins(:race_metadata).order("race_metadata.last_injured_at DESC NULLS LAST") }
    scope :sort_by_race_metadata_entry_nulls_last_asc, -> { joins(:race_metadata).order("race_metadata.next_entry_date ASC NULLS LAST") }
    scope :sort_by_race_metadata_entry_nulls_last_desc, -> { joins(:race_metadata).order("race_metadata.next_entry_date DESC NULLS LAST") }
    scope :sort_by_energy_asc, -> { joins(:race_metadata).order("race_metadata.energy_grade ASC") }
    scope :sort_by_energy_desc, -> { joins(:race_metadata).order("race_metadata.energy_grade DESC") }
    scope :sort_by_fitness_asc, -> { joins(:race_metadata).order("race_metadata.fitness_grade ASC") }
    scope :sort_by_fitness_desc, -> { joins(:race_metadata).order("race_metadata.fitness_grade DESC") }
    scope :sort_by_location_asc, -> { joins(:race_metadata).order("race_metadata.location_string ASC") }
    scope :sort_by_location_desc, -> { joins(:race_metadata).order("race_metadata.location_string DESC") }
    scope :location, ->(value) { where(race_metadata: { location_string: value }) }
    scope :min_energy, ->(value) { where(race_metadata: { energy_grade: ::Racing::RacehorseMetadata.min_grade_levels(value) }) }
    scope :max_energy, ->(value) { where(race_metadata: { energy_grade: ::Racing::RacehorseMetadata.max_grade_levels(value) }) }
    scope :energy_in, ->(max_value, min_value) { where(race_metadata: { energy_grade: ::Racing::RacehorseMetadata.grade_levels_range(min_value, max_value) }) }
    scope :min_fitness, ->(value) { where(race_metadata: { fitness_grade: ::Racing::RacehorseMetadata.min_grade_levels(value) }) }
    scope :max_fitness, ->(value) { where(race_metadata: { fitness_grade: ::Racing::RacehorseMetadata.max_grade_levels(value) }) }
    scope :fitness_in, ->(max_value, min_value) { where(race_metadata: { fitness_grade: ::Racing::RacehorseMetadata.grade_levels_range(min_value, max_value) }) }
    scope :entry_status, ->(status) {
      case status.to_s.downcase
      when "current"
        where.associated(:race_entries)
      when "scheduled"
        where.missing(:race_entries).where.associated(:future_race_entries)
      else
        where.missing(:race_entries).where.missing(:future_race_entries)
      end
    }
    scope :runs_on, ->(value) {
      case value.to_s.downcase
      when "dirt"
        joins(:race_options).merge(::Racing::RaceOption.dirt)
      when "turf"
        joins(:race_options).merge(::Racing::RaceOption.turf)
      else
        joins(:race_options).merge(::Racing::RaceOption.jump)
      end
    }
    scope :runs_on_dirt, -> { runs_on("dirt") }
    scope :runs_on_turf, -> { runs_on("turf") }
    scope :runs_on_steeplechase, -> { runs_on("sc") }
    scope :min_days_since_last_race, ->(days) { joins(:race_metadata).where("last_raced_at IS NULL OR last_raced_at < ?", Date.current - days.to_i.days) }
    scope :min_rest_days_since_last_race, ->(value) { joins(:race_metadata).where(race_metadata: { rest_days_since_last_race: value.to_i.. }) }
    scope :max_rest_days_since_last_race, ->(value) { joins(:race_metadata).where(race_metadata: { rest_days_since_last_race: ..value.to_i }) }
    scope :min_days_since_last_shipment, ->(days) { joins(:race_metadata).where("last_shipped_at IS NULL OR last_shipped_at < ?", Date.current - days.to_i.days) }
    scope :max_days_since_last_shipment, ->(days) { joins(:race_metadata).where(race_metadata: { last_shipped_at: (Date.current - days.to_i.days).. }) }
    scope :min_workouts_since_last_race, ->(value) { joins(:race_metadata).where(race_metadata: { workouts_since_last_race: value.to_i.. }) }
    scope :max_workouts_since_last_race, ->(value) { joins(:race_metadata).where(race_metadata: { workouts_since_last_race: ..value.to_i }) }
    scope :min_days_since_last_injury, ->(days) { joins(:race_metadata).where("last_injured_at IS NULL OR last_injured_at < ?", Date.current - days.to_i.days) }
    scope :max_days_since_last_injury, ->(days) { joins(:race_metadata).where(race_metadata: { last_injured_at: (Date.current - days.to_i.days).. }) }

    delegate :track_record, to: :lifetime_race_record, allow_nil: true

    def at_farm?
      race_metadata.at_home?
    end

    delegate :in_transit?, to: :race_metadata

    def current_location_name
      race_metadata.location.name
    end

    def last_shipment
      racing_shipments.not_future.order(arrival_date: :desc).first
    end

    def boarding_available_days
      data = race_metadata
      return 0 if data.blank?

      current_year_days = boardings.current_year.where(location_id: data.location_id).sum(:days)
      Config::Boarding.max_yearly_days - current_year_days.to_i
    end

    def breeders_series_types
      case race_options.racehorse_type
      when "flat"
        case age
        when 2
          female? ? %w[2yo_filly_dirt 2yo_filly_turf] : %w[2yo_dirt 2yo_turf]
        when 3
          female? ? %w[3yo_filly_dirt 3yo_filly_turf] : %w[3yo_dirt 3yo_turf]
        else
          female? ? %w[4yo_mare_dirt 4yo_mare_turf] : %w[4yo_dirt 4yo_turf]
        end
      else
        female? ? ["steeplechase_filly"] : ["steeplechase"]
      end
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
#  date_of_birth                                                                                                      :date             not null, indexed, indexed => [leaser_id], indexed => [owner_id]
#  date_of_death                                                                                                      :date             indexed
#  dosage_abbr                                                                                                        :string
#  gender(colt, filly, mare, stallion, gelding)                                                                       :enum             not null, indexed, indexed => [status]
#  name                                                                                                               :string(18)       indexed, indexed => [status]
#  slug                                                                                                               :string           indexed
#  status(unborn, weanling, yearling, racehorse, broodmare, stud, retired, retired_broodmare, retired_stud, deceased) :enum             default("unborn"), not null, indexed => [owner_id], indexed => [age], indexed => [breeder_id], indexed => [dam_id], indexed => [gender], indexed => [leaser_id], indexed => [name], indexed => [owner_id], indexed => [sire_id]
#  title_abbr                                                                                                         :string
#  created_at                                                                                                         :datetime         not null
#  updated_at                                                                                                         :datetime         not null
#  breeder_id                                                                                                         :bigint           not null, indexed, indexed => [status]
#  dam_id                                                                                                             :bigint           indexed, indexed => [status]
#  leaser_id                                                                                                          :bigint           indexed => [date_of_birth], indexed, indexed => [status]
#  legacy_id                                                                                                          :integer          indexed
#  location_bred_id                                                                                                   :bigint           not null, indexed
#  manager_id                                                                                                         :bigint           indexed
#  owner_id                                                                                                           :bigint           not null, indexed => [date_of_birth], indexed => [status], indexed => [status]
#  public_id                                                                                                          :string(12)       indexed
#  sire_id                                                                                                            :bigint           indexed, indexed => [status]
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
#  index_horses_on_manager_id                   (manager_id)
#  index_horses_on_name                         (name)
#  index_horses_on_owner_id_and_status          (owner_id,status)
#  index_horses_on_public_id                    (public_id)
#  index_horses_on_sire_id                      (sire_id)
#  index_horses_on_slug                         (slug)
#  index_horses_on_status_and_age               (status,age)
#  index_horses_on_status_and_breeder_id        (status,breeder_id)
#  index_horses_on_status_and_dam_id            (status,dam_id)
#  index_horses_on_status_and_gender            (status,gender)
#  index_horses_on_status_and_leaser_id         (status,leaser_id)
#  index_horses_on_status_and_name              (status,name)
#  index_horses_on_status_and_owner_id          (status,owner_id)
#  index_horses_on_status_and_sire_id           (status,sire_id)
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

