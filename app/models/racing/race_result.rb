module Racing
  class RaceResult < ApplicationRecord
    self.table_name = "race_results"

    SPLITS = %w[4Q 2F].freeze

    belongs_to :track_surface, class_name: "Racing::TrackSurface", foreign_key: :surface_id, inverse_of: :completed_races

    has_many :horses, class_name: "Racing::RaceResultHorse", inverse_of: :race, dependent: :delete_all

    validates :date, :number, :race_type, :age, :distance, :purse, :time_in_seconds, presence: true
    validates :number, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 50 }
    validates :time_in_seconds, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1_000 }
    validates :split, inclusion: { in: SPLITS }
    validates :race_type, inclusion: { in: Racing::RaceSchedule::RACE_TYPES }
    validates :age, inclusion: { in: Racing::RaceSchedule::RACE_AGES }
    validates :condition, inclusion: { in: Racing::TrackSurface::CONDITIONS }
    validates :male_only, inclusion: { in: [true, false] }
    validates :female_only, inclusion: { in: [true, false] }
    validates :distance, numericality: { greater_than_or_equal_to: 5.0, less_than_or_equal_to: 24.0 }
    validates :grade, inclusion: { in: Racing::RaceSchedule::RACE_GRADES }, allow_blank: true
    validates :name, presence: true, if: :grade
    validates :purse, numericality: { only_integer: true, greater_than_or_equal_to: 10_000, less_than_or_equal_to: 20_000_000 }
    validates :claiming_price, numericality: { only_integer: true, greater_than_or_equal_to: 5_000, less_than_or_equal_to: 50_000 }, if: :claiming?

    scope :by_year, ->(year) { where("CAST(TO_CHAR(date, 'YYYY') AS integer) = ?", year) }
    scope :by_track, ->(track) { joins(:track_surface).merge(TrackSurface.send(track.to_sym)) }
    scope :by_type, ->(type) { where(race_type: type) }

    delegate :racetrack, to: :track_surface

    def claiming?
      race_type.to_s.casecmp("claiming").zero?
    end
  end
end

# == Schema Information
#
# Table name: race_results
#
#  id                                                                                                             :bigint           not null, primary key
#  age(2, 2+, 3, 3+, 4, 4+)                                                                                       :enum             default("2"), not null, indexed
#  claiming_price                                                                                                 :integer
#  condition(fast, good, slow, wet)                                                                               :enum             indexed
#  date                                                                                                           :date             not null, indexed
#  distance                                                                                                       :decimal(3, 1)    default(5.0), not null, indexed
#  female_only                                                                                                    :boolean          default(FALSE), not null
#  grade(Ungraded, Grade 3, Grade 2, Grade 1)                                                                     :enum             indexed
#  male_only                                                                                                      :boolean          default(FALSE), not null
#  name                                                                                                           :string           indexed
#  number                                                                                                         :integer          default(1), not null, indexed
#  purse                                                                                                          :bigint           default(0), not null, indexed
#  race_type(maiden, claiming, starter_allowance, nw1_allowance, nw2_allowance, nw3_allowance, allowance, stakes) :enum             default("maiden"), not null, indexed
#  slug                                                                                                           :string           indexed
#  split(4Q, 2F)                                                                                                  :enum
#  time_in_seconds                                                                                                :decimal(7, 3)    default(0.0), not null, indexed
#  created_at                                                                                                     :datetime         not null
#  updated_at                                                                                                     :datetime         not null
#  surface_id                                                                                                     :bigint           not null, indexed
#
# Indexes
#
#  index_race_results_on_age              (age)
#  index_race_results_on_condition        (condition)
#  index_race_results_on_date             (date)
#  index_race_results_on_distance         (distance)
#  index_race_results_on_grade            (grade)
#  index_race_results_on_name             (name)
#  index_race_results_on_number           (number)
#  index_race_results_on_old_id           (old_id)
#  index_race_results_on_purse            (purse)
#  index_race_results_on_race_type        (race_type)
#  index_race_results_on_slug             (slug)
#  index_race_results_on_surface_id       (surface_id)
#  index_race_results_on_time_in_seconds  (time_in_seconds)
#
# Foreign Keys
#
#  fk_rails_...  (surface_id => track_surfaces.id) ON DELETE => restrict ON UPDATE => cascade
#

