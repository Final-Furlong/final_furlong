class Racing::RaceSchedule < ApplicationRecord
  include RaceTypeable

  self.table_name = "race_schedules"

  belongs_to :track_surface, class_name: "Racing::TrackSurface", foreign_key: :surface_id, inverse_of: :scheduled_races

  has_many :entries, class_name: "Racing::RaceEntry", inverse_of: :race, dependent: :destroy
  has_many :future_entries, class_name: "Racing::FutureRaceEntry", inverse_of: :race, dependent: :delete_all

  validates :day_number, :date, :number, :race_type, :age, :distance, :purse,
    :entries_count, presence: true
  validates :day_number, :date, :number, :race_type, :age, :distance, :purse, presence: true
  validates :day_number, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 105 }, allow_nil: true
  validates :number, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 50 }
  validates :race_type, inclusion: { in: Config::Racing.all_types }
  validates :age, inclusion: { in: Config::Racing.ages }
  validates :male_only, :female_only, :qualification_required, inclusion: { in: [true, false] }
  validates :distance, numericality: { greater_than_or_equal_to: 5.0, less_than_or_equal_to: 24.0 }
  validates :grade, inclusion: { in: Config::Racing.grades }, allow_blank: true
  validates :name, presence: true, if: :grade
  validates :purse, numericality: { only_integer: true, greater_than_or_equal_to: 10_000, less_than_or_equal_to: 20_000_000 }
  validates :claiming_price, numericality: { only_integer: true, greater_than_or_equal_to: 5_000, less_than_or_equal_to: 50_000 }, if: :claiming?

  delegate :racetrack, to: :track_surface

  scope :future, -> { where("date > ?", Date.current) }
  scope :next_year, -> { where("date > ?", Date.current + 10.months) }
  scope :past, -> { where(date: ...Date.current) }

  def entry_deadline
    date - Config::Game.entry_deadline_days.days
  end

  def entry_limit
    entry_limit = age.start_with?("2") ? Config::Game.entry_limit_2yo : Config::Game.entry_limit_older
    entry_limit += Config::Game.entry_limit_increase_final_day if Date.current == entry_deadline
    entry_limit
  end

  def entry_fee
    purse * Config::Game.entry_fee_percent
  end

  def min_age
    age[0]
  end

  def max_age
    if age.chars.include?("+")
      Config::Racing.max_racing_age
    else
      min_age
    end
  end

  def surface_type
    return "jump" if track_surface.surface.casecmp("steeplechase").zero?

    "flat"
  end

  def surface_name
    track_surface.surface.downcase
  end

  def race_type_string(mobile = false)
    key = "racing.race."
    key += ".mobile." if mobile
    key += race_type.downcase
    value = I18n.t(key)
    if race_type == "stakes"
      value += " ("
      value += mobile ? I18n.t("racing.race.mobile.#{grade.downcase.tr(" ", "_")}") : grade.titleize
      value += ")"
    elsif race_type == "claiming"
      value += " (#{Game::MoneyFormatter.new(claiming_price)})"
    end
    value
  end

  def race_type_sort
    sort = Config::Racing.all_types.find_index(race_type)
    sort += 9 unless %w[maiden claiming].include?(race_type)
    sort += case claiming_price
    when 5000
      1
    when 10_000
      2
    when 15_000
      3
    when 20_000
      4
    when 25_000
      5
    when 30_000
      6
    when 35_000
      7
    when 40_000
      8
    when 50_000
      9
    else
      0
    end
    sort += Config::Racing.grades.find_index(grade) if grade
    sort
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[age date distance female_only grade male_only name number qualification_required race_type surface_id]
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
#  entries_count                                                                                                  :integer          default(0), not null
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

