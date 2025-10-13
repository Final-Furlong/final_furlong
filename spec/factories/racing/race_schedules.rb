FactoryBot.define do
  factory :race_schedule, class: "Racing::RaceSchedule" do
    age { "2" }
    date { Date.current }
    day_number { 1 }
    distance { 6.5 }
    female_only { false }
    grade { nil }
    name { nil }
    number { 1 }
    purse { 20_000 }
    race_type { "maiden" }
    track_surface
  end
end

# == Schema Information
#
# Table name: race_schedules
#
#  id                                                                                                             :uuid             not null, primary key
#  age(2, 2+, 3, 3+, 4, 4+)                                                                                       :enum             default("2"), not null, indexed
#  claiming_price                                                                                                 :integer
#  date                                                                                                           :date             not null, indexed
#  day_number                                                                                                     :integer          default(1), not null, indexed
#  distance                                                                                                       :decimal(3, 1)    default(5.0), not null, indexed
#  female_only                                                                                                    :boolean          default(FALSE), not null, indexed
#  grade(Ungraded, Grade 3, Grade 2, Grade 1)                                                                     :enum             indexed
#  name                                                                                                           :string           indexed
#  number                                                                                                         :integer          default(1), not null, indexed
#  purse                                                                                                          :integer          default(0), not null, indexed
#  race_type(maiden, claiming, starter_allowance, nw1_allowance, nw2_allowance, nw3_allowance, allowance, stakes) :enum             default("maiden"), not null, indexed
#  created_at                                                                                                     :datetime         not null
#  updated_at                                                                                                     :datetime         not null
#  surface_id                                                                                                     :uuid             not null, indexed
#
# Indexes
#
#  index_race_schedules_on_age          (age)
#  index_race_schedules_on_date         (date)
#  index_race_schedules_on_day_number   (day_number)
#  index_race_schedules_on_distance     (distance)
#  index_race_schedules_on_female_only  (female_only)
#  index_race_schedules_on_grade        (grade)
#  index_race_schedules_on_name         (name)
#  index_race_schedules_on_number       (number)
#  index_race_schedules_on_purse        (purse)
#  index_race_schedules_on_race_type    (race_type)
#  index_race_schedules_on_surface_id   (surface_id)
#
# Foreign Keys
#
#  fk_rails_...  (surface_id => track_surfaces.id)
#

