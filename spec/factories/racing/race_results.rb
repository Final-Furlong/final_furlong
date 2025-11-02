FactoryBot.define do
  factory :race_result, class: "Racing::RaceResult" do
    age { "2" }
    date { Date.current }
    number { 1 }
    distance { 6.5 }
    grade { nil }
    name { nil }
    race_type { "maiden" }
    track_surface
    condition { "fast" }
    purse { 20_000 }
    split { "2F" }
    time_in_seconds { 74.5 }
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

