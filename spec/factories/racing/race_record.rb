FactoryBot.define do
  factory :race_record, class: "Racing::RaceRecord" do
    horse
    year { Date.current.year }
    result_type { "dirt" }
    starts { 4 }
    wins { 0 }
    seconds { 0 }
    thirds { 0 }
    fourths { 0 }
    stakes_starts { 0 }
    stakes_wins { 0 }
    stakes_seconds { 0 }
    stakes_thirds { 0 }
    stakes_fourths { 0 }
    points { 5 }
    earnings { 1_000 }

    trait :jumper do
      result_type { "steeplechase" }
    end
  end
end

# == Schema Information
#
# Table name: jockeys
#
#  id                                   :uuid             not null, primary key
#  acceleration                         :integer          not null
#  average_speed                        :integer          not null
#  break_speed                          :integer          not null
#  closing                              :integer          not null
#  consistency                          :integer          not null
#  courage                              :integer          not null
#  date_of_birth                        :date             not null
#  dirt                                 :integer          not null
#  experience                           :integer          not null
#  experience_rate                      :integer          not null
#  fast                                 :integer          not null
#  first_name                           :string           not null
#  gender(male, female)                 :enum             indexed
#  good                                 :integer          not null
#  height_in_inches                     :integer          not null, indexed
#  jockey_type(flat, jump)              :enum             indexed
#  last_name                            :string           not null
#  leading                              :integer          not null
#  loaf_threshold                       :integer          not null
#  looking                              :integer          not null
#  max_speed                            :integer          not null
#  midpack                              :integer          not null
#  min_speed                            :integer          not null
#  off_pace                             :integer          not null
#  pissy                                :integer          not null
#  rating                               :integer          not null
#  slow                                 :integer          not null
#  status(apprentice, veteran, retired) :enum             indexed
#  steeplechase                         :integer          not null
#  strength                             :integer          not null
#  traffic                              :integer          not null
#  turf                                 :integer          not null
#  turning                              :integer          not null
#  weight                               :integer          not null, indexed
#  wet                                  :integer          not null
#  whip_seconds                         :integer          not null
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  legacy_id                            :integer          not null, indexed
#
# Indexes
#
#  index_jockeys_on_gender            (gender)
#  index_jockeys_on_height_in_inches  (height_in_inches)
#  index_jockeys_on_jockey_type       (jockey_type)
#  index_jockeys_on_legacy_id         (legacy_id)
#  index_jockeys_on_status            (status)
#  index_jockeys_on_weight            (weight)
#

