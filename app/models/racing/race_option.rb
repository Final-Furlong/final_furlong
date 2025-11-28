module Racing
  class RaceOption < ApplicationRecord
    include Equipmentable

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :first_jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :second_jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :third_jockey, class_name: "Racing::Jockey", optional: true

    validates :minimum_distance, :maximum_distance,
      :calculated_maximum_distance, :calculated_minimum_distance, :equipment,
      presence: true
    validates :racehorse_type, inclusion: { in: Config::Racing.racehorse_types }
    validates :racing_style, inclusion: { in: Config::Racing.styles }, allow_blank: true
    validates :minimum_distance, numericality: { greater_than_or_equal_to: Config::Racing.minimum_distance, less_than_or_equal_to: Config::Racing.maximum_distance }
    validates :maximum_distance, numericality: { greater_than_or_equal_to: Config::Racing.minimum_distance, less_than_or_equal_to: Config::Racing.maximum_distance }
    validates :calculated_minimum_distance, numericality: { greater_than_or_equal_to: Config::Racing.minimum_distance, less_than_or_equal_to: Config::Racing.maximum_distance }
    validates :calculated_maximum_distance, numericality: { greater_than_or_equal_to: Config::Racing.minimum_distance, less_than_or_equal_to: Config::Racing.maximum_distance }
    validates :runs_on_dirt, :runs_on_turf, :trains_on_dirt, :trains_on_turf, :trains_on_jumps, inclusion: { in: [true, false] }
    validates :next_race_note_created_at, presence: true, if: :note_for_next_race
    validates :first_jockey, presence: true, if: :second_jockey
    validates :second_jockey, comparison: { other_than: :first_jockey }, if: :first_jockey
    validates :second_jockey, presence: true, if: :third_jockey
    validates :third_jockey, comparison: { other_than: :second_jockey }, if: :second_jockey
    validates :second_jockey_id, uniqueness: { scope: [:horse_id, :first_jockey_id, :third_jockey_id] }
    validates :third_jockey_id, uniqueness: { scope: [:horse_id, :first_jockey_id, :second_jockey_id] }

    scope :flat, -> { where(racehorse_type: "flat") }
    scope :jump, -> { where(racehorse_type: "jump") }
    scope :distance_matching, ->(distance) { where("minimum_distance <= :num AND maximum_distance >= :num", { num: distance }) }
    scope :dirt, -> { where(runs_on_dirt: true) }
    scope :turf, -> { where(runs_on_turf: true) }
    scope :steeplechase, -> {}

    def jockeys_list
      jockeys = Racing::Jockey.order(last_name: :asc, first_name: :asc).all
      priority_list, other_jockeys = jockeys.partition { |jockey| chosen_jockeys.include? jockey }
      priority_list = priority_list.map { |jockey| [jockey.full_name, jockey.id] }
      other_jockeys = other_jockeys.map { |jockey| [jockey.full_name, jockey.id] }
      priority_list + other_jockeys
    end

    def chosen_jockeys
      [first_jockey, second_jockey, third_jockey]
    end

    def options_for_style_select
      Config::Racing.styles.map do |style|
        [I18n.t("racing.style.#{style}"), style]
      end
    end

    def options_for_jockey_select(type)
      Racing::Jockey.active.send(type.to_sym).ordered_by_name.all.map do |jockey|
        [jockey.full_name, jockey.id]
      end
    end

    def options_for_distance_select
      Racing::RaceSchedule.select(:distance).order(distance: :asc).distinct.map do |race|
        [I18n.t("racing.distance_furlongs", value: race.distance), race.distance]
      end
    end
  end
end

# == Schema Information
#
# Table name: race_options
# Database name: primary
#
#  id                                             :bigint           not null, primary key
#  calculated_maximum_distance                    :decimal(3, 1)    default(5.0), not null, indexed
#  calculated_minimum_distance                    :decimal(3, 1)    default(24.0), not null, indexed
#  equipment                                      :integer          default(0), not null
#  maximum_distance                               :decimal(3, 1)    default(24.0), not null, indexed
#  minimum_distance                               :decimal(3, 1)    default(5.0), not null, indexed
#  next_race_note_created_at                      :datetime         indexed
#  note_for_next_race                             :text
#  racehorse_type(flat,jump)                      :enum             indexed
#  racing_style(leading,off_pace,midpack,closing) :enum             indexed
#  runs_on_dirt                                   :boolean          default(TRUE), not null
#  runs_on_turf                                   :boolean          default(TRUE), not null
#  trains_on_dirt                                 :boolean          default(TRUE), not null
#  trains_on_jumps                                :boolean          default(FALSE), not null
#  trains_on_turf                                 :boolean          default(TRUE), not null
#  created_at                                     :datetime         not null
#  updated_at                                     :datetime         not null
#  first_jockey_id                                :bigint           uniquely indexed => [horse_id, second_jockey_id, third_jockey_id], indexed
#  horse_id                                       :bigint           not null, uniquely indexed => [first_jockey_id, second_jockey_id, third_jockey_id], uniquely indexed
#  second_jockey_id                               :bigint           uniquely indexed => [horse_id, first_jockey_id, third_jockey_id], indexed
#  third_jockey_id                                :bigint           uniquely indexed => [horse_id, first_jockey_id, second_jockey_id], indexed
#
# Indexes
#
#  idx_on_horse_id_first_jockey_id_second_jockey_id_th_b7c0ac41cd  (horse_id,first_jockey_id,second_jockey_id,third_jockey_id) UNIQUE
#  index_race_options_on_calculated_maximum_distance               (calculated_maximum_distance)
#  index_race_options_on_calculated_minimum_distance               (calculated_minimum_distance)
#  index_race_options_on_first_jockey_id                           (first_jockey_id)
#  index_race_options_on_horse_id                                  (horse_id) UNIQUE
#  index_race_options_on_maximum_distance                          (maximum_distance)
#  index_race_options_on_minimum_distance                          (minimum_distance)
#  index_race_options_on_next_race_note_created_at                 (next_race_note_created_at)
#  index_race_options_on_racehorse_type                            (racehorse_type)
#  index_race_options_on_racing_style                              (racing_style)
#  index_race_options_on_second_jockey_id                          (second_jockey_id)
#  index_race_options_on_third_jockey_id                           (third_jockey_id)
#
# Foreign Keys
#
#  fk_rails_...  (first_jockey_id => jockeys.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (second_jockey_id => jockeys.id)
#  fk_rails_...  (third_jockey_id => jockeys.id)
#

