FactoryBot.define do
  factory :jockey, class: "Racing::Jockey" do
    legacy_id { rand(1..10_000) }
    date_of_birth { 30.years.ago }
    first_name { "John" }
    last_name { "Smith" }
    gender { "male" }
    height_in_inches { 59 }
    weight { 75 }
    jockey_type { "flat" }
    status { "veteran" }
    acceleration { rand(1..10) }
    consistency { rand(1..10) }
    courage { rand(1..10) }
    leading { rand(1..10) }
    off_pace { rand(1..10) }
    midpack { rand(1..10) }
    closing { rand(1..10) }
    dirt { rand(1..10) }
    turf { rand(1..10) }
    fast { rand(1..10) }
    good { rand(1..10) }
    wet { rand(1..10) }
    slow { rand(1..10) }
    steeplechase { rand(1..10) }
    break_speed { rand(1..5) }
    min_speed { rand(1..5) }
    average_speed { rand(1..5) }
    max_speed { rand(1..5) }
    turning { rand(1..5) }
    experience { 0 }
    experience_rate { rand(1..5).fdiv(10) }
    loaf_threshold { rand(1..10) }
    looking { 20 }
    pissy { rand(1..10) }
    rating { rand(1..10) }
    strength { rand(1..10) }
    traffic { rand(1..10) }
    whip_seconds { rand(1..10) }
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
#  male_only                                                                                                      :boolean          default(FALSE), not null, indexed
#  name                                                                                                           :string           indexed
#  number                                                                                                         :integer          default(1), not null, indexed
#  purse                                                                                                          :integer          default(0), not null, indexed
#  qualification_required                                                                                         :boolean          default(FALSE), not null, indexed
#  race_type(maiden, claiming, starter_allowance, nw1_allowance, nw2_allowance, nw3_allowance, allowance, stakes) :enum             default("maiden"), not null, indexed
#  created_at                                                                                                     :datetime         not null
#  updated_at                                                                                                     :datetime         not null
#  surface_id                                                                                                     :uuid             not null, indexed
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
#  index_race_schedules_on_purse                   (purse)
#  index_race_schedules_on_qualification_required  (qualification_required)
#  index_race_schedules_on_race_type               (race_type)
#  index_race_schedules_on_surface_id              (surface_id)
#
# Foreign Keys
#
#  fk_rails_...  (surface_id => track_surfaces.id)
#

