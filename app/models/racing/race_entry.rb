module Racing
  class RaceEntry < ApplicationRecord
    include Equipmentable
    include RaceRunnable

    attr_accessor :shipping_mode

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :race, class_name: "Racing::RaceSchedule"
    belongs_to :stable, class_name: "Account::Stable"
    belongs_to :jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :first_jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :second_jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :third_jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :odd, class_name: "Racing::Odd", optional: true
    has_many :claims, inverse_of: :entry, dependent: :delete_all

    validates :date, :equipment, presence: true
    validates :shipping_mode, presence: true, if: :horse_needs_shipping
    validates :date, comparison: { greater_than_or_equal_to: -> { Date.current } }
    validates :post_parade, numericality: { only_integer: true,
                                            greater_than_or_equal_to: 0,
                                            less_than_or_equal_to: 14 }
    validates :weight, numericality: { only_integer: true }
    validates :racing_style, inclusion: { in: Config::Racing.styles }, allow_nil: true
    validates :horse_id, uniqueness: { scope: :date }
    validates :jockey_id, uniqueness: { scope: :race_id }, allow_nil: true
    validates :first_jockey, presence: true, if: :second_jockey
    validates :second_jockey, presence: true, if: :third_jockey
    validates :second_jockey_id, uniqueness: { scope: [:horse_id, :first_jockey_id, :third_jockey_id] }
    validates :third_jockey_id, uniqueness: { scope: [:horse_id, :first_jockey_id, :second_jockey_id] }

    scope :future, -> { where("date > ?", Date.current) }
    scope :past, -> { where(date: ...Date.current) }
    scope :ordered_by_name, -> { joins(:horse).merge(Horses::Horse.order_by_name) }
    scope :needs_pre_race, -> { where("(post_parade = 0 OR weight = 0 OR jockey_id IS NULL OR odd_id IS NULL)") }

    counter_culture :race, column_name: "entries_count"

    def store_initial_options
      self.date = race&.date
      return unless horse

      options = horse.race_options
      self.first_jockey = options&.first_jockey
      self.second_jockey = options&.second_jockey
      self.third_jockey = options&.third_jockey
      self.equipment = options&.equipment
      self.racing_style = options&.racing_style
    end

    private

    def horse_needs_shipping
      return false if persisted?
      return false unless horse

      horse.race_metadata.racetrack != race.racetrack
    end
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

