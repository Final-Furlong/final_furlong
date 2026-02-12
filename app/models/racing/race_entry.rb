module Racing
  class RaceEntry < ApplicationRecord
    include Equipmentable

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :race, class_name: "Racing::RaceSchedule"
    belongs_to :jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :first_jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :second_jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :third_jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :odd, class_name: "Racing::Odd", optional: true

    validates :date, :equipment, presence: true
    validates :date, comparison: { greater_than: -> { Date.current } }
    validates :post_parade, numericality: { only_integer: true,
                                            greater_than_or_equal_to: 0,
                                            less_than_or_equal_to: 14 }
    validates :weight, numericality: { only_integer: true }
    validates :racing_style, inclusion: { in: Config::Racing.styles }, allow_nil: true
    validates :horse_id, uniqueness: { scope: :date }

    scope :future, -> { where("date > ?", Date.current) }
    scope :past, -> { where(date: ...Date.current) }

    counter_culture :race, column_name: "entries_count"
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
#  first_jockey_id                                :bigint           indexed
#  horse_id                                       :bigint           not null, uniquely indexed => [date]
#  jockey_id                                      :bigint           indexed
#  odd_id                                         :bigint           indexed
#  race_id                                        :bigint           not null, indexed
#  second_jockey_id                               :bigint           indexed
#  third_jockey_id                                :bigint           indexed
#
# Indexes
#
#  index_race_entries_on_date               (date)
#  index_race_entries_on_equipment          (equipment)
#  index_race_entries_on_first_jockey_id    (first_jockey_id)
#  index_race_entries_on_horse_id_and_date  (horse_id,date) UNIQUE
#  index_race_entries_on_jockey_id          (jockey_id)
#  index_race_entries_on_odd_id             (odd_id)
#  index_race_entries_on_post_parade        (post_parade)
#  index_race_entries_on_race_id            (race_id)
#  index_race_entries_on_racing_style       (racing_style)
#  index_race_entries_on_second_jockey_id   (second_jockey_id)
#  index_race_entries_on_third_jockey_id    (third_jockey_id)
#
# Foreign Keys
#
#  fk_rails_...  (first_jockey_id => jockeys.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (jockey_id => jockeys.id)
#  fk_rails_...  (odd_id => race_odds.id)
#  fk_rails_...  (race_id => race_schedules.id)
#  fk_rails_...  (second_jockey_id => jockeys.id)
#  fk_rails_...  (third_jockey_id => jockeys.id)
#

