module Racing
  class FutureRaceEntry < ApplicationRecord
    include FlagShihTzu

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :race, class_name: "Racing::RaceSchedule"
    belongs_to :first_jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :second_jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :third_jockey, class_name: "Racing::Jockey", optional: true

    validates :date, presence: true
    validates :auto_enter, :auto_ship, :ship_when_entries_open,
      :ship_when_horse_is_entered, :ship_only_if_horse_is_entered,
      inclusion: { in: [true, false] }
    validates :horse_id, uniqueness: { scope: :date }

    has_flags 1 => :blinkers,
      2 => :shadow_roll,
      3 => :wraps,
      4 => :figure_8,
      5 => :no_whip,
      :column => "equipment"
  end
end

# == Schema Information
#
# Table name: future_race_entries
# Database name: primary
#
#  id                                             :bigint           not null, primary key
#  auto_enter                                     :boolean          default(FALSE), not null, indexed
#  auto_ship                                      :boolean          default(FALSE), not null, indexed
#  date                                           :date             not null, indexed, uniquely indexed => [horse_id]
#  equipment                                      :integer          default(0), not null, indexed
#  racing_style(leading,off_pace,midpack,closing) :enum             indexed
#  ship_date                                      :date             indexed
#  ship_mode(road, air)                           :enum             indexed
#  ship_only_if_horse_is_entered                  :boolean          default(FALSE), not null, indexed
#  ship_when_entries_open                         :boolean          default(FALSE), not null, indexed
#  ship_when_horse_is_entered                     :boolean          default(FALSE), not null, indexed
#  created_at                                     :datetime         not null
#  updated_at                                     :datetime         not null
#  first_jockey_id                                :bigint           indexed
#  horse_id                                       :bigint           not null, uniquely indexed => [date]
#  race_id                                        :bigint           not null, indexed
#  second_jockey_id                               :bigint           indexed
#  third_jockey_id                                :bigint           indexed
#
# Indexes
#
#  index_future_race_entries_on_auto_enter                     (auto_enter)
#  index_future_race_entries_on_auto_ship                      (auto_ship)
#  index_future_race_entries_on_date                           (date)
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
#  index_future_race_entries_on_third_jockey_id                (third_jockey_id)
#
# Foreign Keys
#
#  fk_rails_...  (first_jockey_id => jockeys.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (race_id => race_schedules.id)
#  fk_rails_...  (second_jockey_id => jockeys.id)
#  fk_rails_...  (third_jockey_id => jockeys.id)
#

