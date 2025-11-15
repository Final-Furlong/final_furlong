FactoryBot.define do
  factory :race_result_horse, class: "Racing::RaceResultHorse" do
    race { association :race_result }
    horse
    legacy_horse_id { horse.legacy_id || Faker::Number.number(digits: 5) }
    post_parade { 1 }
    margins { "1|1|1|1" }
    positions { "1|1|1|1" }
    finish_position { 1 }
    weight { 100 }
    speed_factor { 100 }
  end
end

# == Schema Information
#
# Table name: race_result_horses
# Database name: primary
#
#  id              :bigint           not null, primary key
#  equipment       :integer          default(0), not null
#  finish_position :integer          default(1), not null, indexed
#  fractions       :string
#  margins         :string           not null
#  positions       :string           not null
#  post_parade     :integer          default(1), not null
#  speed_factor    :integer          default(0), not null, indexed
#  weight          :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  horse_id        :bigint           not null, indexed
#  jockey_id       :bigint           indexed
#  legacy_horse_id :integer          default(0), not null, indexed
#  odd_id          :bigint           indexed
#  race_id         :bigint           not null, indexed
#
# Indexes
#
#  index_race_result_horses_on_finish_position  (finish_position)
#  index_race_result_horses_on_horse_id         (horse_id)
#  index_race_result_horses_on_jockey_id        (jockey_id)
#  index_race_result_horses_on_legacy_horse_id  (legacy_horse_id)
#  index_race_result_horses_on_odd_id           (odd_id)
#  index_race_result_horses_on_race_id          (race_id)
#  index_race_result_horses_on_speed_factor     (speed_factor)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...  (jockey_id => jockeys.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...  (odd_id => race_results.id) ON DELETE => nullify ON UPDATE => cascade
#  fk_rails_...  (race_id => race_results.id) ON DELETE => cascade ON UPDATE => cascade
#

