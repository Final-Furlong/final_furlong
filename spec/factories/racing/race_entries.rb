FactoryBot.define do
  factory :race_entry, class: "Racing::RaceEntry" do
    horse
    race factory: :race_schedule
    stable { horse.manager }
    date { race.date }
  end
end

# == Schema Information
#
# Table name: race_entries
# Database name: primary
#
#  id                                             :bigint           not null, primary key
#  date                                           :date             not null, indexed, uniquely indexed => [horse_id]
#  equipment                                      :integer          default(0), not null, indexed
#  post_parade                                    :integer          default(0), not null, indexed
#  racing_style(leading,off_pace,midpack,closing) :enum             indexed
#  weight                                         :integer          default(0), not null
#  created_at                                     :datetime         not null
#  updated_at                                     :datetime         not null
#  first_jockey_id                                :bigint           uniquely indexed => [horse_id, second_jockey_id, third_jockey_id], indexed
#  horse_id                                       :bigint           not null, uniquely indexed => [first_jockey_id, second_jockey_id, third_jockey_id], uniquely indexed => [date]
#  jockey_id                                      :bigint           indexed, uniquely indexed => [race_id]
#  odd_id                                         :bigint           indexed
#  race_id                                        :bigint           not null, uniquely indexed => [jockey_id]
#  second_jockey_id                               :bigint           uniquely indexed => [horse_id, first_jockey_id, third_jockey_id], indexed
#  stable_id                                      :bigint           not null, indexed
#  third_jockey_id                                :bigint           uniquely indexed => [horse_id, first_jockey_id, second_jockey_id], indexed
#
# Indexes
#
#  idx_on_horse_id_first_jockey_id_second_jockey_id_th_4d3e2bb186  (horse_id,first_jockey_id,second_jockey_id,third_jockey_id) UNIQUE
#  index_race_entries_on_date                                      (date)
#  index_race_entries_on_equipment                                 (equipment)
#  index_race_entries_on_first_jockey_id                           (first_jockey_id)
#  index_race_entries_on_horse_id_and_date                         (horse_id,date) UNIQUE
#  index_race_entries_on_jockey_id                                 (jockey_id)
#  index_race_entries_on_odd_id                                    (odd_id)
#  index_race_entries_on_post_parade                               (post_parade)
#  index_race_entries_on_race_id_and_jockey_id                     (race_id,jockey_id) UNIQUE
#  index_race_entries_on_racing_style                              (racing_style)
#  index_race_entries_on_second_jockey_id                          (second_jockey_id)
#  index_race_entries_on_stable_id                                 (stable_id)
#  index_race_entries_on_third_jockey_id                           (third_jockey_id)
#
# Foreign Keys
#
#  fk_rails_...  (first_jockey_id => jockeys.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (jockey_id => jockeys.id)
#  fk_rails_...  (odd_id => race_odds.id)
#  fk_rails_...  (race_id => race_schedules.id)
#  fk_rails_...  (second_jockey_id => jockeys.id)
#  fk_rails_...  (stable_id => stables.id)
#  fk_rails_...  (third_jockey_id => jockeys.id)
#

