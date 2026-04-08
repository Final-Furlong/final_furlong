FactoryBot.define do
  factory :future_race_entry, class: "Racing::FutureRaceEntry" do
    horse
    race factory: :race_schedule
    stable { horse.manager }
    date { race.date }
  end
end

# == Schema Information
#
# Table name: future_race_entries
# Database name: primary
#
#  id                                                                                                                                           :bigint           not null, primary key
#  auto_enter                                                                                                                                   :boolean          default(FALSE), not null, indexed
#  auto_ship                                                                                                                                    :boolean          default(FALSE), not null, indexed
#  date                                                                                                                                         :date             not null, indexed, uniquely indexed => [horse_id]
#  entry_error(race_full,not_at_track,already_entered,not_qualified,max_entries,cannot_afford_shipping,cannot_ship_in_time,cannot_afford_entry) :enum             indexed
#  entry_status(entered,errored,skipped)                                                                                                        :enum             indexed
#  equipment                                                                                                                                    :integer          default(0), not null, indexed
#  racing_style(leading,off_pace,midpack,closing)                                                                                               :enum             indexed
#  ship_date                                                                                                                                    :date             indexed
#  ship_mode(road, air)                                                                                                                         :enum             indexed
#  ship_only_if_horse_is_entered                                                                                                                :boolean          default(FALSE), not null, indexed
#  ship_when_entries_open                                                                                                                       :boolean          default(FALSE), not null, indexed
#  ship_when_horse_is_entered                                                                                                                   :boolean          default(FALSE), not null, indexed
#  created_at                                                                                                                                   :datetime         not null
#  updated_at                                                                                                                                   :datetime         not null
#  first_jockey_id                                                                                                                              :bigint           indexed
#  horse_id                                                                                                                                     :bigint           not null, uniquely indexed => [date]
#  race_id                                                                                                                                      :bigint           not null, indexed
#  second_jockey_id                                                                                                                             :bigint           indexed
#  stable_id                                                                                                                                    :bigint           not null, indexed
#  third_jockey_id                                                                                                                              :bigint           indexed
#
# Indexes
#
#  index_future_race_entries_on_auto_enter                     (auto_enter)
#  index_future_race_entries_on_auto_ship                      (auto_ship)
#  index_future_race_entries_on_date                           (date)
#  index_future_race_entries_on_entry_error                    (entry_error)
#  index_future_race_entries_on_entry_status                   (entry_status)
#  index_future_race_entries_on_equipment                      (equipment)
#  index_future_race_entries_on_first_jockey_id                (first_jockey_id)
#  index_future_race_entries_on_horse_id_and_date              (horse_id,date) UNIQUE
#  index_future_race_entries_on_race_id                        (race_id)
#  index_future_race_entries_on_racing_style                   (racing_style)
#  index_future_race_entries_on_second_jockey_id               (second_jockey_id)
#  index_future_race_entries_on_ship_date                      (ship_date)
#  index_future_race_entries_on_ship_mode                      (ship_mode)
#  index_future_race_entries_on_ship_only_if_horse_is_entered  (ship_only_if_horse_is_entered)
#  index_future_race_entries_on_ship_when_entries_open         (ship_when_entries_open)
#  index_future_race_entries_on_ship_when_horse_is_entered     (ship_when_horse_is_entered)
#  index_future_race_entries_on_stable_id                      (stable_id)
#  index_future_race_entries_on_third_jockey_id                (third_jockey_id)
#
# Foreign Keys
#
#  fk_rails_...  (first_jockey_id => jockeys.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (race_id => race_schedules.id)
#  fk_rails_...  (second_jockey_id => jockeys.id)
#  fk_rails_...  (stable_id => stables.id)
#  fk_rails_...  (third_jockey_id => jockeys.id)
#

