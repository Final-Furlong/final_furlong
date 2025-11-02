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
# Table name: jockeys
#
#  id                                   :bigint           not null, primary key
#  acceleration                         :integer          not null
#  average_speed                        :integer          not null
#  break_speed                          :integer          not null
#  closing                              :integer          not null
#  consistency                          :integer          not null
#  courage                              :integer          not null
#  date_of_birth                        :date             not null, indexed
#  dirt                                 :integer          not null
#  experience                           :integer          not null
#  experience_rate                      :integer          not null
#  fast                                 :integer          not null
#  first_name                           :string           not null, indexed
#  gender(male, female)                 :enum             indexed
#  good                                 :integer          not null
#  height_in_inches                     :integer          not null, indexed
#  jockey_type(flat, jump)              :enum             indexed
#  last_name                            :string           not null, indexed
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
#  slug                                 :string           indexed
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
#  public_id                            :string(12)       indexed
#
# Indexes
#
#  index_jockeys_on_date_of_birth     (date_of_birth)
#  index_jockeys_on_first_name        (first_name)
#  index_jockeys_on_gender            (gender)
#  index_jockeys_on_height_in_inches  (height_in_inches)
#  index_jockeys_on_jockey_type       (jockey_type)
#  index_jockeys_on_last_name         (last_name)
#  index_jockeys_on_legacy_id         (legacy_id)
#  index_jockeys_on_old_id            (old_id)
#  index_jockeys_on_public_id         (public_id)
#  index_jockeys_on_slug              (slug)
#  index_jockeys_on_status            (status)
#  index_jockeys_on_weight            (weight)
#

