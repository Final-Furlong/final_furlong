class Racing::RaceSchedule < ApplicationRecord
  self.table_name = "race_schedules"
  self.ignored_columns += ["old_id"]

  RACE_TYPES = %w[
    maiden
    claiming
    starter_allowance
    nw1_allowance
    nw2_allowance
    nw3_allowance
    allowance
    stakes
  ].freeze
  RACE_AGES = %w[2 2+ 3 3+ 4 4+].freeze
  RACE_GRADES = ["Ungraded", "Grade 3", "Grade 2", "Grade 1"].freeze

  belongs_to :track_surface, class_name: "Racing::TrackSurface", foreign_key: :surface_id, inverse_of: :scheduled_races

  validates :day_number, :date, :number, :race_type, :age, :distance, :purse, presence: true
  validates :day_number, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 105 }, allow_nil: true
  validates :number, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 50 }
  validates :race_type, inclusion: { in: RACE_TYPES }
  validates :age, inclusion: { in: RACE_AGES }
  validates :male_only, :female_only, :qualification_required, inclusion: { in: [true, false] }
  validates :distance, numericality: { greater_than_or_equal_to: 5.0, less_than_or_equal_to: 24.0 }
  validates :grade, inclusion: { in: RACE_GRADES }, allow_blank: true
  validates :name, presence: true, if: :grade
  validates :purse, numericality: { only_integer: true, greater_than_or_equal_to: 10_000, less_than_or_equal_to: 20_000_000 }
  validates :claiming_price, numericality: { only_integer: true, greater_than_or_equal_to: 5_000, less_than_or_equal_to: 50_000 }, if: :claiming?

  delegate :racetrack, to: :track_surface

  def claiming?
    race_type.to_s.casecmp("claiming").zero?
  end
end

# == Schema Information
#
# Table name: race_schedules
# Database name: primary
#
#  id                                                                                                             :bigint           not null, primary key
#  age(2, 2+, 3, 3+, 4, 4+)                                                                                       :enum             default("2"), not null, indexed
#  claiming_price                                                                                                 :integer
#  date                                                                                                           :date             not null, indexed
#  day_number                                                                                                     :integer          default(1), not null, indexed
#  distance                                                                                                       :decimal(3, 1)    default(5.0), not null, indexed
#  female_only                                                                                                    :boolean          default(FALSE), not null, indexed
#  grade(Ungraded, Grade 3, Grade 2, Grade 1)                                                                     :enum             indexed
#  male_only                                                                                                      :boolean          default(FALSE), not null, indexed
#  name                                                                                                           :string           indexed
#  number                                                                                                         :integer          default(1), not null, indexed
#  purse                                                                                                          :bigint           default(0), not null
#  qualification_required                                                                                         :boolean          default(FALSE), not null, indexed
#  race_type(maiden, claiming, starter_allowance, nw1_allowance, nw2_allowance, nw3_allowance, allowance, stakes) :enum             default("maiden"), not null, indexed
#  created_at                                                                                                     :datetime         not null
#  updated_at                                                                                                     :datetime         not null
#  surface_id                                                                                                     :bigint           not null, indexed
#
# Indexes
#
#  index_race_schedules_on_age                     (age)
#  index_race_schedules_on_date                    (date)
#  index_race_schedules_on_day_number              (day_number)
#  index_race_schedules_on_distance                (distance)
#  index_race_schedules_on_female_only             (female_only)
#  index_race_schedules_on_grade                   (grade)
#  index_race_schedules_on_male_only               (male_only)
#  index_race_schedules_on_name                    (name)
#  index_race_schedules_on_number                  (number)
#  index_race_schedules_on_qualification_required  (qualification_required)
#  index_race_schedules_on_race_type               (race_type)
#  index_race_schedules_on_surface_id              (surface_id)
#
# Foreign Keys
#
#  fk_rails_...  (surface_id => track_surfaces.id) ON DELETE => restrict ON UPDATE => cascade
#

