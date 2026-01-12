module Racing
  class RaceResultHorse < ApplicationRecord
    include FlagShihTzu

    self.table_name = "race_result_horses"

    belongs_to :race, class_name: "Racing::RaceResult", inverse_of: :horses
    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :race_result_finishes
    belongs_to :jockey, class_name: "Racing::Jockey", optional: true, inverse_of: :race_result_horses
    belongs_to :odd, class_name: "Racing::Odd", optional: true, inverse_of: :race_result_horses

    validates :legacy_horse_id, :post_parade, :finish_position, :positions, :margins, :equipment,
      :speed_factor, :weight, presence: true
    validates :post_parade, :finish_position, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 14 }
    validates :speed_factor, :weight, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :legacy_horse_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    scope :by_finish, ->(position) { where(finish_position: position) }
    scope :by_max_finish, ->(position) { where(finish_position: ..position) }
    scope :by_date, ->(date) { joins(:race).merge(RaceResult.by_date(date)) }
    scope :by_year, ->(year) { joins(:race).merge(RaceResult.by_year(year).ordered_by_date) }

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

